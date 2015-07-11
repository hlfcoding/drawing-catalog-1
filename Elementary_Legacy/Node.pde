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
  Public
  ###

  mousePressed: ->

    return if G.responded.mousePressed

    didHit = @overlapsWith mouseX, mouseY
    if didHit

      G.responded.mousePressed = yes

      # On hit, visibly toggle attraction.
      @should.attract = not @should.attract
      @fill if @should.attract then RED else BLACK

  keyPressed: ->

  # TODO - Hit area.
  # TODO - Primitive shape types.
  overlapsWith: (x, y) -> dist(@x(), @y(), x, y) < @width()

_.extend Node::, Event.mixin
