define (require) ->
  Objects = require('utils/objects')
  Rect = require('rect')

  ###*
  * @fileoverview Image masks. Usefull for pixel perfect collision detection.
  ###
  class Mask

    ###*
    * Creates an image mask from the given Surface. The alpha of each pixel is checked
    * to see if it is greater than the given threshold. If it is greater then
    * that pixel is set as non-colliding.
    *
    * @param {gamecs.Surface} surface
    * @param {Number} threshold 0 to 255. defaults to: 255, fully transparent
    ###
    @fromSurface: (surface, threshold) ->
      threshold = threshold && (255 - threshold) || 255
      imgData = surface.getImageData().data
      dims = surface.getSize()
      mask = new Mask(dims)
      #for (i=0i<imgData.length += 4)
      for i in [0..imgData.length] by 4
        ### y: pixel # / width ###
        y = parseInt((i / 4) / dims[0], 10)
        ### x: pixel # % width ###
        x = parseInt((i / 4) % dims[0], 10)
        alpha = imgData[i+3]
        if (alpha >= threshold)
          mask.setAt(x, y)
      return mask

    ###*
    * Image Mask
    * @param {Array} dimensions [width, height]
    ###
    constructor: (dims) ->
      ### @ignore ###
      @width = dims[0]
      ### @ignore ###
      @height = dims[1]
      ### @ignore ###
      @_bits = []
      #for (i=0; i<@width; i++)
      for i in [0...@width]
        @_bits[i] = []
        #for (j=0;j<@height; j++)
        for j in [0...@height]
          @_bits[i][j] = false
      return

    ###*
    * @param {gamecs.mask.Mask} otherMask
    * @param {Array} offset [x,y]
    * @returns the overlapping rectangle or null if there is no overlap
    ###
    overlapRect: (otherMask, offset) ->
      arect = @rect
      brect = otherMask.rect

      brect.moveIp(offset) if (offset)

      ### bounding box intersect ###
      return null if (!brect.collideRect(arect))

      xStart = Math.max(arect.left, brect.left)
      xEnd = Math.min(arect.right, brect.right)

      yStart = Math.max(arect.top, brect.top)
      yEnd = Math.min(arect.bottom, brect.bottom)

      return new Rect([xStart, yStart], [xEnd - xStart, yEnd - yStart])

    ###*
    * @returns True if the otherMask overlaps with this map.
    * @param {Mask} otherMask
    * @param {Array} offset
    ###
    overlap: (otherMask, offset) ->
      overlapRect = @overlapRect(otherMask, offset)
      return false if (overlapRect == null)

      arect = @rect
      brect = otherMask.rect
      
      brect.moveIp(offset) if (offset)

      count = 0
      #for (y=overlapRect.top; y<=overlapRect.bottom; y++)
      for y in [overlapRect.top..overlapRect.bottom]
        #for (x=overlapRect.left; x<=overlapRect.right; x++)
        for x in [overlapRect.left..overlapRect.right]
          return true if (@getAt(x - arect.left, y - arect.top) &&
            otherMask.getAt(x - brect.left, y - brect.top))
            ###*
            * NOTE this should not happen because either we bailed out
            * long ago because the rects do not overlap or there is an
            * overlap and we should not have gotten this far.
            * throw new Error("Maks.overlap: overlap detected but could not create mask for it.")
            ###
      return false

    ###*
    * @param {gamecs.mask.Mask} otherMask
    * @param {Array} offset [x,y]
    * @returns the number of overlapping pixels
    ###
    overlapArea: (otherMask, offset) ->
      overlapRect = @overlapRect(otherMask, offset)
      return 0 if (overlapRect == null)

      arect = @rect
      brect = otherMask.rect
     
      brect.moveIp(offset) if (offset)

      count = 0
      #for (y=overlapRect.top; y<=overlapRect.bottom; y++)
      for y in [overlapRect.top..overlapRect.bottom]
      #  for (x=overlapRect.left; x<=overlapRect.right; x++)
        for x in [overlapRect.left..overlapRect.right]
          count++ if (@getAt(x - arect.left, y - arect.top) &&
            otherMask.getAt(x - brect.left, y - brect.top))
      return count

    ###*
    * @param {gamecs.mask.Mask} otherMask
    * @param {Array} offset [x,y]
    * @returns a mask of the overlapping pixels
    ###
    overlapMask: (otherMask, offset) ->
      overlapRect = @overlapRect(otherMask, offset)
      return 0 if (overlapRect == null)

      arect = @rect
      brect = otherMask.rect
     
      brect.moveIp(offset) if (offset)

      mask = new Mask([overlapRect.width, overlapRect.height])
      #for (y=overlapRect.top y<=overlapRect.bottom y++)
      for y in [overlapRect.top..overlapRect.bottom]
        #for (x=overlapRect.left x<=overlapRect.right x++)
        for x in [overlapRect.left..overlapRect.right]
          mask.setAt(x, y) if (@getAt(x - arect.left, y - arect.top) &&
          otherMask.getAt(x - brect.left, y - brect.top))
                
      return mask

    ###*
    * Set bit at position.
    * @param {Number} x
    * @param {Number} y
    ###
    setAt: (x, y) ->
      @_bits[x][y] = true

    ###*
    * Get bit at position.
    *
    * @param {Number} x
    * @param {Number} y
    ###
    getAt: (x, y) ->
      x = parseInt(x, 10)
      y = parseInt(y, 10)
      return false if (x < 0 || y < 0 || x >= @width || y >= @height)
      return @_bits[x][y]


    ###*
    * Flip the bits in this map.
    ###
    invert: () ->
      @_bits = @_bits.map((row) ->
        return row.map((b) ->
          return !b
        )
      )

    ###*
    * @returns {Array} the dimensions of the map
    ###
    getSize = () ->
      return [@width, @height]

    Objects.accessors(Mask.prototype,
      ###*
      * Rect of this Mask.
      ###
      rect:
        get: () ->
          return new Rect([0, 0], [@width, @height])
      ,
      ###*
      * @returns {Number} number of set pixels in this mask.
      ###
      length:
        get: () ->
          c = 0
          @_bits.forEach((row) ->
            row.forEach((b) ->
              c++ if (b)
            )
          )
          return c
    )
