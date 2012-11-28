
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
    Amoeba.fourText.val Amoeba.Graphics.rectWithFourPoints(0,0,100,300)

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

    @animations = [
      new CogAnimation(Raphael.getColor(), 0, @graphicsPaper)
      new CogAnimation(Raphael.getColor(), 1, @graphicsPaper)
      new CogAnimation(Raphael.getColor(), 2, @graphicsPaper)
      new CogAnimation(Raphael.getColor(), 3, @graphicsPaper)
      new CogAnimation(Raphael.getColor(), 4, @graphicsPaper)
    ]

  _start: =>
    if @animations?
      one.start() for one in @animations
  
# ///////////////////////////////////////////////////////////////////////
# ///////////////////////////////////////////////////////////////////////

class CogAnimation
  constructor: (@fillColor, @index, graphicsPaper) ->
    @pathSwitch = true
    @removed = false;

    # create it offscreen and transparent
    @mainPath = graphicsPaper.paper.path(this.pathOne()).attr({fill:@fillColor, "fill-opacity": 0, transform: "t#{graphicsPaper.width()},0"})
    
    @mainPath.node.onclick = =>
      this.animate()
      this.mainPath.toFront()

  remove: ->
    @removed = true

    # animate it out so it looks cool
    @mainPath.animate "fill-opacity":0, 400, "<>", =>
      @mainPath.remove()

  start: ->
    setTimeout( => 
      this._doStart()
    , 100*@index)

  _doStart: ->
    @mainPath.stop()
    @mainPath.animate {"fill-opacity": 1, transform: "t0,0"}, 600, "<>", =>
      this.rotate();

  rotate: ->
    @mainPath.animate transform: "r0", 0, "<>", =>
      @mainPath.animate transform: "r360", 1800, "<>", =>
        this.changeToPathTwo();

  changeToPathTwo: ->
    @mainPath.animate path:this.pathTwo(), fill:@fillColor, 800, "<>", =>
      this.changeToPathThree();
    
  changeToPathThree: ->
    # just changing circles, 0 duration
    @mainPath.animate path:this.pathThree(), 0, "", =>
      this.changeToPathFour();

  changeToPathFour: ->
    @mainPath.animate path:this.pathFour(), fill:@fillColor, 800, "<>", =>
      console.log("cunt")

  pathOne: ->
    result = Amoeba.oneText.val()
    
    result = Amoeba.Graphics.normalizePath(result)

    result = Amoeba.Graphics.translatePath(result, @index*120, 0);
 
    return result
    
  pathTwo: ->
    result = Amoeba.twoText.val()

    result = Amoeba.Graphics.normalizePath(result)
    result = Amoeba.Graphics.translatePath(result, 100+@index*220, 120);

    return result

  pathThree: ->
    result = Amoeba.threeText.val()

    result = Amoeba.Graphics.normalizePath(result)
    result = Amoeba.Graphics.translatePath(result, 100+@index*220, 120);

    return result

  pathFour: ->
    result = Amoeba.fourText.val()

    result = Amoeba.Graphics.normalizePath(result)

    result = Amoeba.Graphics.scalePath(result, .5, .5 + .3*@index);
    result = Amoeba.Graphics.translatePath(result, 300+@index*50, 220);
  
    return result





