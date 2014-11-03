## Chapter 1 - Getting to Know CreateJS

### EaselJS

EaselJS provides tools for working with HTML5 Canvas. Here is how you might draw moving graphics with the canvas API

    canvas = document.getElementById "canvas"
    ctx = canvas.getContext "2d"

    butterfly = new Image()
    butterfly.src = "images/butterfly.png"
    butterfly.onload = drawButterflies

    drawButterflies = ->
      ctx.drawImage butterfly, 0, 0, 200, 138, 0, 0, 200, 138
      ctx.drawImage butterfly, 0, 0, 200, 138, 200, 0, 200, 138
      ctx.drawImage butterfly, 0, 0, 200, 138, 400, 0, 200, 138
      setTimeout moveButterfly, 1000

    moveButterfly()
      ctx.clearRect 0, 0, canvas.width, canvas.height
      ctx.drawImage butterfly, 0, 0, 138, 0, 0, 200, 138
      ctx.drawImage butterfly, 0, 0, 138, 200, 200, 200, 138
      ctx.drawImage butterfly, 0, 0, 138, 400, 0, 200, 138


With EaselJS:

    drawButterflies ->
      imgPath = 'images/butterfly.png'
      butterfly1 = new createjs.Bitmap imgPath
      butterfly2 = new createjs.Bitmap imgPath
      butterfly3 = new createjs.Bitmap imgPath
      butterfly2.x = 200
      butterfly3.x = 400
      stage.addChild butterfly1, butterfly2, butterfly3
      stage.update()
      setTimeout moveButterfly, 1000

    moveButterfly = ->
      butterfly2.y += 200
      stage.update()

Note that the graphics are updated on an object named `stage`, which is a reference to the `Stage` root object for all graphics drawn with EaselJS.

### TweenJS

TweenJS is useful for animation. To animate with Canvas directly, you would need to:

1. Draw your butterfly
2. Create a timer
3. At each interval, clear the graphics
4. Redraw the butterfly in a new position
5. Check if position has been reached
6. Clear the timer

To do this with TweenJS:

    createjs.Tween.get(butterfly).to
      y: butterfly.y + 20
    , 1000

Here you access the Tween class, use the `get` method with the `butterfly` object, then use `to` with the properties you want to tween and how long to run. You can combine this with other properties

    y: butterfly.y + 20
    alpha: 0

You can also add easing

    .to
      y: butterfly.y + 20
    , 1000, createjs.Ease.QuadOut

You can see examples of Tween easing options at the [SparkTable](http://www.createjs.com/#!/TweenJS/demos/sparkTable).

Tween also has `wait` and `call` methods to help you manage your animation among other actions. To use a callback, you can do something like this:

    butterflyGone = ->
      stage.removeChild this

    create.js.Tween.get(butterfly).to
      alpha: 0
    , 1000
    .call butterflyGone

You may need to **scope** your object when using callbacks, so that it targets the correct thing. Here is an example of scoping:

    Game =
      score: 0
      init: ->
        this.drawButterfly()
      drawButterfly: ->
        imgPath = 'images/butterfly.png'
        butterfly = new createjs.Bitmap imgPath
        stage.addChild butterfly
        createjs.Tween.get butterfly
          .to
            y: 100
          , 1000
          .call this.butterflyGone, [butterfly], this
      butterflyGone: (butterfly) ->
        stage.removeChilde butterfly
        this.score += 10
        this.gameOver()
      gameOver: ->
        alert "score: #{this.score}"

### SoundJS

SoundJS provides tools for working with sounds across multiple browsers, making it easier with ids to reference particular sounds

    createjs.Sound.registerSound "audio/boom.mp3", "boom", 5
    boom = createjs.Sound.play "boom"

When you register a sound, you set the path, an id, and number of maximum concurrent plays are allowed.

It's important to  preload your sounds so they are available when needed. You'll see how to do that in the next section. You may also want to listen for particular events related to a sound.

    mySound.addEventListener "complete", (mySound) ->
      alert 'sound has finished'

There are other available plugins for working with HTML5 audio problems in modern browsers. To register a plugin:

    create.FlashPlugin.BASE_PATH = '../plugins'
    create.Sound.registerPlugins [createjs.FlashPlugin]

### PreloadJS

PreloadJS is a tool to register your assets and preload them. Here's a simple example:

    queue = new createjs.LoadQueue()
    queue.installPlugin createjs.Sound
    queue.addEventListener "complete", onComplete
    queue.loadManifest [
      id: 'butterfly', src: '/img/butterfly.png'
      id: 'poof', src: '/snd/poof.mp'
    ]

    onComplete = ->
      alert 'all files loaded'

### Dancing Butterflies

The script for dancing butterflies:

    root = global ? window

    root.stage = undefined
    root.queue = undefined

    root.init = ->
      root.queue = new createjs.LoadQueue()
      root.queue.installPlugin createjs.Sound
      root.queue.addEventListener "complete", loadComplete

      root.queue.loadManifest [
        { id: "butterfly", src: "images/butterfly.png" }
        { id: "woosh", src: "sounds/woosh.mp3" }
        { id: "chime", src: "sounds/chime.mp3" }
      ]
      
    root.loadComplete = ->
      console.log "Load Complete"
      setupStage()
      buildButterflies()

    root.setupStage = ->
      console.log "Setting up stage"
      root.stage = new createjs.Stage document.getElementById('canvas')
      createjs.Ticker.setFPS 60
      createjs.Ticker.addEventListener "tick", ->
        root.stage.update()

    root.buildButterflies = ->
      img = queue.getResult "butterfly"

      sound = null
      butterfly = null

      for i in [0...3]
        console.log "Building butterfly #{i}"
        butterfly = new createjs.Bitmap img
        butterfly.x = i * 200
        root.stage.addChild butterfly
        createjs.Tween.get(butterfly).wait(i * 1000).to
          y: 100
        , 1000, createjs.Ease.quadOut
        .call butterflyComplete
      
    root.butterflyComplete = ->
      console.log "Butterfly complete"
      root.stage.removeChild this
      if !root.stage.getNumChildren()
        createjs.Sound.play 'chime'

Getting fancy with CoffeeScript:

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

## Chapter 2 - Making and Animating Graphics

### Stage

You must set up your stage for use with EaselJS. You do this with an instance of `Stage` assigned to an existing canvas element.

    stage = new createjs.Stage document.getElementById('canvas')
    # if canvas is IDed
    stage = new createjs.Stage 'canvas'



### Creating Graphics
### Drawing UI Elements

