
window.Amoeba ?= {}

# ------------------------------------------------
class Amoeba.GraphicsPort
  constructor: (@rect) ->

    @paper = Raphael(@rect.x, @rect.y, @rect.w, @rect.h)
    @paper.rect(0, 0, @rect.w, @rect.h).attr
      fill: "90-#aaf-#004"
      stroke: "#f99"
      title: "background"

    @elements = []

  addPoints: (points, radius, color="#f00") ->
    for point in points
      circle = @paper.circle(point.x, point.y, radius)
         .attr({fill: color, stroke: "#0e0"})
         .click( =>
            alert(this.data("i")))

      @elements.push(circle)

  clearAll: =>
    # @paper.clear() removes all, but we only want to remove stuff we know about
    for element in @elements
      element.remove;

# ------------------------------------------------
class Amoeba.Point
  constructor: (@x, @y) ->

  toString: ->
    return "(#{@x}, #{@y})"

  distance: (point2) ->
    xs = point2.x - this.x;
    xs = xs * xs;
   
    ys = point2.y - this.y;
    ys = ys * ys;
   
    return Math.sqrt( xs + ys );

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