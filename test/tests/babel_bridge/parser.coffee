Foundation = require 'art-foundation'
{log} = Foundation
{Parser} = require 'babel-bridge'

newParser = (f) ->
  class TestParser extends Parser

suite "BabelBridge.Parser.basic parsing", ->
  test "string literal", ->
    class MyParser extends Parser
      @rule "foo", "foo"

    myParser = new MyParser
    myParser.parse "foo"
    .then (result) ->
      log result: result
      assert.eq result.offset, 0
      assert.eq result.matchLength, 3
      assert.eq result.text, "foo"
