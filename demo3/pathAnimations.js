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

	// private vars
	// getting the gears out of "cog.js"
	var gear = gearPath;
	var circleGear = circleGearPath;

	function setup(paper) {
     	// not used now, saving 
		// this.startPath = makeRectanglePath(0, 0, 100, 500);
		// this.startPath = translatePath(this.startPath, this.offset, 0);

		// removes the hole in the cog
		if(false) {
			gear = removeGearHole(gear);
		}

		gear = normalizePath(gear);
		gear = scalePath(gear, .5);
		gear = translatePath(gear, this.offset, 0);
		// gear = rotatePath(gear, 180);
		//gear = makeRectanglePath(0, 0, 200, 300);

		circleGear = normalizePath(circleGear);
		circleGear = scalePath(circleGear, .5);
		circleGear = translatePath(circleGear, this.offset, 0);
		//circleGear = rotatePath(circleGear, 75);
		

		this.startPath = circleGear;
		this.mainPath = paper.path(this.startPath).attr({
			fill: this.fillColor
		});

		this.mainPath.node.onclick = function() {
			that.animate();
			that.mainPath.toFront();
		}
	}

	function animate() {
		var thePath = thePath = (+(this.pathSwitch = !this.pathSwitch)) ? gear : this.startPath;

		this.mainPath.animate({
			path: thePath,
			fill: this.fillColor,
		}, 800, "<>");
	}

	function removeGearHole(theGear) {
		var theArray = Raphael.parsePathString(theGear);
		var found = -1;
		var index = 0;

		var theResult = theArray.some(function(item) {
			index += 1;

			if(item.toString() === "z") {
				found = index;
				return true;
			}

			return false;
		});

		if(found !== -1) 
			return theArray.slice(0, found);
	}


}