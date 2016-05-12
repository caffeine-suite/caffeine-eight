Foundation = require 'art-foundation'
{TerminalNode} = require './nodes'
{BaseObject, isPlainArray, isString, isRegExp, inspect, log} = Foundation

escapeRegExp = (str) ->
  str.replace /[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&"

module.exports = class PatternElement extends BaseObject
  constructor: (@match, @options = {}) ->
    # {@ruleVariant} = @options
    # throw new Error "bad args" unless @ruleVariant
    @_terminal = false
    @_init()

  @getter "name"

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
    else if isString(match) ||isRegExp(match) then @_initRegExp match
    # when Symbol then    init_rule match
    # when PatternElementHash then      init_hash match
    else throw new Error "invalid pattern type: #{inspect match}"

  _initRegExp: (pattern) ->
    @_terminal = true
    pattern = if isString pattern
      ///#{escapeRegExp pattern}///y
    else
      ///#{pattern.source}///y

    @_parser = (parentNode) ->
      pattern.lastIndex = offset = parentNode.nextOffset
      log PatternElement_parser:
        pattern: pattern
        offset: offset
        source: parentNode.source
      if match = pattern.exec parentNode.source
        new TerminalNode parentNode,
          offset
          match[0].length
          pattern
