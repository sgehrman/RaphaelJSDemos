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
      result = this._sawPath();
      Amoeba.oneText.val result

      result = this._sawPath(true);
      Amoeba.twoText.val result

      this._updateStatus("Showing example3")

      this.doAnimate()

    $("#example5").on "click", (event) =>
      result = this._gerePath();
      Amoeba.oneText.val result

      result = this._gerePath(30, true);
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

  _gerePath: (degees=90, flat=false) =>
    dim = 100
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
        result += "L#{x1},#{y1}"

      angle += degees

    result += "z"

    return result

  _sawPath: (largeTeeth=false) =>
    dim = 100
    inset = 10
    w = dim
    h = dim
    cw = dim/4
    ch = dim/4
    medd = 22

    teeth = cw
    if largeTeeth
      teeth = dim
    result = "M0,0"

    angle = 0;
    i=0

    while (angle <= 360)
      cogPath = "l#{teeth},0"

      if (angle > 0)
        cogPath = Raphael.transformPath(cogPath, "r" + -angle + " 50, 50")

      result += cogPath
      console.log(i++ + " #{angle}")
      angle += 15
    
    result += "z"

    console.log(result)

    return result;

class PathAnimation
  constructor: (@fillColor, @offset, paper) ->
    @pathSwitch = true
    @mainPath = paper.path(this.pathOne(@offset)).attr(fill:@fillColor)
    
    @mainPath.node.onclick = =>
      this.animate()
      this.mainPath.toFront()

  remove: ->
    # animate it out so it looks cool
    @mainPath.animate "fill-opacity":0, 400, "<>", =>
      @mainPath.remove()

  animate: ->
    if (+(@pathSwitch = not @pathSwitch)) 
      thePath = this.pathOne(@offset)
    else
      thePath = this.pathTwo(@offset)

    @mainPath.animate path:thePath, fill:@fillColor, 400, "<>"

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
