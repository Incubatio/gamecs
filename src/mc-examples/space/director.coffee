define (require) ->
  gamecs = require('gamecs')
  Entity = require('entity')

  class Collider
    @kill: (e) ->
      #weapon = false
      entity = e.ctx
      entity2 = e.params.to

      if entity2.components.Weaponized
        #weapon = true
        entity.killed = true
        entity.killer = entity2.name
      if entity.components.Weaponized
        entity2.killed = true
        entity2.killer = entity.name

  class Director
    isGameOver: false
  
    loadImage: (suffix) ->
      return gamecs.Img.load(@data.prefixs.image + suffix)

    sounds: {}
    playSound: (suffix) ->
      sound = new gamecs.Mixer.Sound(@data.prefixs.sfx + suffix + '.' + gamecs.Mixer.sfxType)
      sound.play()

    getRandPos: (x = false, y = false) ->
      if(x == false) then x = Math.round(Math.random() * @data.screen.size[0])
      if(y == false) then y = Math.round(Math.random() * @data.screen.size[1])
      return [x, y]

    createStar: (options = {}) ->
      k = 'Star'
      v = @data.sprites[k]
      pos = @getRandPos(options.x, options.y)
      star = new Entity(pos, v, {name: k, rect: new gamecs.Rect(pos, v.Visible.size), dirty: true})

      star.components.Mobile.speedY = Math.round(v.Mobile.speedY * Math.random()) + 1

      v = @data.sprites['Star']
      #@starImage = new gamecs.Surface(v.Visible.size)
      star.image = new gamecs.Surface(v.Visible.size)
      radius = Math.floor(Math.random() * 1.2) + Math.floor(Math.random() * 1.1) + 1
      gamecs.Draw[v.Visible.shape](star.image, '#fff', [radius,radius], radius, 0)

      #star.image = @starImage
      return star

    createMeteor: (options = {}) ->
      k = 'Meteor'
      v = @data.sprites[k]
      pos = @getRandPos(options.x, - v.Visible.size[1])
      star = new Entity(pos, v, {name: k, rect: new gamecs.Rect(pos, v.Visible.size), dirty: true})
      star.components.Mobile.speedY = Math.round(v.Mobile.speedY * Math.random()) + 1
      star.on('collision', Collider.kill) #if star.components.Collidable
      star.image = v.Visible.image
      return star


    constructor: (@display, @data) ->
      @font = new gamecs.Font('20px monospace')

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
        entity.image = entity.components.Visible.image if entity.components.Visible
        entity.on('collision', Collider.kill) if entity.components.Collidable
        @groups.sprites.push entity
        @player = entity if entity.name == "Player"
      @player.score = 0
      @blitScore(0)


      # Init stars for background
      for i in [0..@data.stars.number] then @groups.stars.push @createStar()


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
              entity.killed = true
              if entity.name == 'Star' && @groups.stars.length <= @data.stars.number
                # weird param requirement
                @groups.stars.push @createStar({y: 0})

      # Manage player's weapon cooldown
      if @player.cooldown <= 0 or !@player.cooldown
        if @player.firing
          v = @data.sprites.RLazer
          pos = [@player.rect.left + 45, @player.rect.top - 50]
          lazer = new Entity(pos, v, {name: 'RLazer', rect: new gamecs.Rect(pos, v.Visible.size), dirty: true})
          lazer.image = lazer.components.Visible.image
          lazer.on('collision', Collider.kill) #if star.components.Collidable
          @groups.sprites.push lazer
          @playSound('laser1')
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
        if entity && entity.killed
          if entity.name == 'Meteor' && entity.killer == 'RLazer' then @blitScore(10)
          @display.fg.clear(entity.rect)
          group.splice(i, 1)

    gameOver: () ->
      @isGameOver = true
      s1 = @data.screen.size
      surface = new gamecs.Surface(s1)
      #display.clear()
      surface.setAlpha(0.5)
      surface.fill('#f00')
      @display.fg2.blit(surface)
      @display.fg2.blit(@font.render('Game Over', '#fff'), [s1[0] / 2 - 30, s1[1] / 2 - 5])

    blitScore: (score) ->
      @player.score += score
      s = @data.screen.size
      #@display.fg2.clear()
      score = (@player.score + 10000000).toString().slice(1)
      surface = @font.render(score, '#fff')
      pos = [s[0] - 100, 20]

      @display.fg2.clear(surface.clone().clear(), pos)
      @display.fg2.blit(surface, pos)
