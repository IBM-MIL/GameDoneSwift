# GameDoneSwift
##Reticulating Splines

We couldn't come up with a clever name for this section and really wanted to make a Maxis joke, so here you go. What
we'll actually be covering is how to use *GameScene.sks* to build a basic game world and tie all of the pieces from the
editor into *GameScene.swift*.

### Clear Filler

Before we start building our first scene we need to clear out everything that was written for the boiler plate project.
So open up *GameScene.swift* and delete everything out of the functions until they look like this:

```swift
class GameScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
```

Good. Now that we have a clean class to work with lets open up *GameScene.sks* to start adding sprites.

### Resize Game Secene

The first thing we'll want to do is resize our scene, so click anywhere inside the scene editor to bring up the scene
attributes inspector in the top left. It will look something like this:

![starting_files](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Reticulating-Splines/img/scene_attributes.png)

### Add Background
### Add Unicorn
### Add Ground
### Link to GameScene.swift

```swift
let kingSpriteName = "king"
let groundSpriteName = "ground"
let backgroundSpriteName = "background"
    
var king: SKSpriteNode!
var ground: SKSpriteNode!
var background: SKSpriteNode!
```

```swift
guard let king = self.childNodeWithName(kingSpriteName) as? SKSpriteNode,
    let ground = self.childNodeWithName(groundSpriteName) as? SKSpriteNode,
    let background = self.childNodeWithName(backgroundSpriteName) as? SKSpriteNode 
    else {
        print("Sprites not found.")
        return
}

self.king = king
self.ground = ground
self.background = background
```
