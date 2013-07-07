class Events
  _eventables = []

  #constructor: (@_eventables = []) ->

  _on = (name, cb) ->
    if(!@_events[name]) then @_events[name] = []
    @_events[name].push cb
  
  _off = (name) -> delete @_events[name]

  _trigger = (name, argv = {}, callback = null) ->
    if @_events[name]
      for cb in @_events[name]
        cb({name: name, ctx: @, params: argv})

  @eventize: (obj) ->
    _eventables.push obj
    obj._events = {}
    obj.on = _on
    obj.off = _off
    obj.trigger = _trigger
