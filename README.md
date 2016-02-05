# GameDoneSwift
##As The World Turns

Our game isn't in a super great state right now. Sure King can move and jump, but what fun is it when
he runs off screen in less than a second. This section will work on remedying that unfortunate
situation by adding a camera to follow King on his adventures.

###The Paparazzi

![camera_object](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/As-The-World-Turns/img/camera_object.png)

![camera_properties](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/As-The-World-Turns/img/camera_properties.png)

![scene_camera](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/As-The-World-Turns/img/scene_camera.png)

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

```swift
func movePlayer() {
    /* Sets the x velocity of the player character */
        
    self.king.physicsBody?.velocity.dx = 1000.0
    moveCameraWith(self.king, offset: 350)
}
```


###Scrolling Background

```swift
var backgrounds: [SKSpriteNode] = []

let backgroundTime: CFTimeInterval = 1.0
var previousTime: CFTimeInterval = 0
var backgroundTimeCount: CFTimeInterval = 0
```

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

```swift
backgroundTimeCount += currentTime - previousTime
        
if backgroundTimeCount > backgroundTime {
    self.addNextBG()
    backgroundTimeCount = 0
}
        
previousTime = currentTime
```

```swift
backgrounds.append(self.background)
addNextBG()
```

###Platform Generation

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

```swift
platformTimeCount += currentTime - previousTime
        
if platformTimeCount > platformTime {
    self.addPlatform()
    platformTimeCount = 0
}
```

###Game Over

[Game Over](https://github.com/IBM-MIL/GameDoneSwift/tree/Game-Over)