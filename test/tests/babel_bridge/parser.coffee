Foundation = require 'art-foundation'
{log, wordsArray} = Foundation
{Parser} = require 'babel-bridge'

suite "BabelBridge.Parser.basic parsing", ->

  test "basic regex /foo/", ->
    class MyParser extends Parser
      @rule foo: /foo/

    myParser = new MyParser
    myParser.parse "foo"
    .then (result) ->
      assert.eq result.offset, 0
      assert.eq result.matchLength, 3
      assert.eq result.text, "foo"

  test "two regex sequence /foo/, /bar/", ->
    class MyParser extends Parser
      @rule foo: [/foo/, /bar/]

    myParser = new MyParser
    myParser.parse "foobar"
    .then (result) ->
      assert.eq result.offset, 0
      assert.eq result.matchLength, 6
      assert.eq result.text, "foobar"

  test "regex and rule /foo/, 'bar'", ->
    class MyParser extends Parser
      @rule
        foo: [/foo/, "bar"]
        bar: /bar/

    myParser = new MyParser
    myParser.parse "foobar"
    .then (result) ->
      assert.eq result.offset, 0
      assert.eq result.matchLength, 6
      assert.eq result.text, "foobar"

  test "dynamic regex /[0-9]+/", ->
    class MyParser extends Parser
      @rule foo: /[0-9]+/

    promises = for source in sources = wordsArray "0 1 10 123 1001"
      (new MyParser).parse source
    Promise.all(promises)
    .then (results) ->
      for result, i in results
        source = sources[i]
        assert.eq result.offset, 0
        assert.eq result.matchLength, source.length
        assert.eq result.text, source

  test "match /[0-9]+/ -- doesn't match if not at the start of the string", ->
    class MyParser extends Parser
      @rule foo: /[0-9]+/

    (new MyParser).parse " 0123"
    .then ->
      throw new Error "shouldn't succeed"
    , ->
      "should fail"
