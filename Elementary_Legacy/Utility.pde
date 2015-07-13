###
Language Additions
###

###
Static helpers. Some are from Underscore / Backbone, some from jQuery. Only here if they are heavily relied upon.
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

# Alias.
_ = Utility

#Input sugar.
Input = {}
for i in [1...9]
  Input["NUM_#{i}"] = 48 + i

