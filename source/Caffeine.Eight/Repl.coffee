{defineModule, formattedInspect, isClass, log} = require 'art-standard-lib'
require 'color'

defineModule module, class Repl
  @caffeineEightRepl: (parser) ->
    parser = new parser if isClass parser
    require('repl').start
      prompt: "#{parser.getClassName()}> ".grey
      eval: (command, context, filename, callback) ->
        try
          result = parsed = parser.parse command.trim()
          try
            log result = parsed.evaluate?() || parsed
            callback()
          catch e
            callback e
        catch e
          callback parser.getParseFailureInfo(color: true).replace "<HERE>", "<HERE>".red
