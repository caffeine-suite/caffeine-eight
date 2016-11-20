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
    @_pattern = null
    @_nonMatch = false

  @createSubclass: (options) ->
    class NodeSubclass extends @
      @_name = @prototype._name = options.name if options.name
      if options.ruleVarient
        @ruleVarient = options.ruleVarient
        @rule = @ruleVariant.rule
      mergeInto @prototype, objectWithout options, "getter"
      @getter options.getter if options.getter

  toString: -> @text

  @setter "matches offset matchLength ruleVariant pattern"
  @getter "
    parent parser offset matchLength
    label pluralLabel ruleName pluralRuleName pattern nonMatch
    ",
    name: -> @_name || @ruleName || @class.getName()
    present: -> @_matchLength > 0 || @_nonMatch
    matches: -> @_matches ||= []
    source: -> @_parser.source
    isRoot: -> @_parser == @_parent
    ancestors: (into = [])->
      @parent.getAncestors into
      into.push @
      into

    parseInfo: ->
      if @subparseInfo
        "subparse:#{@ruleName}:#{@offset}"
      else
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
    ruleName: ->
      @class.rule?.getName() || @_ruleVariant?.rule.getName() || @parent?.ruleName || "#{@pattern || 'no rule'}"

    isRuleNode: -> @class.rule

    isPassThrough: -> @ruleVariant?.isPassThrough
    nonPassThrough: -> !@ruleVariant?.isPassThrough

  # get substring from source starting at nextOffset of the specified length
  getNextText: (length)->
    {nextOffset} = @
    @source.slice nextOffset, nextOffset + length

  formattedInspect: ->
    "CUSTOM"

  # inspectors
  @getter
    parseTreePath: -> compactFlatten [@parent?.parseTreePath, @class.getName()]

    presentMatches: ->
      m for m in @matches when m.getPresent?()

    isNonMatch: -> !!@nonMatch
    isPartialMatch: ->
      return false unless @nonMatch
      return true for match in @presentMatches when !match.nonMatch

      false

    isMatch: -> !@nonMatch

    nonMatchingLeaf: ->
      @nonMatch && @matches.length == 1 && @matches[0]

    firstPartialMatchParent: ->
      # throw new Error unless @isNonMatch
      if @parent == @parser || @isPartialMatch
        @
      else
        @parent.firstPartialMatchParent

    inspectedObjects: ->
      match = @
      matches = @presentMatches
      if matches.length > 0

        path = []
        while matches.length == 1 && matches[0].matches?.length > 0
          path.push "#{if match.label then "#{match.label}:" else ""}#{match.ruleName}"
          [match] = matches
          matches = match.presentMatches

        {label, ruleName, nonMatch} = match

        path = if path.length == 1
          path[0]
        else
          path.join " > "

        hasOneOrMoreMatchingChildren = false
        children = for match in matches
          hasOneOrMoreMatchingChildren = true unless match.nonMatch
          match.inspectedObjects

        parts = compactFlatten [
          if path.length > 0   then path: path
          if label             then label: label
          if children.length > 0
            children
          else
            match.toString()
        ]
        parts = parts[0] if parts.length == 1
        ret = "#{
          if nonMatch
            if hasOneOrMoreMatchingChildren
              'partialMatch-'
            else 'nonMatch-'
          else
            ''
          }#{ruleName}": parts

        # ret = nonMatch: ret if nonMatch


        ret
      else if @nonMatch
        nonMatch: offset: @offset, pattern: "#{@pattern?.pattern}"
      else
        token: offset: @offset, length: @matchLength, text: @text, pattern: "#{@pattern?.pattern}", class: @class.getName(), ruleName: @ruleName

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

    match._parent = @

    if pattern
      {label, ruleName} = pattern
      match._pattern        = pattern
      match._label          = label
      match._ruleName       = ruleName

    match._pluralLabel    = pluralLabel    = @parser.pluralize label    if label
    match._pluralRuleName = pluralRuleName = @parser.pluralize ruleName if ruleName

    label       ||= ruleName
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

  _addNonMatch: (node) ->
    (@_nonMatches ||= []).push node

  # returns the first parent-node which is a match
  # TODO: I'd like inspectedObjects to distinguish between partialMatches and nonMatches
  #  a partialMatch is any non-leaf...
  _addToParentAsNonMatch: ->
    @_matchLength = 1 if @_matchLength == 0
    if @parent
      if @parent.matches
        unless 0 <= @parent.matches.indexOf @
          @_nonMatch = true
          @parent.matches.push @
          @parent._presentMatches = null
          @parent._matchLength = 1 if @parent._matchLength == 0
        @parent._addToParentAsNonMatch()
      else
        @

    else
      @
