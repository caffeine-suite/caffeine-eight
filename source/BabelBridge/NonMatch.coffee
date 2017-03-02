{log, defineModule} = require 'art-standard-lib'
{BaseClass} = require 'art-class-system'

defineModule module, class NonMatch extends BaseClass
  constructor: (@_node, @_patternElement) ->

  @getter "node patternElement",
    inspectedObjects: ->
      NonMatch:
        patternElement: @toString()
        offset: @node.offset

  toString: ->
    @patternElement.ruleVariant.toString()