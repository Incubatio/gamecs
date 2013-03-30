Description
===========

GameCs is a port of GameJs Framework to CoffeeScript.

GameJs is a JavaScript library for writing 2D games or other interactive
graphic applications for the HTML Canvas <http://gamecs.org>.


Examples
========

You can check gamecs examples online at http://github.com/Incubatio/gamecs/examples.html
Examples are also available in the repository in the `src/examples/` directory.

http:// vs file://
------------------
Every example works in file:// except worker-require that uses WebWorker's ImportScript function which require http://


Usage
=====
Download last version [here](https://raw.github.com/Incubatio/gamecs/master/assets/js/gamecs.min.js)
OR
compile it yourself by:
1. cloning repository
2. ``coffee --compile --watch --output build src``
3. ``sh ./bin/build.sh`` (this will replace assets/js/gamecs.min.js file)


More Help
===========

See the [GameJs Website](http://gamecs.org) for more help or drop us
an email in the [Mailing List](http://groups.google.com/group/gamecs).

Irc channel #gamejs (on irc.freenode.net)


Unit Tests
-----------

Under refactoring


JsDoc
-----

For now please use http://docs.gamejs.org/


TODO
====
- Architecture refarctoring
- Fix Transformation.rotate
- Feature refatoring 
