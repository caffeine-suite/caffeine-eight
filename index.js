if (require('./use-build')) {
  module.exports = require("./build");
} else {
  require('./register');
  module.exports = require("./index.coffee");
}
