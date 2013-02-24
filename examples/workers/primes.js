/**
 * This worker responds to a message `{todo: "nextprimes", start: 123}`
 *
 * and will return five primes after the `start` number. It will
 * skip 100.000 primes between each of those five.
 * (arbitrary algorithm, designed to be long running)
 */
self.onmessage = function(event) {
  if (event.data.todo === 'nextprimes') {
    var foundPrime, n, x, i, primes;
    foundPrime = false;
    n = event.data.start;
    primes = [];
    x = 10000;
    search: while(primes.length < 5) {
      n += 1;
      for (i = 2; i <= Math.sqrt(n); i += 1) {
        if (n % i == 0) {
          continue search;
        }
      }
      if (x-- < 0) {
        primes.push(n);
        self.postMessage(n);
        x = 10000;
      }
    }
  }
};
