define (require) ->
  components = require('components')

  class Entity
    UID = 1

    constructor: (@pos, componentsData, options = {}) ->
      @uid = UID++

      for k, v of options then @[k] = v

      @components = {}

      for k, params of componentsData
        #if typeof Components[k] == "function"
        if components.hasOwnProperty(k)
          @components[k] = new components[k]()
          #@components[k].parent = @          

          #init component object, TOTHINK: shouldn't that be the role of Component constructor ?
          for k2, v2 of params
            if components[k].prototype.hasOwnProperty(k2)
              @components[k][k2] = v2
            else console.log 'Warning Component Property "' + k2 + '" Not Found in ' + k + '| current value: ' + v2
        else console.log 'Warning Component Class "' + k + '" Not Found.'

    toString: () ->
      return (@name || "Entity") + '#' + @uid
