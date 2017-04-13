{w, array, log, a, peek, shallowClone, compactFlatten} = Neptune.Art.StandardLib
{Parser, Nodes, Extensions} = Neptune.BabelBridge
{Node} = Nodes

module.exports = suite:
  blockParsing: ->
    MyParser = null
    setup ->
      class MyParser extends Parser

        @rule
          root: 'line+'
          line: [
            '/!!!/'
            'end'
            'expression block? end'
          ]
          expression: '/[a-z0-9A-Z]+/'
          end: '/\n|$/'

          block: Extensions.IndentBlocks.getPropsToSubparseBlock()

    test "simple expression", ->
      MyParser.parse "one"

    test "one block", ->
      MyParser.parse """
        one
          two
        """

    test "nested blocks", ->
      MyParser.parse """
        one
          two
            three
        """

    suite "failure location", ->
      suite 'baseline without block', ->
        test "before first line", ->
          parser = new MyParser
          assert.rejects -> parser.parse """
            -abc
            """
          .then (rejectsWith) ->
            # log {rejectsWith, parser}
            assert.eq parser._failureIndex, 0

        test "first line", ->
          parser = new MyParser
          assert.rejects -> parser.parse """
            abc-
            """
          .then (rejectsWith) ->
            # log {rejectsWith, parser}
            assert.eq parser._failureIndex, 3

        test "second line", ->
          parser = new MyParser
          assert.rejects -> parser.parse """
            abc
            foo-
            """
          .then (rejectsWith) ->
            # log {rejectsWith, parser}
            assert.eq parser._failureIndex, 7

      suite 'in block', ->
        test "before line", ->
          parser = new MyParser
          assert.rejects -> parser.parse """
            abc
              -def
              foos
            """
          .then (rejectsWith) ->
            # log {rejectsWith, parser}
            assert.eq parser._failureIndex, 6

        test "first line", ->
          parser = new MyParser
          assert.rejects -> parser.parse """
            abc
              def-
              foos
            """
          .then (rejectsWith) ->
            # log {rejectsWith, parser}
            assert.eq parser._failureIndex, 9

        test "second line", ->
          parser = new MyParser
          assert.rejects -> parser.parse """
            abc
              def
              foos-
            """
          .then (rejectsWith) ->
            # log {rejectsWith, parser}
            assert.eq parser._failureIndex, 16

      suite "in nested block", ->
        test "first line", ->
          parser = new MyParser
          assert.rejects -> parser.parse """
            abc
              def
                dood-
              foos
            """
          .then (rejectsWith) ->
            # log {rejectsWith, parser}
            assert.eq parser._failureIndex, 18

        test "second line", ->
          parser = new MyParser
          assert.rejects -> parser.parse """
            abc
              def2
                dood
                goof-
              foos
            """
          .then (rejectsWith) ->
            # log {rejectsWith, parser}
            assert.eq parser._failureIndex, 28

  eolOrblockParsing: ->
    MyParser = null
    setup ->
      class MyParser extends Parser

        @rule
          root: 'expression block? end'
          expression: '/[a-z0-9A-Z]+/'
          end: '/\n|$/'

          block: Extensions.IndentBlocks.getPropsToSubparseToEolAndBlock()

    test "simple expression", ->
      MyParser.parse "one"

    test "simple block", ->
      MyParser.parse """
        one
          two
        """

    test "simple eol", ->
      MyParser.parse """
        one two
        """

    test "nested blocks", ->
      MyParser.parse """
        one
          two
            three
        """

    test "nested eols", ->
      MyParser.parse """
        one two three
        """

    test "nested eols and blocks", ->
      MyParser.parse """
        one two
          three
        """

  CaffeineScriptObjectNotation: ->
    IndentBlocksNode = MyParser = null

    setup ->

      class IndentBlocksNode extends Node

        toJs: ->
          for match in @matches when match.toJs
            return match.toJs()
          log "no matches have toJs": self: @, class: @class, matches: @matches, parseTreePath: @parseTreePath
          throw new Error "no matches have toJs"

      class MyParser extends Parser
        @nodeBaseClass: IndentBlocksNode


        @rules
          root: 'statement+'
          block: Extensions.IndentBlocks.getPropsToSubparseBlock()

          expression: w 'object array block literal'

          literal:
            pattern: w 'string number'
            toJs: -> @text

          end:              ['block end', '/\n+|$/']
          statement:        ['objectStatement end', 'expression end']
          string:           /"([^"]|\\.)*"/
          number:           /-?(\.[0-9]+|[0-9]+(\.[0-9]+)?)/

          array: a
            pattern: "'[]' block"
            toJs: ->
              "[#{(node.toJs() for node in @block.statements).join ', '}]"
            {
              pattern: "'[]' _? arrayElementWithDelimiter* expression"
              toJs: -> "[#{(node.toJs() for node in compactFlatten [@arrayElementWithDelimiters, @expression]).join ', '}]"
            }
            {
              pattern: "'[]'"
              toJs: -> @text
            }

          arrayElementWithDelimiter: "expression _? ',' _?"

          object: [
            "'{}' block"
            pattern: "'{}'? _? objectPropList"
            toJs: -> (@objectPropList || @block).toJs()
          ]

          objectStatement:
            pattern: "objectProp objectPropLine*"
            toJs: -> "{#{(m.toJs() for m in compactFlatten [@objectProp, @objectPropLines]).join ', '}}"

          objectPropLine:
            pattern: "end objectProp"
            toJs: -> @objectProp.toJs()

          objectPropList:
            pattern: "objectProp objectPropListItem*"
            toJs: -> "{#{(m.toJs() for m in compactFlatten [@objectProp, @objectPropListItems]).join ', '}}"

          objectPropListItem:
            pattern: '"," _? objectProp'
            toJs: -> @objectProp.toJs()

          objectProp:
            pattern: 'objectPropLabel _? colon _? expression'
            toJs: -> "#{@objectPropLabel}: #{@expression.toJs()}"

          commaOrEnd: ["',' _?", "end"]
          objectPropLabel:  /[_a-zA-Z][_a-zA-Z0-9.]*/
          colon:            /\:/
          _:                / +/

    suite "parsing literals", ->
      test "string expression", ->
        MyParser.parse '"hi"'

      test "number expression", ->
        MyParser.parse '.1'
        MyParser.parse '0.1'
        MyParser.parse '0'
        MyParser.parse '-100'

    suite "parsing objects", ->
      test "one line", ->
        MyParser.parse 'hi:123'
        MyParser.parse 'hi:123, bye:345'

      test "object expression", ->
        MyParser.parse 'hi:123'
        MyParser.parse """
          hi:    123
          there: 456
          """

        MyParser.parse """
          {}
            hi:    123
            there: 456
          """

      test "nested object expression", ->
        MyParser.parse """
          hi:    123
          there:
            one: 123
            two: 456
          """

    suite "parsing arrays", ->
      test "array", ->
        MyParser.parse '[]'
        MyParser.parse '[] 1'
        MyParser.parse """
          []
            1
          """

    suite "toJs literals", ->
      test "string expression", ->
        assert.eq MyParser.parse('"hi"').toJs(), '"hi"'

    suite "toJs objects", ->
      test "simple", ->
        assert.eq MyParser.parse('hi: 123').toJs(), "{hi: 123}"

      test "object expression implicit one-liner", ->
        assert.eq MyParser.parse('hi: 123, bye:456').toJs(), "{hi: 123, bye: 456}"

      test "object expression explicit one-liner", ->
        assert.eq MyParser.parse('{} hi: 123, bye:456').toJs(), "{hi: 123, bye: 456}"

      test "object statement", ->
        p = MyParser.parse(
          """
          foo: 123
          bar: "hi"
          baz: .1
          """
        )
        assert.eq p.toJs(), '{foo: 123, bar: "hi", baz: .1}'

      test "object statement with nested object expression", ->
        p = MyParser.parse("""
          foo: bar: 123
          baz: 456
        """)
        assert.eq p.toJs(), '{foo: {bar: 123}, baz: 456}'

      test "nested object statements", ->
        parsed = MyParser.parse(
          """
          foo: 123
          bar:
            baz: 2
            bud: 3
          """
        )
        assert.eq parsed.toJs(), '{foo: 123, bar: {baz: 2, bud: 3}}'

      test "nested object expression one line", ->
        assert.eq MyParser.parse(
          """
          foo: 123
          bar: baz: 2, bud: 3
          """
        ).toJs(), '{foo: 123, bar: {baz: 2, bud: 3}}'

    suite "toJs array", ->
      test "array", ->
        assert.eq MyParser.parse('[]').toJs(), "[]"
        assert.eq MyParser.parse('[] 1').toJs(), "[1]"
        assert.eq MyParser.parse('[] 1, 2').toJs(), "[1, 2]"
        assert.eq MyParser.parse("""
          []
            123
            456
        """
        ).toJs(), "[123, 456]"

    suite "toJs complex", ->

      test "everything", ->
        assert.eq MyParser.parse("""
          myNumber1: .10
          myNumber2: 1
          myNumber3: 1.1

          myArray1: []
            123
            456
          myArray2: [] "hello", "world"

          myObject1: foo: 1, bar: 2
          myObject2: {} foo: 1, bar: 2
        """
        ).toJs(), "{myNumber1: .10, myNumber2: 1, myNumber3: 1.1, myArray1: [123, 456], myArray2: [\"hello\", \"world\"], myObject1: {foo: 1, bar: 2}, myObject2: {foo: 1, bar: 2}}"
