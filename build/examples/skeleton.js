// Generated by CoffeeScript 1.4.0
(function() {

  require(['gamecs'], function(gamecs) {
    return gamecs.ready(function() {
      var display;
      display = gamecs.Display.setMode([600, 400]);
      return display.blit((new gamecs.Font('30px Sans-serif')).render('Hello World'));
      /**
      function tick(msDuration) {
          # game loop
          return
      }
      gamecs.time.interval(tick)
      */

    });
  });

}).call(this);
