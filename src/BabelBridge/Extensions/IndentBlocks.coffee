{defineModule, log, merge, escapeJavascriptString} = require 'art-foundation'
{Node} = require '../nodes'

defineModule module, -> class IndentBlocks
  blockStartRegExp = /\n(?: *\n)*( +)(?=$|[^ \n])/y
  toEolContent = /(\ *)((?:\ *[^ \n]+)+)\ */y
  blockLinesRegExp = (indent) -> ///
    (
      (?:\s*\n)
      (?:#{indent}\ *[^\n\ ][^\n]*)
    )+
    ///y

  @matchBlock: matchBlock = (source, offset, returnRawMatch = false) ->
    blockStartRegExp.lastIndex = offset

    if match = blockStartRegExp.exec source
      [__, indent] = match
      length = indent.length
      linesRegExp = blockLinesRegExp indent
      linesRegExp.lastIndex = offset
      [indentedCode] = match = linesRegExp.exec source

      matchLength:  indentedCode.length
      subsource:
        if returnRawMatch then indentedCode
        else indentedCode.replace(///\n#{indent}///g, "\n").slice 1

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
        {subsource, matchLength} = block

        parentNode.subparse subsource, merge subparseOptions,
          originalOffset:       offset
          originalMatchLength:  matchLength

  @getPropsToSubparseBlock: (subparseOptions = {}) => @getParseFunction @matchBlock, subparseOptions
  @getPropsToSubparseToEolAndBlock: (subparseOptions = {}) => @getParseFunction @matchToEolAndBlock, subparseOptions
