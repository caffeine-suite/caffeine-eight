{log, defineModule, toInspectedObjects, isPlainObject, push, isString, compactFlatten, inspect, pad, upperCamelCase, merge} = require 'art-standard-lib'
{BaseClass} = require "art-class-system"

defineModule module, class ScratchNode extends BaseClass
  @_scatchNodes: []
  @_scatchNodesInUse: 0

  @checkout: (parentNode, ruleVariant) ->
    if @_scatchNodesInUse >= @_scatchNodes.length
      @_scatchNodes[@_scatchNodesInUse++] = new ScratchNode parentNode, ruleVariant
    else
      @_scatchNodes[@_scatchNodesInUse++].reset parentNode, ruleVariant

  @checkin: (scratchNode) ->
    throw new Error "WTF" unless scratchNode == @_scatchNodes[--@_scatchNodesInUse]

  constructor: (parent, ruleVariant) ->
    @matches = []
    @matchPatterns = []
    @reset parent, ruleVariant

  reset: (@parent, @ruleVariant) ->
    {@_parser} = @parent
    @offset = @parent.getNextOffset() | 0
    @matchesLength = @matchPatternsLength =
    @matchLength = 0
    @variantNode = null
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

  @getter
    firstPartialMatchParent: -> @realNode.firstPartialMatchParent
    realNode: ->
      @variantNode ||= new @ruleVariant.VariantNodeClass @parent.realNode || @_parser,
        ruleVariant:    @ruleVariant
        matchLength:    @matchLength
        matches:        @matchesLength       > 0 && @matches.slice       0, @matchesLength
        matchPatterns:  @matchPatternsLength > 0 && @matchPatterns.slice 0, @matchPatternsLength

  checkin: -> ScratchNode.checkin @

  subparse: (subSource, options) ->
    @_parser.subparse subSource, merge options, parentNode: @

  addMatch: (pattern, match) ->
    return false unless match

    @variantNode?.addMatch pattern, match

    @matches[@matchesLength++] = match
    @matchPatterns[@matchPatternsLength++] = pattern
    @matchLength   = match.nextOffset - @offset

    true

  _addToParentAsNonMatch: ->
    @realNode._addToParentAsNonMatch()
