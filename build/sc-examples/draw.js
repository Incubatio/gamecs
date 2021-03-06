// Generated by CoffeeScript 1.4.0

/**
* @fileoverview
* Draw lines, polygons, circles, etc on the screen.
* Render text in a certain font to the screen.
*/


(function() {

  require(['gamecs', 'draw', 'font'], function(gamecs, Draw, Font) {
    var main;
    main = function() {
      var colorOne, colorThree, colorTwo, defaultFont, display, textSurface;
      display = gamecs.Display.setMode([600, 400]);
      gamecs.Display.setCaption("Example Draw");
      colorOne = '#ff0000';
      colorTwo = 'rgb(255, 50, 60)';
      colorThree = 'rgba(50, 0, 150, 0.8)';
      Draw.line(display, colorOne, [0, 0], [100, 100], 1);
      Draw.lines(display, colorOne, true, [[50, 50], [100, 50], [100, 100], [50, 100]], 4);
      Draw.polygon(display, colorTwo, [[155, 35], [210, 50], [200, 100]], 0);
      Draw.circle(display, colorThree, [150, 150], 50, 10);
      Draw.circle(display, '#ff0000', [250, 250], 50, 0);
      Draw.rect(display, '#aaaaaa', new gamecs.Rect([10, 150], [20, 20]), 2);
      Draw.rect(display, '#555555', new gamecs.Rect([50, 150], [20, 20]), 0);
      Draw.rect(display, '#aaaaaa', new gamecs.Rect([90, 150], [20, 20]), 10);
      defaultFont = new Font("20px Verdana");
      textSurface = defaultFont.render("Example Draw Test 101", "#bbbbbb");
      return display.blit(textSurface, [300, 50]);
    };
    return gamecs.ready(main);
  });

}).call(this);
