# BabelBridgeJS


NEW THOUGHTS:

We have a basic syntax. And then we use BB to generate a nice little parser, defined using the basic syntax,
which can then be used in any subsequent BB parsers.

BASIC PATTERN SYNTAX:
  regexp: /.../
  string: a rule name which can have zero or exactly one of:
    "!" prefix
    "*/+/?" suffix
  array: of regexps and strings

ADVANCED SYNTAX:


SYNTAX THOUGHTS:

class MyParser extends BabelBridge.Parser

  # labels are single field objects
  @rule foo:
    pattern: [
      (bar: /y+/)
      /something in the middle I don't need a label for/
      (baz: /z+/)
    ]

  # modifiers on rules
  @rule foo: "bar?" # optional
  @rule foo: "!bar" # not
  @rule foo: "could bar" # ensures it could match bar, but lets following pattern cosume those characters
  @rule bar: /bar/
