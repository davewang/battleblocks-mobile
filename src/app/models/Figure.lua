local BTCommon = import("..common.BTCommon")
local Block = import(".Block")

local Figure = class("Figure")
function Figure:ctor()
    self.x = 0
    self.y = 0
    self.current = {}
    self.next = {}
    self.blocks = {}
    self.figureBlocks = nil
    self.view = nil
    self.game = nil
    self.grid = nil
    self.nextBlocks = {}
    self.holdBlocks = {}
    self.showNext = true
    self.showHold = true
end
function Figure:getShadowY()
  
    local shadow_y =  self.y
    while true do
        --self.data
        if not BTCommon.collides_with_blocks(self.current, self.grid, self.x, shadow_y - 1) then
            shadow_y = shadow_y - 1
        else
            break
        end
    end
    return shadow_y
end
function Figure:initBlocks()
    --print("initBlocks")
    local newData = {} 
    for y = 1, #self.current do
        newData[y] = {} 
        for x = 1, #self.current[1] do 
            
            if string.sub(self.current[y], x, x) ~= ' ' then 
                self.blocks[#self.blocks+1] = self:buildingBlock(self.x + x - 1, self.y + y - 1,{color = BTCommon.colors[self.current.index], alpha=255}) 
                self:checkMaxY(self.blocks[#self.blocks])
                newData[y][x] = self.blocks[#self.blocks] 
                local shadow_y = self:getShadowY()
                --print("shadow_y = "..shadow_y)
                --local shadow_p = self:getShadow(self.x + x - 1,self.y + y - 1) 
                self.blocks[#self.blocks].shadow = self:buildingBlock(self.x + x - 1, shadow_y + y - 1,{color = BTCommon.colors[self.current.index], alpha=50})
            else
                newData[y][x] = ' '
            end
        end
    end
    self.figureBlocks = newData 
end
function Figure:clear()
	for i=1,#self.blocks do
		self.blocks[i].shadow:removeFromParent()
        self.blocks[i]:removeFromParent()
	end
	self.blocks = nil
end
function Figure:setNextOffset(offset)
    
	self.drawnext_offset = offset
end
function Figure:setHoldOffset(offset)
    
	self.drawhold_offset = offset
end
function Figure:drawNext()
    
    for i=1,#self.nextBlocks do
        self.nextBlocks[i]:removeFromParent()
    end
    self.nextBlocks = {}
    local offset = {x=self.drawnext_offset.x,y=self.drawnext_offset.y} --{x=12,y=8}
    for i=1,#self.next do 
        for y = 1, #self.next[i] do
            for x = 1, #self.next[i][1] do 
                if string.sub(self.next[i][y], x, x) ~= ' ' then 
                    self.nextBlocks[#self.nextBlocks+1] = self:buildingShowBlock(offset.x + x - 1, offset.y + y - 1,{color = BTCommon.colors[self.next[i].index], alpha=255}) 
                    --self.nextBlocks[#self.nextBlocks+1] = self:buildingBlock(offset.x + x - 1, offset.y + y - 1,{color = BTCommon.colors[self.next[i].index], alpha=255}) 
                end
            end
        end
        offset.y = offset.y-5
    end
  
end
function Figure:drawHold()
 
    for i=1,#self.holdBlocks do
        self.holdBlocks[i]:removeFromParent()
    end
    self.holdBlocks = {}
    local offset = {x=self.drawhold_offset.x,y=self.drawhold_offset.y}--{x=-4,y=18}
    for i=1,#self.game.holds do 
        for y = 1, #self.game.holds[i] do
            for x = 1, #self.game.holds[i][1] do 
                if string.sub(self.game.holds[i][y], x, x) ~= ' ' then 
                    self.holdBlocks[#self.holdBlocks+1] = self:buildingShowBlock(offset.x + x - 1, offset.y + y - 1,{color = BTCommon.colors[self.game.holds[i].index], alpha=255}) 
                    --self.holdBlocks[#self.holdBlocks+1] = self:buildingBlock(offset.x + x - 1, offset.y + y - 1,{color = BTCommon.colors[self.game.holds[i].index], alpha=255}) 
                end
            end
        end
        offset.y = offset.y-5
    end

end
function Figure:spawn()
    --print("spawn")
    self.blocks = {}
    self.figureBlocks = nil
    self:initBlocks()
    if self.showNext then
        self:drawNext()
    end
    if self.showHold then
        self:drawHold()
    end
end
function Figure:checkMaxY(block)
    if block.y>20 then
        block:setVisible(false)
    else
        block:setVisible(true)
    end
	
end
function Figure:buildingShowBlock(x,y,attr)
    --alpha = 100
    --print("building x="..tostring(x)..",y="..tostring(y))
    attr.w = self.game.block_show_config.w
    attr.h = self.game.block_show_config.h
   --- local tile = Block:create(attr.color,attr.alpha) 
    local tile = Block:create(attr) 
    tile.x = x
    tile.y = y
    self.view:addChild(tile,11)
    
    
    tile:setPosition(BTCommon.locationOfPosition(self.grid,{x=x,y=y},self.game.block_show_config))
   -- print("shadow.x = ".. BTCommon.locationOfPosition(self.grid,{x=x,y=y}).x)
    -- print("shadow.y = ".. BTCommon.locationOfPosition(self.grid,{x=x,y=y}).y)
    return tile
end
function Figure:buildingBlock(x,y,attr)
    --alpha = 100
    --print("building x="..tostring(x)..",y="..tostring(y))
    attr.w = self.game.block_config.w
    attr.h = self.game.block_config.h
   --- local tile = Block:create(attr.color,attr.alpha) 
    local tile = Block:create(attr) 
    tile.x = x
    tile.y = y
    self.view:addChild(tile,11)
    
    
    tile:setPosition(BTCommon.locationOfPosition(self.grid,{x=x,y=y},self.game.block_config))
   -- print("shadow.x = ".. BTCommon.locationOfPosition(self.grid,{x=x,y=y}).x)
    -- print("shadow.y = ".. BTCommon.locationOfPosition(self.grid,{x=x,y=y}).y)
    return tile
end
function Figure:move()
    
    for y = 1, #self.figureBlocks do
        for x = 1, #self.figureBlocks[1] do
            if self.figureBlocks[y][x] ~= ' ' then 
                self.figureBlocks[y][x].x=(self.x + x - 1) 
                self.figureBlocks[y][x].y=(self.y + y - 1)
              
--                local move = cc.MoveTo:create(0.1,BTCommon.locationOfPosition(self.grid,{x=self.figureBlocks[y][x].x,y=self.figureBlocks[y][x].y}))
--                self.figureBlocks[y][x]:stopAllActions()
--                self.figureBlocks[y][x]:runAction(move)
                self.figureBlocks[y][x]:setPosition(BTCommon.locationOfPosition(self.grid,{x=self.figureBlocks[y][x].x,y=self.figureBlocks[y][x].y},self.game.block_config))
                self:checkMaxY(self.figureBlocks[y][x])
                --move shadow 
                local shadow_y = self:getShadowY() 
                self.figureBlocks[y][x].shadow.x= (self.x + x - 1) 
                self.figureBlocks[y][x].shadow.y= (shadow_y + y - 1) 
--                local move1 = cc.MoveTo:create(0.1,BTCommon.locationOfPosition(self.grid,{x=self.figureBlocks[y][x].shadow.x,y=self.figureBlocks[y][x].shadow.y}))
--                self.figureBlocks[y][x].shadow:stopAllActions()
--                self.figureBlocks[y][x].shadow:runAction(move1)
                self.figureBlocks[y][x].shadow:setPosition(BTCommon.locationOfPosition(self.grid,{x=self.figureBlocks[y][x].shadow.x,y=self.figureBlocks[y][x].shadow.y},self.game.block_config))
            end
        end
    end  
end
function Figure:fall()-- todo check if floor is reached
    if not BTCommon.collides_with_blocks(self.current, self.grid, self.x, self.y - 1) then
        self.y = self.y - 1
        self.game.frame = 1 --reset lock delay
        -- print("fall")
        self:move()
        --figure.currentDraw:updateBlocksPosition()

        return false
    else
        return true
    end
end


function Figure:rotate() 
    if  self.game.state == 'on_floor' then
    	return false
    end
   
    local new_fig = {}
    for y = 1, #self.current[1] do
        new_fig[y] = ''
        for x = #self.current, 1, -1 do
            if string.sub(self.current[x], y, y) ~= ' ' then
                new_fig[y] = new_fig[y].. string.sub(self.current[x], y, y)
            else
                new_fig[y] = new_fig[y]..' '
            end
        end
    end
    
    if BTCommon.collides_with_blocks(new_fig, self.grid, self.x, self.y) then
        return false
    end
     playSound(GAME_SFXS.transform)
    if BTCommon.rules.spin_reset then
        self.game.frame = 1
    end

    if BTCommon.is_on_floor(self.grid,self) then
        self.game.state = 'on_floor'
    else
        self.game.state = 'in_air'
    end
    new_fig.index = self.current.index
    self.current = new_fig
    local newData = {}
    for y = 1, #self.figureBlocks[1] do
        newData[y] = {}
        for x = #self.figureBlocks, 1, -1 do
            if self.figureBlocks[x][y] ~= ' ' then
                newData[y][#newData[y]+1] = self.figureBlocks[x][y]
            else
                newData[y][#newData[y]+1] = ' '
            end
        end
    end

    self.figureBlocks = newData
    self:move()
    return true

end

return Figure