class Wrap extends Node

  ###
  Container for nodes. A more flexible version of stage.
  @nodes - (Array)
  @frictionMag - (Number)
  @_isReady - (Bool)
  @hasGravity - (Bool)
  ###

  ###
  Constants
  - containment
  ###

  @NONE: 0
  @REFLECTIVE: 1
  @TOROIDAL: 2

  @defaults: null
  @setup: ->
    # Don't extend Node.defaults.
    Wrap.defaults =
      p: [0, 0, 0]
      v: [0, 0, 0]
      a: [0, 0, 0]
      s:
        width: width
        height: height
      c:
        fill: color 255
      should:
        move: no
        autoMass: no
        contain: yes
      num:
        entropy: 1
      containment: Wrap.REFLECTIVE
      frictionMag: 0.01 * SPEED_FACTOR # constant * normal
      _isReady: no
        
  constructor: (params = Wrap.defaults) ->
  
    super params
  
  ###
  Accessors
  Sugar you should use.
  ###
  
  left: -> @x()
  top: -> @y()
  right: -> @width() + @left()
  bottom: -> @height() + @top()
  ready: (isReady) ->
    if isReady?
      @_isReady = isReady
      if isReady is yes then @trigger 'ready'
    @_isReady

  ###
  Inherited
  ###
  
  draw: () ->
    
    @should.trace ?= @nodes[0].viewMode is Node.LINE
    
    if @should.trace is yes and millis() % (FRAME_RATE * 10) is 0
      c = @fill()
      fill red(c), green(c), blue(c), alpha(c) / 100
      rect @top(), @left(), @width(), @height()
      noFill()
    else if @should.trace is no
      fill @fill()
      rect @top(), @left(), @width(), @height()
  
    n.draw() for n in @nodes
  
  ###
  Public
  ###

  nodeMoved: (n) ->

    @applyFrictionForNode n
    if @should.contain is yes then @checkEdgesForNode n
  
  applyFrictionForNode: (n) ->
  
    f = n.v.get()
    f.normalize()
    f.mult -1
    f.mult @frictionMag
    n.applyForce f
  
  checkEdgesForNode: (n) ->
    
    shift = if @hasGravity then 1 else (1 - @num.entropy)
    
    if @containment is Wrap.REFLECTIVE
      # X
      if n.right() > @right()
        n.right @right()
        if n.v.x > 0 then n.v.x *= -shift
      else if n.x() < @left()
        n.left @left()
        if n.v.x < 0 then n.v.x *= -shift
      # Y
      if n.y() > @bottom()
        n.bottom @bottom()
        if n.v.y > 0 then n.v.y *= -shift
      else if n.y() < @top()
        n.top @top()
        if n.v.y < 0 then n.v.y *= -shift
        
    else if @containment is Wrap.TOROIDAL
      # X
      if n.left() > @right()
        n.right @left()
        n.v.normalize()
      else if n.right() < @left()
        n.left @right()
        n.v.normalize()
      # Y
      if n.top() > @bottom()
        n.bottom @top()
        n.v.normalize()
      else if n.bottom() < @top()
        n.top @bottom()
        n.v.normalize()
  

