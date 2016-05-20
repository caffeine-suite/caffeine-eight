Foundation = require 'art-foundation'
PatternElement = require './pattern_element'
{Node} = require './nodes'
{BaseObject, log, isPlainObject, isString, compactFlatten, inspect, pad, upperCamelCase} = Foundation
{allPatternElementsRegExp} = PatternElement

module.exports = class RuleVariant extends BaseObject

  constructor: (options) ->
    {@pattern, @rule, @parserClass, @variantNodeClassName} = options
    @pattern ||= options
    @_initVariantNodeClass options

  @setter "variantNodeClassName"
  @getter
    name: -> @variantNodeClassName + "Variant"
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

  inspect: -> @toString()
  toString: -> "#{@name}: #{@pattern}"

  ###
  see: BabelBridge.Rule#parse
  ###
  parse: (parentNode) ->
    node = new @VariantNodeClass parentNode

    {parser} = parentNode
    for patternElement in @patternElements
      unless parser.tryPatternElement patternElement, node, @
        return false

    node

  @getter
    variantNodeClassName: ->
      return @_variantNodeClassName if @_variantNodeClassName
      baseName = upperCamelCase(@rule.name) + "Rule" + upperCamelCase "#{@pattern}".match(/[a-zA-Z0-9_]+/g)?.join('_') || ""
      @_variantNodeClassName = baseName

  _initVariantNodeClass: ({variantNumber, nodeClass, nodeBaseClass, rule}) ->
    @VariantNodeClass = if nodeClass?.prototype instanceof Node
      nodeClass
    else
      {variantNodeClassName} = @
      class VariantNode extends nodeBaseClass || Node
        @_name: variantNodeClassName #rule.nodeClassName + "Variant#{variantNumber}"
        if isPlainObject nodeClass
          for k, v of nodeClass
            @::[k] = v
