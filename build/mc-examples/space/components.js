// Generated by CoffeeScript 1.4.0
(function() {

  define(function(require) {
    var Objects, components;
    Objects = require('utils/objects');
    components = {
      Visible: (function() {

        function _Class() {}

        _Class.prototype.image_urn = null;

        _Class.prototype.image = null;

        _Class.prototype.originalImage = null;

        _Class.prototype.mask = null;

        _Class.prototype.color = "#f00";

        _Class.prototype.setImage = function(image) {
          this.dirty = true;
          return this.image = image;
        };

        _Class.prototype.size = null;

        _Class.prototype.radius = null;

        _Class.prototype.shape = null;

        return _Class;

      })(),
      Communicable: (function() {

        function _Class() {}

        _Class.prototype.avatar = "question.png";

        _Class.prototype.dialogs = null;

        return _Class;

      })(),
      Mobile: (function() {

        _Class.prototype.speed = null;

        _Class.prototype.move = null;

        function _Class() {
          this.speed = [0, 0, 0];
          this.move = [0, 0, 0];
        }

        return _Class;

      })(),
      Rotative: (function() {

        function _Class() {}

        _Class.prototype.rotationSpeed = 10;

        _Class.prototype.rotation = 0;

        return _Class;

      })(),
      Flipable: (function() {

        function _Class() {}

        _Class.prototype.vertical = null;

        _Class.prototype.horizontal = null;

        return _Class;

      })(),
      Movable: (function() {

        function _Class() {}

        return _Class;

      })(),
      Destructible: (function() {

        function _Class() {}

        return _Class;

      })(),
      Animated: (function() {

        function _Class() {}

        _Class.prototype.imageset = null;

        _Class.prototype.frameset = null;

        _Class.prototype.animation = null;

        _Class.prototype.entitySheet = null;

        _Class.prototype.options = null;

        return _Class;

      })(),
      Inteligent: (function() {

        function _Class() {}

        _Class.prototype.pathfinding = 'straight';

        _Class.prototype.detectionRadius = 0;

        return _Class;

      })(),
      Weaponized: (function() {

        function _Class() {}

        _Class.prototype.behavior = 'offensive';

        _Class.prototype.alorithm = 'kamikaze';

        _Class.prototype.attacking = null;

        _Class.prototype.weapon = 'sword';

        return _Class;

      })(),
      Triggerable: (function() {

        function _Class() {}

        _Class.prototype.triggered = null;

        return _Class;

      })(),
      Collidable: (function() {

        function _Class() {}

        _Class.prototype.shape = null;

        return _Class;

      })(),
      Jumpable: (function() {

        function _Class() {}

        _Class.prototype.startedAt = null;

        _Class.prototype.canJump = true;

        return _Class;

      })()
    };
    Objects.accessors(components.Mobile.prototype, {
      moveX: {
        get: function() {
          return this.move[0];
        },
        set: function(move) {
          return this.move[0] = move;
        }
      },
      moveY: {
        get: function() {
          return this.move[1];
        },
        set: function(move) {
          return this.move[1] = move;
        }
      },
      moveZ: {
        get: function() {
          return this.move[2];
        },
        set: function(move) {
          return this.move[2] = move;
        }
      },
      speedX: {
        get: function() {
          return this.speed[0];
        },
        set: function(speed) {
          return this.speed[0] = speed;
        }
      },
      speedY: {
        get: function() {
          return this.speed[1];
        },
        set: function(speed) {
          return this.speed[1] = speed;
        }
      },
      speedZ: {
        get: function() {
          return this.speed[2];
        },
        set: function(speed) {
          return this.speed[2] = speed;
        }
      }
    });
    return components;
  });

}).call(this);
