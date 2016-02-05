# GameDoneSwift
##As The World Turns

Our game isn't in a super great state right now. Sure King can move and jump, but what fun is it when
he runs off screen in less than a second. This section will work on remedying that unfortunate
situation by adding a camera to follow King on his adventures.

###The Paparazzi

Let's jump right in and create a camera.

1. Open `GameScene.sks`
2. Find the Camera object in the object library.

![camera_object](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/As-The-World-Turns/img/camera_object.png)

3. Drag the camera object onto the scene.
4. Set the camera's properties as follows:

![camera_properties](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/As-The-World-Turns/img/camera_properties.png)

5. *Name* is set to "camera".
6. *Position* is "X: 667 Y: 375".
7. Click outside the yellow-orange camera rectangle to select the scene.
8. Set the scene *Camera* to camera. This allows us to access it later.

![scene_camera](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/As-The-World-Turns/img/scene_camera.png)

Now that we have a camera in our scene we need to make sure it follows King. So first we'll need
to add the following function to `GameScene.swift`.

```swift
func moveCameraWith(node: SKNode, offset: CGFloat) {
    /* Moves the camera along the x-axis with a specified node and offset */
        
    guard let camera = self.camera else {
        print("No camera.")
        return
    }
        
    camera.position = CGPoint(x: node.position.x + offset, y: 375)

}
```

After checking that the camera exists with a guard statement, it sets the camera's x position to
the node's x position plus an offset. This allows us to keep King near the left side of the screen.

Now we just need to move the camera every time we move King. So in the `movePlayer` function add
the call for out newly created `moveCameraWith` function, so it looks like this:

```swift
func movePlayer() {
    /* Sets the x velocity of the player character */
        
    self.king.physicsBody?.velocity.dx = 1000.0
    moveCameraWith(self.king, offset: 350)
}
```

If you run the game at this point you'll get to watch King jump off a cliff into a grey abyss!

###Scrolling Background

We're gonna hold off on fixing that pesky cliff problem for a bit, and fix the grey abyss first.
We can accomplish this by adding a scrolling background. 

The first things we're gonna need are some more global class variables. So add the following to
the `GameScene` class:

```swift
var backgrounds: [SKSpriteNode] = []

let backgroundTime: CFTimeInterval = 1.0
var previousTime: CFTimeInterval = 0
var backgroundTimeCount: CFTimeInterval = 0
```

`backgrounds` is an array that stores all of our background sprites. `backgroundTime` is the rate
at which we spawn new backgrounds (in seconds). `previousTime` is the time stamp of the previous
update, and `backgroundTimeCount` is the amount of time that has passed since the last sprite was
added.

With our handy class variables, we can now create some new background sprites. Add the following
function the the `GameScene` class:

```swift
func addNextBG() {
    /* Adds a new background sprite to backgrounds. */
        
    let nextBG = SKSpriteNode(imageNamed: "background")
    nextBG.size = CGSize(width: 1920.0, height: 1080.0)
    nextBG.anchorPoint = CGPoint(x: 0.0, y: 0.0)
    nextBG.position.x = backgrounds.last!.position.x + backgrounds.last!.frame.width
        
    backgrounds.append(nextBG)
    addChild(nextBG)
    if backgrounds.count > 100 {
        backgrounds.first?.removeFromParent()
        backgrounds.removeFirst()
    }

}
```

This function creates a new background sprite and places it at the end of the previously created
one. It then checks the size of the backgrounds array and prunes it if it appears to be getting too
big.

Now we can add the following to the `update` function:

```swift
backgroundTimeCount += currentTime - previousTime
        
if backgroundTimeCount > backgroundTime {
    self.addNextBG()
    backgroundTimeCount = 0
}
        
previousTime = currentTime
```

The above code snippet uses the scene's update function to keep track of how much time has passed
since the last background was added. In this case it adds a new background every second.

Finally we need to add our original background sprite and a second sprite to the array so the screen
doesn't start off blank. Add this to the bottom of the `didMoveToView` function:

```swift
backgrounds.append(self.background)
addNextBG()
```

###Platform Generation

Ok, we've solved the grey abyss problem. Let's look into solving that pesky cliff issue now. The way
we're going to solve this is by spawning a series of randomly sized platforms after our ground sprite
drops off. Sure this makes King's life harder, but it wouldn't be much of a game if he never
encountered an obstacle.

Begin by adding all of these global class variables to the `GameScene` class:

```swift
var platforms: [SKShapeNode] = []

// Platform Configuration
let platformStartX: CGFloat = 2900.0
let platformHeight: CGFloat = 100.0
let minPlatformWidth: UInt32 = 100
let platformMaxWidthChange: UInt32 = 700
let minPlatformY: UInt32 = 200
let platformMaxYChange: UInt32 = 200
let platformSpacing: CGFloat = 450.0
    
let platformTime: CFTimeInterval = 0.5
var platformTimeCount: CFTimeInterval = 0
```

You'll notice that some of these mirror some of the background variables, and that's because we're 
going to use the same methodology to spawn in our platforms. Everything else (the stuff in the
"Platform Configuration" category) is there to make the platform sizes and locations easily
configurable.

Now add the following function which creates a new platform from a given CGRect:

```swift
func platformWithRect(rect: CGRect) -> SKShapeNode {
    /* Create a new platform node and its physics body. */
        
    let platform = SKShapeNode(rect: rect)
    platform.name = "platform"
    platform.fillColor = UIColor(red: 206/256, green: 229/256, blue: 139/256, alpha: 1.0)
    platform.zPosition = 1
        
    let center = CGPointMake(platform.frame.origin.x + platform.frame.width/2, platform.frame.origin.y + platform.frame.height/2)
    platform.physicsBody = SKPhysicsBody(rectangleOfSize: rect.size, center: center)
    platform.physicsBody?.affectedByGravity = false
    platform.physicsBody?.allowsRotation = false
    platform.physicsBody?.dynamic = false
    platform.physicsBody?.pinned = true
    platform.physicsBody?.categoryBitMask = PhysicsBitMasks.ground
    platform.physicsBody?.collisionBitMask = PhysicsBitMasks.player
    platform.physicsBody?.contactTestBitMask = PhysicsBitMasks.player
        
    return platform
        
}
```

The reason this is seperated out into its own function is because each platform needs to be
initialized with its physics body intact, and that would be quite a bit of code if we had all of it
combined with the next function you need to add, the `addPlatform` function. If we were going deeper
into this game this function would most likely be an initializer for a custom SKShapeNode class.

Go ahead and add the `addPlatform` function now:

```swift
func addPlatform() {
    /* Add a new platform to the game. */
        
    var x: CGFloat = platformStartX
    let y = CGFloat(arc4random_uniform(platformMaxYChange)+minPlatformY)
    let width = CGFloat(arc4random_uniform(platformMaxWidthChange)+minPlatformWidth)
        
    if platforms.count > 0 {
        let previous = platforms.last!
        x = previous.frame.origin.x + previous.frame.width + platformSpacing
    }
        
    let rect = CGRect(x: x, y: y, width: width, height: platformHeight)
        
    let platform = platformWithRect(rect)
        
    platforms.append(platform)
    addChild(platform)
    if platforms.count > 150 {
        platforms.first?.removeFromParent()
        platforms.removeFirst()
    }
        
}
```

This function generates a random CGRect to initialize a platform with. It then adds this platform to
both the scene and the platforms array. If the platforms array starts getting too full it will 
trim it.

Finally we need to add the following snippet to the `update` method. Make sure it is added before the 
`previousTime = currentTime` statement.

```swift
platformTimeCount += currentTime - previousTime
        
if platformTimeCount > platformTime {
    self.addPlatform()
    platformTimeCount = 0
}
```

And there you have it. You should now be able to play a basic version of an infinite runner. The
camera will follow King as he tries to traverse these inconvenient platforms infront of the
repetitive clouds.

###Game Over

Oh No! Our tutorial is approaching its end. We already have a playable game on our hands, but there
are still a couple of loose ends to tie up. Head on over to the [Game Over](https://github.com/IBM-MIL/GameDoneSwift/tree/Game-Over)
branch to put on those finishing touches. As always, you can either checkout that branch for the 
most up to date code, or continue along with your own project.