{w, array, log, a, peek, shallowClone, compactFlatten} = Neptune.Art.StandardLib
{Parser, Nodes, Extensions} = Neptune.Caffeine.Eight
{Node} = Nodes

module.exports = suite:
  toEolSubparsing: ->
    MyParser = null
    setup ->
      class MyParser extends Parser

        @rule
          root: 'line+'
          line: "linePart end"
          linePart: [
            "lineLabel lineEnd"
            "'(' linePart ')'"
          ]
          end: '/\n|$/'

          lineEnd:    Extensions.IndentBlocks.getPropsToSubparseToEol rule: "word", allowPartialMatch: true
          lineLabel:  /[0-9]+\: */
          word:       /[a-z]+/

    test "simple expression", ->
      MyParser.parse "1: hi"

    test "partial toEol match works", ->
      MyParser.parse "(1: hi)"

    test "extra nesting", ->
      MyParser.parse "((1: hi))"

  ifThenElseWithPartialSubBlocks: ->
    IfThenElseParser = null
    setup ->
      class IfThenElseParser extends Parser

        @rule
          root: [
            {pattern: 'ifThenElse', toTestStructure: -> @ifThenElse.toTestStructure()}
            pattern: 'words', toTestStructure: -> @words.toTestStructure()
          ]
          ifThenElse:
            pattern: '/if/ _ testBody:expression _ /then/ _ thenBody:expression _ /else/ _ elseBody:expression'
            toTestStructure: ->
              test: @testBody.toTestStructure()
              then: @thenBody.toTestStructure()
              else: @elseBody.toTestStructure()

          expression:
            pattern: Extensions.IndentBlocks.getPropsToSubparseToEol rule: "words", allowPartialMatch: true
            toTestStructure: -> @matches[0].toTestStructure()

          words:
            pattern: "word*"
            toTestStructure: ->
              for word in @words
                word.toString().trim()

          word:  "_? !/(if|then|else)\\b/ /[a-z]+/"
          _: /\ +/

    test "simple words", ->
      IfThenElseParser.parse "hi there"

    test "simple if-then-else", ->
      IfThenElseParser.parse "if a then b else c"

    test "more if-then-else", ->
      result = IfThenElseParser.parse "if a b then c d else e f"
      assert.eq result.toTestStructure(),
        test: ["a", "b"]
        then: ["c", "d"]
        else: ["e", "f"]

  absoluteOffset: ->
    MyBlockParser = null

    setup ->
      class MyBlockParser extends Parser

        @rule
          root: 'line+'
          line: [
            'end'
            'expression block? end'
          ]
          expression: '/[a-z0-9A-Z]+/'
          end: '/\n|$/'

          block: Extensions.IndentBlocks.getPropsToSubparseBlock()

    validateAbsoluteOffsets = (node) ->
      {absoluteOffset} = node
      if node.ruleName == "expression"
        sourceValue = node.toString()
        assert.eq absoluteOffset, node.parser.rootSource.indexOf(sourceValue), {sourceValue}
      for child in node.children
        assert.lte(
          absoluteOffset
          validateAbsoluteOffsets child
          message: "parent node's absoluteOffset should be <= all of its children"
          node: node.toString()
          child: child.toString()
        )
      absoluteOffset

    test "simple", ->
      validateAbsoluteOffsets MyBlockParser.parse """
        alpha
        """

    test "one block", ->
      validateAbsoluteOffsets MyBlockParser.parse """
        alpha
          beautlful
          colorful
        """

    test "nested blocks", ->
      validateAbsoluteOffsets p = MyBlockParser.parse """
        alpha
          beautlful
          colorful
            and
            delightful
        """

  blockParsing: ->
    MyBlockParser = null

    setup ->
      class MyBlockParser extends Parser

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
      MyBlockParser.parse "one"

    test "one block", ->
      MyBlockParser.parse """
        one
          two
        """

    test "nested blocks", ->
      MyBlockParser.parse """
        one
          two
            three
        """

    suite "failure location", ->
      suite 'baseline without block', ->
        test "before first line", ->
          parser = new MyBlockParser
          assert.rejects -> parser.parse """
            -abc
            """
          .then (rejectsWith) ->
            # log {rejectsWith, parser}
            assert.eq parser._failureIndex, 0

        test "first line", ->
          parser = new MyBlockParser
          assert.rejects -> parser.parse """
            abc-
            """
          .then (rejectsWith) ->
            # log {rejectsWith, parser}
            assert.eq parser._failureIndex, 3

        test "second line", ->
          parser = new MyBlockParser
          assert.rejects -> parser.parse """
            abc
            foo-
            """
          .then (rejectsWith) ->
            # log {rejectsWith, parser}
            assert.eq parser._failureIndex, 7

      suite 'in block', ->
        test "before line", ->
          parser = new MyBlockParser
          assert.rejects -> parser.parse """
            abc
              -def
              foos
            """
          .then (rejectsWith) ->
            # log {rejectsWith, parser}
            assert.eq parser._failureIndex, 6

        test "first line", ->
          parser = new MyBlockParser
          assert.rejects -> parser.parse """
            abc
              def-
              foos
            """
          .then (rejectsWith) ->
            # log {rejectsWith, parser}
            assert.eq parser._failureIndex, 9

        test "second line", ->
          parser = new MyBlockParser
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
          parser = new MyBlockParser
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
          parser = new MyBlockParser
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

  eolOrBlockParsing: ->
    MyEolOrBlockParser = null
    setup ->
      class MyEolOrBlockParser extends Parser

        @rule
          root: 'expression block? end'
          expression: '/[a-z0-9A-Z]+/'
          end: '/\n|$/'

          block: Extensions.IndentBlocks.getPropsToSubparseToEolAndBlock()

    test "simple expression", ->
      MyEolOrBlockParser.parse "one"

    test "simple block", ->
      MyEolOrBlockParser.parse """
        one
          two
        """

    test "simple eol", ->
      MyEolOrBlockParser.parse """
        one two
        """

    test "nested blocks", ->
      MyEolOrBlockParser.parse """
        one
          two
            three
        """

    test "nested eols", ->
      MyEolOrBlockParser.parse """
        one two three
        """

    test "nested eols and blocks", ->
      MyEolOrBlockParser.parse """
        one two
          three
        """

    suite "failure location", ->
      test "in EOL content", ->
        parser = new MyEolOrBlockParser
        assert.rejects -> parser.parse """
          one -two
          """
        .then (rejectsWith) ->
          assert.eq parser._failureIndex, 4

      test "in block with EOL content", ->
        parser = new MyEolOrBlockParser
        assert.rejects -> parser.parse """
          one two
            -abc
          """
        .then (rejectsWith) ->
          assert.eq parser._failureIndex, 10

      test "in block without EOL content", ->
        parser = new MyEolOrBlockParser
        assert.rejects -> parser.parse """
          one
            -abc
          """
        .then (rejectsWith) ->
          assert.eq parser._failureIndex, 6

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
