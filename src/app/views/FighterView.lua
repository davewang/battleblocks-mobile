--local TetrisBase = import("..models.TetrisBase")
local FighterView = class("FighterView", cc.load("mvc").ViewBase)
local Player = import("..models.Player")
local PFCommon = import("..common.PFCommon")
FighterView.events = {
    PLAYER_GAME_OVER_EVENT = "PLAYER_GAME_OVER_EVENT"
}
function FighterView:onCreate1()
    local draw = cc.DrawNode:create()
    -- self:addChild(draw, 300)
    -- local shader = cc.GLProgram:createWithFilenames("shader/example_hb.vsh", "shader/example_hb.fsh")
    -- self.state = cc.GLProgramState:create(shader)
    -- drawNodeRoundRect(draw,{x=12,y=2,width=120,height=120},2,10,cc.c4f(1, 0, 0,1),cc.c4f(221/255,153/255,45/255,1))
    -- draw:setPosition(display.center)
    -- draw:setGLProgramState(self.state)
    -- local vertices2 = { cc.p(30,130), cc.p(30,230), cc.p(50,200) }
    -- draw:drawPoly( vertices2, 3, true, cc.c4f(math.random(0,1), math.random(0,1), math.random(0,1), 1))
end 
function FighterView:onCreate()
 
   self.bg = display.newSprite("tetris_battle_bg.png")
        :move(display.center)
        :addTo(self,-1)
    self.score = 0
    -- add touch layer
    self.layer = display.newLayer()
        :onTouch(handler(self, self.onTouch))
        :addTo(self)
    
    self.scoreLabel_ = cc.Label:createWithTTF("", "fonts/BPreplay.ttf", 32) 
        :addTo(self)
    self.scoreLabel_:setPosition(cc.p(display.width/2, display.top-self.scoreLabel_:getContentSize().height/2 -65))
    cc.bind(self, "event")
--    self.t = display.newSprite("#n_yellow5.png")
--        :move(display.center)
--        :addTo(self)
--         self.t:setColor(cc.c3b(255,0,0))
    
    self:start()
    
    self.oldTime = os.clock()
   -- self.dirlock = false 
    local function accelerometerListener(event,x,y,z,timestamp)  
        
        if os.clock() - self.oldTime > 0.3 then 
          self.oldTime = os.clock()
          --print(string.format("{x = %f, y = %f}", x, y))  
          
          if x > 0.35 then 
            if self.player then 
                 self.player:moveRight()
            end 
             print("right")
          end 
          if x < -0.35 then
            if self.player then 
                 self.player:moveLeft()
            end  
             print("left")
          end 
        end 
    end  
    self.layer:setAccelerometerEnabled(true) 
    -- 创建一个加速度监听器 
    local listerner  = cc.EventListenerAcceleration:create(accelerometerListener)
    self.layer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listerner,self.scoreLabel_)
end
function FighterView:loadBoardWithGrid(gird)
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
    self.gird = gird
    self.draw = cc.DrawNode:create()
    self:addChild(self.draw) 
    self.ldraw = cc.DrawNode:create()
    local p1 = gird:locationOfPosition({x=1,y=13})
    local p2 = gird:locationOfPosition({x=7,y=13})
    self:addChild(self.ldraw) 
    self.ldraw:drawLine(cc.p(p1.x,p1.y), cc.p(p2.x, p2.y), cc.c4f(1,0,0,1))
     
    -- local p = gird:locationOfPosition({x=1,y=1})
    -- local p1 = gird:locationOfPosition({x=1,y=13})
    -- local p2 = gird:locationOfPosition({x=7,y=1})
    -- drawNodeRoundRect(self.draw,{x=p.x,y=p.y+p1.y-p.y,width=p2.x-p.x,height=p1.y-p.y},2,10,cc.c4f(1, 0, 0,1),cc.c4f(221/255,153/255,45/255,0))
    
    
    
    -- self.draw1 = cc.DrawNode:create()
    -- self:addChild(self.draw1) 
    -- local q = gird:locationOfPosition({x=1,y=1})
    -- local q1 = gird:locationOfPosition({x=1,y=16})
    -- local q2 = gird:locationOfPosition({x=7,y=14})
    -- drawNodeRoundRect(self.draw1,{x=q.x,y=q.y+q1.y-q.y,width=q2.x-q.x,height=q1.y-q2.y},2,10,cc.c4f(1, 0, 0,1),cc.c4f(221/255,153/255,45/255,0))
     
    --   local action1 = cc.FadeIn:create(1)
    -- local action1Back = action1:reverse()

    -- local action2 = cc.FadeOut:create(2)
    -- local action2Back = action2:reverse()
    -- draw:setOpacity(0)
    -- draw1:setOpacity(0)
    -- draw:runAction( cc.RepeatForever:create(cc.Sequence:create( action2, action2Back)))
    -- draw1:runAction( cc.RepeatForever:create(cc.Sequence:create( action2, action2Back)))
    
    --draw1:setPosition(0,0)
    self:onWarring(gird)
end
function FighterView:onWarring(gird)
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
function FighterView:onCaution(gird)
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
    self.draw:runAction(cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(0.1),cb1),33))
end 
function FighterView:onDeath(gird)
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
    self.draw:runAction(cc.Repeat:create(cc.Sequence:create(cc.DelayTime:create(0.1),cb1),33))
end 
function FighterView:onGameOver()
   -- self.game_.state = 'paused'
    print("FighterView:onGameOver")
    
    local view = self:getApp():run("FighterView")
   -- self:dispatchEvent({name = FighterView.events.PLAYER_GAME_OVER_EVENT})
  
     
end
function FighterView:sm()
     --play1 play2 play3  opponent -> me 
     --play4 play5 play6  me -> opponent
     --play7              opponent tool -> me 
     
     
      local function animationEvent(armatureBack,movementType,movementID)
        local id = movementID

        if movementType == 1 then
            print("movementID = ",movementID)
            -- if id == "play" then                
            --     armatureBack:getAnimation():play("play2")
            -- elseif id == "play2" then
            --     armatureBack:getAnimation():play("play3")
            -- elseif id == "play3" then
            --     print("end")  
            --     --self:getApp():enterScene("BattleScene")
            --     self:start()
            -- elseif id == "play4" then
            --     print("end")  
            --     --self:start()
            --     self:scheduleUpdate(handler(self, self.step))
            --     al:removeFromParent()
            -- end
        end
    end

      PFCommon.createAnimation(self,"jiguang","play8",animationEvent)
      --PFCommon.createAnimation(self,"new_crazy_ani_2","play")

end 
function FighterView:start()
   -- audio.playMusic(GAME_SFXS.bgMusic3)
    --self.game_:spawn_fig()
    self.player = Player:create(self)
    self:scheduleUpdate(handler(self, self.step))
    self.opponent = Player:create(self,true)
    self:sm()
    
    
    return self
end
function FighterView:getScore()
    return self.score
end

function FighterView:updateScore(score)
    print("score = "..score)
   -- self.score = score
   -- self.scoreLabel_:setString(score)
end
function FighterView:stop()
    self:unscheduleUpdate()
    return self
end
function FighterView:step(dt)
    self.player:step(dt)
    --self.opponent:step(dt)
end

function FighterView:onTouch(event)
    -- if self.game_.state == 'paused' then
    -- 	return
    -- end 
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
                      self.player:moveDirection(1)
                      self.player.hold_dir = 1
                      --self.opponent:moveDirection(1)
                 --   self.game_:around(1)
                  --  self.game_.hold_dir = 1
                 --   playSound(GAME_SFXS.move)
                else
                    self.direction = DIRECTION.left
                    label = string.format("swipe: %s",  "left")
                    self.player:moveDirection(-1)
                    self.player.hold_dir = 1
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
                    self.player:hold()
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
               if self.player.state == 'in_air' then 
                        self.player:drop()
                        --self.opponent:drop()
               end
            end
            --self.game_.gravity = 1
            return 
        end
        self.player:rotate()
         --self.opponent:rotate()
       -- self.game_:rotate()
 
    end

end
 

return FighterView