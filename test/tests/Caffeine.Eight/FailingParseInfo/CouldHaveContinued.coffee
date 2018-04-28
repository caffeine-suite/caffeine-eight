{Parser, CaffeineEightCompileError, Extensions} = Neptune.Caffeine.Eight
{log, defineModule, l, w, compactFlatten} = Neptune.Art.StandardLib

validateCompileError = (error, testProps) ->
  assert.instanceof CaffeineEightCompileError, error
  assert.selectedPropsEq testProps, error
  assert.match error.message, /<HERE>/

validateCompileError2 = (parser, text, testedProps) ->
  myParser = new parser
  assert.rejects -> myParser.parse text
  .then (error)->
    assert.instanceof CaffeineEightCompileError, error
    assert.selectedPropsEq testedProps, error
    assert.match error.message, /<HERE>/


defineModule module, suite:
  info: ->
    MyParser = null
    setup ->
      class MyParser extends Parser
        @rule
          root: "myRule+"
          myRule: /foo\n?/

    test "baseline ok", ->
      myParser = new MyParser
      # assert.rejects -> 123
      myParser.parse "foo"

    test "0", ->
      myParser = new MyParser
      assert.rejects -> myParser.parse "bad"
      .then (error)->
        validateCompileError error,
          failureIndex: 0
          line: 0
          column: 0


    test "line 1, col 3", ->
      myParser = new MyParser
      assert.rejects -> myParser.parse "foobad"
      .then (error)->
        validateCompileError error,
          failureIndex: 3
          line: 0
          column: 3
          location: ":1:4"

    test "line 2, col 1", ->
      myParser = new MyParser
      assert.rejects -> myParser.parse "foo\nbad"
      .then (error)->
        validateCompileError error,
          failureIndex: 4
          line: 1
          column: 0

    test "line 2, col 4", ->
      myParser = new MyParser
      # assert.rejects -> 123
      # myParser.parse "foo"
      assert.rejects ->
        myParser.parse "foo\nfoobar"
      .then (error)->
        validateCompileError error,
          failureIndex: 7
          line: 1
          column: 3

  infoOnNonFirstPattern: ->
    MyParser = null
    setup ->
      class MyParser extends Parser

        @rule
          root: 'number _ /[a-z]+/'
          number: /[0-9]+/
          _: /\s+/

    test "baseline", ->
      MyParser.parse "1 hi"

    test "fail on first pattern", ->
      validateCompileError2 MyParser, "- hi",
        failureIndex: 0
        line: 0
        column: 0
        expectingInfo: expecting: "/[0-9]+/": "to-continue": "root", "started-at": "1:1"

    test "fail on second pattern", ->
      validateCompileError2 MyParser, "1 HI",
        failureIndex: 2
        line: 0
        column: 2
        expectingInfo: expecting: "/[a-z]+/": "to-continue": "root", "started-at": "1:1"

  basic: ->
    test "no match at all simple", ->
      class MyParser extends Parser
        @rule
          root: "foo"
          foo: "bar"
          bar: /bar/

      myParser = new MyParser
      assert.rejects -> myParser.parse "bad"
      .then (error)->
        validateCompileError error,
          failureIndex: 0
          line: 0
          column: 0

        # log myParser.nonMatches
        assert.eq Object.keys(myParser.nonMatches).sort(), [
            "BarRuleBarVariant: /bar/"
          ]

  couldMatchKeys: ->
    test "no match at all", ->
      class MyParser extends Parser
        @rule
          root: "foo"
          foo: "bar? baz"
          bar: /bar/
          baz: /baz/

      myParser = new MyParser
      assert.rejects -> myParser.parse "bad"
      .then (error)->
        validateCompileError error,
          failureIndex: 0
          line: 0
          column: 0

        # log myParser.nonMatches
        assert.eq Object.keys(myParser.nonMatches).sort(), [
           "BarRuleBarVariant: /bar/"
           "BazRuleBazVariant: /baz/"
          ]

    test "partial match", ->
      class MyParser extends Parser
        @rule
          root: "foo"
          foo:  "duh? bar? baz"
          duh:  /duh/
          bar:  /bar/
          baz:  /baz/

      myParser = new MyParser
      assert.rejects -> myParser.parse "duhbad"
      .then (error)->
        validateCompileError error,
          failureIndex: 3
          line: 0
          column: 3

        # log myParser.nonMatches
        assert.eq Object.keys(myParser.nonMatches).sort(), [
            "BarRuleBarVariant: /bar/"
            'BazRuleBazVariant: /baz/'
          ]

  misc: ->

    test "nonMatches keys", ->
      class MyParser extends Parser
        @rule
          root: w "foo bar baz"
          foo: "'foo'"
          bar: /bar/
          baz: '"baz"'

      myParser = new MyParser
      assert.rejects -> myParser.parse "bad"
      .then (error)->
        validateCompileError error,
          failureIndex: 0
          line: 0
          column: 0

        # log myParser.nonMatches
        assert.eq Object.keys(myParser.nonMatches).sort(), [
            "BarRuleBarVariant: /bar/"
            'BazRuleBazVariant: "baz"'
            "FooRuleFooVariant: 'foo'"
          ]

    test "expectingInfo", ->
      class MyParser extends Parser
        @rule
          root: "foobarbaz foobarbaz"
          foobarbaz: w "foo bar baz"
          foo: "'foo'"
          bar: /bar/
          baz: '"baz"'

      myParser = new MyParser
      assert.rejects -> myParser.parse "barfo"
      .then (error)->
        validateCompileError error,
          failureIndex: 3
          line: 0
          column: 3

    test "matchingNegative", ->
      class MyParser extends Parser
        @rule
          root: "foobarbaz foobarbaz"
          foobarbaz: w "foo bar baz"
          foo: "'foo'"
          bar: /bar/
          baz: '!boo "baz"'
          boo: /boo/

      myParser = new MyParser
      assert.rejects -> myParser.parse "baz"
      .then (error)->
        validateCompileError error,
          failureIndex: 3
          line: 0
          column: 3
