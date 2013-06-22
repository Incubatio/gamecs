define (require) ->
  Arrays  = require('utils/arrays')
  Objects = require('utils/objects')
  Vector  = require('utils/vectors')

  ###*
  * @fileoverview Provides `Sprite` the basic building block for any game and
  * `SpriteGroups`, which are an efficient
  * way for doing collision detection between groups as well as drawing layered
  * groups of objects on the screen.
  *
  ###

  class Sprite
    ###* @ignore ###
    _groups: []

    ###* @ignore ###
    _alive: true

    ###*
    * Image to be rendered for this Sprite.
    * @type gamecs.Surface
    ###
    @image = null

    ###*
    * Rect describing the position of this sprite on the display.
    * @type gamecs.Rect
    ###
    @rect = null

    ###*
    * Your visible game objects will typically subclass Sprite. By setting it's image
    * and rect attributes you can control its appeareance. Those attributes control
    * where and what `Sprite.draw(surface)` will blit on the the surface.
    *
    * Your subclass should overwrite `update(msDuration)` with its own implementation.
    * This function is called once every game tick, it is typically used to update
    * the status of that object.
    * @constructor
    ###
    constructor: () ->
      ###* List of all groups that contain this sprite.  ###
      Objects.accessor(this, 'groups', () ->
        return @_groups
      )

    ###*
    * Kill this sprite. This removes the sprite from all associated groups and
    * makes future calls to `Sprite.isDead()` return `true`
    ###
    kill: () ->
      @_alive = false
      @_groups.forEach((group) ->
        group.remove(this)
      , this)


    ###*
    * Remove the sprite from the passed groups
    * @param {Array|gamecs.sprite.Group} groups One or more `gamecs.Group`
    * instances
    ###
    remove: (groups) ->
      groups = [groups] if (!(groups instanceof Array))

      groups.forEach((group) ->
        group.remove(this)
      , this)

    ###*
    * Add the sprite to the passed groups
    * @param {Array|gamecs.sprite.Group} groups One or more `gamecs.sprite.Group`
    * instances
    ###
    add: (groups) ->
      if (!(groups instanceof Array))
        groups = [groups]

      groups.forEach((group) ->
        group.add(this)
      , this)


    ###*
    * Returns an array of all the Groups that contain this Sprite.
    * @returns {Array} an array of groups
    ###
    groups: () ->
      return @_groups.slice(0)

    ###*
    * Draw this sprite onto the given surface. The position is defined by this
    * sprite's rect.
    * @param {gamecs.Surface} surface The surface to draw on
    ###
    draw: (surface) ->
      surface.blit(@image, @rect)

    ###*
    * Update this sprite. You **should** override this method with your own to
    * update the position, status, etc.
    ###
    update: () ->

    ###*
    * @returns {Boolean} True if this sprite has had `Sprite.kill()` called on it
    * previously, otherwise false
    ###
    isDead: () ->
      return !@_alive

