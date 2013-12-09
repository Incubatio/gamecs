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
      velocity: null
      direction: null
      hasNotCollided: null
      constructor: () ->
        @velocity = [0, 0, 0]
        @direction = [0, 0, 0]
        @hasNotCollided = [true, true, true]

    # Maybe following should be part of mobile
    Collidable: class
      shape: null



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
      frameSize: null
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


    Jumpable: class
      startedAt: null
      canJump: true
      jumping: null

    #Shieldable = exports.Shieldable
    #}
  Objects.accessors components.Mobile.prototype,
    directionX:
      get: () -> @direction[0]
      set: (direction) -> @direction[0] = direction
    directionY:
      get: () -> @direction[1]
      set: (direction) -> @direction[1] = direction
    directionZ:
      get: () -> @direction[2]
      set: (direction) -> @direction[2] = direction

    velocityX:
      get: () -> @velocity[0]
      set: (velocity) -> @velocity[0] = velocity
    velocityY:
      get: () -> @velocity[1]
      set: (velocity) -> @velocity[1] = velocity
    velocityZ:
      get: () -> @velocity[2]
      set: (velocity) -> @velocity[2] = velocity

    hasNotCollidedX:
      get: () -> @hasNotCollided[0]
      set: (hasNotCollided) -> @hasNotCollided[0] = hasNotCollided
    hasNotCollidedY:
      get: () -> @hasNotCollided[1]
      set: (hasNotCollided) -> @hasNotCollided[1] = hasNotCollided
    hasNotCollidedZ:
      get: () -> @hasNotCollided[2]
      set: (hasNotCollided) -> @hasNotCollided[2] = hasNotCollided

  return components


