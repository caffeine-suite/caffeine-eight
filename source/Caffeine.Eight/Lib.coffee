{defineModule, max} = require 'art-standard-lib'

defineModule module, class Lib
  @lastLines: lastLines = (string, count = 5) ->
    a = string.split "\n"
    a.slice max(0, a.length - count), a.length
    .join "\n"

  @firstLines: firstLines = (string, count = 5) ->
    a = string.split "\n"
    a.slice 0, count
    .join "\n"

  @presentSourceLocation: (source, index, options = {}) ->

    {maxLines = 10, color, insertString = "<HERE>"} = options

    if color
      color = "red" if color == true
      insertString = "#{insertString}"[color]

    sourceBefore  = source.slice 0, index
    sourceAfter   = source.slice index

    if maxLines
      halfMaxLines  = Math.ceil maxLines / 2
      sourceBefore  = lastLines   sourceBefore, halfMaxLines
      sourceAfter   = firstLines  sourceAfter,  halfMaxLines

    "#{sourceBefore}#{insertString}#{sourceAfter.replace /[\s\n]+$/, ''}"
