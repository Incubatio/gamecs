define (require) ->
  Objects = require('utils/objects')
  ###*
  * Creates a Rect. Rects are used to hold rectangular areas. There are a couple
  * of convinient ways to create Rects with different arguments and defaults.
  * 
  * Any function that requires a `gamecs.Rect` argument also accepts any of the
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
  * @param {Array|gamecs.Rect} position Array holding left and top coordinates
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
          get: () -> return @top + @height

          set: (newValue) ->
            @top = newValue - @height
            return

        ###*
        * Right, X coordinate
        * @name Rect.prototype.right
        * @type Number
        ###
        right:
          get: () -> return @left + @width

          set: (newValue) ->
            @left = newValue - @width
            return

        ###*
        * Center Position. You can assign a rectangle form.
        * @name Rect.prototype.center
        * @type Array
        ###
        center:
          get: () ->
            return [@left + (@width / 2) | 0, @top + (@height / 2) | 0]

          set: (args...) ->
            args = Rect.normalizeArguments.apply(this, args)
            @left = args.left - (@width / 2) | 0
            @top = args.top - (@height / 2) | 0
            return

        ###*
        * Top-left Position. You can assign a rectangle form.
        * @name Rect.prototype.topleft
        * @type Array
        ###
        topleft:
          get: () ->
            return [@left, @top]
          set: (args...) ->
            args = Rect.normalizeArguments.apply(this, args)
            @left = args.left
            @top = args.top
            return

        ###*
        * Bottom-left Position. You can assign a rectangle form.
        * @name Rect.prototype.bottomleft
        * @type Array
        ###
        bottomleft:
          get: () ->
            return [@left, @bottom]

          set: (args...) ->
            args = Rect.normalizeArguments.apply(this, args)
            @left = args.left
            @bottom = args.top
            return

        ###*
        * Top-right Position. You can assign a rectangle form.
        * @name Rect.prototype.topright
        * @type Array
        ###
        topright:
          get: () ->
            return [@right, @top]

          set: (args...) ->
            args = Rect.normalizeArguments.apply(this, args)
            @right = args.left
            @top = args.top
            return

        ###*
        * Bottom-right Position. You can assign a rectangle form.
        * @name Rect.prototype.bottomright
        * @type Array
        ###
        bottomright:
          get: () ->
            return [@right, @bottom]

          set: (args...) ->
            args = Rect.normalizeArguments.apply(this, args)
            @right = args.left
            @bottom = args.top
            return

        ###*
        * Position x value, alias for `left`.
        * @name Rect.prototype.y
        * @type Array
        ###
        x:
          get: () ->
            return @left
          set: (newValue) ->
            @left = newValue
            return

        ###*
        * Position y value, alias for `top`.
        * @name Rect.prototype.y
        * @type Array
        ###
        y:
          get: () ->
            return @top
          set: (newValue) ->
            @top = newValue
            return



  class Rect
    constructor: (args...) ->
      args = Rect.normalizeArguments.apply(this, args)
      @init(args.left, args.top, args.width, args.height)
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
    * TODO: remove the method and normalize parameter all over application
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

      # TOTHINK: create a rect from a rect, it's like cloning
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
    * @param {Number|gamecs.Rect} x amount to move on x axis
    * @param {Number} y amount to move on y axis
    ###
    move: (args...) ->
      args = Rect.normalizeArguments.apply(this, args)
      return new Rect(@left + args.left, @top + args.top, @width, @height)

    ###*
    * Move this Rect in place - not returning a new Rect like `move(x, y)` would.
    * 
    * `moveIp(x,y)` or `moveIp([x,y])`
    * 
    * @param {Number|gamecs.Rect} x amount to move on x axis
    * @param {Number} y amount to move on y axis
    ###
    moveIp: (args...) ->
      args = Rect.normalizeArguments.apply(this, args)
      @left += args.left
      @top += args.top

    ###*
    * Return the area in which this Rect and argument Rect overlap.
    *
    * @param {gamecs.Rect} Rect to clip this one into
    * @returns {gamecs.Rect} new Rect which is completely inside the argument Rect,
    * zero sized Rect if the two rectangles do not overlap
    ###
    clip: (rect) ->
      return new Rect(0,0,0,0) if (!@collideRect(rect))

      ### Left ###
      if ((@left >= rect.left) && (@left < rect.right))
        x = @left
      else if ((rect.left >= @left) && (rect.left < @right))
        x = rect.left

      ### Right ###
      if ((@right > rect.left) && (@right <= rect.right))
        width = @right - x
      else if ((rect.right > @left) && (rect.right <= @right))
        width = rect.right - x

      ### Top ###
      if ((@top >= rect.top) && (@top < rect.bottom))
         y = @top
      else if ((rect.top >= @top) && (rect.top < @bottom))
         y = rect.top

      ### Bottom ###
      if ((@bottom > rect.top) && (@bottom <= rect.bottom))
        height = @bottom - y
      else if ((rect.bottom > @top) && (rect.bottom <= @bottom))
        height = rect.bottom - y

      return new Rect(x, y, width, height)

    ###*
    * Join two rectangles
    *
    * @param {gamecs.Rect} union with this rectangle
    * @returns {gamecs.Rect} rectangle containing area of both rectangles
    ###
    union: (rect) ->
       x = Math.min(@left, rect.left)
       y = Math.min(@top, rect.top)
       width  = Math.max(@right, rect.right) - x
       height = Math.max(@bottom, rect.bottom) - y
       return new Rect(x, y, width, height)

    ###
     * Grow or shrink the rectangle size
     *
     * @param {Number} amount to change in the width
     * @param {Number} amount to change in the height
     * @returns {gamecs.Rect} inflated rectangle centered on the original rectangle's center
    ###
    inflate: (x, y) ->
      copy = @clone()
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
      @left -= Math.floor(x / 2)
      @top -= Math.floor(y / 2)
      @width += x
      @height += y

    ###
     * Check for collision with a point.
     * 
     * `collidePoint(x,y)` or `collidePoint([x,y])` or `collidePoint(new Rect(x,y))`
     * 
     * @param {Array|gamecs.Rect} point the x and y coordinates of the point to test for collision
     * @returns {Boolean} true if the point collides with this Rect
    ###
    collidePoint: (args...) ->
     args = Rect.normalizeArguments.apply(this, args)
     return (@left <= args.left && args.left <= @right) &&
       (@top <= args.top && args.top <= @bottom)

    ###
     * Check for collision with a Rect.
     * @param {gamecs.Rect} rect the Rect to test check for collision
     * @returns {Boolean} true if the given Rect collides with this Rect
    ###
    collideRect: (rect) ->
      return !(@left > rect.right || @right < rect.left ||
        @top > rect.bottom || @bottom < rect.top)

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

      relPoses = [[@left, @top],
        [@left, @bottom],
        [@right, @top],
        [@right, @bottom]
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

      return !((x1 > @right && x2 > @right) ||
        (x1 < @left && x2 < @left) ||
        (y1 < @top && y2 < @top) ||
        (y1 > @bottom && y2 > @bottom))

    ###
      @returns {String} Like "[x, y][w, h]"
    ###
    toString: () ->
      return ["[", @left, ",", @top, "]"," [",@width, ",", @height, "]"].join("")

    ###
      @returns {gamecs.Rect} A new copy of this rect
    ###
    clone: () ->
      return new Rect(this)

