{defineModule, formattedInspect, isClass, log} = require 'art-standard-lib'
require 'color'

defineModule module, class Repl
  @babelBridgeRepl: (parser) ->
    parser = new parser if isClass parser
    require('repl').start
      prompt: "#{parser.getClassName()}> ".grey
      eval: (command, context, filename, callback) ->
        try
          parsed = parser.parse command.trim()
          try
            if result = parsed.evaluate?()
              callback null, result
            else
              log formattedInspect parsed, color: true
              callback()
          catch e
            callback e
        catch e
          callback parser.getParseFailureInfo(color: true).replace "<HERE>", "<HERE>".red
