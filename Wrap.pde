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
  Constants (in order)
  - containment
  - screen-state
  ###

  @UNCONTAINED: 0
  @REFLECTIVE: 1
  @TOROIDAL: 2

  @DEFAULT: 0
  @TRACE: 1

  @defaults: null
  @setup: ->
    # Don't extend Node.defaults.
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
        entropy: 1
      containment: Wrap.REFLECTIVE
      frictionMag: 0.01 * SPEED_FACTOR # constant * normal
      hasGravity: no
      viewMode: Node.FORMLESS
      nodeViewMode: Node.BALL
      _isReady: no
      _needsClear: no
      _screenStates: {}

  constructor: (params = Wrap.defaults) ->

    super params

    @_screenStates[Wrap.TRACE] = []
    @_screenStates[Wrap.DEFAULT] = []

  setupGUI: ->

    return if not G.gui?

    gui = G.gui.addFolder "Wrap #{@id}"

    # Speed controls.
    gui.add @, 'frictionMag', 0.001, 0.1
    gui.add @.num, 'entropy', 0, 2

    # Edge controls.
    # TODO: Don't work.
    gui.add @, 'hasGravity'
    gui.add @, 'containment',
      'Reflective': Wrap.REFLECTIVE
      'Toroidal': Wrap.TOROIDAL

    # View controls.
    # Additional binding glue required.
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
    if viewMode? then @nodeViewMode = parseInt(viewMode, 10) else viewMode = @nodeViewMode
    (n.viewMode = viewMode) for n in @nodes
    @_needsClear = @nodeViewMode is Node.LINE
    @draw()

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

    if @should.trace and millis() % (FRAME_RATE * 10) is 0
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
      # X
      didContain = no
      if n.left() > @right()
        n.right @left()
        didContain = yes
      else if n.right() < @left()
        n.left @right()
        didContain = yes
      # Y
      if n.top() > @bottom()
        n.bottom @top()
        didContain = yes
      else if n.bottom() < @top()
        n.top @bottom()
        didContain = yes

      if didContain and @should.drainAtEdge
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

