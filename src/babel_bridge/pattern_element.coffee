Foundation = require 'art-foundation'
{TerminalNode, EmptyNode} = require './nodes'
{BaseObject, isPlainArray, isString, isRegExp, inspect, log} = Foundation

module.exports = class PatternElement extends BaseObject
  constructor: (@match, @options = {}) ->
    {@ruleVariant} = @options
    throw new Error "bad args" unless @ruleVariant
    @_terminal = false
    @_optional = @_negative = false
    @_init()

  @getter "name optional negative",
    parserClass: -> @ruleVariant.parserClass
    rules: -> @parserClass.getRules()

  parse: (parentNode) ->
    match = @_parser parentNode

    # Negative patterns
    if @negative
      match = if match then null else new EmptyNode parentNode

    # Optional patterns
    match = new EmptyNode parentNode if !match && @optional

    match

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

  _initRule: (ruleName) ->
    console.error _initRule: ruleName, rules: @rules
    [_, @_negative, ruleName, @_optional] = ruleName.match /^([!])?([a-zA-Z0-9]+)(\?)?$/
    throw new Error "can't be ! and ?" if @_negative && @_optional
    matchRule = @rules[ruleName]
    throw new Error "no rule for #{ruleName}" unless matchRule
    @_parser = (parentNode) ->
      matchRule.parse parentNode

  _initRegExp: (pattern) ->
    @_terminal = true
    pattern = ///#{pattern.source}///y

    @_parser = (parentNode) ->
      pattern.lastIndex = offset = parentNode.nextOffset
      if match = pattern.exec parentNode.source
        new TerminalNode parentNode,
          offset
          match[0].length
          pattern
