#gamejs = require('gamejs')

# gamejs.preload([])

require ['gamejs'], (gamejs) ->
  gamejs.ready () ->

      display = gamejs.Display.setMode([600, 400])
      display.blit((new gamejs.Font('30px Sans-serif')).render('Hello World'))

      ###*
      function tick(msDuration) {
          # game loop
          return
      }
      gamejs.time.interval(tick)
      ###
