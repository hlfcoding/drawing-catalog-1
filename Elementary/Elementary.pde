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
  @_setupClasses()

  @state.frameRate = frameRate.FILM

  colorMode RGB, 255
  noStroke()

  [w, h] = size.MEDIUM
  size w, h

  @_updateSpeedFactor()

  background color.WHITE
  
  @_setupStage()

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

_setupClasses: ->

  Node.setup()
  Wrap.setup()

_setupGUI: ->

  ###
  The sketch has state and the datGUI library builds an interface to manipulate
  and tune that state for various results.
  ###

  gui = new dat.GUI()

  toggle = gui.add @state, 'frozen'
  toggle.onFinishChange (frozen) => @freeze frozen

  select = gui.add @state, 'frameRate',
    "Debug": frameRate.DEBUG
    "Animation": frameRate.ANIMATION
    "Film": frameRate.FILM
    "Video": frameRate.VIDEO
    "Real": frameRate.REAL
  select.onFinishChange (frameRate) => @state.frameRate = parseInt frameRate, 10

  range = gui.add @stage, 'frictionMag', 0.001, 0.1
  range = gui.add @stage, 'entropy', 0, 2

  dat.GUI.shared = gui

  gui.open()

_setupStage: ->

  ###
  The sketch only has one Wrap, and filling the sketch, it acts like a 'stage'.
  ###

  @stage = new Wrap
    id: 1
    containment: Wrap.TOROIDAL
    customForces:
      wind: new PVector 0.001, 0

  @stage.updateNodeCount()

  @stage.ready yes

# Updaters
# --------

draw: ->

freeze: (frozen) ->

  ###
  One of the first things we need to do is to be able to control the cycle-
  expensive run state without stopping the server. This is especially handy when
  LiveReload is used.
  ###

_updateSpeedFactor: ->
  @state.speedFactor = frameRate.REAL / @state.frameRate
  frameRate @state.frameRate

