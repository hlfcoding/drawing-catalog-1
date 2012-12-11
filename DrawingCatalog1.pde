###
Constants.
###
BLACK = WHITE = RED = null
FRAME_RATE = 24 # Processing bug.
SPEED_FACTOR = 60 / FRAME_RATE

###
Globals.
###
G =
  stage: null
  frozen: no
  # UI responder flag for allowing optional global handling. Any individual
  # responders should register the global flag accordingly.
  responded:
    mousePressed: no
    keyPressed: no
  gui: null

###
System functions.
###

setup: ->

  # Setup environment.
  colorMode RGB, 255
  frameRate FRAME_RATE
  noStroke()

  # Setup viewport.
  background 255
  #size 300, 300
  size 720, 480
  #size 1252, 626

  ###
  We need to do additional setup calls since constants and statics reference things
  that aren't loaded by the time of the initial closure invocation.
  ###

  # Setup constants.
  BLACK = color 0
  WHITE = color 255
  RED = color 255, 0, 0

  # Setup Processing patches.
  Vector.setup()

  # Setup parts of classes that rely on Processing patches.
  Node.setup()
  Wrap.setup()

  # Setup sketch(es).
  wind =     new PVector 0.001, 0
  #gravity =  Vector.gravity()
  gravity =  new PVector 0, 0

  G.stage = new Wrap _.extend true, {}, Wrap.defaults,
    id: 1
    containment: Wrap.TOROIDAL
  G.stage.nodes = []

  scale = (width / 300)

  for i in [1...( parseInt 50 * scale )]
    do (i, defaults = Node.defaults) ->
      n = new Node _.extend true, {}, defaults,
        id: i
        should:
          varyMass: yes
        num:
          attrtConst: 0.001
        wrap: G.stage
      n.p.randomize()
      if i is 1 then n.log()

      n.applyForce(wind)
       .applyForce(gravity, yes)

      G.stage.nodes.push n

  G.stage.ready yes

  # Setup GUI

  G.gui = new dat.GUI()
  G.stage.setupGUI()

  G.gui.add(G, 'frozen').onFinishChange (should) => @freeze should

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

