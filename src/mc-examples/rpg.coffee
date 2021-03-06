require ['gamecs'], (gamecs) ->
  requirejs.config({baseUrl: 'build/mc-examples/space'})
  require ['systems', 'entity', 'camera'], (systems, Entity, Camera) ->
    requirejs.config({baseUrl: 'build/mc-examples/rpg'})
    require ['director', 'data', 'http', 'tilemap'], (Director, data, Http, TileMap) ->

      resources = []
      myEntities = []
      mySystems = {}

      # Load images from Data
      # TODO: block below is generic code, should be moved in utility class
      for k, v of data.sprites
        if v.Visible && v.Visible.image
          resources.push data.prefixs.image + v.Visible.image
        if v.Animated && v.Animated.frameset
          resources.push data.prefixs.image + v.Animated.imageset
      resources.push data.prefixs.image + data.map.tilesheet

      # Load sound from data
      # TODO: sound should be managed by a system.
      gamecs.Mixer.sfxType = false
      for k in ['mp3', 'wav', 'ogg', 'm4a']
        if gamecs.Mixer.support[k]
          gamecs.Mixer.sfxType = k
          break

      # Load sound from Data
      for k in data.sfx
        resources.push data.prefixs.sfx + k + '.' + gamecs.Mixer.sfxType

      # Load map TODO: preload other thing than image and sfx ?
      req = Http.get(data.map.url)

      # Preload resources
      gamecs.preload(resources)

      gamecs.ready () ->

        # prepare map
        mapData = JSON.parse(req.response)
        mapData.tilesets[0].image = data.prefixs.image + data.map.tilesheet
        map = new TileMap(mapData)
        map.prepareLayers()

        # Init screen layers
        display = {
          bg: gamecs.Display.setMode(data.screen.size, 'background')
          fg:  gamecs.Display.setMode(data.screen.size, 'sprites')
          fg2: gamecs.Display.setMode(data.screen.size, 'foreground')
        }

        scaleRate = 1.5
        display.fg._context.scale(scaleRate, scaleRate)
        display.bg._context.scale(scaleRate, scaleRate)

        camera = new Camera(data.screen.size)
        camera.scale(scaleRate)

        # Init director
        myDirector = new Director(display, {data: data, map: map, camera: camera})
        #myDirector.groups.sprites[2].animation.start 'active'
        #myDirector.groups.sprites[3].animation.start 'wave'

        # Init systems
        for k in data.systems
          mySystems[k] = new systems[k]({ entities: myDirector.groups.sprites, map: map })
        mySystems['Collision'].spriteCollide = (e, es) ->
          return if @map.isColliding(e.rect) then [{components: {}}] else @_spriteCollide(e, es)

        tick = () ->

          # 1. Handle input and A.I.
          myDirector.handleInput(gamecs.Input.get())
          # TODO: following should be a system
          myDirector.handleAI()

          # 2. Update
          for k, group of myDirector.groups then for entity in group
            for k2, system of mySystems then system.update(entity, 30)
          
          # Director move camera if the character goes out
          myDirector.setOffset(mySystems.Rendering)

          # 3. Draw
          #for entity in myDirector.groups.stars then mySystems.Rendering.draw(entity, display.bg2)
          for entity in myDirector.groups.sprites then mySystems.Rendering.draw(entity, display.fg)

          # 4. Game Over condition
          if myDirector.player.killed && !myDirector.isGameOver then myDirector.gameOver()

        gamecs.Time.interval(tick, 36)
