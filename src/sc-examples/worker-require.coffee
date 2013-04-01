start = new Date().getTime()
require ['gamecs'], (gamecs) ->
  main = () ->
    display = gamecs.Display.setMode([400, 200])
    font = new gamecs.Font()
    gamecs.Display.setCaption("Example Worker in application context")

    worker = new Worker('build/sc-examples/workers/primes-require.js')
    yOffset = 50

    # Because of race condition we first need to ensure that the worker is ready by simply receiving a message
    worker.onmessage = (event) ->
      worker.onmessage = (event) ->
        gamecs.Input.post({
          type: gamecs.Input.WORKER_RESULT,
          data: {prime: event.data}
        })

      startNumber = parseInt(1230023 + (Math.random() * 10000))
      display.blit(font.render('Asking worker for primes after ' + startNumber), [100,30])
      worker.postMessage({ todo: "nextprimes", start: startNumber })

    worker.onerror = (event) ->
      msg = document.getElementById("message")
      msg.innerHTML += '<div class="alert"><strong>Warning</strong> This example requires http:// context (gh-pages is file://)</div>'
      error = '<strong>Error</strong> in "' + event.filename + '" at line ' + event.lineno + ': ' + event.message
      msg.innerHTML += '<div class="alert alert-error">' + error + '</div>'


    handleEvent = (event) ->
      if (event.type == gamecs.Input.WORKER_RESULT)
        display.blit(font.render('Worker answered: ' + event.data.prime), [100, yOffset])
        yOffset += 20
        end = new Date().getTime()
        console.log((end - start) + 'ms')

    tick = (msDuration) ->
      gamecs.Input.get().forEach(handleEvent)

    gamecs.Time.interval(tick)
  gamecs.ready(main)
