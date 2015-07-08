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

    nodeParams:
      varyMass: on

  @setup: ->

    ###
    This needs to be called for the class to be ready for use. Some default
    params reference other values not ready on initial declaration.
    ###

    _.defaults @defaults, Node.defaults

    @defaults.width = width
    @defaults.height = height

    @defaults.fill = color.WHITE

    @defaults.containment = Wrap.REFLECTIVE
    @defaults.layoutPattern = Wrap.RANDOM
    @defaults.viewMode = Node.FORMLESS

    @defaults.nodeParams.viewMode = Node.BALL

    @defaults.frictionMag = 0.01 * sketch.state.speedFactor # constant * normal

  # Public
  # ======

  # Accessors
  # ---------

  ready: (isReady) ->

  # Change
  # ------

  updateNodeCount: (count) ->

  # Binding
  # -------

  toggleForce: (f, toggled) ->
