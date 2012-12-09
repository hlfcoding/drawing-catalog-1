class PVectorAdditions

  ###
  Monkey patch PVector
  @type - (Constant)
  ###

  @GENERIC: 0
  @POSITION: 1
  @VELOCITY: 2
  @ACCELERATION: 3
  @GRAVITY: 4
  @ATTRACTION: 4

  ###
  Gravity constant.
  ###
  @G: 0.01

  @setup: ->

    PVector::randomize = ->
      if @type is Vector.POSITION
        @x = random width
        @y = random height

  @gravity: ->
    v = new PVector 0, 0.5 * SPEED_FACTOR
    v.type = Vector.GRAVITY
    v

# Alias.
Vector = PVectorAdditions

###
Language Additions

Some are from Underscore / Backbone, some from jQuery. Only here if they are heavily relied upon.
###

class Utility

  # Concise type-checking. Slowest form. Courtesy of jQuery.
  @typeOf: (obj) -> if obj? then _.TYPES[toString.call(obj)] else String(obj) or 'object'
  @TYPES:
    '[object Boolean]':  'boolean'
    '[object Number]':   'number'
    '[object String]':   'string'
    '[object Function]': 'function'
    '[object Array]':    'array'
    '[object Date]':     'date'
    '[object RegExp]':   'regexp'
    '[object Object]':   'object'
  # jQuery.isPlainObject
  @isCollection: (obj) ->
    # Must be an Object.
    # Make sure that DOM nodes and window objects don't pass through, as well.
    return no if not obj? or _.typeOf(obj) isnt 'object' or obj.nodeType or obj == obj.window
    # Own properties are enumerated firstly, so to speed up,
    # if last one is own, then all properties are own.
    '' for key of obj
    return key is undefined or hasOwnProperty.call(obj, key)
  @isArray: Array.isArray # Faster form.

  # Check instance Class, recursively as needed to check the inheritance chain.
  @isKindOfClass: (obj, aClass) ->
    bool = obj.constructor is aClass
    if not bool and obj.constructor.__super__?
      bool = isKindOfClass obj.constructor.__super__, aClass
    bool

  # Extend + deep-extend + clone. Courtesy of jQuery.
  @extend: (args...) ->
    target = args[0] or {}
    a = 1
    deep = no
    # Handle a deep copy situation.
    if _.typeOf(args[0]) is 'boolean'
      deep = args[0]
      target = args[1] or {}
      # Skip the boolean and the target.
      a = 2
    # Handle case when target is a string or something (possible in deep copy)
    if typeof target isnt 'object' and typeof target isnt 'function' then target = {}
    # Start.
    for arg, i in args
      do (arg) ->
        return if i < a or not arg?
        obj = arg
        for name, prop of obj
          src = target[name]
          # Prevent never-ending loop.
          continue if target is prop
          # Recurse if we're merging plain objects or arrays.
          if deep is yes and prop? and (_.isCollection(prop) or (propIsArray = _.isArray(prop)))
            if propIsArray
              propIsArray = no
              clone = if src? and _.isArray(src) then src else []
            else clone = if src? and _.isCollection(src) then src else {}
            # Never move original objects, clone them.
            target[name] = _.extend deep, clone, prop
          # Don't bring in undefined values.
          else if prop isnt undefined
            target[name] = prop
    # Return the modified object.
    return target

  ###
  Math
  ###

  @randomDualScale: (n) -> random(1, n) / random(1, n)

# Alias.
_ = Utility

Event =
  SPLITTER: (/\s+/)
  mixin:
    on: (events, callback, context) ->

      return @ if not callback?
      events = events.split Event.SPLITTER
      calls = @_callbacks or (@_callbacks = {})

      while event = events.shift()
        list = calls[event]
        node = if list then list.tail else {}
        node.next = tail = {}
        node.context = context
        node.callback = callback
        calls[event] =
          tail: tail
          next: if list then list.next else node

      @

    off: (events, callback, context) ->

      if not(calls = @._callbacks) then return
      if not(events or callback or context)
        delete @._callbacks
        return @

      events = if events then events.split(Event.SPLITTER) else Object.keys(calls)
      while event = events.shift()
        node = calls[event]
        delete calls[event]
        if not node or not(callback or context) then continue
        tail = node.tail
        while (node = node.next) isnt tail
          cb = node.callback
          ctx = node.context
          if (callback and cb isnt callback) or (context and ctx isnt context) then @.on event, cb, ctx

      @

    trigger: (events, rest...) ->

      if not(calls = @._callbacks) then return @
      all = calls.all
      events = events.split Event.SPLITTER

      while event = events.shift()
        if node = calls[event]
          tail = node.tail
          node.callback.apply(node.context or @, rest) while (node = node.next) isnt tail
        if node = all
          tail = node.tail
          args = [event].concat rest
          node.callback.apply(node.context or @, args) while (node = node.next) isnt tail

      @

Input = {}

for i in [1...9]
  Input["NUM_#{i}"] = 48 + i

