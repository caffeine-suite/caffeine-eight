## BabelBridgeJS

* Create parsers with ease 100% in JavaScript, or better yet, CoffeeScript!
* Powered by [Parsing Expression Grammars](https://en.wikipedia.org/wiki/Parsing_expression_grammar)
* Inspired by my earlier [Babel Bridge Ruby Gem](http://babel-bridge.rubyforge.org/index.html), the JavaScript version is turning out to be even more awesome!

#### Motivating Example

```coffeescript
  BabelBridge = require 'babel-bridge'

  class MyParser extends BabelBridge.Parser
    @rule foo: "/foo/ bar?"
    @rule bar: /bar/

  myParser = new MyParser
  myParser.parse "foo"
  myParser.parse "foobar"
  # yay! it worked
```

## Goals

* Define PEG parsers 100% in JavaScript
* Runtime-extensible parsers
* Reasonably fast
* No globals - each parser instance parses in its own space

This is NOT a parser-generator. There is no pre-compile step. Unlike other PEG libraries, BB enables you to *create and extend parsers at runtime*.

## Features

* Full parsing expression grammer support with memoizing
* Full JavaScript regular expressions support for terminals
* Simple, convention-over-configuration parse-tree class structure
* Human-readable parse-tree dumps
* Detailed information about parsing failures
* Custom sub-parser hooks
  * Which enable indention-based block parsing for languages like Python, CoffeeScript, or my own CaffeineScript
