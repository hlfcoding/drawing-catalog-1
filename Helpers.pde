# TODO: extend()

class PVectorAdditions
  
  ###
  Monkey patch PVector
  @type - (Constant)
  #####
    
  @GENERIC: 0
  @POSITION: 1
  @VELOCITY: 2
  @ACCELERATION: 3
  @GRAVITY: 4
  
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
###
 

class Utility

  # Concise type-checking. Slowest form. Courtesy of jQuery.
  @typeof: (obj) -> if obj? then _.TYPES[toString.call(obj)] else String(obj) or 'object' 
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
    return no if not obj? or _.typeof(obj) isnt 'object' or obj.nodeType or obj == obj.window
    # Own properties are enumerated firstly, so to speed up,
    # if last one is own, then all properties are own.
    '' for key of obj
    return key is undefined or hasOwnProperty.call(obj, key)
  @isArray: Array.isArray # Faster form.
    
  # Extend + deep-extend + clone. Courtesy of jQuery.
  @extend: (args...) ->
  
    a = 1
    deep = no
    # Handle a deep copy situation.
    if typeof args[0] is 'boolean'
      deep = args[0]
      target = args[1] or {}
      # Skip the boolean and the target.
      a = 2
    # Handle case when target is a string or something (possible in deep copy)
    if typeof target isnt 'object' and _.typeof(target) isnt 'function' then target = {}
    # Start.
    for arg, i in args
      do (arg) ->
        return if i < a
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
  #####
    
  @randomDualScale: (n) -> random(1, n) / random(1, n)
  
# Alias.
_ = Utility
