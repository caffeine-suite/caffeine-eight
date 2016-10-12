Foundation = require 'art-foundation'
Rule = require './rule'
{getLineColumn} = require './tools'
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

  @property "subparseInfo"
  @getter "source parser",
    rootRuleName: -> @class.getRootRuleName()
    rootRule:     -> @class.getRootRule()
    nextOffset:   -> 0
    ancestors:    (into) ->
      into.push @
      into

    parseInfo: ->
      "Parser"

  constructor: ->
    super
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
      parentNode: set the resulting Node's parent
      originalOffset:
      originalMatchLength:
        offset and matchLength from @source that subSource was generated from.

  OUT: a Node with offset and matchLength
  ###
  subparse: (subSource, options = {}) ->
    try
      options.parentParser = @
      if p = @class.parse subSource, options
        {offset, matchLength, source, parser} = p
        p.subparseInfo =
          offset: offset
          matchLength: matchLength
          source: source
          parser: parser

        p.offset = options.originalOffset
        p.matchLength = options.originalMatchLength
        p._parent = options.parentNode
        p._parser = options.parentNode._parser
        p
    catch
      null

  ###
  OUT: on success, root Node of the parse tree, else null
  ###
  parse: (@_source, options = {})->
    {@parentParser} = options
    @_resetParserTracking()

    ruleName = options.rule || @rootRuleName
    {rules} = @
    throw new Error "No root rule defined." unless ruleName
    startRule = rules[ruleName]
    throw new Error "Could not find rule: #{rule}" unless startRule


    if result = startRule.parse @
      if result.matchLength == @_source.length
        result
      else
        throw new Error "parse only matched #{result.matchLength} of #{@_source.length} characters\n#{@getParseFailureInfo()}"
    else
      throw new Error @getParseFailureInfo()

  addToExpectingInfo = (node, into, value) ->
    if node.parent
      into = addToExpectingInfo node.parent, into

    into[node.parseInfo] ||= value || {}

  ##################
  # Parsing Failure Info
  ##################
  @getter "nonMatches",
    parseFailureInfo: ->
      return unless @_source

      sourceBefore = @_source.slice 0, @_failureIndex
      sourceAfter = @_source.slice @_failureIndex

      out = compactFlatten [
        """
        Parsing error at offset #{inspectLean getLineColumn @_source, @_failureIndex}

        Source:
        ...
        #{sourceBefore}<HERE>#{sourceAfter}
        ...

        """
        @expectingInfo
      ]
      out.join "\n"

    expectingInfo: ->
      return null unless objectLength(@_nonMatches) > 0

      expectingInfoTree = {}
      for k, {patternElement, node} of @_nonMatches
        addToExpectingInfo node, expectingInfoTree, patternElement.pattern.toString()

      [
        "Could continue if one of these rules matched:"
        formattedInspect expectingInfoTree, 0
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

    nonMatch = new NonMatch parseIntoNode, parseIntoNode
    @_nonMatches[nonMatch] = nonMatch
