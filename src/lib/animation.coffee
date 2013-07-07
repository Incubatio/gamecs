define (require) ->
  "use strict"
  Transform = require('transform')

  class Animation
    constructor: (@spriteSheet, @patterns, options) ->
      options  = options || {}
      @fps = options.fps || 20
      @xflip = options.xflip || {}
      @yflip = options.yflip || {}
      @frameDuration = 1000 / @fps

      @currentFrame = null
      @currentFrameDuration = 0
      @currentAnimation = null
      #@nextAnimation = null

      #@image = null
      @image = @spriteSheet.get(0)
      @running = false


    open: (@currentAnimation) ->

    start: (animName) ->
      @open(animName)
      @reset(true)
      @

    reset: (@running = false) ->
      if @patterns[@currentAnimation]
        @currentFrame = @patterns[@currentAnimation][0]
        @currentFrameDuration = 0
        @_update(0)
      @

    pause: () ->
      @running = false
      @

    play: () ->
      @running = true
      @

    ###
    backward: (x) ->
      @currentFrame -= x
      @

    forward: (x) ->
      @currentFrame += x
      @
    ###


    update: (ms = 30) ->
      if @running then @_update(ms)
      return @image
          
      #if @nextAnimation
      #  entity.animation.start(entity.animation.nextAnimation)
      #  entity.image = entity.animation.update(0)
      #if entity.animation.nextAnimation == false
      #  entity.animation.start(entity.animation.currentAnimation)
      
      #else if entity.animation.currentAnimation then entity.image = entity.animation.update(30)

    _update: (ms) ->
      if (!@currentAnimation)
        throw new Error('No animation started. open("an animation") or start("an animation") before updating')
      xflip = false
      yflip = false

      @currentFrameDuration += ms
      if (@currentFrameDuration >= @frameDuration)
        @currentFrameDuration = 0

        # Animation pattern Params
        anim = @patterns[@currentAnimation]
        ### start = anim[0],
         * end       = anim[1],
         * isLooping = anim[2] ###

        # if Animation finished
        if (anim.length == 1 || @currentFrame == anim[1])
          # looping is considered as true if null (animation loops by default)
          if (anim[2] != false) then @currentFrame = anim[0]
        else
          if anim[0] < anim[1] then @currentFrame++ else @currentFrame--

      image = @spriteSheet.get(@currentFrame)

      # TODO: put flipped images in cache
      if(@xflip[@currentAnimation]) then xflip = true
      if(@yflip[@currentAnimation]) then yflip = true
      if(xflip || yflip) then image = Transform.flip(image, xflip, yflip)
      @image = image
