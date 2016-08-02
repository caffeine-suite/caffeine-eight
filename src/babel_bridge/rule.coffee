Foundation = require 'art-foundation'
RuleVariant = require './rule_variant'

{BaseObject, merge, upperCamelCase, objectName, log} = Foundation

module.exports = class Rule extends BaseObject

  constructor: (@_name, @_parserClass, @_variants = [])->

  @getter "nodeClassName name variantNodeClasses",
    numVariants: -> @_variants.length

  addVariant: (options) ->
    @_variants.push v = new RuleVariant merge options,
      variantNumber: @_variants.length + 1
      rule: @
      parserClass: @_parserClass
    v

  @getter
    inspectObjects: ->
      [{inspect: => "<Rule: #{@_name}>"}, @_variants]

  clone: ->
    new Rule @_name, @_parserClass, @_variants.slice()

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
    for v in @_variants
      if match = v.parse parentNode
        return match

    null
