-- ClassicGameView is a combination of view and controller
local ClassicGameView = class("ClassicGameView", cc.load("mvc").ViewBase)
local TetrisBase = import("..models.TetrisBase")
local Marathon = import("..models.Marathon")

local ConfimDialog = import("app.components.ConfimDialog")
ClassicGameView.events = {
    GAME_OVER_EVENT = "GAME_OVER_EVENT",
}

function ClassicGameView:onCreate()
   
    self.score = 0
    print("...ClassicGameView create ")

    -- add touch layer
    display.newLayer()
        :onTouch(handler(self, self.onTouch))
        :addTo(self)

    -- add background image
    self.bg=display.newSprite("classic_bg.png")
       :move(display.center)
       :addTo(self,-1)

  -- 228 400 570
      -- "classic_clear_text":"消除",
      -- "classic_score_text":"得分",
      -- "classic_level_text":"等级",
   local clearl = cc.Label:createWithTTF(LANG["classic_clear_text"], "fonts/fzzy.ttf", 34)
        :addTo(self.bg)
    clearl:enableOutline(cc.c4b(200, 102, 0, 255), 3)
    --rankl:enableShadow(cc.c4b(0, 0, 0, 255))
    clearl:setAnchorPoint(cc.p(0.5,0.5))
    clearl:move(156,1920-218)
    clearl:setContentSize(cc.size(175,34))
    
      
    local scorel = cc.Label:createWithTTF(LANG["classic_score_text"], "fonts/fzzy.ttf", 34)
        :addTo(self.bg)
    scorel:enableOutline(cc.c4b(200, 102, 0, 255), 3)
    --rankl:enableShadow(cc.c4b(0, 0, 0, 255))
    scorel:setAnchorPoint(cc.p(0.5,0.5))
    scorel:move(156,1920-400)
    scorel:setContentSize(cc.size(175,34))
    
      
   local levell = cc.Label:createWithTTF(LANG["classic_level_text"], "fonts/fzzy.ttf", 34)
        :addTo(self.bg)
    levell:enableOutline(cc.c4b(200, 102, 0, 255), 3)
    --rankl:enableShadow(cc.c4b(0, 0, 0, 255))
    levell:setAnchorPoint(cc.p(0.5,0.5))
    levell:move(156,1920-570)
    levell:setContentSize(cc.size(175,34))
  
  
   local nextl = cc.Label:createWithTTF(LANG["battle_next_text"], "fonts/fzzy.ttf", 34)
        :addTo(self.bg)
    nextl:enableOutline(cc.c4b(200, 102, 0, 255), 3)
    --rankl:enableShadow(cc.c4b(0, 0, 0, 255))
    nextl:setAnchorPoint(cc.p(0.5,0.5))
    nextl:move(156,1920-845)
    nextl:setContentSize(cc.size(175,34))
    --157 1920-68
    local holderl = cc.Label:createWithTTF(LANG["battle_holder_text"], "fonts/fzzy.ttf", 34)
        :addTo(self.bg)
    holderl:enableOutline(cc.c4b(200, 102, 0, 255), 3)
    --rankl:enableShadow(cc.c4b(0, 0, 0, 255))
    holderl:move(156,1920-1546)
    holderl:setAnchorPoint(cc.p(0.5,0.5))
    holderl:setContentSize(cc.size(175,34))
    
    
    
    
    
    self.clearLab = cc.Label:createWithTTF("0", "fonts/fzzy.ttf", 52)
        :addTo(self.bg)
    self.clearLab:setColor(cc.c4b(255, 240, 1, 255))
    self.clearLab:setAnchorPoint(cc.p(0.5,0.5))
    self.clearLab:move(156,1920-306)
 
     self.scoreLab = cc.Label:createWithTTF("0", "fonts/fzzy.ttf", 52)
        :addTo(self.bg)
    self.scoreLab:setColor(cc.c4b(255, 240, 1, 255))
    self.scoreLab:setAnchorPoint(cc.p(0.5,0.5))
    self.scoreLab:move(156,1920-476)
    
    self.levelLab = cc.Label:createWithTTF("0", "fonts/fzzy.ttf", 52)
        :addTo(self.bg)
    self.levelLab:setColor(cc.c4b(255, 240, 1, 255))
    self.levelLab:setAnchorPoint(cc.p(0.5,0.5))
    self.levelLab:move(156,1920-662)
    
    
    
    
    
    
    
    local function click(ref, type)
        if type == 2 then
            return 
        end
        print("loseAction")
        --stop game
        self:stop()
        --open
        self.cfDialog = ConfimDialog:create(self)
        self.cfDialog.delegate = self
        
        --local popup = BattleOverView:create(self)
        
        
    end

    local p_btn = ccui.Button:create("pase_btn.png", "pase_btn.png")
    p_btn:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 36})
    p_btn:setTitleColor(cc.c3b(255, 255, 255))
    p_btn:setTitleText(LANG["classic_pause_text"] )
    p_btn:addTouchEventListener(click)
    p_btn:move(cc.p(157,1920-68))
    self.bg:addChild(p_btn)
 
    -- add lives icon and label
--    display.newSprite("Star.png")
--        :move(display.left + 50, display.top - 50)
--        :addTo(self)
   
 
    -- bind the "event" component
    cc.bind(self, "event")
    -- tetrisBase create
    self.game_ = Marathon:create(self)-- TetrisBase:create(self)
    self.game_:spawn_fig()
    self.game_.delegate = self
    -- self.scoreLabel_ = cc.Label:createWithTTF(self.score, "fonts/BPreplay.ttf", 32) 
    --      :addTo(self)
    -- self.scoreLabel_:setPosition(cc.p(display.width/2, display.top-self.scoreLabel_:getContentSize().height/2 -65))
    
    
    self:start()
    
    
   
end
-- ConfimDialog began --
function ClassicGameView:onConfimDialogBack()
     self.ownView:getApp():enterScene("MainView")
end 

function ClassicGameView:onConfimDialogKeep()
   
    self.cfDialog:dismiss()
end 

function ClassicGameView:onConfimDialogDismiss()
     
     self:start()
end 

-- ConfimDialog end --
function ClassicGameView:onGameOver()
	
    self:dispatchEvent({name = ClassicGameView.events.GAME_OVER_EVENT})
end
function ClassicGameView:startArmature()
    
    local al = cc.LayerColor:create(cc.c4b(0,0,0,0))
        -- :onTouch(function(event)end)
        -- :addTo(self)
    al:setTouchEnabled(false)
    self:addChild(al,999)   
    -- local bg = cc.LayerColor:create(cc.c4b(0,0,0,255/2))
    -- bg:setTouchEnabled(false)
    -- al:addChild(bg)
    local armature = ccs.Armature:create("bisaikaishi")--addRowsAni--Dragon 
    local function animationEvent(armatureBack,movementType,movementID)
        local id = movementID

        if movementType == 1 then
            print("movementID = ",movementID)
            if id == "play" then                
                armatureBack:getAnimation():play("play2")
            elseif id == "play2" then
                armatureBack:getAnimation():play("play3")
            elseif id == "play3" then
                print("end")  
                --self:getApp():enterScene("BattleScene")
                self:start()
            elseif id == "play4" then
                print("end")  
                --self:start()
                self:scheduleUpdate(handler(self, self.step))
                al:removeFromParent()
            end


        end
    end
    armature:getAnimation():setMovementEventCallFunc(animationEvent)
    armature:getAnimation():play("play4")
    armature:getAnimation():setSpeedScale(0.5)
    armature:setPosition(cc.p(display.cx, display.cy))
    
    al:addChild(armature)
    
end
function ClassicGameView:start()
    self:startArmature()
    
    return self
end
function ClassicGameView:getScore()
    return self.score
end
function ClassicGameView:getClear()
    return self.clear
end
function ClassicGameView:getLevel()
    return self.level 
end
 
function ClassicGameView:updateScore(score)
    --print("ClassicGameView score = "..score)
   
    --self.scoreLabel_:setString(score)
    --self.scoreLab:setString(score)
    self.scoreLab:setString(score)
    self.score = tonumber(score)
end
function ClassicGameView:stop()
    
    self:unscheduleUpdate()
    return self
end
function ClassicGameView:step(dt)
      --  print("ClassicGameView step = "..dt)
     self.game_:step(dt)
     self.clear = self.game_.current_clean
     self.level = self.game_.level
     self.clearLab:setString(self.game_.current_clean)
     self.levelLab:setString(self.game_.level)
     
--    if self.lives_ <= 0 then return end
--
--    self.addBugInterval_ = self.addBugInterval_ - dt
--    if self.addBugInterval_ <= 0 then
--        self.addBugInterval_ = math.random(GameView.ADD_BUG_INTERVAL_MIN, GameView.ADD_BUG_INTERVAL_MAX)
--        self:addBug()
--    end
--
--    for _, bug in pairs(self.bugs_) do
--        bug:step(dt)
--        if bug:getModel():getDist() <= 0 then
--            self:bugEnterHole(bug)
--        end
--    end
--
--    return self
end

function ClassicGameView:onTouch(event)
    
    local label = string.format("swipe: %s", event.name)
    -- self.stateLabel:setString(label)
    -- print("label = "..label)
    if event.name == 'began' then
        self.hasPendingSwipe=true
        self.mx=event.x;
        self.my=event.y;
        self.isDirectionTouch = false
        self.startTime = os.clock()
        return true
    elseif event.name == 'moved' then
        local tx = event.x
        local ty = event.y

        if self.hasPendingSwipe and (math.abs(self.mx-tx)>EFFECTIVE_SWIPE_DISTANCE_THRESHOLD or math.abs(self.my-ty)>EFFECTIVE_SWIPE_DISTANCE_THRESHOLD ) then
            self.isDirectionTouch = true
            self.hasPendingDir = false
            --self.hasPendingSwipe = false
            self.direction = nil
            if math.abs(self.mx-tx)>math.abs(self.my-ty)  then
                self.hasPendingDir = true
                if self.mx<tx then
                    self.direction = DIRECTION.right
                    label = string.format("swipe: %s", "right")
                  
                    self.game_:around(1)
                    playSound(GAME_SFXS.move)
                    self.game_.hold_dir = 1
                else
                    self.direction = DIRECTION.left
                    label = string.format("swipe: %s",  "left")
                    self.game_:around(-1)
                    playSound(GAME_SFXS.move)
                    self.game_.hold_dir = 1
                end
            else
                self.hasPendingSwipe = false
                if self.my<ty then
                    self.direction = DIRECTION.up
                    label = string.format("swipe: %s",  "up")
                    --self.game_:hard_drop()
                    self.game_:hold()
                else
                    self.direction = DIRECTION.down
                    label = string.format("swipe: %s",  "down")
                    print("label = "..label)
                    self.game_.gravity = 2
                end
            end

            --self.killsLabel_:setString(label)
            self.mx=tx
            self.my=ty
        end

    elseif event.name == 'ended' then
        self.endTime = os.clock()
      
        if self.isDirectionTouch then
            if self.direction == DIRECTION.down then
                local diff = self.endTime-self.startTime 
                --print("diff = "..diff)
                if diff < 0.1 then
                    self.game_:hard_drop()
                end
           end
           self.game_.gravity = 1
           return 
        end
 
        self.game_.figure:rotate()
    end

end
return ClassicGameView