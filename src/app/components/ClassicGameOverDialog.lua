local ClassicGameOverDialog = class("ClassicGameOverDialog",cc.Node)
local KTags = { Share = 100,
                Again = 101 ,
                Back = 102
               }
function ClassicGameOverDialog:ctor(view)
	self.ownView = view
    self.delegate = view
    self.target = cc.RenderTexture:create(display.width, display.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
    self.target:retain()
    self.target:setPosition(cc.p(display.width / 2, display.height / 2))
    self.target:begin()
    
    
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255/2))
    self.bg:setTouchEnabled(false)
    self:addChild(self.bg)
    display.newLayer()
        :onTouch(handler(self, self.onTouch),false,true)
        :addTo(self)
    
    self._bg = display.newSprite("classic_go_bg.png")
        :move(display.cx,display.cy+120)
        :addTo(self)
        
    local s = self._bg:getContentSize()
    local titlLab = cc.Label:createWithTTF(LANG["classic_gameover_text"], "fonts/fzzy.ttf", 68)
    titlLab:addTo(self._bg)
    titlLab:setPosition(cc.p(s.width/2,s.height-45-titlLab:getContentSize().height/2))
    titlLab:enableOutline(cc.c4b(116, 53, 25, 255), 4)
    
     local clearl = cc.Label:createWithTTF(LANG["classic_clear_text"], "fonts/fzzy.ttf", 46)
        :addTo(self._bg)
    clearl:enableOutline(cc.c4b(200, 102, 0, 255), 3)
    clearl:setAnchorPoint(cc.p(1.0,0.5))
    clearl:move(310,1280-623)
    clearl:setContentSize(cc.size(175,34))
    
    local levell = cc.Label:createWithTTF(LANG["classic_level_text"], "fonts/fzzy.ttf", 46)
        :addTo(self._bg)
    levell:enableOutline(cc.c4b(200, 102, 0, 255), 3)
    levell:setAnchorPoint(cc.p(1.0,0.5))
    levell:move(310,1280-795)
    levell:setContentSize(cc.size(175,34))
      
    local scorel = cc.Label:createWithTTF(LANG["classic_best_score_text"], "fonts/fzzy.ttf", 46)
        :addTo(self._bg)
    scorel:enableOutline(cc.c4b(200, 102, 0, 255), 3)
    scorel:setAnchorPoint(cc.p(1.0,0.5))
    scorel:move(310,1280-965)
    scorel:setContentSize(cc.size(175,34))
   
    self.scoreLab = cc.Label:createWithTTF(self.ownView:getApp():getCurrentUser().nickname, "fonts/fzzy.ttf", 136)
        :addTo(self._bg)   
    self.scoreLab:setString("222")
    self.scoreLab:setAnchorPoint(cc.p(0.5,0.5))
    self.scoreLab:setTextColor(cc.c4b(120,68,21,255))
    self.scoreLab:enableOutline(cc.c4b(120,68,21,255), 3)
    self.scoreLab:move(cc.p(s.width/2,1280-350))
    
    self.clearLab = cc.Label:createWithTTF(self.ownView:getApp():getCurrentUser().nickname, "fonts/fzzy.ttf", 56)
        :addTo(self._bg)   
    self.clearLab:setString("222")
    self.clearLab:setAnchorPoint(cc.p(0.0,0.5))
    self.clearLab:setTextColor(cc.c4b(255,240,1,255))
    self.clearLab:move(cc.p(420,1280-623))
  
    self.levelLab = cc.Label:createWithTTF(self.ownView:getApp():getCurrentUser().nickname, "fonts/fzzy.ttf", 56)
        :addTo(self._bg)   
    self.levelLab:setString("222")
    self.levelLab:setAnchorPoint(cc.p(0.0,0.5))
    self.levelLab:setTextColor(cc.c4b(255,240,1,255))
    self.levelLab:move(cc.p(420,1280-795))
    
    self.baseScoreLab = cc.Label:createWithTTF(self.ownView:getApp():getCurrentUser().nickname, "fonts/fzzy.ttf", 56)
        :addTo(self._bg)   
    self.baseScoreLab:setString("222")
    self.baseScoreLab:setAnchorPoint(cc.p(0.0,0.5))
    self.baseScoreLab:setTextColor(cc.c4b(255,240,1,255))
    self.baseScoreLab:move(cc.p(420,1280-965)) 
        
  
  
  
  
    local function saveImage(tag)
        local png = "image.png"
        tag:saveToFile(png, cc.IMAGE_FORMAT_PNG)
    end
    
    local function action(sender,type)
       if type~=2 then
           return
       end
       if sender:getTag() ==  KTags.Back then
             
            self.ownView:getApp():enterScene("MainView")
       elseif  sender:getTag() ==  KTags.Again then
              
            self.ownView:getApp():enterScene("ClassicScene")  
       elseif  sender:getTag() ==  KTags.Share then
             LuaObjcBridge.callStaticMethod("FacebookManager","post",{name=LANG["send_message_app_name_text"],title=LANG["send_message_title_text"],message=LANG["send_message_message_text"]})  
       end
    end
   
  
    self.shared_button = ccui.Button:create( "share_btn.png", "share_btn.png")
    self.shared_button:setPosition(98+self.shared_button:getContentSize().width/2,display.height/4.5)
    self.shared_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 46})
    self.shared_button:setTitleColor(cc.c3b(255, 255, 255))
    self.shared_button:setTitleText(LANG["shared_text"])
    self.shared_button:addTouchEventListener(action)
    self.shared_button:setTag(KTags.Share)
    self:addChild(self.shared_button)  
     
    self.again_button = ccui.Button:create( "try_again_btn.png", "try_again_btn.png")
    self.again_button:setPosition(display.width/3+self.again_button:getContentSize().width,display.height/4.5)
    self.again_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 46})
    self.again_button:setTitleColor(cc.c3b(255, 255, 255))
    self.again_button:setTitleText(LANG["try_again_text"])
    self.again_button:addTouchEventListener(action)
    self.again_button:setTag(KTags.Again)
    self:addChild(self.again_button)  
    
    self.cannel_button = ccui.Button:create( "confim_lose_btn.png", "confim_lose_btn.png")
  
    self.cannel_button:setPosition(display.width/2,300)
    self.cannel_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 36})
    self.cannel_button:setTitleColor(cc.c3b(255, 255, 255))
    self.cannel_button:setTitleText(LANG["return_text"])
    self.cannel_button:addTouchEventListener(action)
    self.cannel_button:setTag(KTags.Back)
    self:addChild(self.cannel_button)
    self.ownView:addChild(self,100)
    
    self.target:endToLua()
   
    
   
    
end

function ClassicGameOverDialog:setInfo(info)
     
    self.scoreLab:setString(info.score) 
    self.clearLab:setString(info.clear) 
    self.levelLab:setString(info.level) 
    self.baseScoreLab:setString(info.bestScore) 
  
end
function ClassicGameOverDialog:onTouch(event)

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
function ClassicGameOverDialog:dismiss()
    playSound(GAME_SFXS.buttonClick)
    self.ownView:removeChild(self)
  
end
return ClassicGameOverDialog