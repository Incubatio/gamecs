#gamecs = require('gamecs')

# gamecs.preload([])
require.config({
    paths:
      three: '../../assets/js/three'
    shim:
      three: { exports: "THREE"}
})

#require ['gamecs', 'engine3d'], (gamecs, Engine) ->
require ['gamecs', 'three', 'input'], (gamecs, THREE, Input) ->
  gamecs.ready () ->

    #layer1 = gamecs.Display.setMode([800, 800], 'layer1')
    #layer2 = gamecs.Display.setMode([400, 200], 'layer2')
    #layer1 = Engine.addLayer([400, 200], 'layer1')

    #layer1.blit((new gamecs.Font('30px Sans-serif')).render('Hello World'))
    #layer2.blit((new gamecs.Font('45px Sans-serif')).render('Hello World'))
    material = new THREE.MeshNormalMaterial( { color: 0xff0000, wireframe: false } )

    cubeSize1 = new THREE.CubeGeometry( 200, 200, 200 )
    cube1 = new THREE.Mesh( cubeSize1, material )

    cubeSize2 = new THREE.CubeGeometry( 200, 800, 1800 )
    cube2 = new THREE.Mesh( cubeSize2, material )
    cube3 = new THREE.Mesh( cubeSize2, material )
    running = true

    renderer = new THREE.CanvasRenderer()
    camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 1, 10000 )
    scene = new THREE.Scene()

    x = y = 0

    init = () ->
      camera.position.z = 1000

      cube2.position.x += 400
      cube2.position.z -= 150
      cube3.position.x -= 400
      cube3.position.z -= 150
      scene.add( cube1 )
      scene.add( cube2 )
      scene.add( cube3 )

      renderer.setSize( window.innerWidth, window.innerHeight )

      #document.body.appendChild( renderer.domElement )
      document.getElementById("gcs-container").appendChild(renderer.domElement)


    animate = () ->
      handleInput(Input.get())

      # note: three.js includes requestAnimationFrame shim
      if running
        requestAnimationFrame( animate )
        cube1.rotation.x += 0.01
        cube1.rotation.y += 0.02

      renderer.render( scene, camera )

    handleInput = (events) ->
      #mesh = camera.getMesh()
      #mesh.rotation.z += x/10;
      for e in events
        if e.type == Input.T_KEY_DOWN
          switch (e.key)
            when Input.K_UP,    Input.K_w then y = -1
            when Input.K_DOWN,  Input.K_s then y = 1
            when Input.K_LEFT,  Input.K_a then x = -1
            when Input.K_RIGHT, Input.K_d then x = 1
        else if e.type == Input.T_KEY_UP
          switch (e.key)
            when Input.K_UP,    Input.K_w then if (y < 0) then y = 0
            when Input.K_DOWN,  Input.K_s then if (y > 0) then y = 0
            when Input.K_LEFT,  Input.K_a then if (x < 0) then x = 0
            when Input.K_RIGHT, Input.K_d then if (x > 0) then x = 0

      r = false
      r = switch(true)
        when x == 1  then  0
        when x == -1 then 180
        when y == 1  then  270
        when y == -1 then 90
      #if(r !== false) then mesh.rotation.y = r
      if x != 0 || y != 0
        camera.position.y += -y * 10
        camera.position.x += x * 10

    window.stop = () ->
      running = false

    init()
    animate()

    ###*
    tick = (msDuration) -> 
      # game loop
      return
    }
    gamecs.time.interval(tick)
    ###
