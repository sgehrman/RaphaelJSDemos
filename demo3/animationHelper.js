// Generated by CoffeeScript 1.4.0
(function() {
  var PathAnimation, _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  if ((_ref = window.Amoeba) == null) {
    window.Amoeba = {};
  }

  Amoeba.Animations = (function() {

    function Animations() {
      this._shieldPath = __bind(this._shieldPath, this);

      this._updateStatus = __bind(this._updateStatus, this);

      this._createAnimations = __bind(this._createAnimations, this);

      this._diamondPath = __bind(this._diamondPath, this);

    }

    Animations.prototype.setupAnimations = function() {
      this.graphicsPort = new Amoeba.GraphicsPort(new Amoeba.Rect(0, 380, 850, 650));
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
        var result, theCog;
        theCog = new Amoeba.Cog(400, 34, _this.graphicsPort);
        result = theCog.path(true);
        Amoeba.oneText.val(result);
        result = theCog.path(false);
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
      return this.animations = [new PathAnimation("#44f", 0, this.graphicsPort)];
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
        x1 = centerX + (Math.cos(Amoeba.Graphics.toRadians(angle)) * radius);
        y1 = centerY + (Math.sin(Amoeba.Graphics.toRadians(angle)) * radius);
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

    return Animations;

  })();

  PathAnimation = (function() {

    function PathAnimation(fillColor, offset, graphicsPort) {
      var _this = this;
      this.fillColor = fillColor;
      this.offset = offset;
      this.pathSwitch = true;
      this.stopped = false;
      this.mainPath = graphicsPort.paper.path(this.pathOne(this.offset)).attr({
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
        fill: this.fillColor,
        'fill-opacity': 0.4
      }, 800, "<>", function() {
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
      result = Amoeba.Graphics.normalizePath(result);
      return result;
    };

    PathAnimation.prototype.pathTwo = function(offset) {
      var result;
      result = Amoeba.twoText.val();
      result = Amoeba.Graphics.normalizePath(result);
      return result;
    };

    return PathAnimation;

  })();

}).call(this);
