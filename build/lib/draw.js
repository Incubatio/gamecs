// Generated by CoffeeScript 1.4.0
(function() {

  define(function(require) {
    var Draw;
    return Draw = (function() {

      function Draw() {}

      /**
      * @fileoverview Utilities for drawing geometrical objects to Surfaces. If you want to put images on
      * the screen see `gamecs.image`.
      *
      * *** Colors
      * There are several ways to specify colors. Whenever the docs says "valid #RGB string"
      * you can pass in any of the following formats.
      *
      *
      * @example
      *     "#ff00ff"
      *     "rgb(255, 0, 255)"
      *     "rgba(255,0, 255, 1)"
      */


      /** FIXME all draw functions must return a minimal rect containing the drawn shape
      */


      /**
      * @param {gamecs.Surface} surface the Surface to draw on
      * @param {String} color valid #RGB string, e.g., "#ff0000"
      * @param {Array} startPos [x, y] position of line start
      * @param {Array} endPos [x, y] position of line end
      * @param {Number} width of the line, defaults to 1
      */


      Draw.line = function(surface, color, startPos, endPos, width) {
        var ctx;
        ctx = surface.context;
        ctx.save();
        ctx.beginPath();
        ctx.strokeStyle = color;
        ctx.lineWidth = width || 1;
        ctx.moveTo(startPos[0], startPos[1]);
        ctx.lineTo(endPos[0], endPos[1]);
        ctx.stroke();
        ctx.restore();
      };

      /**
      * Draw connected lines. Use this instead of indiviudal line() calls for
      * better performance
      *
      * @param {gamecs.Surface} surface the Surface to draw on
      * @param {String} color a valid #RGB string, "#ff0000"
      * @param {Boolean} closed if true the last and first point are connected
      * @param {Array} pointlist holding array [x,y] arrays of points
      * @param {Number} width width of the lines, defaults to 1
      */


      Draw.lines = function(surface, color, closed, pointlist, width) {
        var ctx;
        closed = closed || false;
        ctx = surface.context;
        ctx.save();
        ctx.beginPath();
        ctx.strokeStyle = ctx.fillStyle = color;
        ctx.lineWidth = width || 1;
        pointlist.forEach(function(point, idx) {
          if (idx === 0) {
            return ctx.moveTo(point[0], point[1]);
          } else {
            return ctx.lineTo(point[0], point[1]);
          }
        });
        if (closed) {
          ctx.lineTo(pointlist[0][0], pointlist[0][1]);
        }
        ctx.stroke();
        ctx.restore();
      };

      /**
      * Draw a circle on Surface
      *
      * @param {gamecs.Surface} surface the Surface to draw on
      * @param {String} color a valid #RGB String, #ff00cc
      * @param {Array} pos [x, y] position of the circle center
      * @param {Number} radius of the circle
      * @param {Number} width width of the circle, if not given or 0 the circle is filled
      */


      Draw.circle = function(surface, color, pos, radius, width) {
        var ctx;
        if (!radius) {
          throw new Error('[circle] radius required argument');
        }
        if (!pos || !(pos instanceof Array)) {
          throw new Error('[circle] pos must be given & array' + pos);
        }
        ctx = surface.context;
        ctx.save();
        ctx.beginPath();
        ctx.strokeStyle = ctx.fillStyle = color;
        ctx.lineWidth = width || 1;
        ctx.arc(pos[0], pos[1], radius, 0, 2 * Math.PI, true);
        if (width === void 0 || width === 0) {
          ctx.fill();
        } else {
          ctx.stroke();
        }
        ctx.restore();
      };

      /**
      * @param {gamecs.Surface} surface the Surface to draw on
      * @param {String} color a valid #RGB String, #ff00cc
      * @param {gamecs.Rect} rect the position and dimension attributes of this Rect will be used
      * @param {Number} width the width of line drawing the Rect, if 0 or not given the Rect is filled.
      */


      Draw.rect = function(surface, color, rect, width) {
        var ctx;
        ctx = surface.context;
        ctx.save();
        ctx.beginPath();
        ctx.strokeStyle = ctx.fillStyle = color;
        if (isNaN(width) || width === 0) {
          ctx.fillRect(rect.left, rect.top, rect.width, rect.height);
        } else {
          ctx.lineWidth = width || 1;
          ctx.strokeRect(rect.left, rect.top, rect.width, rect.height);
        }
        return ctx.restore();
      };

      /**
      * @param {gamecs.Surface} surface the Surface to draw on
      * @param {String} color a valid #RGB String, #ff00cc
      * @param {gamecs.Rect} rect the position and dimension attributes of this Rect will be used
      * @param {Number} startAngle
      * @param {Number} stopAngle
      * @param {Number} width the width of line, if 0 or not given the arc is filled.
      */


      Draw.arc = function(surface, color, rect, startAngle, stopAngle, width) {
        var ctx;
        ctx = surface.context;
        ctx.save();
        ctx.beginPath();
        ctx.strokeStyle = ctx.fillStyle = color;
        ctx.arc(rect.center[0], rect.center[1], rect.width / 2, startAngle * (Math.PI / 180), stopAngle * (Math.PI / 180), false);
        if (isNaN(width) || width === 0) {
          ctx.fill();
        } else {
          ctx.lineWidth = width || 1;
          ctx.stroke();
        }
        return ctx.restore();
      };

      /**
      * Draw a polygon on the surface. The pointlist argument are the vertices
      * for the polygon.
      *
      * @param {gamecs.Surface} surface the Surface to draw on
      * @param {String} color a valid #RGB String, #ff00cc
      * @param {Array} pointlist array of vertices [x, y] of the polygon
      * @param {Number} width the width of line, if 0 or not given the polygon is filled.
      */


      Draw.polygon = function(surface, color, pointlist, width) {
        var ctx;
        ctx = surface.context;
        ctx.save();
        ctx.fillStyle = ctx.strokeStyle = color;
        ctx.beginPath();
        pointlist.forEach(function(point, idx) {
          if (idx === 0) {
            return ctx.moveTo(point[0], point[1]);
          } else {
            return ctx.lineTo(point[0], point[1]);
          }
        });
        ctx.closePath();
        if (isNaN(width) || width === 0) {
          ctx.fill();
        } else {
          ctx.lineWidth = width || 1;
          ctx.stroke();
        }
        return ctx.restore();
      };

      return Draw;

    })();
  });

}).call(this);
