--Detects when a player is in reach of a ladder and lets them grab the ladder and climb up and down
--through platforms.
ladder = {}
ladder.__index = ladder
ladders = {}
require("player")
require("onewayplatform")

function ladder.new(x,y,height)
    local instance = setmetatable({}, ladder)
    instance.x = x
    instance.y = y
    instance.width = 16
    instance.height = height
    instance.touching = false
    instance.holding = false
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    table.insert(ladders, instance)
end

function ladder:update(dt)
    ladder:climb()
    ladder:hold()
end

function ladder.updateAll(dt)
    for i,instance in ipairs(ladders) do
        instance:update(dt)
    end
end

function ladder:hold(key)
    for i,instance in ipairs(ladders) do
        if Player.x > instance.x - instance.width / 2 and Player.x < instance.x + instance.width / 2 then
            if instance.touching == true then
                if (key == "w" or key == "up") then
                    instance.holding = true
                end
            end
        end
    end
end

function ladder:climb()
    for i,instance in ipairs(ladders) do
        if instance.holding == true then
            Player.x = instance.x
            Player.state = "climb"
            Player.frames = 4
            if love.keyboard.isDown("w", "up") then
                if Player.y + Player.height / 2 <= instance.y - (instance.height / 2 + 16) then
                    Player.y = instance.y - (instance.height / 2 + 16)
                else
                    Player.yVel = -50
                end
            elseif love.keyboard.isDown("s", "down") then
                Player.yVel = 50
            elseif love.keyboard.isDown("a", "left") or love.keyboard.isDown("d", "right") then
                instance.holding = false
            else
                Player.yVel = 0
                Player.state = "idleclimb"
                Player.frames = 1
            end
        end
    end
end

function ladder:beginContact(a, b, collision)
    for i,instance in ipairs(ladders) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if  a == Player.physics.fixture or b == Player.physics.fixture then
                instance.touching = true
                return true
            end
        end
    end
end
function ladder:endContact(a, b, collision)
    for i,instance in ipairs(ladders) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            instance.touching = false
            instance.holding = false
            collision:setEnabled(true)
        end
    end
end
function ladder:preSolve(a, b, collision)
    local nx, ny = collision:getNormal()
    for i,instance in ipairs(ladders) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            self:hold(collision)
            collision:setEnabled(false)
        elseif instance.holding == true and Player.y + Player.height / 2 < instance.y + instance.height / 2 then
            collision:setEnabled(false)
        end
    end
end

