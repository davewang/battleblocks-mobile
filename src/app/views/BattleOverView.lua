local BattleOverView = class("BattleOverView",cc.Node)
local KTags = { Back = 100,
                AddFriend = 101,
                Share = 102,
                Again = 103
               }
function BattleOverView:ctor(view)
    self.ownView = view
	
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,215))
    self.bg:setTouchEnabled(false)
    self:addChild(self.bg)
	
    display.newLayer()
        :onTouch(handler(self, self.onTouch),false,true)
        :addTo(self)
 
    self.me_photo = display.newSprite("portrait_bg.png")--("portrait_bg.png") 
    self.me_photo:move(cc.p(98+self.me_photo:getContentSize().width/2,display.height / 1.7))    
    self.avatar0 = display.newSprite("#profile_default_picture.png")
    stretchSprite(self.avatar0,361,370)
    
    local px,py = self.me_photo:getPosition()
    local ps = self.me_photo:getContentSize()
    local offset = cc.p(px-ps.width/2+31.5,py-ps.height/2+150)--cc.p(31.5,150)
     
    self.avatar0:setPosition(offset) 
    self.avatar0:setAnchorPoint(cc.p(0,0))
    self:addChild(self.avatar0)
    self.me_photo:addTo(self)
    local clip_a = display.newSprite("clip_bg.png")--:move(cc.p(31.5,150)):
    clip_a:move(cc.p(self.me_photo:getContentSize().width/2-16,54+self.me_photo:getContentSize().height/2))
    clip_a:addTo(self.me_photo) 
    
    self.me_photonameLab = cc.Label:createWithTTF(self.ownView:getApp():getCurrentUser().nickname, "fonts/fzzy.ttf", 54)
        :addTo(self.me_photo)   
    self.me_photonameLab:setString(LANG["league_me_text"])
    -- if self.ownView:getApp():getCurrentUser().username == user.username  then
    --     nameLab:setString(LANG["league_me_text"])
    -- end 
     self.me_photonameLab:setTextColor(cc.c4b(116,54,25,255))
     self.me_photonameLab:move(cc.p(self.me_photo:getContentSize().width/2,self.me_photonameLab:getContentSize().height+15 ))
    --avatar:move(cc.p(self.me_photo:getContentSize().width/2, self.me_photo:getContentSize().height/1.65))
    local levelbg1 = display.newSprite("portrait_level_bg.png")
        :addTo( self.me_photo) 
     
    levelbg1:move(cc.p(40+levelbg1:getContentSize().width/2,self.me_photo:getContentSize().height-levelbg1:getContentSize().height/2 ))
    self.me_photolevelLab = cc.Label:createWithTTF(self.ownView:getApp():getCurrentUser().level, "fonts/fzzy.ttf", 36)
        :addTo(levelbg1)    
    self.me_photolevelLab:setTextColor(cc.c4b(116,54,25,255))
    self.me_photolevelLab:move(cc.p(levelbg1:getContentSize().width/2,self.me_photolevelLab:getContentSize().height ))
    
    
   
    self:setUserInfo(self.me_photo,self.ownView:getApp():getCurrentUser())
    
    
    self.opponent_photo = display.newSprite("portrait_bg.png")       
    self.opponent_photo:move(cc.p(cc.p(self.me_photo:getPosition()).x+self.me_photo:getContentSize().width/2+self.opponent_photo:getContentSize().width/2+40,display.height / 1.7))
    --self.opponent_photo:addTo(self) 
    
     
     
   
    self.avatar1 = display.newSprite("#profile_default_picture.png")
    stretchSprite(self.avatar1,361,370)
    
    local px,py = self.opponent_photo:getPosition()
    local ps = self.opponent_photo:getContentSize()
    local offset = cc.p(px-ps.width/2+31.5,py-ps.height/2+150)--cc.p(31.5,150)
     
    self.avatar1:setPosition(offset) 
    self.avatar1:setAnchorPoint(cc.p(0,0))
    self:addChild(self.avatar1)
   
    local clip_b = display.newSprite("clip_bg.png")--:move(cc.p(31.5,150)):
    clip_b:move(cc.p(self.opponent_photo:getContentSize().width/2-16,54+self.opponent_photo:getContentSize().height/2))
    clip_b:addTo(self.opponent_photo) 
    self.opponent_photo:addTo(self) 
    
    
    self.opponentnameLab = cc.Label:createWithTTF(self.ownView.remotePlayer.nickname, "fonts/fzzy.ttf", 54)
        :addTo(self.opponent_photo)    
    self.opponentnameLab:setTextColor(cc.c4b(116,54,25,255))
    self.opponentnameLab:move(cc.p(self.opponent_photo:getContentSize().width/2,self.opponentnameLab:getContentSize().height+15 ))
    
    local levelbg = display.newSprite("portrait_level_bg.png")
        :addTo(self.opponent_photo) 

    levelbg:move(cc.p(40+levelbg:getContentSize().width/2,self.opponent_photo:getContentSize().height-levelbg:getContentSize().height/2 ))
    self.opponentlevelLab = cc.Label:createWithTTF(self.ownView.remotePlayer.level, "fonts/fzzy.ttf", 36)
        :addTo(levelbg)    
    self.opponentlevelLab:setTextColor(cc.c4b(116,54,25,255))
    self.opponentlevelLab:move(cc.p(levelbg:getContentSize().width/2,self.opponentlevelLab:getContentSize().height ))
    
    
 

    
    self:setRemoteUserInfo(self.opponent_photo,self.ownView.remotePlayer)
  
   
   
   
    local function action(sender,type)
       if type~=2 then
           return
       end
       --print(sender.getTag())
       if sender:getTag() ==  KTags.Back then
            
          --  self.ownView:getApp():enterScene("MainView")
             local view = self.ownView:getApp():enterScene("MainView")
            view:onLoginReceived()
    
       elseif  sender:getTag() ==  KTags.Again then
            self.ownView:getApp():enterScene("FindOpponentView")  
       elseif  sender:getTag() ==  KTags.AddFriend then
            self.ownView:getApp():showLoadingInView(self,LANG["add_friend_text"])
            self.ownView:getApp().client:request("addfriend",{friendname = self.ownView.remotePlayer.username} , function(obj)  
                               --print("obj.result ", obj.result )
                               self.ownView:getApp():hideLoadingView()
                               
                               if obj.result then
                                   sender:setOpacity(0)
                                   promptText(LANG["add_friend_success_text"],self)
                                   --self:loadData(1001)
                               else
                                   promptText(LANG["add_friend_fail_text"],self)
                               end
             end)
       elseif  sender:getTag() ==  KTags.Share then
            --LuaObjcBridge.callStaticMethod("FacebookManager","post",{name=LANG["send_message_app_name_text"],title=LANG["send_message_title_text"],message=LANG["send_message_message_text"]})  
            facebookPost()
       end
      
       --self.parse = true
        print("cannel")
    end
   
   
    self.addFriend_button = ccui.Button:create( "op_add_friend_btn.png", "op_add_friend_btn.png")
    self.addFriend_button:setPosition(390-10,539-35)
    self.addFriend_button:addTouchEventListener(action)
    self.addFriend_button:setTag(KTags.AddFriend)
    self.addFriend_button:setOpacity(0)
    self.opponent_photo:addChild(self.addFriend_button)
    self.ownView:getApp().client:request("isfriend",{friendname = self.ownView.remotePlayer.username} , function(obj)  
                               --print("obj.result ", obj.result )
                             
                               
                               if obj.result then
                                   --self.addFriend_button:setOpacity(0)
                                   --promptText(LANG["add_friend_success_text"],self)
                                   --self:loadData(1001)
                               else
                                  self.addFriend_button:setOpacity(255)
                                  -- promptText(LANG["add_friend_fail_text"],self)
                               end
             end)
     
    self.cannel_button = ccui.Button:create( "confim_lose_btn.png", "confim_lose_btn.png")
  
    self.cannel_button:setPosition(display.width/2,display.height/4)
    self.cannel_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 36})
    self.cannel_button:setTitleColor(cc.c3b(255, 255, 255))
    self.cannel_button:setTitleText(LANG["return_text"])
    self.cannel_button:addTouchEventListener(action)
    self.cannel_button:setTag(KTags.Back)
    self:addChild(self.cannel_button)
     
    self.shared_button = ccui.Button:create( "share_btn.png", "share_btn.png")
    self.shared_button:setPosition(98+self.shared_button:getContentSize().width/2,display.height/2.5)
    self.shared_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 46})
    self.shared_button:setTitleColor(cc.c3b(255, 255, 255))
    self.shared_button:setTitleText(LANG["shared_text"])
    self.shared_button:addTouchEventListener(action)
    self.shared_button:setTag(KTags.Share)
    self:addChild(self.shared_button)  
     
    self.again_button = ccui.Button:create( "try_again_btn.png", "try_again_btn.png")
    self.again_button:setPosition(display.width/3+self.again_button:getContentSize().width,display.height/2.5)
    self.again_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 46})
    self.again_button:setTitleColor(cc.c3b(255, 255, 255))
    self.again_button:setTitleText(LANG["try_again_text"])
    self.again_button:addTouchEventListener(action)
    self.again_button:setTag(KTags.Again)
    self:addChild(self.again_button)  
     
     
     
    self.win_board_photo = display.newSprite("portrait_win_board.png")  
    local p_x,p_y -- = self.me_photo:getPosition() 
    local p_w --= self.me_photo:getContentSize().width 
    local p_h --= self.me_photo:getContentSize().height
    if self.ownView.success == true then
       p_x,p_y = self.me_photo:getPosition() 
       p_w = self.me_photo:getContentSize().width 
       p_h = self.me_photo:getContentSize().height
    else 
       p_x,p_y = self.opponent_photo:getPosition() 
       p_w = self.opponent_photo:getContentSize().width 
       p_h = self.opponent_photo:getContentSize().height
    end
   
    self.win_board_photo:setPosition(cc.p(p_x,p_y))
    self:addChild(self.win_board_photo)     
    
    
    -- local function found(data)
    --     if data.state == "found" then
    --         self.remotePlayer = data.players[1]
    --         self:setRemoteUserInfo(self.opponent_photo,self.remotePlayer)
    --         self.parse = true
    --         local wait = cc.DelayTime:create(0.5*3)
    --         local enter = cc.CallFunc:create(function() 
    --         if self.timeTickScheduler then scheduler:unscheduleScriptEntry(self.timeTickScheduler) end
            
               
    --         end )
    --         self:runAction(cc.Sequence:create(wait,enter))
    --     end
    -- end
   -- MessageDispatchCenter:registerMessage(MessageDispatchCenter.MessageType.MATCH_NOTIFY,found)

    -- local delay = cc.DelayTime:create(0.5)
    -- local startAnim = cc.CallFunc:create(startAnimation)
    -- local startFind = cc.CallFunc:create(startFind)
    -- self:runAction(cc.Sequence:create(delay,startAnim,delay,startFind))
    
    local dialog =  cc.Label:createWithTTF("WIN", "fonts/CGF Locust Resistance.ttf", 80)--display.newSprite("#profile_default_picture.png")
    dialog:setTextColor(cc.c4b(255,0,0,255))
    dialog:setPosition(p_x, display.top + dialog:getContentSize().height / 2 + 40)--display.cx
    self:addChild(dialog)
    local function winEff()
           local emitter = cc.ParticleSystemQuad:create(GAME_PARTICLES.win)
           emitter:setAutoRemoveOnFinish(true)
           -- if type == 0 then
            --   emitter:setStartSize(5)
            --   emitter:setEndSize(5)
            -- else
            --   emitter:setStartSize(40)
            --   emitter:setEndSize(40)
            -- end
             emitter:setEndSize(180)
            emitter:setPosition(cc.p(p_x,display.height/1.5))
            self:addChild(emitter,2001)
            transition.moveTo(dialog, {time = 0.7, x = p_x,y = p_y + p_h/2 + dialog:getContentSize().height / 2 + 40, easing = "BOUNCEOUT"})
    end 
    local delay = cc.DelayTime:create(0.5)
    local startWinEff = cc.CallFunc:create(winEff)
    self:runAction(cc.Sequence:create(delay,startWinEff))
    self.ownView:addChild(self,100)
end
 
  
function BattleOverView:onExit()

    print("BattleOverView exit")
end
function BattleOverView:setRemoteUserInfo(contentView,user)
    if user.avatarid then
        self.avatar1:setSpriteFrame(AVATER_TYPE[user.avatarid])
         stretchSprite(self.avatar1,361,370)
    end
    self.opponentnameLab:setString(user.nickname)
    self.opponentlevelLab:setString(user.level)
end
function BattleOverView:setUserInfo(contentView,user)
    if user.avatarid then
        self.avatar0:setSpriteFrame(AVATER_TYPE[user.avatarid])
         stretchSprite(self.avatar0,361,370)
    end
end
function BattleOverView:dismiss()
 
    playSound(GAME_SFXS.buttonClick)
    self:onExit()
    self.ownView:removeChild(self)
end
function BattleOverView:onTouch(event)

    local label = string.format("swipe: %s", event.name)

    if event.name == 'began' then
        --print("began")
        return true
    elseif event.name == 'moved' then

    --  print("moved")
    elseif event.name == 'ended' then
        --print("ended")
       -- self:dismiss()
    end

end
return BattleOverView
