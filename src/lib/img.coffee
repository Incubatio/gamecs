define (require) ->
  Surface = require('surface')

  CACHE = {}

  ###*
  * need to export preloading status for require
  * @ignore
  ###
  _PRELOADING = false

  ###*
  * add the given <img> dom elements into the cache.
  * @private
  ###
  addToCache = (img) ->
    CACHE[img.gamecsInput] = img

  ###*
  * @fileoverview Load images as Surfaces.
  *
  * Sounds & Images are loaded relative to your game's html page
  * (the html which includes the GameJs code) or relative to the 
  * property `window.$g.resourceBaseHref`
  * if it is set.
  *
  *
  ###
  class Img


    ###*
    * Load image and return it on a Surface.
    *
    * All images must be preloaded before they can be used.
    * @example
    * 
    *     gamecs.preload(["./images/ship.png", "./images/sunflower.png"])
    *     // ...later...
    *     display.blit(gamecs.image.load('images/ship.png'))
    *
    * @param {String|dom.Image} uriOrImage resource uri for image
    * @returns {gamecs.Surface} surface with the image on it.
    ###
    @load: (key) ->
      if (typeof key == 'string')
        img = CACHE[key]
        if (!img)
          ### TODO sync image loading ###
          throw new Error('Missing "' + key + '", gamecs.preload() all images before trying to load them.')
      else
        img = key
      canvas = document.createElement('canvas')
      ### IEFIX missing html5 feature naturalWidth/Height ###
      canvas.width = img.naturalWidth || img.width
      canvas.height = img.naturalHeight || img.height
      context = canvas.getContext('2d')
      context.drawImage(img, 0, 0)
      img.getSize = () ->
        return [img.naturalWidth, img.naturalHeight]
      surface = new Surface(img.getSize())
      ### NOTE hack setting protected _canvas directly ###
      surface._canvas = canvas
      surface._context = context
      return surface


    ###*
    * add all images on the currrent page into cache
    * @ignore
    ###
    @init: () ->
      return

    ###*
    * preload the given img URIs
    * @returns {Function} which returns 0-1 for preload progress
    * @ignore
    ###
    @preload: (imgIdents) ->

      countLoaded = 0
      countTotal = 0

      incrementLoaded = () ->
         countLoaded++
         if (countLoaded == countTotal)
           _PRELOADING = false
         if (countLoaded % 10 == 0)
           console.log('gamecs.image: preloaded  ' + countLoaded + ' of ' + countTotal)

      getProgress = () ->
        return if countTotal > 0 then countLoaded / countTotal else 1

      successHandler = () ->
        addToCache(this)
        incrementLoaded()

      errorHandler = () ->
        incrementLoaded()
        throw new Error('Error loading ' + this.src)

      for key of imgIdents
        lowerInput = key.toLowerCase()
        continue if (lowerInput.indexOf('.png') == -1 && lowerInput.indexOf('.jpg') == -1 &&
          lowerInput.indexOf('.jpeg') == -1 && lowerInput.indexOf('.svg') == -1 &&
          lowerInput.indexOf('.gif') == -1)
        img = new Image()
        img.addEventListener('load', successHandler, true)
        img.addEventListener('error', errorHandler, true)
        img.src = imgIdents[key]
        img.gamecsInput = key
        countTotal++

      if (countTotal > 0)
        _PRELOADING = true

      return getProgress

