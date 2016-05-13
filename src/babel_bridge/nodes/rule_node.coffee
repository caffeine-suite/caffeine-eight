Foundation = require 'art-foundation'
{peek} = Foundation

module.exports = class RuleNode extends require './node'
  constructor: ->
    super
    @_matches = null
    @_matchLength = 0

  @getter "matchLength",
    matches: -> @_matches ||= []
    lastMatch: -> peek @_matches

  addMatch: (name, match) ->
    return unless match
    return match if match == @

    @matches.push match
    @_updateMatchLength()

    @addMatchName match, name if name

    match

  addMatchName: (match, name) ->

  ##################
  # PRIVATE
  ##################
  _updateMatchLength: ->
    @_matchLength = @lastMatch?.getNextOffset() - @offset || 0
