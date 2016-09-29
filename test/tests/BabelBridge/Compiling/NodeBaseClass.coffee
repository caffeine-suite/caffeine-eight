Foundation = require 'art-foundation'
{log, wordsArray} = Foundation
{Parser, Nodes} = require 'babel-bridge'
{Node} = Nodes

module.exports = suite: ->

  test "one node with custom node class", ->
    class IndentBlocksNode extends Node

      toJs: -> @toString() + "!"

    class MyParser extends Parser
      @nodeBaseClass: IndentBlocksNode

      @rule
        root: /boo/

    mainNode = MyParser.parse "boo"
    assert.eq mainNode.toJs(), "boo!"
