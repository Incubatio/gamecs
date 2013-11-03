define (require) ->
  Objects = require('utils/objects')


  components =

    Visible: class
      image_urn: null
      image: null
      originalImage: null
      mask: null
      color: "#f00"
      setImage: (image) ->
        @dirty = true
        @image = image

      size: null
      radius: null
      shape: null

    Communicable: class
      avatar: "question.png"
      dialogs: null

    Mobile: class
      speed: null
      move: null
      constructor: () ->
        @speed = [0, 0, 0]
        @move = [0, 0, 0]



    Rotative: class
      rotationSpeed: 10
      rotation: 0

    Flipable: class
      vertical: null
      horizontal: null

    Movable: class
      #alive: true

    # Alive is already supported by GameJs
    Destructible: class
    # lifepoints


    Animated: class
      imageset: null
      frameset: null
      animation: null
      entitySheet: null
      options: null

    #class Traversable

    Inteligent: class
      pathfinding: 'straight' # none(human), random, sentinel, A*
      detectionRadius: 0

    Weaponized: class
      behavior: 'offensive' # defensive, balanced
      alorithm: 'kamikaze' # none(human), fixed strategy, multiple strategy, alpha beta pruning
      attacking: null
      weapon: 'sword'
      #attackRadius: 0,

    Triggerable: class
      triggered: null

    Collidable: class
      shape: null

    Jumpable: class
      startedAt: null
      canJump: true

    #Shieldable = exports.Shieldable
    #}
  Objects.accessors components.Mobile.prototype,
    moveX:
      get: () -> @move[0]
      set: (move) -> @move[0] = move
    moveY:
      get: () -> @move[1]
      set: (move) -> @move[1] = move
    moveZ:
      get: () -> @move[2]
      set: (move) -> @move[2] = move
    speedX:
      get: () -> @speed[0]
      set: (speed) -> @speed[0] = speed
    speedY:
      get: () -> @speed[1]
      set: (speed) -> @speed[1] = speed
    speedZ:
      get: () -> @speed[2]
      set: (speed) -> @speed[2] = speed

  return components


