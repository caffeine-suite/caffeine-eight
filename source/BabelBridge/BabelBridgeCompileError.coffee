{defineModule, log, mergeInto, isFunction, formattedInspect, ErrorWithInfo} = require 'art-standard-lib'

defineModule module, class BabelBridgeCompileError extends ErrorWithInfo
  constructor: (message, info) ->
    super message, info, "BabelBridgeCompileError"
