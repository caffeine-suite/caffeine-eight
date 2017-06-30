require '../index.coffee'
require "art-testbench/testing"
.init
  synchronous: true
  defineTests: ->
    tests = require './tests'
    Neptune.BabelBridge = require '../source/BabelBridge'
    tests
