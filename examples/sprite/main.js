/**
 * A bare bones Sprite and sprite Group example.
 *
 * We move a lot of Ship sprites across the screen with varying speed. The sprites
 * rotate themselves randomly. The sprites bounce back from the bottom of the
 * screen.
 */

//var gamejs = require('gamejs');
require(['gamejs', 'utils/objects'], function(gamejs, Objects) {

  /**
   * The ship Sprite has a randomly rotated image und moves with random speed (upwards).
   */
  var Ship = function(rect) {
     // call superconstructor
     Ship.superConstructor.apply(this, arguments);
     this.speed = 20 + (40 * Math.random());
     // ever ship has its own scale
     this.originalImage = gamejs.Img.load("sprite/images/ship.png");
     var dims = this.originalImage.getSize();
     this.originalImage = gamejs.Transform.scale(
                                  this.originalImage,
                                  [dims[0] * (0.5 + Math.random()), dims[1] *  (0.5 + Math.random())]
                          );
     this.rotation = 50 + parseInt(120*Math.random());
     this.image = gamejs.Transform.rotate(this.originalImage, this.rotation);
     this.rect = new gamejs.Rect(rect);
     return this;
  };
  // inherit (actually: set prototype)
  Objects.extend(Ship, gamejs.Sprite);
  Ship.prototype.update = function(msDuration) {
     // moveIp = move in place
     this.rect.moveIp(0, this.speed * (msDuration/1000));
     if (this.rect.top > 600) {
        this.speed *= -1;
        this.image = gamejs.Transform.rotate(this.originalImage, this.rotation + 180);
     } else if (this.rect.top < 0 ) {
        this.speed *= -1;
        this.image = gamejs.Transform.rotate(this.originalImage, this.rotation);
     }
  };

  function main() {
     // screen setup
     gamejs.Display.setMode([800, 600]);
     gamejs.Display.setCaption("Example Sprites");
     // create some ship sprites and put them in a group
     var ship = new Ship([100, 100]);
     var gShips = new gamejs.Group();
     for (var j=0;j<4;j++) {
        for (var i=0; i<25; i++) {
           gShips.add(new Ship([10 + i*20, j * 20]));
        }
     }
     // game loop
     var mainSurface = gamejs.Display.getSurface();
     // msDuration = time since last tick() call
     var tick = function(msDuration) {
           mainSurface.fill("#FFFFFF");
           // update and draw the ships
           gShips.update(msDuration);
           gShips.draw(mainSurface);
     };
     gamejs.Time.interval(tick);
  }

  /**
   * M A I N
   */
  gamejs.preload(['sprite/images/ship.png']);
  gamejs.ready(main);
});
