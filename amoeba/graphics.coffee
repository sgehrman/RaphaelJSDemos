
window.Amoeba ?= {}

# ------------------------------------------------
class Amoeba.GraphicsPaper
  constructor: (@divHolder, attr=null) ->

    attr ?= {fill: "90-#aaf-#004", stroke: "#f99"}

    @paper = Raphael(@divHolder)
    # @paper.rect(0, 0, @rect.w, @rect.h).attr(attr)

    @elements = []

  addPoints: (points, radius, color="#f00") ->
    for point in points
      circle = @paper.circle(point.x, point.y, radius)
         .attr({fill: color, stroke: "#0e0"})
         .click( =>
            alert(this.data("i")))

      @elements.push(circle)

  clearAll: =>
    @paper.clear()
    
  clear: =>
    # clearAll removes every element, but we only want to remove stuff we know about
    for element in @elements
      element.remove

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





