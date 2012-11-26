
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

  _pointsAroundCircle: (size, inset, numSegments, shift=0) =>
    centerX = size/2
    centerY = size/2
    radius = (size-(inset*2))/2

    degrees = (360/numSegments)

    result = []

    # .. (not ...) to go one more to add point back to beginning
    for i in [0..numSegments] 
      angle = i * degrees

      degreesShift = degrees * 0.15
      if shift is -1
        angle -= degreesShift
      else if shift is 1
        angle += degreesShift

      if angle >= 360
        angle = angle - 360
      else if angle < 0
        angle = 360 + angle

      cosValue = Math.cos(toRadians(angle))
      sinValue = Math.sin(toRadians(angle))

      x = centerX + (cosValue * radius)
      y = centerY + (sinValue * radius)

      result.push(new Point(x,y))

    return result

  _pairsAroundCircle: (size, inset, numSegments, shifted=false) =>
    result = []

    if (not shifted)
      points = this._pointsAroundCircle(size, inset, numSegments)

      # create a pair of points and add to result
      prevPoint = null
      for nextPoint in points
        if (prevPoint?)
          result.push(new PointPair(prevPoint, nextPoint))
        prevPoint = nextPoint

    else

      leftPoints = this._pointsAroundCircle(size, inset, numSegments, 1)
      rightPoints = this._pointsAroundCircle(size, inset, numSegments, -1)

      for i in [0...leftPoints.length-1]
        result.push(new PointPair(leftPoints[i], rightPoints[i+1]))

    return result

  _createCogSegments: (size, showTeeth, numSegments) =>
    result = []
    toothHeight = 0

    outerPoints = this._pairsAroundCircle(size, 0, numSegments, false)

    # calc tooth height relative to distance between outer points
    if (showTeeth)
      toothHeight = outerPoints[0].left.distance(outerPoints[0].right) * 0.55

    innerPoints = this._pairsAroundCircle(size, toothHeight, numSegments, false)

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


    # return makeCirclePath(@bottomLeft.x, @bottomLeft.y, 3) + makeCirclePath(@bottomRight.x, @bottomRight.y, 5);


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