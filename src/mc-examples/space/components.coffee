define (require) ->
  Objects = require('utils/objects')


  components =

    Visible: class
      image_urn: false
      image: false
      originalImage: false
      mask: false
      color: "#f00"
      setImage: (image) ->
        @dirty = true
        @image = image

      size: false
      radius: false
      shape: false

    Communicable: class
      avatar: "question.png"
      dialogs: false

    Mobile: class
      speed: 0
      moveX: 0
      moveY: 0

    Rotative: class
      rotationSpeed: 10
      rotation: 0

    Flipable: class
      vertical: false
      horizontal: false

    Movable: class
      #alive: true

    # Alive is already supported by GameJs
    Destructible: class
    # lifepoints


    Animated: class
      imageset: false
      frameset: false
      animation: false
      entitySheet: false
      options: false

    #class Traversable

    Inteligent: class
      pathfinding: 'straight' # none(human), random, sentinel, A*
      detectionRadius: 0

    Weaponized: class
      behavior: 'offensive' # defensive, balanced
      alorithm: 'kamikaze' # none(human), fixed strategy, multiple strategy, alpha beta pruning
      attacking: false
      weapon: 'sword'
      #attackRadius: 0,

    Triggerable: class
      triggered: false

    Collidable: class
      shape: false

    #Shieldable = exports.Shieldable
    #}


