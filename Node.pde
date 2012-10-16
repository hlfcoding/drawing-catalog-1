class Node

  ###
  Multi-purpose display and animation element.
  Physics aspect completely from Nature-of-Code.
  @p - position (Vector)
  @v - velocity (Vector)
  @a - acceleration (Vector)
  @m - mass (Number)
  @s - sizes (Object)
  @c - colors (Object<Color|Bool>)
  @n - numbers (Object<Number>)
  @should - switches (Object)
  @wrap - delegate (Object)
  @_aCached - cached constant acceleration, which prevents unnecessary re-applying (Vector)
  #####
  
  ###
  Constants
  #####
  
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
      should:
        move: yes
        autoMass: yes
        autoSize: yes
        varyMass: no
      n:
        massMax: 5
      wrap: null
  
  constructor: (params = Node.defaults) ->
    
    for name, p of params
      @[name] = if name in ['p', 'v', 'a'] then new PVector p[0], p[1], p[2] else p
    
    @p.type = PVectorAdditions.POSITION
    @v.type = PVectorAdditions.VELOCITY
    @a.type = PVectorAdditions.ACCELERATION
    
    if not @m? then @mass Node.AUTO_MASS
  
  ###
  Sugar you should use.
  #####
  
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

  @AUTO_MASS: 1
  mass: (mass) ->
    if mass?
      if mass is Node.AUTO_MASS and @should.autoMass
        @m = @s.width * @s.height
      else @m = mass
      if @should.varyMass
        @m *= _.randomDualScale @n.massMax
      if @should.autoSize
        @s.width = @s.height = @m / @s.width
    @m
  
  fill: (fill) ->
    if fill? then @c.fill = fill
    @c.fill
  
  ###
  Public
  #####
  
  # TODO: Better freezing.
  draw: ->
    
    # Update.
    if @should.move is yes
      @move()
    
    # Style.
    if @fill is no then noFill() else fill @fill()
    
    # Draw.
    ellipse @x(), @y(), @width(), @height()
  
  applyForce: (vec, shouldCacheA = no) ->
    
    mutableVec = vec.get() 
    if vec.type isnt Vector.GRAVITY
      mutableVec.div @m
    @a.add vec
    if shouldCacheA is yes then @_aCached = @a.get()
    @ # Chainable.
  
  move: ->
    
    @v.add @a
    @p.add @v
    if @_aCached? then @a = @_aCached.get()
    
    if @wrap? then @wrap.nodeMoved @
    
  log: ->
    
    console.info @
  

