{
  arrayWith, array, peek, log, push, compactFlatten, objectWithout, isPlainArray, isPlainObject, inspectedObjectLiteral, merge, mergeInto
} = require 'art-standard-lib'
Nodes = require './namespace'

{BaseClass} = require 'art-class-system'

Stats = require '../Stats'

module.exports = class Node extends BaseClass
  constructor: (parent, options) ->
    super
    Stats.add "newNode"
    @_parent = parent
    {@_parser} = parent

    @_absoluteOffset = -1

    @_offset = (options?.offset ? @_parent.getNextOffset()) | 0
    if @_offset > @_parser.source.length
      throw new Error "bad offset #{@inspectedName} - offset:#{@_offset} > sourceLength:#{@_parser.source.length}"
    @_matchLength = 0

    @_ruleName = @_pluralRuleName =
    @_label = @_pluralLabel = @_pattern = @_nonMatches =
    @_ruleVariant = @_matches = @_matchPatterns = null

    @_labelsApplied =
    @_nonMatch = false

    if options
      @_matchLength   = (options.matchLength || 0) | 0
      @_ruleVariant   = options.ruleVariant
      @_matches       = options.matches
      @_matchPatterns = options.matchPatterns

  # provided so CaffineScript or other ES6-class-based systems can define their own class extension
  @_createSubclassBase: ->
    class NodeSubclass extends @

  @createSubclass: (options) ->
    klass = @_createSubclassBase()
    # class NodeSubclass extends @
    klass._name = klass.prototype._name = options.name if options.name
    if options.ruleVarient
      klass.ruleVarient = options.ruleVarient
      klass.rule = klass.ruleVariant.rule
    mergeInto klass.prototype, objectWithout options, "getter"
    klass.getter options.getter if options.getter

    klass

  toString: -> @text

  # SEE: SourceLineColumnMap#getLineColumn
  getSourceLineColumn: (into) -> @parser.getLineColumn @offset, into

  emptyArray = []
  @setter "matches offset matchLength ruleVariant pattern matchPatterns"
  @getter "
    parent parser offset matchLength
    matchPatterns
    label pluralLabel ruleName pluralRuleName pattern nonMatch
    ",
    realNode: -> @
    name: -> @_name || @ruleName || @class.getName()
    present: -> @_matchLength > 0 || @_nonMatch
    matches: -> @_matches ||= []
    source: -> @_parser.source
    isRoot: -> @_parser == @_parent
    hasMatches: -> @_matches?.length > 0
    absoluteOffset: ->
      if @_absoluteOffset >= 0
        @_absoluteOffset
      else
        # log "=== get absoluteOffset --- #{@inspectedName} --- #{@_offset}/#{@parser.source.length} --- subparsed: #{!!@parser.parentParser}"
        @_absoluteOffset = @_parser.offsetInRootParserSource @_offset

    ancestors: (into = [])->
      @parent.getAncestors into
      into.push @
      into

    sourceFile: -> @_parser.sourceFile

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
      @ruleNameOrNull || @parent?.ruleName || "#{@pattern || 'no rule'}"

    ruleNameOrNull: ->
      @class.rule?.getName() || @_ruleVariant?.rule.getName()

    ruleNameOrPattern: ->
      @ruleNameOrNull || "#{@pattern?.pattern || 'no rule'}"

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
      @nonMatch && (peek @matches) || @

    firstPartialMatchParent: ->
      # throw new Error unless @isNonMatch
      if @parent == @parser || @isPartialMatch
        @
      else
        @parent.firstPartialMatchParent

    inspectedName: -> "#{if l = @label then "#{l}:" else ""}#{@ruleName}"

    children: ->
      for match in @presentMatches when match.getPresent?() && !match.nonMatch
        match

    inspectedObjects: (verbose) ->
      match = @
      matches = @presentMatches
      if matches.length > 0

        path = []
        while matches.length == 1 && matches[0].matches?.length > 0
          path.push match.inspectedName
          [match] = matches
          matches = match.presentMatches

        {label, ruleName, nonMatch} = match

        path.push ruleName

        path = path.join '.'

        hasOneOrMoreMatchingChildren = false
        children = for match in matches
          hasOneOrMoreMatchingChildren = true unless match.nonMatch
          match.getInspectedObjects verbose

        parts = compactFlatten [
          # if path.length > 0   then path: path
          if label             then label: label
          {@offset, @absoluteOffset}
          if children.length > 0
            children
          else
            match.toString()
        ]
        parts = parts[0] if parts.length == 1
        "#{
          if nonMatch
            if hasOneOrMoreMatchingChildren
              'partialMatch-'
            else 'nonMatch-'
          else
            ''
          }#{path}": parts

        # ret = nonMatch: ret if nonMatch


        # ret
      else if @nonMatch
        nonMatch: merge {offset: @offset, @ruleName, pattern: "#{@pattern?.pattern ? @ruleVariant?.pattern}"}
        # nonMatch: offset: @offset, pattern: "#{@pattern?.pattern}"
      else

        if verbose
          token: offset: @offset, length: @matchLength, text: @text, pattern: "#{@pattern?.pattern}", class: @class.getName(), ruleName: @ruleName
        else
          @text

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

    @_matches       = push @_matches, match
    @_matchPatterns = push @_matchPatterns, pattern

    @_matchLength   = match.nextOffset - @offset

    true

  applyLabels: ->
    return if !@_matches || @_labelsApplied
    @_labelsApplied = true
    array @_matches, (match, i) =>
      pattern = @_matchPatterns[i]

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

      if label && !(match instanceof Nodes.EmptyNode)
        @_bindToLabelLists    pluralLabel, match
        @_bindToSingleLabels  label, match

      match.applyLabels()

  #################
  # PRIVATE
  #################

  # add to appropriate list in @matches
  # TODO: I'll bet this slows things down, generating the pluralLabel EVERY TIME
  _bindToLabelLists: (pluralLabel, match) ->
    @[pluralLabel] = push @[pluralLabel], match unless @__proto__[pluralLabel]?

  # keep most recent match directly as node property
  # IFF the prototype doesn't already have a property of that name
  _bindToSingleLabels: (label, match) ->
    @[label] = match unless @__proto__[label]?

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
