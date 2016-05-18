Foundation = require 'art-foundation'
{peek, log, push, compactFlatten} = Foundation
EmptyOptionalNode = require './empty_optional_node'

module.exports = class RuleNode extends require './node'
  constructor: ->
    super
    @_lastMatch = null
    @_matches = null
    @_nextOffset = @offset

  @setter "matches"
  @getter "allMatches",
    matches: -> @_matches ||= []
    plainObjects: ->
      [@class.getName()].concat (match.plainObjects for match in @matches)

  ###
  IN: match - instanceof Node
  OUT: true if match was added
  ###
  addMatch: (label, match) ->
    return false unless match

    match._parent = @
    @parser._addToMatchedNodeList match

    @_matches = push @_matches, @_lastMatch = match
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
    pluralLabel = @parser.pluralize label
    {matches} = @
    @[pluralLabel] = push @[pluralLabel], match unless @__proto__[pluralLabel]

  # keep most recent match directly as node property
  # IFF the prototype doesn't already have a property of that name
  _bindToSingleLabels: (label, match) ->
    @[label] = match unless @__proto__[label]
