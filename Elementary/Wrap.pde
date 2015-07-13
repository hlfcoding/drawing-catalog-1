class Wrap extends Node

  constructor: (params = Wrap.defaults) ->

    _.defaults params, Wrap.defaults unless params is Wrap.defaults
    super params

    @_allForces = null
    @_isReady = no
    @_needsClear = no
    @_screenStates = {}
    @_screenStates[Wrap.TRACE] = []
    @_screenStates[Wrap.DEFAULT] = []

    @nodes = []
    @forces = []

    @nodeCount = @nodes.length

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

    density: 1 / 6
    entropy: 1

    contain: on # Contain nodes.
    drainAtEdge: on # Drain node inertia at edges.
    forceOptions: 0
    customForces: {}

    autoMass: off
    gravity: off
    move: off
    trace: off

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

    @defaults.frictionMag = 0.01 * sketch.state.speedFactor # constant * normal

  @traceFillColor: (fc) -> color.transparentize fc, 0.01

  # Inherited
  # =========

  draw: () ->

    tracePrev = @trace
    @trace = @nodeParams.viewMode is Node.LINE

    if tracePrev is on and @trace isnt tracePrev
      @_pushScreen Wrap.TRACE

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
        @_popScreen()

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

  updateNodeCount: (count) ->
    count ?= parseInt @width() * @density # Infer if needed.
    currentCount = @nodes.length
    # Contract if needed.
    if count < currentCount
      # Return nodes removed.
      return (@nodes.pop() for i in [(currentCount - 1)...count])
    # Or expand.
    hasGravity = !!(@forceOptions & PVector.GRAVITY)
    gravity = PVector.createGravity() if hasGravity
    # TODO: Why 1-index?
    for i in [1...(count - currentCount)]
      do (i) =>
        nodeParams = _.extend {}, @nodeParams,
          id: currentCount + i
          wrap: @
        n = new Node nodeParams
        n.p.randomize() if @layoutPattern is Wrap.RANDOM
        n.applyForce gravity if hasGravity
        n.applyForce f for own name, f in @customForces
        n.cacheAcceleration()
        n.log() if i is 1 # Log once.
        @nodes.push n

  # Accessors
  # ---------

  canvasElement: -> document.querySelector 'canvas'

  getTraceFillColor: -> @traceFill

  ready: (r) -> @_ready = r if r?; @onReady() if r; @_ready

  # Binding
  # -------

  toggleForce: (f, toggled) ->

  # Callbacks
  # ---------

  nodeMoved: (n) ->

  onNodeViewModeChange: ->

  onReady: ->
    n.onWrapReady @ for n in @nodes
    @canvasElement().focus()
    @onNodeViewModeChange()
    @log()

  # Protected
  # =========

  # Documenting
  # -----------
  # TODO: I think that's their purpose?

  _pushScreen: (customStack) ->

  _popScreen: ->
