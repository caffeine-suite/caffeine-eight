{log, a, w, m, upperCamelCase, lowerCamelCase} = Neptune.Art.StandardLib
{Parser, Nodes} = Neptune.BabelBridge
{Node} = Nodes

module.exports = suite: ->
  MyParser = null
  setup ->

    class MyParser extends Parser
      @nodeBaseClass: class MyNode extends Node
        compile: -> (a.compile() for a in @matches when a.compile).join ''

      @rule
        root: "noun _ verb _ noun"

        _: pattern: / +/, compile: -> " "

        noun: w "bugs butterflies"

      @rule
        bugs: /bugs|ladybugs|beetles/i
        butterflies: /butterflies|skippers|swallowtails/i
      ,
        compile: -> upperCamelCase @toString()

      @rule
        verb:
          pattern: /eat|shun/i
          compile: -> lowerCamelCase @toString()

  test "one rule multiple patters shares a nodeBaseClass", ->
    mainNode = MyParser.parse "ladybugs eat beetles"
    assert.eq mainNode.compile(), "Ladybugs eat Beetles"

  test "case insensitive", ->
    mainNode = MyParser.parse "ladybugs EAT beetles"
    assert.eq mainNode.compile(), "Ladybugs eat Beetles"
