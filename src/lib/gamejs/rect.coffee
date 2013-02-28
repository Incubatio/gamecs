define (require) ->
  Objects = require('utils/objects')
  ###*
  * Creates a Rect. Rects are used to hold rectangular areas. There are a couple
  * of convinient ways to create Rects with different arguments and defaults.
  * 
  * Any function that requires a `gamejs.Rect` argument also accepts any of the
  * constructor value combinations `Rect` accepts.
  * 
  * Rects are used a lot. They are good for collision detection, specifying
  * an area on the screen (for blitting) or just to hold an objects position.
  * 
  * The Rect object has several virtual attributes which can be used to move and align the Rect:
  * 
  *   top, left, bottom, right
  *   topleft, bottomleft, topright, bottomright
  *   center
  *   width, height
  *   w,h
  * 
  * All of these attributes can be assigned to.
  * Assigning to width or height changes the dimensions of the rectangle all other
  * assignments move the rectangle without resizing it. Notice that some attributes
  * are Numbers and others are pairs of Numbers.
  * 
  * @example
  * new Rect([left, top]) # width & height default to 0
  * new Rect(left, top) # width & height default to 0
  * new Rect(left, top, width, height)
  * new Rect([left, top], [width, height])
  * new Rect(oldRect) # clone of oldRect is created
  * 
  * @property {Number} right
  * @property {Number} bottom
  * @property {Number} center
  * 
  * @param {Array|gamejs.Rect} position Array holding left and top coordinates
  * @param {Array} dimensions Array holding width and height
  ###
  isInit = false
  initAccessor = () ->
    if(!isInit)
      isInit = true
      Objects.accessors Rect.prototype,
        ###*
        * Bottom, Y coordinate
        * @name Rect.prototype.bottom
        * @type Number
        ###
        bottom:
          get: () -> return this.top + this.height

          set: (newValue) ->
            this.top = newValue - this.height
            return

        ###*
        * Right, X coordinate
        * @name Rect.prototype.right
        * @type Number
        ###
        right:
          get: () -> return this.left + this.width

          set: (newValue) ->
            this.left = newValue - this.width
            return

        ###*
        * Center Position. You can assign a rectangle form.
        * @name Rect.prototype.center
        * @type Array
        ###
        center:
          get: () ->
            return [this.left + (this.width / 2) | 0, this.top + (this.height / 2) | 0]

          set: (args...) ->
            args = Rect.normalizeArguments.apply(this, args)
            this.left = args.left - (this.width / 2) | 0
            this.top = args.top - (this.height / 2) | 0
            return

        ###*
        * Top-left Position. You can assign a rectangle form.
        * @name Rect.prototype.topleft
        * @type Array
        ###
        topleft:
          get: () ->
            return [this.left, this.top]
          set: (args...) ->
            args = Rect.normalizeArguments.apply(this, args)
            this.left = args.left
            this.top = args.top
            return

        ###*
        * Bottom-left Position. You can assign a rectangle form.
        * @name Rect.prototype.bottomleft
        * @type Array
        ###
        bottomleft:
          get: () ->
            return [this.left, this.bottom]

          set: (args...) ->
            args = Rect.normalizeArguments.apply(this, args)
            this.left = args.left
            this.bottom = args.top
            return

        ###*
        * Top-right Position. You can assign a rectangle form.
        * @name Rect.prototype.topright
        * @type Array
        ###
        topright:
          get: () ->
            return [this.right, this.top]

          set: (args...) ->
            args = Rect.normalizeArguments.apply(this, args)
            this.right = args.left
            this.top = args.top
            return

        ###*
        * Bottom-right Position. You can assign a rectangle form.
        * @name Rect.prototype.bottomright
        * @type Array
        ###
        bottomright:
          get: () ->
            return [this.right, this.bottom]

          set: (args...) ->
            args = Rect.normalizeArguments.apply(this, args)
            this.right = args.left
            this.bottom = args.top
            return

        ###*
        * Position x value, alias for `left`.
        * @name Rect.prototype.y
        * @type Array
        ###
        x:
          get: () ->
            return this.left
          set: (newValue) ->
            this.left = newValue
            return

        ###*
        * Position y value, alias for `top`.
        * @name Rect.prototype.y
        * @type Array
        ###
        y:
          get: () ->
            return this.top
          set: (newValue) ->
            this.top = newValue
            return



  class Rect
    constructor: (args...) ->
      args = Rect.normalizeArguments.apply(this, args)
      this.init(args.left, args.top, args.width, args.height)
      initAccessor()

    ###*
    * @param {Number} left    left, X coordinate
    * @param {Number} top     top,  Y coordinate
    * @param {Number} width
    * @param {Number} height
    ###
    init: (@left, @top, @width, @height) ->

    ###*
    * Normalize various ways to specify a Rect into {left, top, width, height} form.
    ###
    Rect.normalizeArguments = (args...) ->
      # res = [left, top, width, height]
      if (args.length == 2)
        if (args[0] instanceof Array && args[1] instanceof Array)
          res = [args[0][0], args[0][1], args[1][0], args[1][1]]
        else
          res = [args[0], args[1]]

      else if (args.length == 1 && args[0] instanceof Array)
        res = [args[0][0], args[0][1], args[0][2], args[0][3]]

      else if (args.length == 1 && args[0] instanceof Rect)
        res = [args[0].left, args[0].top, args[0].width, args[0].height]

      else if (args.length == 4)
        res = [args[0], args[1], args[2], args[3]]

      else
        throw new Error('not a valid rectangle specification')
      return {left: res[0] || 0, top: res[1] || 0, width: res[2] || 0, height: res[3] || 0}


    ###*
    * Move returns a new Rect, which is a version of this Rect
    * moved by the given amounts. Accepts any rectangle form.
    * as argument.
    * 
    * @param {Number|gamejs.Rect} x amount to move on x axis
    * @param {Number} y amount to move on y axis
    ###
    move: (args...) ->
      args = Rect.normalizeArguments.apply(this, args)
      return new Rect(this.left + args.left, this.top + args.top, this.width, this.height)

    ###*
    * Move this Rect in place - not returning a new Rect like `move(x, y)` would.
    * 
    * `moveIp(x,y)` or `moveIp([x,y])`
    * 
    * @param {Number|gamejs.Rect} x amount to move on x axis
    * @param {Number} y amount to move on y axis
    ###
    moveIp: (args...) ->
      args = Rect.normalizeArguments.apply(this, args)
      this.left += args.left
      this.top += args.top

    ###*
    * Return the area in which this Rect and argument Rect overlap.
    *
    * @param {gamejs.Rect} Rect to clip this one into
    * @returns {gamejs.Rect} new Rect which is completely inside the argument Rect,
    * zero sized Rect if the two rectangles do not overlap
    ###
    clip: (rect) ->
      return new Rect(0,0,0,0) if (!this.collideRect(rect))

      ### Left ###
      if ((this.left >= rect.left) && (this.left < rect.right))
        x = this.left
      else if ((rect.left >= this.left) && (rect.left < this.right))
        x = rect.left

      ### Right ###
      if ((this.right > rect.left) && (this.right <= rect.right))
        width = this.right - x
      else if ((rect.right > this.left) && (rect.right <= this.right))
        width = rect.right - x

      ### Top ###
      if ((this.top >= rect.top) && (this.top < rect.bottom))
         y = this.top
      else if ((rect.top >= this.top) && (rect.top < this.bottom))
         y = rect.top

      ### Bottom ###
      if ((this.bottom > rect.top) && (this.bottom <= rect.bottom))
        height = this.bottom - y
      else if ((rect.bottom > this.top) && (rect.bottom <= this.bottom))
        height = rect.bottom - y

      return new Rect(x, y, width, height)

    ###*
    * Join two rectangles
    *
    * @param {gamejs.Rect} union with this rectangle
    * @returns {gamejs.Rect} rectangle containing area of both rectangles
    ###
    union: (rect) ->
       x = Math.min(this.left, rect.left)
       y = Math.min(this.top, rect.top)
       width  = Math.max(this.right, rect.right) - x
       height = Math.max(this.bottom, rect.bottom) - y
       return new Rect(x, y, width, height)

    ###
     * Grow or shrink the rectangle size
     *
     * @param {Number} amount to change in the width
     * @param {Number} amount to change in the height
     * @returns {gamejs.Rect} inflated rectangle centered on the original rectangle's center
    ###
    inflate: (x, y) ->
      copy = this.clone()
      #copy = clone(this)

      copy.inflateIp(x, y)

      return copy

    ###
     *  Grow or shrink this Rect in place - not returning a new Rect like `inflate(x, y)` would.
     * 
     *  @param {Number} amount to change in the width
     *  @param {Number} amount to change in the height
    ###
    inflateIp: (x, y) ->
      # Use Math.floor here to deal with rounding of negative numbers the
      # way this relies on.
      this.left -= Math.floor(x / 2)
      this.top -= Math.floor(y / 2)
      this.width += x
      this.height += y

    ###
     * Check for collision with a point.
     * 
     * `collidePoint(x,y)` or `collidePoint([x,y])` or `collidePoint(new Rect(x,y))`
     * 
     * @param {Array|gamejs.Rect} point the x and y coordinates of the point to test for collision
     * @returns {Boolean} true if the point collides with this Rect
    ###
    collidePoint: (args...) ->
     args = Rect.normalizeArguments.apply(this, args)
     return (this.left <= args.left && args.left <= this.right) &&
       (this.top <= args.top && args.top <= this.bottom)

    ###
     * Check for collision with a Rect.
     * @param {gamejs.Rect} rect the Rect to test check for collision
     * @returns {Boolean} true if the given Rect collides with this Rect
    ###
    collideRect: (rect) ->
      return !(this.left > rect.right || this.right < rect.left ||
        this.top > rect.bottom || this.bottom < rect.top)

    ###
     * @param {Array} pointA start point of the line
     * @param {Array} pointB end point of the line
     * @returns true if the line intersects with the rectangle
     * @see http:#stackoverflow.com/questions/99353/how-to-test-if-a-line-segment-intersects-an-axis-aligned-rectange-in-2d/293052#293052
    ###
    collideLine: (p1, p2) ->
      x1 = p1[0]
      y1 = p1[1]
      x2 = p2[0]
      y2 = p2[1]

      linePosition = (point) ->
        x = point[0]
        y = point[1]
        return (y2 - y1) * x + (x1 - x2) * y + (x2 * y1 - x1 * y2)

      relPoses = [[this.left, this.top],
        [this.left, this.bottom],
        [this.right, this.top],
        [this.right, this.bottom]
      ].map(linePosition)

      noNegative = true
      noPositive = true
      noZero = true
      relPoses.forEach((relPos) ->
         if (relPos > 0)
           noPositive = false
         else if (relPos < 0)
           noNegative = false
         else if (relPos == 0)
           noZero = false
      , this)

      return false if ((noNegative || noPositive) && noZero)

      return !((x1 > this.right && x2 > this.right) ||
        (x1 < this.left && x2 < this.left) ||
        (y1 < this.top && y2 < this.top) ||
        (y1 > this.bottom && y2 > this.bottom))

    ###
      @returns {String} Like "[x, y][w, h]"
    ###
    toString: () ->
      return ["[", this.left, ",", this.top, "]"," [",this.width, ",", this.height, "]"].join("")

    ###
      @returns {gamejs.Rect} A new copy of this rect
    ###
    clone: () ->
      return new Rect(this)

