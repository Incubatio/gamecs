#gamecs = require('gamecs')

# gamecs.preload([])

require ['gamecs'], (gamecs) ->
  gamecs.ready () ->

      display = gamecs.Display.setMode([600, 400])
      display.blit((new gamecs.Font('30px Sans-serif')).render('Hello World'))

      ###*
      function tick(msDuration) {
          # game loop
          return
      }
      gamecs.time.interval(tick)
      ###
