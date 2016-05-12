module.exports = class RuleNode extends require './non_terminal_node'
  match: (patternElement) ->
    if result = patternElement.parse @
      @addMatch result, patternElement.getName() # success, but don't keep EmptyNodes

  addMatch: (match, name) ->
    return unless match
    return match if match == @

    @addMatchName super(match), name

    @updateMatchLength()
    match

  addMatchName: (match, name) ->
    return unless name
