Foundation = require 'art-foundation'
{BaseObject} = Foundation

module.exports = class Node extends BaseObject
  constructor: (@_parent) ->
    {@_parser} = @_parent
    @_offset = @_parent.getNextOffset()

  @getter "parent parser offset"
  @getter
    text: -> if @matchLength == 0 then "" else @source.slice @_offset, @_offset + @matchLength
    source: -> @_parser.source
    nextOffset: -> @_offset
