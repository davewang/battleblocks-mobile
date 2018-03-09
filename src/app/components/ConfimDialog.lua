local ConfimDialog = class("ConfimDialog",cc.Node)
local KTags = { Back = 100,
                Keep = 101 
               }
function ConfimDialog:ctor(view)
	self.ownView = view
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255/2))
    self.bg:setTouchEnabled(false)
    self:addChild(self.bg)
    display.newLayer()
        :onTouch(handler(self, self.onTouch),false,true)
        :addTo(self)
    self._bg = display.newSprite("confim_bg.png")
        :move(display.center)
        :addTo(self)
    
	  self._bg:move(display.center)
     local function submit(sender,type)
		playSound(GAME_SFXS.buttonClick)
        if type~=2 then
        	   return
        end
        if sender:getTag() == KTags.Back then
             self.delegate:onConfimDialogBack()
            -- self.ownView.ownview:getApp():enterScene("MainView")
            -- self.ownView:getApp():enterScene("MainView")
        elseif sender:getTag() == KTags.Keep then
             self.delegate:onConfimDialogKeep()
           --  self:dismiss()
        end 
     
       
    end
        
    self.back_button = ccui.Button:create( "confim_lose_btn.png", "confim_lose_btn.png")
  
    self.back_button:setPosition(self._bg:getContentSize().width/4, self._bg:getContentSize().height/2.5 )
    self.back_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 36})
    self.back_button:setTitleColor(cc.c3b(255, 255, 255))
    self.back_button:setTitleText(LANG["classic_exit_text"])
    self.back_button:addTouchEventListener(submit)
    self.back_button:setTag(KTags.Back)
    self._bg:addChild(self.back_button)
    
    
    self.keep_button = ccui.Button:create( "pase_btn.png", "pase_btn.png")
  
    self.keep_button:setPosition(self._bg:getContentSize().width/1.4, self._bg:getContentSize().height/2.5 )
    self.keep_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 36})
    self.keep_button:setTitleColor(cc.c3b(255, 255, 255))
    self.keep_button:setTitleText(LANG["classic_keep_text"])
    self.keep_button:addTouchEventListener(submit)
    self.keep_button:setTag(KTags.Keep)
    self._bg:addChild(self.keep_button)
    -- local submit_button = ccui.Button:create( "name_input_btn.png", "name_input_btn.png")
    -- local function submit(sender,type)
	-- 	playSound(GAME_SFXS.buttonClick)
    --     if type~=2 then
    --     	   return
    --     end
        
     
       
    -- end
    -- submit_button:setPosition(self._bg:getContentSize().width/2, self._bg:getContentSize().height/2.5 )
    -- submit_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 60})
    -- submit_button:setTitleColor(cc.c3b(255, 255, 255))
    -- submit_button:setTitleText(LANG["input_confirm_text"] )
    -- submit_button:addTouchEventListener(submit)
    -- self._bg:addChild(submit_button)
	
	
    local close_button = ccui.Button:create( "red_close_btn.png", "red_close_btn.png")
    local function close(sender,type)
       
        if type~=2 then
        	 return
        end
        playSound(GAME_SFXS.buttonClick)
        --self.ownView:start()
      
        self:dismiss()
    end
    close_button:setPosition(self._bg:getContentSize().width-close_button:getContentSize().width/2-30,self._bg:getContentSize().height-125+close_button:getContentSize().height/2+10)
    close_button:setScale(0.8)
    close_button:addTouchEventListener(close)
    self._bg:addChild(close_button)
    self.ownView:addChild(self,100)
end
function ConfimDialog:onTouch(event)

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
function ConfimDialog:dismiss()
    self.delegate:onConfimDialogDismiss()
    self.ownView:removeChild(self)
  
end
return ConfimDialog