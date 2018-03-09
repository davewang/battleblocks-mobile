--local TetrisBase = import("..models.TetrisBase")
local Player = import("..models.Player")
local PFCommon = import("..common.PFCommon")
local LocalGameView = class("LocalGameView", cc.load("mvc").ViewBase)

LocalGameView.events = {
    PLAYER_GAME_OVER_EVENT = "PLAYER_GAME_OVER_EVENT"
}

function LocalGameView:onCreate()
    self.score = 0
    self.commands= {}
    -- add touch layer
    self.layer = display.newLayer()
        :onTouch(handler(self, self.onTouch))
        :addTo(self)
        --self.player = Player:create(self)
    self.game_ = Player:create(self)--TetrisBase:create(self,self:getApp().matchManager)
 
    self.matchManager = self:getApp().matchManager
    self:getApp().matchManager:clearQueue()
    self:getApp().matchManager:addListener(self)
    
    self.game_.delegate = self    
    cc.bind(self, "event")
    
    --draw 1 point
    -- draw:drawPoint(cc.p(60,60), 4, cc.c4f(math.random(0,1), math.random(0,1), math.random(0,1), 1))
    --local draw = cc.DrawNode:create()
    
    
    
    
    self.scoreLabel_ = cc.Label:createWithTTF("", "fonts/BPreplay.ttf", 32) 
        :addTo(self)
    self.scoreLabel_:setVisible(false)
    self.oldTime = os.clock()
   -- self.dirlock = false 
    local function accelerometerListener(event,x,y,z,timestamp)  
        
        if os.clock() - self.oldTime > 0.3 then 
          self.oldTime = os.clock()
          --print(string.format("{x = %f, y = %f}", x, y))  
          
          if x > 0.35 then 
            if  self.game_ and  self.game_.action_state == 'normal'  then 
                 self.game_:moveRight()
                 self.matchManager:sendMoveRightMsg()
            end 
             print("right")
          end 
          if x < -0.35 then
            
            if  self.game_  and  self.game_.action_state == 'normal' then 
                 self.game_:moveLeft()
                 self.matchManager:sendMoveLeftMsg()
            end  
             print("left")
          end 
        end 
    end  
    -- self.layer:setAccelerometerEnabled(true)
    -- 创建一个加速度监听器 
    local listerner  = cc.EventListenerAcceleration:create(accelerometerListener)
    self.layer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listerner,self.scoreLabel_)

    
    
    
    
    
    
    
end
function LocalGameView:loadBoardWithGrid(gird)
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
function LocalGameView:onWarning(gird)
    local p = gird:locationOfPosition({x=1,y=1})
    local p1 = gird:locationOfPosition({x=1,y=13})
    local p2 = gird:locationOfPosition({x=7,y=1})
    local alpha = 0.0
    local function cb_1(n)
          n:clear()
          --print(alpha)
          drawNodeRoundRect(n,{x=p.x,y=p.y+p1.y-p.y,width=p2.x-p.x,height=p1.y-p.y},2,10,cc.c4f(1, 1, 0,alpha),cc.c4f(221/255,153/255,45/255,0))
         
          alpha = alpha + 0.1
         
          if alpha >= 1 then
             alpha = 0
          end 
         
    end 
     
    local cb1 = cc.CallFunc:create(cb_1)
    self.draw:runAction(cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(0.01),cb1),34))
end 
function LocalGameView:onCaution(gird)
    local p = gird:locationOfPosition({x=1,y=1})
    local p1 = gird:locationOfPosition({x=1,y=13})
    local p2 = gird:locationOfPosition({x=7,y=1})
    local alpha = 0.0
    local function cb_1(n)
          n:clear()
          --print(alpha)
          drawNodeRoundRect(n,{x=p.x,y=p.y+p1.y-p.y,width=p2.x-p.x,height=p1.y-p.y},2,10,cc.c4f(0, 1, 0,alpha),cc.c4f(221/255,153/255,45/255,0))
         
          alpha = alpha + 0.1
         
          if alpha >= 1 then
             alpha = 0
          end 
          
    end 
     
    local cb1 = cc.CallFunc:create(cb_1)
    self.draw:runAction(cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(0.01),cb1),34))
end 
function LocalGameView:onDeath(gird)
    local p = gird:locationOfPosition({x=1,y=1})
    local p1 = gird:locationOfPosition({x=1,y=13})
    local p2 = gird:locationOfPosition({x=7,y=1})
    local alpha = 0.0
    local function cb_1(n)
          n:clear()
          --print(alpha)
          drawNodeRoundRect(n,{x=p.x,y=p.y+p1.y-p.y,width=p2.x-p.x,height=p1.y-p.y},2,10,cc.c4f(1, 0, 0,alpha),cc.c4f(221/255,153/255,45/255,0))
         
          alpha = alpha + 0.1
         
          if alpha > 1 then
             alpha = 0
          end 
       
    end 
     
    local cb1 = cc.CallFunc:create(cb_1)
    self.draw:runAction(cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(0.01),cb1),34))
end 
function LocalGameView:onGameOver()
    self:getApp().matchManager:sendGameOverMsg()      
    self.game_.state = 'paused'
    print("LocalGameView:onGameOver")
    self:getApp():getMatchManager():cancelMatchmakingOpponent()
    self:getApp().matchManager:removeListener(self)
    self:dispatchEvent({name = LocalGameView.events.PLAYER_GAME_OVER_EVENT})
end
function LocalGameView:start()
    playMusic(GAME_SFXS.bgMusic3)
    --self.game_:spawn_fig()
    
    self:scheduleUpdate(handler(self, self.step))
    return self
end
function LocalGameView:onGem(count)
     self.matchManager:sendSolidMsg(count)
end 
function LocalGameView:onReceived(msg)
    if msg.msg_type == 1 then
        --print("TetrisBase:onReceived")
        if msg.msgid==2001 then
           table.insert(self.commands,msg)
         
         
            --self:addSolidRows(msg.solid_count)
             
         --   self.game_:addGem(msg.solid_count)
         --   self.matchManager:sendGemMsg(msg.solid_count)
        end
        if msg.msgid==9001 then
              --print(#msg.data)
              for i=1,#msg.data do 
                 print(string.format("{a=%d,b=%d}",msg.data[i].a,msg.data[i].b))
              end 
              self.game_.blockData = msg.data
              self.game_:start()
              self:getApp():hideLoadingView() 
              self:start()
            --self:build_next(msg.next)
            --self:spawn_build_fig(msg.random_fig)
        end
    end
end
function LocalGameView:getScore()
    return self.score
end

function LocalGameView:updateScore(score)
    print("score = "..score)
   -- self.score = score 
end
function LocalGameView:stop()
    self:unscheduleUpdate()
    return self
end
function LocalGameView:step(dt)
    self.game_:step(dt)
    if #self.commands > 0 and self.game_.action_state == "normal" and self.game_.state == 'in_air' then 
        local msg = table.remove(self.commands,1)
        if msg.solid_count > 5 then
          playSound(GAME_SFXS.clear3)
          PFCommon.createAnimation(self,"jiguang","play3",nil)
        elseif msg.solid_count > 2 then
          playSound(GAME_SFXS.clear2)
          PFCommon.createAnimation(self,"jiguang","play2",nil)
        else 
          playSound(GAME_SFXS.clear1)
          PFCommon.createAnimation(self,"jiguang","play1",nil)
        end 
        
        local st = self.game_:addGem(msg.solid_count)
        self.matchManager:sendGemMsg(msg.solid_count)
        if st== "death" then 
            self:onDeath(self.gird)
        elseif st== "warning" then 
            self:onWarning(self.gird)
        elseif st== "caution" then 
            self:onCaution(self.gird) 
        end 
    
       
    end 
     
end


function LocalGameView:onTouch(event)
    if self.game_.state == 'paused' then
    	return
    end 
     
    local label = string.format("swipe: %s", event.name)
    -- self.stateLabel:setString(label)
     --print("label = "..label)
    if event.name == 'began' then
        self.hasPendingSwipe=true
        self.mx=event.x;
        self.my=event.y;
        self.isDirectionTouch = false
        self.startTime = os.clock()
        self.direction = nil
        return true
    elseif event.name == 'moved' then
        local tx = event.x
        local ty = event.y

        if self.hasPendingSwipe and (math.abs(self.mx-tx)>EFFECTIVE_SWIPE_DISTANCE_THRESHOLD or math.abs(self.my-ty)>EFFECTIVE_SWIPE_DISTANCE_THRESHOLD ) then
            self.isDirectionTouch = true
            self.hasPendingDir = false
           
            self.direction = nil
            if math.abs(self.mx-tx)>math.abs(self.my-ty)  then
                self.hasPendingDir = true
                if self.mx<tx then
                    self.direction = DIRECTION.right
                    label = string.format("swipe: %s", "right")
                    if self.game_.state == 'in_air' then 
                        self.game_:moveDirection(1)
                        self.game_.hold_dir = 1
                        self.matchManager:sendMoveDirectionMsg(1)
                        playSound(GAME_SFXS.move)
                     end
                      
                      --self.opponent:moveDirection(1)
                 --   self.game_:around(1)
                  --  self.game_.hold_dir = 1
                 --   playSound(GAME_SFXS.move)
                else
                    self.direction = DIRECTION.left
                    label = string.format("swipe: %s",  "left")
                     if self.game_.state == 'in_air' then 
                        self.game_:moveDirection(-1)
                        self.game_.hold_dir = 1
                        self.matchManager:sendMoveDirectionMsg(-1)
                        playSound(GAME_SFXS.move)
                     end
                    
                   -- self.opponent:moveDirection(-1)
                  --  self.game_:around(-1)
                  --  self.game_.hold_dir = 1
                  --  playSound(GAME_SFXS.move)
                end
            else
                self.hasPendingSwipe = false
                if self.my<ty then

                    self.direction = DIRECTION.up
                    label = string.format("swipe: %s",  "up")
                    self.game_:hold()
                    self.matchManager:sendHoldMsg()
                    --self.opponent:hold()
                  
                else
                
                    self.direction = DIRECTION.down
                    label = string.format("swipe: %s",  "down")
                    --self.game_.gravity = 2
                end
            end
 
            self.mx=tx
            self.my=ty
        end

    elseif event.name == 'ended' then
        self.endTime = os.clock()
        if self.isDirectionTouch then
            if self.direction == DIRECTION.down then
               if self.game_.state == 'in_air' and self.game_.action_state == 'normal' then 
                         playSound(GAME_SFXS.drop)
                         self.game_:drop()
                         self.matchManager:sendDropMsg()
                          
                        --self.opponent:drop()
               end
            end
            --self.game_.gravity = 1
            return 
        end
        if self.game_.state == 'in_air' then 
             playSound(GAME_SFXS.transform)
             self.game_:rotate()
             self.matchManager:sendRotateMsg()
        end
        --self.opponent:rotate()
        --self.game_:rotate()
 
    end

end

-- function LocalGameView:onTouch(event)
--     if self.game_.state == 'paused' then
--     	return
--     end
--     local label = string.format("swipe: %s", event.name)
--     -- self.stateLabel:setString(label)
--     -- print("label = "..label)
--     if event.name == 'began' then
--         self.hasPendingSwipe=true
--         self.mx=event.x;
--         self.my=event.y;
--         self.isDirectionTouch = false
--         self.startTime = os.clock()
--         self.direction = nil
--         return true
--     elseif event.name == 'moved' then
--         local tx = event.x
--         local ty = event.y

--         if self.hasPendingSwipe and (math.abs(self.mx-tx)>EFFECTIVE_SWIPE_DISTANCE_THRESHOLD or math.abs(self.my-ty)>EFFECTIVE_SWIPE_DISTANCE_THRESHOLD ) then
--             self.isDirectionTouch = true
--             self.hasPendingDir = false
--             --self.hasPendingSwipe = false
--             self.direction = nil
--             if math.abs(self.mx-tx)>math.abs(self.my-ty)  then
--                 self.hasPendingDir = true
--                 if self.mx<tx then
--                     self.direction = DIRECTION.right
--                     label = string.format("swipe: %s", "right")

--                     self.game_:around(1)
--                     self.game_.hold_dir = 1
--                     playSound(GAME_SFXS.move)
--                 else
--                     self.direction = DIRECTION.left
--                     label = string.format("swipe: %s",  "left")
--                     self.game_:around(-1)
--                     self.game_.hold_dir = 1
--                     playSound(GAME_SFXS.move)
--                 end
--             else
--                 self.hasPendingSwipe = false
--                 if self.my<ty then

--                     self.direction = DIRECTION.up
--                     label = string.format("swipe: %s",  "up")
--                     self.game_:hold()
--                 else
--                     self.direction = DIRECTION.down
--                     label = string.format("swipe: %s",  "down")
--                     self.game_.gravity = 2
--                 end
--             end

--             --self.killsLabel_:setString(label)
--             self.mx=tx
--             self.my=ty
--         end

--     elseif event.name == 'ended' then
--         self.endTime = os.clock()
--         if self.isDirectionTouch then
--             if self.direction == DIRECTION.down then
--                 local diff = self.endTime-self.startTime 
--                 --print("diff = "..diff)
--                 if diff < 0.1 then
--                     self.game_:hard_drop()
--                 end
--             end
--             self.game_.gravity = 1
--             return 
--         end
--         self.game_:rotate()
 
--     end

-- end
return LocalGameView