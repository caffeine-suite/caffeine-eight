{Parser, BabelBridgeCompileError} = Neptune.BabelBridge
{log, defineModule, l, w, compactFlatten} = Neptune.Art.StandardLib

validateCompileError = (error, testProps) ->
  assert.instanceof BabelBridgeCompileError, error
  assert.selectedPropsEq testProps, error
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
          line: 1
          column: 1

    test "line 1, col 3", ->
      myParser = new MyParser
      assert.rejects -> myParser.parse "foobad"
      .then (error)->
        validateCompileError error,
          failureIndex: 3
          line: 1
          column: 4

    test "line 2, col 1", ->
      myParser = new MyParser
      assert.rejects -> myParser.parse "foo\nbad"
      .then (error)->
        validateCompileError error,
          failureIndex: 4
          line: 2
          column: 1

    test "line 2, col 4", ->
      myParser = new MyParser
      # assert.rejects -> 123
      # myParser.parse "foo"
      assert.rejects ->
        myParser.parse "foo\nfoobar"
      .then (error)->
        validateCompileError error,
          failureIndex: 7
          line: 2
          column: 4

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
          line: 1
          column: 1

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
          line: 1
          column: 4

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
          line: 1
          column: 4
