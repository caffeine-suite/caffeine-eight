Foundation = require 'art-foundation'
{BaseObject} = Foundation

module.exports = class Node extends BaseObject
  constructor: (@_parent) ->
    @_matchLength = 0
    {@_parser} = @_parent
    @_offset = @_parent.getNextOffset()

  @getter "parent parser offset"
  @getter
    text: -> if @_matchLength == 0 then "" else @source.slice @_offset, @_offset + @_matchLength
    source: -> @_parser.source
    nextOffset: -> @_offset + @_matchLength
