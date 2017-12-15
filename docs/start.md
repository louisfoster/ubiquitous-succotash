### I'm using

- Intellij IDEA
- XCode
- An iPhone SE
- Firefox and Chrome browsers
- Macbook
- Server somewhere in the air (ubuntu 16? 14?)
- Vim
- Github (GIT) and apparently Jekyll with github pages
- JBL Charge/BOSE QuietComfort 35s

### Starting stuff

Note: I do things very non-linearly, lose attention quickly (for my own projects, generally), and like to context shift between code, projects, music playlists, meal planning and wikipedia articles.

#### Jekyll docs?

Git hub pages seems cool. But I get an error to start with in jekyll...
```
➜  ubiquitous-succotash git:(master) ✗ gem install jekyll bundler
Fetching: public_suffix-3.0.1.gem (100%)
ERROR:  While executing gem ... (Gem::FilePermissionError)
    You don't have write permissions for the /Library/Ruby/Gems/2.3.0 directory.
``` 
(Oh... I use zsh, fyi)

Some things about rbenv? (nb. I don't use ruby...)
[this](https://github.com/rbenv/rbenv/issues/938) and [this](https://github.com/rbenv/rbenv/issues/463) suggest something to with rbenv but running rbenv doesn't trigger anything in my shell...

[This](http://talk.jekyllrb.com/t/you-dont-have-write-permissions-for-the-var-lib-gems-2-3-0-directory/204/2) from jekyll rb discussion website suggests to use rvm, which I also don't have. Thanks RUBE! It points [here](http://sharadchhetri.com/2014/06/30/install-jekyll-on-ubuntu-14-04-lts/) where sharad shows off his skills in setting up rvm and jekyll.

The `cURL` command installed something and appended a line to my zshrc file. It also warned me of this: `Found PGP signature at: 'https://github.com/rvm/rvm/releases/download/1.29.3/1.29.3.tar.gz.asc', but no GPG software exists to validate it, skipping.` So I might just quickly install some GPG software... `brew install gnupg`. It's the middle of summer here in Australia so I'm sweating it out listening to some sludge metal while I wait for homebrew to update so I can move on... in the mean time, I'm going to create a new project in xcode.

#### XCode

I guess I'm going to make a game. Everyone likes games? I don't know how to make a cool game. I rarely play games. This probably won't end up resembling a game, but, a game it will be. What isn't a game? Gamification can turn anything into a game. So we are making a game, whether it is a game or isn't.

- File > New > Project > iOS > Game
- Product name? Um... ugh... googling weird name generator, I got [this](https://donjon.bin.sh/weird/name/#type=cthulhu;cthulhu=Investigator%20Male) and selected cthulu mythos and unspeakable names (I only have a remote idea wtf this is all about) and choose "Ktanosha"
- Team? Add Account? I thought I did this before? Anyway, I click that and also need to go to last pass (some online password management system) to get my impossibly hard to remember password. This adds a personal team.
- Organisation name for me is Louis Foster, but I doubt you have the same name as me. and the ID is the same because I own louisfoster.com
- Swift for the project language
- I like 3D, so I'm going to choose SceneKit. However, I lose the ability to use Gameplay Kit, which I guess is a bummer.
- I will leave Unit Tests and UI Tests, because it might force me to write a test, which makes me a prodevhackercode.
- The destination should be obvious by now (the ios dir in the root of this repo... as of the commit for this part of the project)


The project is now generated. The project navigator on the left side shows a bunch of pregenerated code and assets. I assume this means if I run it on my iPhone it will show me something cooooooool. I've already "trusted" my mac with my device, so all I have to do is `Cmd+R` and wait for something to pop up. It takes a moment or two and eventually a spaceship or something appears spinning. Pretty lame. There is some kind of fps stats counter and some other stuff, probably verts. I can use the controls to move what feels like the camera position.

Looking through the code, the first point of interest is `AppDelegate.swift`, which basically handles the setup of the app. Aaaaand it's basically empty. There is 1 controller (`GameViewController.swift`) and a storyboard, and some `art.scnassets` dir, which I assume means "art for scene assets". The Controller file has stuff, let's take a look...

It imports UIKit (for the touches I guess), QuartzCore (not sure what this is) and SceneKit (which does the 3D stuff I believe). The controller only extends a standard UIViewController, nice. The viewDidLoad func is a good place to see what happens when... the view... did... load. Oooh!

```swift
// create a new scene
let scene = SCNScene(named: "art.scnassets/ship.scn")!
```

So the ship we saw earlier exists in a .scn (read: scene) file type. Let's check it out! Ok, it shows a standard 3D coord plane, our vector thing and the ship model in the centre. I can navigate this thing pretty easily with my trackpad. The options down the bottom of the editor allows me to manipulate the view in various ways and the utilities on the right has a list of cool objects, lights, physics etc in the object library. I will probably need to visit youtube or something to get better scope on this later...

There's also a texture file in this dir which looks like a flattened ship.

Back to the code...

Looks like we take this scene file and add a camera at some random point, add lights (omni + ambient)  at fairly random points, fetch the ship "node" from the scene and add an action to the ship (the spin/rotation, repeated forever). Then a "view" is created, which I guess is the scene host. We set the view's scene to our scene, give the user controls over the camera, show the stats, make the background black, and add tap recognition. Done.

The rest of the code is just handling the tap and other unimportant stuff. The other files are relatively unimportant too and the tests show no code. Another thing to note is the clicking on the scnassets dir and pressing `Cmd+N` creates a new scene, which is helpful.

Quickly, back to jekyll...


#### Jekyll docs p2

GPG installed, I think. Typing in that gem command yields the same error as before. Oh yeah it said I needed to source a file. some more commands. ffs this takes so damn long. Alright, I'll come back to this.


#### Xcode interlude


I'm going to create another scene, called "world," to act as our world. I will leave the camera that is autogen'd and add a plane, which in order to edit I have to click on scene graph in the Jump Bar and select the plane. I make it -90 deg, centred to world origin and color it. Change the view scene to this new scene, remove the code-instantiated camera and the ship related code, and run the thing to see what happens (I think I should be able to see the color of the plane at least.)

That runs fine. Although the background is white (not black as in the code) and the camera rotation seems to drop through the material and spin around and stuff. I'm not sure if "FPS" style view and controls is necessarily what I want for this touch style screen. Perhaps I will create an object to track instead.

Switching back to jekyll for moment...


#### Jekyll docs p3

Now making some progress, needing to add extra files here and there. Had to install some jekyll and bundler tools, some Gemfile with what is appearing to be a bunch of deps. And apparently now all I need to is type `jekyll serve` and go to `localhost:4000` in my browser and, yup, there's me docs. Sweet as. I'll figure out [how to make it work nicely along the way](https://jekyllrb.com/docs/configuration/), but for now what I have is good enough. Gotta make sure all this crud is kept out of the repo tho (sup, gitignore).


#### Returning to the XCODE

Now, having the third person view sounds like a nice way to go. I can start by adding a box to the scene, give it some nice materials that reflect the light in simple ways (so that we can get a sense of dimensionality and shape), and place it in the centre of the scene. Because it is "third person" we want the camera to be looking at box. We won't think about movement and controls just yet, but for now we will disable the camera controls because I just want to ensure that we render every normally. Unfortunately, there doesn't seem to be any shadow from the box onto the plane, and it also occurred to me that having a fairly uniform color on the plane is going to make it hard to tell if the box is moving.

Before I continue, this is a list of things to do next

1. Move camera/box with taps, turn with swipes
2. Texture floor/get shadow from box
3. Interact with another object

[Home](./)