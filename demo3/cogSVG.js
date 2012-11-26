// Generated by CoffeeScript 1.4.0
(function() {
  var CogSegment, Point, PointPair, _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  if ((_ref = window.Amoeba) == null) {
    window.Amoeba = {};
  }

  Amoeba.Cog = (function() {

    function Cog(size, numSegments) {
      this.size = size;
      this.numSegments = numSegments;
      this._createCogSegments = __bind(this._createCogSegments, this);

      this._pairsAroundCircle = __bind(this._pairsAroundCircle, this);

      this._pointsAroundCircle = __bind(this._pointsAroundCircle, this);

    }

    Cog.prototype.path = function(showTeeth) {
      var result, segment, segments, _i, _len;
      segments = this._createCogSegments(this.size, showTeeth, this.numSegments);
      result = null;
      for (_i = 0, _len = segments.length; _i < _len; _i++) {
        segment = segments[_i];
        if (!(result != null)) {
          result = "M" + segment.bottomLeft.x + "," + segment.bottomLeft.y;
        }
        result += segment.path();
      }
      result += "z";
      return result;
    };

    Cog.prototype._pointsAroundCircle = function(size, inset, numSegments, shift) {
      var angle, centerX, centerY, cosValue, degrees, degreesShift, i, radius, result, sinValue, x, y, _i;
      if (shift == null) {
        shift = 0;
      }
      centerX = size / 2;
      centerY = size / 2;
      radius = (size - (inset * 2)) / 2;
      degrees = 360 / numSegments;
      result = [];
      for (i = _i = 0; 0 <= numSegments ? _i <= numSegments : _i >= numSegments; i = 0 <= numSegments ? ++_i : --_i) {
        angle = i * degrees;
        degreesShift = degrees * 0.15;
        if (shift === -1) {
          angle -= degreesShift;
        } else if (shift === 1) {
          angle += degreesShift;
        }
        if (angle >= 360) {
          angle = angle - 360;
        } else if (angle < 0) {
          angle = 360 + angle;
        }
        cosValue = Math.cos(toRadians(angle));
        sinValue = Math.sin(toRadians(angle));
        x = centerX + (cosValue * radius);
        y = centerY + (sinValue * radius);
        result.push(new Point(x, y));
      }
      return result;
    };

    Cog.prototype._pairsAroundCircle = function(size, inset, numSegments, shifted) {
      var i, leftPoints, nextPoint, points, prevPoint, result, rightPoints, _i, _j, _len, _ref1;
      if (shifted == null) {
        shifted = false;
      }
      result = [];
      if (!shifted) {
        points = this._pointsAroundCircle(size, inset, numSegments);
        prevPoint = null;
        for (_i = 0, _len = points.length; _i < _len; _i++) {
          nextPoint = points[_i];
          if ((prevPoint != null)) {
            result.push(new PointPair(prevPoint, nextPoint));
          }
          prevPoint = nextPoint;
        }
      } else {
        leftPoints = this._pointsAroundCircle(size, inset, numSegments, 1);
        rightPoints = this._pointsAroundCircle(size, inset, numSegments, -1);
        for (i = _j = 0, _ref1 = leftPoints.length - 1; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
          result.push(new PointPair(leftPoints[i], rightPoints[i + 1]));
        }
      }
      return result;
    };

    Cog.prototype._createCogSegments = function(size, showTeeth, numSegments) {
      var i, innerPoint, innerPoints, isTooth, newSegment, outerPoint, outerPoints, result, toothHeight, _i;
      result = [];
      toothHeight = 0;
      outerPoints = this._pairsAroundCircle(size, 0, numSegments, false);
      if (showTeeth) {
        toothHeight = outerPoints[0].left.distance(outerPoints[0].right) * 0.55;
      }
      innerPoints = this._pairsAroundCircle(size, toothHeight, numSegments, false);
      if ((outerPoints.length !== innerPoints.length) || (outerPoints.length !== numSegments)) {
        console.log("inner and outer points not right?");
      } else {
        isTooth = false;
        for (i = _i = 0; 0 <= numSegments ? _i < numSegments : _i > numSegments; i = 0 <= numSegments ? ++_i : --_i) {
          outerPoint = outerPoints[i];
          innerPoint = innerPoints[i];
          newSegment = new CogSegment(isTooth, size, toothHeight, outerPoint.left, outerPoint.right, innerPoint.left, innerPoint.right);
          result.push(newSegment);
          isTooth = !isTooth;
        }
      }
      return result;
    };

    return Cog;

  })();

  Point = (function() {

    function Point(x, y) {
      this.x = x;
      this.y = y;
    }

    Point.prototype.toString = function() {
      return "(" + this.x + ", " + this.y + ")";
    };

    Point.prototype.distance = function(point2) {
      var xs, ys;
      xs = point2.x - this.x;
      xs = xs * xs;
      ys = point2.y - this.y;
      ys = ys * ys;
      return Math.sqrt(xs + ys);
    };

    return Point;

  })();

  PointPair = (function() {

    function PointPair(left, right) {
      this.left = left;
      this.right = right;
    }

    PointPair.prototype.toString = function() {
      return "(" + this.left + ", " + this.right + ")";
    };

    return PointPair;

  })();

  CogSegment = (function() {

    function CogSegment(isTooth, size, toothHeight, topLeft, topRight, bottomLeft, bottomRight) {
      this.isTooth = isTooth;
      this.size = size;
      this.toothHeight = toothHeight;
      this.topLeft = topLeft;
      this.topRight = topRight;
      this.bottomLeft = bottomLeft;
      this.bottomRight = bottomRight;
      this.outerRadius = this.size / 2;
      this.innerRadius = (this.size - (this.toothHeight * 2)) / 2;
    }

    CogSegment.prototype.toString = function() {
      return "(" + this.topLeft + ", " + this.topRight + ", " + this.bottomLeft + ", " + this.bottomRight + ")";
    };

    CogSegment.prototype.path = function() {
      var flag, result;
      result = "";
      if (this.isTooth) {
        result += "L" + this.topLeft.x + "," + this.topLeft.y;
        result += "A" + this.outerRadius + "," + this.outerRadius + ",0,0,1," + this.topRight.x + "," + this.topRight.y;
        result += "L" + this.bottomRight.x + "," + this.bottomRight.y;
      } else {
        flag = 1;
        if (this.toothHeight > 0) {
          flag = 0;
        }
        result += "A" + this.outerRadius + "," + this.outerRadius + ",0,0," + flag + "," + this.bottomRight.x + "," + this.bottomRight.y;
      }
      return result;
    };

    return CogSegment;

  })();

}).call(this);
