{log, wordsArray} = Neptune.Art.StandardLib
{Parser, Nodes} = Neptune.Caffeine.Eight

module.exports = suite: ->

  test "one node with custom node class", ->
    class MyParser extends Parser
      @rule
        root:
          pattern: /boo/
          myMember: -> 123

    mainNode = MyParser.parse "boo"
    assert.eq mainNode.myMember(), 123

  test "multi-pattern type 1", ->
    class MyParser extends Parser
      @rule
        root: [
            /boo/
            /bad/
            myMember: -> 123
          ]

    mainNode = MyParser.parse "boo"
    assert.eq mainNode.myMember(), 123

    mainNode = MyParser.parse "bad"
    assert.eq mainNode.myMember(), 123


  test "multi-pattern type 2", ->
    class MyParser extends Parser
      @rule
        root: [
          /boo/
          /bad/
          myMember: -> 123
        ]

    mainNode = MyParser.parse "boo"
    assert.eq mainNode.myMember(), 123

    mainNode = MyParser.parse "bad"
    assert.eq mainNode.myMember(), 123

  test "simple math", ->
    class MyParser extends Parser
      @rule root:
        pattern: "expression"
        compute: -> @expression.compute()

      @rule expression:
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
