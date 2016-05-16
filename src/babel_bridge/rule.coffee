Foundation = require 'art-foundation'
RuleVariant = require './rule_variant'
{RuleNode} = require './nodes'

{BaseObject, merge, upperCamelCase, objectName, log} = Foundation

module.exports = class Rule extends BaseObject

  constructor: (@_name, @_parserClass)->
    @_variants = []
    @_nodeClassName = "#{upperCamelCase @_name}Node"

  @getter "nodeClassName name",
    numVariants: -> @_variants.length

  addVariant: (options, block) ->
    @_variants.push v = new RuleVariant merge options,
      variantNumber: @_variants.length + 1
      rule: @
      parserClass: @_parserClass
    v

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
