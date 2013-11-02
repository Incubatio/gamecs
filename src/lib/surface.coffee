define (require) ->
  Rect   = require('rect')
  #Display = require('display')
  Objects = require('utils/objects')
  Matrix = require('utils/matrix')
  ###*
  * A Surface represents a bitmap image with a fixed width and height. The
  * most important feature of a Surface is that they can be `blitted`
  * onto each other.
  *
  * @example
  * new gamecs.Surface([width, height])
  * new gamecs.Surface(width, height)
  * new gamecs.Surface(rect)
  * @constructor
  *
  * @param {Array} dimensions Array holding width and height
  ###
  isInit = false
  class Surface

    ###*
    * set to false to disable
    * pixel smoothing; this is, for example, useful for retro-style, low resolution graphics
    * where you don't want the browser to smooth them when scaling & drawing.
    ###
    Surface.SURFACE_SMOOTHING = true

    constructor: (args...) ->
      if(!isInit)
        isInit = true
        Objects.accessors(Surface.prototype,
          ### @type gamecs.Rect ###
          rect:
            get: () ->
              return @getRect()

          ### @ignore ###
          context:
            get: () ->
              return @_context

          canvas:
            get: () ->
              return @_canvas
        )

      args2 = Rect.normalizeArguments.apply(this, args)
      width = args2.left
      height = args2.top
      # unless argument is rect:
      if (args[0].length == 1 && args[0] instanceof Rect)
        width = args[0].width
        height = args[0].height
      # only for rotatation & scale
      ### @ignore ###
      #@_matrix = Matrix.identity()
      @_matrix = [1, 0, 0, 1, 0, 0]
      ### @ignore ###
      @_canvas = document.createElement("canvas")
      @_canvas.width = width
      @_canvas.height = height
      ### @ignore ###
      @_blitAlpha = 1.0

      ### @ignore ###
      @_context = @_canvas.getContext('2d')


      # using exports is weird but avoids circular require
      # TODO: it's not weird it's retarded, architecture and IOC are solution for fuck sake.
      if Surface.SURFACE_SMOOTHING then @_smooth() else @_noSmooth()
      #@_noSmooth()

    ###* @ignore ###
    _noSmooth: () ->
      ###*
        disable image scaling
        see https:#developer.mozilla.org/en/Canvas_tutorial/Using_images#Controlling_image_scaling_behavior
        and https:#github.com/jbuck/processing-js/commit/65de16a8340c694cee471a2db7634733370b941c
      ###
      @context.mozImageSmoothingEnabled = false
      @context.webkitImageSmoothingEnabled = false
      return

    ###* @ignore ###
    _smooth: () ->
      @context.mozImageSmoothingEnabled = true
      @context.webkitImageSmoothingEnabled = true

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
    * displaySurface.blit(flowerSurface, new gamecs.Rect([10, 10])
    * 
    * # only blit half of the flower onto the display
    * flowerRect = flowerSurface.rect
    * flowerRect = new gamecs.Rect([0,0], [flowerRect.width/2, flowerRect.height/2])
    * displaySurface.blit(flowerSurface, [0,0], flowerRect)
    * 
    * @param {gamecs.Surface} src The Surface which will be blitted onto this one
    * @param {gamecs.Rect|Array} dst the Destination x, y position in this Surface.
    *            If a Rect is given, it's top and left values are taken. If this argument
    *            is not supplied the blit happens at [0,0].
    * @param {gamesjs.Rect|Array} area the Area from the passed Surface which
    *            should be blitted onto this Surface.
    * @param {Number} compositionOperation how the source and target surfaces are composited together 
    *            one of: source-atop, source-in, source-out, source-over (default), destination-atop, 
    *            destination-in, destination-out, destination-over, lighter, copy, xor for an explanation 
    *            of these values see: http:#dev.w3.org/html5/2dcontext/#dom-context-2d-globalcompositeoperation
    * @returns {gamecs.Rect} Rect actually repainted FIXME actually return something?
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
       else if (dest && dest instanceof Array && dest.length == 2)
         rDest = new Rect(dest, src.getSize())
       else
         rDest = new Rect([0,0], src.getSize())
      compositeOperation = compositeOperation || 'source-over'

      # area within src to be drawn
      if (area instanceof Rect)
        rArea = area
      else if (area && area instanceof Array && area.length == 2)
        size = src.getSize()
        rArea = new Rect(area, [size[0] - area[0], size[1] - area[1]])
      else
        rArea = new Rect([0,0], src.getSize())
      

      if (isNaN(rDest.left) || isNaN(rDest.top) || isNaN(rDest.width) || isNaN(rDest.height))
        throw new Error('[blit] bad parameters, destination is ' + rDest)
     

      @context.save()
      @context.globalCompositeOperation = compositeOperation
      ### first translate, then rotate ###
      #@context.translate(rDest.left, rDest.top)
      # TODO: Is it not 1.Scale, 2.Rotate, 3.Translate ?
      m = Matrix.translate(Matrix.identity(), rDest.left, rDest.top)
      m = Matrix.multiply(m, src._matrix)
      @context.transform(m[0], m[1], m[2], m[3], m[4], m[5])
      ### drawImage(image, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight) ###
      @context.globalAlpha = src._blitAlpha
      @context.drawImage(src.canvas, rArea.left, rArea.top, rArea.width, rArea.height, 0, 0, rDest.width, rDest.height)
      @context.restore()
      return

    ###* @returns {Number[]} the width and height of the Surface ###
    getSize: () ->
      return [@canvas.width, @canvas.height]

    ###*
    * Obsolte, only here for compatibility.
    * @deprecated
    * @ignore
    * @returns {gamecs.Rect} a Rect of the size of this Surface
    ###
    getRect: () ->
      return new Rect([0,0], @getSize())

    ###*
    * Fills the whole Surface with a color. Usefull for erasing a Surface.
    * @param {String} CSS color string, e.g. '#0d120a' or '#0f0' or 'rgba(255, 0, 0, 0.5)'
    * @param {gamecs.Rect} a Rect of the area to fill (defauts to entire surface if not specified)
    ###
    fill: (color, rect) ->
      @context.save()
      @context.fillStyle = color || "#000000"
      if ( rect == undefined )
        rect = new Rect(0, 0, @canvas.width, @canvas.height)

      @context.fillRect(rect.left, rect.top, rect.width, rect.height)
      @context.restore()
      return

    ### Clear the surface.  ###
    clear: (rect) ->
      size = @getSize()
      rect = rect || new Rect(0, 0, size[0], size[1])
      @context.clearRect(rect.left, rect.top, rect.width, rect.height)
      return

    ###* @returns {gamecs.Surface} a clone of this surface ###
    clone: () ->
      newSurface = new Surface(@getRect().clone())
      newSurface.blit(this)
      return newSurface

    ###* @returns {Number} current alpha value ###
    getAlpha: () ->
      return (1 - @_blitAlpha)

    ###*
    * Set the alpha value for the whole Surface. When blitting the Surface on
    * a destination, the pixels will be drawn slightly transparent.
    * @param {Number} alpha value in range 0.0 - 1.0
    * @returns {Number} current alpha value
    ###
    setAlpha: (alpha) ->
       return if (isNaN(alpha) || alpha < 0 || alpha > 1)

       @_blitAlpha = (1 - alpha)
       return (1 - @_blitAlpha)

    ###*
    * The data must be represented in left-to-right order, row by row top to bottom,
    * starting with the top left, with each pixel's red, green, blue, and alpha components
    * being given in that order for each pixel.
    * @see http:#dev.w3.org/html5/2dcontext/#canvaspixelarray
    * @returns {ImageData} an object holding the pixel image data {data, width, height}
    ###
    getImageData: () ->
      size = @getSize()
      return @context.getImageData(0, 0, size[0], size[1])

