define (require) ->
  gamecs = require('gamecs')

  class Camera
    scaleRate: 1
  
    constructor: (@size, options) ->
      options = options || {}
      @x = options.x || 0
      @y = options.y || 0
      # interval between screen, it's best if i = max(hero.width, hero.height)
      @i = options.i || 64
      @dirty = false

    isVisible: (gobject) ->
      return gobject.rect.collideRect(@getScreenRect())

    getOffset: () ->
      offset =  @getScreenRect().topleft
      return [-offset[0], -offset[1]]

    getScreenRect: () ->
      i = Math.round(@i * @scaleRate) - @i
      size = [Math.round(@size[0] / @scaleRate), Math.round(@size[1] / @scaleRate)]
      a = (n, m) => n * m - (if n > 0 then i * n else 0)

      left = a(@x, size[0])
      top = a(@y, size[1])

      return new gamecs.Rect([left, top], size)

    # TODO: follow could be call one time to be bound to some game object, and then the rest of 
    #       the code should be placed in a update method ish
    # TODO: replace sprite by a simple pos ?
    follow: (sprite) ->
      rect = sprite.rect
      screenRect = @getScreenRect()
      #console.log sprite.moveY, rect.top + rect.height, creenRect.top + screenRect.height
      x = @x
      y = @y
      switch
        when (sprite.components.Mobile.directionY < 0 && rect.top < screenRect.top) then y--
        when (sprite.components.Mobile.directionY > 0 && rect.top + rect.height > screenRect.top + screenRect.height) then y++
        when (sprite.components.Mobile.directionX < 0 && rect.left < screenRect.left) then x--
        when (sprite.components.Mobile.directionX > 0 && rect.left + rect.width > screenRect.left + screenRect.width) then x++
      if(x != @x || y != @y)
        @dirty = true
        @x = x
        @y = y

    scale: (@scaleRate) ->
