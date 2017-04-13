{log, wordsArray} = Neptune.Art.StandardLib
{Parser, Nodes} = Neptune.BabelBridge

module.exports = suite: ->

  test "three different labels", ->
    class MyParser extends Parser
      @rule
        root:
          pattern: """
            a:'eh'?
            b:'bee'?
            c:'cee'?
            """
          nodeClass:
            result: ->
              a: @a?.text
              b: @b?.text
              c: @c?.text

    mainNode = MyParser.parse "ehcee"
    assert.eq mainNode.result(), a: "eh", b: undefined, c: "cee"

  test "three same labels", ->
    class MyParser extends Parser
      @rule
        root:
          pattern: """
            a:'eh'?
            a:'bee'?
            a:'cee'?
            """
          nodeClass:
            result: ->
              a: @a.text
              "matches.a": (match.text for match in @as)

    mainNode = MyParser.parse "ehcee"
    assert.eq mainNode.result(), a: "cee", "matches.a": ["eh", "cee"]
