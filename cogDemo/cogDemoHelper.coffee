
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

    $("#run").on "click", (event) =>
      this._start()

    $("#showPoints").on "click", (event) =>
      @cog.showPoints()

    $("#hidePoints").on "click", (event) =>
      @graphicsPaper.clearPoints()

    $("#pulsatePoints").on "click", (event) =>
      @graphicsPaper.pulsatePoints()

    this._start()  

  _start: =>
    if @animations?
      one.remove() for one in @animations

    @animations = [
      new CogAnimation(Raphael.getColor(), 0, @graphicsPaper)
      new CogAnimation(Raphael.getColor(), 1, @graphicsPaper)
      new CogAnimation(Raphael.getColor(), 2, @graphicsPaper)
      new CogAnimation(Raphael.getColor(), 3, @graphicsPaper)
      new CogAnimation(Raphael.getColor(), 4, @graphicsPaper)
    ]
    one.start() for one in @animations
  
# ///////////////////////////////////////////////////////////////////////
# ///////////////////////////////////////////////////////////////////////

class CogAnimation
  constructor: (@fillColor, @index, graphicsPaper) ->
    @pathSwitch = true
    @removed = false;

    # create it offscreen and transparent
    @mainPath = graphicsPaper.paper.path(this.pathOne()).attr({fill:@fillColor, opacity: 0, transform: "t#{graphicsPaper.width()},0"})
    
    @mainPath.node.onclick = =>
      this.animate()
      this.mainPath.toFront()

  remove: ->
    @removed = true

    # animate it out so it looks cool
    # Warning: this final animation could get stopped and we never get removed
    @mainPath.animate opacity:0, 400, "<>", =>
      @mainPath.remove()

  start: ->
    setTimeout( => 
      this._start()
    , 100*@index)

  _start: ->
    this._stop()
    @mainPath.animate {opacity: 1, transform: "t0,0"}, 600, "<>", =>
      this.rotate();

  _stop: ->
    # don't stop if removing, we don't want our final animation to get canceled which would prevent the removal of the element
    if (not @removed)
      @mainPath.stop()

  rotate: ->
    @mainPath.animate transform: "r0", 0, "", =>
      @mainPath.animate transform: "r360", 1000, "<>", =>
        this.changeToPathTwo()

  changeToPathTwo: ->
    @mainPath.animate path:this.pathTwo(), 800, "<>", =>
      this.changeToPathThree()
    
  changeToPathThree: ->
    # just changing circles, 0 duration
    @mainPath.animate path:this.pathThree(), 0, "", =>
      this.changeToPathFour()

  changeToPathFour: ->
    @mainPath.animate path:this.pathFour(), 800, "<>", =>
      this.changeToPathFive()

  changeToPathFive: ->
    bBox = @mainPath.getBBox()

    diff = 700 - bBox.y2
    @mainPath.animate transform:"t0,#{diff}", 800, "bounce", =>
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
    result = Amoeba.Graphics.translatePath(result, 500+@index*50, 220);
  
    return result





