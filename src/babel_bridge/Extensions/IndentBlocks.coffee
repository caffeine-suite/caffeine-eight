{defineModule, log} = require 'art-foundation'
{Node} = require '../nodes'

defineModule module, -> class IndentBlocks
  blockStartRegExp = /\n(?: *\n)*( +)(?=[^ \n])/y

  @matchBlock: matchBlock = ({nextOffset, source}) ->
    blockStartRegExp.lastIndex = nextOffset

    if match = blockStartRegExp.exec source
      [__, indent] = match
      length = indent.length
      linesRegexp = ///
        (
          (?:\s*\n)
          (?:#{indent}\ *[^\n\ ][^\n]*)
        )+
        ///y
      linesRegexp.lastIndex = nextOffset
      [indentedCode] = match = linesRegexp.exec source
      blockSource: indentedCode.replace(///\n#{indent}///g, "\n").slice 1
      originalSource: indentedCode
      matchLength: indentedCode.length
      offset: nextOffset
      nextOffset: nextOffset + indentedCode.length

  @ruleProps:
    parse: (parentNode) ->
      if block = matchBlock parentNode
        {blockSource, matchLength, offset} = block

        parentNode.subParse blockSource,
          originalOffset: offset
          originalMatchLength: matchLength

  @unparsedBlockRuleProps:
    parse: (parentNode) ->
      if block = matchBlock parentNode
        {blockSource, matchLength, offset} = block

        node = new Node parentNode,
          offset: offset
          matchLength: matchLength
        node.toString = -> blockSource
        node