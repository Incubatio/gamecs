###*
* A bare bones Sprite and sprite Group example.
*
* We move a lot of Ship sprites across the screen with varying speed. The sprites
* rotate themselves randomly. The sprites bounce back from the bottom of the
* screen.
###

require ['gamecs'], (gamecs) ->

  ###* The ship Sprite has a randomly rotated image und moves with random speed (upwards). ###
  class Ship extends gamecs.Sprite
    constructor: (rect) ->
      # call superconstructor
      super()
      this.speed = 20 + (40 * Math.random())
      # ever ship has its own scale
      this.originalImage = gamecs.Img.load("assets/images/ship.png")
      dims = this.originalImage.getSize()
      this.originalImage = gamecs.Transform.scale( this.originalImage, [dims[0] * (0.5 + Math.random()), dims[1] *  (0.5 + Math.random())])
      this.rotation = 50 + parseInt(120 * Math.random())
      this.image = gamecs.Transform.rotate(this.originalImage, this.rotation)
      this.rect = new gamecs.Rect(rect)

    update: (msDuration) ->
      # moveIp = move in place
      this.rect.moveIp(0, this.speed * (msDuration/1000))
      if (this.rect.top > 600)
        this.speed *= -1
        this.image = gamecs.Transform.rotate(this.originalImage, this.rotation + 180)
      else if (this.rect.top < 0 )
        this.speed *= -1
        this.image = gamecs.Transform.rotate(this.originalImage, this.rotation)

  main = () ->
    # screen setup
    gamecs.Display.setMode([600, 600])
    gamecs.Display.setCaption("Example Sprites")
    # create some ship sprites and put them in a group
    ship = new Ship([100, 100])
    gShips = new gamecs.Group()
    for j in [0...4]
      for i in [0...25]
        gShips.add(new Ship([10 + i*20, j * 20]))
    # game loop
    mainSurface = gamecs.Display.getSurface()
    # msDuration = time since last tick() call
    tick = (msDuration) ->
          mainSurface.fill("#FFFFFF")
          # update and draw the ships
          gShips.update(msDuration)
          gShips.draw(mainSurface)
    gamecs.Time.interval(tick)


  ###* MAIN ###
  gamecs.preload(['assets/images/ship.png'])
  gamecs.ready(main)
