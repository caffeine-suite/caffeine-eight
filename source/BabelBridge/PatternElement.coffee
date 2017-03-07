{Node, EmptyNode, EmptyOptionalNode} = require './Nodes'
{isPlainObject, isString, isRegExp, inspect, log} = require 'art-standard-lib'

module.exports = class PatternElement extends require("art-class-system").BaseClass
  @escapeRegExp: escapeRegExp = (str) ->
    str.replace /[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&"
  @regExpRegExp: /\/((?:[^\\\/]|\\.)+)\//
  @ruleRegExp: /([a-zA-Z0-9_]+)/
  @singleQuotedStringRegExp: /'((?:[^\\']|\\.)+)'/
  @doubleQuotedStringRegExp: /"((?:[^\\"]|\\.)+)"/
  @labelRegExp: /([a-zA-Z0-9_]+)\:/
  @patternElementRegExp: ///
    (?:#{@labelRegExp.source})?
    ([!&])?
    (?:
      #{@ruleRegExp.source} |
      #{@regExpRegExp.source} |
      #{@singleQuotedStringRegExp.source} |
      #{@doubleQuotedStringRegExp.source}
    )
    ([?*+])?
    ///
  @allPatternElementsRegExp: ///#{@patternElementRegExp.source}///g

  #####################
  # members
  #####################
  constructor: (@pattern, {@ruleVariant} = {}) ->
    super
    @parse = null
    @_init()

  toString: ->
    "PatternElement(#{@pattern})"

  @getter "isTokenPattern"

  @property
    label: null
    optional: false
    negative: false
    couldMatch: false
    zeroOrMore: false
    oneOrMore: false
    pattern: null
    ruleName: null

  @getter
    isBasicRulePattern: ->
      @ruleName &&
      !@optional &&
      !@negative &&
      !@zeroOrMore &&
      !@oneOrMore &&
      !@couldMatch
    inspectedObjects: ->
      PatternElement: @props
    props: ->
      props = pattern: @pattern

      props.ruleName = @ruleName if @ruleName
      props.negative = true if @negative
      props.zeroOrMore = true if @zeroOrMore
      props.oneOrMore = true if @oneOrMore
      props.couldMatch = true if @couldMatch
      props


  # IN: parentNode
  # OUT: Node instance or false if no match was found
  parse: (parentNode) -> throw new Error "should be overridden"

  # IN: parentNode
  # OUT: true if parsing was successful
  # EFFECT: if successful, one or more chlidren nodes have been added to parentNode
  parseInto: (parentNode) ->
    !!parentNode.addMatch @, @parse parentNode

  _applyParseFlags: ->
    singleParser = @parse
    if @_optional
      @parse = (parentNode) ->
        if match = singleParser parentNode
          match
        else
          new EmptyOptionalNode parentNode

    if @_negative
      @parse = (parentNode) ->
        parentNode.parser._matchNegative ->
          if match = singleParser parentNode
            null
          else
            new EmptyNode parentNode

    if @couldMatch
      @parse = (parentNode) ->
        if singleParser parentNode
          new EmptyNode parentNode

    if @_zeroOrMore
      @parseInto = (parentNode) =>
        matchCount = 0
        while parentNode.addMatch @, m = singleParser parentNode
          matchCount++
          break if m.matchLength == 0 # avoid infinite match

        # parentNode.addMatch @, new EmptyNode parentNode if matchCount == 0
        true

    if @_oneOrMore
      @parseInto = (parentNode) =>
        matchCount = 0
        while parentNode.addMatch @, m = singleParser parentNode
          matchCount++
          break if m.matchLength == 0 # avoid infinite match

        matchCount > 0

  # initialize PatternElement based on the type of: match
  _init: ->
    @parse = @label = @ruleName = null
    @negative = @couldMatch = @oneOrMore = @optional = @zeroOrMore = false
    @_isTokenPattern = false
    {pattern} = @
    if isPlainObject pattern
      @_initPlainObject pattern
    else if isString pattern
      [__, @label, prefix, @ruleName, regExp, singleQuotedString, doubleQuotedString, suffix] = res = pattern.match PatternElement.patternElementRegExp
      throw new Error "pattern can only have one prefix: !/& or one suffix: ?/+/*" if prefix && suffix

      switch prefix
        when "!" then @negative = true
        when "&" then @couldMatch = true

      switch suffix
        when "?" then @optional = true
        when "+" then @oneOrMore = true
        when "*" then @zeroOrMore = true

      string = singleQuotedString || doubleQuotedString

      if @ruleName   then @_initRule @ruleName
      else if regExp then @_initRegExp new RegExp regExp
      else if string then @_initRegExp new RegExp escapeRegExp string
      else throw new Error "invalid pattern: #{pattern}"

    else if isRegExp pattern then @_initRegExp pattern

    else throw new Error "invalid pattern type: #{inspect pattern}"

    @_applyParseFlags()

  _initPlainObject: (object)->
    {
      @negative
      @oneOrMore
      @zeroOrMore
      @optional
      @parse
      parseInto
    } = object
    @parseInto = parseInto if parseInto
    throw new Error "plain-object pattern definition requires 'parse' or 'parseInto'" unless @parse || parseInto

  _initRule: (ruleName) ->
    matchRule = null
    @parse = (parentNode) ->
      matchRule ||= parentNode.parser.getRule ruleName
      matchRule.parse parentNode

  ###
  NOTE: regExp.test is 3x faster than .exec in Safari, but about the
    same in node/chrome. Safari is 2.5x faster than Chrome/Node in this.

    Regexp must have the global flag set, even if we are using the y-flag,
    to make .test() set .lastIndex correctly.

  SEE: https://jsperf.com/regex-match-length
  ###
  _initRegExp: (regExp) ->
    @_isTokenPattern = true
    flags = "yg"
    flags += "i" if regExp.ignoreCase
    regExp = RegExp regExp.source, flags

    @parse = (parentNode) ->
      {nextOffset, source} = parentNode
      regExp.lastIndex = nextOffset
      if regExp.test source
        new Node parentNode,
          offset: nextOffset
          matchLength: regExp.lastIndex - nextOffset
