module.exports = (require "art-foundation/configure_webpack")
  entries: "index"
  dirname: __dirname
  package:
    description: "a 'runtime' parsing expression grammar parser"
    scripts:
      "test": "nn -s;mocha -u tdd --compilers coffee:coffee-script/register"
