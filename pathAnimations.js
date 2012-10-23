function PathAnimation(inColor) {
	this.fillColor = inColor;

	// method
	this.setup = setup;

	function setup() {
		var paper = Raphael(0, 280, 650, 650);

		var theGradient = "90-#aaf-#004";

		paper.rect(0, 0, 850, 650).attr({
			fill: theGradient,
			stroke: '#f99',
			title: 'background'
		});

		var rectPath = makeRectanglePath(0, 0, 100, 400, 8, 8, 8, 8);
		var pathSwitch = false;

		var theRect = paper.path(rectPath).attr({
			fill: this.fillColor
		});

		var theGear = gear[4].path;
		theGear = normalizePath(theGear);
		theGear = scalePath(theGear, .5);

		theRect.attr({
			title: 'far out man'
		});

		var that = this;

		function animateNext() {
			var thePath = thePath = (+(pathSwitch = !pathSwitch)) ? theGear : rectPath;

			theRect.animate({
				path: thePath,
				fill: that.fillColor,
			}, 400, "bounce", function() {
				console.log("animation done");
			});
		}

		theRect.node.onclick = function() {
			animateNext();
		}
	}
}