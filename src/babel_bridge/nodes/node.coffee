Foundation = require 'art-foundation'
{peek, log, push, compactFlatten, BaseObject, inspectedObjectLiteral, merge, mergeInto} = Foundation
Nodes = require './namespace'

module.exports = class Node extends BaseObject
  constructor: (@_parent, options) ->
    super
    {@_parser} = @_parent
    {@offset, @matchLength, @ruleVariant} = options if options
    @_offset ?= @_parent.getNextOffset()
    @_matchLength ||= 0
    @_lastMatch = null
    @_matches = null

  @createSubClass: (options) ->
    class NodeSubClass extends @
      @_name = @prototype._name = options.name if options.name
      @ruleVarient = options.ruleVarient if options.ruleVarient
      @rule = options.rule if options.rule
      mergeInto @prototype, options

  toString: -> @text

  @setter "matches offset matchLength ruleVariant"
  @getter "parent parser offset matchLength",
    name: -> @_name || @ruleName || @class.getName()
    present: -> true
    matches: -> @_matches ||= []
    source: -> @_parser.source
    nextOffset: -> @offset + @matchLength
    text: -> if @matchLength == 0 then "" else @source.slice @_offset, @_offset + @matchLength

    ruleVariant: -> @_ruleVariant || @_parent?.ruleVariant
    ruleName: -> @class.rule?.getName()

    isRuleNode: -> @class.rule

    isPassThrough: -> @ruleVariant?.isPassThrough
    nonPassThrough: -> !@ruleVariant?.isPassThrough

  # inspectors
  @getter
    parseTreePath: -> compactFlatten [@parent?.parseTreePath, @class.getName()]

    presentMatches: ->
      @_presentMatches ||= (m for m in @matches when m.getPresent?())

    simplifiedInspectedObjects: ->
      matches = @presentMatches
      if matches.length == 1 && matches[0].presentMatches.length > 0
        matches[0].simplifiedInspectedObjects
      else if matches.length > 0
        children = for match in matches
          match.simplifiedInspectedObjects

        ret = {}
        ret[@name] = if children.length == 1
          children[0]
        else
          children

        ret
      else
        @text #, offset: @offset, length: @matchLength

    inspectedObjects: ->
      m = @_matches || []
      if m.length > 0

        children = for match in matches
          match.inspectedObjects

        ret = {}
        ret[@name] = if children.length == 1
          children[0]
        else
          children

        ret
      else
        @text #, offset: @offset, length: @matchLength

    plainObjects: ->
      ret = [{inspect:=>@class.getName()}]
      if @_matches?.length > 0
        ret = ret.concat (match.getPlainObjects() for match in @matches)
      else
        ret = @text #, offset: @offset, length: @matchLength
      ret

  find: (searchName, out = []) ->
    for m in @matches
      if m.getName() == searchName
        out.push m
      else
        m.find searchName, out
    out

  subparse: (subSource, options) ->
    @_parser.subparse subSource, merge options, parentNode: @

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
