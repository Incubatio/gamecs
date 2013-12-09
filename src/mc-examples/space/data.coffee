define (require) ->
  {
    screen:
      size: [600, 800]

    prefixs:
      image: 'assets/images/space/'
      sfx: 'assets/sfx/'

    stars:
      number: 25

    ennemies:
      cooldown: 3000
      spawnRate: 1000
    
    meteors:
      cooldown: 1000
      spawnRate: 4000


    # TOTHINK: add params to system init
    systems: [
      #'Weapon'
      'Movement'
      'Rotation'
      'Collision'
      #'World'
      
      #'Trigger'
      'Rendering'
    ]

    sfx: [
      'laser1'
    ]
      

    # TOTHINK: replace base by a component constructor
    sprites:
      Player:
        Mobile:
          velocity: [4, 4, 0]
        Visible:
          image: 'player.png'
        Collidable:
          shape: "rect"

      Meteor:
        Mobile:
          velocityY: 4
          direction: [0, 1, 0]
        Visible:
          image: 'meteorBig.png'
        Collidable:
          shape: "rect"
        Weaponized: true
        # should be in visible?
        #Rotative:
        #  rotationSpeed: 5

      Ennemy:
        Mobile:
          velocity: [4, 4, 0]
          direction: [0, 1, 0]
        Visible:
          image: 'enemyShip.png'
        Collidable:
          shape: "rect"

      GLazer:
        Mobile:
          velocity: [16, 16, 0]
          direction: [0, -1, 0]
        Visible:
          image: 'laserGreen.png'
        Collidable:
          shape: "rect"
        Weaponized: true

      RLazer:
        Mobile:
          velocity: [16, 16, 0]
          directionY: -1
        Visible:
          image: 'laserRed.png'
        Collidable:
          shape: "rect"
        Weaponized: true

      Star:
        Mobile:
          velocityY: 8
          direction: [0, 1, 0]
        Visible:
          shape: "circle"
          radius: 1
          size: [10, 10]

    scene:
      actors: [
        ['Player', [250, 550]]
      ]
  }
