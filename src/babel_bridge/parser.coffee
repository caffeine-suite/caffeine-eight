Foundation = require 'art-foundation'
Nodes = require './nodes'
Rule = require './rule'

{BaseObject, isFunction, peek, log, isPlainObject, isPlainArray, merge} = Foundation
{RootNode} = Nodes

module.exports = class Parser extends BaseObject

  constructor: ->
    @_parser = @

  @parse: (@_source, options = {})->
    (new @).parse @_source, options

  @classGetter
    rules: ->
      @getPrototypePropertyExtendedByInheritance "_rules", {}

    rootRuleName: -> @_rootRuleName

    rootRule: ->
      @getRules()[@_rootRuleName]

  @addRule: (name, options) ->
    # log addRule: name:name, options:options
    rule = @getRules()[name] ||= new Rule name, @
    @_rootRuleName ||= name

    options = pattern: options unless isPlainObject options

    rule.addVariant options

  @rule: (rules)->
    for rule, definition of rules
      @addRule rule, definition

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


    if result = startRule.parse rootNode = new RootNode @
      if result.matchLength == @_source.length
        result
      else
        throw new Error "parse only matched #{result.matchLength} of #{@_source.length} characters"
    else
      throw new Error "parse failed"
