{array, defineModule, log, merge, escapeJavascriptString, find} = require 'art-standard-lib'
{Node} = require '../Nodes'

defineModule module, -> class IndentBlocks
  blockStartRegExp = /\n(?: *\n)*( +)(?=$|[^ \n])/y
  toEolContent = /(\ *)((?:\ *[^ \n]+)+)\ */y
  blockLinesRegExp = (indent) -> ///
    (
      (?:\s*\n)
      (?:#{indent}\ *[^\n\ ][^\n]*)
    )+
    ///y

  ###
  TODO:
    for matchBlock and matchToEolAndBlock

    We also need a source-offset mapper from the new source back to the old-source.

    I think the map should just be part of the returned object
  ###

  @matchBlock: matchBlock = (source, sourceOffset, returnRawMatch = false) ->
    blockStartRegExp.lastIndex = sourceOffset

    if match = blockStartRegExp.exec source
      [__, indent] = match
      length = indent.length
      linesRegExp = blockLinesRegExp indent
      linesRegExp.lastIndex = sourceOffset
      [rawSubsource] = linesRegExp.exec source

      replaceRegExp = ///(?:^\n#{indent})|(\n)(?:#{indent})///g
      replaceWith = "$1"

      # generated on demand, but then cached for future sourceMap calls.
      subsourceToParentSourceMap = null

      subsource = if returnRawMatch then rawSubsource
      else rawSubsource.replace replaceRegExp, "$1"

      matchLength:  rawSubsource.length
      subsource:    subsource
      sourceMap:
        if returnRawMatch
          (suboffset) -> suboffset + sourceOffset
        else (suboffset) ->
          subsourceToParentSourceMap ||= computeSubsourceToParentSourceMap sourceOffset, replaceRegExp, indent, rawSubsource
          bestMapEntry = find subsourceToParentSourceMap, (entry) ->
            entry if suboffset < entry.subsourceEndOffset

          unless bestMapEntry
            log bestMapEntryNotFound: {source, rawSubsource, subsourceToParentSourceMap, suboffset, sourceLength: source.length, rawSubsourceLength: rawSubsource.length, sourceOffset, indent}
            throw new Error "error getting source location from subparse sourceMap"

          suboffset + bestMapEntry.toSourceDelta

  computeSubsourceToParentSourceMap = (sourceBaseOffset, replaceRegExp, indent, rawSubsource)->
      indentLength = indent.length
      indentWithNewLineLength = indentLength + 1
      indexes = []
      sourceOffset = toSourceDelta = sourceBaseOffset
      subsourceOffset = subsourceEndOffset = 0
      while match = replaceRegExp.exec rawSubsource

        matchLength = match[0].length
        keptLength = match[1]?.length || 0
        removedLength = matchLength - keptLength
        sourceEndOffset     = match.index + sourceBaseOffset + matchLength
        subsourceEndOffset  += sourceEndOffset - sourceOffset - removedLength

        indexes.push {
          keptLength
          removedLength
          sourceOffset
          subsourceOffset
          toSourceDelta
          sourceEndOffset
          subsourceEndOffset
        }

        toSourceDelta += removedLength

        sourceOffset = sourceEndOffset
        subsourceOffset = subsourceEndOffset

      sourceEndOffset     = sourceBaseOffset + rawSubsource.length
      subsourceEndOffset  = sourceEndOffset - sourceOffset + sourceOffset

      indexes.push {
        sourceOffset
        subsourceOffset
        toSourceDelta
        sourceEndOffset
        subsourceEndOffset
      }

      indexes

  # I think this is actually matchToEolOrBlock - one or the other
  @matchToEolAndBlock: matchToEolAndBlock = (source, offset) ->
    toEolContent.lastIndex = offset
    if eolMatch = toEolContent.exec source

      [sourceMatched, spaces] = eolMatch
      matchLength = sourceMatched.length

      if blockMatch = matchBlock source, offset + matchLength, true
        matchLength += blockMatch.matchLength

      subsource:    source.slice offset + spaces.length, offset + matchLength
      sourceMap:    (suboffset) -> offset + spaces.length + suboffset
      matchLength:  matchLength

    else
      matchBlock source, offset

  @matchToEol: matchToEol = (source, offset) ->
    toEolContent.lastIndex = offset
    if eolMatch = toEolContent.exec source

      [sourceMatched, spaces] = eolMatch
      matchLength = sourceMatched.length

      if blockMatch = matchBlock source, offset + matchLength, true
        matchLength += blockMatch.matchLength

      subsource:    source.slice offset + spaces.length, offset + matchLength
      sourceMap:    (suboffset) -> offset + spaces.length + suboffset
      matchLength:  matchLength

  @getParseFunction: (matcher, subparseOptions) ->
    parse:
      # for debugging
      if subparseOptions.verbose
        (parentNode) ->
          {nextOffset:offset, source} = parentNode
          log IndentBlocks_parse_verbose_matcher_attempt: {source, offset}

          if block = matcher source, offset
            {subsource, matchLength, sourceMap} = block

            log IndentBlocks_parse_verbose_matcher_matched: {subsource, matchLength}

            parsed = parentNode.subparse subsource, merge subparseOptions,
              originalOffset:       offset
              originalMatchLength:  matchLength
              sourceMap:            sourceMap

            log IndentBlocks_parse_verbose_matcher_subparse: {subparseOptions, parsed}
            parsed
      else
        (parentNode) ->
          {nextOffset:offset, source} = parentNode

          if block = matcher source, offset
            {subsource, matchLength, sourceMap} = block

            parentNode.subparse subsource, merge subparseOptions,
              originalOffset:       offset
              originalMatchLength:  matchLength
              sourceMap:            sourceMap

  @getPropsToSubparseToEol: (subparseOptions = {}) => @getParseFunction @matchToEol, subparseOptions

  @getPropsToSubparseBlock: (subparseOptions = {}) => @getParseFunction @matchBlock, subparseOptions
  @getPropsToSubparseToEolAndBlock: (subparseOptions = {}) => @getParseFunction @matchToEolAndBlock, subparseOptions
