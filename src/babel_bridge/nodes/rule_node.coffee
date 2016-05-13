Foundation = require 'art-foundation'
{peek, log} = Foundation

module.exports = class RuleNode extends require './node'
  constructor: ->
    super
    @_lastMatch = null
    @_allMatches = null
    @_matches = null
    @_match = null

  @getter
    match: -> @_match ||= {}
    matches: -> @_matches ||= {}
    allMatches: -> @_allMatches ||= []
    matchLength: -> @nextOffset - @offset
    nextOffset: -> @_lastMatch?.nextOffset || @offset

  addMatch: (label, match) ->
    return unless match

    @allMatches.push @_lastMatch = match
    @addLabeledMatch label, match

  addLabeledMatch: (label, match) ->
    if label && match.matchLength > 0
      (@matches[label] ||= []).push match
      @[label] = match unless @__proto__[label]
    match
