Foundation = require 'art-foundation'
{peek, log, push, compactFlatten, BaseObject} = Foundation
Nodes = require './namespace'

module.exports = class Node extends BaseObject
  constructor: (@_parent, @_offset = @_parent.getNextOffset(), @_matchLength = 0) ->
    super
    {@_parser} = @_parent
    @_lastMatch = null
    @_matches = null

  @setter "matches"
  @getter
    matches: -> @_matches ||= []

  @getter "parent parser offset matchLength"
  @getter
    text: -> if @matchLength == 0 then "" else @source.slice @_offset, @_offset + @matchLength
    source: -> @_parser.source
    nextOffset: -> @offset + @matchLength
    plainObjects: ->
      ret = [@class.getName()]
      if @_matches?.length > 0
        ret = ret.concat (match.plainObjects for match in @matches)
      else
        ret = text: @text, offset: @offset, length: @matchLength
      ret

  ###
  IN: match - instanceof Node
  OUT: true if match was added
  ###
  addMatch: (label, match) ->
    return false unless match

    match._parent = @

    @_matches = push @_matches, @_lastMatch = match
    if label && match.class != Nodes.EmptyOptionalNode
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
