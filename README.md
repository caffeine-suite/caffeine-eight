## CaffeineEight [![Build Status](https://travis-ci.org/caffeine-suite/caffeine-eight.svg?branch=master)](https://travis-ci.org/caffeine-suite/caffeine-eight)

Come to C8 because you want an elegant, declarative API that makes parsing as easy as humanly possible. Stay for super powers like detailed parsing errors, predictable [PEG-based](https://en.wikipedia.org/wiki/Parsing_expression_grammar)  parsing and runtime parser extendability.

Unlike other parsing libraries, CaffeineEight is not a parser-generator. There is no build step. Just extend a class, add some rules and you are ready to parse. With CaffeineEight you can create and, more importantly, extend your parsers at runtime.

#### Motivating Example

A complete JSON parser in less than 30 lines of code.

```coffeescript
# CaffeineScript
class JsonParser extends &CaffeineEight.Parser

  @rule
    root: :array :object

    array:
      "'[' _? ']'"
      "'[' _? value commaValue* _? ']'"

    object:
      "'{' _? '}'"
      "'{' _? pair commaPair* _? '}'"

    commaValue: "_? ',' _? value"
    commaPair:  "_? ',' _? pair"
    pair:       "string _? ':' _? value"

    value: :object :array :number :string :true :false :null

    string: /"(?:[^"\\]|\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4}))*"/
    number: /-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?/
    true:   /true/
    false:  /false/
    null:   /null/

    _:      /\ +/

.repl()
```

## Goals

* Define PEG parsers 100% in JavaScript
* Runtime-extensible parsers
* Reasonably fast
* No globals - each parser instance parses in its own space

## Features

* Full parsing expression grammar support with memoizing
* Full JavaScript regular expressions support for terminals
* Simple, convention-over-configuration parse-tree class structure
* Human-readable parse-tree dumps
* Detailed information about parsing failures
* Custom sub-parser hooks
  * Which enable indention-based block parsing for languages like Python, CoffeeScript, or my own CaffeineScript

## Learn More

* [Wiki Home](https://github.com/caffeine-suite/caffeine-eight/wiki)

## Rename History

* CaffeineEight was formally called [BabelBridgeJs](https://www.npmjs.com/package/caffeine-eight)
* CaffeineEight was inspired by my earlier [Babel Bridge Ruby Gem](https://github.com/shanebdavis/Babel-Bridge), the JavaScript version turned out to be even more awesome!