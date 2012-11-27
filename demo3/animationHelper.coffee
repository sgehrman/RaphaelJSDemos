# coffee -wc ./animationHelper.coffee 
# see startup.sh for a simpler way to get started

window.Amoeba ?= {}

class Amoeba.Animations
  constructor: ->

  setupAnimations: ->
    @graphicsPort = new Amoeba.GraphicsPort(new Amoeba.Rect(0, 380, 850, 650))

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
      theCog = new Amoeba.Cog(400, 34, @graphicsPort);
      result = theCog.path(true);
      Amoeba.oneText.val result

      result = theCog.path(false);
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

    @animations = [new PathAnimation("#44f", 0, @graphicsPort)] # , new PathAnimation("#f31", 420, @graphicsPort)]
  
  _updateStatus: (inStatus) =>
    Amoeba.statusText.text inStatus

  _shieldPath: (increment=45, useArcs=false) =>
    dim = 400
    radius = dim/2
    centerX = dim/2
    centerY = dim/2

    angle = 0;

    while (angle <= 360)
      x1 = centerX + (Math.cos(Amoeba.Graphics.toRadians(angle)) * radius)
      y1 = centerY + (Math.sin(Amoeba.Graphics.toRadians(angle)) * radius)

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

# ///////////////////////////////////////////////////////////////////////
# ///////////////////////////////////////////////////////////////////////

class PathAnimation
  constructor: (@fillColor, @offset, graphicsPort) ->
    @pathSwitch = true
    @stopped = false;
    @mainPath = graphicsPort.paper.path(this.pathOne(@offset)).attr(fill:@fillColor)
    
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

    @mainPath.animate path:thePath, fill:@fillColor, 'fill-opacity': 0.4, 800, "<>", =>
      if (not @stopped)
        if (jQuery('#repeatCheck').is(':checked'))
          this.animate()

  pathOne: (offset) ->
    result = Amoeba.oneText.val()
    
    # result = Amoeba.Graphics.normalizePath(result)
    # result = Amoeba.Graphics.scalePath(result, 0.5);
    # result = Amoeba.Graphics.translatePath(result, offset, 0)
    # result = Amoeba.Graphics.rotatePath(result, 180);

    result
    
  pathTwo: (offset) ->
    result = Amoeba.twoText.val()

    # result = Amoeba.Graphics.normalizePath(result)
    # result = Amoeba.Graphics.scalePath(result, 0.5);
    # result = Amoeba.Graphics.translatePath(result, offset, 0)
    # result = Amoeba.Graphics.rotatePath(result, 180);

    result
