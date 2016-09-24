{defineModule, log} = require 'art-foundation'

defineModule module, -> class IndentBlocks
  blockStartRegExp = /\n(?: *\n)*( +)(?=[^ \n])/y

  @ruleProps:
    parse: (parentNode) ->
      {nextOffset, source} = parentNode
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

        if p = parentNode.parser.class.parse indentedCode.replace(///\n#{indent}///g, "\n").slice 1
          p.offset = nextOffset
          p.matchLength = indentedCode.length
          p
