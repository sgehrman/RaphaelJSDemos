
window.Amoeba ?= {}

class Amoeba.Animations
	constructor: ->
	  @animations = [new PathAnimation("#44f", 0)]

	setupAnimations: ->
	  paper = Raphael(0, 280, 650, 650)
	  paper.rect(0, 0, 850, 650).attr
	    fill: "90-#aaf-#004"
	    stroke: "#f99"
	    title: "background"

	  @animations.forEach (el) ->
	    el.setup paper

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
	    Amoeba.twoText.val makeRectanglePath(0, 0, 200, 500)
	    this.doAnimate()

	  $("#run").on "click", (event) =>
	    this.doAnimate()

class PathAnimation
	constructor: (@fillColor, @offset) ->
		@pathSwitch = true

	setup: (paper) ->
		@mainPath = paper.path(this.pathOne(@offset)).attr(fill:@fillColor)
		@mainPath.node.onclick = =>
			this.animate()
			this.mainPath.toFront()

	animate: ->
		thePath = (if (+(@pathSwitch = not @pathSwitch)) then this.pathOne(@offset) else this.pathTwo(@offset))

		@mainPath.animate path:thePath, fill:@fillColor, 800, "<>"

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
