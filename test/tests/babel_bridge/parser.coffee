Foundation = require 'art-foundation'
{log, wordsArray} = Foundation
{Parser} = require 'babel-bridge'

newParser = (f) ->
  class TestParser extends Parser

suite "BabelBridge.Parser.basic parsing", ->

  test "match 'foo'", ->
    class MyParser extends Parser
      @rule "foo", "foo"

    myParser = new MyParser
    myParser.parse "foo"
    .then (result) ->
      assert.eq result.offset, 0
      assert.eq result.matchLength, 3
      assert.eq result.text, "foo"

  test "match /[0-9]+/", ->
    class MyParser extends Parser
      @rule "foo", /[0-9]+/

    promises = for source in sources = wordsArray "0 1 10 123 1001"
      (new MyParser).parse source
    Promise.all(promises)
    .then (results) ->
      for result, i in results
        source = sources[i]
        assert.eq result.offset, 0
        assert.eq result.matchLength, source.length
        assert.eq result.text, source
