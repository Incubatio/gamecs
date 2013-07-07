define (require) ->
  gamecs = require('gamecs')
  components = require('components')

  class System
    constructor: (options) ->
      for k, v of options then @[k] = v

  # Render
  systems =
    Rendering: class extends System

      offset: [0, 0]

      constructor: () ->
        # TODO: use an option param to param scale
        @scaleRate = 1.5

      update: (entity, ms) ->
        #if(entity.components.Animated)
        if(entity.animation)
          component = entity.components.Animated
          entity.image = entity.animation.update(ms)
          #else if component.entitySheet then entity.image = component.entitySheet.get(0)

      draw: (entity, surface) ->
        #if(entity.dirty && entity.components.Visible)
          #component = entity.components.Visible

        if(entity.image)
          surface.clear(entity.oldRect.move(@offset))
#          surface.fill('#F00', entity.rect)
          surface.blit(entity.image, entity.rect.move(@offset))

          entity.dirty = false

    # Transform Rotation
    Rotation: class extends System
      update: (sprite) ->
        if(!sprite.components.Visible.originalImage) then sprite.components.Visible.originalImage = sprite.components.Visible.image
        if(sprite.components.Rotative)
          sprite.components.Rotative.rotation += sprite.components.Rotative.rotationSpeed
          if sprite.components.Rotative.rotation >= 360 then sprite.components.Rotative.rotation -= 360
          sprite.components.Visible.image = gamecs.Transform.rotate(sprite.components.Visible.originalImage, sprite.components.Rotative.rotation)
          size = sprite.components.Visible.image.getSize()
          sprite.rect.width = size[0]
          sprite.rect.height = size[1]
          sprite.dirty = true



    # NOTE: possible perf optimisation: test collision and save position every second (instead of each frame)
    # if collision, replace sprite the position saved the last second
    Collision: class extends System
      ###
      _isColliding: (entity, entities) ->
        res = false
        for entity2 in entities
          if entity.rect.collideRect(entity2.rect)
            res = true
            break
        return res
      ###
      
      ###* function used to detect the collision 
      * @param {Object} entity
      * @param {Array} entities
      * @return {Array}
      ###
      spriteCollide: () -> return []

      constructor: () ->
        super
        @spriteCollide = @_spriteCollide

      # entity.components.Collidable ?
      _spriteCollide: (entity, entities) ->
        collisions = []
        for entity2 in entities
          if entity.uid != entity2.uid
            if entity.rect.collideRect(entity2.rect)
              collisions.push entity2
        return collisions

        

      update: (entity, ms) ->
        # We assume that we need a mobile object to test for collision
        if entity.components.Collidable && entity.components.Mobile
          component = entity.components.Mobile
          if component.moveX != 0 || component.moveY != 0
            x = component.moveX * component.speed
            y = component.moveY * component.speed
            
            collisions = @spriteCollide(entity, @entities)
            if(collisions.length > 0)
              for entity2 in collisions
                entity.trigger('collision', {to: entity2})

              # TOTHINK: (1) possible optimisation: if sprite has been killed during previous event triggering, skip following code
              # TOTHINK: (2) Should following be placed in an event ? (First thought: I don't think so ...)
              entity.rect = entity.oldRect.clone()
              entity.rect.moveIp(x, 0)

              # TODO: manage collision post movement
              collisions = @spriteCollide(entity, @entities)
              if(collisions.length > 0)
                 x = 0
                 entity.rect = entity.oldRect.clone()

              entity.rect.moveIp(0, y)
              collisions = @spriteCollide(entity, @entities)

              if(collisions.length > 0)
                y = 0
                entity.rect = entity.oldRect.clone()

              entity.rect = entity.oldRect.clone()

              if x != 0 || y != 0 then entity.rect.moveIp(x, y)
              else entity.dirty = false

    Movement: class extends System
      update: (entity, ms) ->
        if entity.components.Mobile
          component = entity.components.Mobile
          if component.moveX != 0 || component.moveY != 0

            entity.oldRect = entity.rect.clone()

            # TODO: Maybe manage mobile object while pressing a key that will put the user in a pushing/pulling position
            # 1 straight move = ~1.41 diagonal move, possible optimization ratio:  3/~4.25 and 5/~7.07
            multiplier = if(component.moveX != 0 && component.moveY != 0) then 1 else 1.41

            x = Math.round(component.moveX * component.speed * multiplier)
            y = Math.round(component.moveY * component.speed * multiplier)

            entity.dirty = true
            entity.rect.moveIp(x, y)
            # TODO: check namespace entityGroup.entityCollide ?

            #for k, entity2 of collisions
              #if(!entity2.Traversable) entity2.dirty = true
              #entity2.dirty = true


    Weapon: class extends System
      update: (sprite, ms, director) ->
        if(sprite.Weaponized && sprite.attacking)
          weapon = director.scene.sprites[sprite.weapon]
        
          # test for current animation and if not exists, start it
          if(!weapon.animation.currentAnimation)
            console.log(sprite.animation.currentAnimation)
            animation = if (!sprite.animation.currentAnimation || sprite.animation.currentAnimation == "pause") then "down" else sprite.animation.currentAnimation
            weapon.animation.start(animation)
          #Rendering.clear(weapon, director.display)
          weapon.oldImage = undefined

          # test for collision, apply hit
          collisions = gamecs.sprite.spriteCollide(weapon, director.scene.spriteGroup)
          for k, sprite2 of collisions
            if sprite2.Destructible
              director.surface.clear(sprite2.rect)
              sprite2.kill()
          
          # TODO: push ennemy on hit
          # TODO: if ennemy is comming double hit, immobile normal hit, backing = 1/2 hit


          # Check if animation is finished, if not update image
          if(weapon.animation.finished)
            sprite.attacking = false
            weapon.animation.currentAnimation = undefined
            weapon.dirty = false
            weapon.rect.moveIp([- (sprite.rect.left + sprite.rect.width*2), - (sprite.rect.top + sprite.rect.height*2)])
          else
            weapon.dirty = true
            weapon.rect.moveIp(sprite.rect.left - weapon.rect.left, sprite.rect.top - weapon.rect.top)
            weapon.image = weapon.animation.update(60)
