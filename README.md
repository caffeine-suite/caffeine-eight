# BabelBridgeJS

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
