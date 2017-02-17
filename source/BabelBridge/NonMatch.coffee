{log, defineModule, BaseObject} = require 'art-foundation'
defineModule module, class NonMatch extends BaseObject
  constructor: (@_node, @_patternElement) ->

  @getter "node patternElement",
    inspectedObjects: ->
      NonMatch:
        patternElement: @toString()
        offset: @node.offset

  toString: ->
    @patternElement.ruleVariant.toString()