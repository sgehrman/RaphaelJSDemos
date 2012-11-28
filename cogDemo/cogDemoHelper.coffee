
window.Amoeba ?= {}

class Amoeba.CogDemo
  constructor: (divHolder, @size, @numSegments) ->
    @graphicsPaper = new Amoeba.GraphicsPaper(divHolder)

    Amoeba.oneText = $("#one")
    Amoeba.twoText = $("#two")
    Amoeba.threeText = $("#three")
        
    @cog = new Amoeba.Cog(@size, @numSegments, @graphicsPaper);
    Amoeba.oneText.val @cog.path(true)
    Amoeba.twoText.val @cog.path(false)
    Amoeba.threeText.val makeRectanglePath(0,0,200,500)

    this._createAnimations()

    $("#run").on "click", (event) =>
      this.doAnimate()

    $("#showPoints").on "click", (event) =>
      @cog.showPoints()

    $("#hidePoints").on "click", (event) =>
      @graphicsPaper.clearPoints()

    $("#pulsatePoints").on "click", (event) =>
      @graphicsPaper.pulsatePoints()

    this._start()

  doAnimate: ->
    @animations.forEach (el) ->
      el.animate()

  _createAnimations: =>
    if @animations?
      num.remove() for num in @animations

    @animations = [new CogAnimation("#44f", 0, @graphicsPaper)] # , new CogAnimation("#f31", 420, @graphicsPaper)]
  
  _start: =>
    if @animations?
      one.slideIn() for one in @animations
  
# ///////////////////////////////////////////////////////////////////////
# ///////////////////////////////////////////////////////////////////////

class CogAnimation
  constructor: (@fillColor, @offset, graphicsPaper) ->
    @pathSwitch = true
    @removed = false;
    @mainPath = graphicsPaper.paper.path(this.pathOne(@offset)).attr({fill:@fillColor, "fill-opacity": 0, transform: "t1000,0"})
    
    @mainPath.node.onclick = =>
      this.animate()
      this.mainPath.toFront()

  remove: ->
    @removed = true

    # animate it out so it looks cool
    @mainPath.animate "fill-opacity":0, 400, "<>", =>
      @mainPath.remove()

  slideIn: ->
    params = {"fill-opacity": 1, transform: "t0,0"}

    @mainPath.animate params, 800, "<>", =>
      this.changeToPathTwo();

  changeToPathTwo: ->
    @mainPath.animate path:this.pathTwo(@offset), fill:@fillColor, 'fill-opacity': 0.4, 800, "<>", =>
      this.changeToPathThree();
    
  changeToPathThree: ->
    @mainPath.animate path:this.pathThree(@offset), fill:@fillColor, 'fill-opacity': 0.4, 800, "<>", =>
      console.log("cunt")

  pathOne: (offset) ->
    result = Amoeba.oneText.val()
    
    result = Amoeba.Graphics.normalizePath(result)
 
    result
    
  pathTwo: (offset) ->
    result = Amoeba.twoText.val()

    result = Amoeba.Graphics.normalizePath(result)
  
    result

  pathThree: (offset) ->
    result = Amoeba.threeText.val()

    result = Amoeba.Graphics.normalizePath(result)
  
    result
