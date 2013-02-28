###*
* @fileoverview Minimal is the smalles GameJs app I could think of, which still shows off
* most of the concepts GameJs introduces.
*
* It's a pulsating, colored circle. You can make the circle change color
* by clicking.
*
###

require ['gamejs'], (gamejs) ->

  SCREEN_WIDTH = 400
  SCREEN_HEIGHT = 400

  # ball is a colored circle.
  # ball can circle through color list.
  # ball constantly pulsates in size.
  class Ball
    Ball.MAX_SIZE = 200
    Ball.GROW_PER_SEC = 50
    Ball.COLORS = ['#ff0000', '#00ff00', '#0000cc']

    constructor: (center) ->
      this.center = center
      this.growPerSec = Ball.GROW_PER_SEC
      this.radius = this.growPerSec * 2
      this.color = 0
      return this


    Ball.prototype.nextColor = () ->
      this.color += 1
      if (this.color >= Ball.COLORS.length)
         this.color = 0
    Ball.prototype.draw = (display) ->
      rgbColor = Ball.COLORS[this.color]
      lineWidth = 0 # lineWidth zero fills the circle
      gamejs.Draw.circle(display, rgbColor, this.center, this.radius, lineWidth)
    
    Ball.prototype.update = (msDuration) ->
      this.radius += this.growPerSec * (msDuration / 1000)
      if (this.radius > Ball.MAX_SIZE || this.radius < Math.abs(this.growPerSec))
        this.radius = if(this.radius > Ball.MAX_SIZE) then Ball.MAX_SIZE else Math.abs(this.growPerSec)
        this.growPerSec = -this.growPerSec

  main = () ->
    # ball changes color on mouse up
    handleEvent = (event) ->
      switch(event.type)
        when gamejs.Key.MOUSE_UP then ball.nextColor()

    # handle events.
    # update models.
    # clear screen.
    # draw screen.
    # called ~ 30 times per second by gamejs.time.interval()
    # msDuration = actual time in milliseconds since last call
    gameTick = (msDuration) ->
      gamejs.Key.get().forEach (event) ->
        handleEvent(event)
      ball.update(msDuration)
      display.clear()
      ball.draw(display)

    # setup screen and ball.
    # ball in screen center.
    # start game loop.
    display = gamejs.Display.setMode([SCREEN_WIDTH, SCREEN_HEIGHT])
    ballCenter = [SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2]
    ball = new Ball(ballCenter)
    gamejs.Time.interval(gameTick)

  # call main after all resources have finished loading
  gamejs.ready(main)
