root = global ? window

class ButterflyDance
  stage : undefined
  queue : undefined

  setupStage : ->
    console.log "Setting up stage"
    @stage = new createjs.Stage document.getElementById('canvas')
    createjs.Ticker.setFPS 60
    createjs.Ticker.addEventListener "tick", =>
      @stage.update()
    return

  loadComplete : =>
    console.log "Load Complete"
    @setupStage()
    @buildButterflies()

  buildButterflies : ->
    img = @queue.getResult "butterfly"

    sound = null
    butterfly = null

    for i in [0...3]
      console.log "Building butterfly #{i}"
      butterfly = new createjs.Bitmap img
      butterfly.x = i * 200
      @stage.addChild butterfly
      createjs.Tween.get(butterfly).wait(i * 1000).to
        y: 100
      , 1000, createjs.Ease.quadOut
      .call @butterflyComplete
    
  butterflyComplete : =>
    console.log "Butterfly complete"
    @stage.removeChild this
    if !@stage.getNumChildren()
      createjs.Sound.play 'chime'

  init : ->
    @queue = new createjs.LoadQueue()
    @queue.installPlugin createjs.Sound
    @queue.addEventListener "complete", @loadComplete

    @queue.loadManifest [
      { id: "butterfly", src: "images/butterfly.png" }
      { id: "woosh", src: "sounds/woosh.mp3" }
      { id: "chime", src: "sounds/chime.mp3" }
    ]

root.ButterflyDance = ButterflyDance
