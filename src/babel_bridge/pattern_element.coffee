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

  # IN: parentNode
  # OUT: Node instance or false if no match was found
  parse: (parentNode) -> throw new Error "should be overridden"

  # IN: parentNode
  # OUT: true if parsing was successful
  # EFFECT: if successful, one or more chlidren nodes have been added to parentNode
  parseInto: (parentNode) ->
    !!parentNode.addMatch @name, @parse parentNode

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
        matchCount++ while parentNode.addMatch @name, singleParser parentNode

        parentNode.addMatch new EmptyNode parentNode if matchCount == 0
        true

    if @_oneOrMore
      @parseInto = (parentNode) =>
        matchCount = 0
        matchCount++ while parentNode.addMatch @name, singleParser parentNode
        matchCount > 0

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
    [_, prefix, ruleName, suffix] = ruleName.match /^([!])?([a-zA-Z0-9]+)([?*+])?$/
    throw new Error "pattern can only have one prefix: ! or one suffix: ?/+/*" if prefix && suffix
    @_negative = !!prefix
    switch suffix
      when "?" then @_optional = true
      when "+" then @_oneOrMore = true
      when "*" then @_zeroOrMore = true

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
