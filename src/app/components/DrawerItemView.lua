local DrawerItemView = class("DrawerItemView")
function DrawerItemView:ctor(fileName,callback)
    self.board = cc.BillBoard:create(fileName)
    self.callback = callback
     
    
    --self:initItem(self.board)
end
function DrawerItemView:setData(options)
	if options.title then
        self.titlLab:setString( options.title)
	end
    if options.enterfee then
        self.enterLable:setString( options.enterfee)
    end
    if options.prize then
        self.prizeLable:setString( options.prize)
    end
    if options.online then
        self.onlineLable:setString( options.online)
    end
end
function  DrawerItemView:initItem(item)
    local node = display.newNode():addTo(item)
    node:setPosition(cc.p(0,0)) 
    local s = item:getContentSize()

    self.titlLab = cc.Label:createWithTTF("", "fonts/fzzy.ttf", 68) 
    self.titlLab:addTo(node)
    self.titlLab:setPosition(cc.p(s.width/2,s.height-65-self.titlLab:getContentSize().height/2))
    self.titlLab:enableOutline(cc.c4b(116, 53, 25, 255), 4)
    local bg1 = display.newSprite("#option_label_bg.png"):addTo(node)
    bg1:setPosition(cc.p(s.width/2,s.height - bg1:getContentSize().height-205+46))

    local enterPLable = cc.Label:createWithTTF("入场费:", "fonts/fzzy.ttf", 60)
        :addTo(bg1)
    enterPLable:setPosition(cc.p(bg1:getContentSize().width/2-60,bg1:getContentSize().height/2 ))
    enterPLable:setAnchorPoint(cc.p(1,0.5)) 
    enterPLable:setColor(cc.c4b(105,32,9,255))
    enterPLable:enableShadow(cc.c4b(0, 0, 0, 255))

    self.enterLable = cc.Label:createWithTTF("22", "fonts/fzzy.ttf", 60)
        :addTo(bg1)
    self.enterLable:setPosition(cc.p(bg1:getContentSize().width/2 ,bg1:getContentSize().height/2 ))
    self.enterLable:setAnchorPoint(cc.p(0,0.5)) 
    self.enterLable:setColor(cc.c4b(246,53,53,255))
    self.enterLable:enableShadow(cc.c4b(0, 0, 0, 255))

    local coin = display.newSprite("#option_coin.png")
        :addTo(bg1)
    coin:move(cc.p(cc.p(self.enterLable:getPosition()).x+200+coin:getContentSize().width/2,bg1:getContentSize().height/2 ))



    local bg2 = display.newSprite("#option_label_bg.png"):addTo(node)
    bg2:setPosition(cc.p(s.width/2,  cc.p(bg1:getPosition()).y - bg2:getContentSize().height -40))

    local onlinePLable = cc.Label:createWithTTF("在线人数:", "fonts/fzzy.ttf", 60)
        :addTo(bg2)
    onlinePLable:setPosition(cc.p(bg2:getContentSize().width/2-60,bg2:getContentSize().height/2 ))
    onlinePLable:setAnchorPoint(cc.p(1,0.5)) 
    onlinePLable:setColor(cc.c4b(105,32,9,255))
    onlinePLable:enableShadow(cc.c4b(0, 0, 0, 255))

    self.onlineLable = cc.Label:createWithTTF("1231", "fonts/fzzy.ttf", 60)
        :addTo(bg2)
    self.onlineLable:setPosition(cc.p(bg2:getContentSize().width/2,bg2:getContentSize().height/2 ))
    self.onlineLable:setAnchorPoint(cc.p(0,0.5)) 
    self.onlineLable:setColor(cc.c4b(246,53,53,255))
    self.onlineLable:enableShadow(cc.c4b(0, 0, 0, 255))


    local bg3 = display.newSprite("#option_label_bg.png"):addTo(node)
    bg3:setPosition(cc.p(s.width/2,  cc.p(bg2:getPosition()).y - bg3:getContentSize().height -40))

    local prizePLable = cc.Label:createWithTTF("战力品:", "fonts/fzzy.ttf", 60)
        :addTo(bg3)
    prizePLable:setPosition(cc.p(bg3:getContentSize().width/2-60,bg3:getContentSize().height/2 ))
    prizePLable:setAnchorPoint(cc.p(1,0.5)) 
    prizePLable:setColor(cc.c4b(105,32,9,255))
    prizePLable:enableShadow(cc.c4b(0, 0, 0, 255))

    self.prizeLable = cc.Label:createWithTTF("221", "fonts/fzzy.ttf", 60)
        :addTo(bg3)
    self.prizeLable:setPosition(cc.p(bg3:getContentSize().width/2,bg3:getContentSize().height/2 ))
    self.prizeLable:setAnchorPoint(cc.p(0,0.5)) 
    self.prizeLable:setColor(cc.c4b(246,53,53,255))
    self.prizeLable:enableShadow(cc.c4b(0, 0, 0, 255))
   
    local coinMore = display.newSprite("#option_coin_more.png")
        :addTo(bg3)
    coinMore:move(cc.p(cc.p(self.prizeLable:getPosition()).x+200+coinMore:getContentSize().width/2,bg3:getContentSize().height/2 ))
    
end
return DrawerItemView