// Generated by CoffeeScript 1.4.0
(function() {

  importScripts('/gamecs/assets/js/require.js');

  importScripts('/gamecs/assets/js/gamecs.min.js');

  requirejs.config({
    baseUrl: '/gamecs/build/lib/'
  });

  require(['rect'], function(Rect) {
    self.onmessage = function(event) {
      var foundPrime, i, n, primes, x;
      if (event.data.todo === 'nextprimes') {
        foundPrime = false;
        n = event.data.start;
        primes = [];
        x = 10000;
        return {
          search: (function() {
            var _i, _ref, _results;
            _results = [];
            while (primes.length < 5) {
              n += 1;
              for (i = _i = 2, _ref = Math.sqrt(n); 2 <= _ref ? _i <= _ref : _i >= _ref; i = 2 <= _ref ? ++_i : --_i) {
                if (n % i === 0) {
                  continue;
                }
              }
              if (x-- < 0) {
                primes.push(n);
                self.postMessage(n);
                _results.push(x = 10000);
              } else {
                _results.push(void 0);
              }
            }
            return _results;
          })()
        };
      }
    };
    return self.postMessage(true);
  });

}).call(this);
