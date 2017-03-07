{log, defineModule, toInspectedObjects, isPlainObject, push, isString, compactFlatten, inspect, pad, upperCamelCase, merge} = require 'art-standard-lib'
{BaseClass} = require "art-class-system"

defineModule module, class ScratchNode extends BaseClass
  @_scatchNodes: []
  @_scatchNodesInUse: 0

  @checkout: (parentNode) ->
    if @_scatchNodesInUse >= @_scatchNodes.length
      @_scatchNodes[@_scatchNodesInUse++] = new ScratchNode parentNode
    else
      @_scatchNodes[@_scatchNodesInUse++].reset parentNode

  @checkin: (scratchNode) ->
    throw new Error "WTF" unless scratchNode == @_scatchNodes[--@_scatchNodesInUse]

  constructor: (parent) ->
    @matches = []
    @matchPatterns = []
    @reset parent

  reset: (parent) ->
    @parent = parent
    {@_parser} = parent
    @offset = @parent.getNextOffset()
    @matchesLength = @matchPatternsLength =
    @matchLength = 0
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

  createVariantNode: (ruleVariant) ->
    new ruleVariant.VariantNodeClass @parent,
      ruleVariant:    ruleVariant
      matchLength:    @matchLength
      matches:        @matchesLength       > 0 && @matches.slice       0, @matchesLength
      matchPatterns:  @matchPatternsLength > 0 && @matchPatterns.slice 0, @matchPatternsLength

  checkin: -> ScratchNode.checkin @

  subparse: (subSource, options) ->
    @_parser.subparse subSource, merge options, parentNode: @

  addMatch: (pattern, match) ->
    return false unless match

    @matches[@matchesLength++] = match
    @matchPatterns[@matchPatternsLength++] = pattern
    @matchLength   = match.nextOffset - @offset

    true

