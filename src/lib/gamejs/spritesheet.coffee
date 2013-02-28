define (require) ->
  Surface = require('surface')
  Rect = require('rect')
  
  class SpriteSheet
    _images = []

    constructor: () ->

    # sheet is an instance of gamejs.image
    get: (id) ->
      return _images[id]

    # sheet is an imageset, size is the size of each image in the set
    load: (sheet, size) ->
      width = size[0]
      height = size[1]
      imgSize = new Rect([0,0], size)

      # do not tolerate partial image
      numX = Math.floor(sheet.rect.width / width)
      numY = Math.floor(sheet.rect.height / height)

      # extract images from a frameset
      for y in [0...numY]
        for x in [0...numX]
          surface = new Surface(size)
          rect = new Rect((x*width), (y*height), width, height)
          surface.blit(sheet, imgSize, rect)
          _images.push(surface)
