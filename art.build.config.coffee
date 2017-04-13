module.exports =
  package:
    description: "a 'runtime' parsing expression grammar parser"
    dependencies:
      "art-standard-lib": "^1.0.0"
      color:              "^0.11.4"

    scripts:
      test: "nn -s;mocha -u tdd --compilers coffee:coffee-script/register"

  webpack:
    common: target: "node"
    targets:
      index: {}
