// Generated by CoffeeScript 1.4.0
(function() {
  var CogAnimation, _ref,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  if ((_ref = window.Amoeba) == null) {
    window.Amoeba = {};
  }

  Amoeba.CogDemo = (function() {

    function CogDemo() {
      this._createAnimations = __bind(this._createAnimations, this);
      this.graphicsPort = new Amoeba.GraphicsPaper(new Amoeba.Rect(0, 380, 850, 650));
    }

    CogDemo.prototype.setupAnimations = function() {
      return this._createAnimations();
    };

    CogDemo.prototype.doAnimate = function() {
      return this.animations.forEach(function(el) {
        return el.animate();
      });
    };

    CogDemo.prototype.setupPathFields = function() {
      var theCog,
        _this = this;
      Amoeba.oneText = $("#one");
      Amoeba.twoText = $("#two");
      theCog = new Amoeba.Cog(400, 34, this.graphicsPort);
      Amoeba.oneText.val(theCog.path(true));
      Amoeba.twoText.val(theCog.path(false));
      return $("#run").on("click", function(event) {
        return _this.doAnimate();
      });
    };

    CogDemo.prototype._createAnimations = function() {
      var num, _i, _len, _ref1;
      if (this.animations != null) {
        _ref1 = this.animations;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          num = _ref1[_i];
          num.remove();
        }
      }
      return this.animations = [new CogAnimation("#44f", 0, this.graphicsPort)];
    };

    return CogDemo;

  })();

  CogAnimation = (function() {

    function CogAnimation(fillColor, offset, graphicsPort) {
      var _this = this;
      this.fillColor = fillColor;
      this.offset = offset;
      this.pathSwitch = true;
      this.removed = false;
      this.mainPath = graphicsPort.paper.path(this.pathOne(this.offset)).attr({
        fill: this.fillColor
      });
      this.mainPath.node.onclick = function() {
        _this.animate();
        return _this.mainPath.toFront();
      };
    }

    CogAnimation.prototype.remove = function() {
      var _this = this;
      this.removed = true;
      return this.mainPath.animate({
        "fill-opacity": 0
      }, 400, "<>", function() {
        return _this.mainPath.remove();
      });
    };

    CogAnimation.prototype.animate = function() {
      var thePath,
        _this = this;
      if (+(this.pathSwitch = !this.pathSwitch)) {
        thePath = this.pathOne(this.offset);
      } else {
        thePath = this.pathTwo(this.offset);
      }
      this.mainPath.stop();
      return this.mainPath.animate({
        path: thePath,
        fill: this.fillColor,
        'fill-opacity': 0.4
      }, 800, "<>", function() {
        if (jQuery('#repeatCheck').is(':checked')) {
          if (!_this.removed) {
            return _this.animate();
          }
        }
      });
    };

    CogAnimation.prototype.pathOne = function(offset) {
      var result;
      result = Amoeba.oneText.val();
      result = Amoeba.Graphics.normalizePath(result);
      return result;
    };

    CogAnimation.prototype.pathTwo = function(offset) {
      var result;
      result = Amoeba.twoText.val();
      result = Amoeba.Graphics.normalizePath(result);
      return result;
    };

    return CogAnimation;

  })();

}).call(this);
