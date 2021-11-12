--GUI is the graphical user interface which in this case shows the amount of PB you have or the health
--you have left.
GUI = {}

function GUI:load()
    self.pb = {}
    self.pb.img = love.graphics.newImage("assets/Nut_Butter_2.png")
    self.pb.width = self.pb.img:getWidth() / 2
    self.pb.height = self.pb.img:getHeight() / 2
    self.pb.scale = 1.6
    self.pb.x = love.graphics.getWidth() - 200
    self.pb.y = 50

    self.hearts = {}
    self.hearts.img = love.graphics.newImage("assets/heart.png")
    self.hearts.width = self.hearts.img:getWidth()
    self.hearts.height = self.hearts.img:getHeight()
    self.hearts.x = 0
    self.hearts.y = 30
    self.hearts.scale = 3
    self.hearts.spacing = self.hearts.width * self.hearts.scale + 30

    self.font = love.graphics.newFont("assets/ShinyKids.ttf", 34)
    
end

function GUI:update(dt)

end

function GUI:draw()
    self:displayPB()
    self:displayHearts()
end

function GUI:displayHearts()
    for i=1,Player.health.current do
        local x = self.hearts.x + self.hearts.spacing * i
        love.graphics.setColor(0,0,0,0.5)
        love.graphics.draw(self.hearts.img, x + 2, self.hearts.y + 2, 0, self.hearts.scale, self.hearts.scale)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(self.hearts.img, x, self.hearts.y, 0, self.hearts.scale, self.hearts.scale)
    end

end

function GUI:displayPB()
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.draw(self.pb.img, self.pb.x + 2, self.pb.y + 2, 0, self.pb.scale, self.pb.scale)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.pb.img, self.pb.x, self.pb.y, 0, self.pb.scale, self.pb.scale)
    love.graphics.setFont(self.font)
    local x = self.pb.x + self.pb.width * 2 * self.pb.scale
    local y = self.pb.y + self.pb.height - 30 / 2  * self.pb.scale
    local shadow = {0,0,0,0.5}
    love.graphics.print({shadow, " : "..Player.pb}, x + 2, y + 2)
    local peanutbutter = {1,0.71,0.37}
    love.graphics.print({peanutbutter, " : "..Player.pb}, x, y)
end