Foundation = require 'art-foundation'
PatternElement = require './pattern_element'
{Node, RuleNode} = require './nodes'
{BaseObject, log, isPlainObject, isString, compactFlatten} = Foundation
{allPatternElementsRegExp} = PatternElement

module.exports = class RuleVariant extends BaseObject

  constructor: (options) ->
    {@pattern, @rule, @parserClass} = options
    @_initVariantNodeClass options

  @getter
    patternElements: ->
      @_patternElements ||= @_generatePatternElements()

  _generatePatternElements: ->
    pes = for patternPart in @pattern
      if isString patternPart
        for part in patternPart.match allPatternElementsRegExp
          new PatternElement part, ruleVariant: @
      else
        new PatternElement patternPart, ruleVariant: @

    compactFlatten pes


  parse: (parentNode) ->
    node = new @VariantNodeClass parentNode

    for pe in @patternElements
      return unless pe.parseInto node #.match pe

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
