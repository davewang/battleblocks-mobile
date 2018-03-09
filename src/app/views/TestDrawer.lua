
local TestDrawer = class("TestDrawer", cc.load("mvc").ViewBase)
local DrawerView = import("app.components.DrawerView")
local DrawerItemView = import("app.components.DrawerItemView")
local ProfileView = import("app.components.ProfileView")
local PopupView = import("app.components.PopupView")
local LeagueView = import("app.views.LeagueView")
local SOCKET_TICK_TIME = 0.1

local function setDrawerVSItem(item,options)
  local titleLabel = cc.Label:createWithTTF(options.title, "fonts/CGF Locust Resistance.ttf", 32)
      :addTo(item)
  local s1 =  item:getContentSize()
  titleLabel:setPosition(cc.p(s1.width/2,s1.height-30))

  local cont1 = display.newSprite("dialog_settings_backgrd.png")
           :move(cc.p(s1.width/2,s1.height/2))
           :addTo(item)
  local s2 =  cont1:getContentSize()

  local prizeLable = cc.Label:createWithTTF(string.format("Prize:%d",options.prize), "fonts/Bebas.ttf", 48)
  :addTo(cont1)
  prizeLable:setPosition(cc.p(s2.width/6,s1.height/2-65))
  prizeLable:setAnchorPoint(cc.p(0,0.5))
  local ps  = prizeLable:getContentSize()
  local pp  = cc.p(prizeLable:getPosition())

  display.newSprite("coin-stack.png")
         :move(cc.p(pp.x+ps.width+60,s2.height/2+30))
         :scale(0.7)
         :addTo(cont1)

  local onlineLable = cc.Label:createWithTTF(string.format("Players online:%d",options.onlineCount), "fonts/Bebas.ttf", 38)
  :addTo(cont1)
  onlineLable:setAnchorPoint(cc.p(0,0.5))
  onlineLable:setPosition(cc.p(s2.width/6,s1.height/2-140))

  local entryLable = cc.Label:createWithTTF(string.format("Entry fee:%d",options.entryFee), "fonts/Bebas.ttf", 38)
  :addTo(cont1)
  entryLable:setAnchorPoint(cc.p(0,0.5))
  entryLable:setPosition(cc.p(s2.width/6,s1.height/2-210))
  local es  = entryLable:getContentSize()
  local ep  = cc.p(entryLable:getPosition())

  display.newSprite("Coin.png")
         :move(cc.p(ep.x+es.width+60,ep.y))
         :scale(0.5)
         :addTo(cont1)
end
function TestDrawer:onCreate()


    local a = DrawerItemView:create("dialog_backgrd_dailybonus.png",function()
         print("a")
        self:getApp():getMatchManager():findOpponentByGroup(GAME_GROUP.G_ONE)
        printLog("MainScene","go to battle")
        self:getApp():enterScene("WaitingView")
    end)

    local b = DrawerItemView:create("dialog_backgrd_dailybonus.png",function()
        print("b")

    end)

    local c = DrawerItemView:create("dialog_backgrd_dailybonus.png",function()
        print("c")

    end)

    local d = DrawerItemView:create("dialog_backgrd_dailybonus.png",function()
        print("d")

    end)
    --setDrawerVSItem(d.board,{title="Racing 1 ON 1",entryFee=3500,onlineCount=2302,prize=7000})

    local e = DrawerItemView:create("dialog_backgrd_dailybonus.png",function()
        print("e")
        self.profile:setData({avatar_id=2,level=6,coin=2120,nickname="emma"})

    end)
    setDrawerVSItem(a.board,{title="1 ON 1",entryFee=100,onlineCount=2311,prize=200})
    setDrawerVSItem(b.board,{title="1 ON 1",entryFee=500,onlineCount=1311,prize=1000})
    setDrawerVSItem(c.board,{title="1 ON 1",entryFee=2500,onlineCount=3311,prize=5000})
  --  setDrawerVSItem(d.board,{title="1 ON 1",entryFee=2500,onlineCount=3311,prize=5000})
  --  setDrawerVSItem(e.board,{title="1 ON 1",entryFee=2500,onlineCount=3311,prize=5000})
    --setDrawerVSItem(d.board,{title="1 ON 1",entryFee=2500,onlineCount=3311,prize=5000})

    local v = DrawerView:create(a,b,c)--,d,e
    v:setBasePosition({x=display.width/2,y=display.height/2})
    v:setDepthAndSpacing({depth=100,spacing=45})
    self:addChild(v)
    v:show()
    v:setPosition(cc.p(0,0))



    self.profile = ProfileView:create()

    self:addChild(self.profile)

   self.stars = display.newSprite("background_lobby.png")
       :move(display.center)
       :addTo(self,-1)

   self.stars:setGlobalZOrder(-2)
       local item1 = cc.MenuItemImage:create("boost_backgrd_tab.png", "boost_backgrd_tab_selected.png")
       local item2 = cc.MenuItemImage:create("boost_backgrd_tab.png", "boost_backgrd_tab_selected.png")
       local item3 = cc.MenuItemImage:create("boost_backgrd_tab.png", "boost_backgrd_tab_selected.png")
       local item4 = cc.MenuItemImage:create("icon_leagues.png", "icon_leagues.png")


       item1:registerScriptTapHandler(function()
       end)

       item2:registerScriptTapHandler(function()

       end)
       item3:registerScriptTapHandler(function()

       end)
       item4:registerScriptTapHandler(function()

            local popup = PopupView:create(self,
                function(popupview)
                  display.newSprite("dialog_backgrd_dailybonus.png")
                    :move(display.center)
                    :scale(1)
                    :addTo(popupview)
                end)
           --  LeagueView:create(self)

       end)
       cc.Label:createWithTTF("Shop", "fonts/BPreplay.ttf", 32)
           :move(item1:getContentSize().width/2,item1:getContentSize().height/2)
           :addTo(item1)
           cc.Label:createWithTTF("Inbox", "fonts/BPreplay.ttf", 32)
               :move(item2:getContentSize().width/2,item2:getContentSize().height/2)
               :addTo(item2)
               cc.Label:createWithTTF("Setting", "fonts/BPreplay.ttf", 32)
                   :move(item3:getContentSize().width/2,item3:getContentSize().height/2)
                   :addTo(item3)
       local menu = cc.Menu:create()
       menu:addChild(item1)
       menu:addChild(item2)
       menu:addChild(item3)
       menu:addChild(item4)
       menu:setPosition(cc.p(0, 0))
       item1:setPosition(cc.p(item2:getContentSize().width/2, item2:getContentSize().height / 2+80))
       item2:setPosition(cc.p(display.width / 2, item2:getContentSize().height / 2+80))
       item3:setPosition(cc.p(cc.p(item2:getPosition()).x + item2:getContentSize().width, item2:getContentSize().height / 2+80))
       item4:setPosition(cc.p(display.cx-250,display.cy+400))

       self:addChild(menu, 1)

       if self:getApp():getCurrentUser() then
           self.profile:setData({avatar_id=self:getApp():getCurrentUser().avatarid,level= self:getApp():getCurrentUser().level,coin=self:getApp():getCurrentUser().coin,nickname=self:getApp():getCurrentUser().nickname})
       end

end
function TestDrawer:onLoginReceived()

     self.profile:setData({avatar_id=self:getApp():getCurrentUser().avatarid,level= self:getApp():getCurrentUser().level,coin=self:getApp():getCurrentUser().coin,nickname=self:getApp():getCurrentUser().nickname})

end



return TestDrawer
