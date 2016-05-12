Foundation = require 'art-foundation'
{peek} = Foundation

module.exports = class NonTerminalNode extends require './node'
  constructor: ->
    super
    @_matches = null
    @_matchLength = 0

  @getter "matchLength",
    matches: -> @_matches ||= []
    lastMatch: -> peek @_matches

  addMatch: (node) ->
    return unless node # && !(node instanceof EmptyNode) && node != self
    @matches.push node
    @updateMatchLength()

  updateMatchLength: ->
    @_matchLength = @lastMatch?.getNextOffset() - @offset || 0
