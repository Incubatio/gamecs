// Generated by CoffeeScript 1.4.0
(function() {

  require(['gamecs'], function(gamecs) {
    return gamecs.ready(function() {
      var layer1, layer2;
      layer1 = gamecs.Display.setMode([400, 200], 'layer1');
      layer2 = gamecs.Display.setMode([400, 200], 'layer2');
      layer1.blit((new gamecs.Font('30px Sans-serif')).render('Hello World'));
      return layer2.blit((new gamecs.Font('45px Sans-serif')).render('Hello World'));
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