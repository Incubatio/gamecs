// Generated by CoffeeScript 1.4.0
(function() {
  var start;

  start = new Date().getTime();

  require(['gamecs'], function(gamecs) {
    return gamecs.ready(function() {
      var display, font, startNumber, worker, yOffset;
      display = gamecs.Display.setMode([400, 200]);
      gamecs.Display.setCaption("Example Simple Worker");
      worker = new Worker('build/sc-examples/workers/primes-simple.js');
      font = new gamecs.Font();
      yOffset = 50;
      worker.onmessage = function(event) {
        var end;
        display.blit(font.render('Worker answered: ' + event.data), [100, yOffset]);
        yOffset += 20;
        end = new Date().getTime();
        return console.log((end - start) + 'ms');
      };
      startNumber = parseInt(1230023 + (Math.random() * 10000));
      startNumber = 1236940;
      display.blit(font.render('Asking worker for primes after ' + startNumber), [100, 30]);
      return worker.postMessage({
        todo: "nextprimes",
        start: startNumber
      });
    });
  });

}).call(this);