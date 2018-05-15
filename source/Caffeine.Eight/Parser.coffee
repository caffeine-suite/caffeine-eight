Rule = require './Rule'
{Node} = require './Nodes'
NonMatch = require './NonMatch'
Stats = require './Stats'
SourceLineColumnMap = require './SourceLineColumnMap'

{
  isNumber
  isFunction, peek, log, isPlainObject, isPlainArray, merge, compactFlatten, objectLength, inspect,
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
  uniqueValues
  objectHasKeys
} = require 'art-standard-lib'

{firstLines, lastLines, presentSourceLocation} = require './Lib'

CaffeineEightCompileError = require './CaffeineEightCompileError'

module.exports = class Parser extends require("art-class-system").BaseClass
  @repl: ->
    (require './Repl').caffeineEightRepl @

  @parse: (@_source, options = {})->
    (new @).parse @_source, options

  @classGetter
    rootRuleName: -> @_rootRuleName || "root"
    rootRule: -> @getRules()[@_rootRuleName]

  @extendableProperty
    rules: {}
    {
      # TODO: elliminate the need for 'noSetter'
      noSetter: true
      extend: (extendableRules, newRules) ->
        for ruleName, newRule of newRules
          extendableRules[ruleName] = newRule.clone()
        extendableRules
    }

  @addRule: (ruleName, definitions, nodeBaseClass = @getNodeBaseClass()) ->

    rule = @extendRules()[ruleName] ||= new Rule ruleName, @
    if definitions.root
      throw new Error "root rule already defined! was: #{@_rootRuleName}, wanted: #{ruleName}" if @_rootRuleName
      @_rootRuleName = ruleName

    definitions = [definitions] unless isPlainArray array = definitions
    if definitions.length > 1 && isPlainObject(last = peek definitions) &&
        !(last.pattern ? last.parse)
      [definitions..., commonNodeProps] = definitions
    else
      commonNodeProps = {}

    commonNodeProps.nodeBaseClass ||= nodeBaseClass

    for definition in definitions
      definition = pattern: definition unless isPlainObject definition
      if isPlainArray patterns = definition.pattern
        for pattern in patterns
          rule.addVariant merge commonNodeProps, definition, {pattern}
      else
        rule.addVariant merge commonNodeProps, definition

  ###
  IN:
    rules: plain object mapping rule-names to definitions
    nodeClass: optional, must extend Caffeine.Eight.Node or be a plain object
  ###
  @rule: rulesFunction = (a, b)->
    if isClass a
      sharedNodeBaseClass = a
      rules = b
    else
      rules = a
      sharedNodeBaseClass = b

    if isPlainObject sharedNodeBaseClass
      sharedNodeBaseClass = @getNodeBaseClass().createSubclass sharedNodeBaseClass

    for ruleName, definition of rules
      @addRule ruleName, definition, sharedNodeBaseClass || @getNodeBaseClass()

  @rules: rulesFunction

  rule: instanceRulesFunction = (a, b) -> @class.rule a, b
  rules: instanceRulesFunction

  @getNodeBaseClass: ->
    @_nodeBaseClass ||= if isPlainObject @nodeBaseClass
      log create: @getName() + "NodeBaseClass"
      Node.createSubclass merge
        name:        @getName() + "NodeBaseClass"
        @nodeBaseClass
    else @nodeBaseClass || Node

  @property "subparseInfo options"
  @getter "source parser",
    rootRuleName: -> @class.getRootRuleName()
    rootRule:     -> @class.getRootRule()
    nextOffset:   -> 0
    rootParser:   -> @parentParser?.rootParser || @
    rootSource:   -> @rootParser.source
    ancestors:    (into) ->
      into.push @
      into

    parseInfo: ->
      "Parser"

  constructor: ->
    super
    @_options = null
    @_parser = @
    @_source = null
    @_resetParserTracking()

  @_pluralNames = {}
  @pluralize: (name) ->
    @_pluralNames[name] ||= pluralize name

  pluralize: (name) ->
    @class.pluralize name

  ###
  IN:
    subsource:
      any string what-so-ever
    options:
      [all of @parse's options plus:]
      parentNode: (required)
        the resulting Node's parent

      originalMatchLength: (required)
        matchLength from @source that subsource was generated from.

      originalOffset: starting offset in parentParser.source

      sourceMap: (subsourceOffset) -> parentSourceOffset

    The original source we are sub-parsing from must be:

      parentNode.getNextText originalMatchLength

  OUT: a Node with offset and matchLength
  ###
  subparse: (subsource, options = {}) ->
    Stats.add "subparse"

    # log subparse: START: {subsource, options}

    subparser = new @class
    {originalMatchLength, parentNode, sourceMap, originalOffset} = options
    options.parentParser = @
    if match = subparser.parse subsource, merge(options, isSubparse: true, logParsingFailures: @_logParsingFailures)
      {offset, matchLength, source, parser} = match
      match.subparseInfo = {offset, matchLength, source, parser}

      if match.matchLength < subsource.length
        # options.allowPartialMatch was requested and the match was partial...

        originalMatchLength = if sourceMap
          sourceMap(match.matchLength) - parentNode.nextOffset
        else if match.text == parentNode.getNextText match.matchLength
          match.matchLength
        else
          throw new Error "Subparse requires a sourceMap to determine the match-length in the parent text for partial-matches."

      match.offset      = parentNode.nextOffset
      match.matchLength = originalMatchLength
      match._parser     = parentNode._parser
      match._parent     = parentNode
      match
    else
      failureIndex = subparser.failureIndexInParentParser
      # log subparse: FAILURE: {failureIndex, originalOffset, subFailureIndex: subparser.failureIndex}
      for k, nonMatch of subparser._nonMatches
        rootNode = nonMatch.node
        # throw new Error "A" if rootNode == parentNode
        while rootNode != parentNode && rootNode.parent instanceof Node
          rootNode = rootNode.parent
          # throw new Error "B" if rootNode == parentNode

        rootNode._parent = parentNode if rootNode != parentNode
        if @_logParsingFailures
          @_addNonMatch failureIndex, nonMatch
        else
          @_failureIndex = max @_failureIndex, failureIndex
      null

  offsetInParentParserSource: (suboffset) ->
    {sourceMap, originalOffset = 0} = @options
    if sourceMap
      throw new Error "suboffset (#{suboffset}) > source.length (#{@source.length})" unless suboffset <= @source.length
      sourceMap suboffset

    else if @parentParser
      @options.originalOffset + suboffset

    else
      suboffset

  offsetInRootParserSource: (suboffset) ->
    if @parentParser
      @parentParser.offsetInRootParserSource @offsetInParentParserSource suboffset
    else
      suboffset

  @getter
    failureIndexInParentParser: -> @offsetInParentParserSource @_failureIndex

  colorString: (clr, str)->
    if @options.color
      "#{str}"[clr]
    else
      str

  ###
  OUT: on success, root Node of the parse tree, else null
  options:
    allowPartialMatch: true/false
    color:    (default: false)  show errors in color (console colors)
    maxLines: (default: 10)     max total source lines to show when showing errors
  ###
  parse: (@_source, @options = {})->
    {@parentParser, allowPartialMatch, rule, isSubparse, logParsingFailures} = @options

    startRule = @getRule rule

    @_resetParserTracking()
    @_logParsingFailures = logParsingFailures

    if (rootParseTreeNode = startRule.parse @) &&
        (
          rootParseTreeNode.matchLength == @_source.length ||
          (allowPartialMatch && rootParseTreeNode.matchLength > 0)
        )
      rootParseTreeNode.applyLabels() unless isSubparse
      rootParseTreeNode
    else
      unless isSubparse
        if logParsingFailures
          throw @generateCompileError merge @options, {rootParseTreeNode}
        else
          # rerun parse with parsing-failure-logging
          # NOTE: we could speed this up by not completely trashing the cache
          @parse @_source, merge @options, logParsingFailures: true

  generateCompileError: (options) ->
      {message, info, rootParseTreeNode} = options
      new CaffeineEightCompileError(
        compactFlatten([
          if rootParseTreeNode?.matchLength < @_source.length
            @colorString "gray", "#{@class.name} only parsed: " +
              @colorString "black", "#{rootParseTreeNode.matchLength} of #{@_source.length} " +
              @colorString "gray", "characters"
          @getParseFailureInfo options
          message
        ]).join "\n"
        merge @getParseFailureInfoObject(options), info
      )

  getRule: (ruleName) ->
    ruleName ||= @rootRuleName
    throw new Error "No root rule defined." unless ruleName
    unless rule = @rules[ruleName]
      throw new Error "Could not find rule: #{ruleName}"
    rule

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



  ##################
  # Parsing Failure Info
  ##################
  @getter "nonMatches",

    sourceFile: -> @options.sourceFile

    failureUrl: (failureIndex = @_failureIndex) ->
      "#{@options.sourceFile || ''}:#{@getLineColumnString failureIndex}"

    parseFailureInfoObject: ->
      merge {
        sourceFile: @options.sourceFile
        failureIndex: @_failureIndex
        location: @getFailureUrl @_failureIndex
        @expectingInfo
      }, @getLineColumn @_failureIndex

    parseFailureInfo: (options = {})->
      return unless @_source

      {failureOffset, failureIndex = @_failureIndex, verbose, errorType = "Parsing"} = options
      throw new Error "DEPRICATED: failureOffset" if failureOffset?

      out = compactFlatten [
        ""
        @colorString "gray", "#{errorType} error at #{@colorString "red", @getFailureUrl failureIndex}"
        ""
        @colorString "gray", "Source:"
        @colorString "gray", "..."

        presentSourceLocation @_source,
          failureIndex
          @options

        @colorString "gray", "..."
        ""
        formattedInspect @expectingInfo, options
        if verbose
          formattedInspect ("partial-parse-tree": @partialParseTree), options
        ""
      ]
      out.join "\n"

    partialParseTreeLeafNodes: ->
      return @_partialParseTreeNodes if @_partialParseTreeNodes
      @getPartialParseTree()
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
      return @_expectingInfo if @_expectingInfo

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

      couldMatchRuleNames = []

      expecting = {}
      for pmp in partialMatchingParents
        for child in pmp.matches when child.isNonMatch && child.nonMatchingLeaf
          couldMatchRuleNames.push ruleName if ruleName = child.nonMatchingLeaf.ruleNameOrNull
          expecting[child.nonMatchingLeaf.ruleNameOrPattern] =
            "to-continue": pmp.ruleName
            "started-at": @getLineColumnString pmp.absoluteOffset

      @_expectingInfo = if objectHasKeys expecting
        out = {expecting}
        if couldMatchRuleNames.length > 1
          out.rules = {}
          for ruleName in couldMatchRuleNames
            for v in @rules[ruleName]._variants
              out.rules[ruleName] = v.patternString

        out
      else
        expecting: "end of input"

  tryPatternElement: (patternElement, parseIntoNode, ruleVariant) ->
    Stats.add "tryPatternElement"
    if patternElement.parseInto parseIntoNode
      true
    else
      @_logParsingFailure parseIntoNode, patternElement
      false

  # FAST!
  # SEE: SourceLineColumnMap#getLineColumn
  getLineColumn: (offset, into) ->
    (@_sourceLineColumnMap ||= new SourceLineColumnMap @_source)
    .getLineColumn offset, into

  getLineColumnString: (offset, into)->
    {line, column} = a = @getLineColumn offset, into
    "#{line + 1}:#{column + 1}"



  ##################
  # PRIVATE
  ##################

  _getRuleParseCache: (ruleName) ->
    @_parseCache[ruleName] ||= {}

  _cached: (ruleName, offset) ->
    @_getRuleParseCache(ruleName)[offset]

  _cacheMatch: (ruleName, matchingNode) ->
    Stats.add "cacheMatch"
    @_getRuleParseCache(ruleName)[matchingNode.offset] = matchingNode
    matchingNode

  _cacheNoMatch: (ruleName, offset) ->
    Stats.add "cacheNoMatch"
    @_getRuleParseCache(ruleName)[offset] = "no_match"
    null

  _resetParserTracking: ->
    @_activeRuleVariantParserOffsets = {}
    @_subparseInfo = null
    @_logParsingFailures = false
    @_partialParseTreeNodes = null
    @_partialParseTree = null
    @_matchingNegativeDepth = 0
    @_parsingDidNotMatchEntireInput = false
    @_failureIndex = 0
    @_expectingInfo = null
    @_nonMatches = {}
    @_parseCache = {}
    @_parentParserRootOffset = null

  @getter "activeRuleVariantParserOffsets activeRuleVariantParserAreLeftRecursive failureIndex",
    isMatchingNegative: -> @_matchingNegativeDepth > 0

  _matchNegative: (f) ->
    @_matchingNegativeDepth++
    result = f()
    @_matchingNegativeDepth--
    result

  _logParsingFailure: (parseIntoNode, patternElement) ->
    {nextOffset} = parseIntoNode
    return unless @_matchingNegativeDepth == 0 && nextOffset >= @_failureIndex && patternElement.isTokenPattern

    if @_logParsingFailures
      parseIntoNode = parseIntoNode.getRealNode()
      @_addNonMatch nextOffset, new NonMatch parseIntoNode, patternElement
    else
      @_failureIndex = nextOffset

  _addNonMatch: (offset, nonMatch) ->
    if offset > @_failureIndex
      @_failureIndex = offset
      @_nonMatches = {}

    @_nonMatches[nonMatch] = nonMatch
