class Wrap extends Node

  ###
  Container for nodes. A more flexible version of stage.
  @nodes - (Array)
  #####

  ###
  Constants
  #####

  @defaults: null
  @setup: ->
    Wrap.defaults = 
      p: [0, 0, 0]
      v: [0, 0, 0]
      a: [0, 0, 0]
      s:
        width: width
        height: height
      c:
        fill: no
      should:
        move: no
        autoMass: no
      frictionMag: 0.01 * SPEED_FACTOR # constant * normal
        
  constructor: (params = Wrap.defaults) ->
  
    super params
  
  ###
  Sugar you should use.
  #####
  
  left: -> @x()
  top: -> @y()
  right: -> @width() + @left()
  bottom: -> @height() + @top()

  ###
  Public
  #####

  nodeMoved: (n) ->

    @applyFrictionForNode n
    @checkEdgesForNode n
  
  applyFrictionForNode: (n) ->
  
    f = n.v.get()
    f.normalize()
    f.mult -1
    f.mult @frictionMag
    n.applyForce f
  
  checkEdgesForNode: (n) ->
    
    # X
    if n.x() > @right()
      n.x @right()
      n.v.x *= -1
    else if n.x() < @left()
      n.x @left()
      n.v.x *= -1
    
    # Y
    if n.y() > @bottom()
      n.v.y *= -1
      n.y @bottom()
  
