Foundation = require 'art-foundation'
{BaseObject} = Foundation

module.exports = class Node extends BaseObject
  constructor: (@_parent) ->
    {@_parser} = @_parent
    @_offset = @_parent.getNextOffset()
    @_matchLength = 0

  @getter "parent parser offset matchLength"
  @getter
    text: -> if @matchLength == 0 then "" else @source.slice @_offset, @_offset + @matchLength
    source: -> @_parser.source
    nextOffset: -> @offset + @matchLength
