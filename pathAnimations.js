function PathAnimation(inColor, inOffset) {
	this.fillColor = inColor;
	this.offset = inOffset;

	// private member?  do I need this to be this?
	this.pathSwitch = false;

	// method
	this.setup = setup;

	// this is dumb
	var that = this;

	function setup(paper) {

		this.rectPath = makeRectanglePath(0, 0, 100, 400, 8, 8, 8, 8);

		this.rectPath = translatePath(this.rectPath, this.offset, 0);

		this.mainPath = paper.path(this.rectPath).attr({
			fill: this.fillColor
		});

		var theGear = gear[4].path;
		theGear = normalizePath(theGear);
		this.gear = scalePath(theGear, .5);
		this.gear = translatePath(this.gear, this.offset, 0);

		this.mainPath.attr({
			title: 'far out man'
		});

		this.mainPath.node.onclick = function() {
			animateNext();
		}
	}

	function animateNext() {
		var thePath = thePath = (+(that.pathSwitch = !that.pathSwitch)) ? that.gear : that.rectPath;

		that.mainPath.animate({
			path: thePath,
			fill: that.fillColor,
		}, 400, "bounce", function() {
			console.log("animation done");
		});
	}

}