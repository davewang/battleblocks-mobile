
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
--local BackgroundView = import(".BackgroundView")
function MainScene:onCreate()

--    display.newSprite("cover_bg_new.png")
--        :move(display.center)
--        :addTo(self)


    print("MainScene")

    self.app_:createView("BackgroundView"):addTo(self)



    local coinLabel_ = cc.Label:createWithTTF("Coin:", "fonts/BPreplay.ttf", 32)
        :addTo(self)
    coinLabel_:setPosition(cc.p(display.left+80, display.top-coinLabel_:getContentSize().height/2 -65))
    self.coin = cc.Label:createWithTTF("", "fonts/BPreplay.ttf", 32)
        :addTo(self)
    self.coin:setPosition(cc.p(display.left+80+coinLabel_:getContentSize().width, display.top-coinLabel_:getContentSize().height/2-65))

    local levelLabel_ = cc.Label:createWithTTF("Level:", "fonts/BPreplay.ttf", 32)
        :addTo(self)
    levelLabel_:setPosition(cc.p(display.left+80, display.top-levelLabel_:getContentSize().height/2 -65-coinLabel_:getContentSize().height))
    self.level = cc.Label:createWithTTF("", "fonts/BPreplay.ttf", 32)
        :addTo(self)
    self.level:setPosition(cc.p(display.left+80+levelLabel_:getContentSize().width, display.top-levelLabel_:getContentSize().height/2-65-coinLabel_:getContentSize().height))



    -- add play button
    local function addMenu()
        cc.MenuItemFont:setFontName("CGF Locust Resistance")
        cc.MenuItemFont:setFontSize(44)

        local classic =  cc.MenuItemFont:create("Marathon")--cc.MenuItemImage:create("PlayButton.png", "PlayButton.png")
            :onClicked(function()
                printLog("MainScene","go to ClassicScene")
                self:getApp():enterScene("ClassicScene")
            end)
        local battle =  cc.MenuItemFont:create("2P Battle")--cc.MenuItemImage:create("PlayButton.png", "PlayButton.png")
            :onClicked(function()
                --self:getApp().matchController:findOpponent()
                self:getApp():getMatchManager():findOpponentByGroup(GAME_GROUP.G_ONE)
                printLog("MainScene","go to battle")
                self:getApp():enterScene("WaitingView")
            end)
        local p4battle =  cc.MenuItemFont:create("4P Sprint")
            :onClicked(function()
                self:getApp().matchController:findOpponent()
                printLog("MainScene","go to p4battle")
                self:getApp():enterScene("WaitingView")
            end)
        local league =  cc.MenuItemFont:create("league")
            :onClicked(function()
                printLog("MainScene","go to league")
                self:getApp():enterScene("LeagueScene")
            end)
        local shop =  cc.MenuItemFont:create("Shop")
            :onClicked(function()

                printLog("MainScene","go to ShopScene")
                self:getApp():enterScene("ShopScene")
            end)
        local inbox =  cc.MenuItemFont:create("Inbox")
            :onClicked(function()

                    printLog("MainScene","go to inboxScene")
                    self:getApp():enterScene("InboxScene")
            end)

        local daily =  cc.MenuItemFont:create("Daily")
            :onClicked(function()

                    printLog("MainScene","go to DailyScene")
                    self:getApp():enterScene("DailyScene")
            end)
        local test =  cc.MenuItemFont:create("Test")
            :onClicked(function()

                    printLog("MainScene","go to testScene")
                    self:getApp():enterScene("TestScene")
            end)
        local test1 =  cc.MenuItemFont:create("Test1")
            :onClicked(function()

                    printLog("MainScene","go to testScene")
                    self:getApp():enterScene("TestAsyncScene")
            end)
        local test2 =  cc.MenuItemFont:create("TestUDP")
            :onClicked(function()

                    printLog("MainScene","go to TestUDP")
                    self:getApp():enterScene("TestUdpScene")
            end)
        classic:setColor(cc.c4b(0,255,255,255))
        battle:setColor(cc.c4b(0,255,255,255))
        p4battle:setColor(cc.c4b(0,255,255,255))
        league:setColor(cc.c4b(0,255,255,255))
        shop:setColor(cc.c4b(0,255,255,255))
        inbox:setColor(cc.c4b(0,255,255,255))
        daily:setColor(cc.c4b(0,255,255,255))
        test:setColor(cc.c4b(0,255,255,255))
        test1:setColor(cc.c4b(0,255,255,255))
        test2:setColor(cc.c4b(0,255,255,255))


        cc.Menu:create(classic,battle,p4battle,league,shop,inbox,daily,test,test1,test2)
            :move(display.cx, display.cy)
            :addTo(self)
            :alignItemsVertically()

    end
    addMenu()
    if self:getApp():getCurrentUser() then
        if self:getApp():getCurrentUser().star_count == 0 then
            self.level:setString(0)
        	else
            self.level:setString(STAR_MAP_TABLE[self:getApp():getCurrentUser().star_count])
        end

        self.coin:setString(self:getApp():getCurrentUser().coin)

    end
end
function MainScene:onUserInfoReceived()

    if self:getApp():getCurrentUser().star_count == 0 then
        self.level:setString(0)
    else
        self.level:setString(STAR_MAP_TABLE[self:getApp():getCurrentUser().star_count])
    end

    self.coin:setString(self:getApp():getCurrentUser().coin)
    if self:getApp():getUserManager().isLoginBattle == false then
        self:getApp():getUserManager():requestLoginBattle()
    end


end
function MainScene:onLoginReceived()
end
return MainScene
