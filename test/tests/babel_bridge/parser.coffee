Foundation = require 'art-foundation'
{log, wordsArray} = Foundation
{Parser, Nodes} = require 'babel-bridge'
{Node} = Nodes

suite "BabelBridge.Parser.terminal parsing", ->

  test "\"'foo'\"", ->
    class MyParser extends Parser
      @rule foo: "'foo'"

    myParser = new MyParser
    result = myParser.parse "foo"
    assert.eq result.offset, 0
    assert.eq result.matchLength, 3
    assert.eq result.text, "foo"

  test "/foo/", ->
    class MyParser extends Parser
      @rule foo: /foo/

    myParser = new MyParser
    result = myParser.parse "foo"
    assert.eq result.offset, 0
    assert.eq result.matchLength, 3
    assert.eq result.text, "foo"

  test "/[0-9]+/", ->
    class MyParser extends Parser
      @rule foo: /[0-9]+/

    for source in sources = wordsArray "0 1 10 123 1001"
      result = MyParser.parse source
      assert.eq result.offset, 0
      assert.eq result.matchLength, source.length
      assert.eq result.text, source

  test "match /[0-9]+/ -- doesn't match if not at the start of the string", ->
    class MyParser extends Parser
      @rule foo: /[0-9]+/

    assert.throws -> MyParser.parse " 0123"

suite "BabelBridge.Parser.sequence parsing", ->

  test "'foo' /bar/", ->
    class MyParser extends Parser
      @rule foo: "'foo' /bar/"

    myParser = new MyParser
    result = myParser.parse "foobar"
    assert.eq result.offset, 0
    assert.eq result.matchLength, 6
    assert.eq result.text, "foobar"


  test "/foo/ /bar/", ->
    class MyParser extends Parser
      @rule foo: "/foo/ /bar/"

    myParser = new MyParser
    result = myParser.parse "foobar"
    assert.eq result.offset, 0
    assert.eq result.matchLength, 6
    assert.eq result.text, "foobar"

  test "/foo/ bar", ->
    class MyParser extends Parser
      @rule
        foo: '/foo/ bar'
        bar: /bar/

    myParser = new MyParser
    result = myParser.parse "foobar"
    assert.eq result.offset, 0
    assert.eq result.matchLength, 6
    assert.eq result.text, "foobar"

suite "BabelBridge.Parser.conditional parsing", ->

  test "conditional rule 'foo? bar'", ->
    class MyParser extends Parser
      @rule
        main: "foo? bar"
        bar: /bar/
        foo: /foo/

    MyParser.parse "bar"
    MyParser.parse "foobar"

  test "conditional regExp '/foo/? bar'", ->
    class MyParser extends Parser
      @rule
        main: "/foo/? bar"
        bar: /bar/

    MyParser.parse "bar"
    MyParser.parse "foobar"

suite "BabelBridge.Parser.negative parsing", ->

  test "!boo anything", ->
    class MyParser extends Parser
      @rule
        main: "!boo anything"
        boo: /boo/
        anything: /.*/

     assert.throws -> MyParser.parse "boo"
     assert.throws -> MyParser.parse "boobat"
     MyParser.parse "bobat"

suite "BabelBridge.Parser.couldMatch parsing", ->

  test "!boo anything", ->
    class MyParser extends Parser
      @rule
        main: "boo &foo rest"
        boo: /boo/
        foo: /foo/
        rest: /fo[a-z]+/

     MyParser.parse "boofoo"
     assert.throws -> MyParser.parse "boofoa"

suite "BabelBridge.Parser.rule variants", ->
  test "two variants", ->
    class MyParser extends Parser
      @rule main: /boo/
      @rule main: /foo/

    MyParser.parse "boo"
    MyParser.parse "foo"

suite "BabelBridge.Parser.many parsing", ->

  test "boo*", ->
    class MyParser extends Parser
      @rule
        main: 'boo*'
        boo: /boo/

    MyParser.parse ""
    MyParser.parse "boo"
    MyParser.parse "booboo"

  test "boo+", ->
    class MyParser extends Parser
      @rule
        main: 'boo+'
        boo: /boo/

    assert.throws -> MyParser.parse ""
    MyParser.parse "boo"
    MyParser.parse "booboo"

suite "BabelBridge.Parser.custom parser", ->
  test "basic", ->
    class MyParser extends Parser
      @rule
        main:
          parse: (parentNode) ->
            {nextOffset, source} = parentNode
            if source[nextOffset] == "a"
              new Node parentNode,
                offset: nextOffset
                matchLength: 1
                ruleVariant: @

    MyParser.parse "a"
    assert.throws -> MyParser.parse "A"
