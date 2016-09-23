{Parser} = Neptune.BabelBridge
{log, defineModule, l, w} = Neptune.Art.Foundation

defineModule module, suite: ->
  test "nonMatchingVariants only includes token-patterns", ->
    class MyParser extends Parser
      @rule
        root: w "foo bar baz"
        foo: "'foo'"
        bar: /bar/
        baz: '"baz"'

    myParser = new MyParser
    assert.rejects -> myParser.parse "bad"
    .then ->
      assert.eq Object.keys(myParser.nonMatchingVariants).sort(), [
          "BarRuleBarVariant: /bar/"
          "BazRuleBazVariant: \"baz\""
          "FooRuleFooVariant: 'foo'"
        ]

