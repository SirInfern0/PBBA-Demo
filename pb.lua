--Creates PB that can be "collected" so that the object is destroyed and increments the amount of
-- PB that you have.
pb = {}
pb.__index = pb
activepb = {}
require("player")

function pb.new(x,y)
    local instance = setmetatable({}, pb)
    instance.x = x
    instance.y = y
    instance.img1 = love.graphics.newImage("assets/1.png")
    instance.width = instance.img1:getWidth() * 0.04
    instance.height = instance.img1:getHeight() * 0.053
    instance.toBeRemoved = false
    pb:loadAssets()
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(activepb, instance)
end

function pb:remove()
    for i,instance in ipairs(activepb) do
        if instance == self then
            Player:incrementPB()
            self.physics.body:destroy()
            table.remove(activepb, i)
        end
    end
end

function pb:update(dt)
    self:animate(dt)
    self:checkRemoved()
end

function pb:checkRemoved()
    if self.toBeRemoved then
        self:remove()
    end
end

function pb:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end
end

function pb:setNewFrame()
    local anim = self.animation.spin
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end

function pb:loadAssets()
    self.animation = {timer = 0, rate = 1.5}
    self.animation.spin = {total = 3, current = 1, img = {}}
    for i=1, self.animation.spin.total do
        self.animation.spin.img[i] = love.graphics.newImage("assets/"..i..".png")
    end
    self.animation.draw = self.animation.spin.img[1]
    self.animation.width = self.animation.draw:getWidth()
    self.animation.width = self.animation.draw:getHeight()
end

function pb:draw()
    love.graphics.draw(self.animation.draw, self.x - 16, self.y - 16, 0,0.08,0.08, self.width * 0.08, self.height * 0.08)
end

function pb.updateAll(dt)
    for i,instance in ipairs(activepb) do
        instance:update(dt)
    end
end

function pb.drawAll()
    for i,instance in ipairs(activepb) do
        instance:draw()
    end
end
function pb:beginContact(a, b, collision)
    for i,instance in ipairs(activepb) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                instance.toBeRemoved = true
                return true
            end
        end
    end
end
