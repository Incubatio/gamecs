define (require) ->
  gamecs      = require('gamecs')
  Entity      = require('entity')
  Animation   = require('animation')
  components  = require('components')
  systems     = require('systems')
  SpriteSheet = require('spritesheet')

  Camera      = require('camera')
  Tilemap     = require('tilemap')
  #particles   = require('particles')
  #Dismantle   = require('effects').Dismantle


  #TOTHINK: Manage screen size in scenes ?
  class Director

    loadImage: (suffix) ->
      return gamecs.Img.load(@options.data.prefixs.image + suffix)

    constructor: (@display, @options) ->

      @font = new gamecs.Font('40px monospace')

      @camera = new Camera(@options.data.screen.size)

      # Bind resource on Sprites data
      for k, v of @options.data.sprites
        if v.Visible && v.Visible.image
          v.Visible.image_urn = v.Visible.image
          v.Visible.image = @loadImage(v.Visible.image_urn)
          v.Visible.size = v.Visible.image.getSize()
        if v.Animated && v.Animated.imageset
          v.Animated.entitySheet = new SpriteSheet()
          v.Animated.entitySheet.load(@loadImage(v.Animated.imageset), v.Visible.size)

      @init()

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

    setOffset: (system) ->
      @camera.follow(@groups.sprites[0])
      #if(@camera.dirty) @everyoneIsDirty()
      if @camera.dirty
        offset = @camera.getOffset()
        @init()

        system.offset = offset
        @camera.dirty = false

    init: () ->
      # init background
      @display.bg.clear()
      @display.fg.clear()
      offset = @camera.getOffset()
      @display.bg.blit(@options.map.layers.collision.image, offset)

      rect = new gamecs.Rect([0,0])

      # init decors
      for v in @options.data.scene.decors
        image = switch v[0]
          when 'text' then @font.render(v[1])
          when 'image' then @loadImage(v[1])
        size = image.getSize()
        rect.init(v[2][0], v[2][1], size[0], size[1])
        if @camera.isVisible { rect: rect}
          @display.bg.blit(image, rect.move(offset))

      # TODO: entities or groups[] = sprites + stars
      # Init sprites
      @groups = { sprites: []}
      @groups.sprites.push @player if @player
      for i, [k, pos] of @options.data.scene.actors
        v = @options.data.sprites[k]
        rect.init(pos[0], pos[1], v.Visible.size[0], v.Visible.size[1])
        if @camera.isVisible {rect: rect}
          entity = new Entity(pos, v, {name: k, rect: new gamecs.Rect(pos, v.Visible.size), dirty: true})
          entity.oldRect = entity.rect.clone()
          if entity.components.Visible then entity.image = entity.components.Visible.image
          if v.Animated && v.Animated.imageset
            entity.animation = new Animation(v.Animated.entitySheet, v.Animated.frameset, v.Animated.options)
            entity.animation.start v.Animated.options.start if v.Animated.options && v.Animated.options.start
      #myDirector.groups.sprites[2].animation.start 'active'
      #myDirector.groups.sprites[3].animation.start 'wave'
        
          @groups.sprites.push entity
          #console.log entity.name, @options.data.scene.actors, k, i
          if entity.name == "Player"
            @player = entity
            delete @options.data.scene.actors[i]


    test: () ->
      console.log 'test'
      for entity in @groups.sprites
        console.log entity if entity.components.Visible
