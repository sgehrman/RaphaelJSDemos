
window.Amoeba ?= {}

# ------------------------------------------------
class Amoeba.GraphicsPaper
  constructor: (@divHolder, attr=null) ->

    attr ?= {fill: "90-#aaf-#004", stroke: "#f99"}

    @paper = Raphael(@divHolder)

    # not sure why there isn't a size method on paper, using this I found online
    width = if @paper.canvas.clientWidth then @paper.canvas.clientWidth else @paper.width
    height = if @paper.canvas.clientHeight then @paper.canvas.clientHeight else @paper.height

    @paper.rect(0, 0, width, height).attr(attr)

    @points = []

  addPoints: (points, radius, color="#f00") ->
    for point in points
      circle = @paper.circle(point.x, point.y, radius)
      circle.attr({fill: color, stroke: "none"})

      @points.push(circle)

  pulsatePoints: =>
    for point in @points
      this._fadePoint(true, point)

  clearAll: =>
    @paper.clear()
    
  clearPoints: =>
    # clearAll removes every element, but we only want to remove stuff we know about
    for point in @points
      point.remove()

  _fadePoint: (out, point) =>
    fadeOut = Raphael.animation({transform: "s2", "fill-opacity": 1}, 600, "<", =>
      this._fadePoint(not out, point))

    fadeIn = Raphael.animation({transform: "s1", "fill-opacity": 0.1}, 600, ">", =>
      this._fadePoint(not out, point))

    point.stop() # stop if currently animating

    if out
      point.animate(fadeOut)
    else
      point.animate(fadeIn)

# ------------------------------------------------
class Amoeba.Point
  constructor: (@x, @y) ->

  toString: ->
    return "(#{@x}, #{@y})"

  distance: (point2) ->
    xs = point2.x - this.x
    xs = xs * xs
   
    ys = point2.y - this.y
    ys = ys * ys
   
    return Math.sqrt( xs + ys )

# ------------------------------------------------
class Amoeba.Pair
  constructor: (@left, @right) ->
    
  toString: ->
    return "(#{@left}, #{@right})"

# ------------------------------------------------
class Amoeba.Rect
  constructor: (@x, @y, @w, @h) ->

  toString: ->
    return "(x:#{@x}, y:#{@y}, w:#{@w}, h:#{@h})"

# ------------------------------------------------
class Amoeba.Graphics
  # class methods

  @toDegrees: (angle) ->
    return angle * (180 / Math.PI)

  @toRadians: (angle) ->
    return angle * (Math.PI / 180)

  @normalizePath: (path) ->
    bBox = Raphael.pathBBox(path)

    theMatrix = new Raphael.matrix()
    theMatrix.translate(-bBox.x, -bBox.y)

    transformString = theMatrix.toTransformString()
    path = Raphael.transformPath(path, transformString)

    return path

  @scalePath: (path, amount) ->
    bBox = Raphael.pathBBox(path)

    theMatrix = new Raphael.matrix()
    theMatrix.scale(amount, amount)

    transformString = theMatrix.toTransformString()
    path = Raphael.transformPath(path, transformString)

    return path

  @translatePath: (path, amountX, amountY) ->
    bBox = Raphael.pathBBox(path)

    theMatrix = new Raphael.matrix()
    theMatrix.translate(amountX, amountY)

    transformString = theMatrix.toTransformString()
    path = Raphael.transformPath(path, transformString)

    return path

  @rotatePath: (path, degrees) ->
    bBox = Raphael.pathBBox(path)

    theMatrix = new Raphael.matrix()
    theMatrix.rotate(degrees, bBox.x + (bBox.width / 2), bBox.y + (bBox.height / 2))

    transformString = theMatrix.toTransformString()
    path = Raphael.transformPath(path, transformString)

    return path





