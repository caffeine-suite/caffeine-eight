Foundation = require 'art-foundation'
Rule = require './rule'
{getLineColumn, getLineColumnString} = require './tools'
{Node} = require './nodes'
NonMatch = require './NonMatch'

{
  BaseObject, isFunction, peek, log, isPlainObject, isPlainArray, merge, compactFlatten, objectLength, inspect,
  inspectLean
  pluralize
  isClass
  isPlainArray
  upperCamelCase
  mergeInto
  objectWithout
  uniqueValues
  formattedInspect
  max
  inspect
  pushIfNotPresent
} = Foundation

module.exports = class Parser extends BaseObject

  @parse: (@_source, options = {})->
    (new @).parse @_source, options

  @classGetter
    rootRuleName: -> @_rootRuleName || "root"
    rootRule: -> @getRules()[@_rootRuleName]

  @extendableProperty
    rules: {}
  , (extendableRules, newRules) ->
    for ruleName, newRule of a
      extendableRules[ruleName] = newRule.clone()
    newRule

  @addRule: (ruleName, definitions, nodeBaseClass = @nodeBaseClass) ->

    rule = @extendRules()[ruleName] ||= new Rule ruleName, @
    if definitions.root
      throw new Error "root rule already defined! was: #{@_rootRuleName}, wanted: #{ruleName}" if @_rootRuleName
      @_rootRuleName = ruleName

    definitions = [definitions] unless isPlainArray array = definitions

    for definition in definitions
      rule.addVariant if isPlainObject definition
        merge nodeBaseClass: nodeBaseClass, definition
      else
        pattern: definition, nodeBaseClass: nodeBaseClass

  ###
  IN:
    rules: plain object mapping rule-names to definitions
    nodeClass: optional, must extend BabelBridge.Node or be a plain object
  ###
  @rule: rulesFunction = (a, b)->
    if isClass a
      sharedNodeBaseClass = a
      rules = b
    else
      rules = a
      sharedNodeBaseClass = b

    if isPlainObject sharedNodeBaseClass
      sharedNodeBaseClass = (@nodeBaseClass || Node).createSubclass sharedNodeBaseClass

    for ruleName, definition of rules
      @addRule ruleName, definition, sharedNodeBaseClass || @nodeBaseClass

  @rules: rulesFunction

  rule: instanceRulesFunction = (a, b) -> @class.rule a, b
  rules: instanceRulesFunction

  @property "subparseInfo options"
  @getter "source parser",
    rootRuleName: -> @class.getRootRuleName()
    rootRule:     -> @class.getRootRule()
    nextOffset:   -> 0
    rootParser:   -> @parentParser?.rootParser || @
    ancestors:    (into) ->
      into.push @
      into

    parseInfo: ->
      "Parser"

  constructor: ->
    super
    @_options = null
    @_parser = @
    @_subparseInfo = null
    @_source = null
    @_resetParserTracking()

  @_pluralNames = {}
  @pluralize: (name) ->
    @_pluralNames[name] ||= pluralize name

  pluralize: (name) ->
    @class.pluralize name

  ###
  IN:
    subSource:
      any string what-so-ever
    options:
      [all of @parse's options plus:]
      parentNode: (required)
        the resulting Node's parent

      originalMatchLength: (required)
        matchLength from @source that subSource was generated from.

    The original source we are sub-parsing from must be:

      parentNode.getNextText originalMatchLength

  OUT: a Node with offset and matchLength
  ###
  subparse: (subSource, options = {}) ->
    # log subparse: {subSource, options}
    try
      options.parentParser = @
      if match = @class.parse subSource, merge(options, isSubparse: true)
        {offset, matchLength, source, parser} = match
        match.subparseInfo = {offset, matchLength, source, parser}

        {originalMatchLength, parentNode} = options

        # if options.allowPartialMatch was requested - and the match was partial...
        if match.matchLength < subSource.length

          if match.text != parentNode.getNextText match.matchLength
            throw new Error "INTERNAL TODO: SubParse was a partial match, but a source-map is required to determine the matchLength in the original source."

          originalMatchLength = match.matchLength

        match.offset      = parentNode.nextOffset
        match.matchLength = originalMatchLength
        match
    catch
      null

  ###
  OUT: on success, root Node of the parse tree, else null
  options:
    allowPartialMatch: true/false
  ###
  parse: (@_source, @options = {})->
    {@parentParser, allowPartialMatch, rule, isSubparse} = @options
    @_resetParserTracking()

    ruleName = rule || @rootRuleName
    {rules} = @
    throw new Error "No root rule defined." unless ruleName
    startRule = rules[ruleName]
    throw new Error "Could not find rule: #{ruleName}" unless startRule


    if result = startRule.parse @
      if result.matchLength == @_source.length || (allowPartialMatch && result.matchLength > 0)
        result.applyLabels() unless isSubparse
        result
      else
        throw new Error "parse only matched #{result.matchLength} of #{@_source.length} characters\n#{@getParseFailureInfo @options}"
    else
      throw new Error @getParseFailureInfo @options

  addToExpectingInfo = (node, into, value) ->
    if node.parent
      into = addToExpectingInfo node.parent, into

    into[node.parseInfo] ||= if value
      value
    else
      p = {}
      if (pm = node.presentMatches)?.length > 0
        p.matches = (m.parseInfo for m in pm)
      p


  lastLines = (string, count = 5) ->
    a = string.split "\n"
    a.slice a.length - count, a.length
    .join "\n"

  firstLines = (string, count = 5) ->
    a = string.split "\n"
    a.slice 0, count
    .join "\n"


  ##################
  # Parsing Failure Info
  ##################
  @getter "nonMatches",
    parseFailureInfo: (options)->
      return unless @_source

      verbose = options?.verbose

      sourceBefore = lastLines @_source.slice 0, @_failureIndex
      sourceAfter = firstLines @_source.slice @_failureIndex

      out = compactFlatten [
        """
        Parsing error at #{getLineColumnString @_source, @_failureIndex}

        Source:
        ...
        #{sourceBefore}<HERE>#{sourceAfter}
        ...

        """
        @expectingInfo
        if verbose
          [
            "",
            formattedInspect "partial-parse-tree": @partialParseTree
          ]
        ""
      ]
      out.join "\n"

    partialParseTreeLeafNodes: ->
      return @_partialParseTreeNodes if @_partialParseTreeNodes
      @partialParseTree
      @_partialParseTreeNodes

    partialParseTree: ->
      return @_partialParseTree if @_partialParseTree
      expectingInfoTree = {}
      @_partialParseTreeNodes = for k, {patternElement, node} of @_nonMatches #when (node.getPresent() || node.getPresent == Node.prototype.getPresent)
        addToExpectingInfo node, expectingInfoTree, patternElement.pattern.toString()
        n = new Node node
        n.pattern = patternElement
        rootNode = n._addToParentAsNonMatch()
        n

      @_partialParseTree = rootNode

    expectingInfo: ->
      return null unless objectLength(@_nonMatches) > 0

      ###
      I know how to do this right!

      1) I want to add all the non-match nodes to the parse-tree
      2) I want to further improve the parse-tree inspect
        - it may be time to do a custom inspect


      ###

      partialMatchingParents = []
      for node in @partialParseTreeLeafNodes
        {firstPartialMatchParent} = node
        pushIfNotPresent partialMatchingParents, firstPartialMatchParent

      newOutput = for pmp in partialMatchingParents
        for child in pmp.matches when child.isNonMatch
          "  '#{child.nonMatchingLeaf.ruleName}' to complete '#{pmp.ruleName}' (which started at #{getLineColumnString @_source, pmp.offset})"

      newOutput = compactFlatten newOutput
      newOutput = "  end of input" unless newOutput.length > 0
      compactFlatten [
        "expecting:"
        newOutput
      ]

  tryPatternElement: (patternElement, parseIntoNode, ruleVariant) ->
    if patternElement.parseInto parseIntoNode
      true
    else
      @_logParsingFailure parseIntoNode, patternElement
      false

  ##################
  # PRIVATE
  ##################

  _getRuleParseCache: (ruleName) ->
    @_parseCache[ruleName] ||= {}

  _cached: (ruleName, offset) ->
    @_getRuleParseCache(ruleName)[offset]

  _cacheMatch: (ruleName, matchingNode) ->
    @_getRuleParseCache(ruleName)[matchingNode.offset] = matchingNode
    matchingNode

  _cacheNoMatch: (ruleName, offset) ->
    @_getRuleParseCache(ruleName)[offset] = "no_match"
    null

  _resetParserTracking: ->
    @_partialParseTreeNodes = null
    @_partialParseTree = null
    @_matchingNegativeDepth = 0
    @_parsingDidNotMatchEntireInput = false
    @_failureIndex = 0
    @_nonMatches = {}
    @_parseCache = {}

  @getter
    isMatchingNegative: -> @_matchingNegativeDepth > 0

  _matchNegative: (f) ->
    @_matchingNegativeDepth++
    result = f()
    @_matchingNegativeDepth--
    result

  _logParsingFailure: (parseIntoNode, patternElement) ->
    return unless @_matchingNegativeDepth == 0 && parseIntoNode.offset >= @_failureIndex && patternElement.isTokenPattern
    {offset} = parseIntoNode

    if offset > @_failureIndex
      @_failureIndex = offset
      @_nonMatches = {}

    nonMatch = new NonMatch parseIntoNode, patternElement
    @_nonMatches[nonMatch] = nonMatch
