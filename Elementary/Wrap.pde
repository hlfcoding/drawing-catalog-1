class Wrap extends Node

  constructor: (params = Wrap.defaults) ->

    _.defaults params, Wrap.defaults unless params is Wrap.defaults
    super params

    @_allForces = null
    @_isReady = no
    @_needsClear = no

    @nodes = []

  # Static
  # ======

  ###
  Wrap can contain its nodes using distinct modes.
  ###

  @UNCONTAINED: 0
  @REFLECTIVE: 1
  @TOROIDAL: 2

  ###
  Wrap can render its nodes to screen in distinct states.
  ###

  @DEFAULT: 0
  @TRACE: 1

  ###
  Wrap can layout its nodes in distinct patterns.
  ###

  @UNIFORM: 0
  @RANDOM: 1

  @defaults:

    entropy: 1

    contain: on # Contain nodes.
    drainAtEdge: on # Drain node inertia at edges.
    forceOptions: 0
    customForces: []

    autoMass: off
    gravity: off
    move: off
    trace: off
    varyMass: off

    nodeDensity: 1 / 6
    nodeParams:
      varyMass: on

  @setup: ->

    ###
    This needs to be called for the class to be ready for use. Some default
    attributes reference other values not ready on initial declaration.
    ###

    _.defaults @defaults, Node.defaults

    @defaults.fill = color.WHITE
    @defaults.traceFill = @traceFillColor @defaults.fill

    @defaults.containment = Wrap.REFLECTIVE
    @defaults.layoutPattern = Wrap.RANDOM
    @defaults.viewMode = Node.FORMLESS

    @defaults.nodeParams.viewMode = Node.BALL
    @defaults.nodeParams.vMax = Node.defaults.vMax

    @defaults.frictionMag = 0.01 * sketch.state.speedFactor # constant * normal

  @traceFillColor: (fc) -> color.transparentize fc, 0.01

  # Inherited
  # =========

  draw: () ->
    tracePrev = @trace
    @trace = @nodeParams.viewMode is Node.LINE

    if tracePrev is on and @trace isnt tracePrev
      sketch.pushScreen Wrap.TRACE

    # 'Layer' the canvas if needed.
    isTraceFrame = millis() % (sketch.state.frameRate * 10) is 0
    if @trace is on and isTraceFrame
      fill @getTraceFillColor()
      @drawBoundsRect()
      noFill()

    # Clear the canvas if needed.
    if @trace is off or @_needsClear
      fill @fillColor()
      @drawBoundsRect()
      # Sometimes when switching view modes, the canvas needs to be cleared and restored.
      if @_needsClear
        @_needsClear = no
        sketch.popScreen()

    n.draw() for n in @nodes

  # Accessors
  # ---------

  left: -> @x()
  top: -> @y()
  right: -> @w + @left()
  bottom: -> @h + @top()

  fillColor: (fc) ->
    @traceFill = Wrap.traceFillColor fc if fc?
    super fc

  # Public
  # ======

  clear: ->
    fill @fillColor()
    @drawBoundsRect()

  updateNodeCount: (count, customNodeParams) ->
    count ?= parseInt @width() * @nodeDensity # Infer if needed.
    currentCount = @nodes.length
    # Contract if needed.
    if count < currentCount
      # Return nodes removed.
      return (@nodes.pop() for i in [(currentCount - 1)...count])
    # Or expand.
    hasGravity = !!(@forceOptions & PVector.GRAVITY)
    gravity = PVector.createGravity() if hasGravity
    for i in [0..(count - currentCount)]
      do (ordinal = i + 1) =>
        nodeParams = _.extend {}, @nodeParams, customNodeParams,
          id: currentCount + ordinal
          wrap: @
        n = new Node nodeParams
        n.p.randomize() if @layoutPattern is Wrap.RANDOM and not customNodeParams?.p?
        n.applyForce gravity if hasGravity
        n.applyForce f for f in @customForces
        n.cacheAcceleration()
        @nodes.push n
    # Observable value for datGUI
    @nodeCount ?= @nodes.length

  updateNodeContainment: (n) ->
    shift = if @gravity is on then 1 else (1 - @entropy)

    if @containment is Wrap.REFLECTIVE
      do (v = n.v) =>
        if n.right() > @right()
          n.right @right()
          v.x *= -shift if v.x > 0
        else if n.left() < @left()
          n.left @left()
          v.x *= -shift if v.x < 0
        if n.bottom() > @bottom()
          n.bottom @bottom()
          v.y *= -shift if v.y > 0
        else if n.y() < @top()
          n.top @top()
          v.y *= -shift if v.y < 0

    else if @containment is Wrap.TOROIDAL
      contained = { x: yes, y: yes }

      if n.left() > @right() then n.right @left()
      else if n.right() < @left() then n.left @right()
      else contained.x = no
      if n.top() > @bottom() then n.bottom @top()
      else if n.bottom() < @top() then n.top @bottom()
      else contained.y = no

      if @drainAtEdge is on and (contained.x or contained.y)
        n.v.normalize()
        n.a.normalize()

  # Physics
  # -------

  applyNodeFriction: (n) ->
    friction = n.v.get()
    friction.normalize()
    friction.mult -1
    friction.mult @frictionMag
    n.applyForce friction

  toggleForce: (f, toggled) ->
    return no unless toggled?
    @_allForces ?= @customForces
    isForceOption = typeof f is 'number'
    isForceName = f in @_allForces

    if isForceOption
      vec = PVector.createGravity() if f is PVector.GRAVITY
      if toggled is on then @forceOptions |= f else @forceOptions ^= f

    else if isForceName
      vec = @_allForces[f]
      if toggled is on then @customForces.push vec
      else @customForces.splice @customForces.indexOf(vec), 1

    if vec? then for n in @nodes
      n.applyForce vec, toggled
      n.cacheAcceleration()

  # Accessors
  # ---------

  getTraceFillColor: -> @traceFill

  ready: (r) -> @_ready = r if r?; @onReady() if r; @_ready

  # Callbacks
  # ---------

  mouseClicked: ->
    handled = _.any @nodes, (n) ->
      n.handleClick { mouseX, mouseY }
    , @
    return if handled
    # Add attractor node in empty space.
    @updateNodeCount @nodes.length,
      attract: on
      p: [ mouseX, mouseY, 0 ]

  nodeMoved: (n) ->
    @applyNodeFriction n
    @updateNodeContainment n if @contain is on

  onNodeViewModeChange: (vm) ->
    if vm?
      @nodeParams.viewMode = vm
      n.viewMode = vm for n in @nodes
    @_needsClear = @nodeParams.viewMode is Node.LINE
    @draw()

  onReady: ->
    @onNodeViewModeChange()
    @log()
