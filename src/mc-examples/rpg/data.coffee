define (require) ->
  {
    screen:
      size: [600, 800]

    prefixs:
      image: 'assets/images/rpg/'
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
        Visible:
          size: [64, 64]
        Animated:
          frameset: { "down": [56, 59], "left": [11, 8], "right": [8, 11], "up": [34, 39], "pause": [63, 64] }
          imageset: "frameset/firefox.png"
          options:
            xflip: {"left" : true}
        Mobile:
          speed: 4
        Weaponized:
          weapon: 'sword'

      Octocat:
        Animated:
          frameset: { "down": [0, 3], "left": [4, 7], "right": [8, 11], "up": [12, 15], "pause": [0] }
          imageset: "frameset/octocat.png"
        Mobile:
          speed: 0
        Visible:
          size: [32, 32]
        #Movable:
      
      Stargate:
        Visible:
          image: 'stargate.png'

      Vortex:
        Animated:
          frameset: { 'active': [0, 14] }
          imageset: "frameset/vortex.png"
        Visible:
          size: [64, 64]

      Sword:
        Visible:
          size: [64, 64]
        Animated:
          frameset: { "down": [30, 34], "left": [0, 4], "right": [0, 4], "up": [15, 20], "pause": [0] }
          imageset: "frameset/sword.png"
          options:
            xflip: {"left" : true}
        Mobile:
          speed: 4

    scene:
      actors: [
        ['Player', [100, 100]]
        ['Sword', [-100, 100]]
#        ['Stargate', [250, 1]]
        ['Vortex', [267, 17]]
        ['Octocat', [180, 90]]
      ]
  }
