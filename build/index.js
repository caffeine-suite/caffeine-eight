module.exports =
/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.l = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// identity function for calling harmony imports with the correct context
/******/ 	__webpack_require__.i = function(value) { return value; };

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

/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};

/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 23);
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

module.exports = __webpack_require__(8).addModules({
  EmptyNode: __webpack_require__(6),
  EmptyOptionalNode: __webpack_require__(18),
  Node: __webpack_require__(7),
  ScratchNode: __webpack_require__(19)
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
/***/ (function(module, exports, __webpack_require__) {

var BabelBridge, Neptune,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Neptune = __webpack_require__(22);

module.exports = Neptune.BabelBridge || Neptune.addNamespace('BabelBridge', BabelBridge = (function(superClass) {
  extend(BabelBridge, superClass);

  function BabelBridge() {
    return BabelBridge.__super__.constructor.apply(this, arguments);
  }

  return BabelBridge;

})(Neptune.Base));


/***/ }),
/* 5 */
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
/* 6 */
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

})(__webpack_require__(7));


/***/ }),
/* 7 */
/***/ (function(module, exports, __webpack_require__) {

var BaseClass, Node, Nodes, Stats, array, arrayWith, compactFlatten, inspectedObjectLiteral, isPlainArray, isPlainObject, log, merge, mergeInto, objectWithout, peek, push, ref,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ref = __webpack_require__(0), arrayWith = ref.arrayWith, array = ref.array, peek = ref.peek, log = ref.log, push = ref.push, compactFlatten = ref.compactFlatten, objectWithout = ref.objectWithout, isPlainArray = ref.isPlainArray, isPlainObject = ref.isPlainObject, inspectedObjectLiteral = ref.inspectedObjectLiteral, merge = ref.merge, mergeInto = ref.mergeInto;

Nodes = __webpack_require__(8);

BaseClass = __webpack_require__(1).BaseClass;

Stats = __webpack_require__(3);

module.exports = Node = (function(superClass) {
  var emptyArray;

  extend(Node, superClass);

  function Node(_parent, options) {
    this._parent = _parent;
    Node.__super__.constructor.apply(this, arguments);
    Stats.add("newNode");
    this._parser = this._parent._parser;
    if (options) {
      this.offset = options.offset, this.matchLength = options.matchLength, this.ruleVariant = options.ruleVariant, this.matches = options.matches, this.matchPatterns = options.matchPatterns;
    }
    if (this._offset == null) {
      this._offset = this._parent.getNextOffset();
    }
    this._matchLength || (this._matchLength = 0);
    this._labelsApplied = false;
    this._ruleName = null;
    this._pluralRuleName = null;
    this._label = null;
    this._pluralLabel = null;
    this._pattern = null;
    this._nonMatch = false;
    this._nonMatches = null;
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
      return this.nonMatch && this.matches.length === 1 && this.matches[0];
    },
    firstPartialMatchParent: function() {
      if (this.parent === this.parser || this.isPartialMatch) {
        return this;
      } else {
        return this.parent.firstPartialMatchParent;
      }
    },
    inspectedObjects: function() {
      var children, hasOneOrMoreMatchingChildren, label, match, matches, nonMatch, obj, parts, path, ref1, ref2, ref3, ret, ruleName;
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
        path = path.length === 1 ? path[0] : path.join(" > ");
        hasOneOrMoreMatchingChildren = false;
        children = (function() {
          var j, len, results;
          results = [];
          for (j = 0, len = matches.length; j < len; j++) {
            match = matches[j];
            if (!match.nonMatch) {
              hasOneOrMoreMatchingChildren = true;
            }
            results.push(match.inspectedObjects);
          }
          return results;
        })();
        parts = compactFlatten([
          path.length > 0 ? {
            path: path
          } : void 0, label ? {
            label: label
          } : void 0, children.length > 0 ? children : match.toString()
        ]);
        if (parts.length === 1) {
          parts = parts[0];
        }
        ret = (
          obj = {},
          obj["" + (nonMatch ? hasOneOrMoreMatchingChildren ? 'partialMatch-' : 'nonMatch-' : '') + ruleName] = parts,
          obj
        );
        return ret;
      } else if (this.nonMatch) {
        return {
          nonMatch: {
            offset: this.offset,
            pattern: "" + ((ref2 = this.pattern) != null ? ref2.pattern : void 0)
          }
        };
      } else {
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
/* 8 */
/***/ (function(module, exports, __webpack_require__) {

var BabelBridge, Nodes,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

BabelBridge = __webpack_require__(4);

module.exports = BabelBridge.Nodes || BabelBridge.addNamespace('Nodes', Nodes = (function(superClass) {
  extend(Nodes, superClass);

  function Nodes() {
    return Nodes.__super__.constructor.apply(this, arguments);
  }

  return Nodes;

})(Neptune.Base));


/***/ }),
/* 9 */
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

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(5)(module)))

/***/ }),
/* 10 */
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
    return this.parse = function(parentNode) {
      var matchRule;
      matchRule = parentNode.parser.rules[ruleName];
      if (!matchRule) {
        throw new Error("no rule for " + ruleName);
      }
      return matchRule.parse(parentNode);
    };
  };

  PatternElement.prototype._initRegExp = function(regExp) {
    var flags;
    this._isTokenPattern = true;
    flags = "y";
    if (regExp.ignoreCase) {
      flags += "i";
    }
    regExp = RegExp(regExp.source, flags);
    return this.parse = function(parentNode) {
      var match, nextOffset, source;
      nextOffset = parentNode.nextOffset, source = parentNode.source;
      regExp.lastIndex = nextOffset;
      if (match = regExp.exec(source)) {
        return new Node(parentNode, {
          offset: nextOffset,
          matchLength: match[0].length
        });
      }
    };
  };

  return PatternElement;

})(__webpack_require__(1).BaseClass);


/***/ }),
/* 11 */
/***/ (function(module, exports, __webpack_require__) {

var Rule, RuleVariant, Stats, log, merge, objectName, ref, upperCamelCase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

RuleVariant = __webpack_require__(12);

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
      Stats.add("cacheHit");
      if (cached === "no_match") {
        return null;
      } else {
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
/* 12 */
/***/ (function(module, exports, __webpack_require__) {

var BaseClass, Node, PatternElement, RuleVariant, ScratchNode, Stats, allPatternElementsRegExp, compactFlatten, inspect, isPlainObject, isString, log, merge, pad, push, ref, ref1, toInspectedObjects, upperCamelCase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

PatternElement = __webpack_require__(10);

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
    var i, len, parser, patternElement, ref2, scratchNode;
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
    return scratchNode.createVariantNode();
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
/* 13 */
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
    lines = (string.slice(0, offset - 1) + " ").split("\n");
    return {
      line: lines.length,
      column: peek(lines).length
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
/* 14 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(21);


/***/ }),
/* 15 */
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

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(5)(module)))

/***/ }),
/* 16 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(17).addModules({
  IndentBlocks: __webpack_require__(15)
});


/***/ }),
/* 17 */
/***/ (function(module, exports, __webpack_require__) {

var BabelBridge, Extensions,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

BabelBridge = __webpack_require__(4);

module.exports = BabelBridge.Extensions || BabelBridge.addNamespace('Extensions', Extensions = (function(superClass) {
  extend(Extensions, superClass);

  function Extensions() {
    return Extensions.__super__.constructor.apply(this, arguments);
  }

  return Extensions;

})(Neptune.Base));


/***/ }),
/* 18 */
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

})(__webpack_require__(6));


/***/ }),
/* 19 */
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
    this.offset = this.parent.getNextOffset();
    this.matchesLength = this.matchPatternsLength = this.matchLength = 0;
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

  ScratchNode.prototype.createVariantNode = function(ruleVariant) {
    return new this.ruleVariant.VariantNodeClass(this.parent, {
      ruleVariant: this.ruleVariant,
      matchLength: this.matchLength,
      matches: this.matchesLength > 0 && this.matches.slice(0, this.matchesLength),
      matchPatterns: this.matchPatternsLength > 0 && this.matchPatterns.slice(0, this.matchPatternsLength)
    });
  };

  ScratchNode.prototype.checkin = function() {
    return ScratchNode.checkin(this);
  };

  ScratchNode.prototype.subparse = function(subSource, options) {
    return this._parser.subparse(subSource, merge(options, {
      parentNode: this
    }));
  };

  ScratchNode.prototype.addMatch = function(pattern, match) {
    if (!match) {
      return false;
    }
    this.matches[this.matchesLength++] = match;
    this.matchPatterns[this.matchPatternsLength++] = pattern;
    this.matchLength = match.nextOffset - this.offset;
    return true;
  };

  return ScratchNode;

})(BaseClass));

/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(5)(module)))

/***/ }),
/* 20 */
/***/ (function(module, exports, __webpack_require__) {

var Node, NonMatch, Parser, Rule, Stats, compactFlatten, formattedInspect, getLineColumn, getLineColumnString, inspect, inspectLean, isClass, isFunction, isPlainArray, isPlainObject, log, max, merge, mergeInto, objectLength, objectWithout, peek, pluralize, pushIfNotPresent, ref, ref1, uniqueValues, upperCamelCase,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Rule = __webpack_require__(11);

ref = __webpack_require__(13), getLineColumn = ref.getLineColumn, getLineColumnString = ref.getLineColumnString;

Node = __webpack_require__(2).Node;

NonMatch = __webpack_require__(9);

Stats = __webpack_require__(3);

ref1 = __webpack_require__(0), isFunction = ref1.isFunction, peek = ref1.peek, log = ref1.log, isPlainObject = ref1.isPlainObject, isPlainArray = ref1.isPlainArray, merge = ref1.merge, compactFlatten = ref1.compactFlatten, objectLength = ref1.objectLength, inspect = ref1.inspect, inspectLean = ref1.inspectLean, pluralize = ref1.pluralize, isClass = ref1.isClass, isPlainArray = ref1.isPlainArray, upperCamelCase = ref1.upperCamelCase, mergeInto = ref1.mergeInto, objectWithout = ref1.objectWithout, uniqueValues = ref1.uniqueValues, formattedInspect = ref1.formattedInspect, max = ref1.max, inspect = ref1.inspect, pushIfNotPresent = ref1.pushIfNotPresent;

module.exports = Parser = (function(superClass) {
  var addToExpectingInfo, firstLines, instanceRulesFunction, lastLines, rulesFunction;

  extend(Parser, superClass);

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
    var array, base, definition, i, len, results, rule;
    if (nodeBaseClass == null) {
      nodeBaseClass = this.nodeBaseClass;
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
    results = [];
    for (i = 0, len = definitions.length; i < len; i++) {
      definition = definitions[i];
      results.push(rule.addVariant(isPlainObject(definition) ? merge({
        nodeBaseClass: nodeBaseClass
      }, definition) : {
        pattern: definition,
        nodeBaseClass: nodeBaseClass
      }));
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
      sharedNodeBaseClass = (this.nodeBaseClass || Node).createSubclass(sharedNodeBaseClass);
    }
    results = [];
    for (ruleName in rules) {
      definition = rules[ruleName];
      results.push(this.addRule(ruleName, definition, sharedNodeBaseClass || this.nodeBaseClass));
    }
    return results;
  };

  Parser.rules = rulesFunction;

  Parser.prototype.rule = instanceRulesFunction = function(a, b) {
    return this["class"].rule(a, b);
  };

  Parser.prototype.rules = instanceRulesFunction;

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
    startRule = this.getStartRule(rule);
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
          throw new Error(result ? "parse only matched " + result.matchLength + " of " + this._source.length + " characters\n" + (this.getParseFailureInfo(this.options)) : this.getParseFailureInfo(this.options));
        } else {
          return this.parse(this._source, merge(this.options, {
            logParsingFailures: true
          }));
        }
      }
    }
  };

  Parser.prototype.getStartRule = function(ruleName) {
    var startRule;
    ruleName || (ruleName = this.rootRuleName);
    if (!ruleName) {
      throw new Error("No root rule defined.");
    }
    if (!(startRule = this.rules[ruleName])) {
      throw new Error("Could not find rule: " + ruleName);
    }
    return startRule;
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
    parseFailureInfo: function(options) {
      var left, out, right, sourceAfter, sourceBefore, verbose;
      if (!this._source) {
        return;
      }
      verbose = options != null ? options.verbose : void 0;
      sourceBefore = lastLines(left = this._source.slice(0, this._failureIndex));
      sourceAfter = firstLines(right = this._source.slice(this._failureIndex));
      out = compactFlatten([
        "Parsing error at " + (this.options.sourceFile || '') + ":" + (getLineColumnString(this._source, this._failureIndex)) + "\n\nSource:\n...\n" + sourceBefore + "<HERE>" + sourceAfter + "\n...\n", this.expectingInfo, verbose ? [
          "", formattedInspect({
            "partial-parse-tree": this.partialParseTree
          })
        ] : void 0, ""
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
    expectingInfo: function() {
      var child, couldMatchRuleNames, couldMatchRules, firstPartialMatchParent, i, len, newOutput, node, partialMatchingParents, pmp, ref2, ruleName, v;
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
      newOutput = (function() {
        var j, len1, results;
        results = [];
        for (j = 0, len1 = partialMatchingParents.length; j < len1; j++) {
          pmp = partialMatchingParents[j];
          results.push((function() {
            var l, len2, ref3, results1;
            ref3 = pmp.matches;
            results1 = [];
            for (l = 0, len2 = ref3.length; l < len2; l++) {
              child = ref3[l];
              if (!child.isNonMatch) {
                continue;
              }
              if (ruleName = child.nonMatchingLeaf.ruleNameOrNull) {
                couldMatchRuleNames.push(ruleName);
              }
              results1.push("  " + (formattedInspect(child.nonMatchingLeaf.ruleNameOrPattern)) + " to complete '" + pmp.ruleName + "' (which started at " + (getLineColumnString(this._source, pmp.absoluteOffset)) + ")");
            }
            return results1;
          }).call(this));
        }
        return results;
      }).call(this);
      if (couldMatchRuleNames.length > 1) {
        couldMatchRules = [
          "", "rules:", (function() {
            var j, len1, results;
            results = [];
            for (j = 0, len1 = couldMatchRuleNames.length; j < len1; j++) {
              ruleName = couldMatchRuleNames[j];
              results.push((function() {
                var l, len2, ref3, results1;
                ref3 = this.rules[ruleName]._variants;
                results1 = [];
                for (l = 0, len2 = ref3.length; l < len2; l++) {
                  v = ref3[l];
                  results1.push("  " + ruleName + ": " + (formattedInspect(v.patternString)));
                }
                return results1;
              }).call(this));
            }
            return results;
          }).call(this)
        ];
      }
      newOutput = compactFlatten([newOutput, couldMatchRules]);
      if (!(newOutput.length > 0)) {
        newOutput = "  end of input";
      }
      return compactFlatten(["expecting:", newOutput]);
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
    this._getRuleParseCache(ruleName)[matchingNode.offset] = matchingNode;
    return matchingNode;
  };

  Parser.prototype._cacheNoMatch = function(ruleName, offset) {
    this._getRuleParseCache(ruleName)[offset] = "no_match";
    return null;
  };

  Parser.prototype._resetParserTracking = function() {
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

  Parser.getter({
    failureIndex: function() {
      return this._failureIndex;
    },
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
      parseIntoNode = (typeof parseIntoNode.createVariantNode === "function" ? parseIntoNode.createVariantNode() : void 0) || parseIntoNode;
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
/* 21 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(4).addModules({
  NonMatch: __webpack_require__(9),
  Parser: __webpack_require__(20),
  PatternElement: __webpack_require__(10),
  Rule: __webpack_require__(11),
  RuleVariant: __webpack_require__(12),
  Stats: __webpack_require__(3),
  Tools: __webpack_require__(13)
});

__webpack_require__(16);

__webpack_require__(2);


/***/ }),
/* 22 */
/***/ (function(module, exports) {

module.exports = require("neptune-namespaces");

/***/ }),
/* 23 */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(14);


/***/ })
/******/ ]);