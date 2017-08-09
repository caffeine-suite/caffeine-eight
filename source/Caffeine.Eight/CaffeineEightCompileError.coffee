{defineModule, log, mergeInto, isFunction, formattedInspect, ErrorWithInfo} = require 'art-standard-lib'

defineModule module, class CaffeineEightCompileError extends ErrorWithInfo
  constructor: (message, info) ->
    super message, info, "CaffeineEightCompileError"
