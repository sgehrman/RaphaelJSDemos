
window.Amoeba ?= {}

class Amoeba.CogDemo
  constructor: (divHolder, @size, @numSegments) ->
    @graphicsPaper = new Amoeba.GraphicsPaper(divHolder)

    Amoeba.oneText = $("#one")
    Amoeba.twoText = $("#two")
    Amoeba.threeText = $("#three")
    Amoeba.fourText = $("#four")
        
    @cog = new Amoeba.Cog(@size, @numSegments, @graphicsPaper);
    Amoeba.oneText.val @cog.path(true)
    Amoeba.twoText.val @cog.path(false)
    Amoeba.threeText.val Amoeba.Graphics.circleWithFourPoints(0,0,@size/2)
    Amoeba.fourText.val Amoeba.Graphics.rectWithFourPoints(0,0,200,500)

    this._createAnimations()

    $("#run").on "click", (event) =>
      this._start()

    $("#showPoints").on "click", (event) =>
      @cog.showPoints()

    $("#hidePoints").on "click", (event) =>
      @graphicsPaper.clearPoints()

    $("#pulsatePoints").on "click", (event) =>
      @graphicsPaper.pulsatePoints()

    this._start()

  _createAnimations: =>
    if @animations?
      one.remove() for one in @animations

    @animations = [new CogAnimation("#44f", 0, @graphicsPaper)] # , new CogAnimation("#f31", 420, @graphicsPaper)]
  
  _start: =>
    if @animations?
      one.start() for one in @animations
  
# ///////////////////////////////////////////////////////////////////////
# ///////////////////////////////////////////////////////////////////////

class CogAnimation
  constructor: (@fillColor, @offset, graphicsPaper) ->
    @pathSwitch = true
    @removed = false;

    # create it offscreen and transparent
    @mainPath = graphicsPaper.paper.path(this.pathOne(@offset)).attr({fill:@fillColor, "fill-opacity": 0, transform: "t#{graphicsPaper.width()},0"})
    
    @mainPath.node.onclick = =>
      this.animate()
      this.mainPath.toFront()

  remove: ->
    @removed = true

    # animate it out so it looks cool
    @mainPath.animate "fill-opacity":0, 400, "<>", =>
      @mainPath.remove()

  start: ->
    params = {"fill-opacity": 1, transform: "t0,0"}

    @mainPath.stop()
    @mainPath.animate params, 800, "<>", =>
      this.changeToPathTwo();

  changeToPathTwo: ->
    @mainPath.animate path:this.pathTwo(@offset), fill:@fillColor, 'fill-opacity': 0.4, 800, "<>", =>
      this.changeToPathThree();
    
  changeToPathThree: ->
    # just changing circles, 0 duration
    @mainPath.animate path:this.pathThree(@offset), 0, "", =>
      this.changeToPathFour();

  changeToPathFour: ->
    @mainPath.animate path:this.pathFour(@offset), fill:@fillColor, 'fill-opacity': 0.4, 800, "<>", =>
      console.log("cunt")

  pathOne: (offset) ->
    result = Amoeba.oneText.val()
    
    result = Amoeba.Graphics.normalizePath(result)
 
    return result
    
  pathTwo: (offset) ->
    result = Amoeba.twoText.val()

    result = Amoeba.Graphics.normalizePath(result)
  
    return result

  pathThree: (offset) ->
    result = Amoeba.threeText.val()

    result = Amoeba.Graphics.normalizePath(result)
  
    return result

  pathFour: (offset) ->
    result = Amoeba.fourText.val()

    result = Amoeba.Graphics.normalizePath(result)
  
    return result





