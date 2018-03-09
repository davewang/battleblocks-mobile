local SettingView = class("SettingView",cc.Node)
local products = {}
local userDefault = cc.UserDefault:getInstance()
function SettingView:ctor(view)
	self.ownView = view
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255/2))
    self.bg:setTouchEnabled(false)
    self:addChild(self.bg)
    display.newLayer()
        :onTouch(handler(self, self.onTouch),false,true)
        :addTo(self)
    self._bg = display.newSprite("setting_bg.png")
        :move(display.center)
        :addTo(self)
    self.ownView.app_:reloadSetting()
    local titlel = cc.Label:createWithTTF(LANG["setting_title_text"], "fonts/fzzy.ttf", 68)
        :addTo(self._bg)    
    titlel:enableOutline(cc.c4b(116, 54, 25, 255), 4)
    titlel:setPosition(cc.p(self._bg:getContentSize().width/2,self._bg:getContentSize().height-32-titlel:getContentSize().height/2))
  
  
   local soundl = cc.Label:createWithTTF(LANG["setting_sound_text"], "fonts/fzzy.ttf", 46)
        :addTo(self._bg)    
   soundl:setPosition(cc.p(self._bg:getContentSize().width/2.5,self._bg:getContentSize().height/1.6))
   soundl:setAnchorPoint(cc.p(1,0.5))
     soundl:setColor(cc.c3b(105,32,9))
   local musicl = cc.Label:createWithTTF(LANG["setting_music_text"], "fonts/fzzy.ttf", 46)
        :addTo(self._bg)  
   musicl:setPosition(cc.p(self._bg:getContentSize().width/2.5,self._bg:getContentSize().height/2.2))
   musicl:setAnchorPoint(cc.p(1,0.5)) 
   musicl:setColor(cc.c3b(105,32,9))
   local soundSpr = display.newSprite("horn_icon.png"):move(cc.p( cc.p(soundl:getPosition()).x + 100,self._bg:getContentSize().height/1.6))
                                   :addTo(self._bg)    
   local musicSpr = display.newSprite("music_icon.png"):move(cc.p( cc.p(soundl:getPosition()).x+100,self._bg:getContentSize().height/2.2))
                                    :addTo(self._bg)    
  
                                     
    local sound_button
    --default
    if GAME_SETTING.SOUND == 0 then
        sound_button = ccui.Button:create("open_icon.png", "close_icon.png")
        sound_button.ss = 1
    elseif GAME_SETTING.SOUND == 1 then
        sound_button = ccui.Button:create("open_icon.png", "close_icon.png")
         sound_button.ss = 1
    elseif GAME_SETTING.SOUND == 2 then
        sound_button = ccui.Button:create("close_icon.png", "open_icon.png")
         sound_button.ss = 2
    end
    
    
  
     
    local music_button -- = ccui.Button:create("open_icon.png", "close_icon.png")
    if GAME_SETTING.MUSIC == 0 then
        music_button = ccui.Button:create("open_icon.png", "close_icon.png")
        music_button.ss = 1
    elseif GAME_SETTING.MUSIC == 1 then
        music_button = ccui.Button:create("open_icon.png", "close_icon.png")
        music_button.ss = 1
    elseif GAME_SETTING.MUSIC == 2 then
        music_button = ccui.Button:create("close_icon.png", "open_icon.png")
        music_button.ss = 2
    end
    
    local function action(sender,type)
        if type~=2 then
        	   return
        end
        local t = sender:getTag()
        if t == 1001 then
            	if sender.ss == 2 then
                   sender:loadTextureNormal("open_icon.png")
                   sender:loadTexturePressed("close_icon.png")
                   sender.ss = 1
                   userDefault:setIntegerForKey("MUSIC_SET", 1)        
                else 
                   sender:loadTextureNormal("close_icon.png")
                   sender:loadTexturePressed("open_icon.png")
                   userDefault:setIntegerForKey("MUSIC_SET", 2)
                   sender.ss = 2
                end
        elseif  t == 1002 then
               	if sender.ss == 2 then
                   sender:loadTextureNormal("open_icon.png")
                   sender:loadTexturePressed("close_icon.png")
                   sender.ss = 1
                   userDefault:setIntegerForKey("SOUND_SET", 1)
                else 
                   sender:loadTextureNormal("close_icon.png")
                   sender:loadTexturePressed("open_icon.png")
                   sender.ss = 2
                   userDefault:setIntegerForKey("SOUND_SET", 2)
                end
        end
        self.ownView.app_:reloadSetting()
        
    end
    music_button:addTouchEventListener(action)
    sound_button:addTouchEventListener(action)
    music_button:setTag(1001)
    sound_button:setTag(1002)
    sound_button:setPosition(soundSpr:getContentSize().width+cc.p(soundSpr:getPosition()).x + sound_button:getContentSize().width/2-15, self._bg:getContentSize().height/1.6)
    music_button:setPosition(musicSpr:getContentSize().width+cc.p(musicSpr:getPosition()).x+ music_button:getContentSize().width/2,self._bg:getContentSize().height/2.2)
    self._bg:addChild(sound_button)
    self._bg:addChild(music_button)
    local close_button = ccui.Button:create( "red_close_btn.png", "red_close_btn.png")
    local function close()
       self:dismiss()
      
        playSound(GAME_SFXS.buttonClick)
    end
    close_button:setPosition(self._bg:getContentSize().width-close_button:getContentSize().width/2-18,self._bg:getContentSize().height-177+close_button:getContentSize().height/2+10)

    close_button:addTouchEventListener(close)
    self._bg:addChild(close_button)




    self.cannel_button = ccui.Button:create( "recv_all_btn.png", "recv_all_btn.png")
    local function cannel(sender,type)
        if type~=2 then
            return
        end
        userDefault:setStringForKey(K_GAME_CENTER_ID, "1")
        userDefault:setStringForKey(K_GAME_PWD_ID, "1")
        self.ownView.app_:enterScene("LoginWindow");
--        if self.timeTickScheduler then scheduler:unscheduleScriptEntry(self.timeTickScheduler) end
--        self:getApp():getMatchManager():cancelMatchmakingOpponent()
--        --self:getApp():enterScene("MainView")
--        local view = self:getApp():enterScene("MainView")
--        view:onLoginReceived()
--        hiddenGoogleAd_bar()
--        -- LuaObjcBridge.callStaticMethod("AppController","hiddenBar",nil)
--        --self.parse = true
--        print("cannel")
    end
    self.cannel_button:setPosition(self._bg:getContentSize().width/2,self.cannel_button:getContentSize().height)
    self.cannel_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 56})
    self.cannel_button:setTitleColor(cc.c3b(255, 255, 255))
    self.cannel_button:setTitleText(LANG["logout_text"])
    self.cannel_button:addTouchEventListener(cannel)
    self.cannel_button:setScale(0.8);
    self._bg:addChild(self.cannel_button)




    self.ownView:addChild(self,100)
      --LuaObjcBridge.callStaticMethod("AppController","showBar",nil)
      showGoogleAd_bar()
end
function SettingView:onTouch(event)

    local label = string.format("swipe: %s", event.name)

    if event.name == 'began' then
        --print("began")
        return true
    elseif event.name == 'moved' then

    --  print("moved")
    elseif event.name == 'ended' then
        --print("ended")
        --self:dismiss()
    end

end
function SettingView:dismiss()
   -- LuaObjcBridge.callStaticMethod("AppController","hiddenBar",nil)
     hiddenGoogleAd_bar()
    self.ownView:removeChild(self)
end
return SettingView