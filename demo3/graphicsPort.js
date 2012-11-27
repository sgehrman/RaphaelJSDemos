// Generated by CoffeeScript 1.4.0
(function() {
  var _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  if ((_ref = window.Amoeba) == null) {
    window.Amoeba = {};
  }

  Amoeba.GraphicsPort = (function() {

    function GraphicsPort(rect) {
      this.rect = rect;
      this.clearAll = __bind(this.clearAll, this);

      this.paper = Raphael(this.rect.x, this.rect.y, this.rect.w, this.rect.h);
      this.paper.rect(0, 0, this.rect.w, this.rect.h).attr({
        fill: "90-#aaf-#004",
        stroke: "#f99",
        title: "background"
      });
      this.elements = [];
    }

    GraphicsPort.prototype.addPoints = function(points, radius, color) {
      var circle, point, _i, _len, _results,
        _this = this;
      if (color == null) {
        color = "#f00";
      }
      _results = [];
      for (_i = 0, _len = points.length; _i < _len; _i++) {
        point = points[_i];
        circle = this.paper.circle(point.x, point.y, radius).attr({
          fill: color,
          stroke: "#0e0"
        }).click(function() {
          return alert(_this.data("i"));
        });
        _results.push(this.elements.push(circle));
      }
      return _results;
    };

    GraphicsPort.prototype.clearAll = function() {
      var element, _i, _len, _ref1, _results;
      _ref1 = this.elements;
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        element = _ref1[_i];
        _results.push(element.remove);
      }
      return _results;
    };

    return GraphicsPort;

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

}).call(this);
