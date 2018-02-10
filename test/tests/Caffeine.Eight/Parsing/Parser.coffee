{log, wordsArray} = Neptune.Art.StandardLib
{Parser, Nodes} = Neptune.Caffeine.Eight
{Node} = Nodes

module.exports = suite:
  basic: ->

    test "\"'foo'\"", ->
      class MyParser extends Parser
        @rule root: "'foo'"

      myParser = new MyParser
      result = myParser.parse "foo"
      assert.eq result.offset, 0
      assert.eq result.matchLength, 3
      assert.eq result.text, "foo"

    test "/foo/", ->
      class MyParser extends Parser
        @rule root: /foo/

      myParser = new MyParser
      result = myParser.parse "foo"
      assert.eq result.offset, 0
      assert.eq result.matchLength, 3
      assert.eq result.text, "foo"

    test "/[0-9]+/", ->
      class MyParser extends Parser
        @rule root: /[0-9]+/

      for source in sources = wordsArray "0 1 10 123 1001"
        result = MyParser.parse source
        assert.eq result.offset, 0
        assert.eq result.matchLength, source.length
        assert.eq result.text, source

    test "match /[0-9]+/ -- doesn't match if not at the start of the string", ->
      class MyParser extends Parser
        @rule foo: /[0-9]+/

      assert.throws -> MyParser.parse " 0123"

  "sequence parsing": ->

    test "'foo' /bar/", ->
      class MyParser extends Parser
        @rule root: "'foo' /bar/"

      myParser = new MyParser
      result = myParser.parse "foobar"
      assert.eq result.offset, 0
      assert.eq result.matchLength, 6
      assert.eq result.text, "foobar"


    test "/foo/ /bar/", ->
      class MyParser extends Parser
        @rule root: "/foo/ /bar/"

      myParser = new MyParser
      result = myParser.parse "foobar"
      assert.eq result.offset, 0
      assert.eq result.matchLength, 6
      assert.eq result.text, "foobar"

    test "/foo/ bar", ->
      class MyParser extends Parser
        @rule
          root: '/foo/ bar'
          bar: /bar/

      myParser = new MyParser
      result = myParser.parse "foobar"
      assert.eq result.offset, 0
      assert.eq result.matchLength, 6
      assert.eq result.text, "foobar"

  "conditional parsing": ->

    test "conditional rule 'foo? bar'", ->
      class MyParser extends Parser
        @rule
          root: "foo? bar"
          bar: /bar/
          foo: /foo/

      MyParser.parse "bar"
      MyParser.parse "foobar"

    test "conditional regExp '/foo/? bar'", ->
      class MyParser extends Parser
        @rule
          root: "/foo/? bar"
          bar: /bar/

      MyParser.parse "bar"
      MyParser.parse "foobar"

  "negative parsing": ->

    test "!boo anything", ->
      class MyParser extends Parser
        @rule
          root: "!boo anything"
          boo: /boo/
          anything: /.*/

       assert.throws -> MyParser.parse "boo"
       assert.throws -> MyParser.parse "boobat"
       MyParser.parse "bobat"

  "couldMatch parsing": ->

    test "couldMatch: 'boo &foo rest'", ->
      class MyParser extends Parser
        @rule
          root: "boo &foo rest"
          boo: /boo/
          foo: /foo/
          rest: /fo[a-z]+/

       MyParser.parse "boofoo"
       assert.throws -> MyParser.parse "boofoa"

  "rule variants": ->
    test "two variants", ->
      class MyParser extends Parser
        @rule root: /boo/
        @rule root: /foo/

      MyParser.parse "boo"
      MyParser.parse "foo"

  "many parsing": ->

    test "boo*", ->
      class MyParser extends Parser
        @rule
          root: 'boo*'
          boo: /boo/

      MyParser.parse ""
      MyParser.parse "boo"
      MyParser.parse "booboo"

    test "boo+", ->
      class MyParser extends Parser
        @rule
          root: 'boo+'
          boo: /boo/

      assert.throws -> MyParser.parse ""
      MyParser.parse "boo"
      MyParser.parse "booboo"

  "custom parser": ->
    test "basic", ->
      class MyParser extends Parser
        @rule
          root:
            parse: (parentNode) ->
              {nextOffset, source} = parentNode
              if source[nextOffset] == "a"
                new Node parentNode,
                  offset: nextOffset
                  matchLength: 1
                  ruleVariant: @

      MyParser.parse "a"
      assert.throws -> MyParser.parse "A"

    test "alternate custom parsers", ->
      class MyParser extends Parser
        @rule
          root: [
            {
              parse: (parentNode) ->
                {nextOffset, source} = parentNode
                if source[nextOffset] == "a"
                  new Node parentNode,
                    offset: nextOffset
                    matchLength: 1
                    ruleVariant: @
            }
            {
              parse: (parentNode) ->
                {nextOffset, source} = parentNode
                if source[nextOffset] == "b"
                  new Node parentNode,
                    offset: nextOffset
                    matchLength: 1
                    ruleVariant: @
            }
          ]

      MyParser.parse "a"
      MyParser.parse "b"
      assert.throws -> MyParser.parse "A"

  "prevent simple infinite loops": ->
    test "/foo/ /$/*", ->
      class MyParser extends Parser
        @rule
          root: "/foo/ /$/*"

      MyParser.parse "foo"

    test "/foo/ /$/+", ->
      class MyParser extends Parser
        @rule
          root: "/foo/ /$/+"

      MyParser.parse "foo"

  multiNotations: ->
    test "rule root: []", ->
      class MyParser extends Parser
        @rule
          root: [/foo/, /boo/]

      MyParser.parse "foo"
      MyParser.parse "boo"

    test "rule root: [..., {}]", ->
      class MyParser extends Parser
        @rule
          root: [
            /foo/
            /boo/
            custom: -> @text.toUpperCase()
          ]

      assert.eq "FOO", MyParser.parse("foo").custom()
      assert.eq "BOO", MyParser.parse("boo").custom()

    test "rule root: pattern: [], ...", ->
      class MyParser extends Parser
        @rule
          root:
            pattern: [
              /foo/
              /boo/
            ]
            custom: -> @text.toUpperCase()

      assert.eq "FOO", MyParser.parse("foo").custom()
      assert.eq "BOO", MyParser.parse("boo").custom()
