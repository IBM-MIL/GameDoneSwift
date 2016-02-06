# GameDoneSwift
##Game Over

Welcome to the final section of this tutorial series. It's been a fun time, but unfortunatly our time 
is almost at an end. But before it's time to ship it, let's add a few finishing touches to our game.

###Pump Up The Jams

Up until this point King's journey has been one of silence and solitude. Well we're about to fix one
of those issues. Let's add some background music in there!

The first thing we're going to have to add is the `AVFoundation` framework. 

1. Select the project in the project explorer. (Like we did at the very beginning.)
2. Make sure you are on the "GameDoneSwift" target. If you are, the top left of your work area should
look like this:

![targets_pane_icon](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Game-Over/img/targets_pane_icon.png)

If you aren't, you can either click the drop down to select the target, or expand the targets pane by
clicking the square with a bar on its left side and selecting the target in there.

3. Once the target is properly selected to can look for the *Linked Frameworks and Libraries* section
at the bottom of the general tab. It looks like this:

![linked_frameworks](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Game-Over/img/linked_frameworks.png)

4. Click the "+" at the bottom of the section.
5. Search for "AVFoundation" in the window that pops up. (You'll probably only need to type "AV".)

![framework_search](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Game-Over/img/framework_search.png)

6. Select `AVFoundation.framework` and click "Add".
7. Drag *sickBeats.mp3* from the *assets* folder of this repo into your project directory.

![sick_beats](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Game-Over/img/sick_beats.png)

Now that we have all the proper files in our project lets add the code.

Open `GameScene.swift` back up and add the following at the very top with the other import:

```swift
import AVFoundation
```

Cool, we can use AVFoundation functions and objects now. Let's declare a global class variable to play
our music:

```swift
var player: AVAudioPlayer!
```

Finally we can start playing the music. At the end of the `didMoveToView` function add the following:

```swift
do {
    let sickBeats = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sickBeats", ofType: "mp3")!)
    player = try AVAudioPlayer(contentsOfURL: sickBeats)
    player.numberOfLoops = -1
    player.play()
} catch {
    print("Failed to load audio.")
}
```

This isn't very complicated. We start off by attempting to find the mp3 file in our project bundle.
(If you dragged it in correctly you should be fine.) Then we initialize our player. The number of
loops being set to `-1` is so it will loop infinitly. All of this is wrapped inside a `do-try-catch`
block because the `AVAudioPlayer` can throw an error if it fails to initialize.

Run the app now to hear those sick beats.

###Game Over

This is it, the final portion. All we're gonna add here is a little bit of code to score the player,
present a game over, and reset the game. As always we'll start with our global class variables.

Add these to the `GameScene` class:

```swift
var sceneController: GameViewController!
var score = 0
```

The scene controller is a reference to the `ViewController` that displayed the game scene so we can
present an alert view, and the score is pretty self explanatory.

Now for the first time in this tutorial series, we'll open up `GameViewController.swift`. In here
we're gonna add a single line to the `viewDidLoad` function so it looks like this:

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    if let scene = GameScene(fileNamed:"GameScene") {
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
            
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
            
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
            
        scene.sceneController = self
            
        skView.presentScene(scene)
    }
}
```

Can you spot the line we added? Yes! It is `scene.sceneController = self`. This just completes the
setup of our global variable so it isn't `nil` when we try to use it.

Time to head back over to `GameScene.swift`. Add the following code snippet inside the 
`didFinishUpdate` function:

```swift
if king.position.y < -200 {
    gameOver()
}
```

This handy code snippet will trigger the `gameOver` function when King falls below the screen. Let's
write that function now. Add the following code the the `GameScene` class:

```swift
func gameOver() {
    self.paused = true
    presentScore()
}
```

This simple function pauses the scene so everything stops updating, and calls the `presentScore`
function, which looks like this:

```swift    
func presentScore() {
    let alert = UIAlertController(title: "Game Over!", message:"Your final score was \(score).", preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "Try Again!", style: .Default) { _ in
        self.reset()
    })
    sceneController.presentViewController(alert, animated: true){}
        
}
```

Add it to the `GameScene` class.

This function creates a `UIAlertController` that shows the player their final score and offers them
the chance to try again. Which if they choose to do so will trigger the `reset` function. Go ahead 
and add it to the `GameScene` class:

```swift    
func reset() {
    self.removeAllChildren()
    self.addChild(background)
    self.addChild(ground)
    self.addChild(king)
        
    self.king.position = CGPoint(x: 200, y: 220)
    moveCameraWith(king, offset: 350)
        
    platforms = []
    backgrounds = []
    addNextBG()
        
    score = 0
        
    self.paused = false
}
```

The final function we'll be adding. This function resets all of our tracking variables and clears
all nodes off the scene. It then moves king and the camera back to their starting points, adds
the original sprites back to the scene, and unpauses the game.

That's it! Go ahead and run the game now. When you die, you'll get a nice little alert view 
telling you how long you were alive and prompting to to "Try Again!".

###Thanks For Reading

I hope you enjoyed this tutorial series, and maybe learned something from it. If you want to play
the game in its completed state (without going through all the work yourself) you can head back over 
to the [master](https://github.com/IBM-MIL/GameDoneSwift/tree/master) branch where the completed game 
lives. 