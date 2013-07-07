define (require) ->
  "use strict"
  #Display = require('display')
  #gamecs = require('../gamecs')

  ###*
  * @fileoverview Methods for polling mouse and keyboard.
  *
  * Call `gamecs.Input.get()` in your main loop to get a list of input events that happend
  * since your last call.
  *
  * Note that some events, which would trigger a default browser action, are prevented
  * from triggering their default behaviour if and only if the game's display canvas has
  * focus (the game gets focus if the user clicked on the game).
  *
  * All events have a type identifier. This event type is in between the values
  * of NOEVENT and NUMEVENTS. Each event has a constant in `gamecs.event.*` 
  * All user defined events can have the value of USEREVENT or higher.
  * Make sure your custom event ids* follow this system.
  * 
  * A pattern for using the event loop: your main game function (tick in this example)
  * is being called by [gamecs.time.interval()](../time/#interval).
  * Inside tick we call [gamecs.Input.get()](#get) for a list of events that happened since the last
  * tick and we loop over each event and act on the event properties.
  *
  * @example
  *     events = gamecs.Input.get()
  *     events.forEach(function(event) {
  *        if (event.type == gamecs.Input.T_MOUSE_UP) {
  *          gamecs.log(event.pos, event.button)
  *        } else if (event.type == gamecs.Input.T_KEY_UP) {
  *          gamecs.log(event.key)
  *        }
  *     })
  *
  ###
  lastPos = []
  class Input

    ### key constants ###
    @K_LEFT : 37
    @K_UP   : 38
    @K_RIGHT: 39
    @K_DOWN : 40

    @K_BACKSPACE: 8
    @K_TAB  : 9
    @K_ENTER: 13
    @K_SHIFT: 16
    @K_CTRL : 17
    @K_ALT  : 18
    @K_ESC  : 27
    @K_SPACE: 32

    @K_0: 48
    @K_1: 49
    @K_2: 50
    @K_3: 51
    @K_4: 52
    @K_5: 53
    @K_6: 54
    @K_7: 55
    @K_8: 56
    @K_9: 57
    @K_a: 65
    @K_b: 66
    @K_c: 67
    @K_d: 68
    @K_e: 69
    @K_f: 70
    @K_g: 71
    @K_h: 72
    @K_i: 73
    @K_j: 74
    @K_k: 75
    @K_l: 76
    @K_m: 77
    @K_n: 78
    @K_o: 79
    @K_p: 80
    @K_q: 81
    @K_r: 82
    @K_s: 83
    @K_t: 84
    @K_u: 85
    @K_v: 86
    @K_w: 87
    @K_x: 88
    @K_y: 89
    @K_z: 90

    @K_KP1: 97
    @K_KP2: 98
    @K_KP3: 99
    @K_KP4: 100
    @K_KP5: 101
    @K_KP6: 102
    @K_KP7: 103
    @K_KP8: 104
    @K_KP9: 105

    ### event type constants ###
    @NOEVENT: 0
    @NUMEVENTS: 32000

    @T_QUIT    : 0
    @T_KEY_DOWN: 1
    @T_KEY_UP  : 2
    @T_MOUSE_MOTION: 3
    @T_MOUSE_UP    : 4
    @T_MOUSE_DOWN  : 5
    @T_MOUSE_WHEEL : 6
    @T_USEREVENT: 2000

    @QUEUE: []

    ###*
    * Get all events from the event queue
    * @returns {Array}
    ###
    @get: (eventTypes) ->
      if (eventTypes == undefined)
        return Input.QUEUE.splice(0, Input.QUEUE.length)
      else
        eventTypes = [eventTypes] if (! (eventTypes instanceof Array))
        result = []
        Input.QUEUE = Input.QUEUE.filter (event) ->
          return true if (eventTypes.indexOf(event.type) == -1)
          result.push(event)
          return false
        return result

    ###*
    * Get the newest event of the event queue
    * @returns {gamecs.event.Event}
    ###
    @poll: () ->
      return Input.QUEUE.pop()

    ###*
    * Post an event to the event queue.
    * @param {gamecs.event.Event} userEvent the event to post to the queue
    ###
    @post: (userEvent) ->
      Input.QUEUE.push(userEvent)

    ###*
    * Remove all events from the queue
    ###
    @clear: () ->
      Input.QUEUE = []

    ###*
    * Holds all information about an event.
    * @class
    ###
    @Event: () ->
      ### The type of the event. e.g., gamecs.event.T_QUIT, T_KEY_DOWN, T_MOUSE_UP. ###
      @type = null
      ### key the keyCode of the key. compare with gamecs.event.K_a, gamecs.event.K_b,... ###
      @key = null
      ### relative movement for a mousemove event ###
      @rel = null
      ### the number of the mousebutton pressed ###
      @button = null
      ### pos the position of the event for mouse events ###
      @pos = null

    _getContainer = () ->
      return document.getElementById('gcs-container')

    ###*
    * @ignore
    ###
    @init: () ->
      lastPos = []

      ###*
      * IEFIX does not support addEventListener on document itself
      * MOZFIX but in moz & opera events don't reach body if mouse outside window or on menubar
      ###
      document.addEventListener('mousedown', @onMouseDown, false)
      document.addEventListener('mouseup', @onMouseUp, false)
      document.addEventListener('keydown', @onInputDown, false)
      document.addEventListener('keyup', @onInputUp, false)

      container = _getContainer()
      container.addEventListener('mousemove', @onMouseMove, false)
      container.addEventListener('mousewheel', @onMouseScroll, false)
      ###* 
      * MOZFIX
      * https://developer.mozilla.org/en/Code_snippets/Miscellaneous#Detecting_mouse_wheel_events
      ###
      container.addEventListener('DOMMouseScroll', @onMouseScroll, false)
      container.addEventListener('beforeunload', @onBeforeUnload, false)

      ### anonymous functions as event handlers = memory leak, see MDC:elementAddEventListener ###

    ###*
    * The Display (the canvas element) is most likely not in the top left corner
    * of the browser due to CSS styling. To calculate the mouseposition within the
    * canvas we need this offset.
    * @see {gamecs.Input}
    * @ignore
    *
    * @returns {Array} [x, y] offset of the canvas
    ###
    _getCanvasOffset = () ->
      boundRect = _getContainer().getBoundingClientRect()
      return [boundRect.left, boundRect.top]

    ###* @ignore ###
    _hasFocus = () ->
      return document.activeElement == _getContainer()


    @onMouseDown: (ev) ->
      canvasOffset = _getCanvasOffset()
      Input.QUEUE.push(
        type: Input.T_MOUSE_DOWN,
        pos:  [ev.clientX - canvasOffset[0], ev.clientY - canvasOffset[1]],
        button: ev.button,
        shiftInput: ev.shiftInput,
        ctrlInput:  ev.ctrlInput,
        metaInput:  ev.metaInput
      )

    @onMouseUp: (ev) ->
      canvasOffset = _getCanvasOffset()
      Input.QUEUE.push(
        type: Input.T_MOUSE_UP,
        pos:  [ev.clientX - canvasOffset[0], ev.clientY - canvasOffset[1]],
        button:   ev.button
        shiftInput: ev.shiftInput
        ctrlInput:  ev.ctrlInput
        metaInput:  ev.metaInput
      )

    @onInputDown: (ev) ->
      key = ev.keyCode || ev.which
      Input.QUEUE.push(
        type: Input.T_KEY_DOWN
        key:  key
        shiftInput: ev.shiftInput
        ctrlInput:  ev.ctrlInput
        metaInput:  ev.metaInput
      )

      # if the display has focus, we surpress default action
      # for most keys
      ev.preventDefault() if (_hasFocus() && (!ev.ctrlInput && !ev.metaInput &&
        ((key >= Input.K_LEFT && key <= Input.K_DOWN) ||
        (key >= Input.K_0    && key <= Input.K_z) ||
        (key >= Input.K_KP1  && key <= Input.K_KP9) ||
        key == Input.K_SPACE || key == Input.K_TAB ||
        key == Input.K_ENTER)) ||
        key == Input.K_ALT || key == Input.K_BACKSPACE)


    @onInputUp: (ev) ->
      Input.QUEUE.push(
        type: Input.T_KEY_UP
        key:  ev.keyCode
        shiftInput: ev.shiftInput
        ctrlInput:  ev.ctrlInput
        metaInput:  ev.metaInput
      )

    @onMouseMove: (ev) ->
      canvasOffset = _getCanvasOffset()
      currentPos = [ev.clientX - canvasOffset[0], ev.clientY - canvasOffset[1]]
      relativePos = []
      if (lastPos.length)
        relativePos = [
          lastPos[0] - currentPos[0]
          lastPos[1] - currentPos[1]
        ]
      Input.QUEUE.push(
        type: Input.T_MOUSE_MOTION
        pos:  currentPos
        rel:  relativePos
        buttons: null  # FIXME, fixable?
        timestamp: ev.timeStamp
      )
      lastPos = currentPos

    @onMouseScroll: (ev) ->
      canvasOffset = _getCanvasOffset()
      currentPos = [ev.clientX - canvasOffset[0], ev.clientY - canvasOffset[1]]
      Input.QUEUE.push(
        type: Input.T_MOUSE_WHEEL
        pos:  currentPos
        delta: ev.detail || (- ev.wheelDeltaY / 40)
      )

    @onBeforeUnload: (ev) ->
      Input.QUEUE.push(
        type: Input.T_QUIT
      )
