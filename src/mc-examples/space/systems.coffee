define (require) ->
  gamecs = require('gamecs')
  components = require('components')

  class System
    constructor: (options) ->
      for k, v of options then @[k] = v

  # Render
  systems =
    Rendering: class extends System
    
      constructor: () ->
        # TODO: use an option param to param scale
        this.scaleRate = 1.5

      update: (entity, ms) ->
        if(entity.components.Animated)
          component = entity.components.Animated
          if(!component.animation.currentAnimation)
            component.image = component.animation.entitySheet.get(0)

      draw: (entity, surface) ->
        if(entity.dirty && entity.components.Visible)
          component = entity.components.Visible

          # offset = [0, 0]
          #rect = entity.rect.move(camera.getOffset())
          #rect = entity.rect
          #if entity.components.Visible.image then surface.blit(entity.image, rect, offset) else surface.fill(entity.color, rect)

          #image = entity.image
          #entity.components.Visible.image.rect = entity.rect
          #console.log entity.rect
          #console.log entity.components.Visible.image.rect
          #entity.components.Visible.image.clear()
        
          #entity.rect.topleft = entity.pos
          if(component.image)
            surface.clear(entity.oldRect)
            surface.fill('#fff', entity.rect)
            surface.blit(component.image, entity.rect)
          else
            #gamecs.Draw.circle(surface, '#fff', entity.oldRect.topleft, 1, 0)
            if entity.oldRect
              entity.oldRect.topleft = [entity.oldRect.left - 1, entity.oldRect.top - 1]
              surface.clear(entity.oldRect)
            gamecs.Draw.circle(surface, '#fff', entity.rect.topleft, 1, 0)

          entity.dirty = false

      clear = (sprite, surface, camera) ->
        #offset = camera.getOffset()
        #if(sprite.oldRect)
        #  oldRect = sprite.oldRect.move(camera.getOffset())
        #  surface.clear(oldRect)
        #    if(sprite.oldImage)
        #      surface.blit(sprite.oldImage, oldRect)
        #sprite.oldRect = sprite.rect.clone()
        #size = sprite.image ? sprite.image.getSize() : [sprite.rect.width, sprite.rect.height]
          
        #imgSize = new gamecs.Rect([0,0], size)
        #mySurface = new gamecs.Surface(size)
        
        #rect = sprite.rect.move(camera.getOffset())
        #size = surface.getSize()
        #if(rect.left + rect.width < size[0] && rect.top + rect.width < size[1] && rect.left > size[0] && rect.top > size[1])
        #  mySurface.blit(surface, imgSize, rect)
        #  sprite.oldImage = mySurface

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


    Collision: class extends System
      # entity.components.Collidable ?
      _spriteCollide = (entity, entities) ->
        collisions = []
        for entity2 in entities
          if entity.uid != entity2.uid
            if entity.rect.collideRect(entity2.rect)
              collisions.push entity2
        return collisions

      _isColliding = (entity, entities) ->
        res = false
        for entity2 in entities
          if entity.rect.collideRect(entity2.rect)
            res = true
            break
        return res

      update: (entity, ms) ->
        if entity.components.Collidable && entity.components.Mobile
          component = entity.components.Mobile
          if component.moveX != 0 || component.moveY != 0
            x = component.moveX * component.speed
            y = component.moveY * component.speed
            
            collisions = _spriteCollide(entity, @entities)
            #console.log collisions
            if(collisions.length > 0)

              weapon = false
              for entity2 in collisions
                if entity2.components.Weaponized
                  weapon = true
                  entity.killed = true
                  entity.killer = entity2.name
                if entity.components.Weaponized
                  entity2.killed = true
                  entity2.killer = entity.name

              if !weapon
                entity.rect = entity.oldRect.clone()
                entity.rect.moveIp(x, 0)

                # TODO: manage collision post movement
                collisions = _spriteCollide(entity, @entities)
                if(collisions.length > 0)
                   x = 0
                   entity.rect = entity.oldRect.clone()

                entity.rect.moveIp(0, y)
                collisions = _spriteCollide(entity, @entities)

                if(collisions.length > 0)
                  y = 0
                  entity.rect = entity.oldRect.clone()

                entity.rect = entity.oldRect.clone()

                if x != 0 || y != 0 then entity.rect.moveIp(x, y)
                else
                  entity.dirty = false
                  #component.moveY = 0
                  #component.moveX = 0

    Movement: class extends System
      update: (entity, ms) ->
        if entity.components.Mobile
          component = entity.components.Mobile
          if component.moveX != 0 || component.moveY != 0
            # Handle animations that depends on moves
            #if(entity.Animated)
              #&& entity.animation.currentAnimation != 'pause') {
              # TODO: seperate animation from orientation ?
              #animation = switch
              #  when entity.moveX < 0 then "left"
              #  when entity.moveX > 0 then "right"
              #  when entity.moveY < 0 then "up"
              #  when entity.moveY > 0 then "down"
              #  else "pause"

              #if(animation && animation != entity.animation.currentAnimation)
              #  entity.animation.start(animation)

              #entity.image = entity.animation.update(30)


            entity.oldRect = entity.rect.clone()

            # TODO: Maybe manage mobile object while pressing a key that will put the user in a pushing/pulling position
            x = component.moveX * component.speed
            y = component.moveY * component.speed

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
