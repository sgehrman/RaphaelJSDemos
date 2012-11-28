
window.Amoeba ?= {}

# ------------------------------------------------
class Amoeba.Cog
  constructor: (@size, @numSegments, @graphicsPaper) ->

  path: (showTeeth) ->
    # alternate gear if needed in future
    # return this._alternateGear();

    segments = this._createCogSegments(@size, showTeeth, @numSegments)

    result = null
    for segment in segments
      if (not result?)
        result = "M#{segment.bottomLeft.x},#{segment.bottomLeft.y}"

      result += segment.path()

    result += "z"

    return result

  showPoints: =>
    segments = this._createCogSegments(@size, true, @numSegments)

    for segment in segments
      segment.debugPoints(@graphicsPaper)

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

      cosValue = Math.cos(Amoeba.Graphics.toRadians(angle))
      sinValue = Math.sin(Amoeba.Graphics.toRadians(angle))

      x = centerX + (cosValue * radius)
      y = centerY + (sinValue * radius)

      result.push(new Amoeba.Point(x,y))

    return result

  _pairsAroundCircle: (size, inset, numSegments, shifted=false) =>
    result = []

    if (not shifted)
      points = this._pointsAroundCircle(size, inset, numSegments)

      # create a pair of points and add to result
      prevPoint = null
      for nextPoint in points
        if (prevPoint?)
          result.push(new Amoeba.Pair(prevPoint, nextPoint))
        prevPoint = nextPoint

    else

      leftPoints = this._pointsAroundCircle(size, inset, numSegments, -1)
      rightPoints = this._pointsAroundCircle(size, inset, numSegments, -1)

      for i in [0...leftPoints.length-1]
        result.push(new Amoeba.Pair(leftPoints[i], rightPoints[i+1]))

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


    # sites to check out
    # https://github.com/mbostock/d3/wiki/Gallery
    # http://deanm.github.com/pre3d/colorscube.html
    # http://deanm.github.com/pre3d/

  _alternateGear: () ->
    inRadius = 200
    inTeeth = 32
    insideOut = false

    n = inTeeth
    r2 = Math.abs(inRadius)
    r0 = r2 - 8
    r1 = r2 + 8

    if (insideOut)
      r3 = r0
      r0 = r1
      r1 = r3
      r3 = r2 + 20
    else
      r3 = 20

    da = Math.PI / n
    a0 = -Math.PI / 2 + (insideOut ? Math.PI / n : 0)
    i = -1
    path = ["M", r0 * Math.cos(a0), ",", r0 * Math.sin(a0)]

    while (++i < n) 
      path.push(
        "A", r0, ",", r0, " 0 0,1 ", r0 * Math.cos(a0 += da), ",", r0 * Math.sin(a0),
        "L", r2 * Math.cos(a0), ",", r2 * Math.sin(a0),
        "L", r1 * Math.cos(a0 += da / 3), ",", r1 * Math.sin(a0),
        "A", r1, ",", r1, " 0 0,1 ", r1 * Math.cos(a0 += da / 3), ",", r1 * Math.sin(a0),
        "L", r2 * Math.cos(a0 += da / 3), ",", r2 * Math.sin(a0),
        "L", r0 * Math.cos(a0), ",", r0 * Math.sin(a0))

    path.push("M0,", -r3, "A", r3, ",", r3, " 0 0,0 0,", r3, "A", r3, ",", r3, " 0 0,0 0,", -r3, "Z")
    return path.join("")

# ------------------------------------------------
class CogSegment
  constructor: (@isTooth, @size, @toothHeight, @topLeft, @topRight, @bottomLeft, @bottomRight) ->
    @outerRadius = @size/2
    @innerRadius = (@size - (@toothHeight * 2)) / 2

  toString: ->
    return "(#{@topLeft}, #{@topRight}, #{@bottomLeft}, #{@bottomRight})"

  debugPoints: (graphicsPaper) ->
    if @isTooth
      graphicsPaper.addPoints([@topLeft], 2, "black")
      graphicsPaper.addPoints([@topRight], 2, "orange")
      graphicsPaper.addPoints([@bottomLeft], 2, "black")
      graphicsPaper.addPoints([@bottomRight], 2, "orange")
    else
      graphicsPaper.addPoints([@topLeft], 2, "red")
      graphicsPaper.addPoints([@topRight], 2, "yellow")
      graphicsPaper.addPoints([@bottomLeft], 2, "red")
      graphicsPaper.addPoints([@bottomRight], 2, "yellow")

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




