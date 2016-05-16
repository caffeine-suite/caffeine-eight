Foundation = require 'art-foundation'
PatternElement = require './pattern_element'
{Node, RuleNode} = require './nodes'
{BaseObject, log, isPlainObject, isString, compactFlatten, inspect, pad} = Foundation
{allPatternElementsRegExp} = PatternElement

module.exports = class RuleVariant extends BaseObject

  constructor: (options) ->
    {@pattern, @rule, @parserClass, @variantNumber} = options
    @pattern ||= options
    @_initVariantNodeClass options

  @getter
    numVariants: -> @rule.numVariants
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

  inspect: ->
    {numVariants}  = @
    numVariantsStr = "#{numVariants}"
    variantString = "(variant #{pad @variantNumber, numVariantsStr.length, ' '}/#{numVariantsStr})"

    "rule #{@rule.name}#{variantString}: #{@pattern}"

  toString: ->
    "rule #{@rule.name}: #{@pattern}"

  ###
  see: BabelBridge.Rule#parse
  ###
  parse: (parentNode) ->
    node = new @VariantNodeClass parentNode

    for pe in @patternElements
      unless pe.parseInto node
        parentNode.parser._logParsingFailure parentNode.nextOffset, ruleVariant: @, parentNode: parentNode
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
