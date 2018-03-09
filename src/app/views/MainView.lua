
local MainView = class("MainView", cc.load("mvc").ViewBase)
local DrawerView = import("app.components.DrawerView")
local DrawerItemView = import("app.components.DrawerItemView")
local ProfileView = import("app.components.ProfileView")
local PopupView = import("app.components.PopupView")
local RankingsView = import("app.views.RankingsView")
local LeagueView = import("app.views.LeagueView")
local ShopView = import("app.views.ShopView")
local SettingView = import("app.views.SettingView")

local MailView = import("app.views.MailView")
local DailyView = import("app.views.DailyView")

local ClassicGameOverDialog = import("app.components.ClassicGameOverDialog")
local roomsInfo = nil
require "app.MessageDispatchCenter"
local scheduler = cc.Director:getInstance():getScheduler()
local SOCKET_TICK_TIME = 0.1
local Robot = {
  one = 100,
  two = 50,
  three = 15,
}
function MainView:setItem2(item,options)
    print("item title ",options.title)
    if item:getChildByTag(100) then
        -- local enterLable = item:getChildByTag(100):getChildByTag(101):getChildByTag(1001)
        -- local onlineLable = item:getChildByTag(100):getChildByTag(102):getChildByTag(1002)
        -- local prizeLable = item:getChildByTag(100):getChildByTag(103):getChildByTag(1003)
        -- if options then
        --     if options.prize then
        --     --    prizeLable:setString(options.prize)
        --     end
        --     if options.onlinecount then
        --         onlineLable:setString(options.onlinecount)
        --     end
        --     if options.enterfee then
        --         enterLable:setString(options.enterfee)
        --     end
        -- end
    	   return
    end
    local node = display.newNode():addTo(item)
    node:setPosition(cc.p(0,0))
    local s = item:getContentSize()

    local titlLab = cc.Label:createWithTTF(options.title, "fonts/fzzy.ttf", 68)
    titlLab:addTo(node)
    titlLab:setPosition(cc.p(s.width/2,s.height-65-titlLab:getContentSize().height/2))
    titlLab:enableOutline(cc.c4b(116, 53, 25, 255), 4)
    
    
    local function action(sender,type)
       playSound(GAME_SFXS.buttonClick)
       if type~=2 then
           return
       end
       
       self:getApp():enterScene("ClassicScene")
      -- self:getApp():enterScene("ClassicGameView")
       
    end
  --  local enter= cc.MenuItemSprite:create(display.newSprite("#enter_btn.png"), display.newSprite("#enter_btn.png"))
    
    self.tubiao = display.newSprite("tubiao.png")
                 :addTo(node)
     
    --stretchSprite(self.tubiao,500,505)
    self.tubiao:setPosition(cc.p(display.width/2,s.height/1.6 ))
    self.tubiao:setScale(2.5)
    local enter_button = ccui.Button:create( "enter_btn.png", "enter_btn.png")
    --enter_button:setPosition(cc.p(s.width/2,  cc.p(bg3:getPosition()).y - enter:getContentSize().height ))
    enter_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 60})
    enter_button:setTitleColor(cc.c3b(255, 255, 255))
    enter_button:setTitleText(LANG["btn_play_text"])
    enter_button:addTouchEventListener(action)
  --  466,167
    --stretchNode(enter_button,466,167)
    enter_button:setPosition(cc.p(display.width/2,s.height/3.5 -30))
    node:addChild(enter_button)  
    local  info = display.newSprite("#option_info.png")
                 :addTo(node)
    info:setPosition(cc.p(s.width-info:getContentSize().width-10,  cc.p(enter_button:getPosition()).y - info:getContentSize().height-30 ))
    


end
function MainView:setItem(item,options)
   -- print("item ",item)
    if item:getChildByTag(100) then
        local enterLable = item:getChildByTag(100):getChildByTag(101):getChildByTag(1001)
        local onlineLable = item:getChildByTag(100):getChildByTag(102):getChildByTag(1002)
        local prizeLable = item:getChildByTag(100):getChildByTag(103):getChildByTag(1003)
        if options then
            if options.prize then
                prizeLable:setString(options.prize)
                prizeLable:setColor(cc.c4b(0,0,128,255))
               
            end
            if options.onlinecount then
                onlineLable:setString(options.onlinecount)
                onlineLable:setColor(cc.c4b(0,0,128,255))
            end
            if options.enterfee then
                 if self:getApp():getCurrentUser().coin > options.enterfee then
                    item.enterAble = true 
                    enterLable:setColor(cc.c4b(0,0,128,255))
                 else 
                     item.enterAble = false 
                     enterLable:setColor(cc.c4b(246,53,53,255))
                 end
                enterLable:setString(options.enterfee)
                --enterLable:setColor(cc.c4b(0,0,128,255))
            end
        end
    	    return
    end
    local node = display.newNode():addTo(item,100,100)
    node:setPosition(cc.p(0,0))
    local s = item:getContentSize()

    local titlLab = cc.Label:createWithTTF(options.title, "fonts/fzzy.ttf", 68)
    titlLab:addTo(node)
    titlLab:setPosition(cc.p(s.width/2,s.height-65-titlLab:getContentSize().height/2))
    titlLab:enableOutline(cc.c4b(116, 53, 25, 255), 4)
    local bg1 = display.newSprite("#option_label_bg.png"):addTo(node)
    bg1:setPosition(cc.p(s.width/2,s.height - bg1:getContentSize().height-205+46))
    bg1:setTag(101)
    local enterPLable = cc.Label:createWithTTF(LANG["lab_enterfee_text"], "fonts/fzzy.ttf", 60)
        :addTo(bg1)
    enterPLable:setPosition(cc.p(bg1:getContentSize().width/2-60,bg1:getContentSize().height/2 ))
    enterPLable:setAnchorPoint(cc.p(1,0.5))
    enterPLable:setColor(cc.c4b(105,32,9,255))
    --enterPLable:enableShadow(cc.c4b(0, 0, 0, 255))

    local enterLable = cc.Label:createWithTTF("22", "fonts/fzzy.ttf", 60)
        :addTo(bg1)
    enterLable:setPosition(cc.p(bg1:getContentSize().width/2 ,bg1:getContentSize().height/2 ))
    enterLable:setAnchorPoint(cc.p(0,0.5))
    enterLable:setColor(cc.c4b(246,53,53,255))
    enterLable:enableShadow(cc.c4b(0, 0, 0, 255))
    enterLable:setTag(1001)
    local coin = display.newSprite("#option_coin.png")
        :addTo(bg1)
    coin:move(cc.p(cc.p(enterLable:getPosition()).x+200+coin:getContentSize().width/2,bg1:getContentSize().height/2 ))



    local bg2 = display.newSprite("#option_label_bg.png"):addTo(node,100,102)
    bg2:setPosition(cc.p(s.width/2,  cc.p(bg1:getPosition()).y - bg2:getContentSize().height -40))
    bg2:setTag(102)
    local onlinePLable = cc.Label:createWithTTF(LANG["lab_online_text"], "fonts/fzzy.ttf", 60)
        :addTo(bg2)
    onlinePLable:setPosition(cc.p(bg2:getContentSize().width/2-60,bg2:getContentSize().height/2 ))
    onlinePLable:setAnchorPoint(cc.p(1,0.5))
    onlinePLable:setColor(cc.c4b(105,32,9,255))
    --onlinePLable:enableShadow(cc.c4b(0, 0, 0, 255))

    local onlineLable = cc.Label:createWithTTF("", "fonts/fzzy.ttf", 60)
        :addTo(bg2)
    onlineLable:setPosition(cc.p(bg2:getContentSize().width/2,bg2:getContentSize().height/2 ))
    onlineLable:setAnchorPoint(cc.p(0,0.5))
    onlineLable:setColor(cc.c4b(246,53,53,255))
    onlineLable:enableShadow(cc.c4b(0, 0, 0, 255))
    onlineLable:setTag(1002)

    local bg3 = display.newSprite("#option_label_bg.png"):addTo(node)
    bg3:setPosition(cc.p(s.width/2,  cc.p(bg2:getPosition()).y - bg3:getContentSize().height -40))
    bg3:setTag(103)
    local prizePLable = cc.Label:createWithTTF(LANG["lab_prize_text"], "fonts/fzzy.ttf", 60)
        :addTo(bg3)
    prizePLable:setPosition(cc.p(bg3:getContentSize().width/2-60,bg3:getContentSize().height/2 ))
    prizePLable:setAnchorPoint(cc.p(1,0.5))
    prizePLable:setColor(cc.c4b(105,32,9,255))
   -- prizePLable:enableShadow(cc.c4b(0, 0, 0, 255))

    local prizeLable = cc.Label:createWithTTF("", "fonts/fzzy.ttf", 60)
        :addTo(bg3)
    prizeLable:setTag(1003)
    prizeLable:setPosition(cc.p(bg3:getContentSize().width/2,bg3:getContentSize().height/2 ))
    prizeLable:setAnchorPoint(cc.p(0,0.5))
    prizeLable:setColor(cc.c4b(246,53,53,255))
    prizeLable:enableShadow(cc.c4b(0, 0, 0, 255))

    local coinMore = display.newSprite("#option_coin_more.png")
    :addTo(bg3)
    coinMore:move(cc.p(cc.p(prizeLable:getPosition()).x+200+coinMore:getContentSize().width/2,bg3:getContentSize().height/2 ))


    local enter= cc.MenuItemSprite:create(display.newSprite("#enter_btn.png"), display.newSprite("#enter_btn.png"))
    local info= cc.MenuItemSprite:create(display.newSprite("#option_info.png"), display.newSprite("#option_info.png"))
    local enterl = cc.Label:createWithTTF(LANG["btn_play_text"], "fonts/fzzy.ttf", 60)
        :addTo(enter)
    --enterl:enableOutline(cc.c4b(86, 51, 30, 255), 4)
    enterl:move(enter:getContentSize().width/2,enter:getContentSize().height/2+enterl:getContentSize().height/5)
    enter:setPosition(cc.p(s.width/2,  cc.p(bg3:getPosition()).y - enter:getContentSize().height ))

    info:setPosition(cc.p(s.width-info:getContentSize().width-10,  cc.p(enter:getPosition()).y - info:getContentSize().height-30 ))
    enter:registerScriptTapHandler(function(m)
    
        currentSelectedGroup = options.name
        print(string.format(" coin = %d prize = %d", self:getApp():getCurrentUser().coin,options.enterfee) )
        if self:getApp():getCurrentUser().coin > options.enterfee then
            
              self:getApp():enterScene("FindOpponentView")
              romShowGoogleAdPage()
        else
              promptText(LANG["enough_coin_text"],self)
        end
        -- currentSelectedGroup = options.name
        -- self:getApp():enterScene("FindOpponentView")
        
      
    end)
    local menu = cc.Menu:create()
    menu:addChild(enter)
    menu:addChild(info)

    menu:setPosition(cc.p(0, 0))
    menu:addTo(node)

    if options.prize then
        prizeLable:setString(options.prize)
        prizeLable:setColor(cc.c4b(0,0,128,255))
       
         
    end
    if options.onlinecount then
        onlineLable:setString(options.onlinecount)
        onlineLable:setColor(cc.c4b(0,0,128,255))
    end
    if options.enterfee then
        enterLable:setString(options.enterfee)
        if self:getApp():getCurrentUser().coin > options.enterfee then
            item.enterAble = true 
            enterLable:setColor(cc.c4b(0,0,128,255))
        else 
            item.enterAble = false 
            enterLable:setColor(cc.c4b(246,53,53,255))
        end
        --enterLable:setColor(cc.c4b(0,0,128,255))
    end



end
function MainView:refreshUserInfo() 
    print("refreshUserInfo MainView  ")
    self.app_.client:request("userinfo",{username=""} , function(obj)
             self.app_:getUserManager().currentUser = obj.user
             currentLoginUser =  self.app_:getUserManager().currentUser 
             print("refreshUserInfo MainView  obj.user.coin =", obj.user.coin)
             --self.profile:setUser(self:getApp():getCurrentUser())
             
             self.pageView:removeAllPages()
             self:addPages(self.pageView)
             self:onLoginReceived()
             
             
       
             
    end)
end
 
function MainView:addPages(pageView)
    self.cards = {}
    local groups = KM_LEVEL.groups
    
    
    for i=1,#groups do
        local layout = ccui.Layout:create()
        layout:setContentSize(self.configSize)
        local imageView = ccui.ImageView:create()
        imageView:setTouchEnabled(true)
        imageView:setScale9Enabled(true)
        imageView:loadTexture( "option_card_bg.png" )
        imageView:setContentSize(self.configSize)
        imageView:setPosition(cc.p(layout:getContentSize().width / 2, layout:getContentSize().height / 2))
        imageView:setTag(102)
        layout:addChild(imageView)
        pageView:addPage(layout)
        
        self.cards[groups[i].name]=imageView
        print( string.format("addpage groups[%d].name = %s",i,groups[i].name))
        -- if i == #groups then
            
        --          self:setItem2(imageView,{title=LANG["card_marathon_title_text"] })
     
        -- else 
            
           self:setItem(imageView,{title=LANG[string.format("card_group%d_title_text",i)] ,name=groups[i].name, enterfee=groups[i].enterfee,prize=groups[i].prize,onlinecount=0})
        --end 
        --setItem(imageView,{title=groups[i].title,enterfee=groups[i].enterfee,prize=groups[i].prize,onlinecount=0})

    end
end 
function MainView:onCreate()




    self.bg = display.newSprite("bg.png")
        :move(display.center)
        :addTo(self,-1)
    self.bg:setGlobalZOrder(-2)
  
    
    
    self.optionbg = display.newSprite("#option_card_bg.png")
    self.configSize =  self.optionbg:getContentSize()
    local pageView = ccui.PageView:create()
    pageView:setTouchEnabled(true)
    pageView:setContentSize(self.configSize)--(self.optionbg:getContentSize())
    local backgroundSize = self.bg:getContentSize()
    pageView:setPosition(cc.p((display.width - backgroundSize.width) / 2 +
        (backgroundSize.width - pageView:getContentSize().width) / 2,
        (display.height - backgroundSize.height) / 2 +
        (backgroundSize.height - pageView:getContentSize().height) / 2))
   
    self:addPages(pageView)

    local function pageViewEvent(sender, eventType)
 
    end


    pageView:addEventListener(pageViewEvent)
    self.pageView = pageView
    self:addChild(pageView)




    self.profile = ProfileView:create(nil,function()
           ShopView:create(self)
           romShowGoogleAdPage()
           --self:getApp():enterScene("FacebookView")
    end)

    self:addChild(self.profile)



    
    audio.playMusic( GAME_SFXS.bgMusic1)
   
    self:getApp():reloadSetting()
    local shop = cc.MenuItemSprite:create(display.newSprite("#btn_red.png"), display.newSprite("#btn_red.png"))
    local rank = cc.MenuItemSprite:create(display.newSprite("#btn_yellow.png"), display.newSprite("#btn_yellow.png"))
    local mail = cc.MenuItemSprite:create(display.newSprite("#btn_yellow.png"), display.newSprite("#btn_yellow.png"))
    local setting = cc.MenuItemSprite:create(display.newSprite("#btn_yellow.png"), display.newSprite("#btn_yellow.png"))
    
      self.uread = ccui.ImageView:create()
      self.uread:loadTexture("uread_red_mark.png")
      self.uread:setAnchorPoint(cc.p(0,0))
      self.uread:setPosition(cc.p(30,mail:getContentSize().height-40))
      self.uread:setName("uread") 
      mail:addChild( self.uread )
    --  self.uread:setVisible(true) 
    
    
    
    shop:registerScriptTapHandler(function()
        
        playSound(GAME_SFXS.buttonClick)
        local popup = ShopView:create(self)
         romShowGoogleAdPage()
        end)

    rank:registerScriptTapHandler(function()
     
        playSound(GAME_SFXS.buttonClick)
        local popup = RankingsView:create(self)
           romShowGoogleAdPage()
        end)
      
   
    mail:registerScriptTapHandler(function()
          playSound(GAME_SFXS.buttonClick)
          --playDropCoins(self,1)
           --  LuaObjcBridge.callStaticMethod("AppController","addPage",nil)
           --  self:getApp():showLoadingInView(self)
              MailView:create(self)
              romShowGoogleAdPage()
            -- self.loading:showInView(self)
        end)
    setting:registerScriptTapHandler(function() 
             playSound(GAME_SFXS.buttonClick)
              SettingView:create(self)
               romShowGoogleAdPage()
             -- playDropCoins(self)
--            local popup = PopupView:create(self,
--                function(popupview)
--                    display.newSprite("dialog_backgrd_dailybonus.png")
--                        :move(display.center)
--                        :scale(1)
--                        :addTo(popupview)
--                end)
            --  LeagueView:create(self)

    end)
    local shopl = cc.Label:createWithTTF(LANG["btn_shop_text"], "fonts/fzzy.ttf", 52)
        :addTo(shop)
    shopl:enableOutline(cc.c4b(86, 51, 30, 255), 4)
   -- shopl:enableShadow(cc.c4b(0, 0, 0, 255))
    shopl:move(shop:getContentSize().width/2,shop:getContentSize().height/2+shopl:getContentSize().height/4)

    local rankl = cc.Label:createWithTTF(LANG["btn_league_text"], "fonts/fzzy.ttf", 52)
        :addTo(rank)
    rankl:enableOutline(cc.c4b(221, 129, 0, 255), 4)
    --rankl:enableShadow(cc.c4b(0, 0, 0, 255))
    rankl:move(rank:getContentSize().width/2,rank:getContentSize().height/2+rankl:getContentSize().height/4)
   
        
    
    local maill = cc.Label:createWithTTF(LANG["btn_mail_text"], "fonts/fzzy.ttf", 52)
        :addTo(mail)
    maill:enableOutline(cc.c4b(221, 129, 0, 255), 4)
    --maill:enableShadow(cc.c4b(0, 0, 0, 255))
    maill:move(mail:getContentSize().width/2,mail:getContentSize().height/2+maill:getContentSize().height/4)

    local settingl = cc.Label:createWithTTF(LANG["btn_setting_text"], "fonts/fzzy.ttf", 52)
        :addTo(setting)
    settingl:enableOutline(cc.c4b(221, 129, 0, 255), 4)
    --settingl:enableShadow(cc.c4b(0, 0, 0, 255))
    settingl:move(setting:getContentSize().width/2,setting:getContentSize().height/2+settingl:getContentSize().height/4)

    local menu = cc.Menu:create()
    menu:addChild(shop)
    menu:addChild(rank)
    menu:addChild(mail)
    menu:addChild(setting)
    menu:setPosition(cc.p(0, 0))
    shop:setPosition(cc.p(shop:getContentSize().width/2+21, shop:getContentSize().height/2+40))
    rank:setPosition(cc.p(cc.p(shop:getPosition()).x+shop:getContentSize().width/2+rank:getContentSize().width/2 , shop:getContentSize().height/2+40))
    mail:setPosition(cc.p(cc.p(rank:getPosition()).x+rank:getContentSize().width/2+mail:getContentSize().width/2 , shop:getContentSize().height/2+40))
    setting:setPosition(cc.p(cc.p(mail:getPosition()).x+mail:getContentSize().width/2+setting:getContentSize().width/2 , shop:getContentSize().height/2+40))

    self:addChild(menu, 1)
    
    
    
    local action2 = cc.FadeOut:create(0.5)
    local action2Back = action2:reverse()
    local tip_str = ""
    if device.language == 'cn' then 
        tip_str="<轻扫以滑动>"
    else
        tip_str="<Swipe to slide>"
    end 
    
    local tips = cc.Label:createWithTTF(tip_str, "fonts/fzzy.ttf", 52)
        :addTo(self)
    --To do : native
    tips:move(display.cx,cc.p(rank:getPosition()).y+200 )
    tips:runAction(cc.RepeatForever:create(cc.Sequence:create( action2, action2Back)))

    if self:getApp():getCurrentUser() then
        self.profile:setUser(self:getApp():getCurrentUser())
       -- self.profile:setData({avatar_id=self:getApp():getCurrentUser().avatarid,level= self:getApp():getCurrentUser().level,coin=self:getApp():getCurrentUser().coin,nickname=self:getApp():getCurrentUser().nickname})
    end
--    local function step(dt)
--       print(dt)
--    end
--     self:scheduleUpdate(step)
 
    MessageDispatchCenter:registerMessage(MessageDispatchCenter.MessageType.CHECK_INBOX_NOTIFY,handler(self,self.checkInbox))
    
    MessageDispatchCenter:registerMessage(MessageDispatchCenter.MessageType.REFRESH_USERINFO,handler(self,self.refreshUserInfo))
    self:checkInbox()
    
    --LANG["prompt_name_text"]
    --LANG["prompt_short_name_text"]
    
    --ClassicGameOverDialog:create(self)
    
    --LuaObjcBridge.callStaticMethod("AppController","addPage",nil)
end
function MainView:checkInbox()
      self.app_.client:request("haveureadmessage", {username=""} , function(obj)
            self.uread:setVisible(obj.result) 
      end)
end
function MainView:onLoginReceived()
    print("MainView:onLoginReceived")
    --{avatar_id=self:getApp():getCurrentUser().avatarid,level= self:getApp():getCurrentUser().level,coin=self:getApp():getCurrentUser().coin,nickname=self:getApp():getCurrentUser().nickname}
    self.profile:setUser(self:getApp():getCurrentUser())
    
    self.app_.client:request("checkdaily", {username=""} , function(obj)
                 if obj.result then
                     DailyView:create(self)
                 end
        end)
    local function notify()
        --check online person
        self.app_.client:request("onlineinfo", {sid=""} , function(obj)
                 print("check onlineinfo")
                 if obj.groups then
                    for i=1,#obj.groups do
                       print( string.format("onlineinfo groups[%d].name = %s count = %d",i,obj.groups[i].id,obj.groups[i].count))
                       self:setItem(self.cards[obj.groups[i].id],{onlinecount = obj.groups[i].count + math.random(Robot[obj.groups[i].id]-10,Robot[obj.groups[i].id])})
                      
                 	end
                 end
                 roomsInfo = obj.groups
               -- notify()
                 self:checkInbox()
        end)
       
    end
     
    notify()

    if self.timeTickScheduler then scheduler:unscheduleScriptEntry(self.timeTickScheduler) end
    
    self.timeTickScheduler = scheduler:scheduleScriptFunc(notify,15,false)

end
function MainView:onExit()
    print("onExit MainView  ")
    MessageDispatchCenter:removeAllMessage(MessageDispatchCenter.MessageType.CHECK_INBOX_NOTIFY)
    MessageDispatchCenter:removeAllMessage(MessageDispatchCenter.MessageType.REFRESH_USERINFO)
    if self.timeTickScheduler then scheduler:unscheduleScriptEntry(self.timeTickScheduler) end
    self.timeTickScheduler = nil
    ---self:getApp():getDailyManager():removeListener(self);
    --print("onExit DailyScene  ")

end

return MainView
