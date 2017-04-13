{log, wordsArray} = Neptune.Art.StandardLib
{Parser, Nodes} = Neptune.BabelBridge
{Node} = Nodes

module.exports =suite:  ->
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
    myParser2.parse "bar"
    assert.throws -> myParser1.parse "bar"

  test "can add rules from instance", ->
    class MyParser extends Parser
      @rule root: "'foo'"

    myParser = new MyParser
    myParser.rule root: "'bar'"

    result = myParser.parse "bar"
    assert.eq result.offset, 0
    assert.eq result.matchLength, 3
    assert.eq result.text, "bar"
