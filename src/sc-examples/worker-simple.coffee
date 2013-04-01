start = new Date().getTime()

require ['gamecs'], (gamecs) ->

  gamecs.ready () ->
    display = gamecs.Display.setMode([400, 200])
    gamecs.Display.setCaption("Example Simple Worker")

    worker = new Worker('build/sc-examples/workers/primes-simple.js')
    font = new gamecs.Font()
    yOffset = 50
    worker.onmessage = (event) ->
      display.blit(font.render('Worker answered: ' + event.data), [100, yOffset])
      yOffset += 20
      end = new Date().getTime()
      console.log((end - start) + 'ms')

    startNumber = parseInt(1230023 + (Math.random() * 10000))
    startNumber = 1236940
    display.blit(font.render('Asking worker for primes after ' + startNumber), [100,30])
    worker.postMessage({ todo: "nextprimes", start: startNumber })
