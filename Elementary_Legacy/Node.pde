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
  @c - colors (Object<Array|Bool>) Us rgba arrays for portability.
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

  @defaults: null
  @setup: ->
    Node.defaults =
      id: -1
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
        attrtConst: Vector.G / 10
        attrtDistMin: 5 # Avoid applying huge attraction.pplying huge attraction.
        attrtDistMax: 25 # Avoid applying tiny attraction.
      wrap: null

  ###
  Accessors
  Sugar you should use.
  ###

  stroke: (stroke) ->
    if stroke? then @c.stroke = stroke
    _.trueColor @c.stroke

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

    return if G.responded.mousePressed

    didHit = @overlapsWith mouseX, mouseY
    if didHit

      G.responded.mousePressed = yes

      # On hit, visibly toggle attraction.
      @should.attract = not @should.attract
      @fill if @should.attract then RED else BLACK

  keyPressed: ->

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

_.extend Node::, Event.mixin
