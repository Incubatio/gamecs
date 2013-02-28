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
      this.width = data.width
      this.height = data.height

      this.tileWidth = data.tilewidth
      this.tileHeight = data.tileheight
      this.size = [this.width * this.tileWidth, this.height * this.tileHeight]
      
      # TODO: should be managed in game logic out of the class
      this.collisionLayerName = options.collisionLayerName || 'collision'

      # by default tmx count image from 1

      this.tileSheet = new SpriteSheet()
      this.tileSheet.firstgid = data.tilesets[0].firstgid


      # Init tileset in the main tileSheet
      for tileset in data.tilesets
        imageset = Img.load(tileset.image)
        this.tileSheet.load(imageset, [tileset.tilewidth, tileset.tileheight])

      # Init layers, names have to be unique
      this.layers = {}
      for i in [0...data.layers.length]
        this.layers[data.layers[i].name] = data.layers[i]
      
    ###*
    * @param {interger} gid
    * @return {array}
    ###
    gid2pos: (gid) ->
      gid -= 1
      getX = (i, width) ->
        return (i % width == 0) ? width - 1 : (i % width) - 1

      x = (gid == 0) ? 0 : getX(gid + 1, this.width)
      y = Math.floor(gid / this.width)

      return [(x+1) * this.tileWidth, y * this.tileHeight]

    ###*
    * @param {integer} gid
    * @return {Rect}
    ###
    gid2rect: (gid) ->
      return new gamejs.Rect(this.gid2pos(gid), [this.tileWidth, this.tileHeight])

    ###*
    * @param {integer} x
    * @param {integer} y
    * @return {integer}
    ###
    pos2gid: (x, y) ->
      x = Math.floor(x / this.tileWidth)
      y = Math.floor(y / this.tileHeight)
      return (y * this.width) + x #+ 1;


    ###*
    * @param {integer} gid
    * @return {Img}
    ###
    getTile: (gid) ->
      return this.tileSheet.get(gid - this.tileSheet.firstgid)

    ###*
    * @param {integer} x
    * @param {integer} y
    * @return {boolean}
    ###
    isOutOfBounds: (x, y) ->
      return x <= 0 || x >= this.size[0] || y <= 0 || y >= this.size[1]

    ###*
    * For collision layer
    *
    * @param {integer} x
    * @param {integer} y
    * @return {boolean}
    ###
    _isColliding = (x, y, collisionLayerName) ->
      collisionLayerName = this.collisionLayerName if(collisionLayerName == undefined)
      return true if(this.isOutOfBounds(x, y))
      return !!this.layers[this.collisionLayerName].data[this.pos2gid(x, y)]

    ###*
    * @param {Rect}
    * @return boolean
    ###
    isColliding: (rect) ->
      return  _isColliding(rect.left, rect.top) ||
        _isColliding(rect.left + rect.width, rect.top) ||
        _isColliding(rect.left, rect.top + rect.height) ||
        _isColliding(rect.left + rect.width, rect.top + rect.height)

    ###*
    * For Sprite layer, return each tile as object: {pos: [x, y], card: [a, b], gid: i, image: "path/to/image"}
    *
    * @return {Array}
    ###
    getTiles: () ->
      result = []
      #for i in [this.tileSheet.firstgid...(this.visibleLayers['boxes'].length - this.tileSheet.firstgid)]
      #  if(this.visibleLayers['boxes'][i])
      #    result.push(this.gid2pos(i))
      return result

    ###*
    * Prepare a grid of visible images for visible Layers
    ###
    prepareLayers: () ->
      # TOTHINK: managing layer by layer level would more dynamics and less trivial than using names.
      # TODO: store int array of layer key in visibleLayers
      for key of this.layers
        layer = this.layers[key]
        if layer.properties == undefined || layer.properties.visible != false
          surface = new Surface(this.size[0], this.size[1])
          # TODO: think about the best manner to set opacity
          #this.surface.setAlpha(layer.opacity)

          #extract images from a frameset
          for y in [0...this.height]
            for x in [0...this.width]
              rect = new Rect(x * this.tileWidth, y * this.tileHeight, this.tileWidth, this.tileHeight)
              #console.log(y, this.width, x)
              gid = layer.data[(y * this.width) + x] # + 1]
              #gid = this.tileSheet.get((y * this.width) + x) # + 1]
              if(gid != 0)
                if(gid)
                  image = this.getTile(gid)
                  #console.log(gid, image)
                  surface.blit(image, rect)
                else
                  console.log('bug', x, y, gid)
          this.layers[key].image = surface
