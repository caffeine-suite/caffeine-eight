Foundation = require 'art-foundation'
PatternElement = require './pattern_element'
{BaseObject, log} = Foundation
module.exports = class RuleVariant extends BaseObject

  constructor: ({@pattern, @rule, @VariantNodeClass, @parserClass}) ->
    throw new Error "missing options" unless @pattern && @rule && @VariantNodeClass

  @getter
    patternElements: ->
      @_patternElements ||= for match in @pattern
        new PatternElement match,
          ruleVariant: @
          patternElement: true


  parse: (parentNode) ->
    node = new @VariantNodeClass parentNode

    for pe in @patternElements
      return unless node.match pe

    node
