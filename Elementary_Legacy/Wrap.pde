class Wrap extends Node

  ###
  Container for nodes. A more flexible version of stage.
  @nodes - (Array)
  @frictionMag - (Number)
  @nodeViewMode - (BitMask) Passes through to nodes.
  @_isReady - (Bool)
  @hasGravity - (Bool)
  @_needsClear - (Bool)
  @_screenStates - (Object<Array<ImageData>>)
  ###

  @defaults: null
  @setup: ->
    # Don't extend Node.defaults.
    # Inherited.
    Wrap.defaults =
      p: [0, 0, 0]
      v: [0, 0, 0]
      a: [0, 0, 0]
      s:
        width: width
        height: height
      c:
        fill: WHITE
      should:
        move: no # Override.
        autoMass: no # Override.
        contain: yes # Contain nodes.
        drainAtEdge: yes # Drain node inertia at edges.
      num:
        density: 1 / 6
        entropy: 1
      viewMode: Node.FORMLESS
      # Custom.
      f:
        options: 0
        custom: null
        _allCustom: null
      containment: Wrap.REFLECTIVE
      frictionMag: 0.01 * G.speedFactor # constant * normal
      hasGravity: no
      layoutPattern: Wrap.RANDOM_PATTERN
      nodeViewMode: null # Placeholder.
      nodeCount: null # Placeholder.
      nodeParams:
        should:
          varyMass: yes
        viewMode: Node.BALL
      _isReady: no
      _needsClear: no
      _screenStates: {}

  ###
  Binding
  ###

  onNodeViewModeChange: (viewMode) ->
    # Beware of dat-GUI type-conversion bugs.
    if viewMode?
      @nodeViewMode = parseInt(viewMode, 10)
      (n.viewMode = viewMode) for n in @nodes
    else @nodeViewMode = @nodeParams.viewMode
    @_needsClear = @nodeViewMode is Node.LINE
    @draw()

  toggleForce: (f, toggle) ->
    return if not toggle?
    @f._allCustom ?= @f.custom
    if typeof f is 'number' # Force option.
      # Vector.
      switch f
        when Vector.GRAVITY then vec = Vector.gravity()
      # Update.
      if toggle then @f.options |= f else @f.options ^= f
    else if f in @f._allCustom # Force name.
      # Vector.
      vec = @f._allCustom[f]
      # Update.
      if toggle then @f.custom.push vec
      else _.remove @f.custom, vec
    if vec? then for n in @nodes
      n.applyForce(vec, toggle)
      n.cacheAcceleration()

  ###
  Accessors
  Sugar you should use.
  ###

  left: -> @x()
  top: -> @y()
  right: -> @width() + @left()
  bottom: -> @height() + @top()
  $canvas: -> $('canvas')
  canvas: -> @$canvas().get(0)
  ready: (isReady) ->
    if isReady?
      # DOM-ready-dependent initialization.
      @_isReady = isReady
      if isReady is yes
        @trigger 'ready'
        @$canvas().focus()
        @onNodeViewModeChange()
        @log()
    @_isReady

  ###
  Inherited
  ###

  mousePressed: -> n.mousePressed() for n in @nodes

  keyPressed: -> n.keyPressed() for n in @nodes

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
      didContain = { x: yes, y: yes }
      # X
      if n.left() > @right() then       n.right @left()
      else if n.right() < @left() then  n.left @right()
      else didContain.x = no
      # Y
      if n.top() > @bottom() then       n.bottom @top()
      else if n.bottom() < @top() then  n.top @bottom()
      else didContain.y = no

      if (didContain.x or didContain.y) and @should.drainAtEdge
        n.v.normalize()
        n.a.normalize()

  _prepScreenOp: -> [@canvas().getContext('2d'), if @should.trace is yes then Wrap.TRACE else Wrap.DEFAULT]

  pushScreen: (forcedStack) ->
    [ctx, stack] = @_prepScreenOp()
    screen = ctx.getImageData @left(), @top(), @width(), @height()
    @_screenStates[if forcedStack? then forcedStack else stack].push screen

  popScreen: ->
    [ctx, stack] = @_prepScreenOp()
    return if not @_screenStates[stack].length
    ctx.putImageData @_screenStates[stack].pop(), @left(), @top()

