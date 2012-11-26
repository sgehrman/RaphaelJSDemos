# coffee -wc ./animationHelper.coffee 

window.Amoeba ?= {}

class Amoeba.Animations
  constructor: ->

  setupAnimations: ->
    @paper = Raphael(0, 380, 850, 650)
    @paper.rect(0, 0, 850, 650).attr
      fill: "90-#aaf-#004"
      stroke: "#f99"
      title: "background"

    this._createAnimations()
    
  doAnimate: ->
    @animations.forEach (el) ->
      el.animate()

  setupPathFields: ->
    Amoeba.oneText = $("#one")
    Amoeba.twoText = $("#two")
    Amoeba.statusText = $("#status")
    Amoeba.oneText.val gearPath
    Amoeba.twoText.val circleGearPath

    $("#gears").on "click", (event) =>
      Amoeba.oneText.val gearPath
      Amoeba.twoText.val circleGearPath
      this.doAnimate()
      this._updateStatus("Showing gears")

    $("#rects").on "click", (event) =>
      Amoeba.oneText.val makeRectanglePath(0, 0, 100, 500)
      Amoeba.twoText.val makeRectanglePath(0, 0, 200, 300)
      this.doAnimate()
      this._updateStatus("Showing rects")

    $("#example1").on "click", (event) =>
      result = "M0,0c11,0 20,9 20,20c0,11 -9,20 -20,20c-11,0 -20-9 -20-20c0-11 9-20 20-20z"
      Amoeba.oneText.val result

      result = this._diamondPath(20)
      Amoeba.twoText.val result

      this._updateStatus("Showing example1")

      this.doAnimate()

    $("#example2").on "click", (event) =>
      result = makeCirclePath(0,0,20)
      Amoeba.oneText.val result

      result = this._diamondPath(20)
      Amoeba.twoText.val result

      this._updateStatus("Showing example2")

      this.doAnimate()

    $("#example3").on "click", (event) =>
      result = "M0,0 h-150 a150,150 0 1,0 150,-150z"
      Amoeba.oneText.val result

      result = this._diamondPath(200)
      Amoeba.twoText.val result

      this._updateStatus("Showing example3")

      this.doAnimate()

    $("#example4").on "click", (event) =>
      result = this._cogPath();
      Amoeba.oneText.val result

      result = this._cogPath(false);
      Amoeba.twoText.val result

      this._updateStatus("Showing example3")

      this.doAnimate()

    $("#example5").on "click", (event) =>
      result = this._shieldPath(360/10);
      Amoeba.oneText.val result

      result = this._shieldPath(360/10, true);
      Amoeba.twoText.val result

      this._updateStatus("Showing example3")

      this.doAnimate()

    $("#revDiamond").on "change", (event) =>
      # recreate the diamond
      result = this._diamondPath(200)
      
      Amoeba.twoText.val result
      
      # recreate animations fresh
      this._createAnimations()

      this.doAnimate()

    $("#run").on "click", (event) =>
      this.doAnimate()

  # how make private coffeescript methods?
  _diamondPath: (width=20) =>
    result = "M0,0l#{width},#{width} -#{width},#{width} -#{width}-#{width}z"

    if (jQuery('#revDiamond').is(':checked'))
      result = "M0,0l-#{width},#{width} #{width},#{width} #{width}-#{width}z"
      console.log("reversed")

    return result

  _createAnimations: =>
    if @animations?
      num.remove() for num in @animations

    @animations = [new PathAnimation("#44f", 0, @paper)] # , new PathAnimation("#f31", 420, @paper)]
  
  _updateStatus: (inStatus) =>
    Amoeba.statusText.text inStatus

  _shieldPath: (increment=45, useArcs=false) =>
    dim = 400
    radius = dim/2
    centerX = dim/2
    centerY = dim/2

    angle = 0;

    while (angle <= 360)
      x1 = centerX + (Math.cos(toRadians(angle)) * radius)
      y1 = centerY + (Math.sin(toRadians(angle)) * radius)

      if (angle is 0)
        result = "M#{x1},#{y1}"
      else
        if useArcs
          result += "A#{radius},#{radius},0,0,1,#{x1},#{y1}"
        else
          result += "A#{radius/2},#{radius/2},0,0,0,#{x1},#{y1}"
          # result += "L#{x1},#{y1}"

      angle += increment

    result += "z"

    return result







  _toothHeight: (size, numSegments) =>
    outerPoints = this._pairsAroundCircle(size, 0, numSegments)
    return outerPoints[0].left.distance(outerPoints[0].right) * 0.55

  _pairsAroundCircle: (size, inset, numSegments) =>
    centerX = size/2
    centerY = size/2
    degrees = (360/numSegments);
    radius = (size-(inset*2))/2

    # get the points around the circle
    points = []
    
    for i in [0..numSegments] # go one more to add point back to beginning
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
    if (showTeeth)
      toothHeight = this._toothHeight(size, numSegments) 

    outerPoints = this._pairsAroundCircle(size, 0, numSegments)
    innerPoints = this._pairsAroundCircle(size, toothHeight, numSegments)

    if ((outerPoints.length != innerPoints.length) or (outerPoints.length != numSegments))
      console.log("inner and outer points not OK?")
    else
      isTooth = false

      for i in [0...numSegments]
        outerPoint = outerPoints[i]
        innerPoint = innerPoints[i]

        newSegment = new CogSegment(isTooth, size, toothHeight, outerPoint.left, outerPoint.right, innerPoint.left, innerPoint.right);
        result.push(newSegment)
       
        isTooth = not isTooth

    return result;

  _cogPath: (showTeeth=true) =>
    segments = this._createCogSegments(500, showTeeth, 34)

    result = null
    for segment in segments
      if (not result?)
        result = "M#{segment.bottomLeft.x},#{segment.bottomLeft.y}"

      result += segment.path()

    result += "z"

    return result

# ///////////////////////////////////////////////////////////////////////
# ///////////////////////////////////////////////////////////////////////

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

class PointPair
  constructor: (@left, @right) ->

  toString: ->
    return "(#{@left}, #{@right})"

class CogSegment # isTooth, or is a spacer
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
      result += "A#{@innerRadius},#{@innerRadius},0,0,1,#{@bottomRight.x},#{@bottomRight.y}"

    return result;













# ///////////////////////////////////////////////////////////////////////
# ///////////////////////////////////////////////////////////////////////

class PathAnimation
  constructor: (@fillColor, @offset, paper) ->
    @pathSwitch = true
    @stopped = false;
    @mainPath = paper.path(this.pathOne(@offset)).attr(fill:@fillColor)
    
    @mainPath.node.onclick = =>
      this.animate()
      this.mainPath.toFront()

  remove: ->
    @stopped = true

    # animate it out so it looks cool
    @mainPath.animate "fill-opacity":0, 400, "<>", =>
      @mainPath.remove()

  animate: ->
    if (+(@pathSwitch = not @pathSwitch)) 
      thePath = this.pathOne(@offset)
    else
      thePath = this.pathTwo(@offset)

    @mainPath.animate path:thePath, fill:@fillColor, 800, "elastic", =>
      if (not @stopped)
        if (jQuery('#repeatCheck').is(':checked'))
          this.animate()

  pathOne: (offset) ->
    result = Amoeba.oneText.val()
    
    result = normalizePath(result)
    # result = scalePath(result, 0.5);
    result = translatePath(result, offset, 0)
    # result = rotatePath(result, 180);

    result
    
  pathTwo: (offset) ->
    result = Amoeba.twoText.val()

    result = normalizePath(result)
    # result = scalePath(result, 0.5);
    result = translatePath(result, offset, 0)
    #  result = rotatePath(result, 180);

    result



# ///////////////////////////////////////////////////////////////////////
# ///////////////////////////////////////////////////////////////////////

  # toothPath = Raphael.transformPath(toothPath, "T#{prev_x1},#{prev_y1}");
  # toothPath = Raphael.transformPath(toothPath, "r#{angle+56} #{prev_x1}, #{prev_y1}")


