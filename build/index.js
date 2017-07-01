module.exports =
/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// identity function for calling harmony imports with the correct context
/******/ 	__webpack_require__.i = function(value) { return value; };
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 22);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports) {

module.exports = require("art-standard-lib");

/***/ }),
/* 1 */
/***/ (function(module, exports) {

module.exports = require("art-class-system");

/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(5);

module.exports.addModules({
  EmptyNode: __webpack_require__(10),
  EmptyOptionalNode: __webpack_require__(26),
  Node: __webpack_require__(11),
  ScratchNode: __webpack_require__(27)
});


/***/ }),
/* 3 */
/***/ (function(module, exports, __webpack_require__) {

var Stats,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

module.exports = Stats = (function(superClass) {
  extend(Stats, superClass);

  function Stats() {
    return Stats.__super__.constructor.apply(this, arguments);
  }

  Stats._stats = {};

  Stats.reset = function() {
    return this._stats = {};
  };

  Stats.add = function(statName, amount) {
    if (amount == null) {
      amount = 1;
    }
    return this._stats[statName] = (this._stats[statName] || 0) + amount;
  };

  Stats.get = function() {
    return this._stats;
  };

  return Stats;

})(__webpack_require__(1).BaseClass);


/***/ }),
/* 4 */
/***/ (function(module, exports) {

module.exports = function(module) {
	if(!module.webpackPolyfill) {
		module.deprecate = function() {};
		module.paths = [];
		// module.parent = undefined by default
		if(!module.children) module.children = [];
		Object.defineProperty(module, "loaded", {
			enumerable: true,
			get: function() {
				return module.l;
			}
		});
		Object.defineProperty(module, "id", {
			enumerable: true,
			get: function() {
				return module.i;
			}
		});
		module.webpackPolyfill = 1;
	}
	return module;
};


/***/ }),
/* 5 */
/***/ (function(module, exports, __webpack_require__) {

var Nodes,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

module.exports = (__webpack_require__(7)).addNamespace('Nodes', Nodes = (function(superClass) {
  extend(Nodes, superClass);

  function Nodes() {
    return Nodes.__super__.constructor.apply(this, arguments);
  }

  return Nodes;

})(Neptune.PackageNamespace));


/***/ }),
/* 6 */
/***/ (function(module, exports, __webpack_require__) {

/* WEBPACK VAR INJECTION */(function(module) {var Repl, defineModule, formattedInspect, isClass, log, ref;

ref = __webpack_require__(0), defineModule = ref.defineModule, formattedInspect = ref.formattedInspect, isClass = ref.isClass, log = ref.log;

__webpack_require__(32);

defineModule(module, Repl = (function() {
  function Repl() {}

  Repl.babelBridgeRepl = function(parser) {
    if (isClass(parser)) {
      parser = new parser;
    }
    return __webpack_require__(34).start({
      prompt: ((parser.getClassName()) + "> ").grey,
      "eval": function(command, context, filename, callback) {
        var e, parsed, result;
        try {
          parsed = parser.parse(command.trim());
          try {
            if (result = typeof parsed.evaluate === "function" ? parsed.evaluate() : void 0) {
              return callback(null, result);
            } else {
              log(formattedInspect(parsed, {
                color: true
              }));
              return callback();
            }
          } catch (error) {
            e = error;
            return callback(e);
          }
        } catch (error) {
          e = error;
          return callback(parser.getParseFailureInfo({
            color: true
          }).replace("<HERE>", "<HERE>".red));
        }
      }
    });
  };

  return Repl;

})());

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(4)(module)))

/***/ }),
/* 7 */
/***/ (function(module, exports, __webpack_require__) {

var BabelBridge,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

module.exports = (__webpack_require__(33)).addNamespace('BabelBridge', BabelBridge = (function(superClass) {
  extend(BabelBridge, superClass);

  function BabelBridge() {
    return BabelBridge.__super__.constructor.apply(this, arguments);
  }

  BabelBridge.version = __webpack_require__(19).version;

  return BabelBridge;

})(Neptune.PackageNamespace));

__webpack_require__(9);

__webpack_require__(5);


/***/ }),
/* 8 */
/***/ (function(module, exports, __webpack_require__) {

/* WEBPACK VAR INJECTION */(function(module) {var BabelBridgeCompileError, ErrorWithInfo, defineModule, formattedInspect, isFunction, log, mergeInto, ref,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ref = __webpack_require__(0), defineModule = ref.defineModule, log = ref.log, mergeInto = ref.mergeInto, isFunction = ref.isFunction, formattedInspect = ref.formattedInspect, ErrorWithInfo = ref.ErrorWithInfo;

defineModule(module, BabelBridgeCompileError = (function(superClass) {
  extend(BabelBridgeCompileError, superClass);

  function BabelBridgeCompileError(message, info) {
    BabelBridgeCompileError.__super__.constructor.call(this, message, info, "BabelBridgeCompileError");
  }

  return BabelBridgeCompileError;

})(ErrorWithInfo));

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(4)(module)))

/***/ }),
/* 9 */
/***/ (function(module, exports, __webpack_require__) {

var Extensions,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

module.exports = (__webpack_require__(7)).addNamespace('Extensions', Extensions = (function(superClass) {
  extend(Extensions, superClass);

  function Extensions() {
    return Extensions.__super__.constructor.apply(this, arguments);
  }

  return Extensions;

})(Neptune.PackageNamespace));


/***/ }),
/* 10 */
/***/ (function(module, exports, __webpack_require__) {

var EmptyNode,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

module.exports = EmptyNode = (function(superClass) {
  extend(EmptyNode, superClass);

  function EmptyNode() {
    return EmptyNode.__super__.constructor.apply(this, arguments);
  }

  EmptyNode.getter({
    present: function() {
      return false;
    }
  });

  return EmptyNode;

})(__webpack_require__(11));


/***/ }),
/* 11 */
/***/ (function(module, exports, __webpack_require__) {

var BaseClass, Node, Nodes, Stats, array, arrayWith, compactFlatten, inspectedObjectLiteral, isPlainArray, isPlainObject, log, merge, mergeInto, objectWithout, peek, push, ref,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ref = __webpack_require__(0), arrayWith = ref.arrayWith, array = ref.array, peek = ref.peek, log = ref.log, push = ref.push, compactFlatten = ref.compactFlatten, objectWithout = ref.objectWithout, isPlainArray = ref.isPlainArray, isPlainObject = ref.isPlainObject, inspectedObjectLiteral = ref.inspectedObjectLiteral, merge = ref.merge, mergeInto = ref.mergeInto;

Nodes = __webpack_require__(5);

BaseClass = __webpack_require__(1).BaseClass;

Stats = __webpack_require__(3);

module.exports = Node = (function(superClass) {
  var emptyArray;

  extend(Node, superClass);

  function Node(parent, options) {
    var ref1;
    Node.__super__.constructor.apply(this, arguments);
    Stats.add("newNode");
    this._parent = parent;
    this._parser = parent._parser;
    this._offset = ((ref1 = options != null ? options.offset : void 0) != null ? ref1 : this._parent.getNextOffset()) | 0;
    this._matchLength = 0;
    this._ruleName = this._pluralRuleName = this._label = this._pluralLabel = this._pattern = this._nonMatches = this._ruleVariant = this._matches = this._matchPatterns = null;
    this._labelsApplied = this._nonMatch = false;
    if (options) {
      this._matchLength = (options.matchLength || 0) | 0;
      this._ruleVariant = options.ruleVariant;
      this._matches = options.matches;
      this._matchPatterns = options.matchPatterns;
    }
  }

  Node._createSubclassBase = function() {
    var NodeSubclass;
    return NodeSubclass = (function(superClass1) {
      extend(NodeSubclass, superClass1);

      function NodeSubclass() {
        return NodeSubclass.__super__.constructor.apply(this, arguments);
      }

      return NodeSubclass;

    })(this);
  };

  Node.createSubclass = function(options) {
    var klass;
    klass = this._createSubclassBase();
    if (options.name) {
      klass._name = klass.prototype._name = options.name;
    }
    if (options.ruleVarient) {
      klass.ruleVarient = options.ruleVarient;
      klass.rule = klass.ruleVariant.rule;
    }
    mergeInto(klass.prototype, objectWithout(options, "getter"));
    if (options.getter) {
      klass.getter(options.getter);
    }
    return klass;
  };

  Node.prototype.toString = function() {
    return this.text;
  };

  emptyArray = [];

  Node.setter("matches offset matchLength ruleVariant pattern matchPatterns");

  Node.getter("parent parser offset matchLength matchPatterns label pluralLabel ruleName pluralRuleName pattern nonMatch", {
    realNode: function() {
      return this;
    },
    name: function() {
      return this._name || this.ruleName || this["class"].getName();
    },
    present: function() {
      return this._matchLength > 0 || this._nonMatch;
    },
    matches: function() {
      return this._matches || (this._matches = []);
    },
    source: function() {
      return this._parser.source;
    },
    isRoot: function() {
      return this._parser === this._parent;
    },
    absoluteOffset: function() {
      return this._parser.offsetInRootParserSource(this._offset);
    },
    ancestors: function(into) {
      if (into == null) {
        into = [];
      }
      this.parent.getAncestors(into);
      into.push(this);
      return into;
    },
    parseInfo: function() {
      if (this.subparseInfo) {
        return "subparse:" + this.ruleName + ":" + this.offset;
      } else {
        return this.ruleName + ":" + this.offset;
      }
    },
    rulePath: function() {
      var ancestor, ancestorRuleNames;
      ancestorRuleNames = (function() {
        var j, len, ref1, results;
        ref1 = this.ancestors;
        results = [];
        for (j = 0, len = ref1.length; j < len; j++) {
          ancestor = ref1[j];
          results.push(ancestor.parseInfo);
        }
        return results;
      }).call(this);
      return ancestorRuleNames.join(" > ");
    },
    nextOffset: function() {
      return this.offset + this.matchLength;
    },
    text: function() {
      var matchLength, offset, ref1, source;
      ref1 = this.subparseInfo || this, matchLength = ref1.matchLength, offset = ref1.offset, source = ref1.source;
      if (matchLength === 0) {
        return "";
      } else {
        return source.slice(offset, offset + matchLength);
      }
    },
    ruleVariant: function() {
      var ref1;
      return this._ruleVariant || ((ref1 = this._parent) != null ? ref1.ruleVariant : void 0);
    },
    ruleName: function() {
      var ref1;
      return this.ruleNameOrNull || ((ref1 = this.parent) != null ? ref1.ruleName : void 0) || ("" + (this.pattern || 'no rule'));
    },
    ruleNameOrNull: function() {
      var ref1, ref2;
      return ((ref1 = this["class"].rule) != null ? ref1.getName() : void 0) || ((ref2 = this._ruleVariant) != null ? ref2.rule.getName() : void 0);
    },
    ruleNameOrPattern: function() {
      var ref1;
      return this.ruleNameOrNull || ("" + (((ref1 = this.pattern) != null ? ref1.pattern : void 0) || 'no rule'));
    },
    isRuleNode: function() {
      return this["class"].rule;
    },
    isPassThrough: function() {
      var ref1;
      return (ref1 = this.ruleVariant) != null ? ref1.isPassThrough : void 0;
    },
    nonPassThrough: function() {
      var ref1;
      return !((ref1 = this.ruleVariant) != null ? ref1.isPassThrough : void 0);
    }
  });

  Node.prototype.getNextText = function(length) {
    var nextOffset;
    nextOffset = this.nextOffset;
    return this.source.slice(nextOffset, nextOffset + length);
  };

  Node.prototype.formattedInspect = function() {
    return "CUSTOM";
  };

  Node.getter({
    parseTreePath: function() {
      var ref1;
      return compactFlatten([(ref1 = this.parent) != null ? ref1.parseTreePath : void 0, this["class"].getName()]);
    },
    presentMatches: function() {
      var j, len, m, ref1, results;
      ref1 = this.matches;
      results = [];
      for (j = 0, len = ref1.length; j < len; j++) {
        m = ref1[j];
        if (typeof m.getPresent === "function" ? m.getPresent() : void 0) {
          results.push(m);
        }
      }
      return results;
    },
    isNonMatch: function() {
      return !!this.nonMatch;
    },
    isPartialMatch: function() {
      var j, len, match, ref1;
      if (!this.nonMatch) {
        return false;
      }
      ref1 = this.presentMatches;
      for (j = 0, len = ref1.length; j < len; j++) {
        match = ref1[j];
        if (!match.nonMatch) {
          return true;
        }
      }
      return false;
    },
    isMatch: function() {
      return !this.nonMatch;
    },
    nonMatchingLeaf: function() {
      return this.nonMatch && peek(this.matches);
    },
    firstPartialMatchParent: function() {
      if (this.parent === this.parser || this.isPartialMatch) {
        return this;
      } else {
        return this.parent.firstPartialMatchParent;
      }
    },
    inspectedObjects: function(verbose) {
      var children, hasOneOrMoreMatchingChildren, label, match, matches, nonMatch, obj, parts, path, ref1, ref2, ref3, ruleName;
      match = this;
      matches = this.presentMatches;
      if (matches.length > 0) {
        path = [];
        while (matches.length === 1 && ((ref1 = matches[0].matches) != null ? ref1.length : void 0) > 0) {
          path.push("" + (match.label ? match.label + ":" : "") + match.ruleName);
          match = matches[0];
          matches = match.presentMatches;
        }
        label = match.label, ruleName = match.ruleName, nonMatch = match.nonMatch;
        path.push(ruleName);
        path = path.join('.');
        hasOneOrMoreMatchingChildren = false;
        children = (function() {
          var j, len, results;
          results = [];
          for (j = 0, len = matches.length; j < len; j++) {
            match = matches[j];
            if (!match.nonMatch) {
              hasOneOrMoreMatchingChildren = true;
            }
            results.push(match.getInspectedObjects(verbose));
          }
          return results;
        })();
        parts = compactFlatten([
          label ? {
            label: label
          } : void 0, children.length > 0 ? children : match.toString()
        ]);
        if (parts.length === 1) {
          parts = parts[0];
        }
        return (
          obj = {},
          obj["" + (nonMatch ? hasOneOrMoreMatchingChildren ? 'partialMatch-' : 'nonMatch-' : '') + path] = parts,
          obj
        );
      } else if (this.nonMatch) {
        return {
          nonMatch: {
            offset: this.offset,
            pattern: "" + ((ref2 = this.pattern) != null ? ref2.pattern : void 0)
          }
        };
      } else {
        if (verbose) {
          return {
            token: {
              offset: this.offset,
              length: this.matchLength,
              text: this.text,
              pattern: "" + ((ref3 = this.pattern) != null ? ref3.pattern : void 0),
              "class": this["class"].getName(),
              ruleName: this.ruleName
            }
          };
        } else {
          return this.text;
        }
      }
    },
    detailedInspectedObjects: function() {
      var children, match, matches, ret;
      matches = this.matches;
      if (matches.length > 0) {
        children = (function() {
          var j, len, results;
          results = [];
          for (j = 0, len = matches.length; j < len; j++) {
            match = matches[j];
            results.push(match.detailedInspectedObjects);
          }
          return results;
        })();
        ret = {};
        ret[this.name] = children.length === 1 ? children[0] : children;
        return ret;
      } else {
        return this.text;
      }
    },
    plainObjects: function() {
      var match, ref1, ret;
      ret = [
        {
          inspect: (function(_this) {
            return function() {
              return _this["class"].getName();
            };
          })(this)
        }
      ];
      if (((ref1 = this._matches) != null ? ref1.length : void 0) > 0) {
        ret = ret.concat((function() {
          var j, len, ref2, results;
          ref2 = this.matches;
          results = [];
          for (j = 0, len = ref2.length; j < len; j++) {
            match = ref2[j];
            results.push(match.getPlainObjects());
          }
          return results;
        }).call(this));
      } else {
        ret = this.text;
      }
      return ret;
    }
  });

  Node.prototype.find = function(searchName, out) {
    var j, len, m, ref1;
    if (out == null) {
      out = [];
    }
    ref1 = this.matches;
    for (j = 0, len = ref1.length; j < len; j++) {
      m = ref1[j];
      if (m.getName() === searchName) {
        out.push(m);
      } else {
        m.find(searchName, out);
      }
    }
    return out;
  };

  Node.prototype.subparse = function(subSource, options) {
    return this._parser.subparse(subSource, merge(options, {
      parentNode: this
    }));
  };


  /*
  IN: pattern, match - instanceof Node
  OUT: true if match was added
   */

  Node.prototype.addMatch = function(pattern, match) {
    if (!match) {
      return false;
    }
    this._matches = push(this._matches, match);
    this._matchPatterns = push(this._matchPatterns, pattern);
    this._matchLength = match.nextOffset - this.offset;
    return true;
  };

  Node.prototype.applyLabels = function() {
    if (!this._matches || this._labelsApplied) {
      return;
    }
    this._labelsApplied = true;
    return array(this._matches, (function(_this) {
      return function(match, i) {
        var label, pattern, pluralLabel, pluralRuleName, ruleName;
        pattern = _this._matchPatterns[i];
        match._parent = _this;
        if (pattern) {
          label = pattern.label, ruleName = pattern.ruleName;
          match._pattern = pattern;
          match._label = label;
          match._ruleName = ruleName;
        }
        if (label) {
          match._pluralLabel = pluralLabel = _this.parser.pluralize(label);
        }
        if (ruleName) {
          match._pluralRuleName = pluralRuleName = _this.parser.pluralize(ruleName);
        }
        label || (label = ruleName);
        pluralLabel || (pluralLabel = pluralRuleName);
        if (label && !(match instanceof Nodes.EmptyNode)) {
          _this._bindToLabelLists(pluralLabel, match);
          _this._bindToSingleLabels(label, match);
        }
        return match.applyLabels();
      };
    })(this));
  };

  Node.prototype._bindToLabelLists = function(pluralLabel, match) {
    if (this.__proto__[pluralLabel] == null) {
      return this[pluralLabel] = push(this[pluralLabel], match);
    }
  };

  Node.prototype._bindToSingleLabels = function(label, match) {
    if (this.__proto__[label] == null) {
      return this[label] = match;
    }
  };

  Node.prototype._addNonMatch = function(node) {
    return (this._nonMatches || (this._nonMatches = [])).push(node);
  };

  Node.prototype._addToParentAsNonMatch = function() {
    if (this._matchLength === 0) {
      this._matchLength = 1;
    }
    if (this.parent) {
      if (this.parent.matches) {
        if (!(0 <= this.parent.matches.indexOf(this))) {
          this._nonMatch = true;
          this.parent.matches.push(this);
          this.parent._presentMatches = null;
          if (this.parent._matchLength === 0) {
            this.parent._matchLength = 1;
          }
        }
        return this.parent._addToParentAsNonMatch();
      } else {
        return this;
      }
    } else {
      return this;
    }
  };

  return Node;

})(BaseClass);


/***/ }),
/* 12 */
/***/ (function(module, exports, __webpack_require__) {

/* WEBPACK VAR INJECTION */(function(module) {var BaseClass, NonMatch, defineModule, log, ref,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ref = __webpack_require__(0), log = ref.log, defineModule = ref.defineModule;

BaseClass = __webpack_require__(1).BaseClass;

defineModule(module, NonMatch = (function(superClass) {
  extend(NonMatch, superClass);

  function NonMatch(_node, _patternElement) {
    this._node = _node;
    this._patternElement = _patternElement;
  }

  NonMatch.getter("node patternElement", {
    inspectedObjects: function() {
      return {
        NonMatch: {
          patternElement: this.toString(),
          offset: this.node.offset
        }
      };
    }
  });

  NonMatch.prototype.toString = function() {
    return this.patternElement.ruleVariant.toString();
  };

  return NonMatch;

})(BaseClass));

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(4)(module)))

/***/ }),
/* 13 */
/***/ (function(module, exports, __webpack_require__) {

var EmptyNode, EmptyOptionalNode, Node, PatternElement, inspect, isPlainObject, isRegExp, isString, log, ref, ref1,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ref = __webpack_require__(2), Node = ref.Node, EmptyNode = ref.EmptyNode, EmptyOptionalNode = ref.EmptyOptionalNode;

ref1 = __webpack_require__(0), isPlainObject = ref1.isPlainObject, isString = ref1.isString, isRegExp = ref1.isRegExp, inspect = ref1.inspect, log = ref1.log;

module.exports = PatternElement = (function(superClass) {
  var escapeRegExp;

  extend(PatternElement, superClass);

  PatternElement.escapeRegExp = escapeRegExp = function(str) {
    return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
  };

  PatternElement.regExpRegExp = /\/((?:[^\\\/]|\\.)+)\//;

  PatternElement.ruleRegExp = /([a-zA-Z0-9_]+)/;

  PatternElement.singleQuotedStringRegExp = /'((?:[^\\']|\\.)+)'/;

  PatternElement.doubleQuotedStringRegExp = /"((?:[^\\"]|\\.)+)"/;

  PatternElement.labelRegExp = /([a-zA-Z0-9_]+)\:/;

  PatternElement.patternElementRegExp = RegExp("(?:" + PatternElement.labelRegExp.source + ")?([!&])?(?:" + PatternElement.ruleRegExp.source + "|" + PatternElement.regExpRegExp.source + "|" + PatternElement.singleQuotedStringRegExp.source + "|" + PatternElement.doubleQuotedStringRegExp.source + ")([?*+])?");

  PatternElement.allPatternElementsRegExp = RegExp("" + PatternElement.patternElementRegExp.source, "g");

  function PatternElement(pattern1, arg) {
    this.pattern = pattern1;
    this.ruleVariant = (arg != null ? arg : {}).ruleVariant;
    PatternElement.__super__.constructor.apply(this, arguments);
    this.parse = null;
    this._init();
  }

  PatternElement.prototype.toString = function() {
    return "PatternElement(" + this.pattern + ")";
  };

  PatternElement.getter("isTokenPattern");

  PatternElement.property({
    label: null,
    optional: false,
    negative: false,
    couldMatch: false,
    zeroOrMore: false,
    oneOrMore: false,
    pattern: null,
    ruleName: null
  });

  PatternElement.getter({
    isBasicRulePattern: function() {
      return this.ruleName && !this.optional && !this.negative && !this.zeroOrMore && !this.oneOrMore && !this.couldMatch;
    },
    inspectedObjects: function() {
      return {
        PatternElement: this.props
      };
    },
    props: function() {
      var props;
      props = {
        pattern: this.pattern
      };
      if (this.ruleName) {
        props.ruleName = this.ruleName;
      }
      if (this.negative) {
        props.negative = true;
      }
      if (this.zeroOrMore) {
        props.zeroOrMore = true;
      }
      if (this.oneOrMore) {
        props.oneOrMore = true;
      }
      if (this.couldMatch) {
        props.couldMatch = true;
      }
      return props;
    }
  });

  PatternElement.prototype.parse = function(parentNode) {
    throw new Error("should be overridden");
  };

  PatternElement.prototype.parseInto = function(parentNode) {
    return !!parentNode.addMatch(this, this.parse(parentNode));
  };

  PatternElement.prototype._applyParseFlags = function() {
    var singleParser;
    singleParser = this.parse;
    if (this._optional) {
      this.parse = function(parentNode) {
        var match;
        if (match = singleParser(parentNode)) {
          return match;
        } else {
          return new EmptyOptionalNode(parentNode);
        }
      };
    }
    if (this._negative) {
      this.parse = function(parentNode) {
        return parentNode.parser._matchNegative(function() {
          var match;
          if (match = singleParser(parentNode)) {
            return null;
          } else {
            return new EmptyNode(parentNode);
          }
        });
      };
    }
    if (this.couldMatch) {
      this.parse = function(parentNode) {
        if (singleParser(parentNode)) {
          return new EmptyNode(parentNode);
        }
      };
    }
    if (this._zeroOrMore) {
      this.parseInto = (function(_this) {
        return function(parentNode) {
          var m, matchCount;
          matchCount = 0;
          while (parentNode.addMatch(_this, m = singleParser(parentNode))) {
            matchCount++;
            if (m.matchLength === 0) {
              break;
            }
          }
          return true;
        };
      })(this);
    }
    if (this._oneOrMore) {
      return this.parseInto = (function(_this) {
        return function(parentNode) {
          var m, matchCount;
          matchCount = 0;
          while (parentNode.addMatch(_this, m = singleParser(parentNode))) {
            matchCount++;
            if (m.matchLength === 0) {
              break;
            }
          }
          return matchCount > 0;
        };
      })(this);
    }
  };

  PatternElement.prototype._init = function() {
    var __, doubleQuotedString, pattern, prefix, ref2, regExp, res, singleQuotedString, string, suffix;
    this.parse = this.label = this.ruleName = null;
    this.negative = this.couldMatch = this.oneOrMore = this.optional = this.zeroOrMore = false;
    this._isTokenPattern = false;
    pattern = this.pattern;
    if (isPlainObject(pattern)) {
      this._initPlainObject(pattern);
    } else if (isString(pattern)) {
      ref2 = res = pattern.match(PatternElement.patternElementRegExp), __ = ref2[0], this.label = ref2[1], prefix = ref2[2], this.ruleName = ref2[3], regExp = ref2[4], singleQuotedString = ref2[5], doubleQuotedString = ref2[6], suffix = ref2[7];
      if (prefix && suffix) {
        throw new Error("pattern can only have one prefix: !/& or one suffix: ?/+/*");
      }
      switch (prefix) {
        case "!":
          this.negative = true;
          break;
        case "&":
          this.couldMatch = true;
      }
      switch (suffix) {
        case "?":
          this.optional = true;
          break;
        case "+":
          this.oneOrMore = true;
          break;
        case "*":
          this.zeroOrMore = true;
      }
      string = singleQuotedString || doubleQuotedString;
      if (this.ruleName) {
        this._initRule(this.ruleName);
      } else if (regExp) {
        this._initRegExp(new RegExp(regExp));
      } else if (string) {
        this._initRegExp(new RegExp(escapeRegExp(string)));
      } else {
        throw new Error("invalid pattern: " + pattern);
      }
    } else if (isRegExp(pattern)) {
      this._initRegExp(pattern);
    } else {
      throw new Error("invalid pattern type: " + (inspect(pattern)));
    }
    return this._applyParseFlags();
  };

  PatternElement.prototype._initPlainObject = function(object) {
    var parseInto;
    this.negative = object.negative, this.oneOrMore = object.oneOrMore, this.zeroOrMore = object.zeroOrMore, this.optional = object.optional, this.parse = object.parse, parseInto = object.parseInto;
    if (parseInto) {
      this.parseInto = parseInto;
    }
    if (!(this.parse || parseInto)) {
      throw new Error("plain-object pattern definition requires 'parse' or 'parseInto'");
    }
  };

  PatternElement.prototype._initRule = function(ruleName) {
    var matchRule;
    matchRule = null;
    return this.parse = function(parentNode) {
      matchRule || (matchRule = parentNode.parser.getRule(ruleName));
      return matchRule.parse(parentNode);
    };
  };


  /*
  NOTE: regExp.test is 3x faster than .exec in Safari, but about the
    same in node/chrome. Safari is 2.5x faster than Chrome/Node in this.
  
    Regexp must have the global flag set, even if we are using the y-flag,
    to make .test() set .lastIndex correctly.
  
  SEE: https://jsperf.com/regex-match-length
   */

  PatternElement.prototype._initRegExp = function(regExp) {
    var flags;
    this._isTokenPattern = true;
    flags = "yg";
    if (regExp.ignoreCase) {
      flags += "i";
    }
    regExp = RegExp(regExp.source, flags);
    return this.parse = function(parentNode) {
      var nextOffset, source;
      nextOffset = parentNode.nextOffset, source = parentNode.source;
      regExp.lastIndex = nextOffset;
      if (regExp.test(source)) {
        return new Node(parentNode, {
          offset: nextOffset,
          matchLength: regExp.lastIndex - nextOffset
        });
      }
    };
  };

  return PatternElement;

})(__webpack_require__(1).BaseClass);


/***/ }),
/* 14 */
/***/ (function(module, exports, __webpack_require__) {

var Rule, RuleVariant, Stats, log, merge, objectName, ref, upperCamelCase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

RuleVariant = __webpack_require__(15);

Stats = __webpack_require__(3);

ref = __webpack_require__(0), merge = ref.merge, upperCamelCase = ref.upperCamelCase, objectName = ref.objectName, log = ref.log;

module.exports = Rule = (function(superClass) {
  extend(Rule, superClass);

  function Rule(_name, _parserClass, _variants) {
    this._name = _name;
    this._parserClass = _parserClass;
    this._variants = _variants != null ? _variants : [];
  }

  Rule.getter("nodeClassName name variantNodeClasses", {
    numVariants: function() {
      return this._variants.length;
    }
  });

  Rule.prototype.addVariant = function(options) {
    var v;
    this._variants.push(v = new RuleVariant(merge(options, {
      variantNumber: this._variants.length + 1,
      rule: this,
      parserClass: this._parserClass
    })));
    return v;
  };

  Rule.getter({
    inspectObjects: function() {
      return [
        {
          inspect: (function(_this) {
            return function() {
              return "<Rule: " + _this._name + ">";
            };
          })(this)
        }, this._variants
      ];
    }
  });

  Rule.prototype.clone = function() {
    return new Rule(this._name, this._parserClass, this._variants.slice());
  };


  /*
  IN:
    parentNode: node instance
      This provides critical info:
        parentNode.source:      the source string
        parentNode.nextOffset:  the index in the source where parsing starts
        parentNode.parser:      access to the parser object
  
  EFFECT: If returning a new Node, it is expected that node's parent is already set to parentNode
  OUT: Node instance if parsing was successful
   */

  Rule.prototype.parse = function(parentNode) {
    var cached, i, len, match, nextOffset, parser, ref1, v;
    Stats.add("parseRule");
    parser = parentNode.parser, nextOffset = parentNode.nextOffset;
    if (cached = parser._cached(this.name, nextOffset)) {
      if (cached === "no_match") {
        Stats.add("cacheHitNoMatch");
        return null;
      } else {
        Stats.add("cacheHit");
        return cached;
      }
    }
    ref1 = this._variants;
    for (i = 0, len = ref1.length; i < len; i++) {
      v = ref1[i];
      if (match = v.parse(parentNode)) {
        return parser._cacheMatch(this.name, match);
      }
    }
    return parser._cacheNoMatch(this.name, nextOffset);
  };

  return Rule;

})(__webpack_require__(1).BaseClass);


/***/ }),
/* 15 */
/***/ (function(module, exports, __webpack_require__) {

var BaseClass, Node, PatternElement, RuleVariant, ScratchNode, Stats, allPatternElementsRegExp, compactFlatten, inspect, isPlainObject, isString, log, merge, pad, push, ref, ref1, toInspectedObjects, upperCamelCase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

PatternElement = __webpack_require__(13);

Stats = __webpack_require__(3);

ref = __webpack_require__(2), Node = ref.Node, ScratchNode = ref.ScratchNode;

ref1 = __webpack_require__(0), log = ref1.log, toInspectedObjects = ref1.toInspectedObjects, isPlainObject = ref1.isPlainObject, push = ref1.push, isString = ref1.isString, compactFlatten = ref1.compactFlatten, inspect = ref1.inspect, pad = ref1.pad, upperCamelCase = ref1.upperCamelCase, merge = ref1.merge;

allPatternElementsRegExp = PatternElement.allPatternElementsRegExp;

BaseClass = __webpack_require__(1).BaseClass;

module.exports = RuleVariant = (function(superClass) {
  extend(RuleVariant, superClass);

  function RuleVariant(options1) {
    var ref2;
    this.options = options1;
    this._toString = null;
    if (!isPlainObject(this.options)) {
      this.options = {
        pattern: this.options
      };
    }
    ref2 = this.options, this.pattern = ref2.pattern, this.rule = ref2.rule, this.parserClass = ref2.parserClass;
    this._variantNodeClassName = this.options.variantNodeClassName;
    this._initVariantNodeClass(this.options);
    if (this.options.parse) {
      this.parse = this.options.parse;
    }
  }

  RuleVariant.property({
    passThroughRuleName: null
  });

  RuleVariant.setter("variantNodeClassName");

  RuleVariant.getter({
    isPassThrough: function() {
      return this._passThroughRuleName;
    },
    name: function() {
      return this.variantNodeClassName + "Variant";
    },
    numVariants: function() {
      return this.rule.numVariants;
    },
    patternElements: function() {
      return this._patternElements || (this._patternElements = this._generatePatternElements());
    }
  });

  RuleVariant.prototype._generatePatternElements = function() {
    var part, parts, pes;
    pes = (function() {
      var i, len, results;
      if (isString(this.pattern)) {
        parts = this.pattern.match(allPatternElementsRegExp);
        if (!parts) {
          throw new Error("no pattern-parts found in: " + (inspect(this.pattern)));
        }
        results = [];
        for (i = 0, len = parts.length; i < len; i++) {
          part = parts[i];
          results.push(new PatternElement(part, {
            ruleVariant: this
          }));
        }
        return results;
      } else {
        return [
          new PatternElement(this.pattern, {
            ruleVariant: this
          })
        ];
      }
    }).call(this);
    pes = compactFlatten(pes);
    if (pes.length === 1 && pes[0].isBasicRulePattern) {
      this.passThroughRuleName = pes[0].ruleName;
    }
    return pes;
  };

  RuleVariant.prototype.inspect = function() {
    return this.toString();
  };

  RuleVariant.prototype.toString = function() {
    return this._toString || (this._toString = this.name + ": " + this.patternString);
  };

  RuleVariant.getter({
    patternString: function() {
      return this.pattern || (this.options.parse && 'function()');
    }
  });


  /*
  see: BabelBridge.Rule#parse
   */

  RuleVariant.prototype.parse = function(parentNode) {
    var activeRuleVariantParserOffsets, i, len, name, nextOffset, parser, patternElement, previousActiveRuleVariantParserOffset, ref2, scratchNode;
    name = this.name;
    parser = parentNode.parser, nextOffset = parentNode.nextOffset;
    activeRuleVariantParserOffsets = parser.activeRuleVariantParserOffsets;
    if (nextOffset === (previousActiveRuleVariantParserOffset = activeRuleVariantParserOffsets[name])) {
      throw new Error("leftRecursion detected: RuleVariant: " + name + ", offset: " + nextOffset);
    }
    activeRuleVariantParserOffsets[name] = nextOffset;
    try {
      Stats.add("parseVariant");
      scratchNode = ScratchNode.checkout(parentNode, this);
      parser = parentNode.parser;
      ref2 = this.patternElements;
      for (i = 0, len = ref2.length; i < len; i++) {
        patternElement = ref2[i];
        if (!parser.tryPatternElement(patternElement, scratchNode, this)) {
          scratchNode.checkin();
          return false;
        }
      }
      scratchNode.checkin();
      return scratchNode.getRealNode();
    } finally {
      activeRuleVariantParserOffsets[name] = previousActiveRuleVariantParserOffset;
    }
  };

  RuleVariant.getter({
    variantNodeClassName: function() {
      var baseName, ref2;
      if (this._variantNodeClassName) {
        return this._variantNodeClassName;
      }
      baseName = upperCamelCase(this.rule.name) + "Rule" + (this.pattern ? upperCamelCase(((ref2 = ("" + this.pattern).match(/[a-zA-Z0-9_]+/g)) != null ? ref2.join('_') : void 0) || "") : this.parse ? "CustomParser" : void 0);
      return this._variantNodeClassName = baseName;
    }
  });


  /*
  OPTIONS:
  
    node / nodeClass
      TODO: pick one, I like 'node' today
  
    extends / baseClass / nodeBaseClass
      TODO: pick one, I like 'extends' today
   */

  RuleVariant.prototype._initVariantNodeClass = function(options) {
    var nodeBaseClass, nodeSubclassOptions, rule;
    rule = options.rule;
    nodeSubclassOptions = options.node || options.nodeClass || options;
    nodeBaseClass = options["extends"] || options.baseClass || options.nodeBaseClass || Node;
    return this.VariantNodeClass = (typeof nodeClass !== "undefined" && nodeClass !== null ? nodeClass.prototype : void 0) instanceof Node ? nodeClass : nodeBaseClass.createSubclass(merge({
      name: this.variantNodeClassName,
      ruleVarient: this.ruleVarient
    }, nodeSubclassOptions));
  };

  return RuleVariant;

})(BaseClass);


/***/ }),
/* 16 */
/***/ (function(module, exports, __webpack_require__) {

var Tools, peek;

peek = __webpack_require__(0).peek;

module.exports = Tools = (function() {
  var getLineColumn;

  function Tools() {}

  Tools.getLineColumn = getLineColumn = function(string, offset) {
    var lines;
    if (string.length === 0 || offset === 0) {
      return {
        line: 1,
        column: 1
      };
    }
    lines = (string.slice(0, offset)).split("\n");
    return {
      line: lines.length,
      column: peek(lines).length + 1
    };
  };

  Tools.getLineColumnString = function(string, offset) {
    var column, line, ref;
    ref = getLineColumn(string, offset), line = ref.line, column = ref.column;
    return line + ":" + column;
  };

  return Tools;

})();


/***/ }),
/* 17 */
/***/ (function(module, exports, __webpack_require__) {

/* MIT license */
var cssKeywords = __webpack_require__(18);

// NOTE: conversions should only return primitive values (i.e. arrays, or
//       values that give correct `typeof` results).
//       do not use box values types (i.e. Number(), String(), etc.)

var reverseKeywords = {};
for (var key in cssKeywords) {
	if (cssKeywords.hasOwnProperty(key)) {
		reverseKeywords[cssKeywords[key]] = key;
	}
}

var convert = module.exports = {
	rgb: {channels: 3, labels: 'rgb'},
	hsl: {channels: 3, labels: 'hsl'},
	hsv: {channels: 3, labels: 'hsv'},
	hwb: {channels: 3, labels: 'hwb'},
	cmyk: {channels: 4, labels: 'cmyk'},
	xyz: {channels: 3, labels: 'xyz'},
	lab: {channels: 3, labels: 'lab'},
	lch: {channels: 3, labels: 'lch'},
	hex: {channels: 1, labels: ['hex']},
	keyword: {channels: 1, labels: ['keyword']},
	ansi16: {channels: 1, labels: ['ansi16']},
	ansi256: {channels: 1, labels: ['ansi256']},
	hcg: {channels: 3, labels: ['h', 'c', 'g']},
	apple: {channels: 3, labels: ['r16', 'g16', 'b16']},
	gray: {channels: 1, labels: ['gray']}
};

// hide .channels and .labels properties
for (var model in convert) {
	if (convert.hasOwnProperty(model)) {
		if (!('channels' in convert[model])) {
			throw new Error('missing channels property: ' + model);
		}

		if (!('labels' in convert[model])) {
			throw new Error('missing channel labels property: ' + model);
		}

		if (convert[model].labels.length !== convert[model].channels) {
			throw new Error('channel and label counts mismatch: ' + model);
		}

		var channels = convert[model].channels;
		var labels = convert[model].labels;
		delete convert[model].channels;
		delete convert[model].labels;
		Object.defineProperty(convert[model], 'channels', {value: channels});
		Object.defineProperty(convert[model], 'labels', {value: labels});
	}
}

convert.rgb.hsl = function (rgb) {
	var r = rgb[0] / 255;
	var g = rgb[1] / 255;
	var b = rgb[2] / 255;
	var min = Math.min(r, g, b);
	var max = Math.max(r, g, b);
	var delta = max - min;
	var h;
	var s;
	var l;

	if (max === min) {
		h = 0;
	} else if (r === max) {
		h = (g - b) / delta;
	} else if (g === max) {
		h = 2 + (b - r) / delta;
	} else if (b === max) {
		h = 4 + (r - g) / delta;
	}

	h = Math.min(h * 60, 360);

	if (h < 0) {
		h += 360;
	}

	l = (min + max) / 2;

	if (max === min) {
		s = 0;
	} else if (l <= 0.5) {
		s = delta / (max + min);
	} else {
		s = delta / (2 - max - min);
	}

	return [h, s * 100, l * 100];
};

convert.rgb.hsv = function (rgb) {
	var r = rgb[0];
	var g = rgb[1];
	var b = rgb[2];
	var min = Math.min(r, g, b);
	var max = Math.max(r, g, b);
	var delta = max - min;
	var h;
	var s;
	var v;

	if (max === 0) {
		s = 0;
	} else {
		s = (delta / max * 1000) / 10;
	}

	if (max === min) {
		h = 0;
	} else if (r === max) {
		h = (g - b) / delta;
	} else if (g === max) {
		h = 2 + (b - r) / delta;
	} else if (b === max) {
		h = 4 + (r - g) / delta;
	}

	h = Math.min(h * 60, 360);

	if (h < 0) {
		h += 360;
	}

	v = ((max / 255) * 1000) / 10;

	return [h, s, v];
};

convert.rgb.hwb = function (rgb) {
	var r = rgb[0];
	var g = rgb[1];
	var b = rgb[2];
	var h = convert.rgb.hsl(rgb)[0];
	var w = 1 / 255 * Math.min(r, Math.min(g, b));

	b = 1 - 1 / 255 * Math.max(r, Math.max(g, b));

	return [h, w * 100, b * 100];
};

convert.rgb.cmyk = function (rgb) {
	var r = rgb[0] / 255;
	var g = rgb[1] / 255;
	var b = rgb[2] / 255;
	var c;
	var m;
	var y;
	var k;

	k = Math.min(1 - r, 1 - g, 1 - b);
	c = (1 - r - k) / (1 - k) || 0;
	m = (1 - g - k) / (1 - k) || 0;
	y = (1 - b - k) / (1 - k) || 0;

	return [c * 100, m * 100, y * 100, k * 100];
};

/**
 * See https://en.m.wikipedia.org/wiki/Euclidean_distance#Squared_Euclidean_distance
 * */
function comparativeDistance(x, y) {
	return (
		Math.pow(x[0] - y[0], 2) +
		Math.pow(x[1] - y[1], 2) +
		Math.pow(x[2] - y[2], 2)
	);
}

convert.rgb.keyword = function (rgb) {
	var reversed = reverseKeywords[rgb];
	if (reversed) {
		return reversed;
	}

	var currentClosestDistance = Infinity;
	var currentClosestKeyword;

	for (var keyword in cssKeywords) {
		if (cssKeywords.hasOwnProperty(keyword)) {
			var value = cssKeywords[keyword];

			// Compute comparative distance
			var distance = comparativeDistance(rgb, value);

			// Check if its less, if so set as closest
			if (distance < currentClosestDistance) {
				currentClosestDistance = distance;
				currentClosestKeyword = keyword;
			}
		}
	}

	return currentClosestKeyword;
};

convert.keyword.rgb = function (keyword) {
	return cssKeywords[keyword];
};

convert.rgb.xyz = function (rgb) {
	var r = rgb[0] / 255;
	var g = rgb[1] / 255;
	var b = rgb[2] / 255;

	// assume sRGB
	r = r > 0.04045 ? Math.pow(((r + 0.055) / 1.055), 2.4) : (r / 12.92);
	g = g > 0.04045 ? Math.pow(((g + 0.055) / 1.055), 2.4) : (g / 12.92);
	b = b > 0.04045 ? Math.pow(((b + 0.055) / 1.055), 2.4) : (b / 12.92);

	var x = (r * 0.4124) + (g * 0.3576) + (b * 0.1805);
	var y = (r * 0.2126) + (g * 0.7152) + (b * 0.0722);
	var z = (r * 0.0193) + (g * 0.1192) + (b * 0.9505);

	return [x * 100, y * 100, z * 100];
};

convert.rgb.lab = function (rgb) {
	var xyz = convert.rgb.xyz(rgb);
	var x = xyz[0];
	var y = xyz[1];
	var z = xyz[2];
	var l;
	var a;
	var b;

	x /= 95.047;
	y /= 100;
	z /= 108.883;

	x = x > 0.008856 ? Math.pow(x, 1 / 3) : (7.787 * x) + (16 / 116);
	y = y > 0.008856 ? Math.pow(y, 1 / 3) : (7.787 * y) + (16 / 116);
	z = z > 0.008856 ? Math.pow(z, 1 / 3) : (7.787 * z) + (16 / 116);

	l = (116 * y) - 16;
	a = 500 * (x - y);
	b = 200 * (y - z);

	return [l, a, b];
};

convert.hsl.rgb = function (hsl) {
	var h = hsl[0] / 360;
	var s = hsl[1] / 100;
	var l = hsl[2] / 100;
	var t1;
	var t2;
	var t3;
	var rgb;
	var val;

	if (s === 0) {
		val = l * 255;
		return [val, val, val];
	}

	if (l < 0.5) {
		t2 = l * (1 + s);
	} else {
		t2 = l + s - l * s;
	}

	t1 = 2 * l - t2;

	rgb = [0, 0, 0];
	for (var i = 0; i < 3; i++) {
		t3 = h + 1 / 3 * -(i - 1);
		if (t3 < 0) {
			t3++;
		}
		if (t3 > 1) {
			t3--;
		}

		if (6 * t3 < 1) {
			val = t1 + (t2 - t1) * 6 * t3;
		} else if (2 * t3 < 1) {
			val = t2;
		} else if (3 * t3 < 2) {
			val = t1 + (t2 - t1) * (2 / 3 - t3) * 6;
		} else {
			val = t1;
		}

		rgb[i] = val * 255;
	}

	return rgb;
};

convert.hsl.hsv = function (hsl) {
	var h = hsl[0];
	var s = hsl[1] / 100;
	var l = hsl[2] / 100;
	var smin = s;
	var lmin = Math.max(l, 0.01);
	var sv;
	var v;

	l *= 2;
	s *= (l <= 1) ? l : 2 - l;
	smin *= lmin <= 1 ? lmin : 2 - lmin;
	v = (l + s) / 2;
	sv = l === 0 ? (2 * smin) / (lmin + smin) : (2 * s) / (l + s);

	return [h, sv * 100, v * 100];
};

convert.hsv.rgb = function (hsv) {
	var h = hsv[0] / 60;
	var s = hsv[1] / 100;
	var v = hsv[2] / 100;
	var hi = Math.floor(h) % 6;

	var f = h - Math.floor(h);
	var p = 255 * v * (1 - s);
	var q = 255 * v * (1 - (s * f));
	var t = 255 * v * (1 - (s * (1 - f)));
	v *= 255;

	switch (hi) {
		case 0:
			return [v, t, p];
		case 1:
			return [q, v, p];
		case 2:
			return [p, v, t];
		case 3:
			return [p, q, v];
		case 4:
			return [t, p, v];
		case 5:
			return [v, p, q];
	}
};

convert.hsv.hsl = function (hsv) {
	var h = hsv[0];
	var s = hsv[1] / 100;
	var v = hsv[2] / 100;
	var vmin = Math.max(v, 0.01);
	var lmin;
	var sl;
	var l;

	l = (2 - s) * v;
	lmin = (2 - s) * vmin;
	sl = s * vmin;
	sl /= (lmin <= 1) ? lmin : 2 - lmin;
	sl = sl || 0;
	l /= 2;

	return [h, sl * 100, l * 100];
};

// http://dev.w3.org/csswg/css-color/#hwb-to-rgb
convert.hwb.rgb = function (hwb) {
	var h = hwb[0] / 360;
	var wh = hwb[1] / 100;
	var bl = hwb[2] / 100;
	var ratio = wh + bl;
	var i;
	var v;
	var f;
	var n;

	// wh + bl cant be > 1
	if (ratio > 1) {
		wh /= ratio;
		bl /= ratio;
	}

	i = Math.floor(6 * h);
	v = 1 - bl;
	f = 6 * h - i;

	if ((i & 0x01) !== 0) {
		f = 1 - f;
	}

	n = wh + f * (v - wh); // linear interpolation

	var r;
	var g;
	var b;
	switch (i) {
		default:
		case 6:
		case 0: r = v; g = n; b = wh; break;
		case 1: r = n; g = v; b = wh; break;
		case 2: r = wh; g = v; b = n; break;
		case 3: r = wh; g = n; b = v; break;
		case 4: r = n; g = wh; b = v; break;
		case 5: r = v; g = wh; b = n; break;
	}

	return [r * 255, g * 255, b * 255];
};

convert.cmyk.rgb = function (cmyk) {
	var c = cmyk[0] / 100;
	var m = cmyk[1] / 100;
	var y = cmyk[2] / 100;
	var k = cmyk[3] / 100;
	var r;
	var g;
	var b;

	r = 1 - Math.min(1, c * (1 - k) + k);
	g = 1 - Math.min(1, m * (1 - k) + k);
	b = 1 - Math.min(1, y * (1 - k) + k);

	return [r * 255, g * 255, b * 255];
};

convert.xyz.rgb = function (xyz) {
	var x = xyz[0] / 100;
	var y = xyz[1] / 100;
	var z = xyz[2] / 100;
	var r;
	var g;
	var b;

	r = (x * 3.2406) + (y * -1.5372) + (z * -0.4986);
	g = (x * -0.9689) + (y * 1.8758) + (z * 0.0415);
	b = (x * 0.0557) + (y * -0.2040) + (z * 1.0570);

	// assume sRGB
	r = r > 0.0031308
		? ((1.055 * Math.pow(r, 1.0 / 2.4)) - 0.055)
		: r * 12.92;

	g = g > 0.0031308
		? ((1.055 * Math.pow(g, 1.0 / 2.4)) - 0.055)
		: g * 12.92;

	b = b > 0.0031308
		? ((1.055 * Math.pow(b, 1.0 / 2.4)) - 0.055)
		: b * 12.92;

	r = Math.min(Math.max(0, r), 1);
	g = Math.min(Math.max(0, g), 1);
	b = Math.min(Math.max(0, b), 1);

	return [r * 255, g * 255, b * 255];
};

convert.xyz.lab = function (xyz) {
	var x = xyz[0];
	var y = xyz[1];
	var z = xyz[2];
	var l;
	var a;
	var b;

	x /= 95.047;
	y /= 100;
	z /= 108.883;

	x = x > 0.008856 ? Math.pow(x, 1 / 3) : (7.787 * x) + (16 / 116);
	y = y > 0.008856 ? Math.pow(y, 1 / 3) : (7.787 * y) + (16 / 116);
	z = z > 0.008856 ? Math.pow(z, 1 / 3) : (7.787 * z) + (16 / 116);

	l = (116 * y) - 16;
	a = 500 * (x - y);
	b = 200 * (y - z);

	return [l, a, b];
};

convert.lab.xyz = function (lab) {
	var l = lab[0];
	var a = lab[1];
	var b = lab[2];
	var x;
	var y;
	var z;

	y = (l + 16) / 116;
	x = a / 500 + y;
	z = y - b / 200;

	var y2 = Math.pow(y, 3);
	var x2 = Math.pow(x, 3);
	var z2 = Math.pow(z, 3);
	y = y2 > 0.008856 ? y2 : (y - 16 / 116) / 7.787;
	x = x2 > 0.008856 ? x2 : (x - 16 / 116) / 7.787;
	z = z2 > 0.008856 ? z2 : (z - 16 / 116) / 7.787;

	x *= 95.047;
	y *= 100;
	z *= 108.883;

	return [x, y, z];
};

convert.lab.lch = function (lab) {
	var l = lab[0];
	var a = lab[1];
	var b = lab[2];
	var hr;
	var h;
	var c;

	hr = Math.atan2(b, a);
	h = hr * 360 / 2 / Math.PI;

	if (h < 0) {
		h += 360;
	}

	c = Math.sqrt(a * a + b * b);

	return [l, c, h];
};

convert.lch.lab = function (lch) {
	var l = lch[0];
	var c = lch[1];
	var h = lch[2];
	var a;
	var b;
	var hr;

	hr = h / 360 * 2 * Math.PI;
	a = c * Math.cos(hr);
	b = c * Math.sin(hr);

	return [l, a, b];
};

convert.rgb.ansi16 = function (args) {
	var r = args[0];
	var g = args[1];
	var b = args[2];
	var value = 1 in arguments ? arguments[1] : convert.rgb.hsv(args)[2]; // hsv -> ansi16 optimization

	value = Math.round(value / 50);

	if (value === 0) {
		return 30;
	}

	var ansi = 30
		+ ((Math.round(b / 255) << 2)
		| (Math.round(g / 255) << 1)
		| Math.round(r / 255));

	if (value === 2) {
		ansi += 60;
	}

	return ansi;
};

convert.hsv.ansi16 = function (args) {
	// optimization here; we already know the value and don't need to get
	// it converted for us.
	return convert.rgb.ansi16(convert.hsv.rgb(args), args[2]);
};

convert.rgb.ansi256 = function (args) {
	var r = args[0];
	var g = args[1];
	var b = args[2];

	// we use the extended greyscale palette here, with the exception of
	// black and white. normal palette only has 4 greyscale shades.
	if (r === g && g === b) {
		if (r < 8) {
			return 16;
		}

		if (r > 248) {
			return 231;
		}

		return Math.round(((r - 8) / 247) * 24) + 232;
	}

	var ansi = 16
		+ (36 * Math.round(r / 255 * 5))
		+ (6 * Math.round(g / 255 * 5))
		+ Math.round(b / 255 * 5);

	return ansi;
};

convert.ansi16.rgb = function (args) {
	var color = args % 10;

	// handle greyscale
	if (color === 0 || color === 7) {
		if (args > 50) {
			color += 3.5;
		}

		color = color / 10.5 * 255;

		return [color, color, color];
	}

	var mult = (~~(args > 50) + 1) * 0.5;
	var r = ((color & 1) * mult) * 255;
	var g = (((color >> 1) & 1) * mult) * 255;
	var b = (((color >> 2) & 1) * mult) * 255;

	return [r, g, b];
};

convert.ansi256.rgb = function (args) {
	// handle greyscale
	if (args >= 232) {
		var c = (args - 232) * 10 + 8;
		return [c, c, c];
	}

	args -= 16;

	var rem;
	var r = Math.floor(args / 36) / 5 * 255;
	var g = Math.floor((rem = args % 36) / 6) / 5 * 255;
	var b = (rem % 6) / 5 * 255;

	return [r, g, b];
};

convert.rgb.hex = function (args) {
	var integer = ((Math.round(args[0]) & 0xFF) << 16)
		+ ((Math.round(args[1]) & 0xFF) << 8)
		+ (Math.round(args[2]) & 0xFF);

	var string = integer.toString(16).toUpperCase();
	return '000000'.substring(string.length) + string;
};

convert.hex.rgb = function (args) {
	var match = args.toString(16).match(/[a-f0-9]{6}|[a-f0-9]{3}/i);
	if (!match) {
		return [0, 0, 0];
	}

	var colorString = match[0];

	if (match[0].length === 3) {
		colorString = colorString.split('').map(function (char) {
			return char + char;
		}).join('');
	}

	var integer = parseInt(colorString, 16);
	var r = (integer >> 16) & 0xFF;
	var g = (integer >> 8) & 0xFF;
	var b = integer & 0xFF;

	return [r, g, b];
};

convert.rgb.hcg = function (rgb) {
	var r = rgb[0] / 255;
	var g = rgb[1] / 255;
	var b = rgb[2] / 255;
	var max = Math.max(Math.max(r, g), b);
	var min = Math.min(Math.min(r, g), b);
	var chroma = (max - min);
	var grayscale;
	var hue;

	if (chroma < 1) {
		grayscale = min / (1 - chroma);
	} else {
		grayscale = 0;
	}

	if (chroma <= 0) {
		hue = 0;
	} else
	if (max === r) {
		hue = ((g - b) / chroma) % 6;
	} else
	if (max === g) {
		hue = 2 + (b - r) / chroma;
	} else {
		hue = 4 + (r - g) / chroma + 4;
	}

	hue /= 6;
	hue %= 1;

	return [hue * 360, chroma * 100, grayscale * 100];
};

convert.hsl.hcg = function (hsl) {
	var s = hsl[1] / 100;
	var l = hsl[2] / 100;
	var c = 1;
	var f = 0;

	if (l < 0.5) {
		c = 2.0 * s * l;
	} else {
		c = 2.0 * s * (1.0 - l);
	}

	if (c < 1.0) {
		f = (l - 0.5 * c) / (1.0 - c);
	}

	return [hsl[0], c * 100, f * 100];
};

convert.hsv.hcg = function (hsv) {
	var s = hsv[1] / 100;
	var v = hsv[2] / 100;

	var c = s * v;
	var f = 0;

	if (c < 1.0) {
		f = (v - c) / (1 - c);
	}

	return [hsv[0], c * 100, f * 100];
};

convert.hcg.rgb = function (hcg) {
	var h = hcg[0] / 360;
	var c = hcg[1] / 100;
	var g = hcg[2] / 100;

	if (c === 0.0) {
		return [g * 255, g * 255, g * 255];
	}

	var pure = [0, 0, 0];
	var hi = (h % 1) * 6;
	var v = hi % 1;
	var w = 1 - v;
	var mg = 0;

	switch (Math.floor(hi)) {
		case 0:
			pure[0] = 1; pure[1] = v; pure[2] = 0; break;
		case 1:
			pure[0] = w; pure[1] = 1; pure[2] = 0; break;
		case 2:
			pure[0] = 0; pure[1] = 1; pure[2] = v; break;
		case 3:
			pure[0] = 0; pure[1] = w; pure[2] = 1; break;
		case 4:
			pure[0] = v; pure[1] = 0; pure[2] = 1; break;
		default:
			pure[0] = 1; pure[1] = 0; pure[2] = w;
	}

	mg = (1.0 - c) * g;

	return [
		(c * pure[0] + mg) * 255,
		(c * pure[1] + mg) * 255,
		(c * pure[2] + mg) * 255
	];
};

convert.hcg.hsv = function (hcg) {
	var c = hcg[1] / 100;
	var g = hcg[2] / 100;

	var v = c + g * (1.0 - c);
	var f = 0;

	if (v > 0.0) {
		f = c / v;
	}

	return [hcg[0], f * 100, v * 100];
};

convert.hcg.hsl = function (hcg) {
	var c = hcg[1] / 100;
	var g = hcg[2] / 100;

	var l = g * (1.0 - c) + 0.5 * c;
	var s = 0;

	if (l > 0.0 && l < 0.5) {
		s = c / (2 * l);
	} else
	if (l >= 0.5 && l < 1.0) {
		s = c / (2 * (1 - l));
	}

	return [hcg[0], s * 100, l * 100];
};

convert.hcg.hwb = function (hcg) {
	var c = hcg[1] / 100;
	var g = hcg[2] / 100;
	var v = c + g * (1.0 - c);
	return [hcg[0], (v - c) * 100, (1 - v) * 100];
};

convert.hwb.hcg = function (hwb) {
	var w = hwb[1] / 100;
	var b = hwb[2] / 100;
	var v = 1 - b;
	var c = v - w;
	var g = 0;

	if (c < 1) {
		g = (v - c) / (1 - c);
	}

	return [hwb[0], c * 100, g * 100];
};

convert.apple.rgb = function (apple) {
	return [(apple[0] / 65535) * 255, (apple[1] / 65535) * 255, (apple[2] / 65535) * 255];
};

convert.rgb.apple = function (rgb) {
	return [(rgb[0] / 255) * 65535, (rgb[1] / 255) * 65535, (rgb[2] / 255) * 65535];
};

convert.gray.rgb = function (args) {
	return [args[0] / 100 * 255, args[0] / 100 * 255, args[0] / 100 * 255];
};

convert.gray.hsl = convert.gray.hsv = function (args) {
	return [0, 0, args[0]];
};

convert.gray.hwb = function (gray) {
	return [0, 100, gray[0]];
};

convert.gray.cmyk = function (gray) {
	return [0, 0, 0, gray[0]];
};

convert.gray.lab = function (gray) {
	return [gray[0], 0, 0];
};

convert.gray.hex = function (gray) {
	var val = Math.round(gray[0] / 100 * 255) & 0xFF;
	var integer = (val << 16) + (val << 8) + val;

	var string = integer.toString(16).toUpperCase();
	return '000000'.substring(string.length) + string;
};

convert.rgb.gray = function (rgb) {
	var val = (rgb[0] + rgb[1] + rgb[2]) / 3;
	return [val / 255 * 100];
};


/***/ }),
/* 18 */
/***/ (function(module, exports) {

module.exports = {
	"aliceblue": [240, 248, 255],
	"antiquewhite": [250, 235, 215],
	"aqua": [0, 255, 255],
	"aquamarine": [127, 255, 212],
	"azure": [240, 255, 255],
	"beige": [245, 245, 220],
	"bisque": [255, 228, 196],
	"black": [0, 0, 0],
	"blanchedalmond": [255, 235, 205],
	"blue": [0, 0, 255],
	"blueviolet": [138, 43, 226],
	"brown": [165, 42, 42],
	"burlywood": [222, 184, 135],
	"cadetblue": [95, 158, 160],
	"chartreuse": [127, 255, 0],
	"chocolate": [210, 105, 30],
	"coral": [255, 127, 80],
	"cornflowerblue": [100, 149, 237],
	"cornsilk": [255, 248, 220],
	"crimson": [220, 20, 60],
	"cyan": [0, 255, 255],
	"darkblue": [0, 0, 139],
	"darkcyan": [0, 139, 139],
	"darkgoldenrod": [184, 134, 11],
	"darkgray": [169, 169, 169],
	"darkgreen": [0, 100, 0],
	"darkgrey": [169, 169, 169],
	"darkkhaki": [189, 183, 107],
	"darkmagenta": [139, 0, 139],
	"darkolivegreen": [85, 107, 47],
	"darkorange": [255, 140, 0],
	"darkorchid": [153, 50, 204],
	"darkred": [139, 0, 0],
	"darksalmon": [233, 150, 122],
	"darkseagreen": [143, 188, 143],
	"darkslateblue": [72, 61, 139],
	"darkslategray": [47, 79, 79],
	"darkslategrey": [47, 79, 79],
	"darkturquoise": [0, 206, 209],
	"darkviolet": [148, 0, 211],
	"deeppink": [255, 20, 147],
	"deepskyblue": [0, 191, 255],
	"dimgray": [105, 105, 105],
	"dimgrey": [105, 105, 105],
	"dodgerblue": [30, 144, 255],
	"firebrick": [178, 34, 34],
	"floralwhite": [255, 250, 240],
	"forestgreen": [34, 139, 34],
	"fuchsia": [255, 0, 255],
	"gainsboro": [220, 220, 220],
	"ghostwhite": [248, 248, 255],
	"gold": [255, 215, 0],
	"goldenrod": [218, 165, 32],
	"gray": [128, 128, 128],
	"green": [0, 128, 0],
	"greenyellow": [173, 255, 47],
	"grey": [128, 128, 128],
	"honeydew": [240, 255, 240],
	"hotpink": [255, 105, 180],
	"indianred": [205, 92, 92],
	"indigo": [75, 0, 130],
	"ivory": [255, 255, 240],
	"khaki": [240, 230, 140],
	"lavender": [230, 230, 250],
	"lavenderblush": [255, 240, 245],
	"lawngreen": [124, 252, 0],
	"lemonchiffon": [255, 250, 205],
	"lightblue": [173, 216, 230],
	"lightcoral": [240, 128, 128],
	"lightcyan": [224, 255, 255],
	"lightgoldenrodyellow": [250, 250, 210],
	"lightgray": [211, 211, 211],
	"lightgreen": [144, 238, 144],
	"lightgrey": [211, 211, 211],
	"lightpink": [255, 182, 193],
	"lightsalmon": [255, 160, 122],
	"lightseagreen": [32, 178, 170],
	"lightskyblue": [135, 206, 250],
	"lightslategray": [119, 136, 153],
	"lightslategrey": [119, 136, 153],
	"lightsteelblue": [176, 196, 222],
	"lightyellow": [255, 255, 224],
	"lime": [0, 255, 0],
	"limegreen": [50, 205, 50],
	"linen": [250, 240, 230],
	"magenta": [255, 0, 255],
	"maroon": [128, 0, 0],
	"mediumaquamarine": [102, 205, 170],
	"mediumblue": [0, 0, 205],
	"mediumorchid": [186, 85, 211],
	"mediumpurple": [147, 112, 219],
	"mediumseagreen": [60, 179, 113],
	"mediumslateblue": [123, 104, 238],
	"mediumspringgreen": [0, 250, 154],
	"mediumturquoise": [72, 209, 204],
	"mediumvioletred": [199, 21, 133],
	"midnightblue": [25, 25, 112],
	"mintcream": [245, 255, 250],
	"mistyrose": [255, 228, 225],
	"moccasin": [255, 228, 181],
	"navajowhite": [255, 222, 173],
	"navy": [0, 0, 128],
	"oldlace": [253, 245, 230],
	"olive": [128, 128, 0],
	"olivedrab": [107, 142, 35],
	"orange": [255, 165, 0],
	"orangered": [255, 69, 0],
	"orchid": [218, 112, 214],
	"palegoldenrod": [238, 232, 170],
	"palegreen": [152, 251, 152],
	"paleturquoise": [175, 238, 238],
	"palevioletred": [219, 112, 147],
	"papayawhip": [255, 239, 213],
	"peachpuff": [255, 218, 185],
	"peru": [205, 133, 63],
	"pink": [255, 192, 203],
	"plum": [221, 160, 221],
	"powderblue": [176, 224, 230],
	"purple": [128, 0, 128],
	"rebeccapurple": [102, 51, 153],
	"red": [255, 0, 0],
	"rosybrown": [188, 143, 143],
	"royalblue": [65, 105, 225],
	"saddlebrown": [139, 69, 19],
	"salmon": [250, 128, 114],
	"sandybrown": [244, 164, 96],
	"seagreen": [46, 139, 87],
	"seashell": [255, 245, 238],
	"sienna": [160, 82, 45],
	"silver": [192, 192, 192],
	"skyblue": [135, 206, 235],
	"slateblue": [106, 90, 205],
	"slategray": [112, 128, 144],
	"slategrey": [112, 128, 144],
	"snow": [255, 250, 250],
	"springgreen": [0, 255, 127],
	"steelblue": [70, 130, 180],
	"tan": [210, 180, 140],
	"teal": [0, 128, 128],
	"thistle": [216, 191, 216],
	"tomato": [255, 99, 71],
	"turquoise": [64, 224, 208],
	"violet": [238, 130, 238],
	"wheat": [245, 222, 179],
	"white": [255, 255, 255],
	"whitesmoke": [245, 245, 245],
	"yellow": [255, 255, 0],
	"yellowgreen": [154, 205, 50]
};

/***/ }),
/* 19 */
/***/ (function(module, exports) {

module.exports = {
	"author": "Shane Brinkman-Davis Delamore, Imikimi LLC",
	"dependencies": {
		"art-build-configurator": "*",
		"art-class-system": "*",
		"art-config": "*",
		"art-standard-lib": "*",
		"art-testbench": "*",
		"bluebird": "^3.5.0",
		"caffeine-script": "*",
		"caffeine-script-runtime": "*",
		"case-sensitive-paths-webpack-plugin": "^2.1.1",
		"chai": "^4.0.1",
		"coffee-loader": "^0.7.3",
		"coffee-script": "^1.12.6",
		"colors": "^1.1.2",
		"commander": "^2.9.0",
		"css-loader": "^0.28.4",
		"dateformat": "^2.0.0",
		"detect-node": "^2.0.3",
		"fs-extra": "^3.0.1",
		"glob": "^7.1.2",
		"glob-promise": "^3.1.0",
		"json-loader": "^0.5.4",
		"mocha": "^3.4.2",
		"neptune-namespaces": "*",
		"script-loader": "^0.7.0",
		"style-loader": "^0.18.1",
		"webpack": "^2.6.1",
		"webpack-dev-server": "^2.4.5",
		"webpack-merge": "^4.1.0",
		"webpack-node-externals": "^1.6.0"
	},
	"description": "a 'runtime' parsing expression grammar parser",
	"license": "ISC",
	"name": "babel-bridge",
	"scripts": {
		"build": "webpack --progress",
		"start": "webpack-dev-server --hot --inline --progress",
		"test": "nn -s;mocha -u tdd --compilers coffee:coffee-script/register",
		"testInBrowser": "webpack-dev-server --progress"
	},
	"version": "1.12.8"
};

/***/ }),
/* 20 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(7);

module.exports.includeInNamespace(__webpack_require__(23)).addModules({
  BabelBridgeCompileError: __webpack_require__(8),
  NonMatch: __webpack_require__(12),
  Parser: __webpack_require__(28),
  PatternElement: __webpack_require__(13),
  Repl: __webpack_require__(6),
  Rule: __webpack_require__(14),
  RuleVariant: __webpack_require__(15),
  Stats: __webpack_require__(3),
  Tools: __webpack_require__(16)
});

__webpack_require__(25);

__webpack_require__(2);


/***/ }),
/* 21 */
/***/ (function(module, exports) {

var clone = (function() {
'use strict';

/**
 * Clones (copies) an Object using deep copying.
 *
 * This function supports circular references by default, but if you are certain
 * there are no circular references in your object, you can save some CPU time
 * by calling clone(obj, false).
 *
 * Caution: if `circular` is false and `parent` contains circular references,
 * your program may enter an infinite loop and crash.
 *
 * @param `parent` - the object to be cloned
 * @param `circular` - set to true if the object to be cloned may contain
 *    circular references. (optional - true by default)
 * @param `depth` - set to a number if the object is only to be cloned to
 *    a particular depth. (optional - defaults to Infinity)
 * @param `prototype` - sets the prototype to be used when cloning an object.
 *    (optional - defaults to parent prototype).
*/
function clone(parent, circular, depth, prototype) {
  var filter;
  if (typeof circular === 'object') {
    depth = circular.depth;
    prototype = circular.prototype;
    filter = circular.filter;
    circular = circular.circular
  }
  // maintain two arrays for circular references, where corresponding parents
  // and children have the same index
  var allParents = [];
  var allChildren = [];

  var useBuffer = typeof Buffer != 'undefined';

  if (typeof circular == 'undefined')
    circular = true;

  if (typeof depth == 'undefined')
    depth = Infinity;

  // recurse this function so we don't reset allParents and allChildren
  function _clone(parent, depth) {
    // cloning null always returns null
    if (parent === null)
      return null;

    if (depth == 0)
      return parent;

    var child;
    var proto;
    if (typeof parent != 'object') {
      return parent;
    }

    if (clone.__isArray(parent)) {
      child = [];
    } else if (clone.__isRegExp(parent)) {
      child = new RegExp(parent.source, __getRegExpFlags(parent));
      if (parent.lastIndex) child.lastIndex = parent.lastIndex;
    } else if (clone.__isDate(parent)) {
      child = new Date(parent.getTime());
    } else if (useBuffer && Buffer.isBuffer(parent)) {
      child = new Buffer(parent.length);
      parent.copy(child);
      return child;
    } else {
      if (typeof prototype == 'undefined') {
        proto = Object.getPrototypeOf(parent);
        child = Object.create(proto);
      }
      else {
        child = Object.create(prototype);
        proto = prototype;
      }
    }

    if (circular) {
      var index = allParents.indexOf(parent);

      if (index != -1) {
        return allChildren[index];
      }
      allParents.push(parent);
      allChildren.push(child);
    }

    for (var i in parent) {
      var attrs;
      if (proto) {
        attrs = Object.getOwnPropertyDescriptor(proto, i);
      }

      if (attrs && attrs.set == null) {
        continue;
      }
      child[i] = _clone(parent[i], depth - 1);
    }

    return child;
  }

  return _clone(parent, depth);
}

/**
 * Simple flat clone using prototype, accepts only objects, usefull for property
 * override on FLAT configuration object (no nested props).
 *
 * USE WITH CAUTION! This may not behave as you wish if you do not know how this
 * works.
 */
clone.clonePrototype = function clonePrototype(parent) {
  if (parent === null)
    return null;

  var c = function () {};
  c.prototype = parent;
  return new c();
};

// private utility functions

function __objToStr(o) {
  return Object.prototype.toString.call(o);
};
clone.__objToStr = __objToStr;

function __isDate(o) {
  return typeof o === 'object' && __objToStr(o) === '[object Date]';
};
clone.__isDate = __isDate;

function __isArray(o) {
  return typeof o === 'object' && __objToStr(o) === '[object Array]';
};
clone.__isArray = __isArray;

function __isRegExp(o) {
  return typeof o === 'object' && __objToStr(o) === '[object RegExp]';
};
clone.__isRegExp = __isRegExp;

function __getRegExpFlags(re) {
  var flags = '';
  if (re.global) flags += 'g';
  if (re.ignoreCase) flags += 'i';
  if (re.multiline) flags += 'm';
  return flags;
};
clone.__getRegExpFlags = __getRegExpFlags;

return clone;
})();

if (typeof module === 'object' && module.exports) {
  module.exports = clone;
}


/***/ }),
/* 22 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(20);


/***/ }),
/* 23 */
/***/ (function(module, exports, __webpack_require__) {

var isClass, log, ref;

ref = __webpack_require__(0), isClass = ref.isClass, log = ref.log;

module.exports = [
  __webpack_require__(6), {
    version: (__webpack_require__(19)).version
  }
];


/***/ }),
/* 24 */
/***/ (function(module, exports, __webpack_require__) {

/* WEBPACK VAR INJECTION */(function(module) {var Node, array, defineModule, escapeJavascriptString, find, log, merge, ref;

ref = __webpack_require__(0), array = ref.array, defineModule = ref.defineModule, log = ref.log, merge = ref.merge, escapeJavascriptString = ref.escapeJavascriptString, find = ref.find;

Node = __webpack_require__(2).Node;

defineModule(module, function() {
  var IndentBlocks;
  return IndentBlocks = (function() {
    var blockLinesRegExp, blockStartRegExp, computeSubsourceToParentSourceMap, matchBlock, matchToEolAndBlock, toEolContent;

    function IndentBlocks() {}

    blockStartRegExp = /\n(?: *\n)*( +)(?=$|[^ \n])/y;

    toEolContent = /(\ *)((?:\ *[^ \n]+)+)\ */y;

    blockLinesRegExp = function(indent) {
      return RegExp("((?:\\s*\\n)(?:" + indent + " *[^\\n ][^\\n]*))+", "y");
    };


    /*
    TODO:
      for matchBlock and matchToEolAndBlock
    
      We also need a source-offset mapper from the new source back to the old-source.
    
      I think the map should just be part of the returned object
     */

    IndentBlocks.matchBlock = matchBlock = function(source, sourceOffset, returnRawMatch) {
      var __, indent, length, linesRegExp, match, rawSubsource, replaceRegExp, replaceWith, subsource, subsourceToParentSourceMap;
      if (returnRawMatch == null) {
        returnRawMatch = false;
      }
      blockStartRegExp.lastIndex = sourceOffset;
      if (match = blockStartRegExp.exec(source)) {
        __ = match[0], indent = match[1];
        length = indent.length;
        linesRegExp = blockLinesRegExp(indent);
        linesRegExp.lastIndex = sourceOffset;
        rawSubsource = linesRegExp.exec(source)[0];
        replaceRegExp = RegExp("(?:^\\n" + indent + ")|(\\n)(?:" + indent + ")", "g");
        replaceWith = "$1";
        subsourceToParentSourceMap = null;
        subsource = returnRawMatch ? rawSubsource : rawSubsource.replace(replaceRegExp, "$1");
        return {
          matchLength: rawSubsource.length,
          subsource: subsource,
          sourceMap: returnRawMatch ? function(suboffset) {
            return suboffset + sourceOffset;
          } : function(suboffset) {
            var bestMapEntry;
            subsourceToParentSourceMap || (subsourceToParentSourceMap = computeSubsourceToParentSourceMap(sourceOffset, replaceRegExp, indent, rawSubsource));
            bestMapEntry = find(subsourceToParentSourceMap, function(entry) {
              if (suboffset < entry.subsourceEndOffset) {
                return entry;
              }
            });
            return suboffset + bestMapEntry.toSourceDelta;
          }
        };
      }
    };

    computeSubsourceToParentSourceMap = function(sourceBaseOffset, replaceRegExp, indent, rawSubsource) {
      var indentLength, indentWithNewLineLength, indexes, keptLength, match, matchLength, ref1, removedLength, sourceEndOffset, sourceOffset, subsourceEndOffset, subsourceOffset, toSourceDelta;
      indentLength = indent.length;
      indentWithNewLineLength = indentLength + 1;
      indexes = [];
      sourceOffset = toSourceDelta = sourceBaseOffset;
      subsourceOffset = subsourceEndOffset = 0;
      while (match = replaceRegExp.exec(rawSubsource)) {
        matchLength = match[0].length;
        keptLength = ((ref1 = match[1]) != null ? ref1.length : void 0) || 0;
        removedLength = matchLength - keptLength;
        sourceEndOffset = match.index + sourceBaseOffset + matchLength;
        subsourceEndOffset += sourceEndOffset - sourceOffset - removedLength;
        indexes.push({
          keptLength: keptLength,
          removedLength: removedLength,
          sourceOffset: sourceOffset,
          subsourceOffset: subsourceOffset,
          toSourceDelta: toSourceDelta,
          sourceEndOffset: sourceEndOffset,
          subsourceEndOffset: subsourceEndOffset
        });
        toSourceDelta += removedLength;
        sourceOffset = sourceEndOffset;
        subsourceOffset = subsourceEndOffset;
      }
      sourceEndOffset = sourceBaseOffset + rawSubsource.length;
      subsourceEndOffset = sourceEndOffset - sourceOffset + sourceOffset;
      indexes.push({
        sourceOffset: sourceOffset,
        subsourceOffset: subsourceOffset,
        toSourceDelta: toSourceDelta,
        sourceEndOffset: sourceEndOffset,
        subsourceEndOffset: subsourceEndOffset
      });
      return indexes;
    };

    IndentBlocks.matchToEolAndBlock = matchToEolAndBlock = function(source, offset) {
      var blockMatch, eolMatch, matchLength, sourceMatched, spaces;
      toEolContent.lastIndex = offset;
      if (eolMatch = toEolContent.exec(source)) {
        sourceMatched = eolMatch[0], spaces = eolMatch[1];
        matchLength = sourceMatched.length;
        if (blockMatch = matchBlock(source, offset + matchLength, true)) {
          matchLength += blockMatch.matchLength;
        }
        return {
          subsource: source.slice(offset + spaces.length, offset + matchLength),
          sourceMap: function(suboffset) {
            return offset + spaces.length + suboffset;
          },
          matchLength: matchLength
        };
      } else {
        return matchBlock(source, offset);
      }
    };

    IndentBlocks.getParseFunction = function(matcher, subparseOptions) {
      return {
        parse: function(parentNode) {
          var block, matchLength, offset, source, sourceMap, subsource;
          offset = parentNode.nextOffset, source = parentNode.source;
          if (block = matcher(source, offset)) {
            subsource = block.subsource, matchLength = block.matchLength, sourceMap = block.sourceMap;
            return parentNode.subparse(subsource, merge(subparseOptions, {
              originalOffset: offset,
              originalMatchLength: matchLength,
              sourceMap: sourceMap
            }));
          }
        }
      };
    };

    IndentBlocks.getPropsToSubparseBlock = function(subparseOptions) {
      if (subparseOptions == null) {
        subparseOptions = {};
      }
      return IndentBlocks.getParseFunction(IndentBlocks.matchBlock, subparseOptions);
    };

    IndentBlocks.getPropsToSubparseToEolAndBlock = function(subparseOptions) {
      if (subparseOptions == null) {
        subparseOptions = {};
      }
      return IndentBlocks.getParseFunction(IndentBlocks.matchToEolAndBlock, subparseOptions);
    };

    return IndentBlocks;

  })();
});

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(4)(module)))

/***/ }),
/* 25 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(9);

module.exports.addModules({
  IndentBlocks: __webpack_require__(24)
});


/***/ }),
/* 26 */
/***/ (function(module, exports, __webpack_require__) {

var EmptyOptionalNode,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

module.exports = EmptyOptionalNode = (function(superClass) {
  extend(EmptyOptionalNode, superClass);

  function EmptyOptionalNode() {
    return EmptyOptionalNode.__super__.constructor.apply(this, arguments);
  }

  EmptyOptionalNode.getter({
    present: function() {
      return false;
    }
  });

  return EmptyOptionalNode;

})(__webpack_require__(10));


/***/ }),
/* 27 */
/***/ (function(module, exports, __webpack_require__) {

/* WEBPACK VAR INJECTION */(function(module) {var BaseClass, ScratchNode, compactFlatten, defineModule, inspect, isPlainObject, isString, log, merge, pad, push, ref, toInspectedObjects, upperCamelCase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ref = __webpack_require__(0), log = ref.log, defineModule = ref.defineModule, toInspectedObjects = ref.toInspectedObjects, isPlainObject = ref.isPlainObject, push = ref.push, isString = ref.isString, compactFlatten = ref.compactFlatten, inspect = ref.inspect, pad = ref.pad, upperCamelCase = ref.upperCamelCase, merge = ref.merge;

BaseClass = __webpack_require__(1).BaseClass;

defineModule(module, ScratchNode = (function(superClass) {
  extend(ScratchNode, superClass);

  ScratchNode._scatchNodes = [];

  ScratchNode._scatchNodesInUse = 0;

  ScratchNode.checkout = function(parentNode, ruleVariant) {
    if (this._scatchNodesInUse >= this._scatchNodes.length) {
      return this._scatchNodes[this._scatchNodesInUse++] = new ScratchNode(parentNode, ruleVariant);
    } else {
      return this._scatchNodes[this._scatchNodesInUse++].reset(parentNode, ruleVariant);
    }
  };

  ScratchNode.checkin = function(scratchNode) {
    if (scratchNode !== this._scatchNodes[--this._scatchNodesInUse]) {
      throw new Error("WTF");
    }
  };

  function ScratchNode(parent, ruleVariant) {
    this.matches = [];
    this.matchPatterns = [];
    this.reset(parent, ruleVariant);
  }

  ScratchNode.prototype.reset = function(parent1, ruleVariant1) {
    this.parent = parent1;
    this.ruleVariant = ruleVariant1;
    this._parser = this.parent._parser;
    this.offset = this.parent.getNextOffset() | 0;
    this.matchesLength = this.matchPatternsLength = this.matchLength = 0;
    this.variantNode = null;
    return this;
  };

  ScratchNode.getter("parser", {
    source: function() {
      return this._parser.source;
    },
    nextOffset: function() {
      return this.offset + this.matchLength;
    },
    inspectedObjects: function() {
      return {
        offset: this.offset,
        matchLength: this.matchLength,
        matches: toInspectedObjects(this.matches),
        matchPatterns: toInspectedObjects(this.matchPatterns)
      };
    }
  });

  ScratchNode.prototype.getNextText = function(length) {
    var nextOffset;
    nextOffset = this.getNextOffset();
    return this.source.slice(nextOffset, nextOffset + length);
  };

  ScratchNode.getter({
    firstPartialMatchParent: function() {
      return this.realNode.firstPartialMatchParent;
    },
    realNode: function() {
      return this.variantNode || (this.variantNode = new this.ruleVariant.VariantNodeClass(this.parent.realNode || this._parser, {
        ruleVariant: this.ruleVariant,
        matchLength: this.matchLength,
        matches: this.matchesLength > 0 && this.matches.slice(0, this.matchesLength),
        matchPatterns: this.matchPatternsLength > 0 && this.matchPatterns.slice(0, this.matchPatternsLength)
      }));
    }
  });

  ScratchNode.prototype.checkin = function() {
    return ScratchNode.checkin(this);
  };

  ScratchNode.prototype.subparse = function(subSource, options) {
    return this._parser.subparse(subSource, merge(options, {
      parentNode: this
    }));
  };

  ScratchNode.prototype.addMatch = function(pattern, match) {
    var ref1;
    if (!match) {
      return false;
    }
    if ((ref1 = this.variantNode) != null) {
      ref1.addMatch(pattern, match);
    }
    this.matches[this.matchesLength++] = match;
    this.matchPatterns[this.matchPatternsLength++] = pattern;
    this.matchLength = match.nextOffset - this.offset;
    return true;
  };

  ScratchNode.prototype._addToParentAsNonMatch = function() {
    return this.realNode._addToParentAsNonMatch();
  };

  return ScratchNode;

})(BaseClass));

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(4)(module)))

/***/ }),
/* 28 */
/***/ (function(module, exports, __webpack_require__) {

var BabelBridgeCompileError, Node, NonMatch, Parser, Rule, Stats, compactFlatten, formattedInspect, getLineColumn, getLineColumnString, inspect, inspectLean, isClass, isFunction, isPlainArray, isPlainObject, log, max, merge, mergeInto, objectHasKeys, objectLength, objectWithout, peek, pluralize, pushIfNotPresent, ref, ref1, uniqueValues, upperCamelCase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

Rule = __webpack_require__(14);

ref = __webpack_require__(16), getLineColumn = ref.getLineColumn, getLineColumnString = ref.getLineColumnString;

Node = __webpack_require__(2).Node;

NonMatch = __webpack_require__(12);

Stats = __webpack_require__(3);

ref1 = __webpack_require__(0), isFunction = ref1.isFunction, peek = ref1.peek, log = ref1.log, isPlainObject = ref1.isPlainObject, isPlainArray = ref1.isPlainArray, merge = ref1.merge, compactFlatten = ref1.compactFlatten, objectLength = ref1.objectLength, inspect = ref1.inspect, inspectLean = ref1.inspectLean, pluralize = ref1.pluralize, isClass = ref1.isClass, isPlainArray = ref1.isPlainArray, upperCamelCase = ref1.upperCamelCase, mergeInto = ref1.mergeInto, objectWithout = ref1.objectWithout, uniqueValues = ref1.uniqueValues, formattedInspect = ref1.formattedInspect, max = ref1.max, inspect = ref1.inspect, pushIfNotPresent = ref1.pushIfNotPresent, uniqueValues = ref1.uniqueValues, objectHasKeys = ref1.objectHasKeys;

BabelBridgeCompileError = __webpack_require__(8);

module.exports = Parser = (function(superClass) {
  var addToExpectingInfo, firstLines, instanceRulesFunction, lastLines, rulesFunction;

  extend(Parser, superClass);

  Parser.repl = function() {
    return (__webpack_require__(6)).babelBridgeRepl(this);
  };

  Parser.parse = function(_source, options) {
    this._source = _source;
    if (options == null) {
      options = {};
    }
    return (new this).parse(this._source, options);
  };

  Parser.classGetter({
    rootRuleName: function() {
      return this._rootRuleName || "root";
    },
    rootRule: function() {
      return this.getRules()[this._rootRuleName];
    }
  });

  Parser.extendableProperty({
    rules: {}
  }, function(extendableRules, newRules) {
    var newRule, ruleName;
    for (ruleName in a) {
      newRule = a[ruleName];
      extendableRules[ruleName] = newRule.clone();
    }
    return newRule;
  });

  Parser.addRule = function(ruleName, definitions, nodeBaseClass) {
    var array, base, commonNodeProps, definition, i, j, last, len, pattern, patterns, ref2, results, rule;
    if (nodeBaseClass == null) {
      nodeBaseClass = this.getNodeBaseClass();
    }
    rule = (base = this.extendRules())[ruleName] || (base[ruleName] = new Rule(ruleName, this));
    if (definitions.root) {
      if (this._rootRuleName) {
        throw new Error("root rule already defined! was: " + this._rootRuleName + ", wanted: " + ruleName);
      }
      this._rootRuleName = ruleName;
    }
    if (!isPlainArray(array = definitions)) {
      definitions = [definitions];
    }
    if (definitions.length > 1 && isPlainObject(last = peek(definitions)) && !last.pattern) {
      ref2 = definitions, definitions = 2 <= ref2.length ? slice.call(ref2, 0, i = ref2.length - 1) : (i = 0, []), commonNodeProps = ref2[i++];
    } else {
      commonNodeProps = {};
    }
    commonNodeProps.nodeBaseClass || (commonNodeProps.nodeBaseClass = nodeBaseClass);
    results = [];
    for (j = 0, len = definitions.length; j < len; j++) {
      definition = definitions[j];
      if (!isPlainObject(definition)) {
        definition = {
          pattern: definition
        };
      }
      if (isPlainArray(patterns = definition.pattern)) {
        results.push((function() {
          var l, len1, results1;
          results1 = [];
          for (l = 0, len1 = patterns.length; l < len1; l++) {
            pattern = patterns[l];
            results1.push(rule.addVariant(merge(commonNodeProps, definition, {
              pattern: pattern
            })));
          }
          return results1;
        })());
      } else {
        results.push(rule.addVariant(merge(commonNodeProps, definition)));
      }
    }
    return results;
  };


  /*
  IN:
    rules: plain object mapping rule-names to definitions
    nodeClass: optional, must extend BabelBridge.Node or be a plain object
   */

  Parser.rule = rulesFunction = function(a, b) {
    var definition, results, ruleName, rules, sharedNodeBaseClass;
    if (isClass(a)) {
      sharedNodeBaseClass = a;
      rules = b;
    } else {
      rules = a;
      sharedNodeBaseClass = b;
    }
    if (isPlainObject(sharedNodeBaseClass)) {
      sharedNodeBaseClass = this.getNodeBaseClass().createSubclass(sharedNodeBaseClass);
    }
    results = [];
    for (ruleName in rules) {
      definition = rules[ruleName];
      results.push(this.addRule(ruleName, definition, sharedNodeBaseClass || this.getNodeBaseClass()));
    }
    return results;
  };

  Parser.rules = rulesFunction;

  Parser.prototype.rule = instanceRulesFunction = function(a, b) {
    return this["class"].rule(a, b);
  };

  Parser.prototype.rules = instanceRulesFunction;

  Parser.getNodeBaseClass = function() {
    return this._nodeBaseClass || (this._nodeBaseClass = isPlainObject(this.nodeBaseClass) ? (log({
      create: this.getName() + "NodeBaseClass"
    }), Node.createSubclass(merge({
      name: this.getName() + "NodeBaseClass"
    }, this.nodeBaseClass))) : this.nodeBaseClass || Node);
  };

  Parser.property("subparseInfo options");

  Parser.getter("source parser", {
    rootRuleName: function() {
      return this["class"].getRootRuleName();
    },
    rootRule: function() {
      return this["class"].getRootRule();
    },
    nextOffset: function() {
      return 0;
    },
    rootParser: function() {
      var ref2;
      return ((ref2 = this.parentParser) != null ? ref2.rootParser : void 0) || this;
    },
    ancestors: function(into) {
      into.push(this);
      return into;
    },
    parseInfo: function() {
      return "Parser";
    }
  });

  function Parser() {
    Parser.__super__.constructor.apply(this, arguments);
    this._options = null;
    this._parser = this;
    this._source = null;
    this._resetParserTracking();
  }

  Parser._pluralNames = {};

  Parser.pluralize = function(name) {
    var base;
    return (base = this._pluralNames)[name] || (base[name] = pluralize(name));
  };

  Parser.prototype.pluralize = function(name) {
    return this["class"].pluralize(name);
  };


  /*
  IN:
    subsource:
      any string what-so-ever
    options:
      [all of @parse's options plus:]
      parentNode: (required)
        the resulting Node's parent
  
      originalMatchLength: (required)
        matchLength from @source that subsource was generated from.
  
      originalOffset: starting offset in parentParser.source
  
      sourceMap: (subsourceOffset) -> parentSourceOffset
  
    The original source we are sub-parsing from must be:
  
      parentNode.getNextText originalMatchLength
  
  OUT: a Node with offset and matchLength
   */

  Parser.prototype.subparse = function(subsource, options) {
    var failureIndex, k, match, matchLength, nonMatch, offset, originalMatchLength, originalOffset, parentNode, parser, ref2, rootNode, source, sourceMap, subparser;
    if (options == null) {
      options = {};
    }
    Stats.add("subparse");
    subparser = new this["class"];
    originalMatchLength = options.originalMatchLength, parentNode = options.parentNode, sourceMap = options.sourceMap, originalOffset = options.originalOffset;
    options.parentParser = this;
    if (match = subparser.parse(subsource, merge(options, {
      isSubparse: true,
      logParsingFailures: this._logParsingFailures
    }))) {
      offset = match.offset, matchLength = match.matchLength, source = match.source, parser = match.parser;
      match.subparseInfo = {
        offset: offset,
        matchLength: matchLength,
        source: source,
        parser: parser
      };
      if (match.matchLength < subsource.length) {
        if (match.text !== parentNode.getNextText(match.matchLength)) {
          throw new Error("INTERNAL TODO: SubParse was a partial match, but a source-map is required to determine the matchLength in the original source.");
        }
        originalMatchLength = match.matchLength;
      }
      match.offset = parentNode.nextOffset;
      match.matchLength = originalMatchLength;
      match._parent = parentNode;
      return match;
    } else {
      failureIndex = subparser.failureIndexInParentParser;
      ref2 = subparser._nonMatches;
      for (k in ref2) {
        nonMatch = ref2[k];
        rootNode = nonMatch.node;
        while (rootNode !== parentNode && rootNode.parent instanceof Node) {
          rootNode = rootNode.parent;
        }
        if (rootNode !== parentNode) {
          rootNode._parent = parentNode;
        }
        if (this._logParsingFailures) {
          this._addNonMatch(failureIndex, nonMatch);
        } else {
          this._failureIndex = max(this._failureIndex, failureIndex);
        }
      }
      return null;
    }
  };

  Parser.prototype.offsetInParentParserSource = function(suboffset) {
    var originalOffset, ref2, ref3, sourceMap;
    ref2 = this.options, sourceMap = ref2.sourceMap, originalOffset = (ref3 = ref2.originalOffset) != null ? ref3 : 0;
    if (sourceMap) {
      return sourceMap(suboffset);
    } else if (this.parentParser) {
      return this.options.originalOffset + suboffset;
    } else {
      return suboffset;
    }
  };

  Parser.prototype.offsetInRootParserSource = function(suboffset) {
    if (this.parentParser) {
      return this.parentParser.offsetInRootParserSource(this.offsetInParentParserSource(suboffset));
    } else {
      return suboffset;
    }
  };

  Parser.getter({
    failureIndexInParentParser: function() {
      return this.offsetInParentParserSource(this._failureIndex);
    }
  });

  Parser.prototype.colorString = function(clr, str) {
    if (this.options.color) {
      return ("" + str)[clr];
    } else {
      return str;
    }
  };


  /*
  OUT: on success, root Node of the parse tree, else null
  options:
    allowPartialMatch: true/false
   */

  Parser.prototype.parse = function(_source, options1) {
    var allowPartialMatch, isSubparse, logParsingFailures, ref2, result, rule, startRule;
    this._source = _source;
    this.options = options1 != null ? options1 : {};
    ref2 = this.options, this.parentParser = ref2.parentParser, allowPartialMatch = ref2.allowPartialMatch, rule = ref2.rule, isSubparse = ref2.isSubparse, logParsingFailures = ref2.logParsingFailures;
    startRule = this.getRule(rule);
    this._resetParserTracking();
    this._logParsingFailures = logParsingFailures;
    if ((result = startRule.parse(this)) && (result.matchLength === this._source.length || (allowPartialMatch && result.matchLength > 0))) {
      if (!isSubparse) {
        result.applyLabels();
      }
      return result;
    } else {
      if (!isSubparse) {
        if (logParsingFailures) {
          throw new BabelBridgeCompileError(result ? [this.colorString("gray", (this["class"].name + " only parsed: ") + this.colorString("black", (result.matchLength + " of " + this._source.length + " ") + this.colorString("gray", "characters"))), this.getParseFailureInfo(this.options)].join("\n") : this.getParseFailureInfo(this.options), this.parseFailureInfoObject);
        } else {
          return this.parse(this._source, merge(this.options, {
            logParsingFailures: true
          }));
        }
      }
    }
  };

  Parser.prototype.getRule = function(ruleName) {
    var rule;
    ruleName || (ruleName = this.rootRuleName);
    if (!ruleName) {
      throw new Error("No root rule defined.");
    }
    if (!(rule = this.rules[ruleName])) {
      throw new Error("Could not find rule: " + ruleName);
    }
    return rule;
  };

  addToExpectingInfo = function(node, into, value) {
    var m, name1, p, pm, ref2;
    if (node.parent) {
      into = addToExpectingInfo(node.parent, into);
    }
    return into[name1 = node.parseInfo] || (into[name1] = value ? value : (p = {}, ((ref2 = (pm = node.presentMatches)) != null ? ref2.length : void 0) > 0 ? p.matches = (function() {
      var i, len, results;
      results = [];
      for (i = 0, len = pm.length; i < len; i++) {
        m = pm[i];
        results.push(m.parseInfo);
      }
      return results;
    })() : void 0, p));
  };

  lastLines = function(string, count) {
    var a;
    if (count == null) {
      count = 5;
    }
    a = string.split("\n");
    return a.slice(max(0, a.length - count), a.length).join("\n");
  };

  firstLines = function(string, count) {
    var a;
    if (count == null) {
      count = 5;
    }
    a = string.split("\n");
    return a.slice(0, count).join("\n");
  };

  Parser.getter("nonMatches", {
    failureUrl: function() {
      return (this.options.sourceFile || '') + ":" + (getLineColumnString(this._source, this._failureIndex));
    },
    parseFailureInfoObject: function() {
      return merge({
        sourceFile: this.options.sourceFile,
        failureIndex: this._failureIndex,
        location: this.failureUrl
      }, getLineColumn(this._source, this._failureIndex));
    },
    parseFailureInfo: function(options) {
      var left, out, right, sourceAfter, sourceBefore, verbose;
      if (!this._source) {
        return;
      }
      verbose = options != null ? options.verbose : void 0;
      sourceBefore = lastLines(left = this._source.slice(0, this._failureIndex));
      sourceAfter = firstLines(right = this._source.slice(this._failureIndex));
      out = compactFlatten([
        "", this.colorString("gray", "Parsing error at " + (this.colorString("red", this.failureUrl))), "", this.colorString("gray", "Source:"), this.colorString("gray", "..."), "" + sourceBefore + (this.colorString("red", "<HERE>")) + (sourceAfter.replace(/[\s\n]+$/, '')), this.colorString("gray", "..."), "", this.getExpectingInfo(options), verbose ? formattedInspect({
          "partial-parse-tree": this.partialParseTree
        }, options) : void 0, ""
      ]);
      return out.join("\n");
    },
    partialParseTreeLeafNodes: function() {
      if (this._partialParseTreeNodes) {
        return this._partialParseTreeNodes;
      }
      this.getPartialParseTree();
      return this._partialParseTreeNodes;
    },
    partialParseTree: function() {
      var expectingInfoTree, k, n, node, patternElement, rootNode;
      if (this._partialParseTree) {
        return this._partialParseTree;
      }
      expectingInfoTree = {};
      this._partialParseTreeNodes = (function() {
        var ref2, ref3, results;
        ref2 = this._nonMatches;
        results = [];
        for (k in ref2) {
          ref3 = ref2[k], patternElement = ref3.patternElement, node = ref3.node;
          addToExpectingInfo(node, expectingInfoTree, patternElement.pattern.toString());
          n = new Node(node);
          n.pattern = patternElement;
          rootNode = n._addToParentAsNonMatch();
          results.push(n);
        }
        return results;
      }).call(this);
      return this._partialParseTree = rootNode;
    },
    expectingInfo: function(options) {
      var child, couldMatchRuleNames, expecting, firstPartialMatchParent, i, j, l, len, len1, len2, node, out, partialMatchingParents, pmp, ref2, ref3, ruleName, v;
      if (!(objectLength(this._nonMatches) > 0)) {
        return null;
      }

      /*
      I know how to do this right!
      
      1) I want to add all the non-match nodes to the parse-tree
      2) I want to further improve the parse-tree inspect
        - it may be time to do a custom inspect
       */
      partialMatchingParents = [];
      ref2 = this.partialParseTreeLeafNodes;
      for (i = 0, len = ref2.length; i < len; i++) {
        node = ref2[i];
        firstPartialMatchParent = node.firstPartialMatchParent;
        pushIfNotPresent(partialMatchingParents, firstPartialMatchParent);
      }
      couldMatchRuleNames = [];
      expecting = {};
      for (j = 0, len1 = partialMatchingParents.length; j < len1; j++) {
        pmp = partialMatchingParents[j];
        ref3 = pmp.matches;
        for (l = 0, len2 = ref3.length; l < len2; l++) {
          child = ref3[l];
          if (!(child.isNonMatch && child.nonMatchingLeaf)) {
            continue;
          }
          if (ruleName = child.nonMatchingLeaf.ruleNameOrNull) {
            couldMatchRuleNames.push(ruleName);
          }
          expecting[child.nonMatchingLeaf.ruleNameOrPattern] = {
            "to-continue": pmp.ruleName,
            "started-at": getLineColumnString(this._source, pmp.absoluteOffset)
          };
        }
      }
      expecting = (function() {
        var len3, len4, o, q, ref4;
        if (objectHasKeys(expecting)) {
          out = {
            expecting: expecting
          };
          if (couldMatchRuleNames.length > 1) {
            out.rules = {};
            for (o = 0, len3 = couldMatchRuleNames.length; o < len3; o++) {
              ruleName = couldMatchRuleNames[o];
              ref4 = this.rules[ruleName]._variants;
              for (q = 0, len4 = ref4.length; q < len4; q++) {
                v = ref4[q];
                out.rules[ruleName] = v.patternString;
              }
            }
          }
          return out;
        } else {
          return {
            expecting: "end of input"
          };
        }
      }).call(this);
      return formattedInspect(expecting, options);
    }
  });

  Parser.prototype.tryPatternElement = function(patternElement, parseIntoNode, ruleVariant) {
    Stats.add("tryPatternElement");
    if (patternElement.parseInto(parseIntoNode)) {
      return true;
    } else {
      this._logParsingFailure(parseIntoNode, patternElement);
      return false;
    }
  };

  Parser.prototype._getRuleParseCache = function(ruleName) {
    var base;
    return (base = this._parseCache)[ruleName] || (base[ruleName] = {});
  };

  Parser.prototype._cached = function(ruleName, offset) {
    return this._getRuleParseCache(ruleName)[offset];
  };

  Parser.prototype._cacheMatch = function(ruleName, matchingNode) {
    Stats.add("cacheMatch");
    this._getRuleParseCache(ruleName)[matchingNode.offset] = matchingNode;
    return matchingNode;
  };

  Parser.prototype._cacheNoMatch = function(ruleName, offset) {
    Stats.add("cacheNoMatch");
    this._getRuleParseCache(ruleName)[offset] = "no_match";
    return null;
  };

  Parser.prototype._resetParserTracking = function() {
    this._activeRuleVariantParserOffsets = {};
    this._subparseInfo = null;
    this._logParsingFailures = false;
    this._partialParseTreeNodes = null;
    this._partialParseTree = null;
    this._matchingNegativeDepth = 0;
    this._parsingDidNotMatchEntireInput = false;
    this._failureIndex = 0;
    this._nonMatches = {};
    this._parseCache = {};
    return this._parentParserRootOffset = null;
  };

  Parser.getter("activeRuleVariantParserOffsets activeRuleVariantParserAreLeftRecursive failureIndex", {
    isMatchingNegative: function() {
      return this._matchingNegativeDepth > 0;
    }
  });

  Parser.prototype._matchNegative = function(f) {
    var result;
    this._matchingNegativeDepth++;
    result = f();
    this._matchingNegativeDepth--;
    return result;
  };

  Parser.prototype._logParsingFailure = function(parseIntoNode, patternElement) {
    var offset;
    if (!(this._matchingNegativeDepth === 0 && parseIntoNode.offset >= this._failureIndex && patternElement.isTokenPattern)) {
      return;
    }
    offset = parseIntoNode.offset;
    if (this._logParsingFailures) {
      parseIntoNode = parseIntoNode.getRealNode();
      return this._addNonMatch(offset, new NonMatch(parseIntoNode, patternElement));
    } else {
      return this._failureIndex = offset;
    }
  };

  Parser.prototype._addNonMatch = function(offset, nonMatch) {
    if (offset > this._failureIndex) {
      this._failureIndex = offset;
      this._nonMatches = {};
    }
    return this._nonMatches[nonMatch] = nonMatch;
  };

  return Parser;

})(__webpack_require__(1).BaseClass);


/***/ }),
/* 29 */
/***/ (function(module, exports, __webpack_require__) {

var conversions = __webpack_require__(17);
var route = __webpack_require__(30);

var convert = {};

var models = Object.keys(conversions);

function wrapRaw(fn) {
	var wrappedFn = function (args) {
		if (args === undefined || args === null) {
			return args;
		}

		if (arguments.length > 1) {
			args = Array.prototype.slice.call(arguments);
		}

		return fn(args);
	};

	// preserve .conversion property if there is one
	if ('conversion' in fn) {
		wrappedFn.conversion = fn.conversion;
	}

	return wrappedFn;
}

function wrapRounded(fn) {
	var wrappedFn = function (args) {
		if (args === undefined || args === null) {
			return args;
		}

		if (arguments.length > 1) {
			args = Array.prototype.slice.call(arguments);
		}

		var result = fn(args);

		// we're assuming the result is an array here.
		// see notice in conversions.js; don't use box types
		// in conversion functions.
		if (typeof result === 'object') {
			for (var len = result.length, i = 0; i < len; i++) {
				result[i] = Math.round(result[i]);
			}
		}

		return result;
	};

	// preserve .conversion property if there is one
	if ('conversion' in fn) {
		wrappedFn.conversion = fn.conversion;
	}

	return wrappedFn;
}

models.forEach(function (fromModel) {
	convert[fromModel] = {};

	Object.defineProperty(convert[fromModel], 'channels', {value: conversions[fromModel].channels});
	Object.defineProperty(convert[fromModel], 'labels', {value: conversions[fromModel].labels});

	var routes = route(fromModel);
	var routeModels = Object.keys(routes);

	routeModels.forEach(function (toModel) {
		var fn = routes[toModel];

		convert[fromModel][toModel] = wrapRounded(fn);
		convert[fromModel][toModel].raw = wrapRaw(fn);
	});
});

module.exports = convert;


/***/ }),
/* 30 */
/***/ (function(module, exports, __webpack_require__) {

var conversions = __webpack_require__(17);

/*
	this function routes a model to all other models.

	all functions that are routed have a property `.conversion` attached
	to the returned synthetic function. This property is an array
	of strings, each with the steps in between the 'from' and 'to'
	color models (inclusive).

	conversions that are not possible simply are not included.
*/

// https://jsperf.com/object-keys-vs-for-in-with-closure/3
var models = Object.keys(conversions);

function buildGraph() {
	var graph = {};

	for (var len = models.length, i = 0; i < len; i++) {
		graph[models[i]] = {
			// http://jsperf.com/1-vs-infinity
			// micro-opt, but this is simple.
			distance: -1,
			parent: null
		};
	}

	return graph;
}

// https://en.wikipedia.org/wiki/Breadth-first_search
function deriveBFS(fromModel) {
	var graph = buildGraph();
	var queue = [fromModel]; // unshift -> queue -> pop

	graph[fromModel].distance = 0;

	while (queue.length) {
		var current = queue.pop();
		var adjacents = Object.keys(conversions[current]);

		for (var len = adjacents.length, i = 0; i < len; i++) {
			var adjacent = adjacents[i];
			var node = graph[adjacent];

			if (node.distance === -1) {
				node.distance = graph[current].distance + 1;
				node.parent = current;
				queue.unshift(adjacent);
			}
		}
	}

	return graph;
}

function link(from, to) {
	return function (args) {
		return to(from(args));
	};
}

function wrapConversion(toModel, graph) {
	var path = [graph[toModel].parent, toModel];
	var fn = conversions[graph[toModel].parent][toModel];

	var cur = graph[toModel].parent;
	while (graph[cur].parent) {
		path.unshift(graph[cur].parent);
		fn = link(conversions[graph[cur].parent][cur], fn);
		cur = graph[cur].parent;
	}

	fn.conversion = path;
	return fn;
}

module.exports = function (fromModel) {
	var graph = deriveBFS(fromModel);
	var conversion = {};

	var models = Object.keys(graph);
	for (var len = models.length, i = 0; i < len; i++) {
		var toModel = models[i];
		var node = graph[toModel];

		if (node.parent === null) {
			// no possible conversion, or this node is the source model.
			continue;
		}

		conversion[toModel] = wrapConversion(toModel, graph);
	}

	return conversion;
};



/***/ }),
/* 31 */
/***/ (function(module, exports, __webpack_require__) {

/* MIT license */
var colorNames = __webpack_require__(18);

module.exports = {
   getRgba: getRgba,
   getHsla: getHsla,
   getRgb: getRgb,
   getHsl: getHsl,
   getHwb: getHwb,
   getAlpha: getAlpha,

   hexString: hexString,
   rgbString: rgbString,
   rgbaString: rgbaString,
   percentString: percentString,
   percentaString: percentaString,
   hslString: hslString,
   hslaString: hslaString,
   hwbString: hwbString,
   keyword: keyword
}

function getRgba(string) {
   if (!string) {
      return;
   }
   var abbr =  /^#([a-fA-F0-9]{3})$/,
       hex =  /^#([a-fA-F0-9]{6})$/,
       rgba = /^rgba?\(\s*([+-]?\d+)\s*,\s*([+-]?\d+)\s*,\s*([+-]?\d+)\s*(?:,\s*([+-]?[\d\.]+)\s*)?\)$/,
       per = /^rgba?\(\s*([+-]?[\d\.]+)\%\s*,\s*([+-]?[\d\.]+)\%\s*,\s*([+-]?[\d\.]+)\%\s*(?:,\s*([+-]?[\d\.]+)\s*)?\)$/,
       keyword = /(\D+)/;

   var rgb = [0, 0, 0],
       a = 1,
       match = string.match(abbr);
   if (match) {
      match = match[1];
      for (var i = 0; i < rgb.length; i++) {
         rgb[i] = parseInt(match[i] + match[i], 16);
      }
   }
   else if (match = string.match(hex)) {
      match = match[1];
      for (var i = 0; i < rgb.length; i++) {
         rgb[i] = parseInt(match.slice(i * 2, i * 2 + 2), 16);
      }
   }
   else if (match = string.match(rgba)) {
      for (var i = 0; i < rgb.length; i++) {
         rgb[i] = parseInt(match[i + 1]);
      }
      a = parseFloat(match[4]);
   }
   else if (match = string.match(per)) {
      for (var i = 0; i < rgb.length; i++) {
         rgb[i] = Math.round(parseFloat(match[i + 1]) * 2.55);
      }
      a = parseFloat(match[4]);
   }
   else if (match = string.match(keyword)) {
      if (match[1] == "transparent") {
         return [0, 0, 0, 0];
      }
      rgb = colorNames[match[1]];
      if (!rgb) {
         return;
      }
   }

   for (var i = 0; i < rgb.length; i++) {
      rgb[i] = scale(rgb[i], 0, 255);
   }
   if (!a && a != 0) {
      a = 1;
   }
   else {
      a = scale(a, 0, 1);
   }
   rgb[3] = a;
   return rgb;
}

function getHsla(string) {
   if (!string) {
      return;
   }
   var hsl = /^hsla?\(\s*([+-]?\d+)(?:deg)?\s*,\s*([+-]?[\d\.]+)%\s*,\s*([+-]?[\d\.]+)%\s*(?:,\s*([+-]?[\d\.]+)\s*)?\)/;
   var match = string.match(hsl);
   if (match) {
      var alpha = parseFloat(match[4]);
      var h = scale(parseInt(match[1]), 0, 360),
          s = scale(parseFloat(match[2]), 0, 100),
          l = scale(parseFloat(match[3]), 0, 100),
          a = scale(isNaN(alpha) ? 1 : alpha, 0, 1);
      return [h, s, l, a];
   }
}

function getHwb(string) {
   if (!string) {
      return;
   }
   var hwb = /^hwb\(\s*([+-]?\d+)(?:deg)?\s*,\s*([+-]?[\d\.]+)%\s*,\s*([+-]?[\d\.]+)%\s*(?:,\s*([+-]?[\d\.]+)\s*)?\)/;
   var match = string.match(hwb);
   if (match) {
    var alpha = parseFloat(match[4]);
      var h = scale(parseInt(match[1]), 0, 360),
          w = scale(parseFloat(match[2]), 0, 100),
          b = scale(parseFloat(match[3]), 0, 100),
          a = scale(isNaN(alpha) ? 1 : alpha, 0, 1);
      return [h, w, b, a];
   }
}

function getRgb(string) {
   var rgba = getRgba(string);
   return rgba && rgba.slice(0, 3);
}

function getHsl(string) {
  var hsla = getHsla(string);
  return hsla && hsla.slice(0, 3);
}

function getAlpha(string) {
   var vals = getRgba(string);
   if (vals) {
      return vals[3];
   }
   else if (vals = getHsla(string)) {
      return vals[3];
   }
   else if (vals = getHwb(string)) {
      return vals[3];
   }
}

// generators
function hexString(rgb) {
   return "#" + hexDouble(rgb[0]) + hexDouble(rgb[1])
              + hexDouble(rgb[2]);
}

function rgbString(rgba, alpha) {
   if (alpha < 1 || (rgba[3] && rgba[3] < 1)) {
      return rgbaString(rgba, alpha);
   }
   return "rgb(" + rgba[0] + ", " + rgba[1] + ", " + rgba[2] + ")";
}

function rgbaString(rgba, alpha) {
   if (alpha === undefined) {
      alpha = (rgba[3] !== undefined ? rgba[3] : 1);
   }
   return "rgba(" + rgba[0] + ", " + rgba[1] + ", " + rgba[2]
           + ", " + alpha + ")";
}

function percentString(rgba, alpha) {
   if (alpha < 1 || (rgba[3] && rgba[3] < 1)) {
      return percentaString(rgba, alpha);
   }
   var r = Math.round(rgba[0]/255 * 100),
       g = Math.round(rgba[1]/255 * 100),
       b = Math.round(rgba[2]/255 * 100);

   return "rgb(" + r + "%, " + g + "%, " + b + "%)";
}

function percentaString(rgba, alpha) {
   var r = Math.round(rgba[0]/255 * 100),
       g = Math.round(rgba[1]/255 * 100),
       b = Math.round(rgba[2]/255 * 100);
   return "rgba(" + r + "%, " + g + "%, " + b + "%, " + (alpha || rgba[3] || 1) + ")";
}

function hslString(hsla, alpha) {
   if (alpha < 1 || (hsla[3] && hsla[3] < 1)) {
      return hslaString(hsla, alpha);
   }
   return "hsl(" + hsla[0] + ", " + hsla[1] + "%, " + hsla[2] + "%)";
}

function hslaString(hsla, alpha) {
   if (alpha === undefined) {
      alpha = (hsla[3] !== undefined ? hsla[3] : 1);
   }
   return "hsla(" + hsla[0] + ", " + hsla[1] + "%, " + hsla[2] + "%, "
           + alpha + ")";
}

// hwb is a bit different than rgb(a) & hsl(a) since there is no alpha specific syntax
// (hwb have alpha optional & 1 is default value)
function hwbString(hwb, alpha) {
   if (alpha === undefined) {
      alpha = (hwb[3] !== undefined ? hwb[3] : 1);
   }
   return "hwb(" + hwb[0] + ", " + hwb[1] + "%, " + hwb[2] + "%"
           + (alpha !== undefined && alpha !== 1 ? ", " + alpha : "") + ")";
}

function keyword(rgb) {
  return reverseNames[rgb.slice(0, 3)];
}

// helpers
function scale(num, min, max) {
   return Math.min(Math.max(min, num), max);
}

function hexDouble(num) {
  var str = num.toString(16).toUpperCase();
  return (str.length < 2) ? "0" + str : str;
}


//create a list of reverse color names
var reverseNames = {};
for (var name in colorNames) {
   reverseNames[colorNames[name]] = name;
}


/***/ }),
/* 32 */
/***/ (function(module, exports, __webpack_require__) {

/* MIT license */
var clone = __webpack_require__(21);
var convert = __webpack_require__(29);
var string = __webpack_require__(31);

var Color = function (obj) {
	if (obj instanceof Color) {
		return obj;
	}
	if (!(this instanceof Color)) {
		return new Color(obj);
	}

	this.values = {
		rgb: [0, 0, 0],
		hsl: [0, 0, 0],
		hsv: [0, 0, 0],
		hwb: [0, 0, 0],
		cmyk: [0, 0, 0, 0],
		alpha: 1
	};

	// parse Color() argument
	var vals;
	if (typeof obj === 'string') {
		vals = string.getRgba(obj);
		if (vals) {
			this.setValues('rgb', vals);
		} else if (vals = string.getHsla(obj)) {
			this.setValues('hsl', vals);
		} else if (vals = string.getHwb(obj)) {
			this.setValues('hwb', vals);
		} else {
			throw new Error('Unable to parse color from string "' + obj + '"');
		}
	} else if (typeof obj === 'object') {
		vals = obj;
		if (vals.r !== undefined || vals.red !== undefined) {
			this.setValues('rgb', vals);
		} else if (vals.l !== undefined || vals.lightness !== undefined) {
			this.setValues('hsl', vals);
		} else if (vals.v !== undefined || vals.value !== undefined) {
			this.setValues('hsv', vals);
		} else if (vals.w !== undefined || vals.whiteness !== undefined) {
			this.setValues('hwb', vals);
		} else if (vals.c !== undefined || vals.cyan !== undefined) {
			this.setValues('cmyk', vals);
		} else {
			throw new Error('Unable to parse color from object ' + JSON.stringify(obj));
		}
	}
};

Color.prototype = {
	rgb: function () {
		return this.setSpace('rgb', arguments);
	},
	hsl: function () {
		return this.setSpace('hsl', arguments);
	},
	hsv: function () {
		return this.setSpace('hsv', arguments);
	},
	hwb: function () {
		return this.setSpace('hwb', arguments);
	},
	cmyk: function () {
		return this.setSpace('cmyk', arguments);
	},

	rgbArray: function () {
		return this.values.rgb;
	},
	hslArray: function () {
		return this.values.hsl;
	},
	hsvArray: function () {
		return this.values.hsv;
	},
	hwbArray: function () {
		if (this.values.alpha !== 1) {
			return this.values.hwb.concat([this.values.alpha]);
		}
		return this.values.hwb;
	},
	cmykArray: function () {
		return this.values.cmyk;
	},
	rgbaArray: function () {
		var rgb = this.values.rgb;
		return rgb.concat([this.values.alpha]);
	},
	rgbaArrayNormalized: function () {
		var rgb = this.values.rgb;
		var glRgba = [];
		for (var i = 0; i < 3; i++) {
			glRgba[i] = rgb[i] / 255;
		}
		glRgba.push(this.values.alpha);
		return glRgba;
	},
	hslaArray: function () {
		var hsl = this.values.hsl;
		return hsl.concat([this.values.alpha]);
	},
	alpha: function (val) {
		if (val === undefined) {
			return this.values.alpha;
		}
		this.setValues('alpha', val);
		return this;
	},

	red: function (val) {
		return this.setChannel('rgb', 0, val);
	},
	green: function (val) {
		return this.setChannel('rgb', 1, val);
	},
	blue: function (val) {
		return this.setChannel('rgb', 2, val);
	},
	hue: function (val) {
		if (val) {
			val %= 360;
			val = val < 0 ? 360 + val : val;
		}
		return this.setChannel('hsl', 0, val);
	},
	saturation: function (val) {
		return this.setChannel('hsl', 1, val);
	},
	lightness: function (val) {
		return this.setChannel('hsl', 2, val);
	},
	saturationv: function (val) {
		return this.setChannel('hsv', 1, val);
	},
	whiteness: function (val) {
		return this.setChannel('hwb', 1, val);
	},
	blackness: function (val) {
		return this.setChannel('hwb', 2, val);
	},
	value: function (val) {
		return this.setChannel('hsv', 2, val);
	},
	cyan: function (val) {
		return this.setChannel('cmyk', 0, val);
	},
	magenta: function (val) {
		return this.setChannel('cmyk', 1, val);
	},
	yellow: function (val) {
		return this.setChannel('cmyk', 2, val);
	},
	black: function (val) {
		return this.setChannel('cmyk', 3, val);
	},

	hexString: function () {
		return string.hexString(this.values.rgb);
	},
	rgbString: function () {
		return string.rgbString(this.values.rgb, this.values.alpha);
	},
	rgbaString: function () {
		return string.rgbaString(this.values.rgb, this.values.alpha);
	},
	percentString: function () {
		return string.percentString(this.values.rgb, this.values.alpha);
	},
	hslString: function () {
		return string.hslString(this.values.hsl, this.values.alpha);
	},
	hslaString: function () {
		return string.hslaString(this.values.hsl, this.values.alpha);
	},
	hwbString: function () {
		return string.hwbString(this.values.hwb, this.values.alpha);
	},
	keyword: function () {
		return string.keyword(this.values.rgb, this.values.alpha);
	},

	rgbNumber: function () {
		return (this.values.rgb[0] << 16) | (this.values.rgb[1] << 8) | this.values.rgb[2];
	},

	luminosity: function () {
		// http://www.w3.org/TR/WCAG20/#relativeluminancedef
		var rgb = this.values.rgb;
		var lum = [];
		for (var i = 0; i < rgb.length; i++) {
			var chan = rgb[i] / 255;
			lum[i] = (chan <= 0.03928) ? chan / 12.92 : Math.pow(((chan + 0.055) / 1.055), 2.4);
		}
		return 0.2126 * lum[0] + 0.7152 * lum[1] + 0.0722 * lum[2];
	},

	contrast: function (color2) {
		// http://www.w3.org/TR/WCAG20/#contrast-ratiodef
		var lum1 = this.luminosity();
		var lum2 = color2.luminosity();
		if (lum1 > lum2) {
			return (lum1 + 0.05) / (lum2 + 0.05);
		}
		return (lum2 + 0.05) / (lum1 + 0.05);
	},

	level: function (color2) {
		var contrastRatio = this.contrast(color2);
		if (contrastRatio >= 7.1) {
			return 'AAA';
		}

		return (contrastRatio >= 4.5) ? 'AA' : '';
	},

	dark: function () {
		// YIQ equation from http://24ways.org/2010/calculating-color-contrast
		var rgb = this.values.rgb;
		var yiq = (rgb[0] * 299 + rgb[1] * 587 + rgb[2] * 114) / 1000;
		return yiq < 128;
	},

	light: function () {
		return !this.dark();
	},

	negate: function () {
		var rgb = [];
		for (var i = 0; i < 3; i++) {
			rgb[i] = 255 - this.values.rgb[i];
		}
		this.setValues('rgb', rgb);
		return this;
	},

	lighten: function (ratio) {
		this.values.hsl[2] += this.values.hsl[2] * ratio;
		this.setValues('hsl', this.values.hsl);
		return this;
	},

	darken: function (ratio) {
		this.values.hsl[2] -= this.values.hsl[2] * ratio;
		this.setValues('hsl', this.values.hsl);
		return this;
	},

	saturate: function (ratio) {
		this.values.hsl[1] += this.values.hsl[1] * ratio;
		this.setValues('hsl', this.values.hsl);
		return this;
	},

	desaturate: function (ratio) {
		this.values.hsl[1] -= this.values.hsl[1] * ratio;
		this.setValues('hsl', this.values.hsl);
		return this;
	},

	whiten: function (ratio) {
		this.values.hwb[1] += this.values.hwb[1] * ratio;
		this.setValues('hwb', this.values.hwb);
		return this;
	},

	blacken: function (ratio) {
		this.values.hwb[2] += this.values.hwb[2] * ratio;
		this.setValues('hwb', this.values.hwb);
		return this;
	},

	greyscale: function () {
		var rgb = this.values.rgb;
		// http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
		var val = rgb[0] * 0.3 + rgb[1] * 0.59 + rgb[2] * 0.11;
		this.setValues('rgb', [val, val, val]);
		return this;
	},

	clearer: function (ratio) {
		this.setValues('alpha', this.values.alpha - (this.values.alpha * ratio));
		return this;
	},

	opaquer: function (ratio) {
		this.setValues('alpha', this.values.alpha + (this.values.alpha * ratio));
		return this;
	},

	rotate: function (degrees) {
		var hue = this.values.hsl[0];
		hue = (hue + degrees) % 360;
		hue = hue < 0 ? 360 + hue : hue;
		this.values.hsl[0] = hue;
		this.setValues('hsl', this.values.hsl);
		return this;
	},

	/**
	 * Ported from sass implementation in C
	 * https://github.com/sass/libsass/blob/0e6b4a2850092356aa3ece07c6b249f0221caced/functions.cpp#L209
	 */
	mix: function (mixinColor, weight) {
		var color1 = this;
		var color2 = mixinColor;
		var p = weight === undefined ? 0.5 : weight;

		var w = 2 * p - 1;
		var a = color1.alpha() - color2.alpha();

		var w1 = (((w * a === -1) ? w : (w + a) / (1 + w * a)) + 1) / 2.0;
		var w2 = 1 - w1;

		return this
			.rgb(
				w1 * color1.red() + w2 * color2.red(),
				w1 * color1.green() + w2 * color2.green(),
				w1 * color1.blue() + w2 * color2.blue()
			)
			.alpha(color1.alpha() * p + color2.alpha() * (1 - p));
	},

	toJSON: function () {
		return this.rgb();
	},

	clone: function () {
		var col = new Color();
		col.values = clone(this.values);
		return col;
	}
};

Color.prototype.getValues = function (space) {
	var vals = {};

	for (var i = 0; i < space.length; i++) {
		vals[space.charAt(i)] = this.values[space][i];
	}

	if (this.values.alpha !== 1) {
		vals.a = this.values.alpha;
	}

	// {r: 255, g: 255, b: 255, a: 0.4}
	return vals;
};

Color.prototype.setValues = function (space, vals) {
	var spaces = {
		rgb: ['red', 'green', 'blue'],
		hsl: ['hue', 'saturation', 'lightness'],
		hsv: ['hue', 'saturation', 'value'],
		hwb: ['hue', 'whiteness', 'blackness'],
		cmyk: ['cyan', 'magenta', 'yellow', 'black']
	};

	var maxes = {
		rgb: [255, 255, 255],
		hsl: [360, 100, 100],
		hsv: [360, 100, 100],
		hwb: [360, 100, 100],
		cmyk: [100, 100, 100, 100]
	};

	var i;
	var alpha = 1;
	if (space === 'alpha') {
		alpha = vals;
	} else if (vals.length) {
		// [10, 10, 10]
		this.values[space] = vals.slice(0, space.length);
		alpha = vals[space.length];
	} else if (vals[space.charAt(0)] !== undefined) {
		// {r: 10, g: 10, b: 10}
		for (i = 0; i < space.length; i++) {
			this.values[space][i] = vals[space.charAt(i)];
		}

		alpha = vals.a;
	} else if (vals[spaces[space][0]] !== undefined) {
		// {red: 10, green: 10, blue: 10}
		var chans = spaces[space];

		for (i = 0; i < space.length; i++) {
			this.values[space][i] = vals[chans[i]];
		}

		alpha = vals.alpha;
	}

	this.values.alpha = Math.max(0, Math.min(1, (alpha === undefined ? this.values.alpha : alpha)));

	if (space === 'alpha') {
		return false;
	}

	var capped;

	// cap values of the space prior converting all values
	for (i = 0; i < space.length; i++) {
		capped = Math.max(0, Math.min(maxes[space][i], this.values[space][i]));
		this.values[space][i] = Math.round(capped);
	}

	// convert to all the other color spaces
	for (var sname in spaces) {
		if (sname !== space) {
			this.values[sname] = convert[space][sname](this.values[space]);
		}

		// cap values
		for (i = 0; i < sname.length; i++) {
			capped = Math.max(0, Math.min(maxes[sname][i], this.values[sname][i]));
			this.values[sname][i] = Math.round(capped);
		}
	}

	return true;
};

Color.prototype.setSpace = function (space, args) {
	var vals = args[0];

	if (vals === undefined) {
		// color.rgb()
		return this.getValues(space);
	}

	// color.rgb(10, 10, 10)
	if (typeof vals === 'number') {
		vals = Array.prototype.slice.call(args);
	}

	this.setValues(space, vals);
	return this;
};

Color.prototype.setChannel = function (space, index, val) {
	if (val === undefined) {
		// color.red()
		return this.values[space][index];
	} else if (val === this.values[space][index]) {
		// color.red(color.red())
		return this;
	}

	// color.red(100)
	this.values[space][index] = val;
	this.setValues(space, this.values[space]);

	return this;
};

module.exports = Color;


/***/ }),
/* 33 */
/***/ (function(module, exports) {

module.exports = require("neptune-namespaces");

/***/ }),
/* 34 */
/***/ (function(module, exports) {

module.exports = require("repl");

/***/ })
/******/ ]);