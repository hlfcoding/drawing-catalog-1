
###
Globals.
###
G =
  # UI responder flag for allowing optional global handling. Any individual
  # responders should register the global flag accordingly.
  responded:
    mousePressed: no
    keyPressed: no

###
System functions.
###

mousePressed: ->

  G.responded.mousePressed = no

  G.stage.mousePressed()

keyPressed: ->

  G.responded.keyPressed = no

  #console.log key

  G.stage.keyPressed()

###
Global helpers.
###

###
One of the first things we need to do is to be able to control the cycle-expensive run state
without stopping the server. This is especially handy when LiveReload is used.
###
freeze: (should) ->

  # Default.
  should ?= !G.frozen

  n.should.move = !should for n in G.stage.nodes

  # Note: noLoop() and loop() are somehow global in PJS.
  if should then window.noLoop() else window.loop()

  # Save.
  G.frozen = should
  #console.log "is frozen: #{G.frozen}"

