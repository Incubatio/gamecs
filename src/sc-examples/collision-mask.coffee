###*
* @fileoverview
* Demonstrates pixel perfect collision detection utilizing image masks.
*
* A 'spear' is moved around with mouse or cursors keys - the text 'COLLISION'
* appears if the spear pixel collides with the unit.
*
* gamecs.mask.fromSurface is used to create two pixel masks
* that do the actual collision detection.
###

require ['gamecs', 'mask', 'utils/vectors'], (gamecs, mask, $v) ->
  main = () ->
    display = gamecs.Display.setMode([500, 350])
    spear = gamecs.Img.load(imgPath + 'spear.png')
    unit = gamecs.Img.load(imgPath + 'unit.png')

    # create image masks from surface
    mUnit = mask.fromSurface(unit)
    mSpear = mask.fromSurface(spear)

    unitPosition = [20, 20]
    spearPosition = [6, 0]

    font = new gamecs.Font('20px monospace')

    ###* tick ###
    tick = () ->
      # event handling
      gamecs.Key.get().forEach (event) ->
        direction = {}
        direction[gamecs.Key.K_UP] = [0, -1]
        direction[gamecs.Key.K_DOWN] = [0, 1]
        direction[gamecs.Key.K_LEFT] = [-1, 0]
        direction[gamecs.Key.K_RIGHT] = [1, 0]
        if (event.type == gamecs.Key.KEY_DOWN)
          delta = direction[event.key]
          spearPosition = $v.add(spearPosition, delta) if (delta)
        else if (event.type == gamecs.Key.MOUSE_MOTION)
          if (display.rect.collidePoint(event.pos))
            spearPosition = $v.subtract(event.pos, spear.getSize())

      # draw
      display.clear()
      display.blit(unit, unitPosition)
      display.blit(spear, spearPosition)
      # collision
      # the relative offset is automatically calculated by
      # the higher-level gamecs.sprite.collideMask(spriteA, spriteB)
      relativeOffset = $v.subtract(spearPosition, unitPosition)
      hasMaskOverlap = mUnit.overlap(mSpear, relativeOffset)
      if (hasMaskOverlap)
        display.blit(font.render('COLLISION', '#ff0000'), [250, 50])
      display.blit(font.render('Move with mouse or cursor keys.'), [10, 250])
    gamecs.Time.interval(tick)

  imgPath = 'assets/images/'
  images = [
     'spear.png',
     'unit.png'
  ].map((img) -> return imgPath + img)
  gamecs.preload(images)
  gamecs.ready(main)
