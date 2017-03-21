{defineModule, formattedInspect, isClass, log} = require 'art-standard-lib'

defineModule module, class Repl
  @babelBridgeRepl: (parser) ->
    parser = new parser if isClass parser
    require('repl').start
      prompt: "#{parser.getClassName()}> "
      eval: (command, context, filename, callback) ->
        try
          parsed = parser.parse command.trim()
          try
            if result = parsed.evaluate?()
              callback null, result
            else
              log parsed
              callback()
          catch e
            callback e
        catch e
          callback parser.parseFailureInfo.replace "<HERE>", "<HERE>".red
