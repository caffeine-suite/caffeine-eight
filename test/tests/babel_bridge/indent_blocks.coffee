Foundation = require 'art-foundation'
{log, wordsArray, peek} = Foundation
{Parser, Nodes} = require 'babel-bridge'
{Node} = Nodes

suite "BabelBridge.Parser.indent block parsing", ->

  test "blocks with intent parsing", ->
    class IndentBlocksNode extends Node

      collectLines: (lineStack) ->
        @collectLastBlock lineStack if @collectBlock == "lastBlock"
        for match in @matches
          match.collectLines? lineStack
        @collectFirstBlock lineStack if @collectBlock == "firstBlock"

        @block?.collectLines()

      @getter
        collectBlock: ->
          @ruleVariant.options.collectBlock || @class.collectBlock


      collectFirstBlock: (lineStack) ->
        if peek(lineStack) instanceof Block
          @block = lineStack.pop()

      collectLastBlock: (lineStack) ->
        otherBlocks = []
        while peek(lineStack) instanceof Block
          otherBlocks.push @block if @block
          @matches.push @block = lineStack.pop()

        # restore otherBlocks
        while otherBlocks.length > 0
          lineStack.push otherBlocks.pop()

    class Block extends Node
      constructor: (_, @indentLength = 0, firstMatch)->
        super
        @addMatch null, firstMatch

      collectLines: ->
        lineStack = @matches.reverse()
        newLines = []
        while line = lineStack.pop()
          line.collectLines? lineStack
          newLines.push line

        @_matches = newLines

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
        @block.collectLines()
        log collectLines: @plainObjects
        @

    class MyParser extends Parser
      # need to be able to declare the base non-ternal node type for all nodes
      @nodeBaseClass: IndentBlocksNode
      @rule lines: "line+", LinesNode
      @rule line: "indent expression eol"

      @rule expression: pattern: "/if/ _ expression", collectBlock: "lastBlock"
      @rule expression: pattern: "/else/", collectBlock: "lastBlock"

      @rule expression: /true|false/
      @rule _: pattern: / +/, variantNodeClassName: "Whitespace"
      @rule eol: pattern: /[ ]*(\n|$)/, variantNodeClassName: "Eol"

      @rule indent: / */

      @rule
        if: "'if' _ expression"

    p = MyParser.parse """
      if true
        false
      else
        true
      """
    log p.plainObjects
    p.postParse()

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
