{defineModule} = require 'art-standard-lib'
{SourceLineColumnMap} = Neptune.Caffeine.Eight


defineModule module, suite:
  new: ->
    test "new SourceLineColumnMap", ->
      new SourceLineColumnMap "hi"

  getLineColumn: ->
    test "one-line-source", ->
      map = new SourceLineColumnMap "hi"
      assert.eq line: 0, column: 0, map.getLineColumn 0
      assert.eq line: 0, column: 1, map.getLineColumn 1
      assert.eq line: 0, column: 2, map.getLineColumn 2
      assert.eq line: 0, column: 100, map.getLineColumn 100

    test "two-line-source", ->
      map = new SourceLineColumnMap "hi\nthere"
      assert.eq line: 0, column: 0, map.getLineColumn 0
      assert.eq line: 0, column: 1, map.getLineColumn 1
      assert.eq line: 0, column: 2, map.getLineColumn 2
      assert.eq line: 1, column: 0, map.getLineColumn 3
      assert.eq line: 1, column: 1, map.getLineColumn 4
      assert.eq line: 1, column: 2, map.getLineColumn 5
      assert.eq line: 1, column: 3, map.getLineColumn 6
      assert.eq line: 1, column: 4, map.getLineColumn 7
      assert.eq line: 1, column: 5, map.getLineColumn 8
      assert.eq line: 1, column: 97, map.getLineColumn 100

    test "three-line-source", ->
      map = new SourceLineColumnMap "hi\nthere\nfriend"
      assert.eq line: 0, column: 2, map.getLineColumn 2
      assert.eq line: 1, column: 0, map.getLineColumn 3
      assert.eq line: 1, column: 5, map.getLineColumn 8
      assert.eq line: 2, column: 0, map.getLineColumn 9
      assert.eq line: 2, column: 91, map.getLineColumn 100

  withInto: ->
    test "three-line-source", ->
      into = {}
      map = new SourceLineColumnMap "hi\nthere\nfriend"
      assert.equal into, map.getLineColumn 2, into
      assert.equal into, map.getLineColumn 3, into

  getIndex: ->
    test "three-line-source", ->
      map = new SourceLineColumnMap "hi\nthere\nfriend"

      for index in [2,3,8,9,100]
        {line, column} = map.getLineColumn index
        assert.eq index, map.getIndex(line, column), {index, line, column}
