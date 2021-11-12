local Enemy = {}
Enemy.__index = Enemy
local ActiveEnemies = {}
require("player")

function Enemy.new(x,y)
    local instance = setmetatable({}, Enemy)
    instance.x = x
    instance.y = 247.55
    instance.offsetY = 0
    instance.r = 0

    instance.speed = 50
    instance.xVel = instance.speed

    instance.damage = 1

    instance.state = "walk"
    
    instance.animation = {timer = 0, rate = 0.1}
    instance.animation.walk = {total = 4, current = 1, img = Enemy.walkAnim}
    instance.animation.draw = instance.animation.walk.img[1]

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic")
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape = love.physics.newRectangleShape(instance.width / 2, instance.height / 2)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(25)
    table.insert(ActiveEnemies, instance)
end

function Enemy.loadAssets()
    Enemy.walkAnim = {}
    for i=1,4 do
        Enemy.walkAnim[i] = love.graphics.newImage("assets/walk"..i..".png")
    end

    Enemy.width = Enemy.walkAnim[1]:getWidth()
    Enemy.height = Enemy.walkAnim[1]:getHeight()
end
--When the snake hits a point I designated, it will turn around
function Enemy:update(dt)
    self:syncPhysics()
    self:animate(dt)
    for i,instance in ipairs(ActiveEnemies) do
        if self.x > 470 and self.xVel > 0 then
            Enemy:flipDirection()
            return end
        if self.x < 313 and self.xVel < 0 then
            Enemy:flipDirection()
            return end
    end
end

function Enemy:flipDirection()
    for i,instance in ipairs(ActiveEnemies) do
        instance.xVel = -instance.xVel
    end
end

function Enemy:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, 0)
    
end

function Enemy:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end
end

function Enemy:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end

function Enemy:draw()
    local scaleX = 1
    if self.xVel < 0 then
        scaleX = -1
    end
    love.graphics.draw(self.animation.draw, self.x, self.y + self.offsetY, self.r,scaleX,1, self.width / 2, self.height / 2)
end

function Enemy.updateAll(dt)
    for i,instance in ipairs(ActiveEnemies) do
        instance:update(dt)
    end
end

function Enemy.drawAll()
    for i,instance in ipairs(ActiveEnemies) do
        instance:draw()
    end
end
--When the snake touches the player, it also will cause it to turn direction
function Enemy.beginContact(a, b, collision)
    for i,instance in ipairs(ActiveEnemies) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:takeDamage(instance.damage)
                Enemy:flipDirection()
            end
        end
    end
    
end

return Enemy
