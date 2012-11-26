
window.Amoeba ?= {}

# ------------------------------------------------
class Amoeba.Cog
  constructor: (@size, @numSegments) ->

  path: (showTeeth) ->
    segments = this._createCogSegments(@size, showTeeth, @numSegments)

    result = null
    for segment in segments
      if (not result?)
        result = "M#{segment.bottomLeft.x},#{segment.bottomLeft.y}"

      result += segment.path()

    result += "z"

    return result

  _pairsAroundCircle: (size, inset, numSegments) =>
    centerX = size/2
    centerY = size/2
    degrees = (360/numSegments);
    radius = (size-(inset*2))/2

    # get the points around the circle
    points = []

    # .. (not ...) to go one more to add point back to beginning
    for i in [0..numSegments] 
      angle = i * degrees

      if angle >= 360
        angle = 360 - angle

      cosValue = Math.cos(toRadians(angle))
      sinValue = Math.sin(toRadians(angle))

      x = centerX + (cosValue * radius)
      y = centerY + (sinValue * radius)

      points.push(new Point(x,y))

    # create a pair of points and add to result
    result = []
    prevPoint = null
    for nextPoint in points
      if (prevPoint?)
        result.push(new PointPair(prevPoint, nextPoint))
      prevPoint = nextPoint

    return result

  _createCogSegments: (size, showTeeth, numSegments) =>
    result = []
    toothHeight = 0

    outerPoints = this._pairsAroundCircle(size, 0, numSegments)

    # calc tooth height relative to distance between outer points
    if (showTeeth)
      toothHeight = outerPoints[0].left.distance(outerPoints[0].right) * 0.55

    innerPoints = this._pairsAroundCircle(size, toothHeight, numSegments)

    if ((outerPoints.length != innerPoints.length) or (outerPoints.length != numSegments))
      console.log("inner and outer points not right?")
    else
      isTooth = false

      for i in [0...numSegments]
        outerPoint = outerPoints[i]
        innerPoint = innerPoints[i]

        newSegment = new CogSegment(isTooth, size, toothHeight, outerPoint.left, outerPoint.right, innerPoint.left, innerPoint.right);
        result.push(newSegment)
       
        isTooth = not isTooth

    return result;

# ------------------------------------------------
class Point
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
class PointPair
  constructor: (@left, @right) ->

  toString: ->
    return "(#{@left}, #{@right})"

# ------------------------------------------------
class CogSegment
  constructor: (@isTooth, @size, @toothHeight, @topLeft, @topRight, @bottomLeft, @bottomRight) ->
    @outerRadius = @size/2
    @innerRadius = (@size - (@toothHeight * 2)) / 2

  toString: ->
    return "(#{@topLeft}, #{@topRight}, #{@bottomLeft}, #{@bottomRight})"

  path: ->
    result = ""

    if @isTooth
      result += "L#{@topLeft.x},#{@topLeft.y}"
      result += "A#{@outerRadius},#{@outerRadius},0,0,1,#{@topRight.x},#{@topRight.y}"
      result += "L#{@bottomRight.x},#{@bottomRight.y}"
    else
      flag = 1
      if @toothHeight > 0
        flag = 0

      result += "A#{@outerRadius},#{@outerRadius},0,0,#{flag},#{@bottomRight.x},#{@bottomRight.y}"

    return result;