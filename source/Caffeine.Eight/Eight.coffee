{isClass, log} = require 'art-standard-lib'
module.exports = [
  require './Repl'
  require './Lib'
  version: (require '../../package.json').version
]
