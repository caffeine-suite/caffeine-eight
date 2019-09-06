RuleVariant = require './RuleVariant'
Stats = require './Stats'

{
  toInspectedObjects, merge, upperCamelCase, objectName, log,
  compactFlattenAll
} = require 'art-standard-lib'

module.exports = class Rule extends require("art-class-system").BaseClass

  constructor: (@_name, @_definedInClass, @_variants = [])->

  @getter "nodeClassName name variantNodeClasses definedInClass",
    numVariants: -> @_variants.length

  addVariant: (options, addPriorityVariant) ->
    v = new RuleVariant merge options,
      variantNumber: @_variants.length + 1
      rule: @
      parserClass: @_definedInClass

    if addPriorityVariant
      @_variants = compactFlattenAll v, @_variants
    else
      @_variants.push v
    v

  @getter
    inspectedObjects: ->
      toInspectedObjects @_variants

  clone: ->
    new Rule @_name, @_definedInClass, @_variants.slice()

  ###
  IN:
    parentNode: node instance
      This provides critical info:
        parentNode.source:      the source string
        parentNode.nextOffset:  the index in the source where parsing starts
        parentNode.parser:      access to the parser object

  EFFECT: If returning a new Node, it is expected that node's parent is already set to parentNode
  OUT: Node instance if parsing was successful
  ###
  parse: (parentNode) ->
    Stats.add "parseRule"
    {parser, nextOffset} = parentNode
    if cached = parser._cached @name, nextOffset
      return if cached == "no_match"
        Stats.add "cacheHitNoMatch"
        null
      else
        Stats.add "cacheHit"
        cached

    for v in @_variants
      if match = v.parse parentNode
        return parser._cacheMatch @name, match

    parser._cacheNoMatch @name, nextOffset
