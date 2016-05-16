Foundation = require 'art-foundation'
{peek, log, push} = Foundation
EmptyOptionalNode = require './empty_optional_node'

module.exports = class RuleNode extends require './node'
  constructor: ->
    super
    @_lastMatch = null
    @_allMatches = null
    @_matches = null
    @_nextOffset = @offset

  @getter "allMatches",
    matches: -> @_matches ||= {}

  ###
  IN: match - instanceof Node
  OUT: true if match was added
  ###
  addMatch: (label, match) ->
    return false unless match

    @parser._addToMatchedNodeList match

    @_allMatches = push @_allMatches, @_lastMatch = match
    if label && match.class != EmptyOptionalNode
      @_bindToLabelLists label, match
      @_bindToSingleLabels label, match

    @_matchLength = match.nextOffset - @offset
    true

  #################
  # PRIVATE
  #################

  # add to appropriate list in @matches
  _bindToLabelLists: (label, match) ->
    {matches} = @
    matches[label] = push matches[label], match

  # keep most recent match directly as node property
  # IFF the prototype doesn't already have a property of that name
  _bindToSingleLabels: (label, match) ->
    @[label] = match unless @__proto__[label]
