#gamecs = require('gamecs')

# gamecs.preload([])

require ['gamecs'], (gamecs) ->
  gamecs.ready () ->

      layer1 = gamecs.Display.setMode([400, 200], 'layer1')
      layer2 = gamecs.Display.setMode([400, 200], 'layer2')

      layer1.blit((new gamecs.Font('30px Sans-serif')).render('Hello World'))
      layer2.blit((new gamecs.Font('45px Sans-serif')).render('Hello World'))

      ###*
      tick = (msDuration) -> 
        # game loop
        return
      }
      gamecs.time.interval(tick)
      ###
