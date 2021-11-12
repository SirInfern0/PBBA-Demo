sign = {}
sign.__index = sign
signs = {}
require("player")

function sign.new(x,y)
    local instance = setmetatable({}, sign)
    instance.x = x
    instance.y = y
    instance.width = 16
    instance.height = 16
    instance.signbubble = false
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(signs, instance)
end

function sign:update(dt)

end
--Signs draw a text box that provides a tutorial for the player (Same thing for the other ones)
function sign:draw()
    for i,instance in ipairs(signs) do
        if instance.signbubble == true then
            love.graphics.rectangle("fill", self.x - 24, self.y - 48, 48, 32)
            local black = {0,0,0}
            font = love.graphics.newFont(7)
            font:setFilter( "nearest", "nearest" )
            love.graphics.setFont(font)
            love.graphics.print({black, "A and D or"}, self.x - 24, self.y - 48)
            love.graphics.print({black, "left and right"}, self.x - 24, self.y - 40)
            love.graphics.print({black, "arrow keys to"}, self.x - 24, self.y - 32)
            love.graphics.print({black, "move."}, self.x - 24, self.y - 24)
        end
    end
end

function sign.updateAll(dt)
    for i,instance in ipairs(signs) do
        instance:update(dt)
    end
end

function sign.drawAll()
    for i,instance in ipairs(signs) do
        instance:draw()
    end
end
function sign:beginContact(a, b, collision)
    for i,instance in ipairs(signs) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            instance.signbubble = true
            return true
        end
    end
end
function sign:endContact(a, b, collision)
    for i,instance in ipairs(signs) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            instance.signbubble = false
        end
    end
end