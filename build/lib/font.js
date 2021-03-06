// Generated by CoffeeScript 1.4.0
(function() {

  define(function(require) {
    "use strict";

    var Font, Objects, Surface;
    Surface = require('surface');
    Objects = require('utils/objects');
    /**
    * @fileoverview Methods for creating Font Objects which can render text
    * to a Surface.
    *
    * @example
    *     // create a font
    *     font = new Font('20px monospace')
    *     // render text - this returns a surface with the text written on it.
    *     helloSurface = font.render('Hello World')
    */

    return Font = (function() {
      /**
      * Create a Font to draw on the screen. The Font allows you to
      * `render()` text. Rendering text returns a Surface which
      * in turn can be put on screen.
      *
      * @constructor
      * @property {Number} fontHeight the line height of this Font
      *
      * @param {String} fontSettings a css font definition, e.g., "20px monospace"
      * @param {STring} backgroundColor valid #rgb string, "#ff00cc"
      */

      function Font(fontSettings, backgroundColor) {
        /** @ignore
        */
        this.sampleSurface = new Surface([10, 10]);
        this.sampleSurface.context.font = fontSettings;
        this.sampleSurface.context.textAlign = 'start';
        /** http://diveintohtml5.org/canvas.html#text
        */

        this.sampleSurface.context.textBaseline = 'bottom';
        this.backgroundColor = backgroundColor || false;
        return this;
      }

      /**
      * Returns a Surface with the given text on it.
      * @param {String} text the text to render
      * @param {String} color a valid #RGB String, "#ffcc00"
      * @returns {gamecs.Surface} Surface with the rendered text on it.
      */


      Font.prototype.render = function(text, color) {
        var ctx, dims, surface;
        dims = this.size(text);
        surface = new Surface(dims);
        ctx = surface.context;
        ctx.save();
        if (this.backgroundColor) {
          ctx.fillStyle = this.backgroundColor;
          ctx.fillRect(0, 0, surface.rect.width, surface.rect.height);
        }
        ctx.font = this.sampleSurface.context.font;
        ctx.textBaseline = this.sampleSurface.context.textBaseline;
        ctx.textAlign = this.sampleSurface.context.textAlign;
        ctx.fillStyle = ctx.strokeStyle = color || "#000000";
        ctx.fillText(text, 0, surface.rect.height, surface.rect.width);
        ctx.restore();
        return surface;
      };

      /**
      * Determine the width and height of the given text if rendered
      * with this Font.
      * @param {String} text the text to measure
      * @returns {Array} the [width, height] of the text if rendered with this Font
      */


      Font.prototype.size = function(text) {
        var metrics;
        metrics = this.sampleSurface.context.measureText(text);
        /** FIXME measuretext is buggy, make extra wide
        */

        return [metrics.width, this.fontHeight];
      };

      /** Height of the font in pixels.
      */


      Objects.accessors(Font.prototype, {
        /**
        * Returns an approximate line height of the text
        * »This version of the specification does not provide a way to obtain
        * the bounding box dimensions of the text.«
        * see http://www.whatwg.org/specs/web-apps/current-work/multipage/the-canvas-element.html#dom-context-2d-measuretext
        */

        fontHeight: {
          get: function() {
            return this.sampleSurface.context.measureText('M').width * 1.5;
          }
        }
      });

      return Font;

    })();
  });

}).call(this);
