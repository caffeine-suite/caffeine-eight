Foundation = require 'art-foundation'
PatternElement = require './pattern_element'
{Node} = require './nodes'
{BaseObject, log, isPlainObject, isString, compactFlatten, inspect, pad, upperCamelCase, mergeInto} = Foundation
{allPatternElementsRegExp} = PatternElement

module.exports = class RuleVariant extends BaseObject

  constructor: (@options) ->
    @options = pattern: @options unless isPlainObject @options
    {@pattern, @rule, @parserClass} = @options
    @_variantNodeClassName = @options.variantNodeClassName
    @_initVariantNodeClass @options
    @parse = @options.parse if @options.parse

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
  toString: -> "#{@name}: #{@pattern || (@options.parse && 'function()')}"

  ###
  see: BabelBridge.Rule#parse
  ###
  parse: (parentNode) ->
    node = new @VariantNodeClass parentNode, ruleVariant: @

    {parser} = parentNode
    for patternElement in @patternElements
      unless parser.tryPatternElement patternElement, node, @
        return false

    node

  @getter
    variantNodeClassName: ->
      return @_variantNodeClassName if @_variantNodeClassName
      baseName = upperCamelCase(@rule.name) + "Rule" + if @pattern
        upperCamelCase "#{@pattern}".match(/[a-zA-Z0-9_]+/g)?.join('_') || ""
      else if @parse
        "CustomParser"
      @_variantNodeClassName = baseName

  ###
  OPTIONS:

    node / nodeClass
      TODO: pick one, I like 'node' today

    extends / baseClass / nodeBaseClass
      TODO: pick one, I like 'extends' today
  ###
  _initVariantNodeClass: (options) ->
    {rule} = options
    nodeClass = options.node || options.nodeClass
    nodeBaseClass = options.extends || options.baseClass || options.nodeBaseClass

    @VariantNodeClass = if nodeClass?.prototype instanceof Node
      nodeClass
    else
      {variantNodeClassName} = @
      class VariantNode extends nodeBaseClass || Node
        @_name: variantNodeClassName
        mergeInto @::, nodeClass || options
