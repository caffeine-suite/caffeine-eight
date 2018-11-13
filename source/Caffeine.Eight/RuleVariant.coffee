PatternElement = require './PatternElement'
Stats = require './Stats'

{Node, ScratchNode} = require './Nodes'
{log, toInspectedObjects, isPlainObject, push, isString, compactFlatten, inspect, pad, upperCamelCase, merge} = require 'art-standard-lib'
{allPatternElementsRegExp} = PatternElement
{BaseClass} = require "art-class-system"

module.exports = class RuleVariant extends BaseClass

  constructor: (@options) ->
    @_toString = null

    @options = pattern: @options unless isPlainObject @options
    {@pattern, @rule, @parserClass} = @options
    @_variantNodeClassName = @options.variantNodeClassName
    @_initVariantNodeClass @options
    @parse = @options.parse if @options.parse

  @property
    passThroughRuleName: null

  @setter "variantNodeClassName"
  @getter
    ruleName: -> @rule.name
    inspectedObjects: -> toInspectedObjects @pattern
    isPassThrough: -> @_passThroughRuleName
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

    pes = compactFlatten pes
    @passThroughRuleName = pes[0].ruleName if pes.length == 1 && pes[0].isBasicRulePattern
    pes

  inspect: -> @toString()
  toString: -> @_toString ||= "#{@name}: #{@patternString}"

  @getter
    patternString: -> @pattern || (@options.parse && 'function()')


  # depth = 0
  ###
  see: Caffeine.Eight.Rule#parse
  ###
  parse: (parentNode) ->
    {name} = @
    {parser, nextOffset} = parentNode
    {activeRuleVariantParserOffsets} = parser

    if nextOffset == previousActiveRuleVariantParserOffset = activeRuleVariantParserOffsets[name]
      throw new Error "leftRecursion detected: RuleVariant: #{name}, offset: #{nextOffset}"

    activeRuleVariantParserOffsets[name] = nextOffset

    try
      Stats.add "parseVariant"

      scratchNode = ScratchNode.checkout parentNode, @

      {parser} = parentNode
      for patternElement in @patternElements
        unless parser.tryPatternElement patternElement, scratchNode, @
          scratchNode.checkin()
          return false

      scratchNode.checkin()
      scratchNode.getRealNode()

    finally
      activeRuleVariantParserOffsets[name] = previousActiveRuleVariantParserOffset

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
    nodeSubclassOptions = options.node || options.nodeClass || options
    nodeBaseClass = options.extends || options.baseClass || options.nodeBaseClass || Node

    @VariantNodeClass = if nodeClass?.prototype instanceof Node
      nodeClass
    else
      nodeBaseClass.createSubclass merge
        name:        @variantNodeClassName
        ruleVarient: @ruleVarient
        nodeSubclassOptions
