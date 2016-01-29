# GameDoneSwift
##Brand New Project
Welcome to your brand new project! 

This is what an empty SpriteKit template looks like. Getting your project to look like this is fairly simple. 
It just takes a few mouse clicks. You really don't even need to clone this branch if you want to make the 
empty project yourself. We just have it here for convenience.

### Lets Get Started

First things first. Open the project.

Inside the GameDoneSwift-iPhone directory you'll find *GameDoneSwift.xcodeproj*. Either double click this file
to launch XCode, or if you're using the terminal run `open GameDoneSwift.xcodeproj`.

Now that we have the project open (hopefully) we're gonna go over whats in the project. If you look to the project 
browser on the left side of XCode you should see something like this:

![starting_files](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Brand-New-Project/img/starting_files.png)

These are your starting files. If you've done iOS development before you'll see a few familiar faces, but I'm 
going to go through each of these files here anyway.

- *AppDelegate.swift* - This file manages your app's life cycle. It handles what to do on app launch, app close, and 
states in between.
- *GameScene.sks* - This is a SpriteKit specific file. This is the visual layout editor for your game's scene. 
We'll cover more on this later.
- *GameScene.swift* - This is the swift file that controls GameScene.sks. We'll be doing most of our work in this 
file.
- *GameViewController.swift* - This is the ViewController that displays the Game Scene.
- *Main.storyboard* - This is a classic iOS storyboard. It's useful for visually creating app navigation, but we 
won't be touching it much in this tutorial.
- *Assets.xcassets* - This is where all of your sprite images, background images, or any other assets go.
- *LaunchScreen.storyboard* - This is another iOS default storyboard that handles the screen that is displayed when
the app launches.
- *Info.plist* - This is a property list file that comes pre-populated with important project information, device
orientation, and status bar styling.

Now that we're familiar with our project structure lets clean it up and get some basic necessities out of the way.

### Cleaning Up

*Landscape Orientation*

The first thing we should do is make sure that our app stays in landscape.

1. Select the project in your project browser. This is what is highlighted blue in the screen shot above.
2. Make sure you are on the "General" tab.
3. Look for these checkboxes underneath "Deployment Info".
![device_orientation](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Brand-New-Project/img/device_orientation.png)
4. Uncheck "Portrait". (And "Upside Down" if for some reason that is checked. Hint: It shouldn't be.)
5. Click the Run button. (Or press "command + r")

If you managed to complete these 5 difficult steps (and clicked the simulator screen a couple times) you should see 
something like the following:

![hello_world](https://raw.githubusercontent.com/IBM-MIL/GameDoneSwift/Brand-New-Project/img/hello_world.png)
<center>The (almost) default SpriteKit game, everyone!</center>

Now to test that your app stays in landscape mode rotate the simulator using "command + <-" or "command + ->". 

*Asset Swap*

I hope you didn't get too attached to that spaceship because now we're going to get rid of it and replace it with
a unicorn.

First we'll remove the spaceship.

1. Select "Assets.xcassets" in your project browser.
2. Click "Spaceship" in the asset browser.
3. Say "Goodbye Spaceship."
4. Press delete.

Now we'll add our own assets.

1. Open a finder window and navigate to the "assets" directory in this repo.
2. Click and drag both "background.png" and "unicorn.png" into the asset browser.
3. Select "GameScene.swift" in your project browser.
4. Replace the following code:
```
let sprite = SKSpriteNode(imageNamed:"Spaceship")
```
with:
```
let sprite = SKSpriteNode(imageNamed:"unicorn")
```
(Really all we did was switch spaceship for unicorn. But that looks a bit better.)
5. Run the app again to start spawning unicorns.

### Moving Forward

Congratulations! You completed the first step of this silly simple tutorial. Before continuing it might be good to 
look at the code inside *GameScene.swift* and *GameViewController.swift* to get yourself a bit more familiar with them 
before we really start modifying them.

To continue with the tutorial feel free to either checkout the [Reticulating-Splines](https://github.com/IBM-MIL/GameDoneSwift/tree/Reticulating-Splines) 
branch which has these steps already completed, or continue working inside your own project.



