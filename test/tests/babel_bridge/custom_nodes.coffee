Foundation = require 'art-foundation'
{log, wordsArray} = Foundation
{Parser, Nodes} = require 'babel-bridge'
{TerminalNode} = Nodes

suite "BabelBridge.Parser.custom node classes", ->

  test "one node with custom node class", ->
    class MyParser extends Parser
      @rule
        main:
          pattern: /boo/
          node:
            myMember: -> 123

    mainNode = MyParser.parse "boo"
    assert.eq mainNode.myMember(), 123

  test "simple math", ->
    class MyParser extends Parser
      @rule expression:
        pattern: "n:number '+' expression"
        node: compute: -> @n.compute() + @expression.compute()

      @rule expression:
        pattern: "number"
        node: compute: -> @number.compute()

      @rule number:
        pattern: /[0-9]+/
        node: compute: -> @text | 0

    mainNode = MyParser.parse "123+321+111"
    assert.eq mainNode.compute(), 555
