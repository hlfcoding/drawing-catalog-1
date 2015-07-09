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

    @_aCached = null

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

  # Public
  # ======

  # TODO: Better freezing.
  draw: ->

  drawBoundsRect: -> rect @top(), @left(), @width(), @height()

  log: -> console.info @

  # Physics
  # -------

  applyForce: (vec, toggled = on) ->
    mutableVec = vec.get()
    mutableVec.div @m if vec.type isnt PVector.GRAVITY
    if toggled is on then @a.add(vec) else @a.sub(vec)
    @ # Chaining.

  ###
  Caching allows the resulting acceleration to be committed into cache and
  reused later as base.
  ###

  cacheAcceleration: -> @_aCached = @a.get()

  # Accessors
  # ---------

  ###
  Use accessors for public access when possible instead of the attributes, which
  are generally private outside of construction. Also note accessor names are
  adjusted, so they don't conflict with their respective attributes. Lastly, the
  main reason to wrap attributes in accessors is to allow for will-set and
  did-set behaviors, as well as additional transformations.
  ###

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

  mass: (m) ->
    if m?
      if m is Node.AUTO_MASS and @autoMass is on
        @m = @w * @h
      else
        @m = m
      if @varyMass in on
        @m *= _.randomDualScale @mMax
      if @autoSize is on
        @w = @h = @m / @w
    @m

  ###
  As an exception, try to always use the position accessors, since they wrap a
  complex object.
  ###

  x: (x) -> @p.x = x if x?; @p.x
  y: (y) -> @p.y = y if y?; @p.y
  z: (z) -> @p.z = z if z?; @p.z

  ###
  Note these assume ellipseMode or rectMode is CENTER.
  ###

  top: (t) -> @y (t + @h / 2) if t?; @y() - @h / 2
  bottom: (b) -> @y (b - @h / 2) if b?; @y() + @h / 2
  left: (l) -> @x (l + @w / 2) if l?; @x() - @w / 2
  right: (r) -> @x (r - @w / 2) if r?; @x() + @w / 2

  fillColor: (fc) -> @fill = color.ensure fc if fc?; @fill
