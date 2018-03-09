local spriteFrameCache = cc.SpriteFrameCache:getInstance()
local Tile = class("Tile", function()
    --return display.newNode()
    --return display.newNode()
    return display.newLayer()
    --return cc.LayerColor:create(cc.c4b(0,0,0,0))
end)
function Tile:ctor(config)
    config.alpha = config.alpha or 255
    self.pos = {x=0,y=0}
  --  self:setNodeEventEnabled(true)
    self.pendingActions = {}
    self.pendingActionIndex = 0
    self.grid = nil 
    self.h = config.h
    self.w = config.w
    self.color = config.color
    self.type = config.type
    self.times = 5
    --print(self.color)
    --print(self.type)
    local boxSize = cc.size(self.w,self.h)

    if self.type == "super_crash" then
        --print(string.format("#%s.png","diamond"))
        self.newBlock = display.newSprite( string.format("#%s.png","diamond")) --cc.Sprite:create( string.format("tiles/%s.png","diamond"))-- cc.Sprite:create("block_1.png")--cc.LayerColor:create(cc.c4b(self.color[1],self.color[2],self.color[3],alpha))
    elseif self.type =="normal" then 
        --print(string.format("#%s.png",self.color))
        self.newBlock = display.newSprite( string.format("#%s.png",self.color))--cc.Sprite:create( string.format("tiles/%s.png",self.color))-- cc.Sprite:create("block_1.png")--cc.LayerColor:create(cc.c4b(self.color[1],self.color[2],self.color[3],alpha))
    elseif self.type =="crash" then 
        --print(string.format("#b_%s1.png",self.color))
        self.newBlock = display.newSprite( string.format("#b_%s1.png",self.color))--cc.Sprite:create( string.format("tiles/b_%s1.png",self.color))-- cc.Sprite:create("block_1.png")--cc.LayerColor:create(cc.c4b(self.color[1],self.color[2],self.color[3],alpha))
    
        local fm_str = string.format("b_%s%%d.png",self.color)
        local frames = display.newFrames(fm_str,1,6)
        local animation = display.newAnimation(frames, 0.8/3) -- 0.5 秒播放 8 桢
        self.newBlock:playAnimationForever(animation)
    elseif self.type =="solid" then 
        --print(string.format("#%s.png",self.color))
        local fm_str = string.format("b_%s%%d.png",self.color)
        local frames = display.newFrames(fm_str,1,6)
        self.newBlock = display.newSprite( string.format("#n_%s%d.png",self.color,self.times))--cc.Sprite:create( string.format("tiles/%s.png",self.color))-- cc.Sprite:create("block_1.png")--cc.LayerColor:create(cc.c4b(self.color[1],self.color[2],self.color[3],alpha))
   
    end

    local spx =  self.newBlock:getTextureRect().width
    local spy =  self.newBlock:getTextureRect().height
    self.newBlock:setScaleX(self.w/spx) --设置精灵宽度缩放比例
    self.newBlock:setScaleY(self.h/spy)
    self.newBlock:setOpacity(config.alpha)
    self.newBlock:setAnchorPoint(cc.p(0.5,0.5))
    self.newBlock:setTag(111) 
    --self.newBlock:setPosition(cc.p(self.w/2,self.h/2))
    self.newBlock:setPosition(cc.p(self.w/2,self.h/2))
    self:setContentSize( boxSize) 
    self:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.newBlock)
    
end 
function Tile:updateSolid()
    self.times =  self.times - 1
    if self.times == 0 then
       self.type = "normal" 
       local frame = spriteFrameCache:getSpriteFrame( string.format("%s.png",self.color))
       self.newBlock:setSpriteFrame(frame) 
       
    else 
       local frame = spriteFrameCache:getSpriteFrame( string.format("n_%s%d.png",self.color,self.times))
       self.newBlock:setSpriteFrame(frame) 
    end 
end
--function Tile:refreshValue()
----    local _value = GState.valueForLevel(self.level)
----    self.value:setString(string.format("%d", _value))
----    --print("text = "..self.value:getString())
----    self.value:setSystemFontSize(GState.textSizeForValue(self.value:getString()))
----    self.fillColor = GState.colorForLevel(self.level)
----    self.boardColor = GState.boardColorForLevel(self.level)
----    local node = self:getChildByTag(111)
----    node:setColor(self.fillColor )
----    local node1 = self:getChildByTag(222)
----    node1:setColor(self.boardColor)
--
--end
function Tile:commitPendingActions()
    if #self.pendingActions > 0 then 
       -- print("commitPendingActions:",self.pendingActions)
       -- print("commitPendingActions:",#self.pendingActions)
        self:runAction(cc.Sequence:create(self.pendingActions))
        self.pendingActions = {}
        self.pendingActionIndex = 0
    end
end
function Tile:commitPendingActionsWithEndCallBack(callback)
    local callbackAction = cc.CallFunc:create(callback);
    self.pendingActions[self:IncrementIndex()] = callbackAction
    if #(self.pendingActions) > 0 then 

        self:runAction(cc.Sequence:create(self.pendingActions))
        self.pendingActions = {}
        self.pendingActionIndex = 0
    end

end
 
  
function Tile:removeFromParentCell()
    -- A move is only one action, so if there are more than one actions, there must be
    -- a merge that needs to be committed. If things become more complicated, change
    -- this to an explicit ivar or property.
    self.grid[self.pos.y][self.pos.x] = 0

end  

function Tile:removeWithDelay()
    self:removeFromParentCell()
    local function callback()
        self:removeFromParent()
    end

    local wait = cc.DelayTime:create(GState.animationDuration)
    local remove = cc.CallFunc:create(callback)
    self:runAction(cc.Sequence:create({wait,remove}))
end
function Tile:IncrementIndex()
    self.pendingActionIndex = self.pendingActionIndex+1
    return self.pendingActionIndex
end
 
 
  
 
function Tile:addPendingAction(action)
   -- print("Tile:addPendingAction")
    self.pendingActions[self:IncrementIndex()] = action

end
function Tile:removeAnimated(animated)
    self:removeFromParentCell()
    if animated then
        local scale = cc.ScaleTo:create(0.1,0)
        self.pendingActions[self:IncrementIndex()]=scale
    end
    local function block()
        self:removeFromParent()
    end
    local callback = cc.CallFunc:create(block)
    self.pendingActions[self:IncrementIndex()] =  callback
    self:commitPendingActions() 
end

function Tile:onEnter()
    print("Tile:onEnter")
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(false) 
--    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
--
--            if event.name == "began" then
--
--                printInfo(string.format("Tile::began %s", tostring(M_ARROW_SELECT_TILE)))
--                if not M_ARROW_SELECT_TILE then
--                    return false
--                end
--                self.oldColor = self.fillColor
--                self.boardTile:setColor(cc.c3b(255,255,200))
--                return true
--            end
--            if event.name == "ended" then
--                printInfo("Tile::ended")
--                self.fillColor = self.oldColor
--                self.boardTile:setColor(self.fillColor)
--                self.grid.selectedTile(self)
--            end
--            --local label = string.format("M2Tile: %s x,y: %0.2f, %0.2f", event.name, event.x, event.y)
--            --print(label)
--
--
--
--            return true
--    end)


end 

function Tile:onExit()
end

return Tile