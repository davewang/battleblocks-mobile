local NameSetView = class("NameSetView",cc.Node)
 
 
function NameSetView:ctor(view)
	self.ownView = view
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255/2))
    self.bg:setTouchEnabled(false)
    self:addChild(self.bg)
    display.newLayer()
        :onTouch(handler(self, self.onTouch),false,true)
        :addTo(self)
    self._bg = display.newSprite("input_name_bg.png")
        :move(display.center)
        :addTo(self)
 
	  local function textFieldEvent(sender, eventType)
         print("textFieldEvent:",eventType)
         local attach_with_ime = 0
          local detach_with_ime = 1
           local insert_text = 2
           local delete_backward = 3
        if eventType ==  attach_with_ime then
            local textField = sender
        elseif eventType ==  detach_with_ime then
            local textField = sender
        elseif eventType ==  insert_text then
            local textField = sender
 
        elseif eventType == delete_backward then
            local textField = sender
        end
    end
        
    local inputBg = ccui.ImageView:create()
    inputBg:loadTexture("text_field_bg.png")
    --inputBg:setAnchorPoint(cc.p(0,0))
    inputBg:setPosition(cc.p(self._bg:getContentSize().width / 2.0, self._bg:getContentSize().height / 1.5))
   -- inputBg:setName("uread1") 
    self._bg:addChild(inputBg)   
        
        
    local textField = ccui.TextField:create()
    textField:setMaxLengthEnabled(true)
    textField:setMaxLength(8)
    textField:setTouchEnabled(true)
    textField:setFontName("fonts/fzzy.ttf")
    textField:setFontSize(46)
    textField:setPlaceHolderColor(cc.c4b(225, 225, 225,255))
    
    textField:setTextColor(cc.c4b(25, 25, 25,255))
    textField:setPlaceHolder(LANG["input_nick_text"])
    textField:setPosition(cc.p(self._bg:getContentSize().width / 2.0, self._bg:getContentSize().height / 1.5))
    textField:addEventListener(textFieldEvent) 
    self._bg:addChild(textField) 
    textField:attachWithIME()
    --setDetachWithIME
    --textField:setDetachWithIME(false)
    local submit_button = ccui.Button:create( "name_input_btn.png", "name_input_btn.png")
    local function submit(sender,type)
         
         print(type )
         if type~=2 then
        	   return
        end
        textField:didNotSelectSelf()
        playSound(GAME_SFXS.buttonClick)
       local content = textField:getString()
       if string.len(content)>2 then
            self.ownView:getApp():showLoadingInView(self.ownView)
            
            self.ownView.app_.client:request("editnikename",{nickname = content} , function(obj)  
                               --print("obj.result ", obj.result )
                              -- self.ownView:getApp():hideLoadingView()
         
                               if obj.result then
                                   --print("dispatchMessage ", obj.result )
                                   --MessageDispatchCenter:dispatchMessage(MessageDispatchCenter.MessageType.REFRESH_USERINFO)

                                   local call2 = cc.CallFunc:create(function ()
                                       self.ownView:getApp():hideLoadingView()
                                       local view = self.ownView.app_:enterScene("MainView")
                                       view:refreshUserInfo()

                                   end)
                                   local sp = cc.Sequence:create(cc.DelayTime:create(2.6),call2)
                                   self.ownView:runAction(sp)
                               else
                                   self.ownView:getApp():hideLoadingView()
                                   promptText(LANG["prompt_name_text"],self)
                               end
             end)
       else
          promptText(LANG["prompt_short_name_text"],self)
       end
       
    end
    submit_button:setPosition(self._bg:getContentSize().width/2, self._bg:getContentSize().height/2.5 )
    submit_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 60})
    submit_button:setTitleColor(cc.c3b(255, 255, 255))
    submit_button:setTitleText(LANG["input_confirm_text"] )
    submit_button:addTouchEventListener(submit)
    self._bg:addChild(submit_button)
	
	
    local close_button = ccui.Button:create( "red_close_btn.png", "red_close_btn.png")
    local function close()
          print("close-----")
         -- textField:setDetachWithIME(true)
           --textField:attachWithIME()
          --textField:didNotSelectSelf()
      --  self:dismiss()
      --  playSound(GAME_SFXS.buttonClick)
    end
    close_button:setPosition(self._bg:getContentSize().width-close_button:getContentSize().width/2-60,self._bg:getContentSize().height-145+close_button:getContentSize().height/2+10)

    close_button:addTouchEventListener(close)
    self._bg:addChild(close_button)
    self.ownView:addChild(self,100)
end
function NameSetView:onTouch(event)

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
function NameSetView:dismiss()
   
    self.ownView:removeChild(self)
end
return NameSetView