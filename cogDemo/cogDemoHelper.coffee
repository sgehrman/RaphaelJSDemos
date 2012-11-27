
window.Amoeba ?= {}

class Amoeba.CogDemo
  constructor: ->
    @graphicsPort = new Amoeba.GraphicsPaper(new Amoeba.Rect(0, 380, 850, 650))

  setupAnimations: ->
    this._createAnimations()
    
  doAnimate: ->
    @animations.forEach (el) ->
      el.animate()

  setupPathFields: ->
    Amoeba.oneText = $("#one")
    Amoeba.twoText = $("#two")
        
    theCog = new Amoeba.Cog(400, 34, @graphicsPort);
    Amoeba.oneText.val theCog.path(true)
    Amoeba.twoText.val theCog.path(false)

    $("#run").on "click", (event) =>
      this.doAnimate()

  _createAnimations: =>
    if @animations?
      num.remove() for num in @animations

    @animations = [new CogAnimation("#44f", 0, @graphicsPort)] # , new CogAnimation("#f31", 420, @graphicsPort)]
  
# ///////////////////////////////////////////////////////////////////////
# ///////////////////////////////////////////////////////////////////////

class CogAnimation
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
    
    # result = Amoeba.Graphics.scalePath(result, 0.5)
 
    result
    
  pathTwo: (offset) ->
    result = Amoeba.twoText.val()

    # result = Amoeba.Graphics.scalePath(result, 0.5)
  
    result
