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

  _prepScreenOp: -> [@canvas().getContext('2d'), if @should.trace is yes then Wrap.TRACE else Wrap.DEFAULT]

  pushScreen: (forcedStack) ->
    [ctx, stack] = @_prepScreenOp()
    screen = ctx.getImageData @left(), @top(), @width(), @height()
    @_screenStates[if forcedStack? then forcedStack else stack].push screen

  popScreen: ->
    [ctx, stack] = @_prepScreenOp()
    return if not @_screenStates[stack].length
    ctx.putImageData @_screenStates[stack].pop(), @left(), @top()

