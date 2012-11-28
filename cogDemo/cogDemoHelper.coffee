
window.Amoeba ?= {}

class Amoeba.CogDemo
  constructor: (divHolder, @size, @numSegments) ->
    @graphicsPaper = new Amoeba.GraphicsPaper(divHolder)

    Amoeba.oneText = $("#one")
    Amoeba.twoText = $("#two")
        
    theCog = new Amoeba.Cog(@size, @numSegments, @graphicsPaper);
    Amoeba.oneText.val theCog.path(true)
    Amoeba.twoText.val theCog.path(false)

    this._createAnimations()

    $("#run").on "click", (event) =>
      this.doAnimate()
    
  doAnimate: ->
    @animations.forEach (el) ->
      el.animate()

  _createAnimations: =>
    if @animations?
      num.remove() for num in @animations

    @animations = [new CogAnimation("#44f", 0, @graphicsPaper)] # , new CogAnimation("#f31", 420, @graphicsPaper)]
  
# ///////////////////////////////////////////////////////////////////////
# ///////////////////////////////////////////////////////////////////////

class CogAnimation
  constructor: (@fillColor, @offset, graphicsPaper) ->
    @pathSwitch = true
    @removed = false;
    @mainPath = graphicsPaper.paper.path(this.pathOne(@offset)).attr(fill:@fillColor)
    
    @mainPath.node.onclick = =>
      this.animate()
      this.mainPath.toFront()

  remove: ->
    @removed = true

    # animate it out so it looks cool
    @mainPath.animate "fill-opacity":0, 400, "<>", =>
      @mainPath.remove()

  animate: ->
    if (+(@pathSwitch = not @pathSwitch)) 
      thePath = this.pathOne(@offset)
    else
      thePath = this.pathTwo(@offset)

    @mainPath.stop();

    @mainPath.animate path:thePath, fill:@fillColor, 'fill-opacity': 0.4, 800, "<>", =>
      if (jQuery('#repeatCheck').is(':checked'))
        if (not @removed)
          this.animate()

  pathOne: (offset) ->
    result = Amoeba.oneText.val()
    
    result = Amoeba.Graphics.normalizePath(result)
 
    result
    
  pathTwo: (offset) ->
    result = Amoeba.twoText.val()

    result = Amoeba.Graphics.normalizePath(result)
  
    result
