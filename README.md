# GameDoneSwift
##Lets Get Physical

So we have a nice colorful scene, but it doesn't really do anything yet except sit there and look pretty. That's
what this section is for! Throughout this section we'll take a short dip into SpriteKit's physics engine, so we
can get the world (or at least King) moving.

###Give the ground a body

So before we give King a body, lets make sure he has a place to land. This means our first step is going to be
adding a physics body to the ground sprite.

1. Open up `GameScene.sks`.
2. Select the ground. It's the big green (or other brightly colored) rectangle at the bottom of the scene.
3. In the properties inspector scroll to the bottom where you'll find *Physics Definition*.
4. Make it look like this (the numbers aren't important):

![ground_body](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Lets-Get-Physical/img/ground.png)

The key portions in this screen shot are:

1. The *Body Type* needs to be "Bounding rectangle". This tells the physics engine what shape the node is.
2. *Dynamic* should be unchecked. Dynamic allows the sprite to move. (We don't want our ground moving.)
3. *Allows Rotation* should be unchecked. Similar to Dynamic, but with rotation.
4. *Pinned* should be checked. This ensures that the ground stays pinned to its parent and won't move.
5. *Affected By Gravity* should be unchecked. Stop the ground from falling.

Everything else can stay whatever the default values are. We'll be setting the Masks later.

###Give King a body

Now that we have some solid ground to stand on we can give King a body.

1. In `GameScene.sks` select the King sprite.
2. Just like with the gound modify the *Physics Definition* to look like this (as before the numbers aren't 
important):

![king_body](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Lets-Get-Physical/img/king.png)

The main things to point out here are:

1. The *Body Type* is an "Alpha Mask". This means that the physics body will follow the exact shape of the sprite.
2. *Allows Rotation* is deselected. If you don't do this King will drag his face on the ground when he starts
moving. It's actually pretty funny so feel free to leave selected if you want.

As with the ground we'll be setting the masks later...

###Add Bit Masks

... and later is right now.

Let's start by adding a new file to our project. This file will be a class that holds static references to the 
different physics bit masks we plan to use.

1. Right (CMD) click, the project directory and select "New File..."
![new_file](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Lets-Get-Physical/img/new_file.png)
2. Make sure that "Source" is selected under "iOS". The select "Cocoa Touch Class" and click "Next".
![template](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Lets-Get-Physical/img/template.png)
3. Set the class name to "PhysicsBitMasks" and make it a subclass of "NSObject" then click "Next".
![name](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Lets-Get-Physical/img/file_name.png)
4. Choose a location to save the file and finish creating it.
5. Open up your newly created class and add the following right in the class definition.

```swift
static let player: UInt32 = 0x1 << 0
static let ground: UInt32 = 0x1 << 1
```

These are a couple bit masks that define the player and ground object types to the SpriteKit physics engine. The
reason we are defining them like this instead of setting some insane number in the layout editor is because this
gives us far more control over the number. The player bit mask is shifted 0 and the ground bit mask is shifted 1. 
If we were to add more to this file it is simpler to come up with a new bit mask because we can just shift by the
next value (2).

So now that we have some defined bit masks lets tie them to our sprites.

1. Open `GameScene.swift`.
2. Add the following function to the class.

```swift
func setPhysicsBitMasks() {
    /* Sets up the SKSpriteNode bit masks so they can interact in the physics engine */
        
    self.king.physicsBody?.categoryBitMask = PhysicsBitMasks.player
    self.king.physicsBody?.collisionBitMask = PhysicsBitMasks.ground
    self.king.physicsBody?.contactTestBitMask = PhysicsBitMasks.ground
        
    self.ground.physicsBody?.categoryBitMask = PhysicsBitMasks.ground
    self.ground.physicsBody?.collisionBitMask = PhysicsBitMasks.player
    self.ground.physicsBody?.contactTestBitMask = PhysicsBitMasks.player
        
}
```

This function applies categories to both King and the ground letting them know what type of object they are and
what types of objects they should check for collisions with. Next we'll set up how we react to the collisions.

First add the following to the bottom of `didMoveToView`.

```swift
setPhysicsBitMasks()
self.physicsWorld.contactDelegate = self
```

This calls the function we just wrote that applies our bit masks to the sprites and then sets `GameScene.swift` as
the delegate to be called whenever contact occurs. So we should probably make sure it is equipped to handle it.

At the very bottom of `GameScene.swift` we're going to add an extension to the class. It looks like this:

```swift
extension GameScene: SKPhysicsContactDelegate {
    
    func didBeginContact(contact: SKPhysicsContact) {
        /* Fires when contact is made between two physics bodies with collision bit masks */
        
    }
    
}
```

This extension to `GameScene` makes it conform to the `SKPhysicsContactDelegate` protocol so it can properly handle
an collisions. Now if you run you should see King drop and land on the ground (and maybe bounce a little depending
on how high you put him above the ground).

###Make King "Jump"

Now that we have our game simulating physics we can start interacting with them a bit. Lets start by making King 
jump. We'll accomplish this by applying an impulse in the Y direction to his physics body.

In `GameScene.swift`, add the following function:

```swift
func jump() {
    /* Applies a y velocity to the player character */
        
    self.king.physicsBody?.applyImpulse(CGVector(dx: 200.0, dy: 1000.0))
        
}
```

This is a simple function that we'll be making a few modifications to in a bit. Basically it applies an impluse
to King's physics body that moves him 200 in the X direction and 1000 in the Y direction.

To start the jump add `jump()` to the `touchesBegan` function so it looks like this:

```swift
override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    /* Called when a touch begins */
        
    jump()
        
}
```

Running the app at this point will allow King to jump, but it will also allow him to fly because there is no check
to make sure he is on the ground. So let's add that.

For starters add another global class variable called `onGround` like so:

```swift
var onGround = true
```

Then inside the `didBeginContact` function add `onGround = true` so it looks like this:

```swift
func didBeginContact(contact: SKPhysicsContact) {
    /* Fires when contact is made between two physics bodies with collision bit masks */
        
    onGround = true
        
}
```

This is a naive way to do this, because we aren't checking that the contact is between player and ground, but
because we only have two sprites that can collide we can get away with it.

Finally we modify the `jump` function to check if the player is on the ground:

```swift
func jump() {
    /* Applies a y velocity to the player character */
        
    if onGround {
        self.king.physicsBody?.applyImpulse(CGVector(dx: 200.0, dy: 1000.0))
        onGround = false
    }
        
}
```

Now we you run the game you'll only be able to make King jump when he is on the ground. Feel free to have him jump
all the way off screen.

###Make King "Run"

Now that we have some basic interaction going we can get down to the "runner" part of "infinite runner". It's
actually fairly simple to make King move right at a constant rate. We're just going to set his X velocity at the
end of every update cycle. 

First add a `movePlayer` function that just applies an X velocity change like so:

```swift
func movePlayer() {
    /* Sets the x velocity of the player character */
        
    self.king.physicsBody?.velocity.dx = 1000.0
        
}
```

Then add and override the `didFinishUpdate` function and call the `movePlayer` player function inside of it.  

```swift
override func didFinishUpdate() {
    /* Called after each update */
        
    movePlayer()
    
}
```

If you followed everything in this section so far, King will blissfully fly right off the screen without a care 
in the world bringing us to the end of *Lets-Get-Physical*.

###Continue?

If you wish to continue along with this tutorial series and learn how to setup a camera to follow King on his
adventures you either checkout the [As-The-World-Turns](https://github.com/IBM-MIL/GameDoneSwift/tree/As-The-World-Turns) 
branch with this section completed, or follow along with your own project.

