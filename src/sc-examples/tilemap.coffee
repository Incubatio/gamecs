###*
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
###
require ['gamecs', 'tilemap', 'http'], (gamecs, TileMap, Http) ->


  gamecs.preload(['assets/data/tilesheet.png'])

  gamecs.ready () ->
    gamecs.Display.setCaption('TMX viewer')

    display = gamecs.Display.setMode([800, 500])

    url = 'assets/data/example.json'
    req = Http.get(url)

    data = JSON.parse(req.response)
    console.log(data)
    data.tilesets[0].image = 'assets/data/tilesheet.png'
    map = new TileMap(data)
    map.prepareLayers()

    offset = [0, 0]

    tick = (msDuration) ->
      gamecs.Input.get().forEach (event) ->
        if (event.type == gamecs.Input.T_KEY_DOWN)
          switch (event.key)
            when gamecs.Input.K_LEFT  then offset[0] += 50
            when gamecs.Input.K_RIGHT then offset[0] -= 50
            when gamecs.Input.K_DOWN  then offset[1] -= 50
            when gamecs.Input.K_UP    then offset[1] += 50

      #update(msDuration)
      display.clear()
      for k, layer of map.layers
        display.blit(layer.image, offset)
      #map.draw(display)

    gamecs.Time.interval(tick)
