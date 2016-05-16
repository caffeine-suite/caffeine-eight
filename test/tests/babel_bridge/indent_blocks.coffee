Foundation = require 'art-foundation'
{log, wordsArray} = Foundation
{Parser, Nodes} = require 'babel-bridge'
{TerminalNode} = Nodes

suite "BabelBridge.Parser.indent block parsing", ->

  test "blocks with intent parsing", ->
    class MyParser extends Parser
      @rule
        main: "statement"

      @rule statement: "ifBlock"
      @rule statement: /statement/

      @rule _: / +/

      @rule
        ifBlock: "'if' _ /true|false/ _? block"

        block: "indent statement _? blockLine* outdent"

        blockLine: "samedent statement _?"

      class IndentNode extends TerminalNode

      @rule
        indent:
          pattern: /\n  /
          node: IndentNode
        samedent:
          pattern: /\n  /
          node: IndentNode
        outdent:
          pattern: /$|\n(\n|$)/
          node: IndentNode

    MyParser.parse """
      if true
        statement
      """
