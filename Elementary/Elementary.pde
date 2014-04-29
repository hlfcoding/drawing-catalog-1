###
Constants.
###
BLACK = WHITE = RED = null

###
Globals.
###
G =
  stage: null
  fps: 0
  frozen: no
  # UI responder flag for allowing optional global handling. Any individual
  # responders should register the global flag accordingly.
  responded:
    mousePressed: no
    keyPressed: no
  speedFactor: 0
  gui: null

###
System functions.
###

setup: ->

  # Setup base environment.
  colorMode RGB, 255
  noStroke()

  # Setup constants.
  BLACK = color 0
  WHITE = color 255
  RED = color 255, 0, 0

  # Setup globals and environment.
  G.fps = System.FILM_FPS
  updateSpeedFactor = -> G.speedFactor = System.REAL_FPS / G.fps
  updateSpeedFactor()
  frameRate G.fps
  background WHITE
  #[w, h] = System.SMALL_SIZE
  [w, h] = System.MEDIUM_SIZE
  #[w, h] = System.TWITTER_SIZE
  # size(720, 480); -- Required for CS-P5-mode parser.
  size w, h

  ###
  We need to do additional setup calls since constants and statics reference things
  that aren't loaded by the time of the initial closure invocation.
  ###

  # Setup Processing patches.
  System.setup()
  Vector.setup()

  # Setup parts of classes that rely on Processing patches.
  Node.setup()
  Wrap.setup()

  # Setup sketch(es) _last_.
  wind = new PVector 0.001, 0

  G.stage = new Wrap _.extend true, {}, Wrap.defaults,
    id: 1
    containment: Wrap.TOROIDAL
    f:
      custom: { wind: wind }

  G.stage.updateNodeCount()

  G.stage.ready yes

  # Setup GUI

  G.gui = new dat.GUI()
  G.gui.add(G, 'frozen').onFinishChange (should) => @freeze should
  G.gui.add(G, 'fps',
    'Debug': System.DEBUG_FPS
    'Animation': System.ANIM_FPS
    'Film': System.FILM_FPS
    'Video': System.VIDEO_FPS
    'Real': System.REAL_FPS
  ).onFinishChange (fps) ->
   updateSpeedFactor()
   frameRate parseInt fps, 10
  G.stage.setupGUI()

draw: ->

  G.stage.draw()

mousePressed: ->

  G.responded.mousePressed = no

  G.stage.mousePressed()

keyPressed: ->

  G.responded.keyPressed = no

  #console.log key

  G.stage.keyPressed()

###
Global helpers.
###

###
One of the first things we need to do is to be able to control the cycle-expensive run state
without stopping the server. This is especially handy when LiveReload is used.
###
freeze: (should) ->

  # Default.
  should ?= !G.frozen

  n.should.move = !should for n in G.stage.nodes

  # Note: noLoop() and loop() are somehow global in PJS.
  if should then window.noLoop() else window.loop()

  # Save.
  G.frozen = should
  #console.log "is frozen: #{G.frozen}"

