 
local InboxScene = class("InboxScene", cc.load("mvc").ViewBase)
--ShopScene.RESOURCE_FILENAME="ShopScene.csb"
function InboxScene:onCreate()
    
    self.stars = display.newSprite("starfield-hd.jpg")
        :move(display.center)
        :addTo(self,-1)
    self.stars:runAction(cc.RepeatForever:create(cc.RotateBy:create(360,360)))
    
   
    local function onPurchaseCompile(reslut)
    	if reslut.success == "yes" then
    	    print("is success")
    	else
            print("is fail")
    	end
    end
    local function listViewEvent(sender, eventType)
        --0 start 1 end
        if eventType==1 then
        
         end
        print("select child index = ",sender:getCurSelectedIndex(),eventType)
 
    end

    local function scrollViewEvent(sender, evenType)
 
    end

    self.listView = ccui.ListView:create()
    -- set list view ex direction
    self.listView:setDirection(1)
    self.listView:setBounceEnabled(true)
    --listView:setBackGroundImage("starfield.jpg")
    self.listView:setBackGroundImageScale9Enabled(true)
    self.listView:setContentSize(cc.size(display.width-100,  450))
      
    self.listView:setPosition(cc.p(210,300 ))
    self.listView:addEventListener(listViewEvent)
    self.listView:addScrollViewEventListener(scrollViewEvent)
    self:addChild(self.listView)


    -- create model
    
    local default_button = ccui.Button:create("res/btn.png", "res/btn.png")
    default_button:setName("Title Button")
    default_button:setTitleFontSize(32)
    default_button:setContentSize(cc.size(60,60))
    local default_item = ccui.Layout:create()
    default_item:setTouchEnabled(true)
    default_item:setContentSize(default_button:getContentSize())
    default_button:setPosition(cc.p(default_item:getContentSize().width / 2.0, default_item:getContentSize().height / 2.0))
    default_item:addChild(default_button)

    --set model
    self.listView:setItemModel(default_item)

    --add default item
 
    self:getApp():getInboxManager():addListener(self);
    self:getApp():getInboxManager():requestMessages();
    
    
    cc.MenuItemFont:setFontName("CGF Locust Resistance")
    cc.MenuItemFont:setFontSize(44)

    local cancelRequest =  cc.MenuItemFont:create("BACK")
        :onClicked(function()
            printLog("MainScene","go to menu")
           
            self:getApp():enterScene("MainScene")
        end)
    cancelRequest:setColor(cc.c4b(0,255,255,255))
    cc.Menu:create(cancelRequest)
        :move(display.cx, display.cy-350)
        :addTo(self)
        :alignItemsVertically()
end
function InboxScene:onSystemMessagesReceived()
    local messages = self:getApp():getInboxManager():getSystemMessages()
    print("messages size = ",#messages)
    
    --add default item
    local count = table.getn(messages)
    for i = 1,count do
        self.listView:pushBackDefaultItem()
    end
    --listView:removeAllChildren()
    local items_count  = table.getn(self.listView:getItems())
    for i = 1,items_count do
        local item = self.listView:getItem(i - 1)
        local button = item:getChildByName("Title Button")
        local index = self.listView:getIndex(item)
        button:setTitleText(messages[index + 1].title)
    end
end
function InboxScene:onEnter() 
    print("onEnter InboxScene  ")
    
end
function InboxScene:onExit() 
    self:getApp():getInboxManager():removeListener(self);
    print("onExit InboxScene  ")
    
end


return InboxScene