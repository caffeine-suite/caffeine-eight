{defineModule} = require 'art-foundation'

defineModule module, -> class IndentBlocks
  blockStartRegExp = /\n( +)/y

  @ruleProps:
    parse: (parentNode) ->
      {nextOffset, source} = parentNode
      blockStartRegExp.lastIndex = nextOffset
      if match = blockStartRegExp.exec source
        [_, indent] = match
        length = indent.length
        linesRegexp = ///(\n#{indent}[^\n]*)+///y
        linesRegexp.lastIndex = nextOffset
        [match] = linesRegexp.exec source
        lines = (line.slice length for line in match.split("\n").slice 1)

        if p = parentNode.parser.class.parse lines.join "\n"
          p.offset = nextOffset
          p.matchLength = match.length
          p
