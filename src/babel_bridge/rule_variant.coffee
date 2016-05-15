Foundation = require 'art-foundation'
PatternElement = require './pattern_element'
{Node, RuleNode} = require './nodes'
{BaseObject, log, isPlainObject, isString, compactFlatten, inspect} = Foundation
{allPatternElementsRegExp} = PatternElement

module.exports = class RuleVariant extends BaseObject

  constructor: (options) ->
    {@pattern, @rule, @parserClass} = options
    @pattern ||= options
    @_initVariantNodeClass options

  @getter
    patternElements: ->
      @_patternElements ||= @_generatePatternElements()

  _generatePatternElements: ->
    pes =
      if isString @pattern
        parts = @pattern.match allPatternElementsRegExp
        throw new Error "no pattern-parts found in: #{inspect @pattern}" unless parts
        for part in parts
          new PatternElement part, ruleVariant: @
      else
        [new PatternElement @pattern, ruleVariant: @]

    compactFlatten pes


  parse: (parentNode) ->
    node = new @VariantNodeClass parentNode

    for pe in @patternElements
      unless pe.parseInto node #.match pe
        parentNode.parser._logParsingFailure parentNode.nextOffset, pattern: @pattern, node: parentNode
        return

    node

  _initVariantNodeClass: ({variantNumber, node, rule}) ->
    @VariantNodeClass = if node instanceof Node
      node
    else
      class VariantNode extends RuleNode
        @_name: rule.nodeClassName + "Variant#{variantNumber}"
        if isPlainObject node
          for k, v of node
            @::[k] = v
