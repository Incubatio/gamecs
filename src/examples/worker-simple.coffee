start = new Date().getTime()

require ['gamejs'], (gamejs) ->
  display = gamejs.Display.setMode([800, 600])
  gamejs.Display.setCaption("Example Simple Worker")

  worker = new Worker('/gamecs/build/examples/workers/primes-simple.js')
  font = new gamejs.Font()
  yOffset = 50
  worker.onmessage = (event) ->
    display.blit(font.render('Worker answered: ' + event.data), [10, yOffset])
    yOffset += 20
    end = new Date().getTime()
    console.log((end - start) + 'ms')

  startNumber = parseInt(1230023 + (Math.random() * 10000))
  display.blit(font.render('Asking worker for primes after ' + startNumber), [10,30])
  worker.postMessage({ todo: "nextprimes", start: startNumber })
