// Generated by CoffeeScript 1.4.0
(function() {

  require(['gamecs'], function(gamecs) {
    requirejs.config({
      baseUrl: 'build/mc-examples/space'
    });
    return require(['gamecs', 'systems', 'director', 'data'], function(gamecs, systems, Director, data) {
      var k, myEntities, mySystems, resources, v, _ref;
      resources = [];
      myEntities = [];
      mySystems = {};
      _ref = data.sprites;
      for (k in _ref) {
        v = _ref[k];
        if (v.Visible && v.Visible.image) {
          resources.push(data.prefixs.image + v.Visible.image);
        }
      }
      gamecs.preload(resources);
      return gamecs.ready(function() {
        var display, myDirector, tick, _i, _len, _ref1;
        display = {
          bg1: gamecs.Display.setMode(data.screen.size, 'background'),
          bg2: gamecs.Display.setMode(data.screen.size, 'stars'),
          fg: gamecs.Display.setMode(data.screen.size, 'foreground')
        };
        myDirector = new Director(display, data);
        _ref1 = data.systems;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          k = _ref1[_i];
          mySystems[k] = new systems[k]({
            entities: myDirector.groups.sprites,
            data: data
          });
        }
        tick = function() {
          var entity, group, k2, system, _j, _k, _l, _len1, _len2, _len3, _ref2, _ref3, _ref4;
          myDirector.handleInput(gamecs.Input.get());
          _ref2 = myDirector.groups;
          for (k in _ref2) {
            group = _ref2[k];
            for (_j = 0, _len1 = group.length; _j < _len1; _j++) {
              entity = group[_j];
              for (k2 in mySystems) {
                system = mySystems[k2];
                system.update(entity, 30);
              }
            }
          }
          _ref3 = myDirector.groups.stars;
          for (_k = 0, _len2 = _ref3.length; _k < _len2; _k++) {
            entity = _ref3[_k];
            mySystems.Rendering.draw(entity, display.bg2);
          }
          _ref4 = myDirector.groups.sprites;
          for (_l = 0, _len3 = _ref4.length; _l < _len3; _l++) {
            entity = _ref4[_l];
            mySystems.Rendering.draw(entity, display.fg);
          }
          return myDirector.update();
        };
        return gamecs.Time.interval(tick, 36);
      });
    });
  });

}).call(this);
