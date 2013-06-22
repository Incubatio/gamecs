define (require) ->
  ###
   * Binary Heap
   *
   * @see http:#eloquentjavascript.net/appendix2.html
   ###
  class BinaryHeap
    constructor: (scoreFunction) ->
      ### @ignore ###
      @content = []
      ### @ignore ###
      @scoreFunction = scoreFunction

    ###*
    * Add element to heap.
    * @param {Object} element
    ###
    push: (element) ->
      @content.push(element)
      @sinkDown(@content.length - 1)

    ###*
    * Return first element from heap.
    * @param {Object} element
    * @returns {Object} element
    ###
    pop: () ->
      # Store the first element so we can return it later.
      result = @content[0]
      # Get the element at the end of the array.
      end = @content.pop()
      # If there are any elements left, put the end element at the
      # start, and let it bubble up.
      if (@content.length > 0)
        @content[0] = end
        @bubbleUp(0)
      return result

    ###*
    * Remove the given element from the heap.
    * @param {Object} element
    * @throws {Error} if node not found
    ###
    remove: (node) ->
      # To remove a value, we must search through the array to find
      # it.
      isFound = @content.some((cNode, idx) ->
        if (cNode == node)
          end = @content.pop()
          if (idx != @content.length)
            @content[idx] = end
            if (@scoreFunction(end) < @scoreFunction(node))
              @sinkDown(idx)
            else
              @bubbleUp(idx)
          return true
        return false
      , this)
      #if (!isFound)
         #throw new Error("Node not found.")

    ###* Number of elements in heap.  ###
    size: () ->
      return @content.length

    ###* @ignore ###
    sinkDown: (idx) ->
      # Fetch the element that has to be sunk
      element = @content[idx]
      # When at 0, an element can not sink any further.
      while (idx > 0)
        # Compute the parent element's index, and fetch it.
        parentIdx = Math.floor((idx + 1) / 2) - 1
        parent = @content[parentIdx]
        # Swap the elements if the parent is greater.
        if (@scoreFunction(element) < @scoreFunction(parent))
          @content[parentIdx] = element
          @content[idx] = parent
          # Update 'n' to continue at the new position.
          idx = parentIdx
        # Found a parent that is less, no need to sink any further.
        else
          break


    ###* @ignore ###
    bubbleUp: (idx) ->
      # Look up the target element and its score.
      length = @content.length
      element = @content[idx]
      elemScore = @scoreFunction(element)

      while(true)
        # Compute the indices of the child elements.
        child2Idx = (idx + 1) * 2
        child1Idx= child2Idx - 1
        # This is used to store the new position of the element,
        # if any.
        swapIdx = null
        # If the first child exists (is inside the array)...
        if (child1Idx < length)
          # Look it up and compute its score.
          child1 = @content[child1Idx]
          child1Score = @scoreFunction(child1)
          # If the score is less than our element's, we need to swap.
          swapIdx = child1Idx if (child1Score < elemScore)
           
        # Do the same checks for the other child.
        if (child2Idx < length)
          child2 = @content[child2Idx]
          child2Score = @scoreFunction(child2)
          if (child2Score < (if swapIdx == null then elemScore else child1Score))
            swapIdx = child2Idx

        # If the element needs to be moved, swap it, and continue.
        if (swapIdx != null)
          @content[idx] = @content[swapIdx]
          @content[swapIdx] = element
          idx = swapIdx
        # Otherwise, we are done.
        else
          break
