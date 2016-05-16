Foundation = require 'art-foundation'
Node = require './node'
{BaseObject, log} = Foundation

module.exports = class TerminalNode extends Node

  constructor: (_, offset, matchLength, pattern)->
    super
    @_offset = offset
    @_matchLength = matchLength
    @_pattern = pattern

  @getter "pattern",
    nextOffset: -> @_offset + @_matchLength
