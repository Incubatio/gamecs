# GameCS

### Description

GameCs is a port of GameJs Framework to CoffeeScript.  
GameJs is a JavaScript library for writing 2D games or other interactive
graphic applications for the HTML Canvas <http://gamejs.org>.


### Examples

You can check simple canvas gamecs examples online [here](http://incubatio.github.com/gamecs/sc-examples.html) 
and multi-canvas example [here](http://incubatio.github.com/gamecs/mc-examples.html).  
Examples are also available in the repository in the `src/sc-examples/` and `src/mc-examples` directory.

###### http:// vs file://
Every example works in file:// except worker-require that uses WebWorker's ImportScript function which require http://


### Usage

Download last version [here](https://raw.github.com/Incubatio/gamecs/master/assets/js/gamecs.min.js)  
OR  
compile it yourself by:  

1. cloning repository
2. ``coffee --compile --watch --output build src``
3. ``sh ./bin/build.sh`` (this will replace assets/js/gamecs.min.js file)


### More Help

See the [GameJs Website](http://gamecs.org) for more help or drop us
an email in the [Mailing List](http://groups.google.com/group/gamecs).  
Irc channel #gamejs (on irc.freenode.net)


###### Unit Tests

Under refactoring


###### JsDoc

For now please use http://docs.gamejs.org/


### TODO

Architecture refarctoring, Separate whole project into smaller modules, my actual proposition is:  

- Audio: 
  * mixer
  * sound
  * midi
- Sprite (2d):
  * rect
  * circle
  * polygon (or pnpoly)
  * mask (when pnpoly is not precise enough)
  * collision
  * spriteSheet
  * Tilemap
- Draw:
  * surface
  * surfaceArray
  * shape (formerly draw)
  * img
  * noise (simplex, Alea)
  * transform
- Engines:
  * Particle
  * Physics
- Text:
  * Font
- Browser (or Web?):
  * Dom
  * XHttp (formerly http)
  * Input (formerly events)
  * Uri
- Algorithm
  * Astar
  * MinMax (AlphaBeta pruning)
  * prng
- Utils
  * Arrays
  * BinaryHeap
  * Base64
  * Geometry (formerly utils/math)
  * Matrix
  * Objects
  * Time
  * Vectors
- Parser
  * xml

- Feature refatoring 
