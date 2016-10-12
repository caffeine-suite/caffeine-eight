Foundation = require 'art-foundation'
{peek, log, push, compactFlatten, objectWithout, BaseObject, isPlainArray, isPlainObject, inspectedObjectLiteral, merge, mergeInto} = Foundation
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

    @_ruleName = null
    @_pluralRuleName = null
    @_label = null
    @_pluralLabel = null

  @createSubclass: (options) ->
    class NodeSubclass extends @
      @_name = @prototype._name = options.name if options.name
      if options.ruleVarient
        @ruleVarient = options.ruleVarient
        @rule = @ruleVariant.rule
      mergeInto @prototype, objectWithout options, "getter"
      @getter options.getter if options.getter

  toString: -> @text

  @setter "matches offset matchLength ruleVariant"
  @getter "parent parser offset matchLength, label pluralLabel ruleName pluralRuleName",
    name: -> @_name || @ruleName || @class.getName()
    present: -> @_matchLength > 0
    matches: -> @_matches ||= []
    source: -> @_parser.source
    isRoot: -> @_parser == @_parent
    ancestors: (into = [])->
      @parent.getAncestors into
      into.push @
      into

    parseInfo: ->
      "#{@ruleName}:#{@offset}"

    rulePath: ->
      ancestorRuleNames = for ancestor in @ancestors
        ancestor.parseInfo

      ancestorRuleNames.join " > "

    nextOffset: -> @offset + @matchLength
    text: ->
      {matchLength, offset, source} = @subparseInfo || @
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
          path.push "#{match.ruleName}#{if match.label then " label:#{match.label}" else ""}"
          [match] = matches
          matches = match.presentMatches

        {label, ruleName} = match

        path = path[0] if path.length == 1

        children = for match in matches
          match.inspectedObjects

        parts = compactFlatten [
          path: path if path.length > 0
          label: label if label
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
  IN: pattern, match - instanceof Node
  OUT: true if match was added
  ###
  addMatch: (pattern, match) ->
    return false unless match

    {label, ruleName} = pattern

    match._parent = @
    match._label = label
    match._ruleName = ruleName
    match._pluralLabel    = pluralLabel    = @parser.pluralize label    if label
    match._pluralRuleName = pluralRuleName = @parser.pluralize ruleName if ruleName

    label ||= ruleName
    pluralLabel ||= pluralRuleName

    @_matches = push @_matches, @_lastMatch = match
    if label && !(match instanceof Nodes.EmptyNode)
      @_bindToLabelLists    pluralLabel, match
      @_bindToSingleLabels  label, match

    @_matchLength = match.nextOffset - @offset
    true

  #################
  # PRIVATE
  #################

  # add to appropriate list in @matches
  # TODO: I'll bet this slows things down, generating the pluralLabel EVERY TIME
  _bindToLabelLists: (pluralLabel, match) ->
    @[pluralLabel] = push @[pluralLabel], match unless @__proto__[pluralLabel]

  # keep most recent match directly as node property
  # IFF the prototype doesn't already have a property of that name
  _bindToSingleLabels: (label, match) ->
    @[label] = match unless @__proto__[label]
