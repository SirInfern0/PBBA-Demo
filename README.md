# Peanut Butter Baby Adventure
#### Video Demo:  <https://youtu.be/lHryq42DDEE>
#### Description:
Hello and welcome to my cs50 project called Peanut Butter Baby Adventure (PBBA for short). PBBA is a game I made using the love2d application written in the language of lua suggested by you guys in the final project page. The games hosts many features that can hopefully be pretty easy to explain. The game is a platformer and is a one level screen demo with the goal of having to gather all 5 of the peanutbutter jars to acquire the win condition which draws an image of hopefully a familiar face from the internet. The choice came from how the sprite I downloaded looked familiar to the peanut butter baby, credit goes to Buch and can be found here http://blog-buch.rhcloud.com. I can also credit my girlfriend and another friend for drawing me peanut butter sprites so thanks to them as well for supporting me.

So to start off explaining my project I should start with main.lua which as you may know, handles loading the game and all the assets and the other files associated with the game. In the love.load function, I load my map in using a file called simple tiled implementation (STI for short) which just allows me to load tile maps from another application called Tiled where I actually drew my level. STI simply maps out each tile on the map which are 16 by 16 pixels and adds types and tags associated with each tile. Whats nice about this is it handles multiple layers from tiled which was essential in a lot of things related to my game like the physics, collisions and my one way platforms. Just after that is the love.update function that handles updating things on delta time speed which just refers to the time it took from the last frame to draw to the next frame as you know computers run from frame to frame. The love.draw is pretty simple and it just handles drawing everything you see on the screen like the sprite animations, the background, and the stage itself. A little note on drawing. love.keypressed function handles when you press down a key which is pretty self explanatory. The Contact functions is where I spent the majority of time and frustration with and it handles how and when physical objects should behave with other physical objects. I'll explain each one as I get through the files. In the spawnObjects function is where I iterate over certain object layers and types in my Tiled map to load the physical body and in some cases an animation similar to what I did in my Player file. I have a death function that handles when you fall off the bottom of the screen, it will send you back to the origin point in the game. Lastly I set a winCondition function that handles when you collect all of the peanut butter jars in the game and draws the winning screen image of the peanut butter baby.

My camera.lua file is what allows for the screen to move with the player adjusting for screen width and height and moves everything on the screen to follow the player. Gui.lua file is just taking the information about how much health or peanut butter jars the player has at that moment and lets you know up top via the classic 3 heart and peanut butter counter. The conf.lua file allows me to have command prompt so that I can debug my program

Next we head over to the player.lua file which handles eveything related to the character you play. You've got a bunch of variables determining a lot of his attributes that will effect the way the player interacts and moves around the world. Set to the player that is important is a few things but notably the "self.physics" variable all have to do with position, size, and what kind of physics object it is. The player has been set to "dynamic" which means they can affect and can be affected by other forces in the game. The other physic body choices can be "static" which cannot be moved and "kinematic" which can only move dynamic bodies. I set the player body to have 16x32 pixel rectangular body. This makes for easy collision detection since everything is based off of squares. The newAnimation function will be handling reading into my asset folder and reading the specific images I need to make the animation I want. This was my first struggle where I had to figure out how to read through the images properly but easily understood after awhile that I was only iterating over the pixels in the image which made it really easy. Player:setState will be handling when the player is moving or interacting with the world and changing the animation accordingly. The Player:takeDamage function handles when you get touched/hurt by the enemy in the game which is a snake. The player will take 1 damage and glow red to indicate being hurt to the user from the tintRed function call. Player:unTint will return the player back to original color. Player:die function in tandem with the Player:respawn function let's my game know when to reset my player back to the origin because they have "died" and need to reset. Player:update is called in the love.update function on the main.lua file and it does the same thing of updating functions. I have some math in there to help with animation timing. Player:applyGravity is just how it sounds where I am applying positive y Velocity with my gravity variable which means to go down because it reads top to bottom. Player:move is just that, handling when a player wants to move left or right pressing either a or d; left or right arrow keys. Player:applyFriction is a cool function which makes moving the player feel a little more nice or natural and not so glidy. For my beginContact function I deal with the ability to know when the player is above an object or in this case the ground, and if the player is we call the land function which helps to stop applying y Velocity on the player so that can he still move left or right because without it, the y velocity would be too great for him to move. Player:jump is just when w or up arrow key is pressed and gives negative y velocity shooting the character up just to apply gravity and bring them back down. Player:endContact is going to be useful when the player walks off of a ground block because self.grounded becomes false and allow for gravity to be applied on the player again. Lastly Player:draw is where the magic happens for the animation plugging in all variables for time, frames and different images to make for sweet animation and the scaleX variable handles when the player turns around, which just flips the image.

Onewayplatform.lua is where I spent the majority of my time discovering what I can do with the physics contacts. My problem here was simple but suprisingly hard to find a solution to. At the top I have a function that makes a new platform according to the information I tell it to put for itself and makes a meta table for that one instance of a platform. In main.lua I have a function that uses this *.new function and takes the information for the x and y coordinates and in some cases the width and height of the object from my map made from Tiled. It will then apply physic fixtures to those points so that my player can interact with it. preSolve function is what allows you to jump through platforms and then land on top with just simply disabling and then reenabling collision. So as this may cause certain problems for future additions to the game, like if there were other objects in the world with physics because they would simply fall through the ground. It was an easy solution for me for what I was trying to accomplish.

From here on out the rest of my files do a lot of the same, utilizing the *.new function to get physics fixtures for objects I've already laid out on my Tiled map. However there are some key differences to them so I will go over those. For the ladder.lua file I had to come up with a way to climb through platforms at the top of the ladder but not the bottom. This was a struggle I powered through eventually used something similar to my one way platforms. I simply made a state for when the character was climbing and as long as he had that state and was on the upper part of the ladder and disabled collision. I tested for this by finding the lowest part of the sprite at that moment and made sure it was between two y coordinates, one being above the platform, and another being below. To make sure the character doesn't fall through the platform at the bottom of the ladder I check for the same thing and just made sure to enable collision for that instance. The pb.lua file or "peanut butter" file is the one that handles making my spinning peanut bars and allows you to connect them. I did something a little different for the animation though, for this one I made different images and just iterated over them. It was a more simple process that I figured out how to do after having already made my animations for my player sprite. To make sure the sprite disappears I simply just erase the table information for that peanut butter when the beginContact function is called and that is allso where I increment the peanut butter jar amount. All of the sign files are identical except for what the text box that I draw displays. I set the signs to sensors which just means that when I touch them, they aren't affected but still give a contact, and off of that contact I tell it draw a white box with some text as a sort of tutorial for the player. Last but not least I have my enemy.lua file where I have created an obstacle for the player to get around, hopefully being the only problem the player has to solve, jumping over the snake to get to the peanut butter on top of the mountain I made. When touched I will increment down the players health. It uses the same animation code I use for my peanut butter jars. I could have set some gravity to my snake but due the nature of my code he would have fell through the ground. The problem being that all collision is shut off when the player climbs ladders causing the snake to also fall through the ground. My solution to this problem was to simply remove any gravity to the snake and just make sure he was going in between 2 points that I set. As a note to that, just like the palyer, when the enemy/snake goes the opposite way I make sure his x scale is negative which flips the image.