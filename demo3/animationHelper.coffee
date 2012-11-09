
window.Amoeba ?= {}

class Amoeba.Animations
	constructor: ->
	  this.setupPathFields()
	  this.setupAnimations()
	  this.setupEventHandlers();

	setupAnimations: ->
	  paper = Raphael(0, 280, 850, 650)
	  paper.rect(0, 0, 850, 650).attr
	    fill: "90-#aaf-#004"
	    stroke: "#f99"
	    title: "background"

	  @animations = [new PathAnimation(paper, "#44f", 0), new PathAnimation(paper, "#f32", 420)]

	doAnimate: ->
	  @animations.forEach (el) ->
	    el.animate()

	setupPathFields: ->
	  Amoeba.oneText = $("#one")
	  Amoeba.twoText = $("#two")

	  # default gear paths in cog.js
	  Amoeba.oneText.val gearPath
	  Amoeba.twoText.val circleGearPath

	setupEventHandlers: ->
	  $("#gears").on "click", (event) =>
	    Amoeba.oneText.val gearPath
	    Amoeba.twoText.val circleGearPath
	    this.doAnimate()

	  $("#rects").on "click", (event) =>
	    Amoeba.oneText.val makeRectanglePath(0, 0, 100, 500)
	    Amoeba.twoText.val makeRectanglePath(0, 0, 200, 300)
	    this.doAnimate()

	  $("#run").on "click", (event) =>
	    this.doAnimate()

class PathAnimation
	constructor: (paper, @fillColor, @offset) ->
		@pathSwitch = true

		@mainPath = paper.path(this.pathOne(@offset)).attr(fill:@fillColor)
		
		@mainPath.node.onclick = =>
			this.animate()
			this.mainPath.toFront()

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
