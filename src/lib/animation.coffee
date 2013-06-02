define (require) ->
  Transform = require('transform')

  classs Animation
    constructor: (spriteSheet, animPatterns, options) ->
    options  = options || {}
    this.fps = options.fps || 6
    this.xflip = options.xflip || {}
    this.yflip = options.yflip || {}
    this.frameDuration = 1000 / this.fps
    this.patterns = animPatterns

    this.currentFrame = null
    this.currentFrameDuration = 0
    this.currentAnimation = null

    this.spriteSheet = spriteSheet
    this.finished = true
    this.image = null

  start = (animName) ->
    this.currentAnimation = animName
    this.finished = false
    this.currentFrame = this.patterns[animName][0]
    this.currentFrameDuration = 0
    this.update(0)

  update = (ms) ->
    if (!this.currentAnimation)
      throw new Error('No animation started. Start("an animation") before updating')
    xflip = false
    yflip = false

    this.currentFrameDuration += ms
    if (this.currentFrameDuration >= this.frameDuration)
      this.currentFrameDuration = 0

      # Animation pattern Params
      anim = this.patterns[this.currentAnimation]
      ### start = anim[0],
       * end       = anim[1],
       * isLooping = anim[2] ###

      # if Animation finished
      if (anim.length == 1 || this.currentFrame == anim[1])
        this.finished = true
        # looping is considered as true if null (animation loop by default)
        if (anim[2] != false) then this.currentFrame = anim[0]
      else
          if anim[0] < anim[1] then this.currentFrame++ else this.currentFrame--

    image = this.spriteSheet.get(this.currentFrame)

    # TODO: put flipped images in cache
    if(this.xflip[this.currentAnimation]) then xflip = true
    if(this.yflip[this.currentAnimation]) then yflip = true
    if(xflip || yflip) then image = gamejs.transform.flip(image, xflip, yflip)

    return image

