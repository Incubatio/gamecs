// Generated by CoffeeScript 1.4.0
(function() {

  define(function(require) {
    /**
    * @fileoverview
    * A noise generator comparable to Perlin noise, which is useful
    * for generating procedural content.
    * @see gamecs/utils/prng
    */

    /**
    * Ported to JS by by zz85 <https:#github.com/zz85> from Stefan
    * Gustavson's java implementation
    * <http:#staffwww.itn.liu.se/~stegu/simplexnoise/simplexnoise.pdf>
    * Read Stefan's excellent paper for details on how this code works.
    *
    * Sean McCullough banksean@gmail.com
    */

    var Simplex;
    return Simplex = (function() {
      /**
      * This implementation provides 2D and 3D noise. You can optionally
      * pass a seedable pseudo-random number generator to its constructor. This
      * generator object is assumed to have a `random()` method `Math` is used
      * per default.
      *
      * Also see `gamecs/utils/prng` for a seedable pseudo random number generator
      *
      * @param {Object} prng the random number generator to use most provide `random()` method
      * @usage
      *  simplex = new gamecs.noise.Simplex()
      *  simplex.get(x, y)
      *  # or for 3d noise
      *  simple.get(x, y, y)
      */

      function Simplex(r) {
        var i, _i, _j;
        if (r === void 0) {
          r = Math;
        }
        /** @ignore
        */

        this.grad3 = [[1, 1, 0], [-1, 1, 0], [1, -1, 0], [-1, -1, 0], [1, 0, 1], [-1, 0, 1], [1, 0, -1], [-1, 0, -1], [0, 1, 1], [0, -1, 1], [0, 1, -1], [0, -1, -1]];
        /** @ignore
        */

        this.p = [];
        for (i = _i = 0; _i < 256; i = ++_i) {
          this.p[i] = Math.floor(r.random() * 256);
        }
        /** To remove the need for index wrapping, double the permutation table length
        */

        /** @ignore
        */

        this.perm = [];
        for (i = _j = 0; _j < 512; i = ++_j) {
          this.perm[i] = this.p[i & 255];
        }
        /**
        * A lookup table to traverse the simplex around a given point in 4D.
        * Details can be found where this table is used, in the 4D noise method.
        */

        /** @ignore
        */

        this.simplex = [[0, 1, 2, 3], [0, 1, 3, 2], [0, 0, 0, 0], [0, 2, 3, 1], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [1, 2, 3, 0], [0, 2, 1, 3], [0, 0, 0, 0], [0, 3, 1, 2], [0, 3, 2, 1], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [1, 3, 2, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [1, 2, 0, 3], [0, 0, 0, 0], [1, 3, 0, 2], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [2, 3, 0, 1], [2, 3, 1, 0], [1, 0, 2, 3], [1, 0, 3, 2], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [2, 0, 3, 1], [0, 0, 0, 0], [2, 1, 3, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [2, 0, 1, 3], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [3, 0, 1, 2], [3, 0, 2, 1], [0, 0, 0, 0], [3, 1, 2, 0], [2, 1, 0, 3], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [3, 1, 0, 2], [0, 0, 0, 0], [3, 2, 0, 1], [3, 2, 1, 0]];
      }

      /** @ignore
      */


      Simplex.prototype.dot = function(g, x, y) {
        return g[0] * x + g[1] * y;
      };

      /**
      * @param {Number} x
      * @param {Number} y
      * @returns {Number} noise for given position, in range [-1, 1]
      */


      Simplex.prototype.get = function(xin, yin) {
        /* Skew the input space to determine which simplex cell we're in
        */

        var F2, G2, X0, Y0, gi0, gi1, gi2, i, i1, ii, j, j1, jj, n0, n1, n2, s, t, t0, t1, t2, x0, x1, x2, y0, y1, y2;
        F2 = 0.5 * (Math.sqrt(3.0) - 1.0);
        s = (xin + yin) * F2;
        i = Math.floor(xin + s);
        j = Math.floor(yin + s);
        G2 = (3.0 - Math.sqrt(3.0)) / 6.0;
        t = (i + j) * G2;
        X0 = i - t;
        Y0 = j - t;
        x0 = xin - X0;
        y0 = yin - Y0;
        if (x0 > y0) {
          i1 = 1;
          j1 = 0;
        } else {
          i1 = 0;
          j1 = 1;
        }
        x1 = x0 - i1 + G2;
        y1 = y0 - j1 + G2;
        x2 = x0 - 1.0 + 2.0 * G2;
        y2 = y0 - 1.0 + 2.0 * G2;
        ii = i & 255;
        jj = j & 255;
        gi0 = this.perm[ii + this.perm[jj]] % 12;
        gi1 = this.perm[ii + i1 + this.perm[jj + j1]] % 12;
        gi2 = this.perm[ii + 1 + this.perm[jj + 1]] % 12;
        t0 = 0.5 - x0 * x0 - y0 * y0;
        if (t0 < 0) {
          n0 = 0.0;
        } else {
          t0 *= t0;
          n0 = t0 * t0 * this.dot(this.grad3[gi0], x0, y0);
        }
        t1 = 0.5 - x1 * x1 - y1 * y1;
        if (t1 < 0) {
          n1 = 0.0;
        } else {
          t1 *= t1;
          n1 = t1 * t1 * this.dot(this.grad3[gi1], x1, y1);
        }
        t2 = 0.5 - x2 * x2 - y2 * y2;
        if (t2 < 0) {
          n2 = 0.0;
        } else {
          t2 *= t2;
          n2 = t2 * t2 * this.dot(this.grad3[gi2], x2, y2);
        }
        return 70.0 * (n0 + n1 + n2);
      };

      /**
      * @param {Number} x
      * @param {Number} y
      * @param {Number} y
      * @returns {Number} noise for given position, in range [-1, 1]
      */


      Simplex.prototype.get3d = function(xin, yin, zin) {
        var F3, G3, X0, Y0, Z0, c, gi0, gi1, gi2, gi3, i, i1, i2, ii, j, j1, j2, jj, k, k1, k2, kk, n0, n1, n2, n3, s, t, t0, t1, t2, t3, x0, x2, x3, y0, y1, y2, y3, z0, z1, z2, z3;
        F3 = 1.0 / 3.0;
        s = (xin + yin + zin) * F3;
        i = Math.floor(xin + s);
        j = Math.floor(yin + s);
        k = Math.floor(zin + s);
        G3 = 1.0 / 6.0;
        t = (i + j + k) * G3;
        X0 = i - t;
        Y0 = j - t;
        Z0 = k - t;
        x0 = xin - X0;
        y0 = yin - Y0;
        z0 = zin - Z0;
        if (x0 >= y0) {
          if (y0 >= z0) {
            i1 = 1;
            j1 = 0;
            k1 = 0;
            i2 = 1;
            j2 = 1;
            k2 = 0;
          } else if (x0 >= z0) {
            i1 = 1;
            j1 = 0;
            k1 = 0;
            i2 = 1;
            j2 = 0;
            k2 = 1;
          } else {
            i1 = 0;
            j1 = 0;
            k1 = 1;
            i2 = 1;
            j2 = 0;
            k2 = 1;
          }
        } else {
          if (y0 < z0) {
            i1 = 0;
            j1 = 0;
            k1 = 1;
            i2 = 0;
            j2 = 1;
            k2 = 1;
          } else if (x0 < z0) {
            i1 = 0;
            j1 = 1;
            k1 = 0;
            i2 = 0;
            j2 = 1;
            k2 = 1;
          } else {
            i1 = 0;
            j1 = 1;
            k1 = 0;
            i2 = 1;
            j2 = 1;
            k2 = 0;
          }
        }
        c = 1 / (6..x1 = x0 - i1 + G3);
        y1 = y0 - j1 + G3;
        z1 = z0 - k1 + G3;
        x2 = x0 - i2 + 2.0 * G3;
        y2 = y0 - j2 + 2.0 * G3;
        z2 = z0 - k2 + 2.0 * G3;
        x3 = x0 - 1.0 + 3.0 * G3;
        y3 = y0 - 1.0 + 3.0 * G3;
        z3 = z0 - 1.0 + 3.0 * G3;
        ii = i & 255;
        jj = j & 255;
        kk = k & 255;
        gi0 = this.perm[ii + this.perm[jj + this.perm[kk]]] % 12;
        gi1 = this.perm[ii + i1 + this.perm[jj + j1 + this.perm[kk + k1]]] % 12;
        gi2 = this.perm[ii + i2 + this.perm[jj + j2 + this.perm[kk + k2]]] % 12;
        gi3 = this.perm[ii + 1 + this.perm[jj + 1 + this.perm[kk + 1]]] % 12;
        t0 = 0.6 - x0 * x0 - y0 * y0 - z0 * z0;
        if (t0 < 0) {
          n0 = 0.0;
        } else {
          t0 *= t0;
          n0 = t0 * t0 * this.dot(this.grad3[gi0], x0, y0, z0);
        }
        t1 = 0.6 - x1 * x1 - y1 * y1 - z1 * z1;
        if (t1 < 0) {
          n1 = 0.0;
        } else {
          t1 *= t1;
          n1 = t1 * t1 * this.dot(this.grad3[gi1], x1, y1, z1);
        }
        t2 = 0.6 - x2 * x2 - y2 * y2 - z2 * z2;
        if (t2 < 0) {
          n2 = 0.0;
        } else {
          t2 *= t2;
          n2 = t2 * t2 * this.dot(this.grad3[gi2], x2, y2, z2);
        }
        t3 = 0.6 - x3 * x3 - y3 * y3 - z3 * z3;
        if (t3 < 0) {
          n3 = 0.0;
        } else {
          t3 *= t3;
          n3 = t3 * t3 * this.dot(this.grad3[gi3], x3, y3, z3);
        }
        return 32.0 * (n0 + n1 + n2 + n3);
      };

      return Simplex;

    })();
  });

}).call(this);
