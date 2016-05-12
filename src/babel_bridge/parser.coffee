Foundation = require 'art-foundation'
Nodes = require './nodes'
Rule = require './rule'

{BaseObject, isFunction, peek, log} = Foundation
{RootNode} = Nodes

module.exports = class Parser extends BaseObject

  constructor: ->
    @_parser = @

  @classGetter
    rules: ->
      @getPrototypePropertyExtendedByInheritance "_rules", {}

    rootRuleName: -> @_rootRuleName

    rootRule: ->
      @getRules()[@_rootRuleName]

  @rule: (name, pattern...)->
    rule = @getRules()[name] ||= new Rule name, @
    @_rootRuleName ||= name
    block = pattern.pop() if isFunction peek pattern
    rule.addVariant pattern: pattern, block

  @getter "source parser",
    rootRuleName: -> @class.getRootRuleName()
    rootRule:     -> @class.getRootRule()
    rules:        -> @class.getRules()
    nextOffset:   -> 0

  # OUT: promise
  parse: (@_source, options = {})->

    ruleName = options.rule || @rootRuleName
    {rules} = @
    throw new Error "No root rule defined." unless ruleName
    startRule = rules[ruleName]
    throw new Error "Could not find rule: #{rule}" unless startRule

    Promise.resolve startRule.parse rootNode = new RootNode @
