# TODO: this should be a dependancy of gamecs but not part of it
define (require) ->
  "use strict"
  ###*
  * @fileoverview Utility functions for working with Objects
  ###

  ###*
  * TODO: remove, soon obsolete use coffee script extend instead
  * Put a prototype into the prototype chain of another prototype.
  * @param {Object} subClass
  * @param {Object} superClass
  ###
  class Objects
    @extend: (subClass, superClass) ->
      throw new Error('unknown subClass') if (subClass == undefined)
        
      throw new Error('unknown superClass') if (superClass == undefined)
      # new Function() is evil
      f = new Function()
      f.prototype = superClass.prototype

      subClass.prototype = new f()
      subClass.prototype.constructor = subClass
      subClass.superClass = superClass.prototype
      subClass.superConstructor = superClass

    ###*
    * Creates a new object as the as the keywise union of the provided objects.
    * Whenever a key exists in a later object that already existed in an earlier
    * object, the according value of the earlier object takes precedence.
    * @param {Object} obj... The objects to merge
    ###
    @merge: (args...) ->
      result = {}
      #for i in args.length i > 0 --i)
      for i in [args.length...0]
        obj = args[i - 1]
        for property in obj
          result[property] = obj[property]
      return result

    ###*
    * fallback for Object.keys
    * @param {Object} obj
    * @returns {Array} list of own properties
    * @see https:#developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Object/keys
    ###
    @keys: (obj) ->
      if (Object.keys) then ret = Object.keys(obj)
      else
        ret = []
        for p of obj then ret.push(p) if(Object.prototype.hasOwnProperty.call(obj, p))
      return ret

    ###*
    * Create object accessors
    * @param {Object} object The object on which to define the property
    * @param {String} name name of the property
    * @param {Function} get
    * @param {Function} set
    * @see https:#developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Object/defineProperty
    ###
    @accessor: (object, name, get, set) ->
      # ECMA5
      if (Object.defineProperty != undefined)
         Object.defineProperty(object, name,
            get: get
            set: set
         )
      # non-standard
      else if (Object.prototype.__defineGetter__ != undefined)
        object.__defineGetter__(name, get)
        if (set)
          object.__defineSetter__(name, set)

    ###
    * @param {Object} object The object on which to define or modify properties.
    * @param {Object} props An object whose own enumerable properties constitute descriptors for the properties to be defined or modified.
    * @see https:#developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Object/defineProperties
    ###
    @accessors: (object, props) ->
      for propInput of props
        Objects.accessor(object, propInput, props[propInput].get, props[propInput].set)
