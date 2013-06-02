// Generated by CoffeeScript 1.4.0
(function() {
  var __slice = [].slice;

  define(function(require) {
    /**
    * @fileoverview Utility functions for working with Objects
    */

    /**
    * TODO: remove, soon obsolete use coffee script extend instead
    * Put a prototype into the prototype chain of another prototype.
    * @param {Object} subClass
    * @param {Object} superClass
    */

    var Objects;
    return Objects = (function() {

      function Objects() {}

      Objects.extend = function(subClass, superClass) {
        var f;
        if (subClass === void 0) {
          throw new Error('unknown subClass');
        }
        if (superClass === void 0) {
          throw new Error('unknown superClass');
        }
        f = new Function();
        f.prototype = superClass.prototype;
        subClass.prototype = new f();
        subClass.prototype.constructor = subClass;
        subClass.superClass = superClass.prototype;
        return subClass.superConstructor = superClass;
      };

      /**
      * Creates a new object as the as the keywise union of the provided objects.
      * Whenever a key exists in a later object that already existed in an earlier
      * object, the according value of the earlier object takes precedence.
      * @param {Object} obj... The objects to merge
      */


      Objects.merge = function() {
        var args, i, obj, property, result, _i, _j, _len, _ref;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        result = {};
        for (i = _i = _ref = args.length; _ref <= 0 ? _i < 0 : _i > 0; i = _ref <= 0 ? ++_i : --_i) {
          obj = args[i - 1];
          for (_j = 0, _len = obj.length; _j < _len; _j++) {
            property = obj[_j];
            result[property] = obj[property];
          }
        }
        return result;
      };

      /**
      * fallback for Object.keys
      * @param {Object} obj
      * @returns {Array} list of own properties
      * @see https:#developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Object/keys
      */


      Objects.keys = function(obj) {
        var p, ret;
        if (Object.keys) {
          return Object.keys(obj);
        }
        ret = [];
        for (p in obj) {
          if (Object.prototype.hasOwnProperty.call(obj, p)) {
            ret.push(p);
          }
        }
        return ret;
      };

      /**
      * Create object accessors
      * @param {Object} object The object on which to define the property
      * @param {String} name name of the property
      * @param {Function} get
      * @param {Function} set
      * @see https:#developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Object/defineProperty
      */


      Objects.accessor = function(object, name, get, set) {
        if (Object.defineProperty !== void 0) {
          return Object.defineProperty(object, name, {
            get: get,
            set: set
          });
        } else if (Object.prototype.__defineGetter__ !== void 0) {
          object.__defineGetter__(name, get);
          if (set) {
            return object.__defineSetter__(name, set);
          }
        }
      };

      /*
          * @param {Object} object The object on which to define or modify properties.
          * @param {Object} props An object whose own enumerable properties constitute descriptors for the properties to be defined or modified.
          * @see https:#developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Object/defineProperties
      */


      Objects.accessors = function(object, props) {
        var propInput, _results;
        _results = [];
        for (propInput in props) {
          _results.push(Objects.accessor(object, propInput, props[propInput].get, props[propInput].set));
        }
        return _results;
      };

      return Objects;

    })();
  });

}).call(this);
