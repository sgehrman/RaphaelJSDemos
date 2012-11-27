function makeCirclePath(x, y, r) // x and y are center and r is the radius
{
  var s = "M" + "" + (x) + "," + (y - r) + "A" + r + "," + r + ",0,1,1," + (x - 0.1) + "," + (y - r) + "z";

  return s;
}

function makeRoundRectanglePath(x, y, w, h, r1, r2, r3, r4) {
  var strPath = "M" + p(x + r1, y);
  strPath += "L" + p(x + w - r2, y) + "Q" + p(x + w, y) + p(x + w, y + r2);
  strPath += "L" + p(x + w, y + h - r3) + "Q" + p(x + w, y + h) + p(x + w - r3, y + h);
  strPath += "L" + p(x + r4, y + h) + "Q" + p(x, y + h) + p(x, y + h - r4);
  strPath += "L" + p(x, y + r1) + "Q" + p(x, y) + p(x + r1, y);
  strPath += "Z";

  // inner function

  function p(x, y) {
    return x + " " + y + " ";
  }

  return strPath;
}

function makeRectanglePath(x, y, w, h) {
  var strPath;

  strPath = "M" + p(x, y);

  var complex = false;

  strPath += lineX(w, complex);
  strPath += lineY(h, complex);
  strPath += lineX(-w, complex);
  strPath += lineY(-h, complex);

  // inner function

  function p(x, y) {
    return x + " " + y + " ";
  }

  function lineY(y, complex) {
    var strPath = "";

    if(!complex) {
      strPath += "l" + p(0, y);
    } else {
      if(y < 0) {
        while(y !== 0) {
          strPath += "l" + p(0, -1);
          y += 1;
        }
      } else {
        while(y > 0) {
          strPath += "l" + p(0, 1);
          y -= 1;
        }
      }
    }

    return strPath;
  }

  function lineX(x, complex) {
    var strPath = "";

    if(!complex) {
      strPath += "l" + p(x, 0);
    } else {
      if(x < 0) {
        while(x !== 0) {
          strPath += "l" + p(-1, 0);
          x += 1;
        }
      } else {
        while(x > 0) {
          strPath += "l" + p(1, 0);
          x -= 1;
        }
      }
    }
    return strPath;
  }

  return strPath;
}

function makeTrianglePath(x, y, x1, y1, x2, y2) {
  var result = "M" + x + "," + y;

  result += "L" + x1 + "," + y1;
  result += "L" + x2 + "," + y2;

  return result;
}

// moves the path so it starts at 0,0

function normalizePath(path) {
  var bBox = Raphael.pathBBox(path);

  var theMatrix = new Raphael.matrix();
  theMatrix.translate(-bBox.x, -bBox.y);

  var transformString = theMatrix.toTransformString();
  path = Raphael.transformPath(path, transformString);

  return path;
}

function scalePath(path, amount) {
  var bBox = Raphael.pathBBox(path);

  var theMatrix = new Raphael.matrix();
  theMatrix.scale(amount, amount);

  var transformString = theMatrix.toTransformString();
  path = Raphael.transformPath(path, transformString);

  return path;
}

function translatePath(path, amountX, amountY) {
  var bBox = Raphael.pathBBox(path);

  var theMatrix = new Raphael.matrix();
  theMatrix.translate(amountX, amountY);

  var transformString = theMatrix.toTransformString();
  path = Raphael.transformPath(path, transformString);

  return path;
}

function rotatePath(path, degrees) {
  var bBox = Raphael.pathBBox(path);

  var theMatrix = new Raphael.matrix();
  theMatrix.rotate(degrees, bBox.x + (bBox.width / 2), bBox.y + (bBox.height / 2));

  var transformString = theMatrix.toTransformString();
  path = Raphael.transformPath(path, transformString);

  return path;
}

function crap(r)
{
  var angle = 0;
  while (angle < 360) {
      var color = Raphael.getColor();
      (function (t, c) {
          var theCircle = r.circle(320, 450, 20).attr({stroke: c, fill: c, transform: t, "fill-opacity": 0.4});

          theCircle.click(function () {
              s.animate({transform: t, stroke: c}, 2000, "bounce");
          })
          theCircle.mouseover(function () {
              this.animate({"fill-opacity": 0.75}, 500);
          })
          theCircle.mouseout(function () {
              this.animate({"fill-opacity": 0.4}, 500);
          });

      })("r" + angle + " 320 240", color);
      
      angle += 30;
  }
  Raphael.getColor.reset();
  var s = r.set();
  s.push(r.path("M320,240c-50,100,50,110,0,190").attr({fill: "none", "stroke-width": 2}));
  s.push(r.circle(320, 450, 20).attr({fill: "none", "stroke-width": 2}));
  s.push(r.circle(320, 240, 5).attr({fill: "none", "stroke-width": 10}));
  s.attr({stroke: Raphael.getColor()});
}


