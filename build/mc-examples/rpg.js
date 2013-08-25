// Generated by CoffeeScript 1.4.0
(function() {

  require(['gamecs'], function(gamecs) {
    requirejs.config({
      baseUrl: 'build/mc-examples/space'
    });
    return require(['systems', 'entity', 'camera'], function(systems, Entity, Camera) {
      requirejs.config({
        baseUrl: 'build/mc-examples/rpg'
      });
      return require(['director', 'data', 'http', 'tilemap'], function(Director, data, Http, TileMap) {
        var k, myEntities, mySystems, req, resources, v, _i, _j, _len, _len1, _ref, _ref1, _ref2;
        resources = [];
        myEntities = [];
        mySystems = {};
        _ref = data.sprites;
        for (k in _ref) {
          v = _ref[k];
          if (v.Visible && v.Visible.image) {
            resources.push(data.prefixs.image + v.Visible.image);
          }
          if (v.Animated && v.Animated.frameset) {
            resources.push(data.prefixs.image + v.Animated.imageset);
          }
        }
        resources.push(data.prefixs.image + data.map.tilesheet);
        gamecs.Mixer.sfxType = false;
        _ref1 = ['mp3', 'wav', 'ogg', 'm4a'];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          k = _ref1[_i];
          if (gamecs.Mixer.support[k]) {
            gamecs.Mixer.sfxType = k;
            break;
          }
        }
        _ref2 = data.sfx;
        for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
          k = _ref2[_j];
          resources.push(data.prefixs.sfx + k + '.' + gamecs.Mixer.sfxType);
        }
        req = Http.get(data.map.url);
        gamecs.preload(resources);
        return gamecs.ready(function() {
          var camera, display, map, mapData, myDirector, scaleRate, tick, _k, _len2, _ref3;
          mapData = JSON.parse(req.response);
          mapData.tilesets[0].image = data.prefixs.image + data.map.tilesheet;
          map = new TileMap(mapData);
          map.prepareLayers();
          display = {
            bg: gamecs.Display.setMode(data.screen.size, 'background'),
            fg: gamecs.Display.setMode(data.screen.size, 'sprites'),
            fg2: gamecs.Display.setMode(data.screen.size, 'foreground')
          };
          scaleRate = 1.5;
          display.fg._context.scale(scaleRate, scaleRate);
          display.bg._context.scale(scaleRate, scaleRate);
          camera = new Camera(data.screen.size);
          camera.scale(scaleRate);
          myDirector = new Director(display, {
            data: data,
            map: map,
            camera: camera
          });
          _ref3 = data.systems;
          for (_k = 0, _len2 = _ref3.length; _k < _len2; _k++) {
            k = _ref3[_k];
            mySystems[k] = new systems[k]({
              entities: myDirector.groups.sprites,
              map: map
            });
          }
          mySystems['Collision'].spriteCollide = function(e, es) {
            if (this.map.isColliding(e.rect)) {
              return [
                {
                  components: {}
                }
              ];
            } else {
              return this._spriteCollide(e, es);
            }
          };
          tick = function() {
            var entity, group, k2, system, _l, _len3, _len4, _m, _ref4, _ref5;
            myDirector.handleInput(gamecs.Input.get());
            myDirector.handleAI();
            _ref4 = myDirector.groups;
            for (k in _ref4) {
              group = _ref4[k];
              for (_l = 0, _len3 = group.length; _l < _len3; _l++) {
                entity = group[_l];
                for (k2 in mySystems) {
                  system = mySystems[k2];
                  system.update(entity, 30);
                }
              }
            }
            myDirector.setOffset(mySystems.Rendering);
            _ref5 = myDirector.groups.sprites;
            for (_m = 0, _len4 = _ref5.length; _m < _len4; _m++) {
              entity = _ref5[_m];
              mySystems.Rendering.draw(entity, display.fg);
            }
            if (myDirector.player.killed && !myDirector.isGameOver) {
              return myDirector.gameOver();
            }
          };
          return gamecs.Time.interval(tick, 36);
        });
      });
    });
  });

}).call(this);
