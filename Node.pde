class Node

  ###
  Multi-purpose display and animation element.
  Physics aspect completely from Nature-of-Code.
  @id - (Number)
  @p - position (Vector)
  @pPrev - previous position (Vector)
  @v - velocity (Vector)
  @a - acceleration (Vector)
  @m - mass (Number)
  @s - sizes (Object)
  @c - colors (Object<Color|Bool>)
  @should - switches (Object)
  @num - numbers (Object<Number>)
  @viewMode - (BitMask)
  @_wrap - delegate (Wrap)
  @_neighbors - neighboring nodes (in the same wrap) (Array<Node>)
  @_aCached - cached constant acceleration, which prevents unnecessary re-applying (Vector)
  @id - (Number)
  ###

  ###
  Constants
  ###

  @BALL: 1 << 0
  @LINE: 1 << 1

  @defaults: null
  @setup: ->
    Node.defaults =
      p: [0, 0, 0]
      v: [0, 0, 0]
      a: [0, 0, 0]
      s:
        width: 10
        height: 10
      c:
        fill: BLACK
        stroke: BLACK
      viewMode: Node.BALL
      should:
        move: yes
        autoMass: yes
        autoSize: yes
        varyMass: no
        attract: no
      num:
        massMax: 5
        velMax: 5
        attrtConst: Vector.G
        attrtDistMin: 5 # Avoid applying huge attraction.pplying huge attraction.
        attrtDistMax: 25 # Avoid applying tiny attraction.
      wrap: null

  constructor: (params = Node.defaults) ->

    for name, p of params
      # Account for constructing.
      value = if name in ['p', 'v', 'a'] then new PVector p[0], p[1], p[2] else p
      # Account for accessors.
      if typeof @[name] is 'function' then @[name](value) else @[name] = value

    @p.type = Vector.POSITION
    @v.type = Vector.VELOCITY
    @a.type = Vector.ACCELERATION

    if not @m? then @mass Node.AUTO_MASS

  ###
  Accessors
  Sugar you should use.
  ###

  width: (width) ->
    if width?
      @s.width = width
      @mass Node.AUTO_MASS
    @s.width

  height: (height) ->
    if height?
      @s.height = height
      @mass Node.AUTO_MASS
    @s.height

  x: (x) ->
    if x? then @p.x = x
    @p.x

  y: (y) ->
    if y? then @p.y = y
    @p.y

  z: (z) ->
    if z? then @p.z = z
    @p.z

  top: (top) ->
    if top? then @y top + @s.height / 2
    @y() - @s.height / 2

  bottom: (bottom) ->
    if bottom? then @y bottom - @s.height / 2
    @y() + @s.height / 2

  left: (left) ->
    if left? then @x left + @s.width / 2
    @x() - @s.width / 2

  right: (right) ->
    if right? then @x right - @s.width / 2
    @x() + @s.width / 2

  @AUTO_MASS: 1
  mass: (mass) ->
    if mass?
      if mass is Node.AUTO_MASS and @should.autoMass
        @m = @s.width * @s.height
      else @m = mass
      if @should.varyMass
        @m *= _.randomDualScale @num.massMax
      if @should.autoSize
        @s.width = @s.height = @m / @s.width
    @m

  fill: (fill) ->
    if fill? then @c.fill = fill
    @c.fill

  stroke: (stroke) ->
    if stroke? then @c.stroke = stroke
    @c.stroke

  wrap: (wrap) ->
    if wrap?
      @_wrap = wrap
      if @_wrap.ready() is yes then @neighbors @_wrap.nodes
      else @_wrap.on 'ready', => @neighbors @_wrap.nodes
    @_wrap

  neighbors: (nodes) ->
    if nodes?
      @_neighbors = (n for n in nodes when n isnt @)
    @_neighbors

  ###
  Public
  ###

  # TODO: Better freezing.
  draw: ->

    # Update.
    if @should.move is yes then @move()
    if @should.attract is yes then @attract @neighbors()
    # Note: PJS shortcoming.
    # if mousePressed is yes then @mousePressed()

    # Ball view.
    if @viewMode & Node.BALL
      # Style.
      noStroke()
      if @fill isnt no then fill @fill()
      # Draw.
      ellipse @x(), @y(), @width(), @height()

    # Line view.
    if @viewMode & Node.LINE
      noFill()
      # Style
      strokeWeight 0.1
      c = @stroke()
      stroke red(c), green(c), blue(c), alpha(c) / 3
      if @pPrev? and @p.dist(@pPrev) < width
        line @x(), @y(), @pPrev.x, @pPrev.y
        @pPrev.set @p
      else @pPrev = @p.get()

  mousePressed: ->

    didHit = @overlapsWith mouseX, mouseY
    if didHit

      responded.mousePressed = yes

      # On hit, visibly toggle attraction.
      @should.attract = not @should.attract
      @fill if @should.attract then RED else BLACK

  keyPressed: ->

    pViewMode = @viewMode

    switch key.code
      when Input.NUM_1 then @viewMode = Node.BALL
      when Input.NUM_2 then @viewMode = Node.LINE

    if @viewMode isnt pViewMode
      responded.keyPressed = yes
      @wrap().nodeChangedViewMode @

  # Caching allows the resulting acceleration to be committed into cache and reused later as base.
  # Chainable.
  applyForce: (vec, shouldCacheA = no) ->

    mutableVec = vec.get()
    if vec.type isnt Vector.GRAVITY
      mutableVec.div @m
    @a.add vec
    if shouldCacheA is yes then @_aCached = @a.get()
    @

  move: ->

    @v.add @a
    if @v.mag() > sq(@num.velMax)
      @v.normalize()
      @v.mult @num.velMax
    @p.add @v
    if @_aCached? then @a = @_aCached.get()
    else @a.mult 0 # Clear if nothing to reset to.

    if @wrap()? then @wrap().nodeMoved @

  # node - (Node|Array<Node>)
  attract: (n) ->

    if _.typeOf(n) is 'array'
      @attract aN for aN in n
      return

    f = PVector.sub @p, n.p
    f.type = Vector.ATTRACTION
    d = constrain f.mag(), @num.attrtDistMin, @num.attrtDistMax
    strength = (@num.attrtConst * @mass() * n.mass()) / sq(d)
    f.normalize()
    f.mult strength
    n.applyForce f

  # TODO - Hit area.
  # TODO - Primitive shape types.
  overlapsWith: (x, y) -> dist(@x(), @y(), x, y) < @width()

  log: ->

    console.info @

_.extend Node::, Event.mixin
