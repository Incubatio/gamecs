###*
* @fileoverview
* Draw lines, polygons, circles, etc on the screen.
* Render text in a certain font to the screen.
###
require ['gamecs', 'draw', 'font'], (gamecs, Draw, Font) ->
  main = () ->
    # set resolution & title
    display = gamecs.Display.setMode([600, 400])
    gamecs.Display.setCaption("Example Draw")

    colorOne = '#ff0000'
    colorTwo = 'rgb(255, 50, 60)'
    colorThree = 'rgba(50, 0, 150, 0.8)'

    # All gamecs.draw methods share the same parameter order:
    #
    #  * surface
    #  * color
    #  * position related: gamecs.Rect or [x,y] or array of [x, y]
    #  * [second position if line]
    #  * [radius if circle]
    #  * line width 0 line width = fill the structure

    # surface, color, startPos, endPos, width
    Draw.line(display, colorOne, [0,0], [100,100], 1)
    Draw.lines(display, colorOne, true, [[50,50], [100,50], [100,100], [50,100]], 4)

    Draw.polygon(display, colorTwo, [[155,35], [210,50], [200,100]], 0)

    # surface, color, center, radius, width
    Draw.circle(display, colorThree, [150, 150], 50, 10)
    Draw.circle(display, '#ff0000', [250, 250], 50, 0)

    # surface, color, rect, width
    Draw.rect(display, '#aaaaaa', new gamecs.Rect([10, 150], [20, 20]), 2)
    Draw.rect(display, '#555555', new gamecs.Rect([50, 150], [20, 20]), 0)
    Draw.rect(display, '#aaaaaa', new gamecs.Rect([90, 150], [20, 20]), 10)

    # Font object, create with css font definition
    defaultFont = new Font("20px Verdana")
    # render() returns a white transparent Surface containing the text (default color: black)
    textSurface = defaultFont.render("Example Draw Test 101", "#bbbbbb")
    display.blit(textSurface, [300, 50])

  # gamecs.ready will call your main 
  # once all components and resources are ready.
  gamecs.ready(main)
