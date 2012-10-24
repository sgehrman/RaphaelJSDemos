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

 
  strPath = "M" + p(x, y+h);
  
  strPath += lineX(w);
  strPath += lineY(-h);
  strPath += lineX(-w);
  strPath += lineY(h);


  // inner function

  function p(x, y) {
    return x + " " + y + " ";
  }




function lineY(y) {

 return "l" + p(0, y);


  var strPath = "";

  if (y < 0) {
    while (y != 0) {
      strPath += "l" + p(0, -1);
      y += 1;
    }
  } else {
    while(y > 0) {
      strPath += "l" + p(0, 1);
      y -= 1;
    }
  }

  return strPath;
}


function lineX(x) {

  return "l" + p(x, 0);

  var strPath = "";

  if (x < 0) {
    while (x != 0) {
      strPath += "l" + p(-1, 0);
      x += 1;
    }
  } else {
    while(x > 0) {
      strPath += "l" + p(1, 0);
      x -= 1;
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

  var theMatrix = new Raphael.matrix;
  theMatrix.translate(-bBox.x, -bBox.y);

  var transformString = theMatrix.toTransformString();
  path = Raphael.transformPath(path, transformString);

  return path;
}

function scalePath(path, amount) {
  var bBox = Raphael.pathBBox(path);

  var theMatrix = new Raphael.matrix;
  theMatrix.scale(amount, amount);

   var transformString = theMatrix.toTransformString();
  path = Raphael.transformPath(path, transformString);

  return path;
}

function translatePath(path, amountX, amountY) {
  var bBox = Raphael.pathBBox(path);

  var theMatrix = new Raphael.matrix;
  theMatrix.translate(amountX, amountY);

   var transformString = theMatrix.toTransformString();
  path = Raphael.transformPath(path, transformString);

  return path;
}

function rotatePath(path, degrees) {
  var bBox = Raphael.pathBBox(path);

  var theMatrix = new Raphael.matrix;
  theMatrix.rotate(degrees, bBox.x + (bBox.width / 2), bBox.y + (bBox.height / 2));

   var transformString = theMatrix.toTransformString();
  path = Raphael.transformPath(path, transformString);

  return path;
}

