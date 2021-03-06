define (require) ->

  elem = document.createElement('audio')
  bool = false

  try
    if ( bool = !!elem.canPlayType )
      bool      = new Boolean(bool)
      bool.ogg  = elem.canPlayType('audio/ogg; codecs="vorbis"').replace(/^no$/,'')
      bool.mp3  = elem.canPlayType('audio/mpeg;')               .replace(/^no$/,'')

      bool.wav  = elem.canPlayType('audio/wav; codecs="1"')     .replace(/^no$/,'')
      bool.m4a  = (elem.canPlayType('audio/x-m4a;') || elem.canPlayType('audio/aac;')).replace(/^no$/,'')
  catch error
    console.log error

  ###*
  * @fileoverview Playing sounds with the html5 audio tag. Audio files must be preloaded
  * with the usual `gamecs.preload()` function. Ogg, wav and webm supported.
  *
  * Sounds & Images are loaded relative to './'.
  ###
  class Mixer

    @CACHE = {}

    @support = bool
    ###*
    * need to export preloading status for require
    * @ignore
    ###
    @_PRELOADING = false

    ###*
    * @ignore
    ###
    @NUM_CHANNELS = 8

    ###*
    * Sets the number of available channels for the mixer. The default value is 8.
    ###
    @setNumChannels: (count) ->
      Mixer.NUM_CHANNELS = parseInt(count, 10) || Mixer.NUM_CHANNELS

    @getNumChannels: () ->
      return Mixer.NUM_CHANNELS

    ###*
    * put all audios on page in cache
    * if same domain as current page, remove common href-prefix
    * @ignore
    ###
    @init: () ->
      audios = Array.prototype.slice.call(document.getElementsByTagName("audio"), 0)
      Mixer.addToCache(audios)
      return

    ###*
    * Preload the audios into cache
    * @param {String[]} List of audio URIs to load
    * @returns {Function} which returns 0-1 for preload progress
    * @ignore
    ###
    @preload = (audioUrls, showProgressOrImage) ->
      countTotal = 0
      countLoaded = 0

      incrementLoaded = () ->
        countLoaded++
        Mixer._PRELOADING = false if (countLoaded == countTotal)

      getProgress = () ->
        if countTotal > 0 then countLoaded / countTotal else 1

      successHandler = () ->
        Mixer.addToCache(this)
        incrementLoaded()

      errorHandler = () ->
        incrementLoaded()
        throw new Error('Error loading ' + @src)

      for key of audioUrls
        continue if (key.indexOf('wav') == -1 && key.indexOf('ogg') == -1 && key.indexOf('webm') == -1 && key.indexOf('mp3') == -1 && key.indexOf('m4a') == -1 && key.indexOf('mpeg') == -1)

        countTotal++
        audio = new Audio()
        audio.addEventListener('canplay', successHandler, true)
        audio.addEventListener('error', errorHandler, true)
        audio.src = audioUrls[key]
        audio.gamecsInput = key
        audio.load()

      Mixer._PRELOADING = true if (countTotal > 0)

      return getProgress

    ###* @ignore ###
    @isPreloading = () ->
      return Mixer._PRELOADING

    ###*
    * @param {dom.ImgElement} audios the <audio> elements to put into cache
    * @ignore
    ###
    @addToCache: (audios) ->
      
      audios = [audios] if !(audios instanceof Array)

      docLoc = document.location.href
      audios.forEach((audio) ->
        Mixer.CACHE[audio.gamecsInput] = audio
      )
      return

    ###*
    * Sounds can be played back.
    * @constructor
    * @param {String|dom.AudioElement} uriOrAudio the uri of <audio> dom element
    *                of the sound
    ###
    @Sound: class
      constructor: (uriOrAudio) ->
        cachedAudio = if (typeof uriOrAudio == 'string') then Mixer.CACHE[uriOrAudio] else uriOrAudio
        if (!cachedAudio)
          ### TODO sync audio loading ###
          throw new Error('Missing "' + uriOrAudio + '", gamecs.preload() all audio files before loading')

        @channels = []
        i = Mixer.NUM_CHANNELS
        while (i-->0)
          audio = new Audio()
          audio.preload = "auto"
          audio.loop = false
          audio.src = cachedAudio.src
          @channels.push(audio)

      ###*
      * start the sound
      * @param {Boolean} loop whether the audio should loop for ever or not
      ###
      play: (myLoop) ->
        @channels.some((audio) ->
          if (audio.ended || audio.paused)
            audio.loop = !!myLoop
            audio.play()
            return true
          return false
        )

      ###*
      * Stop the sound.
      * This will stop the playback of this Sound on any active Channels.
      ###
      stop: () ->
        @channels.forEach((audio) ->
          audio.stop()
        )

      ###*
      * Set volume of this sound
      * @param {Number} value volume from 0 to 1
      ###
      setVolume: (value) ->
        @channels.forEach((audio) ->
          audio.volume = value
        )

      ###*
      * @returns {Number} the sound's volume from 0 to 1
      ###
      getVolume: () ->
        return @channels[0].volume

      ###*
      * @returns {Number} Duration of this sound in seconds
      ###
      getLength: () ->
        return @channels[0].duration

      #return this
