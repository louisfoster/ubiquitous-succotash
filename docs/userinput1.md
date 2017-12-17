### User Input-ification

Now that the ahpp is uhp and ruhnning using `code` rather than a ~~GUI~~, I want to make the user's avatar (the box, at the moment) move according to swipes (or as some libraries call them, "drags") upon the screen. In the [previous page](./no-gui) I mentioned these inputs, and also detailed why I had made the decisions for why and what they do:

- Swipe up ⬆️ moves forward (away from user) 
- Swipe right ➡️ turns right
- Swipe left ⬅️ turns left
- Swipe down ⬇️ moves back (towards user)

I'm going to go ahead and burn an afternoon trying to accomplish this as well as listen to some of my Coil cassettes I bought from [Ned's Records](http://www.neds-records.com/) in Tokyo, Japan.


#### Where to start?

There are two major components to this task, which at the get-go don't necessarily appear to take priority in implementation:

1. Detect a swipe in any given direction has occurred, decide the most appropriate event (bottom to top "up" or vice versa "down", or left to right "right" or vice versa "left"), and acknowledge (through some feedback) that it has occurred.

2. Translate or rotate the user avatar and camera.

The two will connect in such a way:

- When the user swipes either up or down, detect if the avatar is first looking in that direction, ie up is looking away from the user and down is looking towards the user, and if not then the event acts as rotating the avatar 180deg around the y axis, while camera stays put. If the avatar has already rotated, then the swipe counts as moving "one unit" and we translate the avatar and camera either positively or negatively along the x or z axis depending on the vertical alignment of the screen to the world coordinate plane. That is, if the axis running from the top of the screen to the bottom is z, and if the axis moves in a positive direction from top to bottom, then a swipe from top to bottom while the avatar is already looking towards the user (per the initial check) while translate the avatar and camera one unit positively along the z axis.
- When the user swipes either left or right, we rotate the avatar and camera in the direction of the swipe, according to the "origin" of the two objects. Basically, there is a shared central point for the avatar and camera. The avatar always stands upon this location, looking up or down the vertical axis (per the previous discussion). The camera always remains translated at a fixed height and distance from this point but is also rotated to always look directly at this point, both regardless of where the avatar is facing. As we swipe, we are basically turning this central point's axis alignment in the direction of the swipe, such that if the positive z-axis of the central point runs along the global positive z-axis then if the user swipes right, we rotate the central point upon the y axis in an anti-clockwise direction, such that the central point's positive z-axis now runs along the global positive x-axis. Because the avatar and and camera are fixed within this central point, they too will move accordingly. The best way to think about it is: 
    - Imagine this central point as being a kind of "harness" shaped like a cylinder. The bottom circle of the cylinder lays flat upon our "world" plane, at the plane's y axis coordinate "0", with it's centre at any given x,z coordinate. The top circle is at a height y, which is the height we give to the camera. The radius of these circles is then the distance from the center of the cylinder that we place the camera. Although the camera is at the location of the outer circumference of the top circle, it is told to "look at" the coordinates of the center of the bottom circle. It is at this coordinate that we also place our avatar. Both the avatar and camera are fixed at their locations within the cylinder. At this stage, the camera will never move independently, however the avatar will rotate 180deg around it's own y axis (which happens to be the y axis of the cylinder and the global y axis) according to the previous discussion, not affecting the cylinder or camera.
    - If we swipe left or right, it is the equivalent of physically grasping this cylinder and rotating it upon it's y axis either clockwise "right" or anti-clockwise "left". This means if we rotate it right, the "fixed" position of the avatar in the center is rotated (as it's origin is x = 0, y = 0 and z = 0 according to the cylinder's coordinate plane) and the camera is translated around the center point (as it is at a fixed point on the cylinder's top circle rim, where either x or z equals the radius of the cylinder's circles and y = the cylinder height).
    - Because we are envisioning the positions of user's avatars according to a square grid-like map, a left or right swipe will rotate the cylinder around it's y axis by 90degs. As such, the cylinder metaphor is just as valid as a rectangular prism, but discussing clock-wise circular rotations is, in my mind, easier to visualise than a rectangle and much more comfortable to imagine physically "grasping."
    
It is clear from the above that what is being suggested is to subordinate the camera and box (avatar) nodes to an empty node. I'm not sure if this is "best practice" or not, but for our intents and purposes it is the easiest to understand for now.

Setting up the new "avatar harness" node as a parent to the camera and avatar seems to look fine. To test the rotation, I want to use that rotation action provided by the example code to see if when I rotate the harness (according to it's position in the world) the camera and avatar also rotate according (but in their fixed positions according to the harness). I should basically see the plane spinning underneath the box, while the box shouldn't move according to the camera's view.

`avatarHarness.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))`

This is the adapted code, which says: on the harness node, loop this action forever "rotate around the y axis ~115deg in 1 second."

That worked according to what I assumed above, additionally, something I didn't think of at the time is that the lighting reflected by the box also changes as they remain stationary according to the scene, so we know for sure that nothing other than the harness and it's children are spinning. Another point is that, the position I've used for the camera, x = 0, y = 10, z = 5, has revealed that according to my material element positions, the color green appears on the "front" face of the box and this appears to be what initially appears to face the camera. This will be able to help us when setting up the forward/back direction of the avatar. One final point, but probably soon to be made redundant is that with the example tap event handler and camera movement controls on I can essentially get the camera to leave it's fixed position and focus while the box continues to spin, which I guess means that the camera is either being repeatedly transformed during this time or it becomes subordinated to the scene's root node. In any case, tapping the box seems to return it to its original state, but I can't verify if it's the actual state or relative to the box. Because I'm going to change the behaviour here, this will basically disappear.


#### Strapped in and ready for action 🤨

Now we are in our harness and know that we rotate with the harness, we just want to also verify we can translate with the harness before moving onto implementing the two actions: translate +/- one unit along the vertical axis and rotate around the harness origin by +/- 90degs.

I started with three actions I wanted to perform, the first is to wait for a short period, the second is to move a short distance (slowly), wait again, then rotate 90deg.

```swift
let moveAlongZ = SCNAction.move(by: SCNVector3(x: 0, y: 0, z: 10), duration: 5)
let delay = SCNAction.wait(duration: 5)
let turnRadians = 90 / 180 * CGFloat.pi
let turnLeft = SCNAction.rotate(by: turnRadians, around: SCNVector3(x: 0, y: 1, z: 0), duration: 5)
```

I wasn't sure how to chain actions together and originally went for this code:

```swift
avatarHarness.runAction(delay, completionHandler: {() -> Void in
    avatarHarness.runAction(moveAlongZ)
})
```

But the second action never seemed to run, even though other code in the same block would run. So, after finding [this on SO](https://stackoverflow.com/a/39196479), I found `SCNAction` also had the sequence command, which worked a charm:

```swift
avatarHarness.runAction(SCNAction.sequence([delay, moveAlongZ, delay, turnLeft]))
```

I'm going to try and record this and make a gif to demonstrate. Fortunately, someone has also wondered about [this](https://stackoverflow.com/questions/20078641/how-do-developers-produce-ios-simulator-animated-gifs) and also [this info about conversion helped](https://superuser.com/questions/556029/how-do-i-convert-a-video-to-gif-using-ffmpeg-with-reasonable-quality). The result being:

![movingBlock1]({{ "./assets/movingBlock1.gif" | absolute_url}})


#### My First Refactor Step

The next step is to place these different actions in functions which can be called by either tests or by user input (swipes). Eventually, we will refactor this to have everything related to the user/avatar in it's own class so that we don't clog up the view controller with unrelated code.

...

While cleaning up the code and adding the functions, I realised it would be simpler just to go ahead and create the Harness class, extending it from `SCNNode`. To manage the direction the box moves, in regards to axis and polarity, I created a struct with two properties `moveAxis` (a string, either "Z" or "X") to store the axis and `upDirection` (a string, either "+" or "-") to indicate the polarity of the forward direction. Of course, there are plenty of "clever" ways one could use to manage this data, but for this project I would like to make things quite obvious and simple (at least for my own sake.) This state is currently the only "property" of the Harness subclass. The actions or "methods" use this state to either alter it when the harness rotates or dictate the direction when the harness translates. The state is checked in a switch statement by concatenating the two strings and performing some task upon a match.

Something I noticed once I began playing with this new input method was that I misspoke earlier when I said the way I will implement it will mean the left and right swipes move against the visual movement of the world under the avatar. This is correct if I perform the swipe at the top of the screen, however at the bottom of the screen the world appears to "spin" in the direction of the swipe, which is fine.

When implementing the gesture recogniser for the `SVNView` the class to handle the swipe `UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))` seems to take this "selector" thing for the action. I've seen the selector before and it appears to require me to add some `@objc` label to my functions. I will look into this some other time. In any case, it was again helpful to have the example code because this hinted at how the gesture recognisers would be implemented.

Swipes can also detect multiple touches and I think some other things related to precision and distance. I'm not too fussed about this for now as the input I have seems to be fine and works as desired. Other than the input itself, the only thing that might change over time is the timing of the actions and the distance for the movements, depending on the timing and animation of the avatar. The movement then may affect how we position other entities in the world and how they relate (positionally) to one another.


#### Side note

I've been listening to my noise cassettes throughout most of this session. Many of them from "Melbourne, Australia"-based label Trapdoor Tapes. However at the moment I'm listening to a tape by Vulture Queen called Black Ritual Noise ([bandcamp](https://falsexidolrecords.bandcamp.com/album/black-ritual-noise)). There are some riffs in here that sound like they come straight out of Worship's Last Tape Before Doomsday ([discogs](https://www.discogs.com/Worship-Last-Tape-Before-Doomsday/master/22032)), which is pretty cool. I'm wondering if I should go for a similar sound for the soundtrack in this game thing. I guess I'll know closer to when the gameplay, story and art is fleshed out, but I'm digging it. Noise is great 🎧


#### Inputted

With the movement and input now successfully completed, the next thing I've noticed is how boring it is to look at the multicolored box and the lame grey environment. Therefore, before I attempt to do the avatar "which way are you facing" check, and rotate it accordingly when the input says so, I want to get some kind of fascinating animated creature avatar. I also need to maybe turn the world "plane" into some kind of weird environment. In line with this project, I'm not going to put too much thought into it but I do need something original and interesting to keep it engaging. poop 💩

[Home](./)