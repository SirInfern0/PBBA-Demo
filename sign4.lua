sign4 = {}
sign4.__index = sign4
signs4 = {}
require("player")

function sign4.new(x,y)
    local instance = setmetatable({}, sign4)
    instance.x = x
    instance.y = y
    instance.width = 16
    instance.height = 16
    instance.signbubble4 = false
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(signs4, instance)
end

function sign4:update(dt)

end

function sign4:draw()
    for i,instance in ipairs(signs4) do
        if instance.signbubble4 == true then
            love.graphics.rectangle("fill", self.x - 24, self.y - 48, 48, 32)
            local black = {0,0,0}
            self.font = love.graphics.newFont(7)
            self.font:setFilter( "nearest", "nearest" )
            love.graphics.setFont(self.font)
            love.graphics.print({black, "Avoid the"}, self.x - 24, self.y - 48)
            love.graphics.print({black, "snake!"}, self.x - 24, self.y - 40)
        end
    end
end

function sign4.updateAll(dt)
    for i,instance in ipairs(signs4) do
        instance:update(dt)
    end
end

function sign4.drawAll()
    for i,instance in ipairs(signs4) do
        instance:draw()
    end
end
function sign4:beginContact(a, b, collision)
    for i,instance in ipairs(signs4) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            instance.signbubble4 = true
            return true
        end
    end
end
function sign4:endContact(a, b, collision)
    for i,instance in ipairs(signs4) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            instance.signbubble4 = false
        end
    end
end