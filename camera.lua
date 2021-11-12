--Controls moving the map with the player
local Camera = {
    x = 0,
    y = 0,
    scale = 2
}

function Camera:apply()
    love.graphics.push()
    love.graphics.scale(self.scale,self.scale)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:clear()
    love.graphics.pop()
end

function Camera:setPosition(x, y)
    self.x = x - love.graphics.getWidth() / 2 / self.scale
    self.y = y - love.graphics.getHeight() / 2 / self.scale - 100

    local RS = self.x + love.graphics.getWidth() / 2
    local BT = self.y + love.graphics.getHeight() / 2

    if self.x < 0 then
        self.x = 0
    elseif RS > MapWidth then
        self.x = MapWidth - love.graphics.getWidth() / 2
    end

    if self.y < 0 then
        self.y = 0
    elseif BT > MapHeight then
        self.y = MapHeight - love.graphics.getHeight() / 2
    end
end

return Camera
