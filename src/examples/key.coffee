###*
* @fileoverview
* Sparkles with position and alpha are created by mouse movement.
* The sparkles position is updated in a time-dependant way. A sparkle
* is removed from the simulation once it leaves the screen.
*
* Additionally, by pressing the cursor UP key the existing sparkles will
* move upwards (movement vecor inverted).
###

require ['gamecs'], (gamecs) ->

  main = () ->

    display = gamecs.Display.setMode([850, 600])
    gamecs.Display.setCaption('example key capture')
    starImage = gamecs.Img.load('assets/images/sparkle.png')

    instructionFont = new gamecs.Font('30px monospace')
    displayRect = display.rect
    sparkles = []

    tick = (msDuration) ->

      # handle key / mouse events
      gamecs.Key.get().forEach (event) ->
        if (event.type == gamecs.Key.KEY_UP)
          if (event.key == gamecs.Key.K_UP)
            # reverse Y direction of sparkles
            sparkles.forEach (sparkle) ->
              sparkle.deltaY *= -1
        else if (event.type == gamecs.Key.MOUSE_MOTION)
           # if mouse is over display surface
           if (displayRect.collidePoint(event.pos))
             # add sparkle at mouse position
             sparkles.push {
               left: event.pos[0]
               top: event.pos[1]
               alpha: Math.random()
               deltaX: 30 - Math.random() * 60
               deltaY: 80 + Math.random() * 40
             }

      # update sparkle position & alpha
      sparkles.forEach (sparkle) ->
        # msDuration makes is frame rate independant: we don't want
        # the sparkles to move faster on a superfast computer.
        r = (msDuration/1000)
        sparkle.left += sparkle.deltaX * r
        sparkle.top += sparkle.deltaY * r

      # remove sparkles that are offscreen or invisible
      sparkles = sparkles.filter (sparkle) ->
        return sparkle.top < displayRect.height && sparkle.top > 0

      # draw sparkles
      display.fill('#000000')
      display.blit(instructionFont.render('Move mouse. Press Cursor up.', '#ffffff'), [20, 20])
      sparkles.forEach (sparkle) ->
        starImage.setAlpha(sparkle.alpha)
        display.blit(starImage, [sparkle.left, sparkle.top])

    gamecs.Time.interval(tick)

  gamecs.preload(['assets/images/sparkle.png'])
  gamecs.ready(main)
