{Parser} = Neptune.BabelBridge
{log, defineModule, l, w, compactFlatten} = Neptune.Art.Foundation

defineModule module, suite: ->
  test "nonMatches keys", ->
    class MyParser extends Parser
      @rule
        root: w "foo bar baz"
        foo: "'foo'"
        bar: /bar/
        baz: '"baz"'

    myParser = new MyParser
    assert.rejects -> myParser.parse "bad"
    .then ->
      log myParser.nonMatches
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
    .then ->
      log myParser.parseFailureInfo

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
    .then ->
      # log myParser.expectingInfo
      log compactFlatten(myParser.expectingInfo).join "\n"
