{log, w} = Neptune.Art.StandardLib
{Parser, Nodes} = Neptune.BabelBridge

module.exports = suite:
  regressions: ->

    test "cache and node mutations - or lack thereof soon", ->
      class MyParser extends Parser
        @rule
          root: w "doesntMatch1 doesntMatch2 doesMatch"

          doesntMatch1: "label ':('"
          doesntMatch2: "bad:identifier ':('"
          doesMatch: "label ')'"
          label: "good:identifier ':'"
          identifier: /[_a-z0-9]+/i

      mainNode = MyParser.parse "boo:)"
      assert.eq "good", mainNode.matches[0].matches[0].matches[0].label
