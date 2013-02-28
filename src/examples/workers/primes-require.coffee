importScripts('/gamecs/assets/js/require.js')
importScripts('/gamecs/assets/js/gamecs.min.js')
requirejs.config({baseUrl: '/gamecs/build/lib/'})

require ['rect'], (Rect) ->
  self.onmessage = (event) ->
    if (event.data.todo == 'nextprimes')
      foundPrime = false
      n = event.data.start
      primes = []
      x = 10000
      doContinue = false
      while(primes.length < 5)
        n++
        doContinue = false
        sqrtn = Math.sqrt(n)
        for i in [2..sqrtn]
          if (n % i == 0)
            doContinue = true
            break
            
        if (!doContinue && x-- < 0)
          primes.push(n)
          x = 10000
          self.postMessage(n)

  self.postMessage(true)
