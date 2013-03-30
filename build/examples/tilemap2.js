// Generated by CoffeeScript 1.4.0

/**
* @fileoverview
* This loads a TMX Map and allows you to scroll over the map
* with the cursor keys.
*
* TMX basically mean Tile Map Xml, tmx file can be opened and edited with Tiled (mapeditor.org)
* Note that the map example.tmx and in export in json (example.json) in assets/data are
* perfectly readable and could provide further details about the tilemap operations.
*
* Note how inside the tilemap-file the necessary Tilesets are specified
* relative - Note that you can erase those path directly in the file or
* in the application when data have been imported.
*/


(function() {

  require(['gamecs', 'tilemap', 'surface'], function(gcs, TileMap, Surface) {
    var alive, canvas, dirty, display, font, grid, mouseover, result, rules, s1, team;
    s1 = [600, 600];
    alive = true;
    mouseover = false;
    result = void 0;
    dirty = true;
    team = true;
    grid = [];
    rules = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]];
    display = gcs.Display.setMode(s1);
    gcs.Display.setCaption('TileMap simple test');
    font = new gcs.Font('20px monospace');
    canvas = document.getElementById('gjs-canvas');
    canvas.addEventListener("mouseout", function() {
      dirty = true;
      return mouseover = false;
    }, false);
    canvas.addEventListener("mouseover", function() {
      dirty = true;
      return mouseover = true;
    }, false);
    return gcs.ready(function() {
      var a, colorThree, draw, end, g, gid, gridLineWidth, lineWidth, mPos, map, o, s2, s3, spritePos, sprites, tick, w, x;
      a = s1 / 3;
      lineWidth = 10;
      s2 = [s1[0] / 3 - 20, s1[1] / 3 - 20];
      spritePos = [s2[0] / 2 + lineWidth, s2[1] / 2 + lineWidth];
      w = s2[0];
      o = new Surface(s2);
      colorThree = 'rgba(50, 0, 150, 0.8)';
      gcs.Draw.circle(o, colorThree, spritePos, w / 2.4, lineWidth);
      s3 = [s1[0] / 3, s1[1] / 3];
      x = new Surface(s3);
      gcs.Draw.line(x, colorThree, [20, 0 + 10], [w, w], lineWidth);
      gcs.Draw.line(x, colorThree, [w, 0 + 10], [20, w], lineWidth);
      g = new Surface(s1);
      gridLineWidth = 2;
      gcs.Draw.line(g, colorThree, [s1[0] / 3, 0], [s1[0] / 3, s1[1]], gridLineWidth);
      gcs.Draw.line(g, colorThree, [s1[0] * 2 / 3, 0], [s1[0] * 2 / 3, s1[1]], gridLineWidth);
      gcs.Draw.line(g, colorThree, [0, s1[1] / 3], [s1[0], s1[1] / 3], gridLineWidth);
      gcs.Draw.line(g, colorThree, [0, s1[1] * 2 / 3], [s1[0], s1[1] * 2 / 3], gridLineWidth);
      sprites = {
        "true": o,
        "false": x
      };
      map = new TileMap({
        width: 3,
        height: 3,
        tilewidth: s1[0] / 3,
        tileheight: s1[1] / 3
      });
      mPos = [0, 0];
      gid = 0;
      draw = function() {
        var k, sprite, _i, _ref;
        display.clear();
        display.blit(g);
        for (k = _i = 0, _ref = grid.length; 0 <= _ref ? _i < _ref : _i > _ref; k = 0 <= _ref ? ++_i : --_i) {
          if (grid[k] !== void 0) {
            display.blit(sprites[grid[k]], map.gid2pos(k + 1));
          }
        }
        if (grid[gid] === void 0 && mouseover) {
          sprite = sprites[team];
          sprite.setAlpha(0.5);
          display.blit(sprite, map.gid2pos(gid + 1));
          return sprite.setAlpha(0);
        }
      };
      end = function(result) {
        var msg, surface;
        alive = false;
        surface = new Surface(s1);
        surface.blit(gcs.Display.getSurface());
        display.clear();
        surface.setAlpha(0.7);
        display.blit(surface);
        msg = (result ? 'round won' : result === false ? 'cross won' : 'draw');
        return display.blit(font.render(msg), [s1[0] / 2 - 30, s1[1] / 2 - 5]);
      };
      tick = function(msDuration) {
        if (alive) {
          gcs.Key.get().forEach(function(event) {
            var count, i, j, newgid, res, _i, _j, _k, _ref, _ref1, _ref2;
            if (event.type === gcs.Key.MOUSE_MOTION) {
              mPos = event.pos;
              newgid = map.pos2gid(mPos[0], mPos[1]);
              if (gid !== newgid) {
                gid = newgid;
                dirty = true;
              }
            }
            if (event.type === gcs.Key.MOUSE_DOWN) {
              return dirty = true;
            } else if (event.type === gcs.Key.MOUSE_UP) {
              if (grid[gid] === void 0 && mouseover) {
                grid[gid] = team;
                for (i = _i = 0, _ref = rules.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
                  res = true;
                  for (j = _j = 0, _ref1 = rules[i].length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; j = 0 <= _ref1 ? ++_j : --_j) {
                    if (grid[rules[i][j]] !== team) {
                      res = false;
                    }
                  }
                  if (res === true) {
                    result = team;
                    alive = false;
                  }
                }
                count = 0;
                for (i = _k = 0, _ref2 = grid.length; 0 <= _ref2 ? _k < _ref2 : _k > _ref2; i = 0 <= _ref2 ? ++_k : --_k) {
                  if (grid[i] !== void 0) {
                    count++;
                  }
                }
                if (!res && count === 9) {
                  result = null;
                  alive = false;
                }
                team = !team;
                return dirty = true;
              }
            }
          });
          if (dirty) {
            dirty = false;
            if (result === void 0) {
              return draw();
            } else {
              return end(result);
            }
          }
        }
      };
      return gcs.Time.interval(tick, this, 60);
    });
  });

}).call(this);