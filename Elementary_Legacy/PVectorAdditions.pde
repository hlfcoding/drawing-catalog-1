class PVectorAdditions

  ###
  Static class to monkey patch PVector and add additional sugar.
  Constants (in order):
  [type] - (Constant|BitMask) Force-type vectors can be used as options.
  G - Gravity constant.
  ###

  @GENERIC: 0
  @POSITION: 1
  @VELOCITY: 2
  @ACCELERATION: 3

  @GRAVITY:    1 << 0
  @ATTRACTION: 1 << 1

  @G: 0.01

  @setup: ->

    PVector::randomize = ->
      if @type is Vector.POSITION
        @x = random width
        @y = random height

  @gravity: ->
    v = new PVector 0, G.speedFactor / 2
    v.type = Vector.GRAVITY
    v

# Alias.
Vector = PVectorAdditions
