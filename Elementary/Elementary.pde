sketch = null

# Initializers
# ------------

setup: ->   
  # Required for CS-P5-mode parser.
  # size(720, 480);

  sketch = @
  @state =
    frozen: no
    speedFactor: 0

  @_setupConstants()
  @_setupExtensions()

  @state.frameRate = frameRate.FILM
  @_updateSpeedFactor()
  # Class defaults may require additional globals.
  @_setupClasses()

  colorMode RGB, 255
  noStroke()

  [w, h] = size.MEDIUM
  size w, h

  background color.WHITE
  
  @_setupStage()

  @_setupScreens()

  @_setupGUI()

_setupConstants: ->

  ###
  Constants, when possible, are attached to the Processing (sketch) API methods.
  This is because scope globals are of limited use in CS mode, and globalized
  methods are conveniently fitting as namespaces, despite being a little risky
  to modify.
  ###

  color.BLACK = color 0
  color.WHITE = color 255
  color.RED = color 255, 0, 0

  frameRate.DEBUG = 1
  frameRate.ANIMATION = 12
  frameRate.FILM = 24
  frameRate.VIDEO = 30
  frameRate.REAL = 60

  size.SMALL = [300, 300]
  size.MEDIUM = [720, 480]
  size.TWITTER = [1252, 626]

_setupExtensions: ->

  ###
  PVector extension to add helper constants and methods for the sketch. The main
  addition is the concept of a vector type.
  ###

  PVector.G = 0.01

  PVector.GENERIC = 0
  PVector.POSITION = 1
  PVector.VELOCITY = 2
  PVector.ACCELERATION = 3

  PVector.GRAVITY = 1 << 0
  PVector.ATTRACTION = 1 << 1

  PVector.createGravity = =>
    vec = new PVector 0, @state.speedFactor / 2
    vec.type = PVector.GRAVITY
    vec

  PVector::randomize = ->
    return unless @type is PVector.POSITION
    @x = random width
    @y = random height

  ###
  Add helpers to the color API methods, mainly for conversion.
  ###

  # This should be less magical.
  color.ensure = (c) -> if c > 0 then c - 16777216 else c

  color.transparentize = (c, ratio) -> color red(c), green(c), blue(c), alpha(c) * ratio

  ###
  Add helpers to number methods, mainly for macro-calculations.
  ###

  random.dualScale = (n) -> random(1, n) / random(1, n)

  ###
  Add core helpers.
  ###

  # Currently unused.
  Processing.isKindOfClass = (obj, aClass) ->
    test = obj.constructor is aClass
    if not bool and obj.constructor.__super__?
      test = isKindOfClass obj.constructor.__super__, aClass
    test

_setupClasses: ->

  Node.setup()
  Wrap.setup()

_setupGUI: ->

  ###
  The sketch has state and the datGUI library builds an interface to manipulate
  and tune that state for various results.
  ###

  gui = new dat.GUI()

  folder = gui.addFolder 'sketch'

  toggle = folder.add @state, 'frozen'
  toggle.onFinishChange (toggled) => @freeze toggled

  select = folder.add @state, 'frameRate',
    'Debug': frameRate.DEBUG
    'Animation': frameRate.ANIMATION
    'Film': frameRate.FILM
    'Video': frameRate.VIDEO
    'Real': frameRate.REAL
  select.onFinishChange (option) => @state.frameRate = parseInt option, 10

  button = folder.add @, 'exportScreen'

  folder = gui.addFolder 'colors'

  # TODO: Still has issues.
  colorPicker = folder.addColor @stage, 'fill'
  colorPicker.onChange (color) => @stage.fillColor color
  colorPicker.onFinishChange (color) => @stage.fillColor color

  folder = gui.addFolder 'stage'

  range = folder.add @stage, 'frictionMag', 0.001, 0.1

  range = folder.add @stage, 'entropy', 0, 2

  range = folder.add @stage, 'nodeCount', 0, 500
  range.onFinishChange (count) => @stage.updateNodeCount count

  range = folder.add @stage.nodeParams, 'vMax', 0, @stage.nodeParams.vMax * 2
  range.onFinishChange (magnitude) => n.vMax = magnitude for n in @stage.nodes

  toggle = folder.add @stage, 'gravity'
  toggle.onFinishChange (toggled) =>
    @stage.containment = if toggled then Wrap.REFLECTIVE else Wrap.TOROIDAL
    @stage.toggleForce PVector.GRAVITY, toggled

  toggle = folder.add @stage.nodeParams, 'collide'
  toggle = folder.add @stage.nodeParams, 'varyMass'

  select = folder.add @stage, 'containment',
    'Reflective': Wrap.REFLECTIVE
    'Toroidal': Wrap.TOROIDAL
  select.onFinishChange (option) => @stage.containment = parseInt option, 10

  select = folder.add @stage.nodeParams, 'viewMode',
    'Ball': Node.BALL
    'Line': Node.LINE
  select.onFinishChange (option) => @stage.onNodeViewModeChange parseInt option, 10

  button = folder.add @stage, 'clear'

  dat.GUI.shared = gui

  gui.open()

_setupScreens: ->

  ###
  Screens can store and restore canvas state when switching between different
  draw modes.
  ###

  @_screenStacks = {}
  @_screenStacks[Wrap.TRACE] = []
  @_screenStacks[Wrap.DEFAULT] = []

_setupStage: ->

  ###
  The sketch only has one Wrap, and filling the sketch, it acts like a 'stage'.
  ###

  wind = new PVector 0.001, 0
  @stage = new Wrap
    id: 1
    containment: Wrap.TOROIDAL
    customForces: [ wind ]
    h: height
    w: width

  @stage.updateNodeCount()

  @stage.ready yes
  @canvasElement().focus()

# Updaters
# --------

draw: -> @stage.draw()

freeze: (frozen) ->

  ###
  One of the first things we need to do is to be able to control the cycle-
  expensive run state without stopping the server. This is especially handy when
  LiveReload is used.
  ###

  frozen ?= @state.frozen

  n.move = !frozen for n in @stage.nodes
  if frozen then noLoop()
  else @loop()

  @state.frozen = frozen

_updateSpeedFactor: ->
  @state.speedFactor = frameRate.REAL / @state.frameRate
  frameRate @state.frameRate

# Canvas State
# ------------

canvasElement: -> @contentElement().querySelector 'canvas'
contentElement: -> document.getElementById 'content'

exportScreen: ->
  img = document.createElement 'img'
  img.src = @canvasElement().toDataURL()
  if @_imgPrev? then @contentElement().insertBefore img, @_imgPrev
  else @contentElement().appendChild img
  @_imgPrev = img

pushScreen: (customStack) ->
  [context, stack] = @_screenUpdateVars()
  stack = customStack if customStack?
  screen = context.getImageData 0, 0, width, height
  @_screenStacks[stack].push screen

popScreen: ->
  [context, stack] = @_screenUpdateVars()
  return unless @_screenStacks[stack].length
  context.putImageData @_screenStacks[stack].pop(), 0, 0

_screenUpdateVars: ->
  context = @canvasElement().getContext '2d'
  stack = if @stage.trace is on then Wrap.TRACE else Wrap.DEFAULT
  [context, stack]

# Responders
# ----------

mouseClicked: -> @stage.mouseClicked()
