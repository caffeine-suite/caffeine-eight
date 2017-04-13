{log, wordsArray} = Neptune.Art.StandardLib
{Parser, Nodes} = Neptune.BabelBridge
{Node} = Nodes

module.exports = suite: ->

  test "with class", ->

    class MyParser extends Parser
      @nodeBaseClass: class IndentBlocksNode extends Node
        toJs: -> @toString() + "!"

      @rule
        root: /boo/

    mainNode = MyParser.parse "boo"
    assert.eq mainNode.toJs(), "boo!"

  test "with plainObject", ->
    class MyParser extends Parser
      @nodeBaseClass:
        toJs: -> @toString() + "!"

      @rule
        root: /boo/

    mainNode = MyParser.parse "boo"
    assert.eq mainNode.toJs(), "boo!"
