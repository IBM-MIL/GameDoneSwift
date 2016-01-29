# GameDoneSwift
##Brand New Project
Welcome to your brand new project! 

This is what an empty SpriteKit template looks like. Getting your project to look like this is fairly simple. 
It just takes a few mouse clicks. You really don't even need to clone this branch if you want to make the 
empty project yourself. We just have it here for convenience.

### Lets Get Started

First we're gonna go over whats in the project. If you look to the project browser on the left side of XCode 
you should see something like this:

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

