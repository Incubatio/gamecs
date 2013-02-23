###* TODO:BROKEN, i'm not sure but probable misuse of worker ###
define (require) ->
  Uri = require('utils/uri')
  Key = require('key')

  ###
  * @fileoverview
  * Workers are useful to relieve your GameJs application from code which
  * might take long to run. Either expensive algorithms, which might get called
  * every now and then (e.g., path-finding) or another logic being run continously
  * within the rendering loop (e.g., physics engine).
  *
  * A Worker is like a seperate GameJs application being executed - another `main.js`
  * with its own `gamejs.ready()`. The Worker's most important feature is that
  * code executing within it does not block the rendering code. The Worker's
  * greatest limitation is that you can only communicate with it through text
  * messages.
  *
  * See the `examples/workers` directory for a running example.
  *
  * @example
  *  // Create a worker with the main module "./test"
  *  fooWorker = new Worker('./test')
  *  // Send a message to your worker.
  *  // The Message doesn't have to be a string but it must be `JSON.stringify()`-able
  *  fooWorker.post("foobar")
  *
  *  // The result of the worker will be accessible
  *  // in the main application via the gamejs.event queue
  *  if (event.type == gamejs.event.WORKER_RESULT) {
  *     gamejs.log('Worker #' + event.worker.id + ' returned ' + event.data)
  *  }
  *
  *  // In the worker module, we can send results back to the main application
  *  // by posting them to the gamejs event queue as type `gamejs.event.WORKER_RESULT`
  *  gamejs.event.post({
  *     type: gamejs.event.WORKER_RESULT,
  *     data: "zarzar"
  *  })
  *
  ###
  class Worker

    ###*
    * true if this GameJs instance is being executed within a WebWorker
    * @type Boolean
    ###
    @inWorker: (this.importScripts != undefined)

    ###*
    * Executed in scope of worker after user's main module
    * @ignore
    ###
    @_ready: () ->
      self.onmessage = (event) ->
        Key.post(event.data)
      self.postMessage(
        type: Key.WORKER_ALIVE
      )

    ###*
    * Send message to main context for logging
    * @ignore
    *###
    @_logMessage: (args...) ->
      self.postMessage(
        type: Key.WORKER_LOGMESSAGE
        arguments: Array.prototype.slice.apply(args)
      )

    ###*
    * Send result message to main context
    * @ignore
    ###
    @_messageMain: (event) ->
      self.postMessage(
        type: Key.WORKER_RESULT
        data: event.data
      )

    ###*
    * executed in scope of worker before user's main module
    * @ignore
    ###
    @workerPrefix: () ->
      __scripts.forEach((script) ->
        try
          importScripts(script)
        catch e
           # can't help the worker
      )


    ###*
    * Setup a worker which has `require()` defined
    * @ignore
    *###
    @create: (workerModuleId) ->
      #moduleRoot = Uri.resolve(document.location.href, window.require.getModuleRoot())
      moduleRoot = document.location.href
      initialScripts = []
      Array.prototype.slice.apply(document.getElementsByTagName('script'), [0]).forEach((script) ->
        initialScripts.push(script.src) if (script.src)
      )

      URL = window.URL || window.webkitURL
      prefixString = Worker.workerPrefix().toString()
      # don't be afraid...
      prefixString = prefixString.substring(prefixString.indexOf("{") + 1, prefixString.lastIndexOf("}"))
      blob = new Blob([
        'var __scripts = ["' + initialScripts.join('","') + '"];'
        prefixString
        'self.require.setModuleRoot("' + moduleRoot + '");'
        'self.require.run("' + workerModuleId + '");'
      ], {type: 'application\/javascript'})

      blobURL = URL.createObjectURL(blob)
      return new Worker(blobURL)

    ###
    * The `Worker` constructor takes only one argument: a module id. This module
    * will be executed inside the newly created Worker. It is effectively the
    * main module of the Worker.
    *
    * Inside a Worker, you can use `require()` to import other scripts or
    * GameJs modules.
    *
    * **Note:** A Worker does not have access to the browser's `document`. So
    * a lot of GameJs modules - everything related to drawing to the canvas -
    * do not work in the Worker.
    *
    * You can use `gamejs.time.*`, `gamejs.utils.*`, `gamejs.event.*` and probably others
    * (as well as any module you write yourself for this purpose, of course).
    *
    * @param {String} moduleId The Worker's main module id. The main module will be executed in the worker
    ###
    constructor: (moduleId) ->
      # FIXME id should be unchangeable
      ###
       * Unique id of this worker
       * @property {Number}
       ###
      id = this.id = this.guid(moduleId)
      worker = Worker.create(moduleId)
      deadQueue = []
      alive = false
      self  = this

      worker.onmessage = (event) ->
        if (event.data.type == gamejs.event.WORKER_ALIVE)
          alive = true
          deadQueue.forEach((data) ->
             self.post(data)
          )
        else if (event.data.type == gamejs.event.WORKER_LOGMESSAGE)
          gamejs.log.apply(null, [id].concat(event.data.arguments))
        else
          gamejs.event.post(
            type: gamejs.event.WORKER_RESULT
            data: event.data.data
            worker: self
            event: event
          )
      worker.onerror = (event) ->
        gamejs.error('Error in worker "' + id + '" line ' + event.lineno + ': ', event.message)
        gamejs.event.post(
          type: gamejs.event.WORKER_ERROR
          data: event.data
          worker: self
          event: event
        )
      

    ###*
    * Send a message to the worker
    *
    * @param {Object} data Payload object which gets sent to the Worker
    ###
    post: (data) ->
      if (alive)
        worker.postMessage(
          type: gamejs.event.WORKER
          data: data
        )
      else
        deadQueue.push(data)
      
    ###*
    * not a real GUID
    * @ignore
    ###
    guid: (moduleId) ->
      S4 = () ->
        return (((1+Math.random())*0x10000)|0).toString(16).substring(1)
      return moduleId + '@' + (S4()+S4())
