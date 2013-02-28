start = new Date().getTime()
require ['gamejs'], (gamejs) ->
  main = () ->
    display = gamejs.Display.setMode([800, 600])
    gamejs.Display.setCaption("Example Simple Worker")

    worker = new Worker('/gamecs/build/examples/workers/primes-require.js')
    font = new gamejs.Font()
    yOffset = 50

    # Because of race condition we first need to ensure that the worker is ready by simply receiving a message
    worker.onmessage = (event) ->
      worker.onmessage = (event) ->
        gamejs.Key.post({
          type: gamejs.Key.WORKER_RESULT,
          data: {prime: event.data}
        })

      startNumber = parseInt(1230023 + (Math.random() * 10000))
      display.blit(font.render('Asking worker for primes after ' + startNumber), [10,30])
      worker.postMessage({ todo: "nextprimes", start: startNumber })


    handleEvent = (event) ->
      if (event.type == gamejs.Key.WORKER_RESULT)
        display.blit(font.render('Worker answered: ' + event.data.prime), [10, yOffset])
        yOffset += 20
        end = new Date().getTime()
        console.log((end - start) + 'ms')

    tick = (msDuration) ->
      gamejs.Key.get().forEach(handleEvent)
    gamejs.Time.interval(tick)
  gamejs.ready(main)
