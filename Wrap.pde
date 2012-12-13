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

  ###
  Constants (in order):
  - containment
  - screen-state - Private?
  - layout-pattern
  ###

  @UNCONTAINED: 0
  @REFLECTIVE: 1
  @TOROIDAL: 2

  @DEFAULT: 0
  @TRACE: 1

  @UNIFORM_PATTERN: 0
  @RANDOM_PATTERN: 1

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

  constructor: (params = Wrap.defaults) ->

    super params

    @_screenStates[Wrap.TRACE] = []
    @_screenStates[Wrap.DEFAULT] = []
    @nodes = []
    @f.custom = []

  setupGUI: ->

    return if not G.gui?

    gui = G.gui.addFolder "Wrap #{@id}"

    # Speed controls.
    gui.add @, 'frictionMag', 0.001, 0.1
    gui.add @.num, 'entropy', 0, 2

    # Edge controls.
    # Provide a ground as needed.
    gui.add(@, 'hasGravity').onFinishChange (has) =>
     @containment = if has then Wrap.REFLECTIVE else Wrap.TOROIDAL
     @toggleForce Vector.GRAVITY, has
    gui.add(@, 'containment',
      'Reflective': Wrap.REFLECTIVE
      'Toroidal': Wrap.TOROIDAL
    ).listen().onFinishChange (type) => @containment = parseInt type, 10

    # Population controls.
    @nodeCount = @nodes.length
    gui.add(@, 'nodeCount', 0, 500).onFinishChange (nodeCount) => @updateNodeCount nodeCount

    # View controls.
    # Additional binding glue required.
    @nodeViewMode = @nodeParams.viewMode
    gui.add(@, 'nodeViewMode',
      'Ball': Node.BALL
      'Line': Node.LINE
    ).onFinishChange (viewMode) => @onNodeViewModeChange viewMode
    # Additional binding glue required.
    # TODO: Still has issues.
    gui.addColor(@.c, 'fill').onChange (c) =>

    gui.open()

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

  draw: () ->

    wasTracing = @should.trace
    @should.trace = @nodeViewMode is Node.LINE
    changeTracing = @should.trace isnt wasTracing

    if wasTracing is yes and changeTracing is yes
      @pushScreen Wrap.TRACE

    if @should.trace and millis() % (G.fps * 10) is 0
      # 'Layer' the canvas.
      c = @fill()
      fill red(c), green(c), blue(c), alpha(c) / 100
      rect @top(), @left(), @width(), @height()
      noFill()

    if @should.trace is no or @_needsClear is yes
      # Clear the canvas.
      fill @fill()
      rect @top(), @left(), @width(), @height()
      # Sometimes when switching view modes, the canvas needs to be cleared and restored.
      if @_needsClear is yes
        @_needsClear = no
        @popScreen()

    n.draw() for n in @nodes

  mousePressed: -> n.mousePressed() for n in @nodes

  keyPressed: -> n.keyPressed() for n in @nodes

  ###
  Public
  ###

  updateNodeCount: (count) ->
    # Infer count as needed.
    count ?= parseInt @width() * @num.density
    currentCount = @nodes.length
    shouldContract = count < currentCount
    # Contract.
    if shouldContract
      @nodes.pop() for i in [(currentCount - 1)...count]
      return
    # Setup forces.
    if @f.options & Vector.GRAVITY then gravity = Vector.gravity()
    # Or expand.
    for i in [1...(count - currentCount)]
      do (i, defaults = Node.defaults) =>
        n = new Node _.extend true, {}, defaults, @nodeParams,
          id: currentCount + i
          wrap: @
          viewMode: if @nodeViewMode? then @nodeViewMode else @nodeParams.viewMode
        # Additional setup.
        if @layoutPattern is Wrap.RANDOM_PATTERN then n.p.randomize()
        # Introduce forces.
        if @f.options & Vector.GRAVITY then n.applyForce gravity
        n.applyForce(f) for f in @f.custom
        n.cacheAcceleration()
        # Log once.
        if i is 1 then n.log()
        # Add.
        G.stage.nodes.push n

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

