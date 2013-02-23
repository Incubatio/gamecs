define (require) ->
  ###
   * @fileoverview This module holds the essential `Rect` and `Surface` classes as
   * well as static methods for preloading assets. `gamejs.ready()` is maybe
   * the most important as it kickstarts your app.
  ###
   
  DEBUG_LEVELS = ['info', 'warn', 'error', 'fatal']
  debugLevel = 2

  exports = {}
  RESOURCES = {}

  ###
   * set logLevel as string or number:
   *   - 0 = info
   *   - 1 = warn
   *   - 2 = error
   *   - 3 = fatal
   *
   * @example
   * gamejs.setLogLevel(0) # debug
   * gamejs.setLogLevel('error') # equal to setLogLevel(2)
  ###
  exports.setLogLevel = (logLevel) ->
    if (typeof logLevel == 'string' && DEBUG_LEVELS.indexOf(logLevel))
      debugLevel = DEBUG_LEVELS.indexOf(logLevel)
    else if (typeof logLevel == 'number')
      debugLevel = logLevel
    else
      throw new Error('invalid logLevel ', logLevel, ' Must be one of: ', DEBUG_LEVELS)
    return debugLevel


  ###
   * Log a msg to the console if console is enable
   * @param {String} msg the msg to log
  ###
  log = exports.log = (args...) ->
    if (Worker.inWorker == true)
      Worker._logMessage(args)
      return

    ### IEFIX can't call apply on console ###
    args = Array.prototype.slice.apply(args, [0])
    args.unshift(Date.now())
    console.log.apply(console, args) if (window.console != undefined && console.log.apply)
        

  exports.info = (args...) ->
    log.apply(this, args) if debugLevel <= DEBUG_LEVELS.indexOf('info')

  exports.warn = (args...) ->
    log.apply(this, args) if (debugLevel <= DEBUG_LEVELS.indexOf('warn'))

  exports.error = (args...) ->
    log.apply(this, args) if (debugLevel <= DEBUG_LEVELS.indexOf('error'))
      
  exports.fatal = (args...) ->
    log.apply(this, args) if (debugLevel <= DEBUG_LEVELS.indexOf('fatal'))


  Display = exports.Display = require('display')
  Draw    = exports.Draw    = require('draw')
  Key     = exports.Key     = require('key')
  Font    = exports.Font    = require('font')
  Http    = exports.Http    = require('http')
  Img     = exports.Img     = require('img')
  Mask    = exports.Mask    = require('mask')
  Mixer   = exports.Mixer   = require('mixer')
  Sprite  = exports.Sprite  = require('sprite')
  Group   = exports.Group   = require('group')
  Time    = exports.Time    = require('time')
  Worker  = exports.Worker  = require('worker')
  Base64  = exports.Base64  = require('base64')
  Xml     = exports.Xml     = require('xml')
  Rect    = exports.Rect    = require('rect')
  Transform = exports.Transform = require('transform')
  Simplex = exports.Simplex = require('simplex')
    #tmx',
    #noise'
    #Surfacearray',

  ###
  * ReadyFn is called once all modules and assets are loaded.
  * @param {Function} readyFn the function to be called once gamejs finished loading
  * @name ready
  ###
  if (Worker.inWorker == true)
    exports.ready = (readyFn) ->
      Worker._ready()
      init()
      readyFn()
  else
    exports.ready = (readyFn) ->
      getMixerProgress = null
      getImageProgress = null

      # init time instantly - we need it for preloaders
      Time.init()

      # 2.
      _ready = () ->
        if (!document.body)
          return window.setTimeout(_ready, 50)

        getImageProgress = Img.preload(RESOURCES)

        try
          getMixerProgress = Mixer.preload(RESOURCES)
        catch e
          #gamejs.debug('Error loading audio files ', e)
          console.log('Error loading audio files ', e)

        window.setTimeout(_readyResources, 50)


      # 3.
      _readyResources = () ->
        if (getImageProgress() < 1 || getMixerProgress() < 1)
          return window.setTimeout(_readyResources, 100)
        Display.init()
        Img.init()
        Mixer.init()
        Key.init()
        readyFn()

      # 1.
      window.setTimeout(_ready, 13)

      getLoadProgress = () ->
         if (getImageProgress)
           return (0.5 * getImageProgress()) + (0.5 * getMixerProgress())
         return 0.1

      return getLoadProgress

  ###
  * Initialize all gamejs modules. This is automatically called
  * by `gamejs.ready()`.
  * @returns {Object} the properties of this objecte are the moduleIds that failed, they value are the exceptions
  * @ignore
  ###
  init = () ->
    errorModules = {}
    ['Time', 'Display', 'Img', 'Mixer', 'Key'].forEach((moduleName) ->
      try
        this[moduleName].init()
      catch e
        errorModules[moduleName] = e.toString()
      
    )
    return errorModules

  resourceBaseHref = () ->
    return (window.$g && window.$g.resourceBaseHref) || document.location.href

  ###
  * Preload resources.
  * @param {Array} resources list of resources paths
  * @name preload
  ###
  preload = exports.preload = (resources) ->
    uri = require('utils/uri')
    baseHref = resourceBaseHref()
    resources.forEach((res) ->
      RESOURCES[res] = uri.resolve(baseHref, res)
    , this)


  return exports
