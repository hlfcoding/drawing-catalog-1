sketch = null

# Initializers
# ------------

setup: ->   
  # Required for CS-P5-mode parser.
  # size(720, 480);

  @_setupConstants()

  sketch = @
  @state =
    frozen: no
    frameRate: frameRate.FILM
    speedFactor: 0

  colorMode(RGB, 255)
  noStroke()

  [w, h] = size.MEDIUM
  size w, h

  @_updateSpeedFactor()

  background color.WHITE
  
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

_setupGUI: ->

  ###
  The sketch has state and the datGUI library builds an to manipulate and tune
  that state for various results.
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

  dat.GUI.shared = gui

  gui.open()

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


