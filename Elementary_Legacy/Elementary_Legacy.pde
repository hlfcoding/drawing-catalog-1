
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
