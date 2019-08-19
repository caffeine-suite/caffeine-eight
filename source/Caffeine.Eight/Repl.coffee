{defineModule, formattedInspect, isClass, log} = require 'art-standard-lib'

defineModule module, class Repl
  @caffeineEightRepl: (parser, options) ->
    parser = new parser if isClass parser

    try require 'colors'

    if options?.load
      log "TODO: load, parse and evaluate these files: #{options.load.join ', '}"

    require('repl').start
      prompt: "#{parser.getClassName()}> ".grey
      eval: (command, context, filename, callback) ->
        try
          result = parsed = parser.parse command.trim()
          try
            log if undefined == result = parsed.evaluate?() then parsed else result
            callback()
          catch e
            callback e
        catch e
          log parser.getParseFailureInfo(color: true).replace "<HERE>", "<HERE>".red
          callback()
