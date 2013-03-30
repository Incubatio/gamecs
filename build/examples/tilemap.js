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

  require(['gamecs', 'tilemap', 'http'], function(gamecs, TileMap, Http) {
    gamecs.preload(['assets/data/tilesheet.png']);
    return gamecs.ready(function() {
      var data, display, map, offset, req, tick, url;
      gamecs.Display.setCaption('TMX viewer');
      display = gamecs.Display.setMode([800, 500]);
      url = 'assets/data/example.json';
      req = Http.get(url);
      data = JSON.parse(req.response);
      console.log(data);
      data.tilesets[0].image = 'assets/data/tilesheet.png';
      map = new TileMap(data);
      map.prepareLayers();
      offset = [0, 0];
      tick = function(msDuration) {
        var k, layer, _ref, _results;
        gamecs.Key.get().forEach(function(event) {
          if (event.type === gamecs.Key.KEY_DOWN) {
            switch (event.key) {
              case gamecs.Key.K_LEFT:
                return offset[0] += 50;
              case gamecs.Key.K_RIGHT:
                return offset[0] -= 50;
              case gamecs.Key.K_DOWN:
                return offset[1] -= 50;
              case gamecs.Key.K_UP:
                return offset[1] += 50;
            }
          }
        });
        display.clear();
        _ref = map.layers;
        _results = [];
        for (k in _ref) {
          layer = _ref[k];
          _results.push(display.blit(layer.image, offset));
        }
        return _results;
      };
      return gamecs.Time.interval(tick);
    });
  });

}).call(this);