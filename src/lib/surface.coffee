define (require) ->
  Rect   = require('rect')
  #Display = require('display')
  Objects = require('utils/objects')
  #Matrix = require('Matrix')
  ###*
  * A Surface represents a bitmap image with a fixed width and height. The
  * most important feature of a Surface is that they can be `blitted`
  * onto each other.
  *
  * @example
  * new gamejs.Surface([width, height])
  * new gamejs.Surface(width, height)
  * new gamejs.Surface(rect)
  * @constructor
  *
  * @param {Array} dimensions Array holding width and height
  ###
  isInit = false
  class Surface

    constructor: (args...) ->
      if(!isInit)
        isInit = true
        Objects.accessors(Surface.prototype,
          ### @type gamejs.Rect ###
          rect:
            get: () ->
              return this.getRect()

          ### @ignore ###
          context:
            get: () ->
              return this._context

          canvas:
            get: () ->
              return this._canvas
        )

      args = Rect.normalizeArguments.apply(this, args)
      width = args.left
      height = args.top
      # unless argument is rect:
      if (args.length == 1 && args[0] instanceof Rect)
        width = args.width
        height = args.height
      # only for rotatation & scale
      ### @ignore ###
      #this._matrix = Matrix.identity()
      this._matrix = [1, 0, 0, 1, 0, 0]
      ### @ignore ###
      this._canvas = document.createElement("canvas")
      this._canvas.width = width
      this._canvas.height = height
      ### @ignore ###
      this._blitAlpha = 1.0

      ### @ignore ###
      this._context = this._canvas.getContext('2d')


      # using exports is weird but avoids circular require
      # TODO: it's not weird it's retarded, architecture and IOC are solution for fuck sake.
      # if Display._isSmoothingEnabled() then this._smooth() else this._noSmooth()
      this._noSmooth()

    ###* @ignore ###
    _noSmooth: () ->
      ###*
        disable image scaling
        see https:#developer.mozilla.org/en/Canvas_tutorial/Using_images#Controlling_image_scaling_behavior
        and https:#github.com/jbuck/processing-js/commit/65de16a8340c694cee471a2db7634733370b941c
      ###
      this.context.mozImageSmoothingEnabled = false
      this.context.webkitImageSmoothingEnabled = false
      return

      ###* @ignore ###
      _smooth: () ->
        this.context.mozImageSmoothingEnabled = true
        this.context.webkitImageSmoothingEnabled = true

    ###*
    * Blits another Surface on this Surface. The destination where to blit to
    * can be given (or it defaults to the top left corner) as well as the
    * Area from the Surface which should be blitted (e.g., for cutting out parts of
    * a Surface).
    * 
    * @example
    * # blit flower in top left corner of display
    * displaySurface.blit(flowerSurface)
    * 
    * # position flower at 10/10 of display
    * displaySurface.blit(flowerSurface, [10, 10])
    * 
    * # ... `dest` can also be a rect whose topleft position is taken:
    * displaySurface.blit(flowerSurface, new gamejs.Rect([10, 10])
    * 
    * # only blit half of the flower onto the display
    * flowerRect = flowerSurface.rect
    * flowerRect = new gamejs.Rect([0,0], [flowerRect.width/2, flowerRect.height/2])
    * displaySurface.blit(flowerSurface, [0,0], flowerRect)
    * 
    * @param {gamejs.Surface} src The Surface which will be blitted onto this one
    * @param {gamejs.Rect|Array} dst the Destination x, y position in this Surface.
    *            If a Rect is given, it's top and left values are taken. If this argument
    *            is not supplied the blit happens at [0,0].
    * @param {gamesjs.Rect|Array} area the Area from the passed Surface which
    *            should be blitted onto this Surface.
    * @param {Number} compositionOperation how the source and target surfaces are composited together 
    *            one of: source-atop, source-in, source-out, source-over (default), destination-atop, 
    *            destination-in, destination-out, destination-over, lighter, copy, xor for an explanation 
    *            of these values see: http:#dev.w3.org/html5/2dcontext/#dom-context-2d-globalcompositeoperation
    * @returns {gamejs.Rect} Rect actually repainted FIXME actually return something?
    ###
    blit: (src, dest, area, compositeOperation) ->

      if (dest instanceof Rect)
        #rDest = clone(dest)
        rDest = dest.clone()
        srcSize = src.getSize()
        if (!rDest.width)
          rDest.width = srcSize[0]
        if (!rDest.height)
          rDest.height = srcSize[1]
       else if (dest && dest instanceof Array && dest.length = 2)
         rDest = new Rect(dest, src.getSize())
       else
         rDest = new Rect([0,0], src.getSize())
      compositeOperation = compositeOperation || 'source-over'

      # area within src to be drawn
      if (area instanceof Rect)
        rArea = area
      else if (area && area instanceof Array && area.length = 2)
        size = src.getSize()
        rArea = new Rect(area, [size[0] - area[0], size[1] - area[1]])
      else
        rArea = new Rect([0,0], src.getSize())
      

      if (isNaN(rDest.left) || isNaN(rDest.top) || isNaN(rDest.width) || isNaN(rDest.height))
        throw new Error('[blit] bad parameters, destination is ' + rDest)
     

      this.context.save()
      this.context.globalCompositeOperation = compositeOperation
      ### first translate, then rotate ###
      #m = matrix.translate(matrix.identity(), rDest.left, rDest.top);
      this.context.translate(rDest.left, rDest.top)
      #m = Matrix.translate(Matrix.identity(), rDest.left, rDest.top)
      #m = Matrix.multiply(m, src._matrix)
      #this.context.transform(m[0], m[1], m[2], m[3], m[4], m[5])
      ### drawImage(image, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight) ###
      this.context.globalAlpha = src._blitAlpha
      this.context.drawImage(src.canvas, rArea.left, rArea.top, rArea.width, rArea.height, 0, 0, rDest.width, rDest.height)
      this.context.restore()
      return

    ###* @returns {Number[]} the width and height of the Surface ###
    getSize: () ->
      return [this.canvas.width, this.canvas.height]

    ###*
    * Obsolte, only here for compatibility.
    * @deprecated
    * @ignore
    * @returns {gamejs.Rect} a Rect of the size of this Surface
    ###
    getRect: () ->
      return new Rect([0,0], this.getSize())

    ###*
    * Fills the whole Surface with a color. Usefull for erasing a Surface.
    * @param {String} CSS color string, e.g. '#0d120a' or '#0f0' or 'rgba(255, 0, 0, 0.5)'
    * @param {gamejs.Rect} a Rect of the area to fill (defauts to entire surface if not specified)
    ###
    fill: (color, rect) ->
      this.context.save()
      this.context.fillStyle = color || "#000000"
      if ( rect == undefined )
        rect = new Rect(0, 0, this.canvas.width, this.canvas.height)

      this.context.fillRect(rect.left, rect.top, rect.width, rect.height)
      this.context.restore()
      return

    ### Clear the surface.  ###
    clear: (rect) ->
      size = this.getSize()
      rect = rect || new Rect(0, 0, size[0], size[1])
      this.context.clearRect(rect.left, rect.top, rect.width, rect.height)
      return

    ###* @returns {gamejs.Surface} a clone of this surface ###
    clone: () ->
      newSurface = new Surface(this.getRect())
      newSurface.blit(this)
      return newSurface

    ###* @returns {Number} current alpha value ###
    getAlpha: () ->
      return (1 - this._blitAlpha)

    ###*
    * Set the alpha value for the whole Surface. When blitting the Surface on
    * a destination, the pixels will be drawn slightly transparent.
    * @param {Number} alpha value in range 0.0 - 1.0
    * @returns {Number} current alpha value
    ###
    setAlpha: (alpha) ->
       return if (isNaN(alpha) || alpha < 0 || alpha > 1)

       this._blitAlpha = (1 - alpha)
       return (1 - this._blitAlpha)

    ###*
    * The data must be represented in left-to-right order, row by row top to bottom,
    * starting with the top left, with each pixel's red, green, blue, and alpha components
    * being given in that order for each pixel.
    * @see http:#dev.w3.org/html5/2dcontext/#canvaspixelarray
    * @returns {ImageData} an object holding the pixel image data {data, width, height}
    ###
    getImageData: () ->
      size = this.getSize()
      return this.context.getImageData(0, 0, size[0], size[1])

