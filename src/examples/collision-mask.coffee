###*
* @fileoverview
* Demonstrates pixel perfect collision detection utilizing image masks.
*
* A 'spear' is moved around with mouse or cursors keys - the text 'COLLISION'
* appears if the spear pixel collides with the unit.
*
* gamejs.mask.fromSurface is used to create two pixel masks
* that do the actual collision detection.
###

require ['gamejs', 'mask', 'utils/vectors'], (gamejs, mask, $v) ->
  main = () ->
    display = gamejs.Display.setMode([500, 350])
    spear = gamejs.Img.load(imgPath + 'spear.png')
    unit = gamejs.Img.load(imgPath + 'unit.png')

    # create image masks from surface
    mUnit = mask.fromSurface(unit)
    mSpear = mask.fromSurface(spear)

    unitPosition = [20, 20]
    spearPosition = [6, 0]

    font = new gamejs.Font('20px monospace')

    ###* tick ###
    tick = () ->
      # event handling
      gamejs.Key.get().forEach (event) ->
        direction = {}
        direction[gamejs.Key.K_UP] = [0, -1]
        direction[gamejs.Key.K_DOWN] = [0, 1]
        direction[gamejs.Key.K_LEFT] = [-1, 0]
        direction[gamejs.Key.K_RIGHT] = [1, 0]
        if (event.type == gamejs.Key.KEY_DOWN)
          delta = direction[event.key]
          spearPosition = $v.add(spearPosition, delta) if (delta)
        else if (event.type == gamejs.Key.MOUSE_MOTION)
          if (display.rect.collidePoint(event.pos))
            spearPosition = $v.subtract(event.pos, spear.getSize())

      # draw
      display.clear()
      display.blit(unit, unitPosition)
      display.blit(spear, spearPosition)
      # collision
      # the relative offset is automatically calculated by
      # the higher-level gamejs.sprite.collideMask(spriteA, spriteB)
      relativeOffset = $v.subtract(spearPosition, unitPosition)
      hasMaskOverlap = mUnit.overlap(mSpear, relativeOffset)
      if (hasMaskOverlap)
        display.blit(font.render('COLLISION', '#ff0000'), [250, 50])
      display.blit(font.render('Move with mouse or cursor keys.'), [10, 250])
    gamejs.Time.interval(tick)

  imgPath = 'assets/images/'
  images = [
     'spear.png',
     'unit.png'
  ].map((img) -> return imgPath + img)
  gamejs.preload(images)
  gamejs.ready(main)
