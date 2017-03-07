module.exports =
  package:
    description: "a 'runtime' parsing expression grammar parser"
    scripts:
      test: "nn -s;mocha -u tdd --compilers coffee:coffee-script/register"

  webpack:
    common: target: "node"
    targets:
      index: {}
