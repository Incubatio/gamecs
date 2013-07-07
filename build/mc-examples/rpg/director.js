// Generated by CoffeeScript 1.4.0
(function() {

  define(function(require) {
    var Animation, Camera, Director, Entity, SpriteSheet, components, gamecs, systems;
    gamecs = require('gamecs');
    Entity = require('entity');
    Animation = require('animation');
    components = require('components');
    systems = require('systems');
    SpriteSheet = require('spritesheet');
    Camera = require('camera');
    return Director = (function() {

      Director.prototype.loadImage = function(suffix) {
        return gamecs.Img.load(this.options.data.prefixs.image + suffix);
      };

      function Director(display, options) {
        var k, v, _ref;
        this.display = display;
        this.options = options;
        this.font = new gamecs.Font('40px monospace');
        this.camera = new Camera(this.options.data.screen.size);
        _ref = this.options.data.sprites;
        for (k in _ref) {
          v = _ref[k];
          if (v.Visible && v.Visible.image) {
            v.Visible.image_urn = v.Visible.image;
            v.Visible.image = this.loadImage(v.Visible.image_urn);
            v.Visible.size = v.Visible.image.getSize();
          }
          if (v.Animated && v.Animated.imageset) {
            v.Animated.entitySheet = new SpriteSheet();
            v.Animated.entitySheet.load(this.loadImage(v.Animated.imageset), v.Visible.size);
          }
        }
        this.init();
      }

      Director.prototype.handleInput = function(events) {
        var animation, component, event, x, y, _i, _len, _results;
        component = this.player.components.Mobile;
        if (!this.isGameOver) {
          _results = [];
          for (_i = 0, _len = events.length; _i < _len; _i++) {
            event = events[_i];
            x = component.moveX;
            y = component.moveY;
            if (event.type === gamecs.Input.T_KEY_DOWN) {
              switch (event.key) {
                case gamecs.Input.K_UP:
                case gamecs.Input.K_w:
                  y = -1;
                  break;
                case gamecs.Input.K_DOWN:
                case gamecs.Input.K_s:
                  y = 1;
                  break;
                case gamecs.Input.K_LEFT:
                case gamecs.Input.K_a:
                  x = -1;
                  break;
                case gamecs.Input.K_RIGHT:
                case gamecs.Input.K_d:
                  x = 1;
                  break;
                case gamecs.Input.K_SPACE:
                  this.player.firing = true;
                  break;
                case gamecs.Input.K_t:
                  this.test();
              }
            } else if (event.type === gamecs.Input.T_KEY_UP) {
              switch (event.key) {
                case gamecs.Input.K_UP:
                case gamecs.Input.K_w:
                  if (y < 0) {
                    y = 0;
                  }
                  break;
                case gamecs.Input.K_DOWN:
                case gamecs.Input.K_s:
                  if (y > 0) {
                    y = 0;
                  }
                  break;
                case gamecs.Input.K_LEFT:
                case gamecs.Input.K_a:
                  if (x < 0) {
                    x = 0;
                  }
                  break;
                case gamecs.Input.K_RIGHT:
                case gamecs.Input.K_d:
                  if (x > 0) {
                    x = 0;
                  }
                  break;
                case gamecs.Input.K_SPACE:
                  this.player.firing = false;
              }
            }
            component.moveX = x;
            component.moveY = y;
            animation = (function() {
              switch (false) {
                case !(x < 0):
                  return "left";
                case !(x > 0):
                  return "right";
                case !(y < 0):
                  return "up";
                case !(y > 0):
                  return "down";
                default:
                  this.player.animation.reset();
                  return false;
              }
            }).call(this);
            if (animation && !(animation === this.player.animation.currentAnimation && this.player.animation.running)) {
              _results.push(this.player.animation.start(animation));
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        }
      };

      Director.prototype.handleAI = function() {};

      Director.prototype.setOffset = function(system) {
        var offset;
        this.camera.follow(this.groups.sprites[0]);
        if (this.camera.dirty) {
          offset = this.camera.getOffset();
          this.init();
          system.offset = offset;
          return this.camera.dirty = false;
        }
      };

      Director.prototype.init = function() {
        var entity, i, image, k, offset, pos, rect, size, v, _i, _len, _ref, _ref1, _ref2, _results;
        this.display.bg.clear();
        this.display.fg.clear();
        offset = this.camera.getOffset();
        this.display.bg.blit(this.options.map.layers.collision.image, offset);
        rect = new gamecs.Rect([0, 0]);
        _ref = this.options.data.scene.decors;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          v = _ref[_i];
          image = (function() {
            switch (v[0]) {
              case 'text':
                return this.font.render(v[1]);
              case 'image':
                return this.loadImage(v[1]);
            }
          }).call(this);
          size = image.getSize();
          rect.init(v[2][0], v[2][1], size[0], size[1]);
          if (this.camera.isVisible({
            rect: rect
          })) {
            this.display.bg.blit(image, rect.move(offset));
          }
        }
        this.groups = {
          sprites: []
        };
        if (this.player) {
          this.groups.sprites.push(this.player);
        }
        _ref1 = this.options.data.scene.actors;
        _results = [];
        for (i in _ref1) {
          _ref2 = _ref1[i], k = _ref2[0], pos = _ref2[1];
          v = this.options.data.sprites[k];
          rect.init(pos[0], pos[1], v.Visible.size[0], v.Visible.size[1]);
          if (this.camera.isVisible({
            rect: rect
          })) {
            entity = new Entity(pos, v, {
              name: k,
              rect: new gamecs.Rect(pos, v.Visible.size),
              dirty: true
            });
            entity.oldRect = entity.rect.clone();
            if (entity.components.Visible) {
              entity.image = entity.components.Visible.image;
            }
            if (v.Animated && v.Animated.imageset) {
              entity.animation = new Animation(v.Animated.entitySheet, v.Animated.frameset, v.Animated.options);
              if (v.Animated.options && v.Animated.options.start) {
                entity.animation.start(v.Animated.options.start);
              }
            }
            this.groups.sprites.push(entity);
            if (entity.name === "Player") {
              this.player = entity;
              _results.push(delete this.options.data.scene.actors[i]);
            } else {
              _results.push(void 0);
            }
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      };

      Director.prototype.test = function() {
        var entity, _i, _len, _ref, _results;
        console.log('test');
        _ref = this.groups.sprites;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          entity = _ref[_i];
          if (entity.components.Visible) {
            _results.push(console.log(entity));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      };

      return Director;

    })();
  });

}).call(this);
