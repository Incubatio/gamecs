###*
* @fileoverview Minimal is the smalles GameJs app I could think of, which still shows off
* most of the concepts GameJs introduces.
*
* It's a pulsating, colored circle. You can make the circle change color
* by clicking.
*
###

require ['gamecs'], (gamecs) ->

  SCREEN_WIDTH = 400
  SCREEN_HEIGHT = 400

  # ball is a colored circle.
  # ball can circle through color list.
  # ball constantly pulsates in size.
  class Ball
    @MAX_SIZE = 200
    @GROW_PER_SEC = 50
    @COLORS = ['#ff0000', '#00ff00', '#0000cc']

    constructor: (center) ->
      @center = center
      @growPerSec = Ball.GROW_PER_SEC
      @radius = @growPerSec * 2
      @color = 0
      return this


    nextColor: () ->
      @color += 1
      if (@color >= Ball.COLORS.length)
         @color = 0

    draw: (display) ->
      rgbColor = Ball.COLORS[@color]
      lineWidth = 0 # lineWidth zero fills the circle
      gamecs.Draw.circle(display, rgbColor, @center, @radius, lineWidth)
    
    update: (msDuration) ->
      @radius += @growPerSec * (msDuration / 1000)
      if (@radius > Ball.MAX_SIZE || @radius < Math.abs(@growPerSec))
        @radius = if(@radius > Ball.MAX_SIZE) then Ball.MAX_SIZE else Math.abs(@growPerSec)
        @growPerSec = -@growPerSec

  main = () ->
    # ball changes color on mouse up
    handleEvent = (event) ->
      switch(event.type)
        when gamecs.Input.T_MOUSE_UP then ball.nextColor()

    # handle events.
    # update models.
    # clear screen.
    # draw screen.
    # called ~ 30 times per second by gamecs.time.interval()
    # msDuration = actual time in milliseconds since last call
    gameTick = (msDuration) ->
      gamecs.Input.get().forEach (event) ->
        handleEvent(event)
      ball.update(msDuration)
      display.clear()
      ball.draw(display)

    # setup screen and ball.
    # ball in screen center.
    # start game loop.
    display = gamecs.Display.setMode([SCREEN_WIDTH, SCREEN_HEIGHT])
    ballCenter = [SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2]
    ball = new Ball(ballCenter)
    gamecs.Time.interval(gameTick)

  # call main after all resources have finished loading
  gamecs.ready(main)
