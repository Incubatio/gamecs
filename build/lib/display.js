// Generated by CoffeeScript 1.4.0
(function() {

  define(function(require) {
    var Display, Surface;
    Surface = require('surface');
    /**
    * @fileoverview Methods to create, access and manipulate the display Surface.
    *
    * @example
    * display = gamecs.display.setMode([800, 600])
    * // blit sunflower picture in top left corner of display
    * sunflower = gamecs.image.load("images/sunflower")
    * display.blit(sunflower)
    *
    */

    return Display = (function() {
      var CANVAS_ID, CONTAINER_ID, DISABLE_SMOOTHING, LOADER_ID, getCanvas, layers, _SURFACE_SMOOTHING;

      function Display() {}

      CONTAINER_ID = "gcs-container";

      CANVAS_ID = "gcs-canvas";

      LOADER_ID = "gcs-loader";

      layers = {};

      /**
      * Pass this flag to `gamecs.display.setMode(resolution, flags)` to disable
      * pixel smoothing; this is, for example, useful for retro-style, low resolution graphics
      * where you don't want the browser to smooth them when scaling & drawing.
      */


      DISABLE_SMOOTHING = 2;

      _SURFACE_SMOOTHING = true;

      /**
      * @param {String} [id] id of the canvas dom element
      * @returns {document.Element} the canvas dom element
      */


      getCanvas = function(id) {
        var canvasId;
        canvasId = id || CANVAS_ID;
        return document.getElementById(canvasId);
      };

      /**
      * Create the master Canvas plane.
      * @ignore
      */


      Display.init = function() {
        /** create canvas element if not yet present
        */

        var gameContainer, loader;
        gameContainer = document.getElementById(CONTAINER_ID);
        if (gameContainer === null) {
          gameContainer = document.createElement("div");
          gameContainer.setAttribute("id", CONTAINER_ID);
          document.body.appendChild(gameContainer);
        }
        gameContainer.setAttribute("tabindex", 1);
        gameContainer.focus();
        /** remove loader if any
        */

        loader = document.getElementById(LOADER_ID);
        if (loader) {
          return loader.style.display = "none";
        }
      };

      /** @ignore
      */


      Display._isSmoothingEnabled = function() {
        return _SURFACE_SMOOTHING === true;
      };

      /**
      * Set the width and height of the Display. Conviniently this will
      * return the actual display Surface - the same as calling [gamecs.display.getSurface()](#getSurface))
      * later on.
      * @param {Array} dimensions [width, height] of the display surface
      * @param {String} [id] id of the canvas dom element
      */


      Display.setMode = function(dimensions, id, flags) {
        var canvas, canvasId, gameContainer;
        canvasId = id || CANVAS_ID;
        gameContainer = document.getElementById(CONTAINER_ID);
        gameContainer.style.width = dimensions[0] + "px";
        gameContainer.style.height = dimensions[1] + "px";
        canvas = getCanvas(canvasId);
        if (canvas === null) {
          canvas = document.createElement("canvas");
          canvas.setAttribute("id", canvasId);
          canvas.style.position = "absolute";
          canvas.onclick = function() {
            return gameContainer.focus();
          };
          gameContainer.appendChild(canvas);
        }
        canvas.width = dimensions[0];
        canvas.height = dimensions[1];
        _SURFACE_SMOOTHING = flags !== DISABLE_SMOOTHING;
        return this.getSurface(canvasId);
      };

      /**
      * Set the Caption of the Display (document.title)
      * @param {String} title the title of the app
      * @param {gamecs.Image} icon FIXME implement favicon support
      */


      Display.setCaption = function(title, icon) {
        return document.title = title;
      };

      Display.getSurfaces = function() {
        return layers;
      };

      /**
      * Drawing on the Surface returned by `getSurface()` will draw on the screen.
      * @param {String} [id] id of the canvas dom element
      * @returns {gamecs.Surface} the display Surface
      */


      Display.getSurface = function(id) {
        var canvas, canvasId, surface;
        canvasId = id || CANVAS_ID;
        if (!layers[canvasId]) {
          canvas = getCanvas(id);
          surface = new Surface([canvas.clientWidth, canvas.clientHeight]);
          surface._canvas = canvas;
          surface._context = canvas.getContext('2d');
          layers[canvasId] = surface;
        }
        return layers[canvasId];
      };

      return Display;

    })();
  });

}).call(this);
