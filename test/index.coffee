require '../'
require "art-testbench/testing"
.init
  synchronous: true
  defineTests: -> require './tests'
