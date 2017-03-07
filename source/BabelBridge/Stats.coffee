module.exports = class Stats extends require("art-class-system").BaseClass
  @_stats: {}
  @reset: -> @_stats = {}

  @add: (statName, amount = 1) ->
    @_stats[statName] = (@_stats[statName] || 0) + amount

  @get: -> @_stats
