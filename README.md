## BabelBridgeJS

* Create parsers with ease 100% in JavaScript, or better yet, CoffeeScript!
* Powered by [Parsing Expression Grammars](https://en.wikipedia.org/wiki/Parsing_expression_grammar)

This is inspired by my Babel Bridge Ruby library: http://babel-bridge.rubyforge.org/index.html. However, I've learned a few things, and the JavaScript version is turning out to be an even better way to write parsers.

#### Example:

```coffeescript
  BabelBridge = require 'babel-bridge'
  class MyParser extends BabelBridge.Parser
    @rule foo: /foo/

  myParser = new MyParser
  rootNode = myParser.parse "foo"
  # yay! it worked
```

## Goals

* Define parsers 100% in JavaScript
* Runtime-extensible parsers
* Reasonably fast

This is NOT a parser-generator. There is no pre-compile step. BB enables you to *create and extend* parsers at runtime.
