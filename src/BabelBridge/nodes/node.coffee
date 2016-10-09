Foundation = require 'art-foundation'
{peek, log, push, compactFlatten, BaseObject, isPlainArray, isPlainObject, inspectedObjectLiteral, merge, mergeInto} = Foundation
Nodes = require './namespace'

module.exports = class Node extends BaseObject
  constructor: (@_parent, options) ->
    super
    {@_parser} = @_parent
    {@offset, @matchLength, @ruleVariant} = options if options
    @_offset ?= @_parent.getNextOffset()
    @_matchLength ||= 0
    @_lastMatch = null
    @_label = null
    @_pluralLabel = null
    @_matches = null

  @createSubclass: (options) ->
    class NodeSubclass extends @
      @_name = @prototype._name = options.name if options.name
      if options.ruleVarient
        @ruleVarient = options.ruleVarient
        @rule = @ruleVariant.rule
      mergeInto @prototype, options

  toString: -> @text

  @setter "matches offset matchLength ruleVariant"
  @getter "parent parser offset matchLength, label pluralLabel",
    name: -> @_name || @ruleName || @class.getName()
    present: -> @_matchLength > 0
    matches: -> @_matches ||= []
    source: -> @_parser.source
    isRoot: -> @_parser == @_parent
    nextOffset: -> @offset + @matchLength
    text: ->
      {matchLength, offset, source} = @
      if matchLength == 0 then "" else source.slice offset, offset + matchLength

    subparseText: ->
      {matchLength, offset, source} = @subparse
      if matchLength == 0 then "" else source.slice offset, offset + matchLength

    ruleVariant: -> @_ruleVariant || @_parent?.ruleVariant
    ruleName: -> @class.rule?.getName() || @_ruleVariant.rule.getName()

    isRuleNode: -> @class.rule

    isPassThrough: -> @ruleVariant?.isPassThrough
    nonPassThrough: -> !@ruleVariant?.isPassThrough

  # inspectors
  @getter
    parseTreePath: -> compactFlatten [@parent?.parseTreePath, @class.getName()]

    presentMatches: ->
      @_presentMatches ||= (m for m in @matches when m.getPresent?())

    inspectedObjects: ->
      match = @
      matches = @presentMatches
      if matches.length > 0

        path = []
        while matches.length == 1 && matches[0].matches?.length > 0
          path.push match.ruleName
          [match] = matches
          matches = match.presentMatches

        {label, ruleName} = match

        path = path[0] if path.length == 1

        children = for match in matches
          match.inspectedObjects

        parts = compactFlatten [
          path: path if path.length > 0
          label: label if label && label != ruleName
          if children.length > 0
            children
          else
            match.toString()
        ]
        parts = parts[0] if parts.length == 1
        ret = {}
        ret[ruleName] = parts


        ret
      else
        source: text: @text, offset: @offset, length: @matchLength #, offset: @offset, length: @matchLength

    detailedInspectedObjects: ->
      {matches} = @
      if matches.length > 0

        children = for match in matches
          match.detailedInspectedObjects

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
    match._label = label
    match._pluralLabel = @parser.pluralize label

    @_matches = push @_matches, @_lastMatch = match
    if label && match.class != Nodes.EmptyOptionalNode
      @_bindToLabelLists match
      @_bindToSingleLabels match

    @_matchLength = match.nextOffset - @offset
    true

  #################
  # PRIVATE
  #################

  # add to appropriate list in @matches
  # TODO: I'll bet this slows things down, generating the pluralLabel EVERY TIME
  _bindToLabelLists: (match) ->
    {pluralLabel} = match
    {matches} = @
    @[pluralLabel] = push @[pluralLabel], match unless @__proto__[pluralLabel]

  # keep most recent match directly as node property
  # IFF the prototype doesn't already have a property of that name
  _bindToSingleLabels: (match) ->
    {label} = match
    @[label] = match unless @__proto__[label]
