PatternElement = require './PatternElement'
Stats = require './Stats'

{Node} = require './Nodes'
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


  class ScratcNode extends BaseClass
    @_scatchNodes: []
    @_scatchNodesInUse: 0

    @checkout: (parentNode) ->
      if @_scatchNodesInUse >= @_scatchNodes.length
        @_scatchNodes[@_scatchNodesInUse++] = new ScratcNode parentNode
      else
        @_scatchNodes[@_scatchNodesInUse++].reset parentNode

    @checkin: (scratchNode) ->
      throw new Error "WTF" unless scratchNode == @_scatchNodes[--@_scatchNodesInUse]

    constructor: (parent) ->
      @matches = []
      @matchPatterns = []
      @reset parent

    reset: (parent) ->
      @parent = parent
      {@_parser} = parent
      @offset = @parent.getNextOffset()
      @matchesLength = @matchPatternsLength =
      @matchLength = 0
      @

    @getter "parser",
      source:     -> @_parser.source
      nextOffset: -> @offset + @matchLength
      inspectedObjects: ->
        offset: @offset
        matchLength: @matchLength
        matches: toInspectedObjects @matches
        matchPatterns: toInspectedObjects @matchPatterns

    getNextText: (length)->
      nextOffset = @getNextOffset()
      @source.slice nextOffset, nextOffset + length

    createVariantNode: (ruleVariant) ->
      new ruleVariant.VariantNodeClass @parent,
        ruleVariant:    ruleVariant
        matchLength:    @matchLength
        matches:        @matchesLength       > 0 && @matches.slice       0, @matchesLength
        matchPatterns:  @matchPatternsLength > 0 && @matchPatterns.slice 0, @matchPatternsLength

    checkin: -> ScratcNode.checkin @

    subparse: (subSource, options) ->
      @_parser.subparse subSource, merge options, parentNode: @

    addMatch: (pattern, match) ->
      return false unless match

      @matches[@matchesLength++] = match
      @matchPatterns[@matchPatternsLength++] = pattern
      @matchLength   = match.nextOffset - @offset

      true

  ###
  see: BabelBridge.Rule#parse
  ###
  parse: (parentNode) ->
    Stats.add "parseVariant"

    scratchNode = ScratcNode.checkout parentNode

    {parser} = parentNode
    for patternElement in @patternElements
      unless parser.tryPatternElement patternElement, scratchNode, @
        scratchNode.checkin()
        return false

    scratchNode.checkin()
    scratchNode.createVariantNode @

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
