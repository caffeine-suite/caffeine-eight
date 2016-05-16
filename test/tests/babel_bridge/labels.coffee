Foundation = require 'art-foundation'
{log, wordsArray} = Foundation
{Parser, Nodes} = require 'babel-bridge'
{TerminalNode} = Nodes

suite "BabelBridge.Parser.labels", ->

  test "three different labels", ->
    class MyParser extends Parser
      @rule
        main:
          pattern: """
            a:'eh'?
            b:'bee'?
            c:'cee'?
            """
          node:
            result: ->
              a: @a?.text
              b: @b?.text
              c: @c?.text

    mainNode = MyParser.parse "ehcee"
    assert.eq mainNode.result(), a: "eh", b: undefined, c: "cee"

  test "three same labels", ->
    class MyParser extends Parser
      @rule
        main:
          pattern: """
            a:'eh'?
            a:'bee'?
            a:'cee'?
            """
          node:
            result: ->
              a: @a.text
              "matches.a": (match.text for match in @matches.a)

    mainNode = MyParser.parse "ehcee"
    assert.eq mainNode.result(), a: "cee", "matches.a": ["eh", "cee"]
