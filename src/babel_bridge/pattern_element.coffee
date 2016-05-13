Foundation = require 'art-foundation'
{TerminalNode, EmptyNode} = require './nodes'
{BaseObject, isPlainArray, isString, isRegExp, inspect, log} = Foundation


module.exports = class PatternElement extends BaseObject
  @escapeRegExp: escapeRegExp = (str) ->
    str.replace /[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&"
  @regExpRegExp: /\/((?:[^\\\/]|\\.)+)\//
  @ruleRegExp: /([a-zA-Z0-9_]+)/
  @singleQuotedStringRegExp: /'((?:[^\\']|\\.)+)'/
  @doubleQuotedStringRegExp: /"((?:[^\\"]|\\.)+)"/
  @labelRegExp: /([a-zA-Z0-9_]+)\:/
  @patternElementRegExp: ///
    (?:#{@labelRegExp.source})?
    ([!])?
    (?:
      #{@ruleRegExp.source} |
      #{@regExpRegExp.source} |
      #{@singleQuotedStringRegExp.source} |
      #{@doubleQuotedStringRegExp.source}
    )
    ([?*+])?
    ///
  @allPatternElementsRegExp: ///#{@patternElementRegExp.source}///g

  constructor: (@pattern, @options = {}) ->
    {@ruleVariant} = @options
    throw new Error "bad args" unless @ruleVariant
    @_terminal = false
    @_init()

  @property
    label: null
    optional: false
    negative: false
    zeroOrMore: false
    oneOrMore: false
    pattern: null

  @getter
    parserClass: -> @ruleVariant.parserClass
    rules: -> @parserClass.getRules()

  # IN: parentNode
  # OUT: Node instance or false if no match was found
  parse: (parentNode) -> throw new Error "should be overridden"

  # IN: parentNode
  # OUT: true if parsing was successful
  # EFFECT: if successful, one or more chlidren nodes have been added to parentNode
  parseInto: (parentNode) ->
    !!parentNode.addMatch @label, @parse parentNode

  _applyParseFlags: ->
    singleParser = @parse
    if @_optional
      @parse = (parentNode) ->
        if match = singleParser parentNode
          match
        else
          new EmptyNode parentNode

    if @_negative
      @parse = (parentNode) ->
        if match = singleParser parentNode
          null
        else
          new EmptyNode parentNode

    if @_zeroOrMore
      @parseInto = (parentNode) =>
        matchCount = 0
        matchCount++ while parentNode.addMatch @label, singleParser parentNode

        parentNode.addMatch new EmptyNode parentNode if matchCount == 0
        true

    if @_oneOrMore
      @parseInto = (parentNode) =>
        matchCount = 0
        matchCount++ while parentNode.addMatch @label, singleParser parentNode
        matchCount > 0

  # initialize PatternElement based on the type of: match
  _init: ->
    {pattern} = @
    if isPlainArray pattern
      if pattern.length == 1
        pattern = pattern[0]
      else
        @_initArray pattern

    else if isString pattern
      [_, label, prefix, ruleName, regExp, singleQuotedString, doubleQuotedString, suffix] = res = pattern.match PatternElement.patternElementRegExp
      # log
      #   pattern: pattern
      #   res: res
      #   prefix: prefix
      #   ruleName: ruleName
      #   regExp: regExp
      #   suffix: suffix
      throw new Error "pattern can only have one prefix: ! or one suffix: ?/+/*" if prefix && suffix
      @negative = !!prefix
      @label = label || ruleName
      switch suffix
        when "?" then @optional = true
        when "+" then @oneOrMore = true
        when "*" then @zeroOrMore = true

      # log
      #   label: @label
      #   ruleName: ruleName
      #   regExp: regExp
      #   stringMatch: singleQuotedString || doubleQuotedString
      #   negative: @negative
      #   optional: @optional
      #   oneOrMore: @oneOrMore
      #   zeroOrMore: @zeroOrMore

      if ruleName
        @_initRule ruleName
      else if regExp
        @_initRegExp new RegExp regExp
      else if string = singleQuotedString || doubleQuotedString
        @_initRegExp new RegExp escapeRegExp string
      else
        throw new Error "invalid pattern: #{pattern}"

    else if isRegExp pattern then @_initRegExp pattern

    else throw new Error "invalid pattern type: #{inspect pattern}"

    @_applyParseFlags()

  _initRule: (ruleName) ->
    matchRule = @rules[ruleName]
    throw new Error "no rule for #{ruleName}" unless matchRule
    @parse = (parentNode) ->
      matchRule.parse parentNode

  _initRegExp: (regExp) ->
    @_terminal = true
    regExp = ///#{regExp.source}///y

    @parse = (parentNode) ->
      regExp.lastIndex = offset = parentNode.nextOffset
      if match = regExp.exec parentNode.source
        new TerminalNode parentNode,
          offset
          match[0].length
          regExp
