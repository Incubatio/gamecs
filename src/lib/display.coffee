define (require) ->
  "use strict"
  # TOTHINK: merge display with surface
  Surface = require('surface')


  ###*
  * @fileoverview Methods to create, access and manipulate the display Surface.
  *
  * @example
  * display = gamecs.display.setMode([800, 600])
  * // blit sunflower picture in top left corner of display
  * sunflower = gamecs.image.load("images/sunflower")
  * display.blit(sunflower)
  *
  ###
  class Display
    # TODO: move "Constants" as "default static properties"
    CONTAINER_ID = "gcs-container"
    CANVAS_ID = "gcs-canvas"
    LOADER_ID = "gcs-loader"

    layers = {}

    ###*
    * @param {String} [id] id of the canvas dom element
    * @returns {document.Element} the canvas dom element
    ###
    getCanvas = (id) ->
      canvasId = id || CANVAS_ID
      return document.getElementById(canvasId)



    ###*
    * Create the master Canvas plane.
    * @ignore
    ###
    @init: () ->
      ###* create canvas element if not yet present ###
      #jsGameCanvas = null
      gameContainer = document.getElementById(CONTAINER_ID)
      if (gameContainer == null)
        gameContainer = document.createElement("div")
        gameContainer.setAttribute("id", CONTAINER_ID)
        document.body.appendChild(gameContainer)

      # to be focusable, tabindex must be set
      gameContainer.setAttribute("tabindex", 1)
      gameContainer.focus()

      ###* remove loader if any ###
      loader = document.getElementById(LOADER_ID)
      loader.style.display = "none" if (loader)

    ###* @ignore ###
    @_isSmoothingEnabled: () ->
      return (_SURFACE_SMOOTHING == true)

    ###*
    * Set the width and height of the Display. Conviniently this will
    * return the actual display Surface - the same as calling [gamecs.display.getSurface()](#getSurface))
    * later on.
    * @param {Array} dimensions [width, height] of the display surface
    * @param {String} [id] id of the canvas dom element
    ###
    @setMode: (dimensions, id) ->
      canvasId = id || CANVAS_ID
      gameContainer = document.getElementById(CONTAINER_ID)
      gameContainer.style.width = dimensions[0] + "px"
      gameContainer.style.height = dimensions[1] + "px"
      canvas = getCanvas(canvasId)
      if(canvas == null)
        canvas = document.createElement("canvas")
        canvas.setAttribute("id", canvasId)
        canvas.style.position = "absolute"
        canvas.onclick = () -> gameContainer.focus()
        gameContainer.appendChild(canvas)
        
        
      canvas.width  = dimensions[0]
      canvas.height = dimensions[1]
      return @getSurface(canvasId)

    ###*
    * Set the Caption of the Display (document.title)
    * @param {String} title the title of the app
    * @param {gamecs.Image} icon FIXME implement favicon support
    ###
    @setCaption: (title, icon) ->
      document.title = title

    @getSurfaces: () ->
      return layers

    ###*
    * Drawing on the Surface returned by `getSurface()` will draw on the screen.
    * @param {String} [id] id of the canvas dom element
    * @returns {gamecs.Surface} the display Surface
    ###
    @getSurface: (id) ->
      canvasId = id || CANVAS_ID
      if (!layers[canvasId])
        canvas = getCanvas(id)
        surface = new Surface([canvas.clientWidth, canvas.clientHeight])
        surface._canvas = canvas
        surface._context = canvas.getContext('2d')
        layers[canvasId] = surface
      return layers[canvasId]
  #return new Display()
