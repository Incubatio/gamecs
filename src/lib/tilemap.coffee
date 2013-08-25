define (require) ->
  Surface = require('surface')
  Img = require('img')
  Rect = require('rect')
  SpriteSheet = require('spritesheet')

  ###*
  * This Driver Supports tmxmap of a version >= 0.9
  * To upgrade your tmx map, simply download the last version of Tiled, open the file an re-export it :).
  * http://www.mapeditor.org/
  *
  * TileMap is a component that allow to compose map from re-usable image
  *
  * Tilemap can manage several layers
  * We can consider two different kind of layer, the visible layers and not visible layers (or data layers)
  * - Visible layers are merged into one Layer that will be rendered.
  * - Data layer can contain collision map, movable objects, mob positions, mob areas, ...
  * that directly fits the landscape, and thus can be reused from the application logic :).
  *
  *
  * Note: To keep this component re-usable data layer are simply loaded and then ignored until user
  * decide to get the layer (ex: map.layers.<layerName>) 
  ###
  class TileMap
    
    ###*
    * The width is expressed in tile (this is tmx standart)
    * @type integer
    ###
    width = null

    ###*
    * The height is expressed in tile
    * @type integer
    ###
    height = null

    ###*
    * Tile width in px
    * @type integer
    ###
    tileWidth = null

    ###*
    * Tile height in px
    * @type integer
    ###
    tileHeight = null

    ###*
    * size in px = [width * tileWidth, height * tileHeight] 
    * @type Array
    ###
    size = null

    ###*
    * contains the different image that compose the tile map
    * @type SpriteSheet
    ###
    tileSheet = null

    ###*
    * @constructor
    * @this {Map}
    *
    * @param {Hash} data
    * @param {Hash} options
    ###
    constructor: (data, options) ->
      options = options || {}
      @width = data.width
      @height = data.height

      @tileWidth = data.tilewidth
      @tileHeight = data.tileheight
      @size = [@width * @tileWidth, @height * @tileHeight]
      

      if data.tilesets
        @tileSheet = new SpriteSheet()
        # by default tmx count image from 1
        @tileSheet.firstgid = data.tilesets[0].firstgid

        # Init tileset in the main tileSheet
        for tileset in data.tilesets
          imageset = Img.load(tileset.image)
          @tileSheet.load(imageset, [tileset.tilewidth, tileset.tileheight])


      # Init layers, names have to be unique
      if data.layers
        # TODO: change options management 
        @collisionLayerName = options.collisionLayerName || 'collision'

        @layers = {}
        for i in [0...data.layers.length]
          @layers[data.layers[i].name] = data.layers[i]
      
    ###*
    * @param {interger} gid
    * @return {array}
    ###
    gid2pos: (gid) ->
      gid -= 1
      getX = (i, width) ->
        return if(i % width == 0) then width - 1 else (i % width) - 1

      x = if(gid == 0) then 0 else getX(gid + 1, @width)
      y = Math.floor(gid / @width)

      return [x * @tileWidth, y * @tileHeight]

    ###*
    * @param {integer} gid
    * @return {Rect}
    ###
    gid2rect: (gid) ->
      return new gamecs.Rect(@gid2pos(gid), [@tileWidth, @tileHeight])

    ###*
    * @param {integer} x
    * @param {integer} y
    * @return {integer}
    ###
    pos2gid: (x, y) ->
      x = Math.floor(x / @tileWidth)
      y = Math.floor(y / @tileHeight)
      return (y * @width) + x #+ 1;


    ###*
    * @param {integer} gid
    * @return {Img}
    ###
    getTile: (gid) ->
      return @tileSheet.get(gid - @tileSheet.firstgid)

    ###*
    * @param {integer} x
    * @param {integer} y
    * @return {boolean}
    ###
    isOutOfBounds: (x, y) ->
      return x <= 0 || x >= @size[0] || y <= 0 || y >= @size[1]

    ###*
    * For collision layer
    *
    * @param {integer} x
    * @param {integer} y
    * @return {boolean}
    ###
    _isColliding: (x, y, collisionLayerName) ->
      collisionLayerName = @collisionLayerName if(collisionLayerName == undefined)
      return true if(@isOutOfBounds(x, y))
      return !!@layers[@collisionLayerName].data[@pos2gid(x, y)]

    ###*
    * @param {Rect}
    * @return boolean
    ###
    # TODO: there is a bug here when sprite is bigger than tile, (collision is actually detected by matchin sprite corners to tiles)
    isColliding: (rect) ->
      return  @_isColliding(rect.left, rect.top) ||
        @_isColliding(rect.left + rect.width, rect.top) ||
        @_isColliding(rect.left, rect.top + rect.height) ||
        @_isColliding(rect.left + rect.width, rect.top + rect.height)

    ###*
    * For Sprite layer, return each tile as object: {pos: [x, y], card: [a, b], gid: i, image: "path/to/image"}
    *
    * @return {Array}
    ###
    getTiles: () ->
      result = []
      #for i in [@tileSheet.firstgid...(@visibleLayers['boxes'].length - @tileSheet.firstgid)]
      #  if(@visibleLayers['boxes'][i])
      #    result.push(@gid2pos(i))
      return result

    ###*
    * Prepare a grid of visible images for visible Layers
    ###
    prepareLayers: () ->
      # TOTHINK: managing layer by layer level would more dynamics and less trivial than using names.
      # TODO: store int array of layer key in visibleLayers
      for key of @layers
        layer = @layers[key]
        if layer.properties == undefined || layer.properties.visible != false
          surface = new Surface(@size[0], @size[1])
          # TODO: think about the best manner to set opacity
          #@surface.setAlpha(layer.opacity)

          #extract images from a frameset
          for y in [0...@height]
            for x in [0...@width]
              rect = new Rect(x * @tileWidth, y * @tileHeight, @tileWidth, @tileHeight)
              #console.log(y, @width, x)
              gid = layer.data[(y * @width) + x] # + 1]
              #gid = @tileSheet.get((y * @width) + x) # + 1]
              if(gid != 0)
                if(gid)
                  image = @getTile(gid)
                  #console.log(gid, image)
                  surface.blit(image, rect)
                else
                  console.log('bug', x, y, gid)
          @layers[key].image = surface
