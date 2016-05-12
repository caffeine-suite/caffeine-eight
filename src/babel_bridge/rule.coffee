Foundation = require 'art-foundation'
RuleVariant = require './rule_variant'
{RuleNode} = require './nodes'

{BaseObject, merge, upperCamelCase, objectName, log} = Foundation

module.exports = class Rule extends BaseObject

  constructor: (@_name, @_parserClass)->
    @_upperCamelCaseName = upperCamelCase @_name
    @_variants = []
    @NodeClass = @newNodeClass

  addVariant: (options, block) ->
    @_variants.push v = new RuleVariant merge options,
      VariantNodeClass: @newVariantNodeClass
      rule: @
      parserClass: @_parserClass
    v

  parse: (node) ->
    for v in @_variants
      if match = v.parse node
        return match

    null

  ##################
  # PRIVATE
  ##################

  @getter
    nodeClassName: -> "#{@_upperCamelCaseName}Node"
    newNodeClass: ->
      {nodeClassName} = @
      class _RuleNode extends RuleNode
        @_name: nodeClassName

    newVariantNodeClass: ->
      {nodeClassName} = @
      number = @_variants.length + 1
      class VariantNode extends @NodeClass
        @_name: nodeClassName + "Variant#{number}"
