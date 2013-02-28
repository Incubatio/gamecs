define (require) ->
  Sprite = require('sprite')
  ###*
  * Sprites are often grouped. That makes collision detection more efficient and
  * improves rendering performance. It also allows you to easly keep track of layers
  * of objects which are rendered to the screen in a particular order.
  *
  * `Group.update()` calls `update()` on all the contained sprites the same is true for `draw()`.
  * @constructor
  ###
  class Group
    constructor: () ->
      ###* @ignore ###
      this._sprites = []

      this.add(arguments[0]) if (arguments[0] instanceof Sprite ||
        (arguments[0] instanceof Array &&
          arguments[0].length &&
          arguments[0][0] instanceof Sprite))

    ###*
    * Update all the sprites in this group. This is equivalent to calling the
    * update method on each sprite in this group.
    ###
    update: () ->
      updateArgs = arguments

      this._sprites.forEach((sp) ->
        sp.update.apply(sp, updateArgs)
      , this)

    ###*
    * Add one or more sprites to this group
    * @param {Array|gamecs.sprite.Sprite} sprites One or more
    * `gamecs.sprite.Sprite` instances
    ###
    add: (sprites) ->
      sprites = [sprites] if (!(sprites instanceof Array))

      sprites.forEach((sprite) ->
        this._sprites.push(sprite)
        sprite._groups.push(this)
      , this)

    ###*
    * Remove one or more sprites from this group
    * @param {Array|gamecs.sprite.Sprite} sprites One or more
    * `gamecs.sprite.Sprite` instances
    ###
    remove: (sprites) ->
      sprites = [sprites] if (!(sprites instanceof Array))

      sprites.forEach((sp) ->
        Arrays.remove(sp, this._sprites)
        Arrays.remove(this, sp._groups)
      , this)
      return

    ###*
    * Check for the existence of one or more sprites within a group
    * @param {Array|gamecs.sprite.Sprite} sprites One or more
    * `gamecs.sprite.Sprite` instances
    * @returns {Boolean} True if every sprite is in this group, false otherwise
    ###
    has: (sprites) ->
      sprites = [sprites] if (!(sprites instanceof Array))

      return sprites.every((sp) ->
        return this._sprites.indexOf(sp) != -1
      , this)

    ###*
    * Get the sprites in this group
    * @returns {Array} An array of `gamecs.sprite.Sprite` instances
    ###
    sprites: () ->
      return this._sprites

    ###
    * Draw all the sprites in this group. This is equivalent to calling each
    * sprite's draw method.
    ###
    draw: () ->
       args = arguments
       this._sprites.forEach((sprite) ->
          sprite.draw.apply(sprite, args)
       , this)
       return

    ###*
    * Draw background (`source` argument) over each sprite in the group
    * on the `destination` surface.
    *
    * This can, for example, be used to clear the
    * display surface to a a static background image in all the places
    * occupied by the sprites of all group.
    *
    * @param {gamecs.Surface} destination the surface to draw on
    * @param {gamecs.Surface} source surface
    ###
    clear: (destination, source) ->
      this._sprites.forEach((sprite) ->
        destination.blit(source, sprite.rect)
      , this)

    ###*
    * Remove all sprites from this group
    ###
    empty: () ->
      this._sprites = []
      return

    ###*
    * @returns {Array} of sprites colliding with the point
    ###
    collidePoint: () ->
      args = Array.prototype.slice.apply(arguments)
      return this._sprites.filter((sprite) ->
        return sprite.rect.collidePoint.apply(sprite.rect, args)
      , this)

    ###*
    * Loop over each sprite in this group. This is a shortcut for
    * `group.sprites().forEach(...)`.
    ###
    forEach: (callback, thisArg) ->
      return this._sprites.forEach(callback, thisArg)

    ###*
    * Check whether some sprite in this group passes a test. This is a shortcut
    * for `group.sprites().some(...)`.
    ###
    some: (callback, thisArg) ->
      return this._sprites.some(callback, thisArg)


    ###*
    * Find sprites in a group that intersect another sprite
    * @param {gamecs.sprite.Sprite} sprite The sprite to check
    * @param {gamecs.sprite.Group} group The group to check
    * @param {Boolean} doKill If true, kill sprites in the group when collided
    * @param {function} collided Collision function to use, defaults to `gamecs.sprite.collideRect`
    * @returns {Array} An array of `gamecs.sprite.Sprite` instances that collided
    ###
    @spriteCollide: (sprite, group, doKill, collided) ->
      collided = collided || collideRect
      doKill = doKill || false

      collidingSprites = []
      group.sprites().forEach((groupSprite) ->
        if (collided(sprite, groupSprite))
          groupSprite.kill() if (doKill)
          collidingSprites.push(groupSprite)
      )
      return collidingSprites

    ###*
    * Find all Sprites that collide between two Groups.
    *
    * @example
    * groupCollide(group1, group2).forEach(function (collision) {
    *    group1Sprite = collision.a
    *    group2Sprite = collision.b
    *    // Do processing here!
    * })
    *
    * @param {gamecs.sprite.Group} groupA First group to check
    * @param {gamecs.sprite.Group} groupB Second group to check
    * @param {Boolean} doKillA If true, kill sprites in the first group when
    * collided
    * @param {Boolean} doKillB If true, kill sprites in the second group when
    * collided
    * @param {function} collided Collision function to use, defaults to `gamecs.sprite.collideRect`
    * @returns {Array} A list of objects where properties 'a' and 'b' that
    * correspond with objects from the first and second groups
    ###
    @groupCollide: (groupA, groupB, doKillA, doKillB, collided) ->
      doKillA = doKillA || false
      doKillB = doKillB || false

      collideList = []
      collideFn = collided || collideRect
      groupA.sprites().forEach((groupSpriteA) ->
        groupB.sprites().forEach((groupSpriteB) ->
          if (collideFn(groupSpriteA, groupSpriteB))
            groupSpriteA.kill() if (doKillA)
              
            groupSpriteB.kill() if (doKillB)

            collideList.push(
              a: groupSpriteA
              b: groupSpriteB
            )
        )
      )

      return collideList

    ###*
    * Check for collisions between two sprites using their rects.
    *
    * @param {gamecs.sprite.Sprite} spriteA First sprite to check
    * @param {gamecs.sprite.Sprite} spriteB Second sprite to check
    * @returns {Boolean} True if they collide, false otherwise
    ###
    @collideRect: (spriteA, spriteB) ->
      return spriteA.rect.collideRect(spriteB.rect)

    ###*
    * Collision detection between two sprites utilizing the optional `mask`
    * attribute on the sprites. Beware: expensive operation.
    *
    * @param {gamecs.sprite.Sprite} spriteA Sprite with 'mask' property set to a `gamecs.mask.Mask`
    * @param {gamecs.sprite.Sprite} spriteB Sprite with 'mask' property set to a `gamecs.mask.Mask`
    * @returns {Boolean} True if any mask pixels collide, false otherwise
    ###
    @collideMask: (spriteA, spriteB) ->
      if (!spriteA.mask || !spriteB.mask)
        throw new Error("Both sprites must have 'mask' attribute set to an gamecs.mask.Mask")

      offset = [
        spriteB.rect.left - spriteA.rect.left
        spriteB.rect.top - spriteA.rect.top
      ]
      return spriteA.mask.overlap(spriteB.mask, offset)

    ###*
    * Collision detection between two sprites using circles at centers.
    * There sprite property `radius` is used if present, otherwise derived from bounding rect.
    * @param {gamecs.sprite.Sprite} spriteA First sprite to check
    * @param {gamecs.sprite.Sprite} spriteB Second sprite to check
    * @returns {Boolean} True if they collide, false otherwise
    ###
    @collideCircle: (spriteA, spriteB) ->
      rA = spriteA.radius || Math.max(spriteA.rect.width, spriteA.rect.height)
      rB = spriteB.radius || Math.max(spriteB.rect.width, spriteB.rect.height)
      return Vector.distance(spriteA.rect.center, spriteB.rect.center) <= rA + rB
