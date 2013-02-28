start = new Date().getTime()

require ['gamecs'], (gamecs) ->
  display = gamecs.Display.setMode([800, 600])
  gamecs.Display.setCaption("Example Simple Worker")

  worker = new Worker('build/examples/workers/primes-simple.js')
  font = new gamecs.Font()
  yOffset = 50
  worker.onmessage = (event) ->
    display.blit(font.render('Worker answered: ' + event.data), [10, yOffset])
    yOffset += 20
    end = new Date().getTime()
    console.log((end - start) + 'ms')

  startNumber = parseInt(1230023 + (Math.random() * 10000))
  startNumber = 1236940
  display.blit(font.render('Asking worker for primes after ' + startNumber), [10,30])
  worker.postMessage({ todo: "nextprimes", start: startNumber })
