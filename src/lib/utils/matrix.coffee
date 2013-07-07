###*
* @fileoverview Matrix manipulation, used by GameJs itself. You
* probably do not need this unless you manipulate a Context's transformation
* matrix yourself.
###

# correct way to do scale, rotate, translate
# *  gamecs.utils.matrix will be used in gamecs.transforms, modifing the surfaces.matrix
# * this matrix must be applied to the context in Surface.draw()

define (require) ->
  "use strict"
  class Matrix
    ###* @returns {Array} [1, 0, 0, 1, 0, 0] ###
    @identity: () ->
      return [1, 0, 0, 1, 0, 0]


    ###*
    * TODO: Only add one dimention matrix, and only support array of 7 element or less
    * what does it really calculate ?
    *
    * @param {Array} matrix
    * @param {Array} matrix
    * @returns {Array} matrix sum
    ###
    @add: (m1, m2) ->
      return [
        m1[0] + m2[0]
        m1[1] + m2[1]
        m1[2] + m2[2]
        m1[3] + m2[3]
        m1[4] + m2[4]
        m1[5] + m2[5]
        m1[6] + m2[6]
      ]

    ###*
    * TODO: WTF is the code below, require one dimention matrix of at lease 3 elements each.
    * what does it really calculate ?
    *
    * @param {Array} matrix A
    * @param {Array} matrix B
    * @returns {Array} matrix product
    ###
    @multiply: (m1, m2) ->
      return [
        m1[0] * m2[0] + m1[2] * m2[1]
        m1[1] * m2[0] + m1[3] * m2[1]
        m1[0] * m2[2] + m1[2] * m2[3]
        m1[1] * m2[2] + m1[3] * m2[3]
        m1[0] * m2[4] + m1[2] * m2[5] + m1[4]
        m1[1] * m2[4] + m1[3] * m2[5] + m1[5]
      ]

    ###*
    * @param {Array} matrix
    * @param {Array} matrix
    * @returns {Array} matrix sum
    ###
    @add2: (m1, m2) ->
      m1 = [m1] if !(m1[0] instanceof Array)
      m2 = [m2] if !(m2[0] instanceof Array)
      throw "error: incompatible sizes" if (m1.length != m2.length && m1[0].length != m2[0].length )
 
      res = []
      for i in [0...m1.length]
        res[i] = []
        for j in [0...m1[0].length]
          res[i][j] = m1[i][j] + m2[i][j]
      return res

    ###*
    * @param {Array} matrix
    * @param {Array} matrix
    * @returns {Array} matrix sum
    ###
    @multiply2: (m1, m2) ->
      m1 = [m1] if !(m1[0] instanceof Array)
      m2 = m2.map((i) -> return [i]) if !(m2[0] instanceof Array)
      throw "error: incompatible sizes" if (m1[0].length != m2.length)

      res = []
      for i in [0...m1.length]
        res[i] = []
        for j in [0...m2[0].length]
          s = 0
          for k in [0...m1[0].length]
            s += m1[i][k] * m2[k][j]
          res[i][j] = s

    ###*
    * @param {Array} matrix
    * @param {Number} dx
    * @param {Number} dy
    * @returns {Array} translated matrix
    ###
    @translate: (m1, dx, dy) ->
      return Matrix.multiply(m1, [1, 0, 0, 1, dx, dy])

    ###*
    * @param {Array} matrix
    * @param {Number} angle in radians
    * @returns {Array} rotated matrix
    ###
    @rotate: (m1, angle) ->
      # radians
      sin = Math.sin(angle)
      cos = Math.cos(angle)
      return Matrix.multiply(m1, [cos, sin, -sin, cos, 0, 0])

    ###*
    * @param {Array} matrix
    * @returns {Number} rotation in radians
    ###
    @rotation: (m1) ->
      return Math.atan2(m1[1], m1[0])

    ###*
    * @param {Array} matrix
    * @param {Array} vector [a, b]
    * @returns {Array} scaled matrix
    ###
    @scale: (m1, svec) ->
      sx = svec[0]
      sy = svec[1]
      return Matrix.multiply(m1, [sx, 0, 0, sy, 0, 0])
