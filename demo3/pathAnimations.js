function PathAnimation(inColor, inOffset) {
	this.fillColor = inColor;
	this.offset = inOffset;

	// private member?  do I need this to be this?
	this.pathSwitch = false;

	// method
	this.setup = setup;
	this.animate = animate;

	// this is dumb
	var that = this;

	function setup(paper) {

		this.rectPath = makeRectanglePath(0, 0, 100, 500);

		this.rectPath = translatePath(this.rectPath, this.offset, 0);

		this.mainPath = paper.path(this.rectPath).attr({
			fill: this.fillColor
		});

		var theGear = gear[4].path;
		this.gear = normalizePath(theGear);
		this.gear = scalePath(this.gear, .5);
		this.gear = translatePath(this.gear, this.offset, 0);
		this.gear = rotatePath(this.gear, 75);

		//this.gear = makeRectanglePath(0, 0, 200, 300);



		this.mainPath.attr({
			title: 'far out man',
			stroke: 'none'
		});

		this.mainPath.node.onclick = function() {
			that.animate();
			that.mainPath.toFront();
		}
	}

	function animate() {
		var thePath = thePath = (+(this.pathSwitch = !this.pathSwitch)) ? this.gear : this.rectPath;

		this.mainPath.animate({
			path: thePath,
			fill: this.fillColor,
		}, 800, "<>");
	}

}