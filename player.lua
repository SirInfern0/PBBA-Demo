Player = {}

function Player:load()
    --This is the starting point and size of the collision box of the player
    self.x = 40
    self.y = 231
    self.startX = self.x
    self.startY = self.y
    self.width = 16
    self.height = 16

    --Variables to apply some math to make smooth movement
    self.xVel = 0
    self.yVel = 0
    self.maxSpeed = 100
    self.acceleration = 4000
    self.friction = 3500

    --Jumping variables
    self.gravity = 1500
    self.jumpAmount = -350
    self.hasDoubleJump = true

    --Item/Health Variables
    self.pb = 0
    self.health = {current = 3, max = 3}
    self.alive = true

    --Animation variables
    self.direction = "right"
    self.state = "idle"
    self.frames = 0
    self.color = {
        red = 1,
        green = 1,
        blue = 1,
        speed = 3,
    }

    self.animation = self:newAnimation(love.graphics.newImage("assets/characters.png"), 32, 32, 1)

    --This variable helps to see whether the player is touching the ground or not.
    self.grounded = false

    --This applies the physics variables to the player within the playable world
    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
end

--Animations taken from a png containing multiple sprites.
function Player:newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.idle = {};
    animation.run = {};
    animation.jump = {};
    animation.fall = {};
    animation.climb = {};
    animation.idleclimb = {};

    --Idle animation
    for y = 0, image:getHeight() - height, height do
        for x = 64, image:getWidth() - width, 64 do
            table.insert(animation.idle, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end
    --Run animation
    for y = 0, image:getHeight() - height, height do
        for x = 448, image:getWidth() - width, width do
            table.insert(animation.run, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end
    --Jump animation
    for y = 0, image:getHeight() - height, height do
        for x = 160, image:getWidth() - width, 32 do
            table.insert(animation.jump, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end
    --Fall animation
    for y = 0, image:getHeight() - height, height do
        for x = 192, image:getWidth() - width, 32 do
            table.insert(animation.fall, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end
    --Climb animation
    for y = 0, image:getHeight() - height, height do
        for x = 576, image:getWidth() - width, width do
            table.insert(animation.climb, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end
    --IdleClimb animation
    for y = 0, image:getHeight() - height, height do
        for x = 576, image:getWidth() - width, width do
            table.insert(animation.idleclimb, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end

function Player:takeDamage(amount)
    self:tintRed()
    if self.health.current - amount > 0 then
        self.health.current = self.health.current - amount
    else
        self.health.current = 0
        self:die()
    end
end

function Player:die()
    self.alive = false
end

function Player:respawn()
    if not self.alive then
        self.physics.body:setPosition(self.startX, self.startY)
        self.health.current = self.health.max
        self.alive = true
    end
end

function Player:tintRed()
    self.color.green = 0
    self.color.blue = 0
end

function Player:incrementPB()
    self.pb = self.pb + 1
end

--Updates the world and it's various moving and animated parts
function Player:update(dt)
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
    self:setDirection()
    self:setState()
    self:respawn()
    self:unTint(dt)

    self.animation.currentTime = self.animation.currentTime + dt
    if self.animation.currentTime >= self.animation.duration then
        self.animation.currentTime = self.animation.currentTime - self.animation.duration
    end
end

function Player:unTint(dt)
    self.color.red = math.min(self.color.red + self.color.speed * dt, 1)
    self.color.green = math.min(self.color.green + self.color.speed * dt, 1)
    self.color.blue = math.min(self.color.blue + self.color.speed * dt, 1)
end

--This keeps track of the state the player is in to aid in keeping track of animations
function Player:setState()
    if self.yVel < 0 and not self.grounded then
        self.state = "jump"
        self.frames = 1
    elseif self.yVel > 0 and not self.grounded then
        self.state = "fall"
        self.frames = 1
    elseif self.xVel == 0 then
        self.state = "idle"
        self.frames = 2
    else
        self.state = "run"
        self.frames = 4
    end
end

--Determines the direction of the player
function Player:setDirection()
    if self.xVel < 0 then
        self.direction = "left"
    elseif self.xVel > 0 then
        self.direction = "right"
    end
end

--Gravity function
function Player:applyGravity(dt)
    if not self.grounded then
        self.yVel = self.yVel + self.gravity * dt
    end
end    

--Player movement on the x-axis
function Player:move(dt)
    if love.keyboard.isDown("d", "right") then
        self.xVel = math.min(self.xVel + self.acceleration * dt, self.maxSpeed)
    elseif love.keyboard.isDown("a", "left") then 
        self.xVel = math.max(self.xVel - self.acceleration * dt, -self.maxSpeed)
    else
        self:applyFriction(dt)
    end
end

--Allows for better movement via "friction"
function Player:applyFriction(dt)
    if self.xVel > 0 then
        self.xVel = math.max(self.xVel - self.friction * dt, 0)
    elseif self.xVel < 0 then
        self.xVel = math.min(self.xVel + self.friction * dt, 0)
    end
end    

--Set's physics to the player
function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

--Physics collision when the player first touches the collision objects set in Tiled.
function Player:beginContact(a, b, collision)
    if self.grounded == true then return end
    local nx, ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land(collision)
        end
    end
end


--When the player lands changes variables
function Player:land(collision)
    self.currentGroundCollision = collision
    self.yVel = 0
    self.grounded = true
end

--The jump function
function Player:jump(key)
    if (key == "w" or key == "up") and self.grounded then
        self.yVel = self.jumpAmount
        self.grounded = false
    end
end

--When the player stops touching a collision object
function Player:endContact(a, b, collision)
    if a == self.physics.fixture or b == self.physics.fixture then
        if self.currentGroundCollision == collision then
            self.grounded = false
        end
    end
end

--This function handles drawing the animation to the player
function Player:draw()
    local scaleX = 1

    if self.direction == "left" then
        scaleX = -1
    end    
    local spriteNum = math.floor(self.animation.currentTime / self.animation.duration * self.frames) + 1
    love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
    love.graphics.draw(self.animation.spriteSheet, self.animation[self.state][spriteNum], self.x, self.y, 0, scaleX, 1, 16, 23.5)
    love.graphics.setColor(1,1,1,1)
end