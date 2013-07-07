define (require) ->
  {
    screen:
      size: [600, 800]

    map:
      url: 'assets/data/rpg/example.json'
      tilesheet: 'tilesheet.png'

    prefixs:
      image: 'assets/images/rpg/'
      sfx: 'assets/sfx/'

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
    ]
      

    # TOTHINK: replace base by a component constructor
    sprites:
      Player:
        Visible:
          size: [64, 64]
        Animated:
          frameset: { "down": [56, 59], "left": [8, 11], "right": [8, 11], "up": [34, 39], "pause": [64, 65] }
          imageset: "frameset/firefox.png"
          options:
            xflip: {"left" : true}
        Mobile:
          speed: 3
        Weaponized:
          weapon: 'sword'
        Collidable:
          shape: "rect"
          # TODO: maybe allow to define a collision mask / also PNPOLY could solve this without overcoding
          # mask:
            #offset: [20, 10]
            #size: [24, 44]

      Octocat:
        Animated:
          frameset: { "wave": [0, 3], "pause": [0] }
          imageset: "frameset/octocat.png"
          options:
            start: 'wave'
        Mobile:
          speed: 0
        Visible:
          size: [32, 32]
        Collidable:
          shape: "rect"
        #Movable:
      
      Stargate:
        Visible:
          image: 'stargate.png'

      Vortex:
        Animated:
          frameset: { 'active': [0, 14] }
          imageset: "frameset/vortex.png"
          options:
            start: 'active'
        Visible:
          size: [64, 64]
        Collidable:
          shape: "rect"

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
        ['Player', [60, 60]]
        ['Sword', [-100, 100]]
        ['Vortex', [267, 17]]
        ['Octocat', [380, 90]]
      ]
      decors: [
        ['text', 'Hello World', [200, 250]]
        ['image', 'stargate.png', [250, 1]]
        ['text', 'Da Big Boss', [1450, 280]]
      ]
  }
