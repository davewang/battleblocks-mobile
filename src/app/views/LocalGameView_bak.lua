local TetrisBase = import("..models.TetrisBase")
local LocalGameView = class("LocalGameView", cc.load("mvc").ViewBase)

LocalGameView.events = {
    PLAYER_GAME_OVER_EVENT = "PLAYER_GAME_OVER_EVENT"
}
function LocalGameView:onCreate()
    self.score = 0
    -- add touch layer
    display.newLayer()
        :onTouch(handler(self, self.onTouch))
        :addTo(self)
    self.game_ = TetrisBase:create(self,self:getApp().matchManager)
   -- self.game_.matchGame = self:getApp().matchController
    --self.game_.state = 'paused'
    --self.game_:sendReadyMsg()
     
   
    self:getApp().matchManager:addListener(self.game_)
    
    self.game_.delegate = self    
   -- self.scoreLabel_ = cc.Label:createWithTTF(self.score, "fonts/BPreplay.ttf", 32) 
    self.scoreLabel_ = cc.Label:createWithTTF("", "fonts/BPreplay.ttf", 32) 
        :addTo(self)
    self.scoreLabel_:setPosition(cc.p(display.width/2, display.top-self.scoreLabel_:getContentSize().height/2 -65))
    cc.bind(self, "event")
    
    --local delay = cc.DelayTime:create(0.5)
    --local call = cc.CallFunc:create(start)
 
    --self.localGameView_:start()
    --self.localGameView_:runAction(cc.Sequence:create({delay,call}))
end


function LocalGameView:onGameOver()
    self.game_.state = 'paused'
    print("LocalGameView:onGameOver")
    self:getApp():getMatchManager():cancelMatchmakingOpponent()
    self:getApp().matchManager:removeListener(self.game_)
    self:dispatchEvent({name = LocalGameView.events.PLAYER_GAME_OVER_EVENT})
  
    --self:dispatchEvent({name = LocalGameView.events.GAME_OVER_EVENT})
end
function LocalGameView:start()
    --audio.playMusic(GAME_SFXS.bgMusic3)
    playMusic(GAME_SFXS.bgMusic3)
    self.game_:spawn_fig()
    self:scheduleUpdate(handler(self, self.step))
    return self
end
function LocalGameView:getScore()
    return self.score
end

function LocalGameView:updateScore(score)
    print("score = "..score)
   -- self.score = score
   -- self.scoreLabel_:setString(score)
end
function LocalGameView:stop()
    self:unscheduleUpdate()
    return self
end
function LocalGameView:step(dt)
    self.game_:step(dt)
end

function LocalGameView:onTouch(event)
    if self.game_.state == 'paused' then
    	return
    end
    local label = string.format("swipe: %s", event.name)
    -- self.stateLabel:setString(label)
    -- print("label = "..label)
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
            --self.hasPendingSwipe = false
            self.direction = nil
            if math.abs(self.mx-tx)>math.abs(self.my-ty)  then
                self.hasPendingDir = true
                if self.mx<tx then
                    self.direction = DIRECTION.right
                    label = string.format("swipe: %s", "right")

                    self.game_:around(1)
                    self.game_.hold_dir = 1
                    playSound(GAME_SFXS.move)
                else
                    self.direction = DIRECTION.left
                    label = string.format("swipe: %s",  "left")
                    self.game_:around(-1)
                    self.game_.hold_dir = 1
                    playSound(GAME_SFXS.move)
                end
            else
                self.hasPendingSwipe = false
                if self.my<ty then

                    self.direction = DIRECTION.up
                    label = string.format("swipe: %s",  "up")
                    self.game_:hold()
                else
                    self.direction = DIRECTION.down
                    label = string.format("swipe: %s",  "down")
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
        self.game_:rotate()
 
    end

end
return LocalGameView