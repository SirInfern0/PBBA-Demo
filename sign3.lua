sign3 = {}
sign3.__index = sign3
signs3 = {}
require("player")

function sign3.new(x,y)
    local instance = setmetatable({}, sign3)
    instance.x = x
    instance.y = y
    instance.width = 16
    instance.height = 16
    instance.signbubble3 = false
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(signs3, instance)
end

function sign3:update(dt)

end

function sign3:draw()
    for i,instance in ipairs(signs3) do
        if instance.signbubble3 == true then
            love.graphics.rectangle("fill", self.x - 24, self.y - 48, 48, 32)
            local black = {0,0,0}
            self.font = love.graphics.newFont(7)
            self.font:setFilter( "nearest", "nearest" )
            love.graphics.setFont(self.font)
            love.graphics.print({black, "W or up arrow"}, self.x - 24, self.y - 48)
            love.graphics.print({black, "keys to jump."}, self.x - 24, self.y - 40)
        end
    end
end

function sign3.updateAll(dt)
    for i,instance in ipairs(signs3) do
        instance:update(dt)
    end
end

function sign3.drawAll()
    for i,instance in ipairs(signs3) do
        instance:draw()
    end
end
function sign3:beginContact(a, b, collision)
    for i,instance in ipairs(signs3) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            instance.signbubble3 = true
            return true
        end
    end
end
function sign3:endContact(a, b, collision)
    for i,instance in ipairs(signs3) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            instance.signbubble3 = false
        end
    end
end