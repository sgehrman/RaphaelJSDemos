// Generated by CoffeeScript 1.4.0
(function() {
  var _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  if ((_ref = window.Amoeba) == null) {
    window.Amoeba = {};
  }

  Amoeba.GraphicsPaper = (function() {

    function GraphicsPaper(divHolder, attr) {
      var height, width;
      this.divHolder = divHolder;
      if (attr == null) {
        attr = null;
      }
      this._fadePoint = __bind(this._fadePoint, this);

      this.clearPoints = __bind(this.clearPoints, this);

      this.clearAll = __bind(this.clearAll, this);

      this.pulsatePoints = __bind(this.pulsatePoints, this);

      if (attr == null) {
        attr = {
          fill: "90-#aaf-#004",
          stroke: "#f99"
        };
      }
      this.paper = Raphael(this.divHolder);
      width = this.paper.canvas.clientWidth ? this.paper.canvas.clientWidth : this.paper.width;
      height = this.paper.canvas.clientHeight ? this.paper.canvas.clientHeight : this.paper.height;
      this.paper.rect(0, 0, width, height).attr(attr);
      this.points = [];
    }

    GraphicsPaper.prototype.addPoints = function(points, radius, color) {
      var circle, point, _i, _len, _results;
      if (color == null) {
        color = "#f00";
      }
      _results = [];
      for (_i = 0, _len = points.length; _i < _len; _i++) {
        point = points[_i];
        circle = this.paper.circle(point.x, point.y, radius);
        circle.attr({
          fill: color,
          stroke: "none"
        });
        _results.push(this.points.push(circle));
      }
      return _results;
    };

    GraphicsPaper.prototype.pulsatePoints = function() {
      var point, _i, _len, _ref1, _results;
      _ref1 = this.points;
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        point = _ref1[_i];
        _results.push(this._fadePoint(true, point));
      }
      return _results;
    };

    GraphicsPaper.prototype.clearAll = function() {
      return this.paper.clear();
    };

    GraphicsPaper.prototype.clearPoints = function() {
      var point, _i, _len, _ref1, _results;
      _ref1 = this.points;
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        point = _ref1[_i];
        _results.push(point.remove());
      }
      return _results;
    };

    GraphicsPaper.prototype._fadePoint = function(out, point) {
      var fadeIn, fadeOut,
        _this = this;
      fadeOut = Raphael.animation({
        transform: "s2",
        "fill-opacity": 1
      }, 600, "<", function() {
        return _this._fadePoint(!out, point);
      });
      fadeIn = Raphael.animation({
        transform: "s1",
        "fill-opacity": 0.1
      }, 600, ">", function() {
        return _this._fadePoint(!out, point);
      });
      point.stop();
      if (out) {
        return point.animate(fadeOut);
      } else {
        return point.animate(fadeIn);
      }
    };

    return GraphicsPaper;

  })();

  Amoeba.Point = (function() {

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

  Amoeba.Pair = (function() {

    function Pair(left, right) {
      this.left = left;
      this.right = right;
    }

    Pair.prototype.toString = function() {
      return "(" + this.left + ", " + this.right + ")";
    };

    return Pair;

  })();

  Amoeba.Rect = (function() {

    function Rect(x, y, w, h) {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
    }

    Rect.prototype.toString = function() {
      return "(x:" + this.x + ", y:" + this.y + ", w:" + this.w + ", h:" + this.h + ")";
    };

    return Rect;

  })();

  Amoeba.Graphics = (function() {

    function Graphics() {}

    Graphics.toDegrees = function(angle) {
      return angle * (180 / Math.PI);
    };

    Graphics.toRadians = function(angle) {
      return angle * (Math.PI / 180);
    };

    Graphics.normalizePath = function(path) {
      var bBox, theMatrix, transformString;
      bBox = Raphael.pathBBox(path);
      theMatrix = new Raphael.matrix();
      theMatrix.translate(-bBox.x, -bBox.y);
      transformString = theMatrix.toTransformString();
      path = Raphael.transformPath(path, transformString);
      return path;
    };

    Graphics.scalePath = function(path, amount) {
      var bBox, theMatrix, transformString;
      bBox = Raphael.pathBBox(path);
      theMatrix = new Raphael.matrix();
      theMatrix.scale(amount, amount);
      transformString = theMatrix.toTransformString();
      path = Raphael.transformPath(path, transformString);
      return path;
    };

    Graphics.translatePath = function(path, amountX, amountY) {
      var bBox, theMatrix, transformString;
      bBox = Raphael.pathBBox(path);
      theMatrix = new Raphael.matrix();
      theMatrix.translate(amountX, amountY);
      transformString = theMatrix.toTransformString();
      path = Raphael.transformPath(path, transformString);
      return path;
    };

    Graphics.rotatePath = function(path, degrees) {
      var bBox, theMatrix, transformString;
      bBox = Raphael.pathBBox(path);
      theMatrix = new Raphael.matrix();
      theMatrix.rotate(degrees, bBox.x + (bBox.width / 2), bBox.y + (bBox.height / 2));
      transformString = theMatrix.toTransformString();
      path = Raphael.transformPath(path, transformString);
      return path;
    };

    return Graphics;

  })();

}).call(this);
