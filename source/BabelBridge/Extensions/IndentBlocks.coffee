{defineModule, log, merge, escapeJavascriptString, find} = require 'art-foundation'
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

      replaceRegExp = ///\n#{indent}///g
      replaceWith = "\n"

      # generated on demand, but then cached for future sourceMap calls.
      subsourceToParentSourceMap = null

      subsource = if returnRawMatch then rawSubsource
      else rawSubsource.replace replaceRegExp, replaceWith

      matchLength:  rawSubsource.length
      sourceMap: (suboffset) ->
        subsourceToParentSourceMap ||= computeSubsourceToParentSourceMap sourceOffset, replaceRegExp, replaceWith, indent, rawSubsource
        bestMapEntry = find subsourceToParentSourceMap, (entry) ->
          entry if suboffset < entry.subsourceEndOffset

        suboffset + bestMapEntry.toSourceDelta

      subsource: subsource

  computeSubsourceToParentSourceMap = (sourceBaseOffset, replaceRegExp, replaceWith, indent, rawSubsource)->
      indentLength = indent.length
      indentWithNewLineLength = indentLength + 1
      indexes = [
      ]
      sourceOffset = toSourceDelta = sourceBaseOffset
      subsourceOffset = subsourceEndOffset = 0
      replaceWithLength = replaceWith.length
      while match = replaceRegExp.exec rawSubsource

        removedLength = match[0].length
        sourceEndOffset     = match.index + sourceBaseOffset + removedLength
        subsourceEndOffset  += sourceEndOffset - sourceOffset - removedLength + replaceWithLength

        indexes.push {
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
      subsourceEndOffset  = sourceEndOffset = sourceOffset

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
