// Generated by CoffeeScript 1.4.0
(function() {

  define(function(require) {
    var Camera, Director, Entity, SpriteSheet, components, gamecs, systems;
    gamecs = require('gamecs');
    Entity = require('entity');
    components = require('components');
    systems = require('systems');
    SpriteSheet = require('spritesheet');
    Camera = (function() {

      function Camera(surface, options) {
        options = options || {};
        this.x = options.x || 0;
        this.y = options.y || 0;
        this.i = options.i || 64;
        this.dirty = false;
        this.surface = surface;
      }

      Camera.prototype.isVisible = function(gobject) {
        return gobject.rect.collideRect(this.getScreenRect());
      };

      Camera.prototype.getOffset = function() {
        var offset;
        offset = this.getScreenRect().topleft;
        return [-offset[0], -offset[1]];
      };

      Camera.prototype.getScreenRect = function() {
        var a, i, left, size, top;
        size = this.surface.getSize();
        i = this.i;
        a = function(n, m) {
          var _ref;
          return n * m - ((_ref = n > 0) != null ? _ref : i * {
            n: 0
          });
        };
        left = a(this.x, size[0]);
        top = a(this.y, size[1]);
        return new gamecs.Rect([left, top], size);
      };

      Camera.prototype.follow = function(sprite) {
        var rect, screenRect, surface, x, y;
        surface = this.surface;
        rect = sprite.rect;
        screenRect = this.getScreenRect();
        x = this.x;
        y = this.y;
        switch (false) {
          case !(sprite.moveY < 0 && rect.top < screenRect.top):
            y--;
            break;
          case !(sprite.moveY > 0 && rect.top + rect.height > screenRect.top + screenRect.height):
            y++;
            break;
          case !(sprite.moveX < 0 && rect.left < screenRect.left):
            x--;
            break;
          case !(sprite.moveX > 0 && rect.left + rect.width > screenRect.left + screenRect.width):
            x++;
        }
        if (x !== this.x || y !== this.y) {
          this.dirty = true;
          this.x = x;
          return this.y = y;
        }
      };

      return Camera;

    })();
    return Director = (function() {

      Director.prototype.loadImage = function(suffix) {
        return gamecs.Img.load(this.data.prefixs.image + suffix);
      };

      function Director(display, data) {
        var entity, k, pos, v, _i, _len, _ref, _ref1, _ref2;
        this.display = display;
        this.data = data;
        this.MENU = 1;
        this.LOADING = 2;
        this.RUNNING = 3;
        this.PAUSE = 4;
        this.CONSOLE = 5;
        this.font = new gamecs.Font('20px monospace');
        this.display.fg.blit((new gamecs.Font('45px Sans-serif')).render('Hello World'));
        this.display.bg.blit(this.loadImage('stargate.png'), [250, 1]);
        _ref = this.data.sprites;
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
        this.groups = {
          sprites: []
        };
        _ref1 = this.data.scene.actors;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          _ref2 = _ref1[_i], k = _ref2[0], pos = _ref2[1];
          v = this.data.sprites[k];
          entity = new Entity(pos, v, {
            name: k,
            rect: new gamecs.Rect(pos, v.Visible.size),
            dirty: true
          });
          entity.oldRect = entity.rect.clone();
          if (entity.components.Visible) {
            entity.image = entity.components.Visible.image;
          }
          this.groups.sprites.push(entity);
          if (entity.name === "Player") {
            this.player = entity;
          }
        }
        this.player.score = 0;
      }

      Director.prototype.handleInput = function(events) {
        var component, event, x, y, _i, _len, _results;
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
            _results.push(component.moveY = y);
          }
          return _results;
        }
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

      Director.prototype.setScene = function(myScene, dirty) {
        var loadScene, test2, _act, _dialog, _ref;
        this.scene = myScene;
        this.camera.dirty = (_ref = dirty !== false) != null ? _ref : {
          "true": false
        };
        ({
          menu: function() {
            return this.status = this.MENU;
          },
          win: function() {},
          loose: function() {},
          start: function(myScene) {
            this.status = this.RUNNING;
            return this.setScene(myScene);
          },
          loading: function() {
            var image, pos, size, sprite;
            this.status = this.LOADING;
            myScene = {
              sprites: {},
              spriteGroup: new gamecs.sprite.Group()
            };
            size = this.surface.getSize();
            image = this.loadImage('loading.png');
            sprite = components.create('Visible', 'Rotative');
            pos = [size[0] / 2 - 40, size[1] / 2 - 40];
            size = image.getSize();
            sprite.rect = new gamecs.Rect(pos, size);
            sprite.originalImage = image;
            myScene.spriteGroup.add(sprite);
            myScene.sprites['loading'] = sprite;
            return this.setScene(myScene, true);
          },
          everyoneIsDirty: function() {
            var k, sprite, _ref1, _results;
            _ref1 = this.scene.sprites;
            _results = [];
            for (k in _ref1) {
              sprite = _ref1[k];
              sprite.oldImage = false;
              _results.push(sprite.dirty = true);
            }
            return _results;
          },
          test: function() {
            console.log('test', this.status);
            if (this.status === "running") {
              this.pauseScene = this.scene;
              return this.loading();
            } else {
              if (this.status === "loading") {
                this.start(this.pauseScene);
                return this.everyoneIsDirty();
              }
            }
          }
        });
        test2 = function() {
          var $v, image, player;
          if (!this.emitter) {
            $v = require('utils/vectors');
            player = this.scene.sprites.Player;
            this.emitter = new particles.Emitter({
              delay: 50,
              numParticles: 100,
              pos: player.rect.center,
              modifierFunc: particles.Modifiers.explosion(4, 2, "rgba(255,0,0,0.6)")
            });
            this.emitter.start();
            image = gamecs.transform.scale(player.image, $v.multiply(player.image.getSize(), 1));
            return this.dismantle = new Dismantle(image, {
              pos: player.rect.topleft
            });
          }
        };
        ({
          testUpdate: function() {
            var ms;
            return ms = 10;
          }
        });
        if (this.emitter && this.emitter.isRunning()) {
          this.dismantle.age += ms;
          if (this.dismantle.age >= this.dismantle.lifetime) {
            this.emitter.stop();
            this.emitter = null;
          } else {
            this.emitter.update(ms);
            this.dismantle.update(ms);
          }
        }
        ({
          testDraw: function() {
            var player;
            if (this.emitter && this.emitter.isRunning()) {
              player = this.scene.sprites.Player;
              this.emitter.draw(this.surface);
              return this.dismantle.draw(this.surface);
            } else if (this.emitter) {
              return this.emitter = false;
            }
          },
          loadImage: function(image) {
            return gamecs.image.load(this.prefixs.image + image);
          }
          /*
                * @arg string param || array params
          */

        });
        loadScene = function(name, myCallback) {
          this.loading();
          return this.sceneLoader.get(name);
        };
        ({
          readScript: function(scriptName, scene) {
            scene = scene || this.scene;
            if (scene.scripts && scene.scripts[scriptName]) {
              return this.instructions = this.sceneReader.parse(scene.scripts[scriptName]);
            }
          }
        });
        _act = function(params) {
          var func;
          console.log("call:" + params);
          func = params.shift();
          if (this[func](this[func].apply(this, params))) {

          } else {
            throw new SyntaxError("try to call " + func + "(), which is not accessible or does not exists");
          }
        };
        ({
          act: function() {
            if (this.instructions.length > 0) {
              return this._act(this.instructions.shift());
            }
          },
          update: function() {
            var k, sprite, system, _i, _len, _ref1, _ref2;
            _ref1 = this.scene.sprites;
            for (k in _ref1) {
              sprite = _ref1[k];
              _ref2 = this.systems;
              for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
                system = _ref2[_i];
                system.update(sprite, 30, this);
              }
            }
            this.testUpdate();
            if (this.scene.sprites.Player) {
              this.camera.follow(this.scene.sprites.Player);
            }
            if (this.camera.dirty) {
              return this.everyoneIsDirty();
            }
          },
          draw: function() {
            var k, sprite, _ref1, _results;
            this.camera.dirty = true;
            if (this.camera.dirty) {
              this.systems.Rendering.drawBackground(this);
            }
            _ref1 = this.scene.sprites;
            _results = [];
            for (k in _ref1) {
              sprite = _ref1[k];
              sprite.dirty = true;
              if (!this.dark && sprite.rect.left > 0 && sprite.rect.top > 0) {
                _results.push(this.systems.Rendering.draw(sprite, this.surface, this.camera));
              } else {
                _results.push(void 0);
              }
            }
            return _results;
          },
          handleInput: function(event) {
            var player;
            if (this.status === this.RUNNING && this.scene.sprites.Player) {
              player = this.scene.sprites.Player;
              if (event.type === gamecs.event.KEY_DOWN) {
                switch (event.key) {
                  case gamecs.event.K_w:
                  case gamecs.event.K_UP:
                    player.moveY = -1;
                    break;
                  case gamecs.event.K_s:
                  case gamecs.event.K_DOWN:
                    player.moveY = 1;
                    break;
                  case gamecs.event.K_a:
                  case gamecs.event.K_LEFT:
                    player.moveX = -1;
                    break;
                  case gamecs.event.K_d:
                  case gamecs.event.K_RIGHT:
                    player.moveX = 1;
                }
                if (event.key === gamecs.event.K_e) {
                  this.scene.sprites.Player.attacking = true;
                }
              }
              if (event.type === gamecs.event.KEY_UP) {
                switch (event.key) {
                  case gamecs.event.K_w:
                  case gamecs.event.K_UP:
                    if (player.moveY < 0) {
                      return player.moveY = 0;
                    }
                    break;
                  case gamecs.event.K_s:
                  case gamecs.event.K_DOWN:
                    if (player.moveY > 0) {
                      return player.moveY = 0;
                    }
                    break;
                  case gamecs.event.K_a:
                  case gamecs.event.K_LEFT:
                    if (player.moveX < 0) {
                      return player.moveX = 0;
                    }
                    break;
                  case gamecs.event.K_d:
                  case gamecs.event.K_RIGHT:
                    if (player.moveX > 0) {
                      return player.moveX = 0;
                    }
                }
              }
            }
          },
          finish: function() {
            this.status = this.LOADING;
            console.log("Kikoo");
            myScene = {
              sprites: {},
              bgImage: this.loadImage("finish.png"),
              spriteGroup: {}
            };
            this.setScene(myScene, false);
            return this.surface.blit(myScene.bgImage, new gamecs.Rect([0, 0], this.surface.getSize()));
          }
          /*
                * Function below are accesible from scene scripts, 
                * TODO: for better encapsulation, put them into a new namespace, e.g: Director.prototype.scriptMethods
          */

        });
        _dialog = function(actor, msg, buttons) {
          var pos, rect, size;
          console.log('test', actor, msg);
          size = this.surface.getSize();
          pos = [0, size[1] - 200];
          rect = new gamecs.Rect(pos, [size[1], 200]);
          this.surface.fill('#00f', rect);
          return this.surface.blit(this.font.render("LoadinG ..."), pos);
        };
        return {
          dialog: function(actor, msg) {
            var div, self;
            this._dialog(actor, msg, {});
            self = this;
            div = $(".ui-dialog");
            return div.keydown(function(event) {
              if (!event.isDefaultPrevented() && event.keyCode && event.keyCode === $.ui.keyCode.SPACE) {
                self.busy = false;
                div.unbind(event);
                return event.preventDefault();
              }
            });
          },
          ask: function(label, questions) {
            var buttons, k, self, v;
            buttons = [];
            self = this;
            for (k in questions) {
              v = questions[k];
              buttons.push({
                text: v,
                click: function() {
                  self[label] = k;
                  return $(this).dialog("close");
                }
              });
            }
            return this._dialog("Player", "", buttons);
          },
          set: function(key, value) {
            this._read(this.instructions.shift());
            return this.scene[key] = value;
          },
          increase: function(key, value) {
            if (this.scene[key]) {
              return this.scene[key] += value;
            } else {
              return this.scene[key] = value;
            }
          },
          "switch": function(key, values) {
            var instructions;
            this[key] = this[key] || 0;
            instructions = this.sceneReader.parse(values[this[key]]);
            return this.instructions = instructions.concat(this.instructions);
          },
          max: function(key, values) {
            var k, key2, lastv, scene, v;
            lastv = 0;
            key2 = values[0];
            scene = this.scene;
            for (k in values) {
              v = values[k];
              if (scene[v]) {
                if (scene[v] > lastv) {
                  key2 = v;
                  lastv = scene[v];
                }
              }
            }
            return this.scene[key] = key2;
          }
        };
      };

      return Director;

    })();
  });

}).call(this);
