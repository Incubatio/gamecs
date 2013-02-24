/**
 * Creates a Worker which - given a starting number - will produce
 * primes coming after that number.
 *
 * This examples shows how messages are being sent from and to a worker, and that
 * the number-crunching worker does not block the browser's UI (like a normal script
 * running this long would).
 */
var start = new Date().getTime();
require(['gamejs'], function(gamejs) {
  var display = gamejs.Display.setMode([800, 600]);
  gamejs.Display.setCaption("Example Simple Worker");

  var worker = new Worker('http://incube.dev/gamejs/examples/workers/primes.js');
  var font = new gamejs.Font();
  var yOffset = 50;
  worker.onmessage = function(event) {
    display.blit(font.render('Worker answered: ' + event.data), [10, yOffset])
    yOffset += 20;
    var end = new Date().getTime();
    console.log((end - start) + 'ms');
  };
  var startNumber = parseInt(1230023 + (Math.random() * 10000));
  display.blit(font.render('Asking worker for primes after ' + startNumber), [10,30]);
  my = {
     todo: "nextprimes", start: startNumber
  }
  worker.postMessage(my);

});
