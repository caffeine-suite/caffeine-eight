Foundation = require 'art-foundation'
{log, wordsArray} = Foundation
{Parser, Nodes} = require 'babel-bridge'
{TerminalNode} = Nodes

suite "BabelBridge.Parser.terminal parsing", ->

  test "\"'foo'\"", ->
    class MyParser extends Parser
      @rule foo: "'foo'"

    myParser = new MyParser
    myParser.parse "foo"
    .then (result) ->
      assert.eq result.offset, 0
      assert.eq result.matchLength, 3
      assert.eq result.text, "foo"

  test "/foo/", ->
    class MyParser extends Parser
      @rule foo: /foo/

    myParser = new MyParser
    myParser.parse "foo"
    .then (result) ->
      assert.eq result.offset, 0
      assert.eq result.matchLength, 3
      assert.eq result.text, "foo"

  test "/[0-9]+/", ->
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

suite "BabelBridge.Parser.sequence parsing", ->

  test "'foo' /bar/", ->
    class MyParser extends Parser
      @rule foo: "'foo' /bar/"

    myParser = new MyParser
    myParser.parse "foobar"
    .then (result) ->
      assert.eq result.offset, 0
      assert.eq result.matchLength, 6
      assert.eq result.text, "foobar"


  test "/foo/ /bar/", ->
    class MyParser extends Parser
      @rule foo: "/foo/ /bar/"

    myParser = new MyParser
    myParser.parse "foobar"
    .then (result) ->
      assert.eq result.offset, 0
      assert.eq result.matchLength, 6
      assert.eq result.text, "foobar"

  test "/foo/ bar", ->
    class MyParser extends Parser
      @rule
        foo: '/foo/ bar'
        bar: /bar/

    myParser = new MyParser
    myParser.parse "foobar"
    .then (result) ->
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

    Promise.all [
      (new MyParser).parse "bar"
      (new MyParser).parse "foobar"
    ]

  test "conditional regExp '/foo/? bar'", ->
    class MyParser extends Parser
      @rule
        main: "/foo/? bar"
        bar: /bar/

    Promise.all [
      (new MyParser).parse "bar"
      (new MyParser).parse "foobar"
    ]

suite "BabelBridge.Parser.negative parsing", ->

  test "!boo anything", ->
    class MyParser extends Parser
      @rule
        main: "!boo anything"
        boo: /boo/
        anything: /.*/

    Promise.all [
      (new MyParser).parse("boo").then (-> throw "should not have parsed"), ->
      (new MyParser).parse("boobat").then (-> throw "should not have parsed"), ->
      (new MyParser).parse("bobat")
    ]

suite "BabelBridge.Parser.rule variants", ->
  test "two variants", ->
    class MyParser extends Parser
      @rule main: /boo/
      @rule main: /foo/

    Promise.all [
      (new MyParser).parse "boo"
      (new MyParser).parse "foo"
    ]

suite "BabelBridge.Parser.many parsing", ->

  test "boo*", ->
    class MyParser extends Parser
      @rule
        main: 'boo*'
        boo: /boo/

    Promise.all [
      (new MyParser).parse ""
      (new MyParser).parse "boo"
      (new MyParser).parse "booboo"
    ]

  test "boo+", ->
    class MyParser extends Parser
      @rule
        main: 'boo+'
        boo: /boo/

    Promise.all [
      ((new MyParser).parse "").then (-> throw "should not have parsed"), ->
      (new MyParser).parse "boo"
      (new MyParser).parse "booboo"
    ]

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

    ((new MyParser).parse "ehcee")
    .then (mainNode) ->
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

    ((new MyParser).parse "ehcee")
    .then (mainNode) ->
      assert.eq mainNode.result(), a: "cee", "matches.a": ["eh", "cee"]

suite "BabelBridge.Parser.custom parser", ->
  test "with oneOrMore", ->
    class MyParser extends Parser
      @rule
        main:
          oneOrMore: true
          parse: (parentNode) ->
            {nextOffset, source} = parentNode
            if source[nextOffset]?.match /[a-z]/
              new TerminalNode parentNode,
                nextOffset
                1
                "custom"

    ((new MyParser).parse "abc")
    .then (mainNode) ->
      ((new MyParser).parse "A")
      .then (mainNode) ->
        throw new Error "shouldn't match"
      , ->

suite "BabelBridge.Parser.custom node classes", ->

  test "one node with custom node class", ->
    class MyParser extends Parser
      @rule
        main:
          pattern: /boo/
          node:
            myMember: -> 123

    ((new MyParser).parse "boo")
    .then (mainNode) ->
      assert.eq mainNode.myMember(), 123

  test "simple math", ->
    class MyParser extends Parser
      @rule expression:
        pattern: "n:number '+' expression"
        node: compute: -> @n.compute() + @expression.compute()

      @rule expression:
        pattern: "number"
        node: compute: -> @number.compute()

      @rule number:
        pattern: /[0-9]+/
        node: compute: -> @text | 0

    ((new MyParser).parse "123+321+111")
    .then (mainNode) -> assert.eq mainNode.compute(), 555
