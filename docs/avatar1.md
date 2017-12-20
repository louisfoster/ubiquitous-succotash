### Ma dude

The first step to creating the game/product/app thing is some form of interaction, this way I know what the possibilities are for driving the game and what kind of "spaces" I have to work with (if the player's thumb is constantly blocking important text, then either the thumb or the text has to go!) Because this is starting out as an iOS app with no peripherals, simple swipe gestures to move an avatar (with the avatar in a "third person" view) seems to be fine and immediately puts the "look" of the avatar into focus. I have been testing it only in portrait mode, right way up (and I intend to lock it this way), so most of this input will likely occur with one hand underneath or to the side of the avatar.

In the attempt to put together video of me interacting with the app and showing where we are so far, I have used the mac standard (as of 2017) "Photo Booth" to do my recording, although I probably could've just used quicktime, because I ended up opening it in QT for editing (I don't use iMovie). However now I want to crop the video, but I like teh CLI so I want to use `ffmpeg` just like is discussed [here](https://video.stackexchange.com/questions/4563/how-can-i-crop-a-video-with-ffmpeg). However I don't seem to have ffplay in order to test this, so I found [this blog post](http://www.renevolution.com/ffmpeg/2013/03/16/how-to-install-ffmpeg-on-mac-os-x.html) showing me how to install it. I needed to run `upgrade` rather than install though because I already had it. While I wait, I'm going to take a look around [ShaderToy](https://www.shadertoy.com). [Cool stuff](https://www.shadertoy.com/view/4sByWz).

On another note, I was thinking about the nature of past lives. If we have past lives, does that mean in any case (in regards to reincarnation) we pop up again only in a linear future? By the repetitive, cyclical nature of things I would've thought that perhaps it isn't necessarily a requirement that we look at things in a traditional "past and future" calendar sense, but as a "a some stage, I had this other life." Again, past lives being hypothetical anyway. But how would it supposedly work, if it could be mathematically modeled? Would my existence as some conscious being be dictated by some larger structure that places me in that being? Then what of free will? Free will can't be sacrificed just to say "structues can't be autonomous." But instead, there is always free will, but every action pulls like strings at the model, changing those things that don't have such free will, causing the phenomena of randomness, but a kind of interconnected and self-correcting randomness. Like, I can't just decided to hold my breath and expect at a moment the Universe will collapse, but perhaps the greater the need for adjustment, the more self-correct and randomness takes place. So spontaneity of mind brings about spontaneity of reality? Perhaps it would only be clear to those who are spontaneous? Or maybe the spontaneity has more obvious cause to those people, whereas seems "random" to others? Back to past lives, if we then are part of this self-correcting structure, where we can be anything at any "time" then perhaps it is a co-ordinated structure. So the consciousness, with free will, exists and it is me, but the me is a greater unified complex structure so the exhibition of free will in actually contained within the structure and I am part of the action, so in a sense it is one entity with multiple consciousnesses.

Perhaps I can include this idea into the game somehow. If we are all the same thing, but all with separate avatars. At any moment we may exist as another avatar (so long as others exist in other avatars.) As more of us live through these avatars, we could develop a collection of internal dialogue. Like the time of the unified being spent paying attention to the experience of an individual, the monologue grows and we may come to pass and be recreated as time turns over but the story continues, until the individual comes to realise it's own nature within the experience of it's own narrative. Does that make sense? I guess what I mean is, the "you" that "is" always has the opportunity to understand the experience of that one self. As it will be repeated consistently, and the life itself may change, but there is always a high probability of consistent events due to context, but there is always the choice to really observe and maybe glean something from and as the individual. There is no need to carry "past lives" from one to another, or be aware of the "collective" of all consciousness, instead just knowing of there diversity, unification and pattern of time and consciousness in order to engage with the self that is.

That got a little jibbery and rambly towards the end, and it's all finished install- UGH! `Warning: ffmpeg: --with-ffplay was deprecated; using --with-sdl2 instead!` DAMN! Alright, let's see... `brew reinstall --with-sdl2 ffmpeg` according to [this](https://github.com/Homebrew/homebrew-core/issues/7630). Ugh, more downloading and installing, so borrrrrring. All just so I could show off some really short UI video. In the mean time I've been listening to some noise album compilation called "Sonic Protest 2012." Interesting stuff. While I wait, I'm going to talk about creating this character and just pop in the gif when I finally get it.


#### Create the damn thing

On my test screen, the avatar appears to be around 100mm. Playing around with different heights and distances of the camera from the avatar shows completely different aspects of how we contextualise the scene. Do we have a top down "controlled" effect, where our focus is solely on the avatar? Or, do we bring the angle down slightly so we can see a little beyond the avatar? I do like the latter, but also choosing how much of the "beyond" we want to expose our senses to and how close to the avatar we want to be and fill the screen I think comes down to gameplay and how engaging the avatar itself is. So, for now, I think it would be best to imagine the avatar will be generally somewhere between 100mm-200mm on a standard iPhone screen, so we want it to look pretty detailed and fascinating at this level.

Everyone has their own method to coming up with a design for a character. I think the fastest method for this situation is to do some sketches and pick something that I like and then model it with as few polys as possible. Time to do sketches!

...but before I disappear to draw:


#### UI Demo

![uinput1]({{ "./assets/uinput1.gif" | absolute_url}})


#### Sketches

While putting together some sketches, I was watching [this talk](https://vimeo.com/22963088) by Will Wright (creator of The Sims). He paraphrases Sid Meier (creator of Civilisation) in saying, "give the player a rich set of decisions" in the context of provided gameplay with a large amount of considerations that collapse into this decision set. That's just one take of game design, but interesting to note nonetheless.

The sketches I completed could be more dense and complete, more fleshed out and much more exploratory. However, I want to keep the _swift_ momentum of this project going, so I kinda used my own biases with fascinating character design to hone in on something that was the right combination of weird and funny without being totally creepy or gross. I really like to draw quadrupeds and strange faces. Also incorrect anatomy is also cool. I've kept anything that could be considered too risque out of the design due to this project's possible end goal being an attempted release to the app store (why not?) and I want to avoid rejection by Apple's strict standards.

Side note, I also came across [this](http://preshing.com/20171218/how-to-write-your-own-cpp-game-engine/) today on hacker news. Engines, fun, but why C++? Maybe it discusses it somewhere in the article, I didn't really read all of it 👽 ah! aliens!

![uinput1]({{ "./assets/sketches1.jpg" | absolute_url}})

As you can see, my style is somewhat demented. There isn't so much depth here beyond something that looks fascinating. Maybe big eyes is cool for art because it can be more expressive, and I tend to fall slightly on the realistic side of cartooning (like a close up in Ren and Stimpy) and also tend to avoid pointless detail for low poly modeling and texturing (flatter noses, no ears or real muscle or bone definition and no protruding hair) as well as trying to move from something cliched to something totally absurd then scaling it back until I feel comfortable. Also finding a design I can draw repeatedly with a formula of repeatable lines is great for transforming a 2D idea into something 3D and more life-like.

Alright, maybe there is some preference and technique in the sketches and decision making. However, the main thing missing is time for developing the idea further. Back in Industrial Design school, we were expected to put out 10s to about a hundred sketches a day (and prove it) and then whittle it down to maybe 30 professional-quality presentation sketch boards (these would require different angles, context, colouring, annotations, scales, decomposition and our own personal header/name box.) I was so sick of the whole thing after doing it for a year straight (the preceding three years were a variety of classes, so the workload wasn't always that intense for subject) that I threw most of my stuff away. However carrying around thousands of sketches wasn't logistically sound and it's why I now do most of my sketches in small journals or using a tablet and some graphics software.

Talking about Industrial Design, time for some 3D! I will be using [Blender](https://www.blender.org/).


#### Blendered

Blender (contradictory to what most people say) is pretty easy to use and learn. There's heaps of cool features and countless only tutorials (free) that are just a search away. There are obviously some key principles to learn just like any other piece of software and domain of knowledge, but it's all relatively easy to pick up and it's all quite practical so you can do as you learn, which is called kinesthetic learning or something.

The first step is to create half of the model in a rudimentary form, and this will then get mirrored and subdivided by a modifier. Most of the design comes from simply thinking about the best way to do something with the least amount of polygons. Here is the model so far:


![3dmodel1]({{ "./assets/3dmodel1.png" | absolute_url}})


To get to this stage was fairly quick, and to me, it already looks very close to the drawing (and this is without any "guide" drawings) minus the "chest arm," which will be next in the process. I think the whole model might end up being a little over 3000 verts. This shouldn't be an issue for the GPU at all. Once we have the arm, then it is just a matter of texturing the creature (so it doesn't looks like some creepy clay model) and giving it an armature to be animated.

I also just noticed, comparing the shape of the face to the drawings, there should be more of a "concerned snarl" in the brow and eye lids, and the cheeks currently looks really skeletal rather than the rounded puffy cheek bones in the sketch. The body is super close though, barring the random left arm appendage on the sternum. The name for the creature at the moment is Pataralaxa, which I believe is Enochian for 'rock'. 



[Home](./)