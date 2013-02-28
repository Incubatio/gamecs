require ['gamejs', 'surfacearray', 'utils/prng'], (gamejs, SurfaceArray, Alea) ->

  gamejs.ready () ->
    dims = [600, 400]
    # we will modify individual pixels directly, that's
    # easiest with a SurfaceArray
    display = gamejs.Display.setMode(dims)
    displayArray = new SurfaceArray(display)


    # the same seed will reproduce the same pattern
    # you can not use alea and pass nothing to Simplex and
    # it will use `Math.random()` instead.
    seed = new Date()
    alea = new Alea(seed)

    # asign pixel colors according to the noise
    simplex = new gamejs.Simplex(alea)
    for i in [0...dims[0]]
      for j in [0...dims[1]]
        val = simplex.get(i/50, j/50) * 255
        r = if val > 0 then val else 0
        b = if val < 0 then -val else 0
        displayArray.set(i, j, [r, 0, b])

    # and blit the modified array back to the display
    SurfaceArray.blitArray(display, displayArray)
