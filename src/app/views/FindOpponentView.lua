local FindOpponentView = class("FindOpponentView", cc.load("mvc").ViewBase)
require "app.MessageDispatchCenter"
local scheduler = cc.Director:getInstance():getScheduler()
function FindOpponentView:onCreate()
   --LuaObjcBridge.callStaticMethod("AppController","showBar",nil)
   showGoogleAd_bar()
   MessageDispatchCenter:removeAllMessage(MessageDispatchCenter.MessageType.MATCH_NOTIFY)
   
   self.bg = display.newSprite("bg.png")
  -- self.bg = display.newSprite("tetris_battle_bg.png")
        :move(display.center)
        :addTo(self,-1)
    self.bg:setGlobalZOrder(-2)
    local black= cc.LayerColor:create(cc.c4b(0,0,0,255/4))
    black:setTouchEnabled(false)
    self:addChild(black)
    display.newLayer()
        :onTouch(handler(self, self.onTouch),false,true)
        :addTo(self)
        
    local titlel = ccui.Text:create(LANG["search_op_text"], "fonts/fzzy.ttf", 68)
    titlel:setTextHorizontalAlignment(1)
    titlel:addTo(self)
  --  print(prompt:getStringLength())
    titlel:enableOutline(cc.c4b(116, 54, 26, 255), 4)
   
    titlel:move(cc.p(display.width / 2.0, display.height / 1.4) )
    self.tag_photo = display.newSprite("tag_bg.png") 
    --self.tag_photo:move(cc.p(display.width/2.0,display.height / 3.2)) 
    self.tag_photo:move(cc.p(display.width/2.0,display.height / 2))      
    self.tag_photo:addTo(self)
    self.chips_photo = display.newSprite("coin_chips.png") 
    self.chips_photo:move(cc.p(145,80))      
    self.chips_photo:addTo(self.tag_photo)
    --self.chips_photo:setOpacity(0)
    local group =  group_map[currentSelectedGroup]
    
    self.chiplab = ccui.Text:create(group.prize, "fonts/fzzy.ttf", 68)
   -- self.chiplab:setTextHorizontalAlignment(1)
    self.chiplab:addTo(self.tag_photo)
    self.chiplab:move(cc.p(200, 83) )
    self.chiplab:setAnchorPoint(0,0.5)
    self.chiplab:setTextColor(cc.c4b(253,239,81,255))
    self.chips_photo:setOpacity(0)
    self.chiplab:setOpacity(0)
    self.tag_photo:setOpacity(0)
    --BOUNCEOUT
    
     
      
    self.me_photo = display.newSprite("portrait_bg.png") 
    self.me_photo:move(cc.p(98+self.me_photo:getContentSize().width/2,display.height / 2.0))
    
   
   
    local clip_a = display.newSprite("clip_bg.png")--:move(cc.p(31.5,150)):
    clip_a:move(cc.p(self.me_photo:getContentSize().width/2-16,54+self.me_photo:getContentSize().height/2))
    clip_a:addTo(self.me_photo)
    
    
    
    local avatar = display.newSprite("#profile_1.png")
    stretchSprite(avatar,370,370)
    if self:getApp():getCurrentUser().avatarid then
        avatar:setSpriteFrame(AVATER_TYPE[self:getApp():getCurrentUser().avatarid])
    end
    
    avatar:addTo(self)
    local px1,py1 = self.me_photo:getPosition()
    local ps1 = self.me_photo:getContentSize()
    local offset1 = cc.p(px1-ps1.width/2+31.5,py1-ps1.height/2+150)
    avatar:move(offset1)
    avatar:setAnchorPoint(cc.p(0,0))
    --avatar:move(cc.p(self.me_photo:getContentSize().width/2, self.me_photo:getContentSize().height/1.65))
 
   
    self:setUserInfo(self.me_photo,self:getApp():getCurrentUser())
    self.me_photo:addTo(self)
    
    self.opponent_photo = display.newSprite("portrait_bg.png")       
    self.opponent_photo:move(cc.p(cc.p(self.me_photo:getPosition()).x+self.me_photo:getContentSize().width/2+self.opponent_photo:getContentSize().width/2+40,display.height / 2.0))
    --self.opponent_photo:addTo(self)  
    local scrollView2 = cc.ScrollView:create()
    local function scrollView2DidScroll()
        print("scrollView2DidScroll")
    end
    local function scrollView2DidZoom()
        print("scrollView2DidZoom")
    end
    self.avatar3 = display.newSprite("#profile_default_picture.png")
    self.avatar2 = display.newSprite("#profile_default_picture.png")
    self.avatar1 = display.newSprite("#profile_default_picture.png")
    stretchSprite(self.avatar3,370,370)
    stretchSprite(self.avatar2,370,370)
    stretchSprite(self.avatar1,370,370)
    
    print( self.avatar1:getContentSize().width)
    print( self.avatar1:getContentSize().height)
    self.avatar1:setAnchorPoint(cc.p(0,0))
    self.avatar2:setAnchorPoint(cc.p(0,0))
    self.avatar3:setAnchorPoint(cc.p(0,0))
    local px,py = self.opponent_photo:getPosition()
    local ps = self.opponent_photo:getContentSize()
    local offset = cc.p(px-ps.width/2+31.5,py-ps.height/2+150)--cc.p(31.5,150)
    scrollView2:setViewSize(cc.size(self.avatar1:getContentSize().width,self.avatar1:getContentSize().height))
    scrollView2:setPosition(offset) 
    scrollView2:ignoreAnchorPointForPosition(true)
        --scrollView2:setContainer(avatar2)
   -- scrollView2:updateInset()
    scrollView2:setDirection(1)
    scrollView2:setClippingToBounds(true)
    scrollView2:setBounceable(true)
    scrollView2:setDelegate()  
     
    scrollView2:setAnchorPoint(cc.p(0,0))
    scrollView2:registerScriptHandler(scrollView2DidScroll,0)
    scrollView2:registerScriptHandler(scrollView2DidZoom,1)
    --self.opponent_photo:addChild(scrollView2)
    self:addChild(scrollView2)
    local clip_b = display.newSprite("clip_bg.png")--:move(cc.p(31.5,150)):
    clip_b:move(cc.p(self.opponent_photo:getContentSize().width/2-16,54+self.opponent_photo:getContentSize().height/2))
    clip_b:addTo(self.opponent_photo) 
     
    self.opponent_photo:addTo(self) 
   -- audio.playMusic(GAME_SFXS.matching)
    scrollView2:addChild(self.avatar1) 
    self.avatar1:setPosition(cc.p(0,0))
    self.avatar2:setPosition(cc.p(0,self.avatar1:getContentSize().height))
    self.avatar3:setPosition(cc.p(0,self.avatar1:getContentSize().height*2))
    local subViews = {self.avatar1,self.avatar2,self.avatar3}
    scrollView2:addChild(self.avatar2)
    scrollView2:addChild(self.avatar3)
    local u = 3
    local a = 10
    local v = 0
    local h = 370
    
    self.parse = false
    self.notFrist = false
    function roll(dt)
        --t=t+math.floor(dt)
        if self.parse then
           a = -5
        end
        v = v + u*math.floor(dt)+a
        if v < 10  then
            v = 0 
            if self.notFrist then
                return
            end
        end
       
        if v > 50 then
            v = 50
        end
        
        for i=1,#subViews do 
            subViews[i]:setPosition(0,cc.p(subViews[i]:getPosition()).y-v)
            --print(i,cc.p(subViews[i]:getPosition()).y)
        end
        --print("1:",cc.p(subViews[1]:getPosition()).y)
        --print("2:",cc.p(subViews[2]:getPosition()).y)
        --print("3:",cc.p(subViews[3]:getPosition()).y)
        local minIndex = 1
        local maxIndex = minIndex
        local minY = cc.p(subViews[1]:getPosition()).y
        local maxY = minY
        for i=2,#subViews do 
           if cc.p(subViews[i]:getPosition()).y < minY then
                minY = cc.p(subViews[i]:getPosition()).y
                minIndex = i
           end 
           if cc.p(subViews[i]:getPosition()).y > maxY then
                maxY = cc.p(subViews[i]:getPosition()).y
                maxIndex = i
           end 
        end 
        --print("minY: ",minY)
        --print("maxY: ",maxY)
        if math.abs(minY/370) > 1 then 
           -- print("minY/370: ",(minY/370) )
            subViews[minIndex]:setPosition(0,cc.p(subViews[maxIndex]:getPosition()).y+370)
        end
--        if cc.p(subViews[i]:getPosition()).y>-370 then
--
--        end 
 
        if v == 0 then
            self.notFrist = true
            local mid = 0
            local midindex = 0
            for i=1,#subViews do
                if cc.p(subViews[i]:getPosition()).y >0 then
                    mid = cc.p(subViews[i]:getPosition()).y
                    midindex = i
                end
            end
             
            for i=1,#subViews do
                if cc.p(subViews[i]:getPosition()).y >0 and mid > cc.p(subViews[i]:getPosition()).y then
                    mid = cc.p(subViews[i]:getPosition()).y
                    midindex = i
              
                end
            end
            print("midindex",midindex ) 
           -- print("lv",lv)
            local mv = cc.MoveBy:create(0.01, cc.p(0,-cc.p(subViews[midindex]:getPosition()).y))
           -- local dv = cc.MoveBy:create(0.3,cc.p(0,-cc.p(subViews[midindex]:getPosition()).y))
           -- local uv = cc.MoveBy:create(0.3,cc.p(0,-cc.p(subViews[midindex]:getPosition()).y))
               
            local sp = cc.Sequence:create(mv,cc.CallFunc:create(function () playMusic(GAME_SFXS.matchFound,false)  end))
            subViews[midindex]:runAction(sp) 
             
            for i=1,#subViews do
                if i~= midindex then
                    local m = cc.MoveBy:create(0.01,cc.p(0,-cc.p(subViews[midindex]:getPosition()).y))
                   subViews[i]:runAction(m)
                   
                end
            end
            --subViews[downindex]:runAction(dv)
           -- subViews[upindex]:runAction(uv)
        end
    end
   
    self.cannel_button = ccui.Button:create( "recv_all_btn.png", "recv_all_btn.png")
    local function cannel(sender,type)
       if type~=2 then
           return
       end
       if self.timeTickScheduler then scheduler:unscheduleScriptEntry(self.timeTickScheduler) end
       self:getApp():getMatchManager():cancelMatchmakingOpponent()
       --self:getApp():enterScene("MainView")
       local view = self:getApp():enterScene("MainView")
       view:onLoginReceived()
       hiddenGoogleAd_bar()
      -- LuaObjcBridge.callStaticMethod("AppController","hiddenBar",nil)
       --self.parse = true
        print("cannel")
    end
    self.cannel_button:setPosition(display.width/2,display.height/6)
    self.cannel_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 56})
    self.cannel_button:setTitleColor(cc.c3b(255, 255, 255))
    self.cannel_button:setTitleText(LANG["cannel_text"])
    self.cannel_button:addTouchEventListener(cannel)
    self:addChild(self.cannel_button)
    local function startAnimation()
        if self.timeTickScheduler then scheduler:unscheduleScriptEntry(self.timeTickScheduler) end
        self.timeTickScheduler = scheduler:scheduleScriptFunc(roll,0.001,false) 	
        --audio.playMusic(GAME_SFXS.matching)
        playMusic(GAME_SFXS.matching)
        --playMusic(GAME_SFXS.matchFound,false) 
        
        --audio.playMusic(GAME_SFXS.matchFound,false )
    end
    local function startFind()
        self:getApp():getMatchManager():findOpponentByGroup(currentSelectedGroup)

    end

    local function found(data)
        if data.state == "found" then
            self.remotePlayer = data.players[1]
            self:setRemoteUserInfo(self.opponent_photo,self.remotePlayer)
            self.parse = true
            self.cannel_button:setVisible(false)
           -- self.chips_photo:runAction(cc.FadeIn:create(1))
            local wait = cc.DelayTime:create(0.5*3)
            local enter = cc.CallFunc:create(function() 
            if self.timeTickScheduler then scheduler:unscheduleScriptEntry(self.timeTickScheduler) end
               local view = self:getApp():enterScene("BattleScene") 
               view:setRemoteUserInfo(self.remotePlayer)
               --LuaObjcBridge.callStaticMethod("AppController","hiddenBar",nil)
                hiddenGoogleAd_bar()
            end )
            local function fadeAction()
                  self.chiplab:runAction(cc.FadeIn:create(1))
                  self.chips_photo:runAction(cc.FadeIn:create(1))
            end
            local fi = cc.FadeIn:create(0.2)
            local backIo = cc.EaseBackInOut:create(cc.MoveTo:create(0.9,cc.p(display.width / 2.0, display.height / 3.0)))
            local fadeouts = cc.CallFunc:create(fadeAction)
     
            self.tag_photo:runAction(cc.Sequence:create(wait,fi,backIo,fadeouts,cc.DelayTime:create(1.5),enter))
    
            --self:runAction(cc.Sequence:create(wait,enter))
        end
    end
    
    MessageDispatchCenter:registerMessage(MessageDispatchCenter.MessageType.MATCH_NOTIFY,found)

    local delay = cc.DelayTime:create(0.5)
    local startAnim = cc.CallFunc:create(startAnimation)
    local startFind = cc.CallFunc:create(startFind)
    self:runAction(cc.Sequence:create(delay,startAnim,delay,startFind))
    
    
--    self._bg = display.newSprite("input_name_bg.png")
--        :move(display.center)
--        :addTo(self)
 --  promptText(LANG["prompt_bind_gc_text"],self)
 
--     local clipNode = cc.ClippingNode:create()   
--     self.ss = display.newSprite("search_bg.png")
--                    :move(display.center)
--                    :addTo(clipNode,1)
--    local points = {
--        {0, 0},  -- point 1
--        {500, 0},  -- point 2
--        {500, 500}, -- point 3
--        {0, 500}, -- point 4
--    }

--    local dnode = cc.DrawNode:create()
--    dnode:drawPolygon(points,4, cc.c4f(1, 1, 1, 1), 1, cc.c4f(1, 1, 1, 1) )
--     dnode:setGlobalZOrder(1)
    -- local b_layer = cc.LayerColor:create(cc.c4b(255,255,255,255))
    -- clipNode:addChild(b_layer) 
--    local stencil_layer =  display.newLayer()
--    local stencilChild_layer = display.newSprite("clip_bg.png")
    -- stencil_layer:setContentSize( cc.size(300, 300 ))
   -- stencilChild_layer:setContentSize( cc.size(100, 100 ))
--     stencil_layer:addChild(stencilChild_layer) 
--     stencilChild_layer:move(display.center)
--     dnode:move(display.center)
--     clipNode:setStencil(stencil_layer)
--     clipNode:addChild(stencil_layer) 
     --clipNode:addChild(dnode)
     --clipNode:setInverted(true)
     --clipNode:setAlphaThreshold(0.1)
       
    -- self:addChild(clipNode) 
     --self:addChild(dnode) 
end 
function FindOpponentView:setRemoteUserInfo(contentView,user)
--    local avatar = display.newSprite("#profile_1.png")
--    if self:getApp():getCurrentUser().avatarid then
--        avatar:setSpriteFrame(AVATER_TYPE[user.avatarid])
--    end
   -- avatar:addTo(contentView)
    local nameLab = cc.Label:createWithTTF(user.nickname, "fonts/fzzy.ttf", 54)
        :addTo(contentView)    
    nameLab:setTextColor(cc.c4b(116,54,25,255))
    nameLab:move(cc.p(self.me_photo:getContentSize().width/2,nameLab:getContentSize().height+15 ))
    --avatar:move(cc.p(self.me_photo:getContentSize().width/2, self.me_photo:getContentSize().height/1.65))
    local levelbg = display.newSprite("portrait_level_bg.png")
        :addTo(contentView) 

    levelbg:move(cc.p(40+levelbg:getContentSize().width/2,self.me_photo:getContentSize().height-levelbg:getContentSize().height/2 ))
    local levelLab = cc.Label:createWithTTF(user.level, "fonts/fzzy.ttf", 36)
        :addTo(levelbg)    
    levelLab:setTextColor(cc.c4b(116,54,25,255))
    levelLab:move(cc.p(levelbg:getContentSize().width/2,levelLab:getContentSize().height ))
    
    
    
    
    
    
  

end
function FindOpponentView:setUserInfo(contentView,user)
    -- local clip_a = display.newSprite("clip_bg.png")--:move(cc.p(31.5,150)):
    -- clip_a:move(cc.p(contentView:getContentSize().width/2-16,54+contentView:getContentSize().height/2))
    -- clip_a:addTo(contentView) 
   
    local levelbg = display.newSprite("portrait_level_bg.png")
        :addTo(contentView) 
     
    levelbg:move(cc.p(40+levelbg:getContentSize().width/2,self.me_photo:getContentSize().height-levelbg:getContentSize().height/2 ))
    local levelLab = cc.Label:createWithTTF(user.level, "fonts/fzzy.ttf", 36)
        :addTo(levelbg)    
    levelLab:setTextColor(cc.c4b(116,54,25,255))
    levelLab:move(cc.p(levelbg:getContentSize().width/2,levelLab:getContentSize().height ))
   
  
    local nameLab = cc.Label:createWithTTF(user.nickname, "fonts/fzzy.ttf", 54)
        :addTo(contentView)   
    if self:getApp():getCurrentUser().username == user.username  then
        nameLab:setString(LANG["league_me_text"])
    end 
    nameLab:setTextColor(cc.c4b(116,54,25,255))
    nameLab:move(cc.p(self.me_photo:getContentSize().width/2,nameLab:getContentSize().height+15 ))
    
end
function FindOpponentView:onTouch(event)

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
 
return FindOpponentView