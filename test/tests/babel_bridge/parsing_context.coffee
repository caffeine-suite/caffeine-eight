Foundation = require 'art-foundation'
{log, wordsArray} = Foundation
{Parser, Nodes} = require 'babel-bridge'
{EmptyNode, TerminalNode} = Nodes

suite "BabelBridge.Parser.parsing context", ->

  test "reverseEachMatchedNodeSoFar at the end", ->
    class MyParser extends Parser
      @rule
        main: "/boo/ /[a-z]+/"

    parser = new MyParser
    parser.parse "boowho"
    list = []
    parser.reverseEachMatchedNodeSoFar (node) -> list.push node.text
    assert.eq list, ["who", "boo"]

  test "reverseEachMatchedNodeSoFar in the middle", ->
    list = []
    class MyParser extends Parser
      @rule
        main: "a b c"
        a: /eh/
        b:
          parse: (parentNode) ->
            parentNode.parser.reverseEachMatchedNodeSoFar (node) ->
              list.push node.text if node instanceof TerminalNode
              true
            new EmptyNode parentNode
        c: /cee/

    parser = new MyParser
    parser.parse "ehcee"
    assert.eq list, ["eh"]

