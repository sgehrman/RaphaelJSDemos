
function setupAnimation() {
	var paper = Raphael(0, 280, 650, 650);

	var theGradient = "90-#aaf-#004";

	paper.rect(0, 0, 650, 650).attr({
		fill: theGradient,
		'fill-opacity': .4,
		stroke: '#f99',
		title: 'background'
	});

	var rectPath = makeRectanglePath(0, 0, 100, 400, 8, 8, 8, 8);
	var pathSwitch = false;

	var theRect = paper.path(rectPath).attr({
		fill: '#333'
	});

	var theGear = gear[4].path;
	theGear = normalizePath(theGear);
	theGear = scalePath(theGear, .5);

	theRect.attr({
		title: 'far out man'
	});

	function animateNext() {
		var thePath = rectPath;
		if(+(pathSwitch = !pathSwitch)) thePath = theGear;

		theRect.animate({
			path: thePath,
			fill: Raphael.getColor(),
			'fill-opacity': 0.4
		}, 400, "bounce", function() {
			console.log("animation done");
		});
	}

	theRect.node.onclick = function() {
		animateNext();
	}
}