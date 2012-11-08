window.Globelz = {}


function setupAnimations() {
  var theGradient = "90-#aaf-#004";
  var paper = Raphael(0, 280, 650, 650);

  paper.rect(0, 0, 850, 650).attr({
    fill: theGradient,
    stroke: '#f99',
    title: 'background'
  });

  Globelz.animations = [
  new PathAnimation('#44f', 0)
  // new PathAnimation('#f33', 100),
  //  new PathAnimation('#2f2', 200),
  //   new PathAnimation('#232', 300),
  //    new PathAnimation('#f1f', 400)
  ];

  Globelz.animations.forEach(function(el) {
    el.setup(paper);
  });
}

function doAnimate() {
  // tell all the animations to run
  Globelz.animations.forEach(function(el) {
    el.animate();
  });
}

function setupPathFields() {
  var $ = jQuery;

  Globelz.oneText = $('#one');
  Globelz.twoText = $('#two');

  Globelz.oneText.val(gearPath);
  Globelz.twoText.val(circleGearPath);

  $("#gears").on("click", function(event) {

    Globelz.oneText.val(gearPath);
    Globelz.twoText.val(circleGearPath);

    doAnimate();
  });

  $("#rects").on("click", function(event) {

    Globelz.oneText.val(makeRectanglePath(0, 0, 100, 500));
    Globelz.twoText.val(makeRectanglePath(0, 0, 200, 500));

    doAnimate();
  });

  $("#run").on("click", function(event) {

    doAnimate();
  });

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

  if(found !== -1) return theArray.slice(0, found);
}

function pathOne(offset) {
  var result = Globelz.oneText.val();

  // modify paths
  result = normalizePath(result);
  // result = scalePath(result, 0.5);
  result = translatePath(result, offset, 0);
  // result = rotatePath(result, 180);
  // removes the hole in the cog
  if(false) {
    result = removeGearHole(result);
  }

  return result;
}

function pathTwo(offset) {
  var result = Globelz.twoText.val();

  result = normalizePath(result);
 // result = scalePath(result, 0.5);
  result = translatePath(result, offset, 0);
  //  result = rotatePath(result, 180);
  return result;
}

function PathAnimation(inColor, inOffset) {
  this.fillColor = inColor;
  this.offset = inOffset;

  var pathSwitch = true;

  // method
  this.setup = setup;
  this.animate = animate;

  // this is dumb
  var that = this;

  function setup(paper) {
    this.mainPath = paper.path(pathOne(this.offset)).attr({
      fill: this.fillColor
    });

    this.mainPath.node.onclick = function() {
      that.animate();
      that.mainPath.toFront();
    };
  }

  function animate() {
    var thePath = (+(pathSwitch = !pathSwitch)) ? pathOne(this.offset) : pathTwo(this.offset);

    this.mainPath.animate({
      path: thePath,
      fill: this.fillColor
    }, 800, "<>");
  }

}