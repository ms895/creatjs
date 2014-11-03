# root = global ? window
# 
# root.stage = undefined
# root.queue = undefined
# 
# root.init = ->
#   root.queue = new createjs.LoadQueue()
#   root.queue.installPlugin createjs.Sound
#   root.queue.addEventListener "complete", loadComplete
# 
#   root.queue.loadManifest [
#     { id: "butterfly", src: "images/butterfly.png" }
#     { id: "woosh", src: "sounds/woosh.mp3" }
#     { id: "chime", src: "sounds/chime.mp3" }
#   ]
#   
# root.loadComplete = ->
#   console.log "Load Complete"
#   setupStage()
#   buildButterflies()
# 
# root.setupStage = ->
#   console.log "Setting up stage"
#   root.stage = new createjs.Stage document.getElementById('canvas')
#   createjs.Ticker.setFPS 60
#   createjs.Ticker.addEventListener "tick", ->
#     root.stage.update()
# 
# root.buildButterflies = ->
#   img = queue.getResult "butterfly"
# 
#   sound = null
#   butterfly = null
# 
#   for i in [0...3]
#     console.log "Building butterfly #{i}"
#     butterfly = new createjs.Bitmap img
#     butterfly.x = i * 200
#     root.stage.addChild butterfly
#     createjs.Tween.get(butterfly).wait(i * 1000).to
#       y: 100
#     , 1000, createjs.Ease.quadOut
#     .call butterflyComplete
#   
# root.butterflyComplete = ->
#   console.log "Butterfly complete"
#   root.stage.removeChild this
#   if !root.stage.getNumChildren()
#     createjs.Sound.play 'chime'
# 
# 
