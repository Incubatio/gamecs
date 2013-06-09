define (require) ->
  gamecs      = require('gamecs')
  Entity = require('entity')
  Animation   = require('animation')
  components  = require('components')
  systems     = require('systems')
  SpriteSheet = require('spritesheet')
  #particles   = require('particles')
  #Dismantle   = require('effects').Dismantle


  class Camera
    constructor: (surface, options) ->
      options = options || {}
      @x = options.x || 0
      @y = options.y || 0
      # interval between screen, it's best if i = max(hero.width, hero.height)
      @i = options.i || 64
      @dirty = false
      @surface = surface


    isVisible: (gobject) ->
      return gobject.rect.collideRect(@getScreenRect())

    getOffset: () ->
      offset =  @getScreenRect().topleft
      return [-offset[0], -offset[1]]

    getScreenRect: () ->
      size = @surface.getSize()
      i = @i

      a = (n, m) -> n * m - (n > 0 ? i * n : 0)

      left = a(@x, size[0])
      top = a(@y, size[1])

      return new gamecs.Rect([left, top], size)

    # TODO: follow could be call one time to be bound to some game object, and then the rest of 
    #       the code should be placed in a update method ish
    follow: (sprite) ->
      surface = @surface
      rect = sprite.rect
      screenRect = @getScreenRect()
      x = @x
      y = @y
      switch
        when (sprite.moveY < 0 && rect.top < screenRect.top) then y--
        when (sprite.moveY > 0 && rect.top + rect.height > screenRect.top + screenRect.height) then y++
        when (sprite.moveX < 0 && rect.left < screenRect.left) then x--
        when (sprite.moveX > 0 && rect.left + rect.width > screenRect.left + screenRect.width) then x++
      if(x != @x || y != @y)
        @dirty = true
        @x = x
        @y = y

  #TOTHINK: Manage screen size in scenes ?
  class Director

    loadImage: (suffix) ->
      return gamecs.Img.load(@data.prefixs.image + suffix)

    constructor: (@display, @data) ->

      @MENU    = 1
      @LOADING = 2
      @RUNNING = 3
      @PAUSE   = 4
      @CONSOLE = 5

      @font = new gamecs.Font('20px monospace')

      #@display.bg1.fill('#000')
      @display.fg.blit((new gamecs.Font('45px Sans-serif')).render('Hello World'))
      @display.bg.blit(@loadImage('stargate.png'), [250, 1])


      # Bind resource on Sprites data
      for k, v of @data.sprites
        if v.Visible && v.Visible.image
          v.Visible.image_urn = v.Visible.image
          v.Visible.image = @loadImage(v.Visible.image_urn)
          v.Visible.size = v.Visible.image.getSize()
        if v.Animated && v.Animated.imageset
          v.Animated.entitySheet = new SpriteSheet()
          v.Animated.entitySheet.load(@loadImage(v.Animated.imageset), v.Visible.size)

      # TODO: entities or groups[] = sprites + stars
      # Init sprites
      @groups = { sprites: []}
      for [k, pos] in @data.scene.actors
        v = @data.sprites[k]
        entity = new Entity(pos, v, {name: k, rect: new gamecs.Rect(pos, v.Visible.size), dirty: true})
        entity.oldRect = entity.rect.clone()
        if entity.components.Visible then entity.image = entity.components.Visible.image
        if v.Animated && v.Animated.imageset
          entity.animation = new Animation(v.Animated.entitySheet, v.Animated.frameset, v.Animated.options)
        
        @groups.sprites.push entity
        @player = entity if entity.name == "Player"
      @player.score = 0

    handleInput: (events) ->
      # Handle Input
      component = @player.components.Mobile
      if !@isGameOver
        for event in events
          x = component.moveX
          y = component.moveY
          if event.type == gamecs.Input.T_KEY_DOWN
            switch event.key
              when gamecs.Input.K_UP,    gamecs.Input.K_w then y = -1
              when gamecs.Input.K_DOWN,  gamecs.Input.K_s then y = 1
              when gamecs.Input.K_LEFT,  gamecs.Input.K_a then x = -1
              when gamecs.Input.K_RIGHT, gamecs.Input.K_d then x = 1
              when gamecs.Input.K_SPACE then @player.firing = true
              when gamecs.Input.K_t then @test()
          else if event.type == gamecs.Input.T_KEY_UP
            switch event.key
              when gamecs.Input.K_UP,    gamecs.Input.K_w then if y < 0 then y = 0
              when gamecs.Input.K_DOWN,  gamecs.Input.K_s then if y > 0 then y = 0
              when gamecs.Input.K_LEFT,  gamecs.Input.K_a then if x < 0 then x = 0
              when gamecs.Input.K_RIGHT, gamecs.Input.K_d then if x > 0 then x = 0
              when gamecs.Input.K_SPACE then @player.firing = false
          component.moveX = x
          component.moveY = y

          animation = switch
            when x < 0 then "left"
            when x > 0 then "right"
            when y < 0 then "up"
            when y > 0 then "down"
            #else "pause"
            else @player.animation.reset(); false
          if animation && !(animation == @player.animation.currentAnimation && @player.animation.running)
            @player.animation.start(animation)
            #@player.dirty = true

    handleAI: () ->


    test: () ->
      console.log 'test'
      for entity in @groups.sprites
        console.log entity if entity.components.Visible

    setScene: (myScene, dirty) ->
      @scene = myScene
      @camera.dirty = dirty != false ?  true : false

      # Simple scenes
      menu: () ->
        @status = @MENU

        #size = @surface.getSize()
        #@surface.blit(@font.render("Play"), [size[0]/2 - 70, @size[1]/2])


      win: () ->

      loose: () ->

      start: (myScene) ->
        @status = @RUNNING
        @setScene(myScene)

      loading: () ->
        @status = @LOADING
        myScene = {
          sprites : {},
          spriteGroup : new gamecs.sprite.Group()
        }
        size   = @surface.getSize()
        image  = @loadImage('loading.png')
        sprite = components.create('Visible', 'Rotative')
        pos    = [size[0]/2 - 40, size[1]/2 - 40]
        size   = image.getSize()
        sprite.rect = new gamecs.Rect(pos, size)
        sprite.originalImage = image

        myScene.spriteGroup.add(sprite)
        myScene.sprites['loading'] = sprite

        #@surface.blit(@font.render("LoadinG ..."), [size[0]/2 - 70, size[1]/2])
        #@surface.blit(@loadImage('loading.png'), [size[0]/2 - 40, size[1]/2 - 40])

        @setScene(myScene, true)


      # OH YEAHHHH
      everyoneIsDirty: () ->
        for k, sprite of @scene.sprites
          sprite.oldImage = false
          sprite.dirty = true

      test: () ->
        console.log('test', @status)
        if(@status == "running")
          @pauseScene = @scene
          @loading()
        else
          if(@status == "loading")
            @start(@pauseScene)
            @everyoneIsDirty()

      test2 = () ->
        #console.log(@scene.sprites.Player.rect)

        if(!@emitter)
          $v = require('utils/vectors')

          player = @scene.sprites.Player
          @emitter = new particles.Emitter({
            delay: 50,
            numParticles: 100,
            pos: player.rect.center,
            #modifierFunc: particles.Modifiers.tail(2, 0.5, 'rgb(255, 0, 0)', $v.multiply([0,0], -1))
            modifierFunc: particles.Modifiers.explosion(4, 2, "rgba(255,0,0,0.6)")
          })
          @emitter.start()

          image = gamecs.transform.scale(player.image, $v.multiply(player.image.getSize(), 1))
          @dismantle = new Dismantle(image, { pos: player.rect.topleft })

      testUpdate: () ->
         ms = 10
        if(@emitter && @emitter.isRunning())
          @dismantle.age += ms
          if (@dismantle.age >= @dismantle.lifetime)
             @emitter.stop()
             @emitter = null
          else
           @emitter.update(ms)
           @dismantle.update(ms)

      testDraw: () ->
        
        if(@emitter && @emitter.isRunning())
          player = @scene.sprites.Player
          #@surface.clear(player.rect)
          #@surface.clear(new gamecs.Rect([0, 0], [700, 700]))
          #@systems.Rendering.clear(player, @surface)
          #@emitter.pos = player.rect.topleft
          @emitter.draw(@surface)
          @dismantle.draw(@surface)
        else if(@emitter)
          @emitter = false
          #@surface.clear(new gamecs.Rect([0, 0], [500, 500]))

      loadImage: (image) ->
        return gamecs.image.load(@prefixs.image + image)
      
      ###
      * @arg string param || array params
      ###
      loadScene = (name, myCallback) ->

        #Loading
        @loading()

        #console.log(this)
        @sceneLoader.get(name)

      readScript: (scriptName, scene) ->
        scene = scene || @scene
        #console.log('... reading ' + scriptName)
        if(scene.scripts && scene.scripts[scriptName])
          @instructions = @sceneReader.parse(scene.scripts[scriptName])

      _act = (params) ->
        console.log("call:" + params)
        func = params.shift()
        if(@[func]) @[func].apply(@, params)
        else
          throw new SyntaxError("try to call " + func + "(), which is not accessible or does not exists")

      act: () ->
        if(@instructions.length > 0)
          @_act(@instructions.shift())

      #TOTHINK: Manage update speed in scenes ?
      update: () ->

        for k, sprite of @scene.sprites
          for system in @systems

            #TOTHINK: define empty methods vs test if method exists
            # TODO: an event base application would be more proper: cf Incube_Events
            system.update(sprite, 30, @)
        
            # because of the collision in systems.movment, i can't have lazy refresh
        @testUpdate()
        if(@scene.sprites.Player) then @camera.follow(@scene.sprites.Player)
        if(@camera.dirty) then @everyoneIsDirty()

      draw: () ->

        #for k, sprite of @scene.sprites
          #if(!@dark && sprite.dirty && sprite.rect.left > 0 && sprite.rect.top > 0) @systems.Rendering.clear(sprite, @surface, @camera)

        @camera.dirty = true
        if(@camera.dirty) then @systems.Rendering.drawBackground(@)

        for k, sprite of @scene.sprites
          sprite.dirty = true
          if(!@dark && sprite.rect.left > 0 && sprite.rect.top > 0)
            @systems.Rendering.draw(sprite, @surface, @camera)
          ## TOTHINK: define empty methods vs test if method exists
          ## TODO: an event base application would be more proper: cf Incube_Events
        #@testDraw()

      finish: () ->
        @status = @LOADING
        console.log("Kikoo")
        myScene = {
            sprites : {},
            bgImage: @loadImage("finish.png"),
            spriteGroup : {}
        }

        @setScene(myScene, false)
        @surface.blit(myScene.bgImage, new gamecs.Rect([0,0], @surface.getSize()))



      ###
      * Function below are accesible from scene scripts, 
      * TODO: for better encapsulation, put them into a new namespace, e.g: Director.prototype.scriptMethods
      ###

      # TODO: develop dialog system, jquery ui was the fast heavy, dirty solution
      _dialog = (actor, msg, buttons) ->
        console.log('test', actor, msg)

        size = @surface.getSize()
        pos = [0, size[1] - 200]
        rect = new gamecs.Rect(pos, [size[1], 200])
        @surface.fill('#00f', rect)
        @surface.blit(@font.render("LoadinG ..."), pos)
        #@busy=true


      dialog: (actor, msg) ->
        
        @_dialog(actor, msg, {})

        self = @
        div = $(".ui-dialog")
        div.keydown (event) ->
          if(!event.isDefaultPrevented() && event.keyCode && event.keyCode == $.ui.keyCode.SPACE )
            self.busy = false
            div.unbind(event)
            event.preventDefault()

      ask: (label, questions) ->
        buttons = []
        self = @
        
        for k, v of questions
          buttons.push({
            text: v,
            click: () ->
              self[label] = k
              $( @ ).dialog( "close" )
          })
        @_dialog("Player", "", buttons)

      set: (key, value) ->
        @_read(@instructions.shift())
        @scene[key] = value

      increase: (key, value) ->
        if @scene[key] then @scene[key] += value else @scene[key] = value

      switch: (key, values) ->
        @[key] = @[key] || 0
        #console.log('data', values)
        instructions = @sceneReader.parse(values[@[key]])
        @instructions = instructions.concat(@instructions)

      max: (key, values) ->
        lastv = 0
        key2 = values[0]
        scene = @scene
        for k, v of values
          if(scene[v])
            if(scene[v]>lastv)
              key2 = v
              lastv = scene[v]
        @scene[key] = key2

