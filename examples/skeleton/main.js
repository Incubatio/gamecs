//var gamejs = require('gamejs');

// gamejs.preload([]);

require(['gamejs'], function(gamejs) {
  gamejs.ready(function() {

      var display = gamejs.Display.setMode([600, 400]);
      display.blit(
          (new gamejs.Font('30px Sans-serif')).render('Hello World')
      );

      /**
      function tick(msDuration) {
          // game loop
          return;
      };
      gamejs.time.interval(tick);
      **/
  });
});
