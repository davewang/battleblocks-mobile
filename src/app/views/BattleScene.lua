
local BattleScene = class("BattleScene", cc.load("mvc").ViewBase)
local LocalGameView = import(".LocalGameView")
local RemoteGameView = import(".RemoteGameView")
local BattleOverView = import("app.views.BattleOverView")
local ConfimDialog = import("app.components.ConfimDialog")
function BattleScene:onCreate()
  
    self.bg = display.newSprite("tetris_battle_bg.png")
        :move(display.center)
        :addTo(self,-1)
    local nextl = cc.Label:createWithTTF(LANG["battle_next_text"], "fonts/fzzy.ttf", 34)
        :addTo(self.bg)
    nextl:enableOutline(cc.c4b(200, 102, 0, 255), 3)
    --rankl:enableShadow(cc.c4b(0, 0, 0, 255))
    nextl:setAnchorPoint(cc.p(0.5,0.5))
    nextl:move(160,896)
    nextl:setContentSize(cc.size(175,34))
    --157 1920-68
    local holderl = cc.Label:createWithTTF(LANG["battle_holder_text"], "fonts/fzzy.ttf", 34)
        :addTo(self.bg)
    holderl:enableOutline(cc.c4b(200, 102, 0, 255), 3)
    --rankl:enableShadow(cc.c4b(0, 0, 0, 255))
    holderl:move(160,295)
    holderl:setAnchorPoint(cc.p(0.5,0.5))
    holderl:setContentSize(cc.size(175,34))
    
    
    self.avatar = display.newSprite("#profile_default_picture.png")
    stretchSprite(self.avatar,146,140)
    --stretchSprite(self.avatar,146/2,140/2)
    local offset = cc.p(105,1920-250)
    self.avatar:setPosition(offset)
    self:addChild(self.avatar,-2)
    self.levelLab = cc.Label:createWithTTF("&", "fonts/fzzy.ttf", 36)
        :addTo(self.bg)    
    self.levelLab:setTextColor(cc.c4b(116,54,25,255))
    self.levelLab:move(cc.p(240,1920-276))
    
    
    self.remoteGameView_ =  self:getApp():createView("RemoteGameView") -- RemoteGameView:create()
        :addEventListener(RemoteGameView.events.PLAYER_DISCONNECTED_EVENT, handler(self, self.onRemotePlayerDisconnected))
        :addEventListener(RemoteGameView.events.PLAYER_GAME_OVER_EVENT, handler(self, self.onRemotePlayerGameOver))
        :addTo(self.bg)
    self.localGameView_ =  self:getApp():createView("LocalGameView")  --LocalGameView:create()
        :addEventListener(LocalGameView.events.PLAYER_GAME_OVER_EVENT, handler(self, self.onLocalPlayerGameOver))
        :addTo(self.bg)
    self.localGameView_.ownView = self
    
    local function click(ref, type)
        if type == 2 then
            return 
        end
        print("loseAction")
        
        --local popup = BattleOverView:create(self)
         self.cfDialog = ConfimDialog:create(self)
         self.cfDialog.delegate = self
        
        
    end

    local lose_btn = ccui.Button:create("confim_lose_btn.png", "confim_lose_btn.png")
    lose_btn:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 36})
    lose_btn:setTitleColor(cc.c3b(255, 255, 255))
    lose_btn:setTitleText(LANG["loser_text"] )
    lose_btn:addTouchEventListener(click)
    lose_btn:move(cc.p(157,1920-68))
    self.bg:addChild(lose_btn)
    
    local speed_btn = ccui.Button:create("speed_ef_bg.png", "speed_ef_bg.png")
    speed_btn:addTouchEventListener(click)
    speed_btn:move(cc.p(978,1920-126))
   -- self.bg:addChild(speed_btn)
    
    local clear_btn = ccui.Button:create("clear_ef_bg.png", "clear_ef_bg.png")
    clear_btn:addTouchEventListener(click)
    clear_btn:move(cc.p(978,1920-346))
   -- self.bg:addChild(clear_btn)
    
    local add_btn = ccui.Button:create("add_ef_bg.png", "add_ef_bg.png")
    add_btn:addTouchEventListener(click)
    add_btn:move(cc.p(978,1920-560))
   -- self.bg:addChild(add_btn)
    
    
     self:getApp():showLoadingInView(self,LANG["waitting_opp_text"])
    
    	
    local function start(ref)
           --ref.game_:sendReadyMsg()
          ref.matchManager:sendReadyMsg()
    end 
    local delay = cc.DelayTime:create(0.5)
    local call = cc.CallFunc:create(start)
 
    --self.localGameView_:start()
    self.localGameView_:runAction(cc.Sequence:create({delay,call}))
        --:addEventListener(LocalGameView.events.GAME_OVER_EVENT, handler(self, self.onGameOver))

end
-- ConfimDialog began --
function BattleScene:onConfimDialogBack()
     self:clearListeners()
     self:getApp():getMatchManager():cancelMatchmakingOpponent()
     self:getApp().matchManager:matchFail()
     --self:getApp():enterScene("MainView")
     local view = self:getApp():enterScene("MainView")
     view:onLoginReceived()
    
end 

function BattleScene:onConfimDialogKeep()
   
    self.cfDialog:dismiss()
end 

function BattleScene:onConfimDialogDismiss()
     
     --self:start()
end 

-- ConfimDialog end --
function BattleScene:setRemoteUserInfo(user)
    self.remotePlayer = user
    -- local nameLab = cc.Label:createWithTTF(user.nickname, "fonts/fzzy.ttf", 54)
    --     :addTo(contentView)    
    -- nameLab:setTextColor(cc.c4b(116,54,25,255))
    -- nameLab:move(cc.p(self.me_photo:getContentSize().width/2,nameLab:getContentSize().height+15 ))
    if user.avatarid then
        self.avatar:setSpriteFrame(AVATER_TYPE[user.avatarid])
    end
     self.levelLab:setString(user.level)
   
    
    
end
function BattleScene:clearListeners()
    self.remoteGameView_.game_.state = 'paused'
    self.localGameView_.game_.state = 'paused'
    self.localGameView_:stop()
    --self:getApp().matchManager:removeListener(self.remoteGameView_.game_)
    --self:getApp().matchManager:removeListener(self.localGameView_.game_)
    self:getApp().matchManager:removeListener(self.remoteGameView_)
    self:getApp().matchManager:removeListener(self.localGameView_)
    self:getApp().matchManager.queue = {}
    
    audio.pauseMusic()
    
end
function BattleScene:onLocalPlayerGameOver(event)
    self:clearListeners()
  
    playSound(GAME_SFXS.lost) 
    self:getApp().matchManager:matchFail()
    self.success = false
    local popup = BattleOverView:create(self)
    
end
function BattleScene:onRemotePlayerGameOver(event)
    self:clearListeners()
   
    playSound(GAME_SFXS.win) 
    self:getApp().matchManager:matchWin()
    self.success = true
    local popup = BattleOverView:create(self)
end
function BattleScene:onRemotePlayerDisconnected(event)
    self:clearListeners()
    
    
        playSound(GAME_SFXS.win) 
        self:getApp().matchManager:matchWin()
        self.success = true
        local popup = BattleOverView:create(self)
     
    
end

 
return BattleScene