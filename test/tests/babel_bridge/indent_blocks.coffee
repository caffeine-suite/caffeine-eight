Foundation = require 'art-foundation'
{log, wordsArray, peek, shallowClone} = Foundation
{Parser, Nodes} = require 'babel-bridge'
{Node} = Nodes

###
TODO: A new IDEA

Annotations:

  Add a pre-parse step which scans all lines and marks every:
    - indent
    - samedent
    - outdent

  This annotations are tied to specific offsets in the source, specicially at
  the end of the indent string on the first non-white-space character.

  The source string is not altered. Annotations use their own data structure
  attached the the parser instance.

  Then, we add custom parsers which match only if there is a matching
  annotation at the current offset.

  There may be more than one annotation at the same offset.
  (that was the problem I had before with suggestions on the net to
  alter the source and add <indent> and <outdent> unique strings - you couldn't
  have two at the same index which is required for two sequential blocks.)

Pros:
  should make parsing pretty streightforward.

Cons:
  The following appears to be very hard or ugly to write parse rules for:
    if foo
        fooParam1
        fooParam2
      ifStatement1
      ifStatement2

  AND also parse:

    if foo
      ifStatement1
      ifStatement2

  Logically, I'd also like to be able to parse, even though there isn't a practical need:

    if if foo
          fooParam1
          fooParam2
        secondIfStatement1
        secondIfStatement2
      firstIfStatement1
      firstIfStatement2

    if if foo
    {
      fooParam1
      fooParam2
    }
    {
      secondIfStatement1
      secondIfStatement2
    }
    {
      firstIfStatement1
      firstIfStatement2
    }

    The problem is the determining if "foo" is a method invocation with parameters
    in a block-style-list or if "foo" is just a value is CONTEXCTUAL!
    It matters both how many "ifs" (or other block-requiring expressions) come before it
    AND how many blocks follow it.

    The answer may be that the test-expression for an "if", "while" or similar block-requireing
    statement cannot have itself match a block UNLESS it is within a parenthesis.

    So we could allow:
    if foo(
        fooParam1
        fooParam2
      )
      ifStatement1
      ifStatement2

    And:
    if foo () # the () with whitespace padding indicate a function invocation params list follows.
        fooParam1
        fooParam2
      ifStatement1
      ifStatement2

  Another option:
    Do something like the current system where we fully parse every line, but we ignore blocks.
    Then on each line we count how many "tail-blocks" are "required".
    Then we do the annotations, and tail-blocks get get "tailIndent" annotations instead of "indent"
    annotations. That way "foo" won't greedly assume the following "tailIndent" block indicates
    a method invocation - it only matches "indent" blocks.
    And, if, etc, matches "tailIndent" blocks.

    Is it possible to use the same parsing rules on the same source with two results?

    Perhaps we can do it with custom parsers? The first time the annotations aren't set, and
    therefor all the "blocks" stuff parses one way.

    The second time, the annotations exist and we are doing the "real" thing.

###

suite "BabelBridge.Parser.indent block parsing", ->

  class IndentBlocksNode extends Node

    blockParseMatches: (lineStack) ->

      newMatches = []
      for match in @matches
        result = if match.blockParse
          match.blockParse lineStack
        else
          match

        unless result
          log
            error: "didn't match blockParse"
            match:
              match.plainObjects
          throw new Error "didn't match blockParse"

        newMatches.push result

      @_matches = newMatches

    blockParse: (lineStack) ->
      @blockParseMatches lineStack
      @

    collectLastBlock: (lineStack) ->
      blocks = []
      blocks.push lineStack.pop() while peek(lineStack) instanceof Block
      @addMatch "block", block = blocks.pop()
      lineStack.push blocks.pop() while blocks.length > 0
      block.blockParse()

  class Block extends IndentBlocksNode
    constructor: (_, @indentLength = 0, firstMatch)->
      super
      @addMatch null, firstMatch

    blockParse: ->
      lineStack = @matches.reverse()
      newMatches = []
      while match = lineStack.pop()
        result = match.blockParse lineStack
        unless result
          log match:match.plainObjects
          throw new Error "didn't match blockParse"
        newMatches.push result

      @_matches = newMatches

    toJavascript: ->
      out = for match in @matches
        match.toJavascript()
      "{#{out.join ';'};}"

  class CouldHaveBlockNode extends IndentBlocksNode

  class LinesNode extends Block
    extractBlocks: ->
      blockStack = [new Block @parser]

      for line in @matches
        indentLength = line.indent.matchLength

        while indentLength < peek(blockStack).indentLength
          block = blockStack.pop()
          peek(blockStack).matches.push block

        if indentLength == peek(blockStack).indentLength
          peek(blockStack).addMatch null, line.expression
        else
          blockStack.push new Block peek(blockStack), indentLength, line.expression

      while blockStack.length > 1
        block = blockStack.pop()
        peek(blockStack).matches.push block

      @lines = null
      @matches = [@block = blockStack[0]]

    postParse: ->
      @extractBlocks()
      log extractBlocks: @plainObjects
      @block.blockParse()
      log blockParse: @plainObjects
      @

    toJavascript: -> @matches[0].toJavascript()

  class MyParser extends Parser
    # need to be able to declare the base non-ternal node type for all nodes
    @nodeBaseClass: IndentBlocksNode
    @rule lines: "line+", LinesNode
    @rule line: "indent expression eol"

    @rule expression:
      pattern: "/if/ _ expression"
      collectBlock: "lastBlock"
      nodeClass: class IfExpression extends IndentBlocksNode
        getPlainObjects: ->
          out =
            expression: @expression
          out.block = @block if @block
          out.else = @else if @else
          [
            {inspect: => "If"},
            out
          ]
        blockParse: (lineStack) ->
          if peek(lineStack) instanceof Block
            @collectLastBlock lineStack
            if @expression = @expression.blockParse lineStack
              if peek(lineStack) instanceof ElseExpression
                log "foundElseExpression"
                elseExpression = lineStack.pop()
                if newElseExpression elseExpression.blockParse lineStack
                  @addMatch "else", newElseExpression
                  @
              else
                @

        toJavascript: ->
          res = "if (#{@expression.toJavascript()}) #{@block.toJavascript()}"
          res += @else.toJavascript() if @else
          res

    @rule expression: "elseExpression"

    @rule elseExpression:
      pattern: "/else/"
      collectBlock: "lastBlock"
      nodeClass: class ElseExpression extends IndentBlocksNode
        toJavascript: ->
          " else #{@block.toJavascript()}"

    @rule expression:
      pattern: /true|false/
      nodeClass:
        toJavascript: -> @text

    @rule _: pattern: / +/, variantNodeClassName: "Whitespace"
    @rule eol: pattern: /[ ]*(\n|$)/, variantNodeClassName: "Eol"

    @rule indent: / */


  test "basic if-block", ->
    p = MyParser.parse """
      if true
        false
      """
    log p.plainObjects
    p.postParse()
    assert.eq "{if (true) {false;};}", p.toJavascript()

  test "basic if-else-block", ->
    p = MyParser.parse """
      if true
        false
      else
        true
      """
    log p.plainObjects
    p.postParse()
    assert.eq "{if (true) {false;} else {true;};}", p.toJavascript()

  test "simple expression", ->
    p = MyParser.parse "false"
    p.postParse()
    log "simple expression": p.plainObjects
    assert.eq "{false;}", p.toJavascript()

  test "simple expressions", ->
    p = MyParser.parse "false\ntrue"
    p.postParse()
    log "simple expression": p.plainObjects
    assert.eq "{false;true;}", p.toJavascript()

###
Block things we want to parse:

basic if, optional else
  if a
    b
  else
    c

if with test-block-method-invocation
  if a
      b
    c

  # js
  if (a(b)) c;

tail-if

  #coffee
  a = b if c

  # js
  if (c) a = b;

if - after assignment - block required
  a = if b
    c
  else
    d

if - becomes method invocation - block changes interpretation

  #coffee
  a = b if c
    block

  #js
  a = b(c ? block);

if - becomes method invocation, 2 - block required
  #coffee
  a = b c, if d
    block

  #js
  a = b(c, d ? block);

if - becomes method invocation, 3 - two blocks

  #coffee
  a = b if c
      d
    block

  #js
  a = b(c(d) ? block);

------------------

# expressions always return values
@rule ifExpression
  # could have 'then' and a statement, OR must have a block ('then' keyword optional)
  # could have 'else'

@rule tailIfExpression
  the statement to the left becomes the 'body' of the if
  if followed by a block, it is NOT a tailIf, it should be interpreted as a plain ifExpression

This seems to mean the presence of a block effects the intra-line parsing. Currently I am assuming
intra-line parsing is 'final' regarless of the presense of one or more blocks.

So far I only know of scenarios where two trailing blocks make sense. Is there a case where >2
make sense?

@rule expression: "ifExpression"
@rule ifExpression: pattern: "/if/ _ expressionWithOptionalBlockInvocation", block: "required", newLineElse: "optional"
@rule ifExpression: pattern: "/if/ _ expression _ /then/", block: "required", newLineElse: "optional"
@rule ifExpression: pattern: "/if/ _ expression _ /then/ _ expressionWithOptionalBlockInvocation", newLineElse: "optional"
@rule ifExpression: pattern: "/if/ _ expression _ /then/ _ expression _ /else/ expressionWithOptionalBlockInvocation"

@rule onLineMethodInvocation: "expression expression*-/listDelimiter/"
@rule listDelimiter: "_? /,/ _?"

Basically, expressionWithOptionalBlockInvocation should only ever apply to the very last
expression on a line. Parenthesis can override this associativity.

Tail-IFs should fail to match if ther could-match a block-indent just after. Can we at least do that?
  - detecting a block indent in normal PEG:
    - custom parser
    - match / *\n( *)/ -- add comment-detection/ignore
    - then compare the indent of the next line with the indent of this line
    - huh. Even that may be illegit.
  - it seems like the only legit way to do this is to make the decision at the block
    collection phase.
  -
@rule possiblyTailIf: "expression /if/ expression"
  - if we find one or more blocks follow, convert this to a non tail-if:
    - expressions[0](if expressons[1] then block)
  - else, it's a tail-if
    - if expressions[1] then expressions[0]

Other TAILS?
  if
  unless
  for ...

  I think they all need this handling.
###
