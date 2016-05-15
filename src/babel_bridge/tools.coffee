Foundation = require 'art-foundation'
{peek} = Foundation

module.exports = class Tools
  @getLineColumn: (string, offset)->
    return line:1, column:1 if string.length==0 || offset==0

    lines = (string.slice(0,offset-1) + " ").split "\n"

    line:   lines.length
    column: peek(lines).length
