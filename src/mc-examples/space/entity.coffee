define (require) ->
  components = require('components')

  class Events

    on: (name, cb) ->
      if(!@_events) then @_events = {}
      if(!@_events[name]) then @_events[name] = []
      @_events[name].push cb

    off: (name) -> if(@_events) then delete @_events[name]

    trigger: (name, argv = {}, callback = null) ->
      if @_events && @_events[name]
        for cb in @_events[name]
          cb({name: name, ctx: @, params: argv})

  class Entity extends Events
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
            if !components[k].prototype.hasOwnProperty(k2) then console.log 'Warning Component Property "' + k2 + '" Not Found in ' + k + '| current value: ' + v2
            if v2 instanceof Array then @components[k][k2] = v2.slice(0)
            else @components[k][k2] = v2
            
        else console.log 'Warning Component Class "' + k + '" Not Found.'

    toString: () ->
      return (@name || "Entity") + '#' + @uid
