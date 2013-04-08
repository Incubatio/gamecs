require ['gamecs'], (gamecs) ->
  requirejs.config({baseUrl: 'build/mc-examples/space'})
  require ['gamecs', 'systems', 'director', 'data'], (gamecs, systems, Director, data) ->

    resources = []
    myEntities = []
    mySystems = {}

    # Load resources from Data
    for k, v of data.sprites
      if v.Visible && v.Visible.image
        resources.push data.prefixs.image + v.Visible.image
      #if v.Animated && v.Animated.frameset
      #  resources.push data.prefixs.image + v.Animated.frameset
    gamecs.preload(resources)

    gamecs.ready () ->

      display =
        bg1: gamecs.Display.setMode(data.screen.size, 'background')
        bg2: gamecs.Display.setMode(data.screen.size, 'stars')
        fg:  gamecs.Display.setMode(data.screen.size, 'foreground')

      myDirector = new Director(display, data)

      # Init systems
      for k in data.systems
        mySystems[k] = new systems[k]({ entities: myDirector.groups.sprites, data: data })

      tick = () ->

        myDirector.handleInput(gamecs.Input.get())


        # Update
        for k, group of myDirector.groups then for entity in group
          for k2, system of mySystems then system.update(entity, 30)



        # Draw
        for entity in myDirector.groups.stars then mySystems.Rendering.draw(entity, display.bg2)
        for entity in myDirector.groups.sprites then mySystems.Rendering.draw(entity, display.fg)

        myDirector.update()

      gamecs.Time.interval(tick, 36)
