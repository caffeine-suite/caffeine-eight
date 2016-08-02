Foundation = require 'art-foundation'
Rule = require './rule'
{getLineColumn} = require './tools'

{
  BaseObject, isFunction, peek, log, isPlainObject, isPlainArray, merge, compactFlatten, objectLength, inspect,
  inspectLean
  pluralize
  isClass
  isPlainArray
} = Foundation

module.exports = class Parser extends BaseObject

  @parse: (@_source, options = {})->
    (new @).parse @_source, options

  @classGetter
    rootRuleName: -> @_rootRuleName || "root"
    rootRule: -> @getRules()[@_rootRuleName]

  @getRules: ->
    @getPrototypePropertyExtendedByInheritance "_rules", {}, (superRules) ->
      out = {}
      for k, v of superRules
        out[k] = v.clone()
      out

  @addRule: (ruleName, definitions, nodeBaseClass = @nodeBaseClass) ->
    # log addRule: ruleName:ruleName, definition:definition
    rule = @getRules()[ruleName] ||= new Rule ruleName, @
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
    {nodeBaseClass} = @
    if isClass a
      nodeBaseClass = a
      rules = b
    else
      rules = a
      nodeBaseClass = b if isClass b

    for ruleName, definition of rules
      @addRule ruleName, definition, nodeBaseClass

  @rules: rulesFunction

  rule: instanceRulesFunction = (a, b) -> @class.rule a, b
  rules: instanceRulesFunction

  @getter "source parser",
    rootRuleName: -> @class.getRootRuleName()
    rootRule:     -> @class.getRootRule()
    rules:        -> @class.getRules()
    nextOffset:   -> 0

  constructor: ->
    super
    @_parser = @
    @_source = null
    @_resetParserTracking()
    @_pluralNames = {}

  pluralize: (name) ->
    @_pluralNames[name] ||= pluralize name

  ###
  OUT: on success, root Node of the parse tree, else null
  ###
  parse: (@_source, options = {})->
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

  getParseFailureInfo: ->
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
      @getExpectingInfo()
    ]
    out.join "\n"

  getExpectingInfo: ->
    return null unless objectLength(@_expectingList) > 0

    sortedKeys = Object.keys(@_expectingList).sort()

    [
      "Could continue if one of these rules matched:"
      for k in sortedKeys
        {ruleVariant} = @_expectingList[k]
        "  #{k}"
    ]

  tryPatternElement: (patternElement, parseIntoNode, ruleVariant) ->
    if patternElement.parseInto parseIntoNode
      true
    else
      @_logParsingFailure parseIntoNode.offset,
        ruleVariant: ruleVariant
        parentNode: parseIntoNode.parent
      false

  ##################
  # PRIVATE
  ##################
  _resetParserTracking: ->
    @_matchingNegativeDepth = 0
    @_parsingDidNotMatchEntireInput = false
    @_failureIndex = 0
    @_expectingList = {}
    @_parseCache = {}

  @getter
    isMatchingNegative: -> @_matchingNegativeDepth > 0

  _matchNegative: (f) ->
    @_matchingNegativeDepth++
    result = f()
    @_matchingNegativeDepth--
    result

  ###
    expecting: {ruleVariant, parentNode}
  ###
  _logParsingFailure: (index, expecting) ->
    return if @matchingNegative

    if index >= @_failureIndex
      if index > @_failureIndex
        @_failureIndex = index
        @_expectingList = {}
      # log _logParsingFailure: index:index, expecting: expecting
      @_expectingList[expecting.ruleVariant.toString()] = expecting
