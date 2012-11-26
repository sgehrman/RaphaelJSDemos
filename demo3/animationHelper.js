// Generated by CoffeeScript 1.4.0
(function() {
  var CogSegment, PathAnimation, Point, PointPair, _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  if ((_ref = window.Amoeba) == null) {
    window.Amoeba = {};
  }

  Amoeba.Animations = (function() {

    function Animations() {
      this._cogPath = __bind(this._cogPath, this);

      this._createCogSegments = __bind(this._createCogSegments, this);

      this._pairsAroundCircle = __bind(this._pairsAroundCircle, this);

      this._toothHeight = __bind(this._toothHeight, this);

      this._shieldPath = __bind(this._shieldPath, this);

      this._updateStatus = __bind(this._updateStatus, this);

      this._createAnimations = __bind(this._createAnimations, this);

      this._diamondPath = __bind(this._diamondPath, this);

    }

    Animations.prototype.setupAnimations = function() {
      this.paper = Raphael(0, 380, 850, 650);
      this.paper.rect(0, 0, 850, 650).attr({
        fill: "90-#aaf-#004",
        stroke: "#f99",
        title: "background"
      });
      return this._createAnimations();
    };

    Animations.prototype.doAnimate = function() {
      return this.animations.forEach(function(el) {
        return el.animate();
      });
    };

    Animations.prototype.setupPathFields = function() {
      var _this = this;
      Amoeba.oneText = $("#one");
      Amoeba.twoText = $("#two");
      Amoeba.statusText = $("#status");
      Amoeba.oneText.val(gearPath);
      Amoeba.twoText.val(circleGearPath);
      $("#gears").on("click", function(event) {
        Amoeba.oneText.val(gearPath);
        Amoeba.twoText.val(circleGearPath);
        _this.doAnimate();
        return _this._updateStatus("Showing gears");
      });
      $("#rects").on("click", function(event) {
        Amoeba.oneText.val(makeRectanglePath(0, 0, 100, 500));
        Amoeba.twoText.val(makeRectanglePath(0, 0, 200, 300));
        _this.doAnimate();
        return _this._updateStatus("Showing rects");
      });
      $("#example1").on("click", function(event) {
        var result;
        result = "M0,0c11,0 20,9 20,20c0,11 -9,20 -20,20c-11,0 -20-9 -20-20c0-11 9-20 20-20z";
        Amoeba.oneText.val(result);
        result = _this._diamondPath(20);
        Amoeba.twoText.val(result);
        _this._updateStatus("Showing example1");
        return _this.doAnimate();
      });
      $("#example2").on("click", function(event) {
        var result;
        result = makeCirclePath(0, 0, 20);
        Amoeba.oneText.val(result);
        result = _this._diamondPath(20);
        Amoeba.twoText.val(result);
        _this._updateStatus("Showing example2");
        return _this.doAnimate();
      });
      $("#example3").on("click", function(event) {
        var result;
        result = "M0,0 h-150 a150,150 0 1,0 150,-150z";
        Amoeba.oneText.val(result);
        result = _this._diamondPath(200);
        Amoeba.twoText.val(result);
        _this._updateStatus("Showing example3");
        return _this.doAnimate();
      });
      $("#example4").on("click", function(event) {
        var result;
        result = _this._cogPath();
        Amoeba.oneText.val(result);
        result = _this._cogPath(false);
        Amoeba.twoText.val(result);
        _this._updateStatus("Showing example3");
        return _this.doAnimate();
      });
      $("#example5").on("click", function(event) {
        var result;
        result = _this._shieldPath(360 / 10);
        Amoeba.oneText.val(result);
        result = _this._shieldPath(360 / 10, true);
        Amoeba.twoText.val(result);
        _this._updateStatus("Showing example3");
        return _this.doAnimate();
      });
      $("#revDiamond").on("change", function(event) {
        var result;
        result = _this._diamondPath(200);
        Amoeba.twoText.val(result);
        _this._createAnimations();
        return _this.doAnimate();
      });
      return $("#run").on("click", function(event) {
        return _this.doAnimate();
      });
    };

    Animations.prototype._diamondPath = function(width) {
      var result;
      if (width == null) {
        width = 20;
      }
      result = "M0,0l" + width + "," + width + " -" + width + "," + width + " -" + width + "-" + width + "z";
      if (jQuery('#revDiamond').is(':checked')) {
        result = "M0,0l-" + width + "," + width + " " + width + "," + width + " " + width + "-" + width + "z";
        console.log("reversed");
      }
      return result;
    };

    Animations.prototype._createAnimations = function() {
      var num, _i, _len, _ref1;
      if (this.animations != null) {
        _ref1 = this.animations;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          num = _ref1[_i];
          num.remove();
        }
      }
      return this.animations = [new PathAnimation("#44f", 0, this.paper)];
    };

    Animations.prototype._updateStatus = function(inStatus) {
      return Amoeba.statusText.text(inStatus);
    };

    Animations.prototype._shieldPath = function(increment, useArcs) {
      var angle, centerX, centerY, dim, radius, result, x1, y1;
      if (increment == null) {
        increment = 45;
      }
      if (useArcs == null) {
        useArcs = false;
      }
      dim = 400;
      radius = dim / 2;
      centerX = dim / 2;
      centerY = dim / 2;
      angle = 0;
      while (angle <= 360) {
        x1 = centerX + (Math.cos(toRadians(angle)) * radius);
        y1 = centerY + (Math.sin(toRadians(angle)) * radius);
        if (angle === 0) {
          result = "M" + x1 + "," + y1;
        } else {
          if (useArcs) {
            result += "A" + radius + "," + radius + ",0,0,1," + x1 + "," + y1;
          } else {
            result += "A" + (radius / 2) + "," + (radius / 2) + ",0,0,0," + x1 + "," + y1;
          }
        }
        angle += increment;
      }
      result += "z";
      return result;
    };

    Animations.prototype._toothHeight = function(size, numSegments) {
      var outerPoints;
      outerPoints = this._pairsAroundCircle(size, 0, numSegments);
      return outerPoints[0].left.distance(outerPoints[0].right) * 0.55;
    };

    Animations.prototype._pairsAroundCircle = function(size, inset, numSegments) {
      var angle, centerX, centerY, cosValue, degrees, i, nextPoint, points, prevPoint, radius, result, sinValue, x, y, _i, _j, _len;
      centerX = size / 2;
      centerY = size / 2;
      degrees = 360 / numSegments;
      radius = (size - (inset * 2)) / 2;
      points = [];
      for (i = _i = 0; 0 <= numSegments ? _i <= numSegments : _i >= numSegments; i = 0 <= numSegments ? ++_i : --_i) {
        angle = i * degrees;
        if (angle >= 360) {
          angle = 360 - angle;
        }
        cosValue = Math.cos(toRadians(angle));
        sinValue = Math.sin(toRadians(angle));
        x = centerX + (cosValue * radius);
        y = centerY + (sinValue * radius);
        points.push(new Point(x, y));
      }
      result = [];
      prevPoint = null;
      for (_j = 0, _len = points.length; _j < _len; _j++) {
        nextPoint = points[_j];
        if ((prevPoint != null)) {
          result.push(new PointPair(prevPoint, nextPoint));
        }
        prevPoint = nextPoint;
      }
      return result;
    };

    Animations.prototype._createCogSegments = function(size, showTeeth, numSegments) {
      var i, innerPoint, innerPoints, isTooth, newSegment, outerPoint, outerPoints, result, toothHeight, _i;
      result = [];
      toothHeight = 0;
      if (showTeeth) {
        toothHeight = this._toothHeight(size, numSegments);
      }
      outerPoints = this._pairsAroundCircle(size, 0, numSegments);
      innerPoints = this._pairsAroundCircle(size, toothHeight, numSegments);
      if ((outerPoints.length !== innerPoints.length) || (outerPoints.length !== numSegments)) {
        console.log("inner and outer points not OK?");
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

    Animations.prototype._cogPath = function(showTeeth) {
      var result, segment, segments, _i, _len;
      if (showTeeth == null) {
        showTeeth = true;
      }
      segments = this._createCogSegments(500, showTeeth, 34);
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

    return Animations;

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

  PathAnimation = (function() {

    function PathAnimation(fillColor, offset, paper) {
      var _this = this;
      this.fillColor = fillColor;
      this.offset = offset;
      this.pathSwitch = true;
      this.stopped = false;
      this.mainPath = paper.path(this.pathOne(this.offset)).attr({
        fill: this.fillColor
      });
      this.mainPath.node.onclick = function() {
        _this.animate();
        return _this.mainPath.toFront();
      };
    }

    PathAnimation.prototype.remove = function() {
      var _this = this;
      this.stopped = true;
      return this.mainPath.animate({
        "fill-opacity": 0
      }, 400, "<>", function() {
        return _this.mainPath.remove();
      });
    };

    PathAnimation.prototype.animate = function() {
      var thePath,
        _this = this;
      if (+(this.pathSwitch = !this.pathSwitch)) {
        thePath = this.pathOne(this.offset);
      } else {
        thePath = this.pathTwo(this.offset);
      }
      return this.mainPath.animate({
        path: thePath,
        fill: this.fillColor
      }, 800, "elastic", function() {
        if (!_this.stopped) {
          if (jQuery('#repeatCheck').is(':checked')) {
            return _this.animate();
          }
        }
      });
    };

    PathAnimation.prototype.pathOne = function(offset) {
      var result;
      result = Amoeba.oneText.val();
      result = normalizePath(result);
      result = translatePath(result, offset, 0);
      return result;
    };

    PathAnimation.prototype.pathTwo = function(offset) {
      var result;
      result = Amoeba.twoText.val();
      result = normalizePath(result);
      result = translatePath(result, offset, 0);
      return result;
    };

    return PathAnimation;

  })();

}).call(this);
