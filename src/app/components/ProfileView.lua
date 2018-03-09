local ProfileView = class("ProfileView",cc.Node)
function ProfileView:ctor(view,callback)
     self.head_bg = display.newSprite("#main_head_bg.png")
     
     
     self.avatar = display.newSprite("#profile_default_picture.png")
     --self.head_bg:addChild(self.avatar)
    -- stretchSprite(self.avatar,146/2,140/2)
     stretchSprite(self.avatar,146,140)
  
     
     self.head_bg:setPosition(cc.p(self.head_bg:getContentSize().width/2,display.top_center.y-self.head_bg:getContentSize().height/2))
     
     --计算
     local px,py = self.head_bg:getPosition()
     local ps = self.head_bg:getContentSize()
     local offset = cc.p(px-ps.width/2+self.avatar:getContentSize().width-36.5,py-ps.height/2+148)
     self.avatar:setPosition(offset)
     
      self:addChild(self.avatar)
     self:addChild(self.head_bg)
     self.nickLabel = cc.Label:createWithTTF( {fontFilePath ="fonts/fzzy.ttf",fontSize=52},"davewang", cc.TEXT_ALIGNMENT_LEFT,0)-- cc.Label:createWithTTF("dave wang", "fonts/BPreplay.ttf", 96)
        :addTo(self.head_bg)
     self.nickLabel:setAnchorPoint(cc.p(0,0.5)) 
     self.nickLabel:setPosition(cc.p(230,self.head_bg:getContentSize().height-18-self.nickLabel:getContentSize().height/2))
     self.nickLabel:setColor(cc.c4b(72,29,0,255))
     self.nickLabel:enableOutline(cc.c4b(255, 255, 0, 255), 1)
     self.nickLabel:enableShadow(cc.c4b(0, 0, 0, 255))
    
    -- self.avatar:setPosition(cc.p(self.avatar:getContentSize().width/2+10 ,self.head_bg:getContentSize().height-self.avatar:getContentSize().height/4 -40 ))
  
     --129 137
    -- self.avatar:setScale(0.33)
    -- self.avatar:setPosition(cc.p(self.avatar:getContentSize().width/2+10 ,self.head_bg:getContentSize().height-self.avatar:getContentSize().height/4 -40 ))
  
    self.xpprogress = ccui.LoadingBar:create()
    self.xpprogress:setTag(0)
    self.xpprogress:setName("xp")
    self.xpprogress:loadTexture("xp_progress.png")--#xp_progress.png
    self.xpprogress:setDirection(0)
    --self.xpprogress:setScale9Enabled(true)
    self.xpprogress:setPercent(50)
    self.xpprogress:move(cc.p(299+self.xpprogress:getContentSize().width/2,106))
    self.xpprogress:addTo(self.head_bg)
     
    self.levelpro = cc.Label:createWithTTF({fontFilePath ="fonts/zyjt.ttf",fontSize=24}, "LVL", cc.TEXT_ALIGNMENT_LEFT,0)
    self.levelpro:addTo(self.head_bg)
    self.levelpro:setAnchorPoint(cc.p(0.5,0.5)) 
    self.levelpro:setPosition(cc.p(260,self.head_bg:getContentSize().height-105-self.levelpro:getContentSize().height/2))
    self.levelpro:setColor(cc.c4b(251,207,50,255))
    
    self.levelLabel = cc.Label:createWithTTF({fontFilePath ="fonts/zyjt.ttf",fontSize=36}, "1", cc.TEXT_ALIGNMENT_LEFT,0)
    self.levelLabel:addTo(self.head_bg)
    self.levelLabel:setAnchorPoint(cc.p(0.5,0.5)) 
    self.levelLabel:setPosition(cc.p(260,self.head_bg:getContentSize().height-125-self.levelLabel:getContentSize().height/2))
    self.levelLabel:setColor(cc.c4b(251,207,50,255))
    
    local item1 = cc.MenuItemImage:create("head_coin_add.png", "head_coin_add.png")

    self.coinLabel = cc.Label:createWithTTF("0", "fonts/fzzy.ttf", 42)
        :move(item1:getContentSize().width/2,item1:getContentSize().height/2)
        :addTo(item1) 
    self.coinLabel:setColor(cc.c4b(255,255,171,255))
    item1:registerScriptTapHandler(callback)
    local menu = cc.Menu:create()
    menu:addChild(item1)
    menu:setPosition(cc.p(0, 0))
    item1:setPosition(cc.p(700+item1:getContentSize().width/2, self.head_bg:getContentSize().height-item1:getContentSize().height/2-20))
    menu:addTo(self.head_bg)
   
--    display.newLayer()
--         :onTouch(handler(self, self.onTouch))
--         :addTo(self)
end

function ProfileView:setUser(profile)

    --{avatar_id=self:getApp():getCurrentUser().avatarid,level= self:getApp():getCurrentUser().level,coin=self:getApp():getCurrentUser().coin,nickname=self:getApp():getCurrentUser().nickname}

    if profile.avatarid then
        self.avatar:setSpriteFrame(AVATER_TYPE[profile.avatarid])
        --self.avatar:setScale(1.5)
       -- stretchSprite(self.avatar,146,140)
       -- local offset = cc.p(px-ps.width/2+self.avatar:getContentSize().width+36.5,py-ps.height/2+148)
       -- self.avatar:setPosition(offset)
      
    end
    if profile.coin then
      local num1,unit = coin_to_string(profile.coin)
        --item3:setString(tostring(num1)..unit
        self.coinLabel:setString(tostring(num1)..unit)
       --self.coinLabel:setString(profile.coin)
    end
    if profile.level then
       self.levelLabel:setString(profile.level)
    end
    if profile.xp then
        local xpp = profile.xp/KM_LEVEL[profile.level]
        self.xpprogress:setPercent(xpp*100)
    end
    if profile.nickname then
       self.nickLabel:setString(profile.nickname)
    end
end
local function checkSpriteClick(sp,pos)
  local ponsition = cc.p(sp:getPosition())
  local s1 = sp:getContentSize()
  local touchRect = cc.rect(-s1.width / 2 + ponsition.x, -s1.height / 2 + ponsition.y, s1.width, s1.height)
  return cc.rectContainsPoint(touchRect, cc.p(pos.x,pos.y))
end
function ProfileView:onTouch(event)

    local label = string.format("swipe: %s", event.name)

    if event.name == 'began' then

        self.mx=event.x;
        self.my=event.y;

        return true
    elseif event.name == 'moved' then

        self.mx=event.x
        self.my=event.y
    elseif event.name == 'ended' then
        -- if checkSpriteClick(self.avatar,{x=self.mx,y=self.my}) then
        --    print("click avatar")
        -- end
        -- if checkSpriteClick(self.headXp,{x=self.mx,y=self.my}) then
        --    print("click head xp")
        -- end
        if checkSpriteClick(self.headCoin,{x=self.mx,y=self.my}) then
           print("click add coin")
        end



    end

end
return ProfileView
