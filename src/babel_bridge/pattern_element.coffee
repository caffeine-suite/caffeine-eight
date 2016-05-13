Foundation = require 'art-foundation'
{TerminalNode, EmptyNode} = require './nodes'
{BaseObject, isPlainArray, isString, isRegExp, inspect, log} = Foundation

module.exports = class PatternElement extends BaseObject
  constructor: (@match, @options = {}) ->
    {@ruleVariant} = @options
    throw new Error "bad args" unless @ruleVariant
    @_terminal = false
    @_oneOrMore = @_zeroOrMore = @_optional = @_negative = false
    @_init()

  @getter "name optional negative",
    parserClass: -> @ruleVariant.parserClass
    rules: -> @parserClass.getRules()

  parseInto: (parentNode) ->
    if match = @parse parentNode
      parentNode.addMatch match, @name

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

    if @_oneOrMore
      @parse = (parentNode) ->
        matched = while match = singleParser parentNode
          match
        if matched.length == 0
          null
        else
          matched

  # initialize PatternElement based on the type of: match
  _init: ->
    {match} = @
    if isPlainArray match
      if match.length == 1
        match = match[0]
      else
        @_initArray match

    else if isString match then @_initRule match
    else if isRegExp match then @_initRegExp match
    # when Symbol then    init_rule match
    # when PatternElementHash then      init_hash match
    else throw new Error "invalid pattern type: #{inspect match}"

    @_applyParseFlags()

  _initRule: (ruleName) ->
    console.error _initRule: ruleName, rules: @rules
    [_, prefix, ruleName, postfix] = ruleName.match /^([!])?([a-zA-Z0-9]+)([?*+])?$/
    @_negative = !!prefix
    switch postfix
      when "?" then @_optional = true
      when "+" then @_oneOrMore = true
      when "*" then @_zeroOrMore = true

    throw new Error "can't be ! and ?" if @_negative && @_optional
    matchRule = @rules[ruleName]
    throw new Error "no rule for #{ruleName}" unless matchRule
    @parse = (parentNode) ->
      matchRule.parse parentNode

  _initRegExp: (pattern) ->
    @_terminal = true
    pattern = ///#{pattern.source}///y

    @parse = (parentNode) ->
      pattern.lastIndex = offset = parentNode.nextOffset
      if match = pattern.exec parentNode.source
        new TerminalNode parentNode,
          offset
          match[0].length
          pattern
