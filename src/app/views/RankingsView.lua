local RankingsView = class("RankingsView",cc.Node)
local Lab_Tag = 100
local friendranks = {}
local worldranks = {}
local scoreranks = {}
local gg = 15
local function getHeadView(type)
    local bg = display.newSprite("ranking_head.png")
    local goal_lab = cc.Label:createWithTTF(LANG["league_head_lab_rank_text"], "fonts/fzzy.ttf", 44)
        :addTo(bg)
    goal_lab:move(42,bg:getContentSize().height/2)
    goal_lab:setColor(cc.c4b(211, 113, 36, 255))

    local nick_lab = cc.Label:createWithTTF(LANG["league_head_lab_nickname_text"], "fonts/fzzy.ttf", 44)
        :addTo(bg)
    nick_lab:move( gg+180,bg:getContentSize().height/2)
    nick_lab:setColor(cc.c4b(211, 113, 36, 255))

    local level_lab = cc.Label:createWithTTF(LANG["league_head_lab_level_text"], "fonts/fzzy.ttf", 44)
        :addTo(bg)
    level_lab:move(gg*2+180*2,bg:getContentSize().height/2)
    level_lab:setColor(cc.c4b(211, 113, 36, 255))

    local rate_lab = cc.Label:createWithTTF(LANG["league_head_lab_winrate_text"], "fonts/fzzy.ttf", 44)
        :addTo(bg)
    rate_lab:move(gg*3+180*3,bg:getContentSize().height/2)
    rate_lab:setColor(cc.c4b(211, 113, 36, 255))
    if type==1 then
        rate_lab:setString(LANG["league_head_lab_level_text"])
        level_lab:setString(LANG["league_head_lab_score_text"])
    end
    goal_lab:setAnchorPoint(cc.p(0,0.5))
    nick_lab:setAnchorPoint(cc.p(0,0.5))
    
    level_lab:setAnchorPoint(cc.p(0,0.5))
    rate_lab:setAnchorPoint(cc.p(0,0.5))
    return bg
end

function RankingsView:ctor(ownView)
    print("RankingsView ctor")
    self.ownView = ownView
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255/2))
    self.bg:setTouchEnabled(false)
    self:addChild(self.bg)
    display.newLayer()
        :onTouch(handler(self, self.onTouch),false,true)
        :addTo(self)

    self.rank_bg = display.newSprite("ranking_a_bg.png")
    :move(cc.p(display.cx,display.cy-40) )
    :addTo(self)

    self.headview1 = getHeadView(0)
    self.headview1:setPosition(cc.p(72+self.headview1:getContentSize().width/2,self.rank_bg:getContentSize().height-335-self.headview1:getContentSize().height/2))
    self.rank_bg:addChild(self.headview1)

    self.headview2 = getHeadView(1)
    self.headview2:setPosition(cc.p(72+self.headview2:getContentSize().width/2,self.rank_bg:getContentSize().height-335-self.headview2:getContentSize().height/2))
    self.rank_bg:addChild(self.headview2)
    self.headview2:setVisible(false)

    local titlel = cc.Label:createWithTTF(LANG["league_title_text"], "fonts/fzzy.ttf", 68)
        :addTo(self.rank_bg)
    titlel:enableOutline(cc.c4b(233, 0, 0, 255), 4)
    titlel:setPosition(cc.p(self.rank_bg:getContentSize().width/2,self.rank_bg:getContentSize().height-32-titlel:getContentSize().height/2))
    local friend_button = ccui.Button:create("ranking_tab_down.png", "ranking_tab_down.png")

    local rank_button = ccui.Button:create("ranking_tab_up.png", "ranking_tab_up.png")

    local score_button = ccui.Button:create("ranking_tab_up.png", "ranking_tab_up.png")

    local close_button = ccui.Button:create( "red_close_btn.png", "red_close_btn.png")




    friend_button:setTag(1001)
    score_button:setTag(1003)
    rank_button:setTag(1002)
    close_button:setTag(1004)
    self.selected = friend_button
    friend_button:setPosition(friend_button:getContentSize().width/2+72,self.rank_bg:getContentSize().height-317+friend_button:getContentSize().height/2)
    rank_button:setPosition(friend_button:getPositionX()+rank_button:getContentSize().width+3,self.rank_bg:getContentSize().height-317+friend_button:getContentSize().height/2)
    score_button:setPosition(rank_button:getPositionX()+score_button:getContentSize().width+3,self.rank_bg:getContentSize().height-317+friend_button:getContentSize().height/2)
    close_button:setPosition(910+close_button:getContentSize().width/2 -10,self.rank_bg:getContentSize().height-177+close_button:getContentSize().height/2-10)




    friend_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 46})
    friend_button:setTitleColor(cc.c3b(105, 32, 9))
    friend_button:setTitleText(LANG["league_friend_text"] )

    rank_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 46})
    rank_button:setTitleColor(cc.c3b(211, 113, 36))
    rank_button:setTitleText(LANG["league_world_text"])

    score_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 46})
    score_button:setTitleColor(cc.c3b(211, 113, 36))
    score_button:setTitleText(LANG["league_score_text"])
    local function listViewEvent(sender, eventType)
        --0 start 1 end
        if eventType==1 and self.selected == friend_button then
            local rank =  friendranks[sender:getCurSelectedIndex()+1]
            if self:isSelf(rank.username) then
                  facebookPost()
                --LuaObjcBridge.callStaticMethod("FacebookManager","post",{name=LANG["send_message_app_name_text"],title=LANG["send_message_title_text"],message=LANG["send_message_message_text"]})  
   
                --  LuaObjcBridge.callStaticMethod("FacebookManager","invite",{message=LANG["invite_message_text"],title=LANG["invite_title_text"]})
            else
                 -- LuaObjcBridge.callStaticMethod("FacebookManager","send",{message=string.format(LANG["send_coin_gift_message_text"],100),title=LANG["send_coin_gift_title_text"],sendId="861193893957676"})
           
            end    
        end
--        print("select child index = ",sender:getCurSelectedIndex(),eventType)
--
    end

    local function scrollViewEvent(sender, evenType)

    end

    self.listView = ccui.ListView:create()
    -- set list view ex direction
    self.listView:setDirection(1)
    self.listView:setBounceEnabled(true)
    --listView:setBackGroundImage("starfield.jpg")
    --self.listView:setBackGroundImage("starfield.jpg")
    self.listView:setBackGroundImageScale9Enabled(true)
    self.listView:setContentSize(cc.size(850,  950))
    self.listView:setPosition(cc.p(80,300))
--
    --self.listView:setContentSize(cc.size(display.width-100,  450))

    --self.listView:setPosition(cc.p(210,300 ))

    self.listView:addEventListener(listViewEvent)
    self.listView:addScrollViewEventListener(scrollViewEvent)
    self.rank_bg:addChild(self.listView)
    local function loginOk()
    end
    local function connectfb(ref, type)
        if type == 2 then
            return 
        end
       -- LuaObjcBridge.callStaticMethod("FacebookManager","userInfo",{callback=loginOk})  
        facebookInvite()
       -- LuaObjcBridge.callStaticMethod("FacebookManager","invite",{message=LANG["invite_message_text"],title=LANG["invite_title_text"]})
           
       -- LuaObjcBridge.callStaticMethod("FacebookManager","post",{name=LANG["send_message_app_name_text"],title=LANG["send_message_title_text"],message=LANG["send_message_message_text"]})  
    end
    local fb_button = ccui.Button:create("fb_btn.png", "fb_btn.png")
    fb_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 34})
    fb_button:setTitleColor(cc.c3b(255, 255, 255))
    fb_button:setTitleText(LANG["conn_fb_btn_text"] )
    fb_button:addTouchEventListener(connectfb)
     
    fb_button:move(cc.p(display.width/2,display.height/9.5))
    self.rank_bg:addChild(fb_button)
    --self:addChild(fb_button)
    fb_button:getTitleRenderer():move(cc.p(0,0))

    local function createMode()
       -- local default_button = ccui.Button:create("ranking_head.png", "ranking_head.png")
        local bg = ccui.Layout:create()
        bg:setTouchEnabled(true)
        bg:setContentSize(cc.size(850,100))

        local goal_lab = ccui.Text:create("", "fonts/fzzy.ttf", 52)--cc.Label:createWithTTF("1", "fonts/fzzy.ttf", 52)
   
        bg:addChild(goal_lab)
        goal_lab:setContentSize(cc.size(100,goal_lab:getContentSize().height))
        goal_lab:setPosition(cc.p(48,bg:getContentSize().height/2))
        --goal_lab:move(42,bg:getContentSize().height/2)
        goal_lab:setColor(cc.c4b(105, 32, 9, 255))

        local nick_lab = ccui.Text:create("", "fonts/fzzy.ttf", 42)
            --:addTo(bg)
        bg:addChild(nick_lab)
        nick_lab:setContentSize(cc.size(170,nick_lab:getContentSize().height))
        nick_lab:setPosition( cc.p(gg+170,bg:getContentSize().height/2))
        nick_lab:setColor(cc.c4b(105, 32, 9, 255))

        local level_lab = ccui.Text:create("", "fonts/fzzy.ttf", 52)
            --:addTo(bg)
        bg:addChild(level_lab)
        level_lab:setContentSize(cc.size(170,level_lab:getContentSize().height))

        level_lab:setPosition( cc.p(gg*2+180*2,bg:getContentSize().height/2))
        level_lab:setColor(cc.c4b(105, 32, 9, 255))

        local rate_lab = ccui.Text:create("", "fonts/fzzy.ttf", 52)
            --:addTo(bg)
        bg:addChild(rate_lab)
        rate_lab:setContentSize(cc.size(170,rate_lab:getContentSize().height))

        rate_lab:setPosition( cc.p(gg*3+180*3,bg:getContentSize().height/2))
        rate_lab:setColor(cc.c4b(105, 32, 9, 255))

        goal_lab:setAnchorPoint(cc.p(0,0.5))
        nick_lab:setAnchorPoint(cc.p(0,0.5))
        level_lab:setAnchorPoint(cc.p(0,0.5))
        rate_lab:setAnchorPoint(cc.p(0,0.5))
        goal_lab:setName("item1")
        nick_lab:setName("item2")
        level_lab:setName("item3")
        rate_lab:setName("item4")
        local lineView = ccui.ImageView:create()
        lineView:loadTexture("line.png")
        lineView:setAnchorPoint(cc.p(0,0))
        lineView:setPosition(cc.p(30,0))
        bg:addChild(lineView)




        return bg
    end
     -- create model
     self.listView:setItemModel(createMode())





    local function selected(current)
        self.selected:setTitleColor(cc.c3b(211, 113, 36))
        self.selected:loadTextureNormal("ranking_tab_up.png")
        self.selected = current
        self.selected:setTitleColor(cc.c3b(105, 32, 9))
        self.selected:loadTextureNormal("ranking_tab_down.png")
    end

    local function callback(ref, type)
        if type~=2 then
        	   return
        end
        local t = ref:getTag()
            if t==1001 then
            playSound(GAME_SFXS.buttonClick)
            selected(ref)
            if #friendranks==0 then
                self:loadData(t)
            else
                self:synFriendsRankData(friendranks)
            end
            self.headview2:setVisible(false)
            self.headview1:setVisible(true)
        	elseif t==1002 then
            playSound(GAME_SFXS.buttonClick)
            selected(ref)
            if #worldranks==0 then
                self:loadData(t)
            else
                self:synRankData(worldranks)
            end
            self.headview2:setVisible(false)
            self.headview1:setVisible(true)
        	elseif t==1003 then
            playSound(GAME_SFXS.buttonClick)
            selected(ref)
            if #scoreranks==0 then
                self:loadData(t)
            else
                self:synScoreData(scoreranks)
            end
            self.headview2:setVisible(true)
            self.headview1:setVisible(false)
        	elseif t==1004 then
        	     self:dismiss()
        end
        print("type ",type)

    end
    friend_button:addTouchEventListener(callback)
    rank_button:addTouchEventListener(callback)
    score_button:addTouchEventListener(callback)
    close_button:addTouchEventListener(callback)
    self.rank_bg:addChild(friend_button)
    self.rank_bg:addChild(rank_button)
    self.rank_bg:addChild(score_button)
    self.rank_bg:addChild(close_button)

    --display.newLayer()
    --    :onTouch(handler(self, self.onTouch),false,true)
     --   :addTo(self)
    --callback(self)
    self.ownView:addChild(self,100)
    if #friendranks==0 then
    	    self:loadData(1001)
    	else
        self:synFriendsRankData(friendranks)
    end
     showGoogleAd_bar()

end
function RankingsView:loadData(type)
      if type == 1001 then
        self.ownView.app_.client:request("friendrank",{} , function(obj)
                friendranks = obj.ranks
--                for k,v in ipairs(obj.ranks) do
--                    print("k,v ",k,v)
--                end
                --print(string.format("ranks %d",#obj.ranks))
                if friendranks == nil then
                	   friendranks = {}
                end
                self:synFriendsRankData(friendranks)

        end)
      elseif type == 1002 then
          self.ownView.app_.client:request("worldrank",{} , function(obj)

                worldranks = obj.ranks
                --print(string.format("ranks %d",#obj.ranks))
                if worldranks == nil then
                    worldranks = {}
                end
                self:synRankData(worldranks)
           end)
      elseif type == 1003 then
        self.ownView.app_.client:request("scorerank",{} , function(obj)
                scoreranks=obj.ranks
                if scoreranks == nil then
                      scoreranks = {}
                end
                --print(string.format("ranks %d",#obj.ranks))
                self:synScoreData(scoreranks)

        end)
      end
      
      -- LuaObjcBridge.callStaticMethod("AppController","showBar",nil)
      
--    self.app_.client:request("friendrank",{} , function(obj)
--
--            print(string.format("ranks %d",#obj.ranks))
--            for k,v in ipairs(obj.ranks) do
--                print("k,v ",k,v)
--            end
--
--    end)
--    self.app_.client:request("scorerank",{} , function(obj)
--
--            print(string.format("ranks %d",#obj.ranks))
--            for k,v in ipairs(obj.ranks) do
--                print("k,v ",k,v)
--            end
--
--    end)
--    self.app_.client:request("worldrank",{} , function(obj)
--
--            print(string.format("ranks %d",#obj.ranks))
--            for k,v in ipairs(obj.ranks) do
--                print("k,v ",k,v)
--            end
--
--    end)
end
function RankingsView:isSelf(username)
    if self.ownView.app_:getCurrentUser().username == username then
        return true
    end
    return false
end
function RankingsView:synScoreData(ranks)
    self.listView:removeAllItems()
    for i = 1,#ranks do
        self.listView:pushBackDefaultItem()
    end

    local items_count  = table.getn(self.listView:getItems())
    for i = 1,items_count do
        local item = self.listView:getItem(i - 1)


        local item1 = item:getChildByName("item1")
        item1:setString(i)


        local item2 = item:getChildByName("item2")
        if self:isSelf(ranks[i].username) then
            item2:setString(LANG["league_me_text"])
            item2:setColor(cc.c3b(233, 0, 0))
        else
            
            item2:setString(ranks[i].nickname)
        end

        local item3 = item:getChildByName("item3")
        
        local num1,unit = coin_to_string(ranks[i].coin)
        item3:setString(tostring(num1)..unit)
        --item3:setString(string.format("%d",ranks[i].score))
        local item4 = item:getChildByName("item4")
        item4:setString(string.format("LV %d",ranks[i].level))

--        local button = item:getChildByName("Title Button")
--        local index = self.listView:getIndex(item)
--        button:setTitleText("dave")
    end
    if #ranks==0 then


        self.noDataLabel =  ccui.Text:create(string.format("                   %s",LANG["no_data"]), "fonts/fzzy.ttf", 68)
        self.noDataLabel:setPosition(cc.p(200,self.listView:getContentSize().height/2))
        self.noDataLabel:setColor(cc.c4b(105, 32, 9, 255))
        self.listView:addChild(self.noDataLabel)
    end

end
function RankingsView:synFriendsRankData(ranks)
    self.listView:removeAllItems()




    for i = 1,#ranks do
        self.listView:pushBackDefaultItem()
    end
    --listView:removeAllChildren()
    local items_count  = table.getn(self.listView:getItems())
    print("items_count ",items_count)
    
     local function sendGift(ref, type)
        if type ~= 2 then
            return 
        end
       -- LuaObjcBridge.callStaticMethod("FacebookManager","userInfo",{callback=loginOk})  
        print(type)
         playSound(GAME_SFXS.buttonClick)
        self.ownView:getApp():showLoadingInView(self.ownView)
             print(ref.rank.username)
            self.ownView.app_.client:request("sendgift",{friendname = ref.rank.username} , function(obj)  
                               --print("obj.result ", obj.result )
                               self.ownView:getApp():hideLoadingView()
                              
                               if obj.result then
                                  
                                   promptText(string.format(LANG["send_gift_success_text"],ref.rank.nickname) ,self)
                                   self:loadData(1001)
                               else
                                   promptText(LANG["send_gift_fail_text"],self)
                               end
             end)
    end
    for i = 1,items_count do
        local item = self.listView:getItem(i - 1)
        print("item ",item)
        -- print("item pon =",item:getPonsition)


        local item1 = item:getChildByName("item1")
        item1:setString(i)
        local item2 = item:getChildByName("item2")
        if self:isSelf(ranks[i].username) then
           item2:setString(LANG["league_me_text"])
            item2:setColor(cc.c3b(233, 0, 0))
        else
            item2:setString(ranks[i].nickname)
            
             if ranks[i].isablesendgift  then
               local item3 = item:getChildByName("item4")
               local x,y = item3:getPosition()
                local iconView = ccui.Button:create("enable_send_gift.png", "enable_send_gift.png")
           
                iconView:setAnchorPoint(cc.p(0,0))
                iconView:setPosition(cc.p(item:getContentSize().width-iconView:getContentSize().width-50,iconView:getContentSize().height/2-20))
                iconView.rank = ranks[i]
                iconView:addTouchEventListener(sendGift)
                item:addChild(iconView)
              else
             
                local iconView = ccui.Button:create("disable_send_gift.png", "disable_send_gift.png")
                iconView:setAnchorPoint(cc.p(0,0))
                iconView:setPosition(cc.p(item:getContentSize().width-iconView:getContentSize().width-50,iconView:getContentSize().height/2-20))
                  --iconView.rank = ranks[i]
                item:addChild(iconView)
              end
        end
       -- item2:setString(ranks[i].nickname)
        local item3 = item:getChildByName("item3")
        item3:setString(string.format("LV %d",ranks[i].level))
        local item4 = item:getChildByName("item4")
        local sum = ranks[i].win+ranks[i].lose 
        if sum > 0 then
            item4:setString(string.format("%.0f%%",ranks[i].win/sum*100))
        else
            item4:setString("0%")
        end

      



        -- local index = self.listView:getIndex(item)
        -- button:setTitleText(products[index + 1].coin_count)
    end
    if #ranks==0 then
        self.noDataLabel =  ccui.Text:create(string.format("                   %s",LANG["no_data"]), "fonts/fzzy.ttf", 68)
        self.noDataLabel:setPosition(cc.p(200,self.listView:getContentSize().height/2))
        self.noDataLabel:setColor(cc.c4b(105, 32, 9, 255))
        self.listView:addChild(self.noDataLabel)
    end



end
function RankingsView:synRankData(ranks)
    self.listView:removeAllItems()
    for i = 1,#ranks do
        self.listView:pushBackDefaultItem()
    end
    --listView:removeAllChildren()
    local items_count  = table.getn(self.listView:getItems())
    print("items_count ",items_count)
    for i = 1,items_count do
        local item = self.listView:getItem(i - 1)
        print("item ",item)
       -- print("item pon =",item:getPonsition)



        local item2 = item:getChildByName("item2")
        --item2:setString(ranks[i].nickname)
        if self:isSelf(ranks[i].username) then
          item2:setString(LANG["league_me_text"])
            item2:setColor(cc.c3b(233, 0, 0))
        else
            item2:setString(ranks[i].nickname)
        end
        local item3 = item:getChildByName("item3")
        item3:setString(string.format("LV %d",ranks[i].level))
        local item4 = item:getChildByName("item4")
        local sum = ranks[i].win+ranks[i].lose
        if sum > 0 then
            item4:setString(string.format("%.0f%%",ranks[i].win/sum*100))
        	else
            item4:setString("0%")
        end

        if i<4 then
             if i==1 then
                local iconView = ccui.ImageView:create()
                iconView:loadTexture("glod_m.png")
                iconView:setAnchorPoint(cc.p(0,0))
                iconView:setPosition(cc.p(30,0))
                item:addChild(iconView)
             elseif i==2 then
                local iconView = ccui.ImageView:create()
                iconView:loadTexture("bronze_m.png")
                iconView:setAnchorPoint(cc.p(0,0))
                iconView:setPosition(cc.p(30,0))
                item:addChild(iconView)
             elseif i==3 then
                local iconView = ccui.ImageView:create()
                iconView:loadTexture("silver_m.png")
                iconView:setAnchorPoint(cc.p(0,0))
                iconView:setPosition(cc.p(30,0))
                item:addChild(iconView)
             end
        else
            local item1 = item:getChildByName("item1")
            item1:setString(i)
        end




       -- local index = self.listView:getIndex(item)
       -- button:setTitleText(products[index + 1].coin_count)
    end

    if #ranks==0 then
        self.noDataLabel =  ccui.Text:create(string.format("                   %s",LANG["no_data"]), "fonts/fzzy.ttf", 68)
        self.noDataLabel:setPosition(cc.p(200,self.listView:getContentSize().height/2))
        self.noDataLabel:setColor(cc.c4b(105, 32, 9, 255))
        self.listView:addChild(self.noDataLabel)
    end

end
function RankingsView:dismiss()
   
    playSound(GAME_SFXS.buttonClick)
    self:onExit()
    self.ownView:removeChild(self)
    --LuaObjcBridge.callStaticMethod("AppController","hiddenBar",nil)
     hiddenGoogleAd_bar()
end
function RankingsView:onTouch(event)

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
function RankingsView:onExit()
    friendranks = {}
    worldranks =  {}
    scoreranks =  {}
    print("RankingsView exit")
end
return RankingsView
