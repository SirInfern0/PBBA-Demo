sign2 = {}
sign2.__index = sign2
signs2 = {}
require("player")

function sign2.new(x,y)
    local instance = setmetatable({}, sign2)
    instance.x = x
    instance.y = y
    instance.width = 16
    instance.height = 16
    instance.signbubble2 = false
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(signs2, instance)
end

function sign2:update(dt)

end

function sign2:draw()
    for i,instance in ipairs(signs2) do
        if instance.signbubble2 == true then
            love.graphics.rectangle("fill", self.x - 24, self.y - 48, 48, 32)
            local black = {0,0,0}
            self.font = love.graphics.newFont(7)
            self.font:setFilter( "nearest", "nearest" )
            love.graphics.setFont(self.font)
            love.graphics.print({black, "W or up"}, self.x - 24, self.y - 48)
            love.graphics.print({black, "arrow keys to"}, self.x - 24, self.y - 40)
            love.graphics.print({black, "climb ladders."}, self.x - 24, self.y - 32)
        end
    end
end

function sign2.updateAll(dt)
    for i,instance in ipairs(signs2) do
        instance:update(dt)
    end
end

function sign2.drawAll()
    for i,instance in ipairs(signs2) do
        instance:draw()
    end
end
function sign2:beginContact(a, b, collision)
    for i,instance in ipairs(signs2) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            instance.signbubble2 = true
            return true
        end
    end
end
function sign2:endContact(a, b, collision)
    for i,instance in ipairs(signs2) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            instance.signbubble2 = false
        end
    end
end