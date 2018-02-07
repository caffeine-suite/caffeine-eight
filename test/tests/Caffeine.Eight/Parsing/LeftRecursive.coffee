{defineModule, log, wordsArray} = Neptune.Art.StandardLib
{Parser, Nodes} = Neptune.Caffeine.Eight

defineModule module, suite:
  simplest: ->
    test "depth 1", ->
      class MyLeftRecursiveParser extends Parser
        @rule
          root: "leftRecursiveRule"

          leftRecursiveRule: [
            "leftRecursiveRule '.'"
            "'&'"
          ]

      p = new MyLeftRecursiveParser

      assert.rejects -> p.parse "&."

    test "depth 2", ->
      class MyLeftRecursiveParser extends Parser
        @rule
          root: "leftRecursiveRule"

          leftRecursiveRule: [
            "leftRecursiveRule '.'"
            "'&'"
          ]

      p = new MyLeftRecursiveParser

      assert.rejects -> p.parse "&.."