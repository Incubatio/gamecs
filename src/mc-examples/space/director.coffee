define (require) ->
  gamecs = require('gamecs')
  Entity = require('entity')

  class Director
    loadImage: (suffix) ->
      return gamecs.Img.load(@data.prefixs.image + suffix)

    getRandPos: (x = false, y = false) ->
      if(x == false) then x = Math.round(Math.random() * @data.screen.size[0])
      if(y == false) then y = Math.round(Math.random() * @data.screen.size[1])
      return [x, y]

    createStar: (options = {}) ->
      k = 'Star'
      v = @data.sprites[k]
      pos = @getRandPos(options.x, options.y)
      star = new Entity(pos, v, {name: k, rect: new gamecs.Rect(pos, v.Visible.size), dirty: true})
      star.components.Mobile.speed = Math.round(v.Mobile.speed * Math.random()) + 1
      return star

    createMeteor: (options = {}) ->
      k = 'Meteor'
      v = @data.sprites[k]
      pos = @getRandPos(options.x, - v.Visible.size[1])
      star = new Entity(pos, v, {name: k, rect: new gamecs.Rect(pos, v.Visible.size), dirty: true})
      star.components.Mobile.speed = Math.round(v.Mobile.speed * Math.random()) + 1
      return star


    constructor: (@display, @data) ->
      @display.bg1.fill('#000')
      @display.fg.blit((new gamecs.Font('45px Sans-serif')).render('Hello World'))

      # Bind resource on Sprites data
      for k, v of @data.sprites
        if v.Visible && v.Visible.image
          v.Visible.image_urn = v.Visible.image
          v.Visible.image = @loadImage(v.Visible.image_urn)
          v.Visible.size = v.Visible.image.getSize()

      # TODO: entities or groups[] = sprites + stars
      # Init sprites
      @groups = { stars: [], sprites: []}
      for [k, pos] in @data.scene.actors
        v = @data.sprites[k]
        entity = new Entity(pos, v, {name: k, rect: new gamecs.Rect(pos, v.Visible.size), dirty: true})
        entity.oldRect = entity.rect.clone()
        @groups.sprites.push entity
        @player = entity if entity.name == "Player"

      # Init stars for background
      for i in [0..@data.stars.number] then @groups.stars.push @createStar()


    handleInput: (events) ->
      # Handle Input
      component = @player.components.Mobile
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
        else if event.type == gamecs.Input.T_KEY_UP
          switch event.key
            when gamecs.Input.K_UP,    gamecs.Input.K_w then if y < 0 then y = 0
            when gamecs.Input.K_DOWN,  gamecs.Input.K_s then if y > 0 then y = 0
            when gamecs.Input.K_LEFT,  gamecs.Input.K_a then if x < 0 then x = 0
            when gamecs.Input.K_RIGHT, gamecs.Input.K_d then if x > 0 then x = 0
            when gamecs.Input.K_SPACE then @player.firing = false
        component.moveX = x
        component.moveY = y

    update: () ->
      # Manage world bounds for every entities
      for k, group of @groups then for entity in group
        if entity.components.Mobile
          w = @data.screen.size[0]
          h = @data.screen.size[1]
          w2 = Math.round(entity.rect.width / 2)

          if entity.name == 'Player'
            if entity.rect.left < - w2  then entity.rect.left = - w2
            else if entity.rect.right > w + w2 then entity.rect.right = w + w2
            if entity.rect.top < 0 then entity.rect.top = 0
            else if entity.rect.bottom > h then entity.rect.bottom = h

          else
            if entity.rect.left < - w2  || entity.rect.right > w + w2 || entity.rect.bottom < 0 || entity.rect.top > h
              entity.kill = true
              if entity.name == 'Star' && @groups.stars.length <= @data.stars.number
                # weird param requirement
                @groups.stars.push @createStar({y: 0})

      # Manage player's weapon cooldown
      if @player.cooldown <= 0 or !@player.cooldown
        if @player.firing
          v = @data.sprites.RLazer
          pos = [@player.rect.left + 45, @player.rect.top - 50]
          @groups.sprites.push new Entity(pos, v, {name: k, rect: new gamecs.Rect(pos, v.Visible.size), dirty: true})
          @player.cooldown = 100
      else @player.cooldown -= 30


      if @data.meteors.cooldown <= 0 or !@data.meteors.cooldown
        @groups.sprites.push @createMeteor()
        @data.meteors.cooldown = @data.meteors.spawnRate
      else @data.meteors.cooldown -= 30
        


      # Garbage collection: collect the dead
      # TODO: Implement Pool of entity with real garbage collection
      for k, group of @groups then for i in [0...group.length]
        entity = group[i]
        if entity && entity.kill
          @display.fg.clear(entity.rect)
          group.splice(i, 1)
