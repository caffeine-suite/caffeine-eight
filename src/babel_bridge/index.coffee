# generated by Neptune Namespaces v1.x.x
# file: babel_bridge/index.coffee

module.exports = require './namespace'
.addModules
  Parser:         require './parser'         
  PatternElement: require './pattern_element'
  RuleVariant:    require './rule_variant'   
  Rule:           require './rule'           
  Tools:          require './tools'          
require './Extensions'
require './nodes'