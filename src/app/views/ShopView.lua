local ShopView = class("ShopView",cc.Node)
local json = require("dkjson")
local products = {}
local this = nil
function ShopView:ctor(view)
    print("iLog ShopView")
    self.ownView = view
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255/2))
    self.bg:setTouchEnabled(false)
    self:addChild(self.bg)
    display.newLayer()
        :onTouch(handler(self, self.onTouch),false,true)
        :addTo(self)



    self._bg = display.newSprite("shop_bg.png")
        :move(display.center)
        :addTo(self)
    local titlel = cc.Label:createWithTTF(LANG["shop_title_text"], "fonts/fzzy.ttf", 68)
        :addTo(self._bg)
    titlel:enableOutline(cc.c4b(116, 54, 25, 255), 4)
    titlel:setPosition(cc.p(self._bg:getContentSize().width/2,self._bg:getContentSize().height-30-titlel:getContentSize().height/2))

    local close_button = ccui.Button:create( "shop_close.png", "shop_close.png")
    self._bg:addChild(close_button)
    close_button:setAnchorPoint(cc.p(0,0.5))
    close_button:setPosition(972,1235)
    close_button:addTouchEventListener(handler(self,self.dismiss))






    self.pageView = ccui.PageView:create()
    self.pageView:setTouchEnabled(true)
   -- self.pageView:setBackGroundImage("bg.png")
    self.pageView:setContentSize(cc.size(850,880))
   -- local backgroundSize = self._bg:getContentSize()

    self.pageView:setPosition(100,120)
    self.cards = {}
    local function pageViewEvent(sender, eventType)

    end
    self.pageView:addEventListener(pageViewEvent)

    self._bg:addChild(self.pageView)
    local tips = ccui.Text:create(LANG['tips_recharge'], "fonts/fzzy.ttf", 32)
       
    tips:setTextHorizontalAlignment(1)
    local autosize =  32
    local autoOutline = 4
    tips:setFontSize(autosize)
    tips:addTo(self._bg)
    tips:enableOutline(cc.c4b(255, 0, 0, 255), autoOutline)
    
    tips:move(self._bg:getContentSize().width / 2.0,120 )
    if #products == 0 then
    	   self:loadProducts()
    	else
       self:synProductsData(products)
    end

    --callback(self)
    self.ownView:addChild(self,100)
    --LuaObjcBridge.callStaticMethod("AppController","showBar",nil)
    showGoogleAd_bar()
    this = self
    self.currendSelectedItem = nil
end

local function onPurchaseCompile(reslut)
        if type(reslut) == 'string' then
             print(reslut)
             local rr, pos, err = json.decode (reslut, 1, nil)
             reslut = rr
        end 
          
        print("onPurchaseCompile ----start---------")
        --sender.ext.ownView:getApp():hideLoadingView()
        this.ownView:getApp():hideLoadingView()
        print("onPurchaseCompile ----hideLoadingView---------")
        
        print(string.format("reslut.success = ->%s<-",reslut.success))
        if reslut.success == "yes" then
            print("reslut.success onPurchaseCompile ----hideLoadingView---------")
            print("is success")
            print(string.format("pid = >%s<",reslut.pid))
            local function getCoinCountWithPid(pid)
                 for i=1,#products do
                    if pid == products[i].product_uid then
                        return products[i].coin_count
                    end 
                 end 
                 return 0
             end 
             
             local recv_coin = getCoinCountWithPid(reslut.pid)
             if tonumber(recv_coin) > 0 then
                         print(string.format(" reslut.pid = %s",reslut.pid))
                         this.ownView.app_.client:request("addCoin",{count = tonumber( recv_coin),type=1,p_id=reslut.pid} , function(obj)
                            if obj.result then
                                    print("playDropCoins", obj.result )
                                    playDropCoins(this)
                                    promptText(string.format( LANG["pay_success_text"],recv_coin),this)
                                    print("playDropCoins end")
                                    print("dispatchMessage ", obj.result )
                                    
                                    MessageDispatchCenter:dispatchMessage(MessageDispatchCenter.MessageType.REFRESH_USERINFO)
                                    hiddenGoogleAd_bar()
                            end
                         end)
            else 
                promptText(  LANG["pay_fail_text"] ,this)
            end
           
        else
            print("reslut.fail onPurchaseCompile  ")
            print("is fail")
            promptText(  LANG["pay_fail_text"] ,this)
        end
end
local function payAction(sender,type)
    
    if type==2 then
        
        print("price ",sender.ext.price)

       if cc.PLATFORM_OS_ANDROID == targetPlatform_ then
           promptText(  "对不起,暂不支持!" ,this)
--        local args = {sender.ext.product_uid,onPurchaseCompile}
--        local sigs = "(Ljava/lang/String;I)V"
--        local className = "net/iapploft/games/battletetris/Functions"
--        local ok = LuaJavaBridge.callStaticMethod(className,"buyForProduct",args,sigs)
--        if not ok then
--            print("luaj error")
--        end
        
       elseif (cc.PLATFORM_OS_IPHONE == targetPlatform_) or (cc.PLATFORM_OS_IPAD == targetPlatform_) or (cc.PLATFORM_OS_MAC == targetPlatform_) then
           this.ownView:getApp():showLoadingInView(this.ownView,LANG["paying_text"])
           LuaObjcBridge.callStaticMethod("PurchaseManager","buyForProduct",{productId=sender.ext.product_uid,onPurchaseCompileHandler=onPurchaseCompile})
       end 
        
    end

end



--local function synProductData(item,product)
function ShopView:synProductData(item,product)
    local add_lab = ccui.Text:create("", "fonts/fzzy.ttf", 46)--cc.Label:createWithTTF("1", "fonts/fzzy.ttf", 52)
    item:addChild(add_lab)
    add_lab:setPosition(cc.p(130,item:getContentSize().height/2))

    add_lab:setTextColor(cc.c4b(203, 138, 72, 255))
    add_lab:enableOutline(cc.c4b(255, 255, 255, 255), 4)
    add_lab:setString(string.format("x%d",product.coin_count))
    add_lab:setAnchorPoint(0.5,0.5)
    local coin = display.newSprite(string.format("shop_more_coin_%d.png",product.id) )
        :move(cc.p(item:getContentSize().width/2,item:getContentSize().height/2+100))
        :addTo(item)

    local price_lab = ccui.Text:create("", "fonts/fzzy.ttf", 42)--cc.Label:createWithTTF("1", "fonts/fzzy.ttf", 52)
    item:addChild(price_lab)
    price_lab:setPosition(cc.p(130,item:getContentSize().height/2-55))
    price_lab:setContentSize(cc.size(200,price_lab:getContentSize().height ))
    price_lab:setTextColor(cc.c4b(255, 255, 255, 255))
    --price_lab:enableOutline(cc.c4b(255, 255, 255, 255), 4)
    --LANG["shop_currency_text"]
    price_lab:setString(string.format("%s%s","$",product.price_en))
    --price_lab:setAnchorPoint(0,0.5)
    price_lab:setAnchorPoint(0.5,0.5)

    local pay_button = ccui.Button:create( "pay_btn.png", "pay_btn.png")
    item:addChild(pay_button)
    pay_button:setAnchorPoint(cc.p(0.5,0.5))
    pay_button:setPosition(item:getContentSize().width/2,item:getContentSize().height/2-150)
    pay_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 42})
    pay_button:setTitleText(LANG["shop_pay_text"])
    pay_button.ext = product 
    pay_button:addTouchEventListener(payAction)
end

-- function ShopView:synProductData(product)
-- end 
function ShopView:synProductsData(products)
    self.pageView:removeAllPages()
	local pagesize=6
    local recordcount=#products
    local pagecount=(recordcount+pagesize-1)/pagesize

--    for i=1,count do
--        local nextp=(i-1)*size+size
--
--        if i==count  then
--            nextp=#a-(i-1)*size
--            nextp=(i-1)*size+nextp
--        end
--        for j=(i-1)*size+1,nextp do
--           print(string.format("page %d and itme %s",i,a[j]))
--        end
--     end



    for i=1,pagecount do
        local layout = ccui.Layout:create()
        layout:setContentSize(self.pageView:getContentSize())
        --layout:setBackGroundImage("bg.png")
        local nextp=(i-1)*pagesize+pagesize
        if i==pagecount  then
            nextp=recordcount-(i-1)*pagesize
            nextp=(i-1)*pagesize+nextp
        end
        local it = 1
        for j=(i-1)*pagesize+1,nextp do
            --print(string.format("page %d and itme %s",i,a[j]))
            local product = products[j]
            local imageView = ccui.ImageView:create()
            imageView:setTouchEnabled(true)
            --imageView:setScale9Enabled(true)
            imageView:loadTexture( "shop_item_bg.png" )
            if it>3 then
                imageView:setPosition(cc.p((it-1-3)*imageView:getContentSize().width+imageView:getContentSize().width/2+(it-1-3)*20, layout:getContentSize().height-(imageView:getContentSize().height/2+imageView:getContentSize().height+30)))
            else
                imageView:setPosition(cc.p((it-1)*imageView:getContentSize().width+imageView:getContentSize().width/2+(it-1)*20, layout:getContentSize().height-(imageView:getContentSize().height/2  )))
            end
            product.ownView = self.ownView
             --synProductData(imageView,product)
            self:synProductData(imageView,product)
            layout:addChild(imageView)
            it = it + 1
            print(string.format("page %d  ",i))
        end
--        local imageView = ccui.ImageView:create()
--        imageView:setTouchEnabled(true)
--        imageView:setScale9Enabled(true)
--        imageView:loadTexture( "option_card_bg.png" )
--        --imageView:setContentSize(self.optionbg:getContentSize())
--        imageView:setPosition(cc.p(layout:getContentSize().width / 2, layout:getContentSize().height / 2))
--        imageView:setTag(102)
--        layout:addChild(imageView)
        self.pageView:addPage(layout)
        -- self.cards[groups[i].name]=imageView
        --setItem(imageView,{title=groups[i].title,enterfee=groups[i].enterfee,prize=groups[i].prize,onlinecount=0})

    end





end
function ShopView:loadProducts()
    self.ownView:getApp():showLoadingInView(self.ownView)
    self.ownView.app_.client:request("product",{} , function(obj)
        products = obj.goods
        if products == nil then
            products = {}
        end
        self:synProductsData(products)
        self.ownView:getApp():hideLoadingView()
    end)
end
function ShopView:onExit()
   
    print("ShopView exit")
end
function ShopView:dismiss()
 
    playSound(GAME_SFXS.buttonClick)
    self:onExit()
    self.ownView:removeChild(self)
    --LuaObjcBridge.callStaticMethod("AppController","hiddenBar",nil)
    hiddenGoogleAd_bar()
end
function ShopView:onTouch(event)

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
return ShopView
