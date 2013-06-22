define (require) ->
  Surface = require('surface')
  Objects = require('utils/objects')

  ###*
  * @fileoverview Methods for creating Font Objects which can render text
  * to a Surface.
  *
  * @example
  *     // create a font
  *     font = new Font('20px monospace')
  *     // render text - this returns a surface with the text written on it.
  *     helloSurface = font.render('Hello World')
  ###
  class Font

    ###*
    * Create a Font to draw on the screen. The Font allows you to
    * `render()` text. Rendering text returns a Surface which
    * in turn can be put on screen.
    *
    * @constructor
    * @property {Number} fontHeight the line height of this Font
    *
    * @param {String} fontSettings a css font definition, e.g., "20px monospace"
    * @param {STring} backgroundColor valid #rgb string, "#ff00cc"
    ###
    constructor: (fontSettings, backgroundColor) ->
      ###* @ignore ###
      @sampleSurface = new Surface([10,10])
      @sampleSurface.context.font = fontSettings
      @sampleSurface.context.textAlign = 'start'
      ###* http://diveintohtml5.org/canvas.html#text ###
      @sampleSurface.context.textBaseline = 'bottom'
      @backgroundColor = backgroundColor || false
      return this

    ###*
    * Returns a Surface with the given text on it.
    * @param {String} text the text to render
    * @param {String} color a valid #RGB String, "#ffcc00"
    * @returns {gamecs.Surface} Surface with the rendered text on it.
    ###
    render: (text, color) ->
      dims = @size(text)
      surface = new Surface(dims)
      ctx = surface.context
      ctx.save()
      if ( @backgroundColor )
        ctx.fillStyle = @backgroundColor
        ctx.fillRect(0, 0, surface.rect.width, surface.rect.height)

      ctx.font = @sampleSurface.context.font
      ctx.textBaseline = @sampleSurface.context.textBaseline
      ctx.textAlign = @sampleSurface.context.textAlign
      ctx.fillStyle = ctx.strokeStyle = color || "#000000"
      ctx.fillText(text, 0, surface.rect.height, surface.rect.width)
      ctx.restore()
      return surface

    ###*
    * Determine the width and height of the given text if rendered
    * with this Font.
    * @param {String} text the text to measure
    * @returns {Array} the [width, height] of the text if rendered with this Font
    ###
    size: (text) ->
      metrics = @sampleSurface.context.measureText(text)
      ###* FIXME measuretext is buggy, make extra wide ###
      return [metrics.width, @fontHeight]

    ###* Height of the font in pixels.  ###
    Objects.accessors(Font.prototype,
      ###*
      * Returns an approximate line height of the text
      * »This version of the specification does not provide a way to obtain
      * the bounding box dimensions of the text.«
      * see http://www.whatwg.org/specs/web-apps/current-work/multipage/the-canvas-element.html#dom-context-2d-measuretext
      ###
      fontHeight:
        get: () ->
          return @sampleSurface.context.measureText('M').width * 1.5
    )
