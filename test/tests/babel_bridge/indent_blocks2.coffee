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

###
2016-06-12 Plans

I think I have a complete solution:

1)  we pre-process and discover where we need to add start-block and end-blocks annotations.
2)  we only place a max of one annotation PER CHARACTER. It is important we can match something like `} } } {`
3)  start-block annotations can start on the first non-whitespace character of the block
4)  in order to ensure enough unique character indexes for end-block annotations, we
    append space characters to the end of the last line of the block for each }.
    This probably means we should semantically say that any multi-line string strips all trailing whitespace.
5)  Solving the if + implicit-function-invocation-expression problem:
    a. any time we need to match an expression followed by block, the expression rule should exclude
      any possiblity of matching implicit function invocations. See below.
    b. instead, we match 1-or-more blocks and apply the implicit method invocations at code-gen time!
    c. example: @rule if: "/if/ expressionWithoutImplicitFunctionInvocations block+"

(below is the only 'messy' part, the rest of the solution above is pretty simple)
6)  For simplicitly we want expressionWithoutImplicitFunctionInvocations to be exactly the same as
    'expression' except the implicit-method-invocation rule never matches.
    The simple version is we don't make them the same.
    We COULD add a way to have an "environment" of key-value pairs, settable when attempting to match a rule:
      "expression(noImplicitFunctionInvocation:true)"
    And testable somehow like:
      @rule implicitFunctionInvocation:
        pattern: ...
        preParse: (env) -> env.noImplicitFunctionInvocation != "true"
    The main trick is caching needs to include the env in the names so that even if we are trying the
    same rule at the same offset, different environments mean it's effectively a different rule.
    Logically, this is like cloning all rules and appending a unique string defined by the env - both
    for definitions and for references in patterns.
    Maybe "context" is a better name than "environment". It's more parser-lingo and accurate.

###

suite "BabelBridge.Parser.indent block v2 parsing", ->

  class IndentBlocksNode extends Node

  class MyParser extends Parser
    @nodeBaseClass: IndentBlocksNode

    @rule expression: /false/
    @rule expression: /true/

  test "simple expression", ->
    p = MyParser.parse "false"
    log "simple expression": p.plainObjects









