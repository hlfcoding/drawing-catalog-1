class Node

  constructor: (params = Node.defaults) ->

    ###
    Node constructs as dynamically as possible, and has a large set of default
    params. Vectors are auto-constructed and typed. Size and mass are calculated
    automatically if possible.
    ###

    _.defaults params, Node.defaults unless params is Node.defaults

    for name, value of params
      # Account for constructing.
      if value instanceof Array and value.length is 3
        [x, y, z] = value
        value = new PVector x, y, z
      # Account for accessors.
      if typeof @[name] is 'function' then @[name](value)
      else @[name] = value

    @p.type = PVector.POSITION
    @v.type = PVector.VELOCITY
    @a.type = PVector.ACCELERATION

    @mass Node.AUTO_MASS unless @m?

  # Static
  # ======

  ###
  Node can render using one or more different view modes.
  ###

  @FORMLESS: 0
  @BALL: 1 << 0
  @LINE: 1 << 1

  @AUTO_MASS: 1

  @defaults:

    id: -1
    wrap: null

    p: [0, 0, 0]
    v: [0, 0, 0]
    a: [0, 0, 0]

    w: 10
    h: 10
    mMax: 5
    vMax: 5
    attractDistMin: 5 # Avoid applying huge attraction.
    attractDistMax: 25 # Avoid applying tiny attraction.

    attract: on
    autoMass: on
    autoSize: on
    move: on
    varyMass: on

  @setup: ->

    ###
    This needs to be called for the class to be ready for use. Some default
    params reference other values not ready on initial declaration.
    ###

    @defaults.fill = color.BLACK
    @defaults.stroke = color.BLACK

    @defaults.viewMode = @BALL

    @defaults.attractConst = PVector.G / 10

  # Accessors
  # =========

  width: (w) ->
    if w?
      @w = w
      @mass Node.AUTO_MASS
    @w

  height: (h) ->
    if h?
      @h = h
      @mass Node.AUTO_MASS
    @h

  x: (x) -> @p.x = x if x?; @p.x
  y: (y) -> @p.y = y if y?; @p.y
  z: (z) -> @p.z = z if z?; @p.z

  mass: (mass) ->
    if mass?
      if mass is Node.AUTO_MASS and @autoMass is on
        @m = @w * @h
      else
        @m = mass
      if @varyMass in on
        @m *= _.randomDualScale @mMax
      if @autoSize is on
        @w = @h = @m / @w
    @m
