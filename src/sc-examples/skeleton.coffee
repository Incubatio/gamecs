#gamecs = require('gamecs')

# gamecs.preload([])

require ['gamecs'], (gamecs) ->
  gamecs.ready () ->

      display = gamecs.Display.setMode([400, 200])
      display.blit((new gamecs.Font('30px Sans-serif')).render('Hello World'))

      ###*
      tick = (msDuration) ->
        # game loop
        return
      gamecs.time.interval(tick)
      ###
