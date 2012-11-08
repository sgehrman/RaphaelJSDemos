window.Globelz = {}


function setupAnimations() {
  var theGradient = "90-#aaf-#004";
  var paper = Raphael(0, 280, 650, 650);

  paper.rect(0, 0, 850, 650).attr({
    fill: theGradient,
    stroke: '#f99',
    title: 'background'
  });

  var animations = [
  new PathAnimation('#44f', 0), new PathAnimation('#f33', 100), new PathAnimation('#2f2', 200), new PathAnimation('#232', 300), new PathAnimation('#f1f', 400)];

  animations.forEach(function(el) {
    el.setup(paper);
  });

  // control button
  var controlPaper = Raphael(0, 100, 50, 50);
  var circle = controlPaper.circle(22, 22, 22).attr({
    fill: '#333',
    stroke: '#29f'
  });

  circle.node.onclick = function() {
    // tell all the animations to run
    animations.forEach(function(el) {
      el.animate();
    });
  }
}

function setupPathFields() {
  var $ = jQuery;

  Globelz.oneText = $('#one');
  Globelz.twoText = $('#two');

  Globelz.oneText.text(gearPath);
  Globelz.twoText.text(circleGearPath);

  $("#cunt").on("click", function(event) {

    Globelz.oneText.text(gearPath);
    Globelz.twoText.text(circleGearPath);


    alert("reset to defaults.");
  });

  $("#rects").on("click", function(event) {

    Globelz.oneText.text(makeRectanglePath(0, 0, 100, 500));
    Globelz.twoText.text(makeRectanglePath(0, 0, 200, 500));

    alert("set to rects.");
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
  var result = Globelz.oneText.text();

  console.log("One" + result);

  // modify paths
  result = normalizePath(result);
//  result = scalePath(result, .5);
  result = translatePath(result, offset, 0);
 // result = rotatePath(result, 180);
  // removes the hole in the cog
  if(false) {
    result = removeGearHole(result);
  }

  return result;
}

function pathTwo(offset) {
  var result = Globelz.twoText.text();

  console.log("Two" + result);

  result = normalizePath(result);
 // result = scalePath(result, .5);
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
    }
  }

  function animate() {
    var thePath = (+(pathSwitch = !pathSwitch)) ? pathOne(this.offset) : pathTwo(this.offset);

    this.mainPath.animate({
      path: thePath,
      fill: this.fillColor,
    }, 800, "<>");
  }

}