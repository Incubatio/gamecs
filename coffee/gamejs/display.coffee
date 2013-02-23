define (require) ->
  # TOTHINK: merge display with surface
  Surface = require('surface')

  # TODO: move "Constants" as "default static properties"
  CANVAS_ID = "gjs-canvas"
  LOADER_ID = "gjs-loader"
  SURFACE = null

  ###*
  * Pass this flag to `gamejs.display.setMode(resolution, flags)` to disable
  * pixel smoothing; this is, for example, useful for retro-style, low resolution graphics
  * where you don't want the browser to smooth them when scaling & drawing.
  ###
  DISABLE_SMOOTHING = 2

  _SURFACE_SMOOTHING = true

  ###*
  * @returns {document.Element} the canvas dom element
  ###
  getCanvas = () ->
    return document.getElementById(CANVAS_ID)

  class Display
    ###*
    * @fileoverview Methods to create, access and manipulate the display Surface.
    *
    * @example
    * display = gamejs.display.setMode([800, 600])
    * // blit sunflower picture in top left corner of display
    * sunflower = gamejs.image.load("images/sunflower")
    * display.blit(sunflower)
    *
    ###



    ###*
    * Create the master Canvas plane.
    * @ignore
    ###
    @init: () ->
      ###* create canvas element if not yet present ###
      jsGameCanvas = null
      if ((jsGameCanvas = getCanvas()) == null)
        jsGameCanvas = document.createElement("canvas")
        jsGameCanvas.setAttribute("id", CANVAS_ID)
        document.body.appendChild(jsGameCanvas)

      # to be focusable, tabindex must be set
      jsGameCanvas.setAttribute("tabindex", 1)
      jsGameCanvas.focus()

      ###* remove loader if any ###
      $loader = document.getElementById('gjs-loader')
      $loader.style.display = "none" if ($loader)

    ###* @ignore ###
    @_hasFocus: () ->
      return document.activeElement == getCanvas()

    ###* @ignore ###
    @_isSmoothingEnabled: () ->
      return (_SURFACE_SMOOTHING == true)

    ###*
    * Set the width and height of the Display. Conviniently this will
    * return the actual display Surface - the same as calling [gamejs.display.getSurface()](#getSurface))
    * later on.
    * @param {Array} dimensions [width, height] of the display surface
    ###
    @setMode: (dimensions, flags) ->
      SURFACE = null
      canvas = getCanvas()
      canvas.width  = dimensions[0]
      canvas.height = dimensions[1]
      _SURFACE_SMOOTHING = (flags != DISABLE_SMOOTHING)
      return this.getSurface()

    ###*
    * Set the Caption of the Display (document.title)
    * @param {String} title the title of the app
    * @param {gamejs.Image} icon FIXME implement favicon support
    ###
    @setCaption: (title, icon) ->
      document.title = title

    ###*
    * The Display (the canvas element) is most likely not in the top left corner
    * of the browser due to CSS styling. To calculate the mouseposition within the
    * canvas we need this offset.
    * @see {gamejs.event}
    * @ignore
    *
    * @returns {Array} [x, y] offset of the canvas
    ###
    # TODO: _ designate private/protected property, ... this one was clearly exported...
    @_getCanvasOffset: () ->
      boundRect = getCanvas().getBoundingClientRect()
      return [boundRect.left, boundRect.top]


    ###*
    * Drawing on the Surface returned by `getSurface()` will draw on the screen.
    * @returns {gamejs.Surface} the display Surface
    ###
    @getSurface: () ->
      if (SURFACE == null)
        canvas = getCanvas()
        SURFACE = new Surface([canvas.clientWidth, canvas.clientHeight])
        SURFACE._canvas = canvas
        SURFACE._context = canvas.getContext('2d')
      return SURFACE
