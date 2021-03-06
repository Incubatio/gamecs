define (require) ->
  "use strict"
  ###*
  * @fileoverview Make synchronous http requests to your game's serverside component.
  *
  * If you configure a ajax base URL you can make http requests to your
  * server using those functions.
  *
  * The most high-level functions are `load()` and `save()` which take
  * and return a JavaScript object, which they will send to / recieve from
  * the server-side in JSON format.
  *
  * @example
  *
  *     <script>
  *     // Same Origin policy applies! You can only make requests
  *     // to the server from which the html page is served.
  *      $g = {
  *         ajaxBaseHref: "http://the-same-server.com/ajax/"
  *      }
  *      </script>
  *      <script src="./public/gamecs-wrapped.js"></script>
  *      ....
  *      typeof gamecs.load('userdata/') === 'object'
  *      typeof gamecs.get('userdata/') === 'string'
  *      ...
  *
  ###
  class Http
    ###*
    * Response object returned by http functions `get` and `post`. This
    * class is not instantiable.
    *
    * @param{String} responseText
    * @param {String} responseXML
    * @param {Number} status
    * @param {String} statusText
    ###
    @Response: () ->
      ###* @param {String} header ###
      @getResponseHeader = (header) ->
      # TODO: check why empty func above ?
      throw new Error('response class not instantiable')

    ###*
    * Make http request to server-side
    * @param {String} method http method
    * @param {String} url
    * @param {String|Object} data
    * @param {String|Object} type "Accept" header value
    * @return {Response} response
    ###
    @ajax: (method, url, data, type) ->
      data = data || null
      response = new XMLHttpRequest()
      response.open(method, url, false)

      response.setRequestHeader("Accept", type) if (type)
        
      if (data instanceof Object)
        data = JSON.stringify(data)
        response.setRequestHeader('Content-Type', 'application/json')
      response.setRequestHeader('X-Requested-With', 'XMLHttpRequest')
      response.send(data)
      return response

    ###*
    * Make http GET request to server-side
    * @param {String} url
    ###
    @get: (url) ->
      return @ajax('GET', url)

    ###
     * Make http POST request to server-side
     * @param {String} url
     * @param {String|Object} data
     * @param {String|Object} type "Accept" header value
     * @returns {Response}
     ###
    @post: (url, data, type) ->
      return @ajax('POST', url, data, type)

    @stringify: (response) ->
      ### eval is evil ###
      return eval('(' + response.responseText + ')')

    @ajaxBaseHref: () ->
      return (window.$g && window.$g.ajaxBaseHref) || './'

    ###
     * Load an object from the server-side.
     * @param {String} url
     * @return {Object} the object loaded from the server
     ###
    @load: (url) ->
      return @stringify(@get(@ajaxBaseHref() + url))


    ###
     * Send an object to a server-side function.
     * @param {String} url
     * @param {String|Object} data
     * @param {String|Object} type "Accept" header value
     * @returns {Object} the response object
     ###
    @save: (url, data, type) ->
      return @stringify(@post(@ajaxBaseHref() + url, {payload: data}, type))
