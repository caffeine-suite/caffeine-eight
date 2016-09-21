Foundation = require 'art-foundation'
{log, wordsArray} = Foundation
{Parser, Nodes} = require 'babel-bridge'

suite "BabelBridge.Parser.custom node classes", ->

  test "one node with custom node class", ->
    class MyParser extends Parser
      @rule
        root:
          pattern: /boo/
          myMember: -> 123

    mainNode = MyParser.parse "boo"
    assert.eq mainNode.myMember(), 123

  test "simple math", ->
    class MyParser extends Parser
      @rule expression:
        root: true
        pattern: "n:number '+' expression"
        compute: -> @n.compute() + @expression.compute()

      @rule expression:
        pattern: "number"
        compute: -> @number.compute()

      @rule number:
        pattern: /[0-9]+/
        compute: -> @text | 0

    mainNode = MyParser.parse "123+321+111"
    assert.eq mainNode.compute(), 555
