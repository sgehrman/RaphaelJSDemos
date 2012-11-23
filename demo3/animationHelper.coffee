# coffee -wc ./animationHelper.coffee 

window.Amoeba ?= {}

class Amoeba.Animations
  constructor: ->

  setupAnimations: ->
    @paper = Raphael(0, 380, 850, 650)
    @paper.rect(0, 0, 850, 650).attr
      fill: "90-#aaf-#004"
      stroke: "#f99"
      title: "background"

    this._createAnimations()
    
  doAnimate: ->
    @animations.forEach (el) ->
      el.animate()

  setupPathFields: ->
    Amoeba.oneText = $("#one")
    Amoeba.twoText = $("#two")
    Amoeba.statusText = $("#status")
    Amoeba.oneText.val gearPath
    Amoeba.twoText.val circleGearPath

    $("#gears").on "click", (event) =>
      Amoeba.oneText.val gearPath
      Amoeba.twoText.val circleGearPath
      this.doAnimate()
      this._updateStatus("Showing gears")

    $("#rects").on "click", (event) =>
      Amoeba.oneText.val makeRectanglePath(0, 0, 100, 500)
      Amoeba.twoText.val makeRectanglePath(0, 0, 200, 300)
      this.doAnimate()
      this._updateStatus("Showing rects")

    $("#example1").on "click", (event) =>
      result = "M0,0c11,0 20,9 20,20c0,11 -9,20 -20,20c-11,0 -20-9 -20-20c0-11 9-20 20-20z"
      Amoeba.oneText.val result

      result = this._diamondPath(20)
      Amoeba.twoText.val result

      this._updateStatus("Showing example1")

      this.doAnimate()

    $("#example2").on "click", (event) =>
      result = makeCirclePath(0,0,20)
      Amoeba.oneText.val result

      result = this._diamondPath(20)
      Amoeba.twoText.val result

      this._updateStatus("Showing example2")

      this.doAnimate()

    $("#example3").on "click", (event) =>
      result = "M0,0 h-150 a150,150 0 1,0 150,-150z"
      Amoeba.oneText.val result

      result = this._diamondPath(200)
      Amoeba.twoText.val result

      this._updateStatus("Showing example3")

      this.doAnimate()

    $("#example4").on "click", (event) =>
      result = "M0,0 h-150 a150,150 0 1,0 150,-150z"
      Amoeba.oneText.val result

      # http://vonexplaino.com/code/cog/
      result = "M365.9580263406116,168.70242767711596A165,165,0,0,1,369.8680175990613,198.40175985920536L389.9907500770831,203.15003083317916L404.75005207899324,214.99583385413567A200,200,0,0,1,400.53084627881685,247.04388366325958L383.20853587081535,254.66606228382042L362.5425259154164,254.0443934429854A165,165,0,0,1,351.07901158276434,281.71976521733234L366.1316736153025,295.89325474385674L372.990702580605,313.5316720891866A200,200,0,0,1,353.31273826929555,339.1764944655488L334.50008809344627,337.1163395791363L316.9136328976262,326.2449535925325A165,165,0,0,1,293.1482523817291,344.48077144196975L299.09749533322633,364.2817044484816L296.21837998980664,382.98653643474063A200,200,0,0,1,266.3543518132681,395.35662193255513L251.09219629167904,384.16615037726666L241.29757232288392,365.9580263406116A165,165,0,0,1,211.59824014079464,369.8680175990613L206.84996916682084,389.9907500770831L195.00416614586433,404.75005207899324A200,200,0,0,1,162.95611633674045,400.53084627881685L155.3339377161796,383.20853587081535L155.95560655701462,362.5425259154164A165,165,0,0,1,128.28023478266772,351.0790115827644L114.10674525614324,366.1316736153025L96.46832791081346,372.990702580605A200,200,0,0,1,70.82350553445121,353.31273826929555L72.88366042086372,334.50008809344627L83.75504640746749,316.9136328976262A165,165,0,0,1,65.5192285580303,293.1482523817291L45.718295551518395,299.09749533322633L27.01346356525943,296.21837998980675A200,200,0,0,1,14.643378067444871,266.35435181326807L25.833849622733368,251.0921962916791L44.04197365938842,241.29757232288392A165,165,0,0,1,40.131982400938654,211.59824014079467L20.009249922916922,206.8499691668208L5.249947921006736,195.0041661458644A200,200,0,0,1,9.469153721183176,162.95611633674045L26.791464129184646,155.3339377161797L47.457474084583566,155.95560655701465A165,165,0,0,1,58.920988417235606,128.28023478266772L43.868326384697525,114.10674525614324L37.00929741939501,96.46832791081346A200,200,0,0,1,56.68726173070439,70.8235055344513L75.49991190655365,72.88366042086378L93.08636710237376,83.75504640746755A165,165,0,0,1,116.85174761827089,65.5192285580303L110.90250466677365,45.718295551518395L113.78162001019327,27.01346356525943A200,200,0,0,1,143.64564818673182,14.6433780674449L158.90780370832084,25.833849622733368L168.702427677116,44.04197365938845A165,165,0,0,1,198.40175985920533,40.131982400938654L203.15003083317916,20.009249922916922L214.99583385413558,5.249947921006736A200,200,0,0,1,247.04388366325952,9.469153721183176L254.66606228382028,26.791464129184646L254.04439344298532,47.457474084583566A165,165,0,0,1,281.7197652173322,58.92098841723558L295.8932547438567,43.86832638469747L313.5316720891865,37.009297419394954A200,200,0,0,1,339.1764944655488,56.68726173070445L337.11633957913625,75.49991190655368L326.2449535925325,93.0863671023738A165,165,0,0,1,344.48077144196964,116.85174761827088L364.2817044484816,110.90250466677364L382.9865364347405,113.78162001019325A200,200,0,0,1,395.3566219325551,143.64564818673182L384.1661503772666,158.9078037083208L365.9580263406116,168.70242767711596Z"
      Amoeba.twoText.val result

      this._updateStatus("Showing example3")

      this.doAnimate()

    $("#revDiamond").on "change", (event) =>
      # recreate the diamond
      result = this._diamondPath(200)
      
      Amoeba.twoText.val result
      
      # recreate animations fresh
      this._createAnimations()

      this.doAnimate()

    $("#run").on "click", (event) =>
      this.doAnimate()

  # how make private coffeescript methods?
  _diamondPath: (width=20) =>
    result = "M0,0l#{width},#{width} -#{width},#{width} -#{width}-#{width}z"

    if (jQuery('#revDiamond').is(':checked'))
      result = "M0,0l-#{width},#{width} #{width},#{width} #{width}-#{width}z"
      console.log("reversed")

    return result

  _createAnimations: =>
    if @animations?
      num.remove() for num in @animations

    @animations = [new PathAnimation("#44f", 0, @paper), new PathAnimation("#f31", 420, @paper)]
  
  _updateStatus: (inStatus) =>
    Amoeba.statusText.text inStatus

class PathAnimation
  constructor: (@fillColor, @offset, paper) ->
    @pathSwitch = true
    @mainPath = paper.path(this.pathOne(@offset)).attr(fill:@fillColor)
    
    @mainPath.node.onclick = =>
      this.animate()
      this.mainPath.toFront()

  remove: ->
    # animate it out so it looks cool
    @mainPath.animate "fill-opacity":0, 400, "<>", =>
      @mainPath.remove()

  animate: ->
    if (+(@pathSwitch = not @pathSwitch)) 
      thePath = this.pathOne(@offset)
    else
      thePath = this.pathTwo(@offset)

    @mainPath.animate path:thePath, fill:@fillColor, 400, "<>"

  pathOne: (offset) ->
    result = Amoeba.oneText.val()
    
    result = normalizePath(result)
    # result = scalePath(result, 0.5);
    result = translatePath(result, offset, 0)
    # result = rotatePath(result, 180);

    result
    
  pathTwo: (offset) ->
    result = Amoeba.twoText.val()

    result = normalizePath(result)
    # result = scalePath(result, 0.5);
    result = translatePath(result, offset, 0)
    #  result = rotatePath(result, 180);

    result
