// Generated by CoffeeScript 1.4.0
(function() {

  define(function(require) {
    var Arrays, Objects, Sprite, Vector;
    Arrays = require('utils/arrays');
    Objects = require('utils/objects');
    Vector = require('utils/vectors');
    /**
    * @fileoverview Provides `Sprite` the basic building block for any game and
    * `SpriteGroups`, which are an efficient
    * way for doing collision detection between groups as well as drawing layered
    * groups of objects on the screen.
    *
    */

    return Sprite = (function() {
      /** @ignore
      */

      Sprite.prototype._groups = [];

      /** @ignore
      */


      Sprite.prototype._alive = true;

      /**
      * Image to be rendered for this Sprite.
      * @type gamecs.Surface
      */


      Sprite.image = null;

      /**
      * Rect describing the position of this sprite on the display.
      * @type gamecs.Rect
      */


      Sprite.rect = null;

      /**
      * Your visible game objects will typically subclass Sprite. By setting it's image
      * and rect attributes you can control its appeareance. Those attributes control
      * where and what `Sprite.draw(surface)` will blit on the the surface.
      *
      * Your subclass should overwrite `update(msDuration)` with its own implementation.
      * This function is called once every game tick, it is typically used to update
      * the status of that object.
      * @constructor
      */


      function Sprite() {
        /** List of all groups that contain this sprite.
        */
        Objects.accessor(this, 'groups', function() {
          return this._groups;
        });
      }

      /**
      * Kill this sprite. This removes the sprite from all associated groups and
      * makes future calls to `Sprite.isDead()` return `true`
      */


      Sprite.prototype.kill = function() {
        this._alive = false;
        return this._groups.forEach(function(group) {
          return group.remove(this);
        }, this);
      };

      /**
      * Remove the sprite from the passed groups
      * @param {Array|gamecs.sprite.Group} groups One or more `gamecs.Group`
      * instances
      */


      Sprite.prototype.remove = function(groups) {
        if (!(groups instanceof Array)) {
          groups = [groups];
        }
        return groups.forEach(function(group) {
          return group.remove(this);
        }, this);
      };

      /**
      * Add the sprite to the passed groups
      * @param {Array|gamecs.sprite.Group} groups One or more `gamecs.sprite.Group`
      * instances
      */


      Sprite.prototype.add = function(groups) {
        if (!(groups instanceof Array)) {
          groups = [groups];
        }
        return groups.forEach(function(group) {
          return group.add(this);
        }, this);
      };

      /**
      * Returns an array of all the Groups that contain this Sprite.
      * @returns {Array} an array of groups
      */


      Sprite.prototype.groups = function() {
        return this._groups.slice(0);
      };

      /**
      * Draw this sprite onto the given surface. The position is defined by this
      * sprite's rect.
      * @param {gamecs.Surface} surface The surface to draw on
      */


      Sprite.prototype.draw = function(surface) {
        return surface.blit(this.image, this.rect);
      };

      /**
      * Update this sprite. You **should** override this method with your own to
      * update the position, status, etc.
      */


      Sprite.prototype.update = function() {};

      /**
      * @returns {Boolean} True if this sprite has had `Sprite.kill()` called on it
      * previously, otherwise false
      */


      Sprite.prototype.isDead = function() {
        return !this._alive;
      };

      return Sprite;

    })();
  });

}).call(this);
