Foundation = require 'art-foundation'
{TerminalNode} = require './nodes'
{BaseObject, isPlainArray, isString, isRegExp, inspect, log} = Foundation

module.exports = class PatternElement extends BaseObject
  constructor: (@match, @options = {}) ->
    {@ruleVariant} = @options
    throw new Error "bad args" unless @ruleVariant
    @_terminal = false
    @_init()

  @getter "name",
    parserClass: -> @ruleVariant.parserClass
    rules: -> @parserClass.getRules()

  parse: (parentNode) ->
    @_parser parentNode

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
