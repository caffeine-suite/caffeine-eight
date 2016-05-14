# BabelBridgeJS

It's Babel-Bridge for JavaScript / CoffeeScript!

## Examples

```coffeescript
  class MyParser extends BabelBridge.Parser
    @rule foo: /foo/

  myParser = new MyParser
  myParser.parse "foo"
  .then (fooNode) ->
    # yay! it worked
```
