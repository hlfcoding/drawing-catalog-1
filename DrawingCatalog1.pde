###
Constants.
###
BLACK = WHITE = RED = null
FRAME_RATE = 24 # Processing bug.
SPEED_FACTOR = 60 / FRAME_RATE

###
Globals.
###
stage = null
frozen = no
responded =
  mousePressed: no

###
System functions.
###

setup: ->
  
  # Setup context.
  size 300, 300
  frameRate FRAME_RATE
  noStroke()
  
  ###
  We need to do additional setup calls since constants and statics reference things 
  that aren't loaded by the time of the initial closure invocation. 
  ###
  
  # Setup constants.
  colorMode RGB, 255
  BLACK = color 0
  WHITE = color 255
  RED = color 255, 0, 0
  
  # Setup patches.
  Vector.setup()
  
  # Setup classes.
  Node.setup()
  Wrap.setup()
  
  # Setup sketch(es).
  wind =     new PVector 0.001, 0
  gravity =  Vector.gravity()
  
  stage = new Wrap _.extend true, {}, Wrap.defaults,
    containment: Wrap.REFLECTIVE
    hasGravity: yes # TODO: Patched.
  stage.nodes = []
  
  scale = (width / 300)
  
  for i in [1...( parseInt 50 * scale )]
    do (i, defaults = Node.defaults) ->
      n = new Node _.extend true, {}, defaults,
        id: i
        viewMode: Node.BALL
        should:
          varyMass: yes
        num:
          attrtConst: 0.001
        wrap: stage
      n.p.randomize()
      if i is 1 then n.log()
      
      n.applyForce(wind)
       .applyForce(gravity, yes)
      
      stage.nodes.push n

  stage.ready yes

draw: ->
  
  stage.draw()

mousePressed: ->
  
  responded.mousePressed = no
  
  n.mousePressed() for n in stage.nodes

  if responded.mousePressed is no
    @freeze()

###
Global helpers.
###

###
One of the first things we need to do is to be able to control the cycle-expensive run state
without stopping the server. This is especially handy when LiveReload is used.
###
freeze: (should) ->
  
  # Default.
  should ?= !frozen

  n.should.move = !should for n in stage.nodes
  
  # Note: noLoop() and loop() are somehow global in PJS.
  if should then window.noLoop() else window.loop()
  
  # Save.
  frozen = should
  
