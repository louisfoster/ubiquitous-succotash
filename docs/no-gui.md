### No more GUI editors!!!

I feel like there might be a long way to go before something cool begins to take place in the dimension known as "Ktanosha." But I feel like if I play multiple Chick Corea albums over one another, then perhaps it will inspire me to see the potential in these raw conceptions.

Here are some things I more or less wanted to achieve now:
- Get a texture on the plane
- Get a shadow from the box on the plane
- Move the box (and the camera follow) according to user input


#### XCODE: A texture flips my lid

I realised I forgot to add the xcode project to a workspace. Basically, just create a new workspace, save it to the same dir as yr project then open the finder and drag the xcodeproj file into the project navigator of the workspace. This allows you to have mutliple projects (such as cocoa pods) all working together. Good work.

I've added the provided ship texture (imitating the method used in the example) by dragging the texture onto the plane and setting the lighting model to lambert (not sure at this stage if the lighting model really matters, but we are also trying to figure out shadows!) It's worthwhile looking into lighting models later, same with getting appropriate textures and models -> start with the basics first. I also adjusted the camera slightly to get a nicer angle, here is what it all looks like:

![block1]({{ "./assets/block1.png" | absolute_url }})


#### Ruby/Jekyll Interlude
...
well, for the moment I can't make sure the above image is visible because jekyll won't run in my shell. slakdfalkdsf;lakjsdf;almksvd;lkansdvasfd!!!!!! wth rube! You worked yesterday! y u no work 2dai? I went back to sharad's website I mentioned [here](./start) and found a command like this: `source ~/.rvm/scripts/rvm` which worked, so I added it to my .zshrc file. If yr wondering what zsh is, it's [z shell](http://www.zsh.org/) which is an alternative shell and you can use it with [oh my zsh](http://ohmyz.sh/) which comes with some cool add-ons. I think people who take the time to build and improve shells (especially when they are usually free and open source) are really cool people are invaluable to the entire IT community.
...


#### Back to having my lid flipped by XCODE

Notice the texture is patterned across the plane? You can do that by repeating across the S and T wrap and changing the scale (I chose '10'). `Cmd+R` to see the results of these minor changes. Looks nice, I can see that the texture is laid out in a way that will help me know that block is moving if I keep the camera at a fixed position behind it (which, for now, is what I intend to do.) There is no obvious shadow coming off the box onto the plane, so I believe this might have something to do with the kind of light I'm using - I'll solve this issue later.

Now that I'm here, I am beginning to think about how I want the controls to work (and also how much I would like these same controls to work in the browser, but first things first and second things second and third things third and forth things forth, I should script this, yay! coding!) and have decided on trying to implement it as so:

- Swipe up ⬆️ moves forward (away from user) 
- Swipe right ➡️ turns right
- Swipe left ⬅️ turns left
- Swipe down ⬇️ moves back (towards user)

I will need to experience how this feels as I'm a little confused over the turning mechanism, as a part of me says that swiping should move the player conversely. However, this implies that by swiping left or right we are moving the environment around the player, which may be how the animation "looks." But then if we swipe up to move forward, then we are commanding the player to move upon the environment in the direction of the swipe, and it's the environment that appears to move conversely (as the player in fact remains stationary in the centre of the screen throughout all swipes and animations.) As much as I am tempted to find some examples of other apps/games implemented some variation of this, or checking stack overflow or something, I'm just going to implement what I have above and see how it goes, because either way, this is a learning experience.

I've switched the camera controls back on and when I use them, this time I can see that no matter how I control the camera (move, rotate, etc) I continue looking at the box, but the box stays stationary. Really, in this 3D "world" all user movements are essentially camera movements, which in maths-land is, in a sense and not entirely accurately, whole world movements (because there isn't really a physical "camera" in this world that is moving, is there?) So what I want to do is keep looking at the box, but when I move the camera (along the x and z axis, not y because the camera should stay at the same height always looking down at the box) the box should appear to move as well, at the same rate, as to give the illusion of the camera "following" the box. I guess this could actually work inversely. Ugh... now I'm confused as the best way to do this. Might do a quick google.

Ok, I can't really be bothered to copy the discussions here because there are plenty and they all say conflicting things. For now, I'm going to go the route of having an empty "node" and making both the box and the camera a child of this empty node, so, no matter how the <whatever the box becomes> moves or rotates or animates, the camera will be focused on the position of the empty node and rotate and track according to it's position/angle. The empty node will then also set the centre position for the box/whatever and can also be used in future to help contain anything else which needs a relative point for the "center view." In any case, I'm trying to figure out how to do this with the scene editor interface, but it really doesn't provide a clear way of doing so, and as such I feel like I'm wasting time playing around with a drag and drop editor (which I really don't like to use any way and might as well pick up Unity instead). Looking at SO questions like [this one](https://stackoverflow.com/questions/42029347/position-a-scenekit-object-in-front-of-scncameras-current-orientation/42030679) is making me want to just focus on the code, so I'm going to take a minute and see if I can implement what I've already created, but entirely with code.

That wasn't so bad, however I encountered a few issues when trying to apply the image material to the plane and get it to repeat in the way I had it while using the scene kit editor. Being able to look at the code and manipulate that instead of some funky drag and drop UI with input areas and whatnot really makes a difference and I didn't quite find the editor as intuitive as I hoped. The thing is, the code for swift and it's various libraries and APIs are fairly clear, so I think I prefer doing it that way anyway. I used [this SO question](https://stackoverflow.com/questions/44920519/repeating-a-texture-over-a-plane-in-scenekit) to figure out how to apply the texture. Basically, my issue was over the confusing while setting the `planeMaterial.diffuse.contents` property. I was trying to use what I thought was correct, that is, by creating a `SCNMaterialProperty` and handling the image there. This was incorrect, the image gets passed as a `UIImage` directly to the `planeMaterial.diffuse.contents` property, like so:

```Swift
let planeMaterial = SCNMaterial()
planeMaterial.diffuse.contents = UIImage(named: "art.scnassets/texture.png")
planeMaterial.diffuse.wrapS = .repeat
planeMaterial.diffuse.wrapT = .repeat
planeMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(10, 10, 0)
```

This has revealed some interest points. Firstly, there is a "contents" property to set some properties that can't be set directly. Secondly, the `SCNMatrix4MakeScale` that returns a scaling transformation matrix (helpful!) and other matrix helpers.

Another point is that some transformations require radians, not degrees, which is standard practice, so I/You/them have to make sure to convert degrees to radians (the editor had it's default input as degrees, not radians, hence why this is relevant.)


#### Joy to the Code

This means I can move away from reliance on the GUI editor thingo and just focus on writing code, which is the ideal. I love writing, I love writing code. Also, in the process of eliminating the editor, I changed from layers of Chick Corea to just single albums by Herbie Hancock, and it feels like I'm celebrating life. Herbie Hancock is brilliant. Listening to his music is like reading a good book. Also, in order to perk myself up (as it is around midnight as I do this), I went and got myself an Oreo McFlurry with caramel sauce, it's some kind of ice cream from McDonalds. I wouldn't usually eat "Macca's" but it's pretty difficult to get much food at this time of night where I am.

By adding a spot light high up in the scene, in addition to the already existing omni (for general brightness) and ambient light (for light where it would otherwise would not be), I can get a shadow to appear underneath the box. But now that it is there, I don't really feel like it adds much to the current aesthetics and realism, so I'm going to remove it in order to reduce the general overhead it brings to the rendering of the scene. This basically finishes two of the tasks I wanted to accomplish for now.

This page is fairly long already and I'm not sure that handling user input and making the box move around with the camera is going to be only a few lines to talk about (primary user interface is basically the defining point of really any software) so that will be it's own ramble. Although I am going to wrap the box in various colours beforehand so that I know which side of the box I'm tracking as I move around. Thankfully, the code has already been created [here](https://stackoverflow.com/a/45447813). The finally step will be just to add some comments and make a commit for reference. There is some weird stuff going on with files I didn't want commited (xcuserdata) which was supposed to be respected by the `.gitignore` but wasn't, an apparently this is an [issue](https://stackoverflow.com/questions/6564257/cant-ignore-userinterfacestate-xcuserstate). 

[Home](./)