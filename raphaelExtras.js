function makeCirclePath(x, y, r) // x and y are center and r is the radius
{
  var s = "M" + "" + (x) + "," + (y - r) + "A" + r + "," + r + ",0,1,1," + (x - 0.1) + "," + (y - r) + "z";

  return s;
}

function makeRectanglePath(x, y, w, h, r1, r2, r3, r4) {
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

function makeTrianglePath(x, y, x1, y1, x2, y2) {
  var result = "M" + x + "," + y;

  result += "L" + x1 + "," + y1;
  result += "L" + x2 + "," + y2;

  return result;
}
