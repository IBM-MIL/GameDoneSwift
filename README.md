# GameDoneSwift
##Game Over

###Pump Up The Jams

![targets_pane_icon](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Game-Over/img/targets_pane_icon.png)

![linked_frameworks](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Game-Over/img/linked_frameworks.png)

![framework_search](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Game-Over/img/framework_search.png)

![sick_beats](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Game-Over/img/sick_beats.png)

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

###GameOver

```swift
if king.position.y < -200 {
    gameOver()
}
```

```swift
func gameOver() {
    self.paused = true
    presentScore()
}
```

```swift    
func presentScore() {
    let alert = UIAlertController(title: "Game Over!", message:"Your final score was \(score).", preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "Try Again!", style: .Default) { _ in
        self.reset()
    })
    sceneController.presentViewController(alert, animated: true){}
        
}
```

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

###Thanks For Reading

[master](https://github.com/IBM-MIL/GameDoneSwift/tree/master)