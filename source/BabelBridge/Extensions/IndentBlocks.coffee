{array, defineModule, log, merge, escapeJavascriptString, find} = require 'art-foundation'
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

      # log {subsource, sourceOffset}

      matchLength:  rawSubsource.length
      sourceMap: if returnRawMatch
        (suboffset) -> suboffset + sourceOffset
      else (suboffset) ->
        subsourceToParentSourceMap ||= computeSubsourceToParentSourceMap sourceOffset, replaceRegExp, indent, rawSubsource
        bestMapEntry = find subsourceToParentSourceMap, (entry) ->
          entry if suboffset < entry.subsourceEndOffset

        # log sourceMap: {
        #   source
        #   sourceLenght: source.length
        #   rawSubsource: rawSubsource
        #   rawSubsourceLength: rawSubsource.length
        #   sourceEndOffset: sourceOffset + rawSubsource.length
        #   subsource
        #   subsourceLength: subsource.length
        #   sourceOffset
        #   subsourceToParentSourceMap: array subsourceToParentSourceMap, (m) ->
        #     merge m,
        #       sourceSlice: source.slice m.sourceOffset, m.sourceEndOffset
        #       subsourceSlice: subsource.slice m.subsourceOffset, m.subsourceEndOffset
        #   mapInputs: {
        #     suboffset
        #     bestMapEntry
        #   }
        #   mapResult:
        #     offset: finalOffset = suboffset + bestMapEntry.toSourceDelta
        #     here: source.slice(0, finalOffset) + "<here>" + source.slice(finalOffset, source.length)
        # }

        suboffset + bestMapEntry.toSourceDelta

      subsource: subsource

  computeSubsourceToParentSourceMap = (sourceBaseOffset, replaceRegExp, indent, rawSubsource)->
      indentLength = indent.length
      indentWithNewLineLength = indentLength + 1
      indexes = [
      ]
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

  @matchToEolAndBlock: matchToEolAndBlock = (source, offset) ->
    toEolContent.lastIndex = offset

    eolMatch = toEolContent.exec source
    return matchBlock source, offset unless eolMatch

    [sourceMatched, spaces] = eolMatch
    matchLength = sourceMatched.length

    if blockMatch = matchBlock source, offset + matchLength, true
      matchLength += blockMatch.matchLength

    subsource:    source.slice offset + spaces.length, offset + matchLength
    matchLength:  matchLength

  @getParseFunction: (matcher, subparseOptions) ->
    parse: (parentNode) ->
      {nextOffset:offset, source} = parentNode
      if block = matcher source, offset
        {subsource, matchLength, sourceMap} = block

        parentNode.subparse subsource, merge subparseOptions,
          originalOffset:       offset
          originalMatchLength:  matchLength
          sourceMap:            sourceMap

  @getPropsToSubparseBlock: (subparseOptions = {}) => @getParseFunction @matchBlock, subparseOptions
  @getPropsToSubparseToEolAndBlock: (subparseOptions = {}) => @getParseFunction @matchToEolAndBlock, subparseOptions
