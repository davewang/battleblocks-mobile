--local Simulation = import("..models.Simulation")
local Player = import("..models.Player")
local PFCommon = import("..common.PFCommon")
local RemoteGameView = class("RemoteGameView", cc.load("mvc").ViewBase)

RemoteGameView.events = {
    PLAYER_DISCONNECTED_EVENT = "PLAYER_DISCONNECTED_EVENT",
    PLAYER_GAME_OVER_EVENT = "PLAYER_GAME_OVER_EVENT",
}
function RemoteGameView:onCreate()
    self.commands = {}
    self.score = 0
    self.game_ = Player:create(self,true)--Simulation:create(self)
    self.game_.state = 'paused'

    self.game_.delegate = self  
                 
    self:getApp().matchManager:clearQueue()
    self:getApp().matchManager:addListener(self)
    cc.bind(self, "event")
 
end
function RemoteGameView:step(dt)
    self.game_:step(dt)
   -- print(dt)
    if #self.commands > 0 and self.game_.action_state == 'normal' then 
     local msg = table.remove(self.commands,1)
      if msg.msgid==1001 then
        self.game_:drop()
       --table.insert(self.commands,msg)
      elseif msg.msgid==1002 then
        self.game_:hold()
       -- table.insert(self.commands,msg)
      elseif msg.msgid==1003 then
        self.game_:rotate()
       --table.insert(self.commands,msg)
      elseif msg.msgid==1004  then
        if self.game_.state == 'in_air' then 
        
           if msg.solid_count > 5 then
            playSound(GAME_SFXS.clear3)
            PFCommon.createAnimation(self,"jiguang","play6",nil)
           elseif msg.solid_count > 2 then
            playSound(GAME_SFXS.clear2)
            PFCommon.createAnimation(self,"jiguang","play5",nil)
           else 
            playSound(GAME_SFXS.clear1)
            PFCommon.createAnimation(self,"jiguang","play4",nil)
           end
        
            local st = self.game_:addGem(msg.solid_count)
            if st== "death" then 
                 self:onDeath(self.gird)
            elseif st== "warning" then 
                 self:onWarning(self.gird)
            elseif st== "caution" then 
                 self:onCaution(self.gird) 
            end 
        else
             table.insert(self.commands,1,msg) 
        end 
         
         --self.game_:addGem(msg.solid_count)
         --self.matchManager:sendGemMsg(msg.solid_count)
       
       
        -- local st = self.game_:addGem(msg.solid_count)
        -- if st== "death" then 
        --     self:onDeath(self.gird)
        -- elseif st== "warning" then 
        --     self:onWarning(self.gird)
        -- elseif st== "caution" then 
        --     self:onCaution(self.gird) 
        -- end 
        
      elseif msg.msgid==1005 then
          self.game_:moveDirection(msg.dx)
      elseif msg.msgid==1008 then
      --  table.insert(self.commands,msg)
          self:onPlayerDisconnected()
      elseif msg.msgid==1009 then
          self:onPlayerGameOver()
      elseif msg.msgid==1101 then
          self.game_:moveLeft()
      elseif msg.msgid==1102 then
          self.game_:moveRight()
        -- table.insert(self.commands,msg)
      end 
     
    --  if  self.game_.solidState == false then
     
    --     local msg = table.remove(self.commands,1)
    --     local st = self.game_:addGem(msg.solid_count)
    --     --self.matchManager:sendGemMsg(msg.solid_count)
    --     if st== "death" then 
    --         self:onDeath(self.gird)
    --     elseif st== "warning" then 
    --         self:onWarning(self.gird)
    --     elseif st== "caution" then 
    --         self:onCaution(self.gird) 
    --     end 
    --  end 
       
    end 
end

function RemoteGameView:onPlayerDisconnected()
    self.game_.state = 'paused'
    print("RemoteGameView:onPlayerDisconnected")
    self:getApp():getMatchManager():cancelMatchmakingOpponent()
    self:getApp().matchManager:removeListener(self)
    self:dispatchEvent({name = RemoteGameView.events.PLAYER_DISCONNECTED_EVENT})
    
    
   
end


function RemoteGameView:loadBoardWithGrid(gird)
    -- local bk = cc.LayerColor:create(cc.c4b(0x19, 0x20, 0x2a,0))
    -- self:addChild(bk) 
    -- for y = 1,gird.h  do
    --     for x = 1, gird.w do
    --         local back = cc.LayerColor:create(cc.c4b(0x25,0x2c,0x38,255),gird.blockConfig.w,gird.blockConfig.h)
    --         back:setAnchorPoint(cc.p(0.5,0.5))
    --         back:setPosition(gird:locationOfPosition({x=x,y=y}))
    --         bk:addChild(back) 
    --     end
    -- end 
    -- bk:setPosition(0,0)
    -- local draw = cc.DrawNode:create()
    -- self:addChild(draw) 
    -- local p = gird:locationOfPosition({x=1,y=1})
    -- local p1 = gird:locationOfPosition({x=1,y=12})
    -- local p2 = gird:locationOfPosition({x=12,y=1})
   
    
    self.gird = gird
    self.draw = cc.DrawNode:create()
    self:addChild(self.draw) 
    self.ldraw = cc.DrawNode:create()
    local p1 = gird:locationOfPosition({x=1,y=13})
    local p2 = gird:locationOfPosition({x=7,y=13})
    self:addChild(self.ldraw) 
    self.ldraw:drawLine(cc.p(p1.x,p1.y), cc.p(p2.x, p2.y), cc.c4f(1,0,0,1))
     
    
end
function RemoteGameView:onWarning(gird)
    local p = gird:locationOfPosition({x=1,y=1})
    local p1 = gird:locationOfPosition({x=1,y=13})
    local p2 = gird:locationOfPosition({x=7,y=1})
    local alpha = 0.0
    local function cb_1(n)
          n:clear()
          print(alpha)
          drawNodeRoundRect(n,{x=p.x,y=p.y+p1.y-p.y,width=p2.x-p.x,height=p1.y-p.y},2,10,cc.c4f(1, 1, 0,alpha),cc.c4f(221/255,153/255,45/255,0))
         
          alpha = alpha + 0.1
         
          if alpha >= 1 then
             alpha = 0
          end 
         
    end 
     
    local cb1 = cc.CallFunc:create(cb_1)
    self.draw:runAction(cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(0.01),cb1),34))
end 
function RemoteGameView:onCaution(gird)
    local p = gird:locationOfPosition({x=1,y=1})
    local p1 = gird:locationOfPosition({x=1,y=13})
    local p2 = gird:locationOfPosition({x=7,y=1})
    local alpha = 0.0
    local function cb_1(n)
          n:clear()
          print(alpha)
          drawNodeRoundRect(n,{x=p.x,y=p.y+p1.y-p.y,width=p2.x-p.x,height=p1.y-p.y},2,10,cc.c4f(0, 1, 0,alpha),cc.c4f(221/255,153/255,45/255,0))
         
          alpha = alpha + 0.1
         
          if alpha >= 1 then
             alpha = 0
          end 
          
    end 
     
    local cb1 = cc.CallFunc:create(cb_1)
    self.draw:runAction(cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(0.01),cb1),34))
end 
function RemoteGameView:onDeath(gird)
    local p = gird:locationOfPosition({x=1,y=1})
    local p1 = gird:locationOfPosition({x=1,y=13})
    local p2 = gird:locationOfPosition({x=7,y=1})
    local alpha = 0.0
    local function cb_1(n)
          n:clear()
          print(alpha)
          drawNodeRoundRect(n,{x=p.x,y=p.y+p1.y-p.y,width=p2.x-p.x,height=p1.y-p.y},2,10,cc.c4f(1, 0, 0,alpha),cc.c4f(221/255,153/255,45/255,0))
         
          alpha = alpha + 0.1
         
          if alpha > 1 then
             alpha = 0
          end 
       
    end 
     
    local cb1 = cc.CallFunc:create(cb_1)
    self.draw:runAction(cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(0.01),cb1),34))
end 
 
--function RemoteGameView:loadBoardWithGrid(gird)
    -- local bk = cc.LayerColor:create(cc.c4b(0x19, 0x20, 0x2a,0))
    -- self:addChild(bk) 
    -- for y = 1,gird.h  do
    --     for x = 1, gird.w do
    --         local back = cc.LayerColor:create(cc.c4b(0x25,0x2c,0x38,255),gird.blockConfig.w,gird.blockConfig.h)
    --         back:setAnchorPoint(cc.p(0.5,0.5))
    --         back:setPosition(gird:locationOfPosition({x=x,y=y}))
    --         bk:addChild(back) 
    --     end
    -- end
     
    -- bk:setPosition(0,0)
--end
function RemoteGameView:onPlayerGameOver()
    self.game_.state = 'paused'
    print("RemoteGameView:onPlayerGameOver")
    self:getApp():getMatchManager():cancelMatchmakingOpponent()
    self:getApp().matchManager:removeListener(self)
    self:dispatchEvent({name = RemoteGameView.events.PLAYER_GAME_OVER_EVENT})
end
-- function RemoteGameView:onGameOver()
--     self.game_.state = 'paused'
--     print("RemoteGameView:onGameOver")
--     self:getApp():getMatchManager():cancelMatchmakingOpponent()
--     self:getApp().matchManager:removeListener(self)
--     self:dispatchEvent({name = RemoteGameView.events.PLAYER_GAME_OVER_EVENT})
    
    
    
-- end

function RemoteGameView:start()
    --playMusic(GAME_SFXS.bgMusic3)
    --self.game_:spawn_fig()
    self:scheduleUpdate(handler(self, self.step))
    return self
end
function RemoteGameView:onReceived(msg)
   if msg.msg_type == 0 then
    if msg.msgid==1001 then
      -- self.game_:drop()
       table.insert(self.commands,msg)
    elseif msg.msgid==1002 then
      -- self.game_:hold()
       table.insert(self.commands,msg)
    elseif msg.msgid==1003 then
      -- self.game_:rotate()
       table.insert(self.commands,msg)
    elseif msg.msgid==1004 then
       --self.game_:addGem(msg.solid_count)
        table.insert(self.commands,msg)
    elseif msg.msgid==1005 then
       -- self.game_:moveDirection(msg.dx)
       table.insert(self.commands,msg)
    elseif msg.msgid==1006 then
        
    elseif msg.msgid==1007 then
        self.state = 'paused'
        --self.figure:rotate()
    elseif msg.msgid==1008 then
        table.insert(self.commands,msg)
      --  self:onPlayerDisconnected()
    elseif msg.msgid==1009 then
        --self:onPlayerGameOver()
         table.insert(self.commands,msg)
    elseif msg.msgid==1101 then
        --self:onPlayerGameOver()
         table.insert(self.commands,msg)
    elseif msg.msgid==1102 then
        --self:onPlayerGameOver()
         table.insert(self.commands,msg)
         
    elseif msg.msgid==1010 then
        self:addSolidRows(msg.solid_count,msg.gap_index)
    elseif msg.msgid==1011 then
        self:hold(msg.random_fig)
        
        
        
    end
   end
   
   
   if msg.msg_type == 1 then
       
        if msg.msgid==9001 then
              --print(#msg.data)
              for i=1,#msg.data do 
                 print(string.format("remote {a=%d,b=%d}",msg.data[i].a,msg.data[i].b))
              end 
              self.game_.blockData = msg.data
              self.game_:start()
             -- self:getApp():hideLoadingView() 
              self:start()
            --self:build_next(msg.next)
            --self:spawn_build_fig(msg.random_fig)
        end
    end
end 
return RemoteGameView