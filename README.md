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

### Resize Our Game Secene

The first thing we'll want to do is resize our scene, so click anywhere inside the scene editor to bring up the scene
properties inspector in the top left. It will look something like this:

![scene_attributes](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Reticulating-Splines/img/scene_attributes.png)

The only thing you need to edit in these attributes is the screen size. Make it a solid `1334 x 750` so it at least matches
the resolution of an iPhone 6 screen. (Note: This doesn't mean that it won't run or look fine on devices that have different 
screen resolutions.)

### Add Some Clouds

Next we're gonna add our first sprite to the game. In the bottom right of XCode you'll fine the object library. Inside the
object library are all kinds of native game objects that can be used in your scene. For the purposes of this tutorial we'll
only really be focusing on the *Color Sprite*.

![objects_pane](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Reticulating-Splines/img/objects_pane.png)

To add a sprite to you scene simple click and drag a color sprite out of the object library and into the scene editor. This
will create a nice red square in your scene. With this sprite selected you'll see some different attributes in the properties
inspector. You should now edit your attributes so that they match the following:

![background_attributes](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Reticulating-Splines/img/background_attributes.png)

The major changes here are mostly to the size, location, name, and texture. They are:
1. Set the Name to "background" (XCode should attempt to autocomplete this for you.). Setting the name will allow us to find 
it in *GameScene.swift* later.
2. Change the Texture to "background". This will make it look like pretty clouds.
3. Change the Position to `X:0 Y:0`. This places the sprite's anchor at the scene's origin.
4. Change the Anchor Point to `X:0 Y:0`. This set the anchor point of the sprite to it's bottom left.
5. Change the Size to `W: 1334 H: 750`. This will make the sprite the same size as the scene.

Now you have a nice pretty cloud background.

### Add The Ground

Let's add a nice green rectangle for our main character to run/stand/awkwardly slide on.

Just like we did with the background, drag a Color Sprite into the scene and change its attributes to mostly match these:

![ground_attributes](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Reticulating-Splines/img/ground_attributes.png)

1. Set the Name to "ground".
2. Set the Size to `W:2500 H:100`. We want our ground to have a decent runway before it drops off and the player has to
start jumping.
3. Set the Position to `X:1250 Y:50`. Since we aren't setting the anchor point to `X:0 Y:0` like we did for the background
we need to compensate for it to place the bottom left corner of the ground rectangle at the scene's origin.
4. Set the Z Position to `1`. This ensures that the ground appears infront of the background.
5. Set the Color to green. (Unless you want a red/blue/magenta/lavendar or other crazy color ground. I won't judge you.)

(Note: The ground's Anchor Point needs to stay at `X:0.5 Y:0.5` to make sure its physics body lines up when we add that in 
the next phase.)

### Add Our Main Character

Time to add our main character, *King*!

Just like we did with the background and ground, drag a Color Sprite into the scene and change its attributes to mostly match these:

![king_attributes](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Reticulating-Splines/img/king_attributes.png)

1. Set the name to "king".
2. Set the texture to "unicorn".
3. Set the size to `W:200 H:200`.
4. Set the position to ~`X:200 Y:220`. The position isn't as important. Just make sure that King is on the left side of the
screen and that he's hovering just above the ground.
5. Set the Z Position to `1`. This ensures that King appears infront of the background.

(Note: King's Anchor Point needs to stay at `X:0.5 Y:0.5` to make sure his physics body lines up when we add that in the next 
phase.)

### Link To GameScene.swift

Great! So now we have some sprites in our scene to start playing with, but how can we access them in our code? Lets start
by opening up *GameScene.swift* again. You should've carved out all of the boiler plater stuff earlier leaving us with
and empty shell of a class to work with.

The first thing we want to do is add these as global variables to the class:

```swift
let kingSpriteName = "king"
let groundSpriteName = "ground"
let backgroundSpriteName = "background"
    
var king: SKSpriteNode!
var ground: SKSpriteNode!
var background: SKSpriteNode!
```

The three `let` variables are there to act as defines for our sprite names. I'm sure you noticed that they match what we
gave our sprites in the properties inspector. The three `var` variables are there to hold references to the sprites once we
find them.

To link the sprites from the layout editor to our `var`s, add this to the `didMoveToView` function:

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

What this code snippet is doing is checking with the game scene to see if it has a child node with a specific name, and that
if it does, it is an `SKSpriteNode`. The guard statement lets us do all of that fairly easily, and if for some reason a 
sprite's name is wrong, or it has an incorrect type we'll get a nice print in our debug console saying that the sprites 
were not found. After this check occurs is assigns the nodes it found to our global variables so we can use them later.

At this point it should be safe to run the app again and if all goes well you should see this:

![scene](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Reticulating-Splines/img/scene.png)

(and hopefully you won't see "Sprites not found." in the debug console.)

### Moving Forward

Hey! The game is looking a bit more colorful now. In the next phase we'll start to get moving and dip into SpriteKit's
physic's engine. If you want to continue feel free to either follow along with your own project, or checkout the 
[Lets-Get-Physical](https://github.com/IBM-MIL/GameDoneSwift/tree/Lets-Get-Physical) branch which already has this phase
completed.