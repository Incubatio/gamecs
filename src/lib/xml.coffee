define (require) ->

  ###
  * @fileoverview
  *
  * Provides facilities for parsing an xml String.
  * 
  * You will typically get a `gamecs.xml.Document` instance
  * by loading the data with one of the two static 
  * `Document.fromString(string)` or `Document.fromUrl(url)`.
  *
  * Querying for `elements(name)` or `children()` will return a
  * new `gamecs.xml.Document` matching your result (or null).
  *
  * Use `attributes(name)` and `value()` to get the data stored
  * in the XML Document.
  ###

  ###*
  * XMLParser
  ###
  class Parser
    constructor: () ->

      xmlDoc = null
      parser = new DOMParser()
      
      @parseFromString = (xmlString) ->
        xmlDoc = parser.parseFromString(xmlString, 'text/xml')
        return xmlDoc
      

    ###*
    * Instantiate with the static functions `Document.fromString()` and `fromURL()`.
    ###
    class Document
      constructor: (xmlDocument) ->
        if (!xmlDocument || (!xmlDocument instanceof XMLDocument) )
          throw new Error('Need a valid xmlDocument.')
        ### @ignore *###
        @_xmlDocument = xmlDocument
        return this

      ###*
      * Returns the first element in the current document whose tag-name matches
      * the given 'name'.
      * @returns gamecs.xml.Document
      ###
      element: (name) ->
        elem = @_xmlDocument.getElementsByTagName(name)[0]
        return elem && new Document(elem) || null

      ###*
      * Returns all elements in the current document whose tag-name matches
      * the given 'name'.
      * @returns an Array of gamecs.xml.Document
      ###
      elements: (name) ->
        elems = @_xmlDocument.getElementsByTagName(name)
        return Array.prototype.slice.apply(elems, [0]).map((elem) ->
          return new Document(elem)
        )

      ###*
      * Returns the attribute value of this document.
      *
      * @returns String
      ###
      attribute: (name) ->
        attributeValue = @_xmlDocument.getAttribute(name)
        attributeValue = if attributeValue then attributeValue.trim() else null
        return null if (attributeValue == null)

        return true if (attributeValue.toLowerCase() == 'true')

        return false if (attributeValue.toLowerCase() == 'false')

        attributeIntValue = parseInt(attributeValue, 10)
        attributeFloatValue = parseFloat(attributeValue, 10)
        if (!isNaN(attributeIntValue))
          if (attributeFloatValue != attributeIntValue)
            return attributeFloatValue
          return attributeIntValue
        return attributeValue

      ###*
      * Returns the nodevalue of the current xml document
      * @returns String
      ###
      value: () ->
         return @_xmlDocument.nodeValue

      ###*
      * Returns all children of this xml document
      * @returns Array of gamecs.xml.Document
      ###
      children: () ->
        return Array.prototype.slice.apply(@_xmlDocument.childNodes, [0]).map((cNode) ->
          return new Document(cNode)
        )

      ###*
      * @returns gamecs.xml.Document
      ###
      fromString: (xmlString) ->
        parser = new DOMParser()
        xmlDoc = parser.parseFromString(xmlString, 'text/xml')
        return new Document(xmlDoc)

      ###*
      * @returns gamecs.xml.Document
      ###
      fromURL: (url) ->
        response = new XMLHttpRequest()
        response.open('GET', url, false)
        response.setRequestHeader('X-Requested-With', 'XMLHttpRequest')
        response.setRequestHeader('Content-Type', 'text/xml')
        response.overrideMimeType('text/xml')
        response.send()
        return new Document(response.responseXML)
