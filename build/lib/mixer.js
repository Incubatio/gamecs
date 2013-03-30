// Generated by CoffeeScript 1.4.0
(function() {

  define(function(require) {
    /**
    * @fileoverview Playing sounds with the html5 audio tag. Audio files must be preloaded
    * with the usual `gamecs.preload()` function. Ogg, wav and webm supported.
    *
    * Sounds & Images are loaded relative to './'.
    */

    var Mixer;
    return Mixer = (function() {
      var Sound;

      function Mixer() {}

      Mixer.CACHE = {};

      /**
      * need to export preloading status for require
      * @ignore
      */


      Mixer._PRELOADING = false;

      /**
      * @ignore
      */


      Mixer.NUM_CHANNELS = 8;

      /**
      * Sets the number of available channels for the mixer. The default value is 8.
      */


      Mixer.setNumChannels = function(count) {
        return this.NUM_CHANNELS = parseInt(count, 10) || this.NUM_CHANNELS;
      };

      Mixer.getNumChannels = function() {
        return this.NUM_CHANNELS;
      };

      /**
      * put all audios on page in cache
      * if same domain as current page, remove common href-prefix
      * @ignore
      */


      Mixer.init = function() {
        var audios;
        audios = Array.prototype.slice.call(document.getElementsByTagName("audio"), 0);
        this.addToCache(audios);
      };

      /**
      * Preload the audios into cache
      * @param {String[]} List of audio URIs to load
      * @returns {Function} which returns 0-1 for preload progress
      * @ignore
      */


      Mixer.preload = function(audioUrls, showProgressOrImage) {
        var audio, countLoaded, countTotal, errorHandler, getProgress, incrementLoaded, key, successHandler;
        countTotal = 0;
        countLoaded = 0;
        incrementLoaded = function() {
          countLoaded++;
          if (countLoaded === countTotal) {
            return this._PRELOADING = false;
          }
        };
        getProgress = function() {
          if (countTotal > 0) {
            return countLoaded / countTotal;
          } else {
            return 1;
          }
        };
        successHandler = function() {
          this.addToCache(this);
          return incrementLoaded();
        };
        errorHandler = function() {
          incrementLoaded();
          throw new Error('Error loading ' + this.src);
        };
        for (key in audioUrls) {
          if (key.indexOf('wav') === -1 && key.indexOf('ogg') === -1 && key.indexOf('webm') === -1) {
            continue;
          }
          countTotal++;
          audio = new Audio();
          audio.addEventListener('canplay', successHandler, true);
          audio.addEventListener('error', errorHandler, true);
          audio.src = audioUrls[key];
          audio.gamecsKey = key;
          audio.load();
        }
        if (countTotal > 0) {
          this._PRELOADING = true;
        }
        return getProgress;
      };

      /** @ignore
      */


      Mixer.isPreloading = function() {
        return this._PRELOADING;
      };

      /**
      * @param {dom.ImgElement} audios the <audio> elements to put into cache
      * @ignore
      */


      Mixer.addToCache = function(audios) {
        var docLoc;
        if (!(audios instanceof Array)) {
          audios = [audios];
        }
        docLoc = document.location.href;
        audios.forEach(function(audio) {
          return this.CACHE[audio.gamecsKey] = audio;
        });
      };

      /**
      * Sounds can be played back.
      * @constructor
      * @param {String|dom.AudioElement} uriOrAudio the uri of <audio> dom element
      *                of the sound
      */


      Sound = (function() {

        function Sound(uriOrAudio) {
          var audio, cachedAudio, channels, i;
          cachedAudio = typeof uriOrAudio === 'string' ? this.CACHE[uriOrAudio] : uriOrAudio;
          if (!cachedAudio) {
            /* TODO sync audio loading
            */

            throw new Error('Missing "' + uriOrAudio + '", gamecs.preload() all audio files before loading');
          }
          channels = [];
          i = NUM_CHANNELS;
          while (i-- > 0) {
            audio = new Audio();
            audio.preload = "auto";
            audio.loop = false;
            audio.src = cachedAudio.src;
            channels.push(audio);
          }
        }

        /**
        * start the sound
        * @param {Boolean} loop whether the audio should loop for ever or not
        */


        Sound.prototype.play = function(myLoop) {
          return channels.some(function(audio) {
            if (audio.ended || audio.paused) {
              audio.loop = !!myLoop;
              audio.play();
              return true;
            }
            return false;
          });
        };

        /**
        * Stop the sound.
        * This will stop the playback of this Sound on any active Channels.
        */


        Sound.prototype.stop = function() {
          return channels.forEach(function(audio) {
            return audio.stop();
          });
        };

        /**
        * Set volume of this sound
        * @param {Number} value volume from 0 to 1
        */


        Sound.prototype.setVolume = function(value) {
          return channels.forEach(function(audio) {
            return audio.volume = value;
          });
        };

        /**
        * @returns {Number} the sound's volume from 0 to 1
        */


        Sound.prototype.getVolume = function() {
          return channels[0].volume;
        };

        /**
        * @returns {Number} Duration of this sound in seconds
        */


        Sound.prototype.getLength = function() {
          return channels[0].duration;
        };

        return Sound;

      })();

      return Mixer;

    })();
  });

}).call(this);