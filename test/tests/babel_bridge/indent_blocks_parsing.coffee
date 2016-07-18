Foundation = require 'art-foundation'
{log, wordsArray, peek, shallowClone, compactFlatten} = Foundation
{Parser, Nodes} = require 'babel-bridge'
{Node} = Nodes

suite "BabelBridge.Parser.indent block parsing.basic", ->

  class IndentBlocksNode extends Node

  class MyParser extends Parser
    @nodeBaseClass: IndentBlocksNode

    @rule root: 'statement*'

    blockStartRegExp = /\n( +)/y

    @rule blocks: 'block+'
    @rule block:
      parse: (parentNode) ->
        {nextOffset, source} = parentNode
        blockStartRegExp.lastIndex = nextOffset
        if match = blockStartRegExp.exec source
          [_, indent] = match
          length = indent.length
          linesRegexp = ///(\n#{indent}[^\n]*)+///y
          linesRegexp.lastIndex = nextOffset
          [match] = linesRegexp.exec source
          lines = (line.slice length for line in match.split("\n").slice 1)

          if p = parentNode.parser.class.parse lines.join "\n"
            p.offset = nextOffset
            p.matchLength = match.length
            p

    @rule _: / */

    @rule statement: 'expression end'
    @rule expression: '/[a-z0-9A-Z]+/'

    @rule end: 'blocks end'
    @rule end: '/\n|$/'

  test "simple expression", ->
    p = MyParser.parse "false"
    log "simple expression": p.plainObjects

  test "simple block", ->
    p = MyParser.parse """
      false
         indent3a
          indent4
         indent3b
        indent2
       indent1
      false
      """
    log "simple expression": p.plainObjects

suite "BabelBridge.Parser.indent block parsing.CaffeineScriptObjectNotation", ->

  class IndentBlocksNode extends Node

    toJs: ->
      for match in @matches when match.toJs
        return match.toJs()
      log "no matches have toJs": @, class: @class
      throw new Error "no matches have toJs"

  class MyParser extends Parser
    @nodeBaseClass: IndentBlocksNode

    blockStartRegExp = /\n( +)/y

    @rules
      root: 'statement+'
      block:
        parse: (parentNode) ->
          {nextOffset, source} = parentNode
          blockStartRegExp.lastIndex = nextOffset
          if match = blockStartRegExp.exec source
            [_, indent] = match
            length = indent.length
            linesRegexp = ///(\n#{indent}[^\n]*)+///y
            linesRegexp.lastIndex = nextOffset
            [match] = linesRegexp.exec source
            lines = (line.slice length for line in match.split("\n").slice 1)

            if p = parentNode.parser.class.parse lines.join "\n"
              p.offset = nextOffset
              p.matchLength = match.length
              p

      expression: [
        'object'
        'array'
        'block'
        pattern: 'literal',
        node: toJs: -> @text
      ]

      literal:          ['string', 'number']
      end:              ['block end', '/\n+|$/']
      statement:        'expression end'
      string:           /"([^"]|\\.)*"/
      number:           /-?(\.[0-9]+|[0-9]+(\.[0-9]+)?)/

      array: [
        {
          pattern: "'[]' block"
          node: toJs: ->
            "[#{(node.toJs() for node in @block.statements).join ', '}]"
        }
        {
          pattern: "'[]' _? arrayElementWithDelimiter* expression"
          node: toJs: -> "[#{(node.toJs() for node in compactFlatten [@arrayElementWithDelimiters, @expression]).join ', '}]"
        }
        pattern: "'[]'"
        node: toJs: -> @text
      ]

      arrayElementWithDelimiter: "expression _? ',' _?"

      object: [
        "'{}' block"
        "'{}'? _? objectPropList"
      ]

      objectPropList:
        pattern: "objectProp commaObjectProp*"
        node: toJs: -> "{#{(m.toJs() for m in compactFlatten [@objectProp, @commaObjectProps]).join ', '}}"

      commaObjectProp: pattern: '"," _? objectProp'

      objectProp:
        pattern: 'objectPropLabel _? colon _? expression'
        node: toJs: -> "#{@objectPropLabel}: #{@expression.toJs()}"

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
      log MyParser.parse """
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

    test "one line", ->
      assert.eq MyParser.parse('hi: 123, bye:456').toJs(), "{hi: 123}"

    test "object expression", ->
      assert.eq MyParser.parse(
        """
        foo: 123
        bar: "hi"
        """
      ).toJs(), '{foo: 123, bar: "hi"}'
      assert.eq MyParser.parse("""
        foo: bar: 123
        baz: 456
      """).toJs(), '{foo: {bar: 123}, baz: 456}'

    test "nested object expression", ->
      assert.eq MyParser.parse(
        """
        foo: 123
        bar:
          baz: 2
          bud: 3
        """
      ).toJs(), '{foo: 123, bar: {baz: 2, bud: 3}}'

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
      ).toJs(), "{[123, 456]}"
