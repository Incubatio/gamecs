define (require) ->
  {
    screen:
      size: [600, 800]

    prefixs:
      image: 'assets/images/'
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
          speed: 4
        Visible:
          image: 'player.png'
        Collidable:
          shape: "rect"

      Meteor:
        Mobile:
          speed: 4
          moveY: 1
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
          speed: 4
          moveY: 1
        Visible:
          image: 'enemyShip.png'
        Collidable:
          shape: "rect"

      GLazer:
        Mobile:
          speed: 16
          moveY: -1
        Visible:
          image: 'laserGreen.png'
        Collidable:
          shape: "rect"
        Weaponized: true

      RLazer:
        Mobile:
          speed: 16
          moveY: -1
        Visible:
          image: 'laserRed.png'
        Collidable:
          shape: "rect"
        Weaponized: true

      Star:
        Mobile:
          speed: 8
          moveY: 1
        Visible:
          shape: "circle"
          radius: 1
          size: [3, 3]

    scene:
      actors: [
        ['Player', [250, 550]]
      ]
  }
