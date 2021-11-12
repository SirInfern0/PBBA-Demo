love.graphics.setDefaultFilter("nearest", "nearest")
local STI = require("sti")
local Platform = require("onewayplatform")
local Ladder = require("ladder")
require("player")
require("pb")
require("gui")
require("sign")
require("sign2")
require("sign3")
require("sign4")
local Enemy = require("enemy")
Camera = require("camera")


--love.load just loads in images, physics, map, etc..., in my case I've decided to load in a map from another application called Tiled
function love.load()
    love.window.setTitle( "PBBA" )
    Map = STI("map/1.lua", {"box2d"})
    World = love.physics.newWorld(0,0)
    Map:box2d_init(World)
    World:setCallbacks(beginContact, endContact, preSolve, postSolve)
    Map.layers.solid.visible = false
    Map.layers.oneway.visible = false
    Map.layers.entities.visible = false
    MapWidth = Map.layers.Base.width * 16
    MapHeight = Map.layers.Base.height * 16
    background = love.graphics.newImage("assets/background3.png")
    for i = 100,-100 do print(i) end
    GUI:load()
    Enemy.loadAssets()
    Player:load()
    spawnObjects()
end

--love.update updates the world in dt (delta time) which just means how many frames a second the game runs at
function love.update(dt)
    World:update(dt)
    Player:update(dt)
    ladder.updateAll(dt)
    pb.updateAll(dt)
    Enemy.updateAll(dt)
    GUI:update(dt)
    death()
    
    Camera:setPosition(Player.x, Player.y)
end

--love.draw handles actually printing the loading images and animations onto the love canvas
function love.draw()
    local sx = love.graphics.getWidth() / background:getWidth()
    local sy = love.graphics.getHeight() / background:getHeight()
    love.graphics.draw(background, 0, 0, 0, sx, sy) -- x: 0, y: 0, rot: 0, scale x and scale y

  
    Map:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)
    Camera:apply()
    
    Player:draw()
    Enemy.drawAll()
    sign.drawAll()
    sign2.drawAll()
    sign3.drawAll()
    sign4.drawAll()
    pb.drawAll()

    Camera:clear()
    GUI:draw()
    winCondition()
end

--Handles when a key is pressed
function love.keypressed(key)
    Player:jump(key)
    ladder:hold(key)
end    

--Called back from player.lua to handle physics collision
function beginContact(a, b, collision)
    if pb:beginContact(a, b, collision) then return end
    Enemy.beginContact(a, b, collision)
    if sign:beginContact(a, b, collision) then return end
    if sign2:beginContact(a, b, collision) then return end
    if sign3:beginContact(a, b, collision) then return end
    if sign4:beginContact(a, b, collision) then return end
    if ladder:beginContact(a, b, collision) then return end
    Player:beginContact(a, b, collision)
end
--^^^^^^
function endContact(a, b, collision)
    sign:endContact(a, b, collision)
    sign2:endContact(a, b, collision)
    sign3:endContact(a, b, collision)
    sign4:endContact(a, b, collision)
    ladder:endContact(a, b, collision)
    Player:endContact(a, b, collision)
end
--^^^^^^
function preSolve(a, b, collision)
    onewayplatform:preSolve(a, b, collision)
    ladder:preSolve(a, b, collision)
end
--Calls functions that creates physical fixtures
function spawnObjects()
    for i,v in ipairs(Map.layers.oneway.objects) do
        if v.type == "oneway" then
            onewayplatform.new(v.x + v.width / 2, v.y + v.height / 2, v.width)
        end
    end
    for i,v in ipairs(Map.layers.entities.objects) do
        if v.type == "ladder" then
            ladder.new(v.x + v.width / 2, v.y + v.height / 2, v.height)
        elseif v.type == "pb" then
            pb.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "sign" then
            sign.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "sign2" then
            sign2.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "sign3" then
            sign3.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "sign4" then
            sign4.new(v.x + v.width / 2, v.y + v.height / 2)
        elseif v.type == "enemy" then
            Enemy.new(v.x + v.width / 2, v.y + v.height / 2)
        end
    end
end
--resets player to beginning on death
function death()
    mapHeight = love.graphics.getHeight()
    if Player.y > mapHeight then
        Player.physics.body:setPosition(Player.startX, Player.startY)
    end
end
--When all PB jars are collected, produce win image
function winCondition()
    youWin = love.graphics.newImage('assets/ah.png')
    local sx = love.graphics.getWidth() / youWin:getWidth()
    local sy = love.graphics.getHeight() / youWin:getHeight()
    local mx = love.graphics.getWidth() / 2
    local my = love.graphics.getHeight() / 2
    if Player.pb == 5 then
        love.graphics.draw(youWin, 0, 0, 0, sx, sy)
        local peanutbutter = {1,0.71,0.37}
        love.graphics.print({peanutbutter, "Ah."}, 500, 430)
    end
end