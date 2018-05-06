if (true) {
  module.exports = require("./build");
} else {
  require('./register');
  module.exports = require("./index.coffee");
}
