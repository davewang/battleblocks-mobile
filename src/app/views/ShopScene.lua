 
local ShopScene = class("ShopScene", cc.load("mvc").ViewBase)
--ShopScene.RESOURCE_FILENAME="ShopScene.csb"
function ShopScene:onCreate()
    
 
--    self.listView = self.resourceNode_:getChildByName("ls1")  
--    self.listView:setBounceEnabled(true)
--    self.listView:setBackGroundImage("cocosui/green_edit.png")
--    self.listView:setBackGroundImageScale9Enabled(true) 
--    self.tpl = cc.CSLoader:createNode("GoodItem.csb")
     
    self.stars = display.newSprite("starfield-hd.jpg")
        :move(display.center)
        :addTo(self,-1)
    self.stars:runAction(cc.RepeatForever:create(cc.RotateBy:create(360,360)))
    
    
--    local array = {}
--    for i = 1,10 do
--        array[i] = string.format("ListView_item_%d",i - 1)
--    end
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
        
            local product =  self:getApp():getProductManager():getProducts()[sender:getCurSelectedIndex()+1]
            LuaObjcBridge.callStaticMethod("PurchaseManager","buyForProduct",{productId=product.product_uid,onPurchaseCompileHandler=onPurchaseCompile})
        end
        print("select child index = ",sender:getCurSelectedIndex(),eventType)
--        if eventType == ccui.ListViewEventType.ONSELECTEDITEM_START then
--            print("select child index = ",sender:getCurSelectedIndex())
--        end
    end

    local function scrollViewEvent(sender, evenType)
       -- 0 top 1 botton 2 left 3 right 4 scrolling 5 bounce top 6 bounce bottom  7 b left 8 b right
       -- print("scrollToBottom = ",evenType)
--        if evenType == ccui.ScrollviewEventType.scrollToBottom then
--            print("SCROLL_TO_BOTTOM")
--        elseif evenType ==  ccui.ScrollviewEventType.scrollToTop then
--            print("SCROLL_TO_TOP")
--        end
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
    
    local default_button = ccui.Button:create("ranking_head.png", "ranking_head.png")
    default_button:setName("Title Button")
    default_button:setTitleFontSize(32)
    --default_button:setContentSize(cc.size(60,60))
    local default_item = ccui.Layout:create()
    default_item:setTouchEnabled(true)
    default_item:setContentSize(default_button:getContentSize())
    default_button:setPosition(cc.p(default_item:getContentSize().width / 2.0, default_item:getContentSize().height / 2.0))
    default_item:addChild(default_button)

    --set model
    self.listView:setItemModel(default_item)

    --add default item
--    local count = table.getn(array)
-- 
--    for i = 1,count do
--        self.listView:pushBackDefaultItem()
--    end
--    --listView:removeAllChildren()
--    local items_count  = table.getn(self.listView:getItems())
--    for i = 1,items_count do
--        local item = self.listView:getItem(i - 1)
--        local button = item:getChildByName("Title Button")
--        local index = self.listView:getIndex(item)
--        button:setTitleText(array[index + 1])
--    end

    -- remove last item
    --listView:removeChildByTag(1)

    -- remove item by index
   -- items_count = table.getn(listView:getItems())
   -- listView:removeItem(items_count - 1)

    -- set all items layout gravity
    -- listView:setGravity(2)

    --set items margin
    -- listView:setItemsMargin(2.0)
    self:getApp():getProductManager():addListener(self);
    self:getApp():getProductManager():requestProducts();
    
    
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
function ShopScene:onReceived()
    local products = self:getApp():getProductManager():getProducts()
    print("products size = ",#products)
    
    --add default item
    local count = table.getn(products)
    for i = 1,count do
        self.listView:pushBackDefaultItem()
    end
    --listView:removeAllChildren()
    local items_count  = table.getn(self.listView:getItems())
    for i = 1,items_count do
        local item = self.listView:getItem(i - 1)
        local button = item:getChildByName("Title Button")
        local index = self.listView:getIndex(item)
        button:setTitleText(products[index + 1].coin_count)
    end
end
function ShopScene:onEnter() 
    print("onEnter ShopScene  ")
    
end
function ShopScene:onExit() 
    self:getApp():getProductManager():removeListener(self);
    print("onExit ShopScene  ")
    
end


return ShopScene