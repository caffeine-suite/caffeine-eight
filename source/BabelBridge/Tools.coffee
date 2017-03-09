{peek} = require 'art-standard-lib'

module.exports = class Tools
  @getLineColumn: getLineColumn =(string, offset)->
    return line:1, column:1 if string.length==0 || offset==0

    lines = (string.slice(0, offset) ).split "\n"

    line:   lines.length
    column: peek(lines).length + 1

  @getLineColumnString: (string, offset) ->
    {line, column} = getLineColumn string, offset
    "#{line}:#{column}"
