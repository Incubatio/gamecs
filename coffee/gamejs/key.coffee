define (require) ->
  Display = require('display')
  #gamejs = require('../gamejs')

  ###*
  * @fileoverview Methods for polling mouse and keyboard.
  *
  * Call `gamejs.event.get()` in your main loop to get a list of events that happend
  * since your last call.
  *
  * Note that some events, which would trigger a default browser action, are prevented
  * from triggering their default behaviour if and only if the game's display canvas has
  * focus (the game gets focus if the user clicked on the game).
  *
  * All events have a type identifier. This event type is in between the values
  * of NOEVENT and NUMEVENTS. Each event has a constant in `gamejs.event.*` 
  * All user defined events can have the value of USEREVENT or higher.
  * Make sure your custom event ids* follow this system.
  * 
  * A pattern for using the event loop: your main game function (tick in this example)
  * is being called by [gamejs.time.interval()](../time/#interval).
  * Inside tick we call [gamejs.event.get()](#get) for a list of events that happened since the last
  * tick and we loop over each event and act on the event properties.
  *
  * @example
  *     events = gamejs.event.get()
  *     events.forEach(function(event) {
  *        if (event.type == gamejs.event.MOUSE_UP) {
  *          gamejs.log(event.pos, event.button)
  *        } else if (event.type == gamejs.event.KEY_UP) {
  *          gamejs.log(event.key)
  *        }
  *     })
  *
  ###
  lastPos = []
  class Key

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

    @QUIT    : 0
    @KEY_DOWN: 1
    @KEY_UP  : 2
    @MOUSE_MOTION: 3
    @MOUSE_UP    : 4
    @MOUSE_DOWN  : 5
    @MOUSE_WHEEL : 6
    @USEREVENT: 2000

    @QUEUE: []

    ###*
    * Get all events from the event queue
    * @returns {Array}
    ###
    @get: (eventTypes) ->
      if (eventTypes == undefined)
        return Key.QUEUE.splice(0, Key.QUEUE.length)
      else
        eventTypes = [eventTypes] if (! (eventTypes instanceof Array))
        result = []
        Key.QUEUE = Key.QUEUE.filter (event) ->
          return true if (eventTypes.indexOf(event.type) == -1)
          result.push(event)
          return false
        return result

    ###*
    * Get the newest event of the event queue
    * @returns {gamejs.event.Event}
    ###
    @poll: () ->
      return Key.QUEUE.pop()

    ###*
    * Post an event to the event queue.
    * @param {gamejs.event.Event} userEvent the event to post to the queue
    ###
    @post: (userEvent) ->
      Key.QUEUE.push(userEvent)

    ###*
    * Remove all events from the queue
    ###
    @clear: () ->
      Key.QUEUE = []

    ###*
    * Holds all information about an event.
    * @class
    ###
    @Event: () ->
      ### The type of the event. e.g., gamejs.event.QUIT, KEYDOWN, MOUSEUP. ###
      this.type = null
      ### key the keyCode of the key. compare with gamejs.event.K_a, gamejs.event.K_b,... ###
      this.key = null
      ### relative movement for a mousemove event ###
      this.rel = null
      ### the number of the mousebutton pressed ###
      this.button = null
      ### pos the position of the event for mouse events ###
      this.pos = null

    ###*
    * @ignore
    ###
    @init: () ->

      lastPos = []

      ###*
      * IEFIX does not support addEventListener on document itself
      * MOZFIX but in moz & opera events don't reach body if mouse outside window or on menubar
      ###
      canvas = Display.getSurface()._canvas
      document.addEventListener('mousedown', this.onMouseDown, false)
      document.addEventListener('mouseup', this.onMouseUp, false)
      document.addEventListener('keydown', this.onKeyDown, false)
      document.addEventListener('keyup', this.onKeyUp, false)
      canvas.addEventListener('mousemove', this.onMouseMove, false)
      canvas.addEventListener('mousewheel', this.onMouseScroll, false)
      ###* 
      * MOZFIX
      * https://developer.mozilla.org/en/Code_snippets/Miscellaneous#Detecting_mouse_wheel_events
      ###
      canvas.addEventListener('DOMMouseScroll', this.onMouseScroll, false)
      canvas.addEventListener('beforeunload', this.onBeforeUnload, false)

      ### anonymous functions as event handlers = memory leak, see MDC:elementAddEventListener ###


    @onMouseDown: (ev) ->
      canvasOffset = Display._getCanvasOffset()
      Key.QUEUE.push(
        type: Key.MOUSE_DOWN,
        pos:  [ev.clientX - canvasOffset[0], ev.clientY - canvasOffset[1]],
        button: ev.button,
        shiftKey: ev.shiftKey,
        ctrlKey:  ev.ctrlKey,
        metaKey:  ev.metaKey
      )

    @onMouseUp: (ev) ->
      canvasOffset = Display._getCanvasOffset()
      Key.QUEUE.push(
        type: Key.MOUSE_UP,
        pos:  [ev.clientX - canvasOffset[0], ev.clientY - canvasOffset[1]],
        button:   ev.button
        shiftKey: ev.shiftKey
        ctrlKey:  ev.ctrlKey
        metaKey:  ev.metaKey
      )

    @onKeyDown: (ev) ->
      key = ev.keyCode || ev.which
      Key.QUEUE.push(
        type: Key.KEY_DOWN
        key:  key
        shiftKey: ev.shiftKey
        ctrlKey:  ev.ctrlKey
        metaKey:  ev.metaKey
      )

      # if the display has focus, we surpress default action
      # for most keys
      ev.preventDefault() if (Display._hasFocus() && (!ev.ctrlKey && !ev.metaKey &&
        ((key >= Key.K_LEFT && key <= Key.K_DOWN) ||
        (key >= Key.K_0    && key <= Key.K_z) ||
        (key >= Key.K_KP1  && key <= Key.K_KP9) ||
        key == Key.K_SPACE || key == Key.K_TAB ||
        key == Key.K_ENTER)) ||
        key == Key.K_ALT || key == Key.K_BACKSPACE)


    @onKeyUp: (ev) ->
      Key.QUEUE.push(
        type: Key.KEY_UP
        key:  ev.keyCode
        shiftKey: ev.shiftKey
        ctrlKey:  ev.ctrlKey
        metaKey:  ev.metaKey
      )

    @onMouseMove: (ev) ->
      canvasOffset = Display._getCanvasOffset()
      currentPos = [ev.clientX - canvasOffset[0], ev.clientY - canvasOffset[1]]
      relativePos = []
      if (lastPos.length)
        relativePos = [
          lastPos[0] - currentPos[0]
          lastPos[1] - currentPos[1]
        ]
      Key.QUEUE.push(
        type: Key.MOUSE_MOTION
        pos:  currentPos
        rel:  relativePos
        buttons: null  # FIXME, fixable?
        timestamp: ev.timeStamp
      )
      lastPos = currentPos

    @onMouseScroll: (ev) ->
      canvasOffset = Display._getCanvasOffset()
      currentPos = [ev.clientX - canvasOffset[0], ev.clientY - canvasOffset[1]]
      Key.QUEUE.push(
        type: Key.MOUSE_WHEEL
        pos:  currentPos
        delta: ev.detail || (- ev.wheelDeltaY / 40)
      )

    @onBeforeUnload: (ev) ->
      Key.QUEUE.push(
        type: Key.QUIT
      )
