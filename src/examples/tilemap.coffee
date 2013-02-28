###*
* @fileoverview
* This loads a TMX Map and allows you to scroll over the map
* with the cursor keys.
*
* Try to open the "data/cute.tmx" file with the Tiled map editor to
* see how the layers work and how the image for the tiles is specified.
*
* There are several useful classes inside the "view.js" module, which
* help with rendering all the layers of a map.
*
* Note how inside the tmx-file the necessary Tilesets are specified
* relative - this is the easiest way to get them to automatically load
* with the map.
###
require ['gamejs', 'tilemap', 'http'], (gamejs, TileMap, Http) ->


  gamejs.preload(['/gamecs/assets/data/tilesheet.png'])

  gamejs.ready () ->
    gamejs.Display.setCaption('TMX viewer')

    display = gamejs.Display.setMode([800, 500])

    url = 'assets/data/example.json'
    req = Http.get(url)

    data = JSON.parse(req.response)
    console.log(data)
    data.tilesets[0].image = '/gamecs/assets/data/tilesheet.png'
    map = new TileMap(data)
    map.prepareLayers()

    offset = [0, 0]

    tick = (msDuration) ->
      gamejs.Key.get().forEach (event) ->
        if (event.type == gamejs.Key.KEY_DOWN)
          switch (event.key)
            when gamejs.Key.K_LEFT  then offset[0] += 50
            when gamejs.Key.K_RIGHT then offset[0] -= 50
            when gamejs.Key.K_DOWN  then offset[1] -= 50
            when gamejs.Key.K_UP    then offset[1] += 50

      #update(msDuration)
      display.clear()
      #console.log(map.visibleLayers)
      for layer of map.layers
        display.blit(layer.image, offset)
      #map.draw(display)

    gamejs.Time.fpsCallback(tick, this, 60)
