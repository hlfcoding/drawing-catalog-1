###
Constants.
###
BLACK = WHITE = null
FRAME_RATE = 24 # Processing bug.
SPEED_FACTOR = 60 / FRAME_RATE

###
Globals.
###
wrap = null
frozen = no

###
System functions.
###

setup: ->
  
  # Stage.
  size 300, 300
  frameRate FRAME_RATE
  
  ###
  We need to do additional setup calls since constants and statics reference things 
  that aren't loaded by the time of the initial closure invocation. 
  #####
  
  # Setup constants.
  colorMode RGB, 255
  BLACK = color 0
  WHITE = color 255

  # Setup patches.
  Vector.setup()
  
  # Setup classes.
  Node.setup()
  Wrap.setup()
  
  # Setup sketch(es)
  wind =     new PVector 0.01, 0
  gravity =  Vector.gravity()
  
  wrap = new Wrap()
  wrap.nodes = []
  
  for i in [1...50]
    do (i) ->
      n = new Node _.extend true, {}, Node.defaults, 
        should:
          varyMass: yes
        wrap: wrap
      n.p.randomize()
      if i is 1 then n.log()
      
      n.applyForce(wind)
       .applyForce(gravity, yes)
      
      wrap.nodes.push n

draw: ->

  background 255
  
  n.draw() for n in wrap.nodes

mousePressed: ->
  
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

  n.should.move = !should for n in wrap.nodes
  
  # Note: noLoop() and loop() are somehow global in PJS.
  if should then window.noLoop() else window.loop()
  
  # Save.
  frozen = should
  
