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
      while(primes.length < 5)
        n += 1
        for i in [2..Math.sqrt(n)]
          continue if (n % i == 0)
            
        if (x-- < 0)
          primes.push(n)
          self.postMessage(n)
          x = 10000

  self.postMessage(true)
