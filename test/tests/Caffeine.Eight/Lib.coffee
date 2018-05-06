{log} = require 'art-standard-lib'
{presentSourceLocation} = Neptune.Caffeine.Eight

module.exports = suite:
  presentSourceLocation: ->
    source =
      """
      firstLines = (string, count = 5) ->
        a = string.split "\\n"
        a.slice 0, count
        .join "\\n"
      """

    testString = "slice"
    insertString = "<HERE>"
    sourceIndex = source.indexOf testString

    test "presentSourceLocation source, sourceIndex", ->
      out = presentSourceLocation source, sourceIndex

      assert.eq sourceIndex, out.indexOf insertString
      assert.eq sourceIndex + insertString.length, out.indexOf testString

    test "presentSourceLocation source, sourceIndex, color: true", ->
      out = presentSourceLocation source, sourceIndex, color: true

      assert.lt sourceIndex, outIndexOfInsertString = out.indexOf insertString
      assert.lt outIndexOfInsertString + insertString.length, out.indexOf testString

    test "presentSourceLocation source, sourceIndex, maxLines: 1", ->
      out = presentSourceLocation source, sourceIndex, maxLines: 1
      assert.eq 1, (out.split "\n").length
      assert.match out, insertString

    test "presentSourceLocation source, sourceIndex, maxLines: 2", ->
      out = presentSourceLocation source, sourceIndex, maxLines: 3
      assert.eq 3, (out.split "\n").length
      assert.match out, insertString

    test "presentSourceLocation source, sourceIndex, maxLines: 5", ->
      out = presentSourceLocation source, sourceIndex, maxLines: 5
      assert.eq 4, (out.split "\n").length
      assert.match out, insertString
