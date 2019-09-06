{log, wordsArray} = Neptune.Art.StandardLib
{Parser, Nodes} = Neptune.Caffeine.Eight
{Node} = Nodes

module.exports = suite:
  basic: ->
    MyParser = MySubParser = null
    setup ->
      class MyParser extends Parser
        @rule root: "'foo'"

      class MySubParser extends MyParser
        @rule root: "'bar'"

    test "parsers are extensible", ->
      myParser = new MySubParser
      myParser.parse "bar"
      myParser.parse "foo"

    test "parsers extentension doesn't alter parent class", ->
      myParser1 = new MyParser
      myParser2 = new MySubParser
      assert.throws -> myParser1.parse "bar"
      assert.true   !!myParser2.parse "bar"

    test "can add rules from instance", ->
      class MyParser extends Parser
        @rule root: "'foo'"

      myParser = new MyParser
      myParser.rule root: "'bar'"

      result = myParser.parse "bar"
      assert.eq result.offset, 0
      assert.eq result.matchLength, 3
      assert.eq result.text, "bar"

  priorityRule: ->

    test "parsers are extensible", ->
      class MyParser extends Parser
        @rule root: "'foo' 'o'?"

      class MyNormalSubParser extends MyParser
        @rule root: "'fooo'"

      class MyPrioritySubParser extends MyParser
        @priorityRule root: "'fooo'"

      assert.eq 2,
        (new MyParser)
        .parse "fooo"
        .matches.length
        "MyParser"

      assert.eq 2,
        (new MyNormalSubParser)
        .parse "fooo"
        .matches.length
        "MyNormalSubParser"

      assert.eq 1,
        (new MyPrioritySubParser)
        .parse "fooo"
        .matches.length
        "MyPrioritySubParser"

  replaceRule: ->

    test "parsers are extensible", ->
      class MyParser extends Parser
        @rule root: /foo/

      class MyReplaceSubParser extends MyParser
        @replaceRule root: /bar/

      (new MyParser).parse "foo"
      assert.throws -> (new MyParser).parse "bar"

      (new MyReplaceSubParser).parse "bar"
      assert.throws -> (new MyReplaceSubParser).parse "foo"

