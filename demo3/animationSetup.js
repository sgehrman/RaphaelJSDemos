  function setupAnimations() {
    var theGradient = "90-#aaf-#004";
    var paper = Raphael(0, 280, 650, 650);

    paper.rect(0, 0, 850, 650).attr({
      fill: theGradient,
      stroke: '#f99',
      title: 'background'
    });

    var animations = [
      new PathAnimation('#44f', 0), new PathAnimation('#f33', 100), 
      new PathAnimation('#2f2', 200), 
      new PathAnimation('#232', 300), 
      new PathAnimation('#f1f', 400)
    ];

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