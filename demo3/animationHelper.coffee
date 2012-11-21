
window.Amoeba ?= {}

class Amoeba.Animations
  constructor: ->

  setupAnimations: ->
    @paper = Raphael(0, 280, 850, 650)
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
    Amoeba.oneText.val gearPath
    Amoeba.twoText.val circleGearPath

    $("#gears").on "click", (event) =>
      Amoeba.oneText.val gearPath
      Amoeba.twoText.val circleGearPath
      this.doAnimate()

    $("#rects").on "click", (event) =>
      Amoeba.oneText.val makeRectanglePath(0, 0, 100, 500)
      Amoeba.twoText.val makeRectanglePath(0, 0, 200, 300)
      this.doAnimate()

    $("#example1").on "click", (event) =>
      result = "M0,0c11,0 20,9 20,20c0,11 -9,20 -20,20c-11,0 -20-9 -20-20c0-11 9-20 20-20z"
      Amoeba.oneText.val result

      result = this._diamondPath(20)
      Amoeba.twoText.val result

      this.doAnimate()

    $("#example2").on "click", (event) =>
      result = makeCirclePath(0,0,20)
      Amoeba.oneText.val result

      result = this._diamondPath(20)
      Amoeba.twoText.val result

      this.doAnimate()

    $("#example3").on "click", (event) =>
      result = "M0,0 h-150 a150,150 0 1,0 150,-150z"
      Amoeba.oneText.val result

      result = this._diamondPath(200)
      Amoeba.twoText.val result

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

    @animations = [new PathAnimation("#44f", 0, @paper), new PathAnimation("#f31", 420, @paper)]

class PathAnimation
  constructor: (@fillColor, @offset, paper) ->
    @pathSwitch = true
    @mainPath = paper.path(this.pathOne(@offset)).attr(fill:@fillColor)
    
    @mainPath.node.onclick = =>
      this.animate()
      this.mainPath.toFront()

  remove: ->
    @mainPath.remove();

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
