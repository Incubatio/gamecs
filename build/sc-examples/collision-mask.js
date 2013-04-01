// Generated by CoffeeScript 1.4.0

/**
* @fileoverview
* Demonstrates pixel perfect collision detection utilizing image masks.
*
* A 'spear' is moved around with mouse or cursors keys - the text 'COLLISION'
* appears if the spear pixel collides with the unit.
*
* gamecs.mask.fromSurface is used to create two pixel masks
* that do the actual collision detection.
*/


(function() {

  require(['gamecs', 'mask', 'utils/vectors'], function(gamecs, mask, $v) {
    var images, imgPath, main;
    main = function() {
      var display, font, mSpear, mUnit, spear, spearPosition, tick, unit, unitPosition;
      display = gamecs.Display.setMode([500, 350]);
      spear = gamecs.Img.load(imgPath + 'spear.png');
      unit = gamecs.Img.load(imgPath + 'unit.png');
      mUnit = mask.fromSurface(unit);
      mSpear = mask.fromSurface(spear);
      unitPosition = [20, 20];
      spearPosition = [6, 0];
      font = new gamecs.Font('20px monospace');
      /** tick
      */

      tick = function() {
        var hasMaskOverlap, relativeOffset;
        gamecs.Input.get().forEach(function(event) {
          var delta, direction;
          direction = {};
          direction[gamecs.Input.K_UP] = [0, -1];
          direction[gamecs.Input.K_DOWN] = [0, 1];
          direction[gamecs.Input.K_LEFT] = [-1, 0];
          direction[gamecs.Input.K_RIGHT] = [1, 0];
          if (event.type === gamecs.Input.T_KEY_DOWN) {
            delta = direction[event.key];
            if (delta) {
              return spearPosition = $v.add(spearPosition, delta);
            }
          } else if (event.type === gamecs.Input.T_MOUSE_MOTION) {
            if (display.rect.collidePoint(event.pos)) {
              return spearPosition = $v.subtract(event.pos, spear.getSize());
            }
          }
        });
        display.clear();
        display.blit(unit, unitPosition);
        display.blit(spear, spearPosition);
        relativeOffset = $v.subtract(spearPosition, unitPosition);
        hasMaskOverlap = mUnit.overlap(mSpear, relativeOffset);
        if (hasMaskOverlap) {
          display.blit(font.render('COLLISION', '#ff0000'), [250, 50]);
        }
        return display.blit(font.render('Move with mouse or cursor keys.'), [10, 250]);
      };
      return gamecs.Time.interval(tick);
    };
    imgPath = 'assets/images/';
    images = ['spear.png', 'unit.png'].map(function(img) {
      return imgPath + img;
    });
    gamecs.preload(images);
    return gamecs.ready(main);
  });

}).call(this);