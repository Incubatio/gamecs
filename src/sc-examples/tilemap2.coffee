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
require ['gamecs', 'tilemap', 'surface'], (gcs, TileMap, Surface) ->

  #### Some game variables
  # screen size
  s1 = [600, 600]

  alive  = true
  mouseover = false
  result = undefined

  dirty = true
  team = true
  grid = []
  rules = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], # horrizontal
    [0, 3, 6], [1, 4, 7], [2, 5, 8], #vertical
    [0, 4, 8], [2, 4, 6] #diagonal
  ]

  display = gcs.Display.setMode(s1)
  gcs.Display.setCaption('TileMap simple test')
  font = new gcs.Font('20px monospace')

  ###### Dom events 
  canvas = document.getElementById('gcs-canvas')
  canvas.addEventListener("mouseout", () ->
    dirty = true
    mouseover = false
  , false)
  canvas.addEventListener("mouseover", () ->
    dirty = true
    mouseover = true
  , false)

  ###### Game Management
  gcs.ready () ->

    a = s1 / 3

    # Sprites
    lineWidth = 10
    s2 = [s1[0] / 3 - 20, s1[1] / 3 - 20]
    spritePos = [s2[0] / 2 + lineWidth, s2[1] / 2 + lineWidth]
    w = s2[0]

    o = new Surface(s2)
    colorThree = 'rgba(50, 0, 150, 0.8)'
    gcs.Draw.circle(o, colorThree, spritePos, w/2.4, lineWidth)

    s3 = [s1[0] / 3, s1[1] / 3]
    x = new Surface(s3)
    gcs.Draw.line(x, colorThree, [20, 0 + 10], [w, w], lineWidth)
    gcs.Draw.line(x, colorThree, [w, 0 + 10], [20, w], lineWidth)

    g = new Surface(s1)
    gridLineWidth = 2
    gcs.Draw.line(g, colorThree, [s1[0]/3,0], [s1[0]/3, s1[1]], gridLineWidth)
    gcs.Draw.line(g, colorThree, [s1[0]*2/3,0], [s1[0]*2/3, s1[1]], gridLineWidth)
    gcs.Draw.line(g, colorThree, [0, s1[1]/3], [s1[0], s1[1]/3], gridLineWidth)
    gcs.Draw.line(g, colorThree, [0, s1[1]*2/3], [s1[0], s1[1]*2/3], gridLineWidth)

    sprites = {
      true: o
      false: x
    }


    # Tilemap
    map = new TileMap({
      width: 3
      height: 3
      tilewidth: s1[0] / 3
      tileheight: s1[1] / 3
    })

    mPos = [0, 0]
    gid = 0

    draw = () ->
      display.clear()
      display.blit(g)
      # draw grid
      for k in [0...grid.length]
        display.blit(sprites[grid[k]], map.gid2pos(k + 1)) if grid[k] != undefined

      if(grid[gid] == undefined && mouseover)
        sprite = sprites[team]
        sprite.setAlpha 0.5
        display.blit(sprite, map.gid2pos(gid + 1))
        sprite.setAlpha 0

      #display.blit(font.render('Test: ' + gid + ' ...[' + mPos[0] + ', ' + mPos[1] + ']' ), [10, 250])

    end = (result) ->
      alive = false
      surface = new Surface(s1)
      #surface = gcs.Display.getSurface().clone()
      surface.blit(gcs.Display.getSurface())

      display.clear()
      surface.setAlpha(0.7)
      display.blit(surface)

      msg = (if result then 'round won' else if result == false then 'cross won' else 'draw')
      display.blit(font.render(msg), [s1[0] / 2 - 30, s1[1] / 2 - 5])



    tick = (msDuration) ->

      if(alive)
        gcs.Input.get().forEach (event) ->
          if (event.type == gcs.Input.T_MOUSE_MOTION)
            mPos = event.pos
            newgid = map.pos2gid(mPos[0], mPos[1])
            if(gid != newgid)
              gid = newgid
              dirty = true

          if (event.type == gcs.Input.T_MOUSE_DOWN)
            dirty = true

          else if (event.type == gcs.Input.T_MOUSE_UP)
            if(grid[gid] == undefined && mouseover)
              grid[gid] = team

              for i in [0...rules.length]
                res = true
                for j in [0...rules[i].length]
                  res = false if(grid[rules[i][j]] != team)
                if res == true
                  result = team
                  alive = false
                  break
              count = 0
              for i in [0...grid.length] then if grid[i] != undefined then count++

              if !res && count == 9
                result = null
                alive = false

              team = !team
              dirty = true
              # draw mouse over
        if dirty
          dirty = false
          if(result == undefined) then draw() else end(result)

    gcs.Time.interval(tick)
