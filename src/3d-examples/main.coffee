material = new THREE.MeshNormalMaterial( { color: 0xff0000, wireframe: false } )

cubeSize1 = new THREE.CubeGeometry( 200, 200, 200 )
cube1 = new THREE.Mesh( cubeSize1, material )

cubeSize2 = new THREE.CubeGeometry( 200, 800, 1800 )
cube2 = new THREE.Mesh( cubeSize2, material )
cube3 = new THREE.Mesh( cubeSize2, material )
$container = $('#container')
running = true

renderer = new THREE.CanvasRenderer()
camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 1, 10000 )
scene = new THREE.Scene()

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

    #console.log renderer.domElement
    #document.body.appendChild( renderer.domElement )
    $container.append(renderer.domElement)


animate = () ->
    # note: three.js includes requestAnimationFrame shim
        if running
            requestAnimationFrame( animate )
            cube1.rotation.x += 0.01
            cube1.rotation.y += 0.02

        renderer.render( scene, camera )

window.stop = () ->
    running = false
    #$container.html("")

init()
animate()
