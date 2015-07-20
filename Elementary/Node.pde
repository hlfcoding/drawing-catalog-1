class Node

  constructor: (params = Node.defaults) ->

    ###
    Node constructs as dynamically as possible, and has a large set of default
    params. Vectors are auto-constructed and typed. Size and mass are calculated
    automatically if possible.
    ###

    _.defaults params, Node.defaults unless params is Node.defaults

    for attribute, value of params
      # Account for constructing.
      if value instanceof Array and value.length is 3
        [x, y, z] = value
        value = new PVector x, y, z
      # Account for accessors.
      accessor = @getAccessor attribute
      if accessor? then accessor value
      else @[attribute] = value

    @p.type = PVector.POSITION
    @v.type = PVector.VELOCITY
    @a.type = PVector.ACCELERATION

    @mass Node.AUTO_MASS unless @m?

    @_aCached = null
    @_pFill = null

    @attractorDist = null

    # Manually set after others.
    @isAttractor @attract

  destroy: -> @wrap?.removeNode @

  # Static
  # ======

  ###
  Node can render using one or more different view modes.
  ###

  @FORMLESS: 0
  @BALL: 1 << 0
  @LINE: 1 << 1

  @AUTO_MASS: 1

  @ATTRIBUTE_TO_ACCESSOR:
    w: 'width'
    h: 'height'
    m: 'mass'

  @defaults:

    id: -1
    wrap: null

    p: [0, 0, 0]
    v: [0, 0, 0]
    a: [0, 0, 0]

    # TODO: Actually support rectangles.
    w: 10
    h: 10

    m: null
    mMax: 100
    vMax: 1 # On one dimension.
    density: 1
    attractFieldMin: 40 # Avoid applying huge attraction.
    attractFieldMax: 80 # Avoid applying tiny attraction.
    attractDecayRate: 0.01

    attract: off
    autoMass: on
    autoSize: on
    collide: on
    move: on
    varyMass: off

  @setup: ->

    ###
    This needs to be called for the class to be ready for use. Some default
    attributes reference other values not ready on initial declaration.
    ###

    @defaults.fill = color.BLACK
    @defaults.stroke = color.BLACK

    @defaults.viewMode = @BALL

    @defaults.attractConst = PVector.G

  # Public
  # ======

  # TODO: Better freezing.
  draw: ->
    @updateMovement() if @move
    @updateAttraction() if @attract
    # Note: PJS shortcoming.
    # @mousePressed() if mousePressed

    if @viewMode & Node.BALL
      noStroke()
      fill @fillColor() unless @fill is no
      ellipse @x(), @y(), @w, @h

    if @viewMode & Node.LINE and @shouldDrawLine()
      noFill()
      strokeWeight 0.1
      stroke color.transparentize @strokeColor(), 0.33
      line @x(), @y(), @px(), @py()

    @updateStorage()

  drawBoundsRect: -> rect @top(), @left(), @width(), @height()

  shouldDrawLine: -> @pPrev? and @p.dist(@pPrev) < @w

  updateAttraction: ->
    return @isAttractor off if @_attractLifespan <= 0

    @attractNode n for n in @getNeighbors()
    # Decay.
    @_attractLifespan -= @attractDecayRate * @_attractLifespan

  updateMovement: ->
    @v.add @a
    @refineVelocity()
    @p.add @v
    @resetAcceleration()
    @wrap?.nodeMoved @

  updateStorage: ->
    if @viewMode & Node.LINE
      if @shouldDrawLine() then @pPrev.set @p else @pPrev = @p.get()

  log: -> console.info @

  # Geometry
  # --------

  # TODO - Configurable hit area.
  overlapsWith: (x, y) ->
    abs(@x() - x) < (@w / 2) and abs(@y() - y) < (@h / 2)

  # Physics
  # -------

  applyForce: (vec, toggled = on) ->
    mutableVec = vec.get()
    mutableVec.div @m if vec.type isnt PVector.GRAVITY
    if toggled is on then @a.add(vec) else @a.sub(vec)

  attractNode: (n) ->
    f = PVector.sub @p, n.p
    f.type = PVector.ATTRACTION
    d = constrain f.mag(), @attractFieldMin, @attractFieldMax
    strength = (@attractConst * @mass() * n.mass()) / sq(d)
    f.normalize()
    f.mult strength
    n.applyForce f
    n.attractorDist = PVector.dist @p, n.p
    n.onAttract @

  refineVelocity: -> @v.limit @vMax

  resetAcceleration: ->
    if @_aCached? then @a = @_aCached.get()
    else @a.mult 0 # Clear if nothing to reset to.

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

  getAccessor: (attribute) ->
    accessor = @[attribute]
    accessor ?= @[Node.ATTRIBUTE_TO_ACCESSOR[attribute]]
    accessor ?= @["#{attribute}Color"]
    return accessor.bind @ if typeof accessor is 'function'
    undefined

  width: (w) ->
    if w?
      wPrev = @w
      @w = w
      @mass Node.AUTO_MASS
      @attractFieldMin *= @w / wPrev
      @attractFieldMax *= @w / wPrev
    @w

  height: (h) ->
    if h?
      @h = h
      @mass Node.AUTO_MASS
    @h

  radius: (r) ->
    if r?
      @width r * 2
      @h = @w
    @w / 2 # Optimize if needed.

  mass: (m) ->
    if m?
      # Support autoMass.
      # It's 2D 'mass', where the third size is 1.
      if m isnt Node.AUTO_MASS then @m = m
      else if @autoMass is on then @m = @w * @h * @density
      # Support varyMass.
      @m *= sqrt random.dualScale(@mMax) if @varyMass is on
      # Support autoSize.
      @w = @h = @m / @w / @density if @autoSize is on and @m?
    @m

  isAttractor: (bool) ->
    if bool?
      @attract = bool
      # Update fill.
      @_pFill ?= @fill
      @fillColor if @attract is on then color.RED else @_pFill
      # Restart decay.
      @_attractLifespan = 1.0 if @attract is on
    @attract

  ###
  As an exception, try to always use the position accessors, since they wrap a
  complex object.
  ###

  x: (x) -> @p.x = x if x?; @p.x
  y: (y) -> @p.y = y if y?; @p.y
  z: (z) -> @p.z = z if z?; @p.z

  px: -> @pPrev.x
  py: -> @pPrev.y
  pz: -> @pPrev.z

  ###
  Note these assume ellipseMode or rectMode is CENTER.
  ###

  top: (t) -> @y (t + @h / 2) if t?; @y() - @h / 2
  bottom: (b) -> @y (b - @h / 2) if b?; @y() + @h / 2
  left: (l) -> @x (l + @w / 2) if l?; @x() - @w / 2
  right: (r) -> @x (r - @w / 2) if r?; @x() + @w / 2

  fillColor: (fc) -> @fill = color.ensure fc if fc?; @fill
  strokeColor: (sc) -> @stroke = color.ensure sc if sc?; @stroke

  getNeighbors: -> n for n in @wrap.nodes when n isnt @

  # Callbacks
  # ---------

  handleClick: (c) ->
    should = @overlapsWith c.mouseX, c.mouseY
    return no unless should
    @isAttractor not @attract

  onAttract: (attractor) ->
    # Destroy if too close.
    return unless @collide
    d = @p.dist attractor.p
    return unless d < @attractFieldMin
    # Destroy the attractor with lesser mass.
    if @isAttractor() and @m > attractor.mass then attractor.destroy()
    else @destroy()
