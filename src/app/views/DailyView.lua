local DailyView = class("DailyView",cc.Node)
 
local items = {}
local own = nil;
function DailyView:ctor(view)
	self.ownView = view
    own = view
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255/2))
    self.bg:setTouchEnabled(false)
    self:addChild(self.bg)
    display.newLayer()
        :onTouch(handler(self, self.onTouch),false,true)
        :addTo(self)
    self._bg = display.newSprite("daily_bg.png")
        :move(display.center)
        :addTo(self)
 
    local titlel = cc.Label:createWithTTF(LANG["daily_title_text"], "fonts/fzzy.ttf", 68)
        :addTo(self._bg)    
    titlel:enableOutline(cc.c4b(116, 54, 25, 255), 4)
    titlel:setPosition(cc.p(self._bg:getContentSize().width/2,self._bg:getContentSize().height-32-titlel:getContentSize().height/2))
   
    
  
--    for i=1,7 do
--        local inputBg = ccui.ImageView:create()
--        inputBg:loadTexture("daily_item_bg_1.png")
--        inputBg:setPosition(cc.p(self._bg:getContentSize().width / 2.0, self._bg:getContentSize().height / 1.5))
--        self._bg:addChild(inputBg)   
--    
--    end
--    
     
        
        local offset = cc.p(78,-165)
        for i=1,7 do 
           -- local product = products[j]
            local imageView = ccui.ImageView:create()
            imageView:setTouchEnabled(true) 
            if i == 7 then
              imageView:loadTexture( "daily_item_bg_2.png" )
              
            else
              imageView:loadTexture( "daily_item_bg_1.png" )
            end
            
            
            if i>4 then
                imageView:setPosition(cc.p(offset.x + (i-1-4)*imageView:getContentSize().width+imageView:getContentSize().width/2+(i-1-4)*20,offset.y+ self._bg:getContentSize().height-(imageView:getContentSize().height/2+imageView:getContentSize().height+30)))
            else
                imageView:setPosition(cc.p(offset.x + (i-1)*imageView:getContentSize().width+imageView:getContentSize().width/2+(i-1)*20,offset.y+ self._bg:getContentSize().height-(imageView:getContentSize().height/2  )))
            end
            if i==7 then
                 local oldp = cc.p(imageView:getPosition())
                 imageView:setPosition(cc.p(oldp.x-460,oldp.y+5))
                 
              
                
            end
            
            
              local lab = ccui.Text:create(LANG[string.format( "daily_%i_text",i)], "fonts/fzzy.ttf", 32)
              lab:setPosition(cc.p(imageView:getContentSize().width/2,imageView:getContentSize().height-lab:getContentSize().height))
              lab:setTextColor(cc.c4b(143, 84, 8, 255))
              lab:setName(string.format("day_%d",i))
              local icon =  ccui.ImageView:create()
              icon:loadTexture( string.format("daily_coin_%d.png",i ) )
              icon:setPosition(cc.p(imageView:getContentSize().width/2,imageView:getContentSize().height/2))
              icon:setName(string.format("icon_%d",i))
              local count = ccui.Text:create("000", "fonts/fzzy.ttf", 46)
              count:setPosition(cc.p(imageView:getContentSize().width/2,count:getContentSize().height-10))
              count:setTextColor(cc.c4b(203, 138, 72, 255))
              count:enableOutline(cc.c4b(255, 255, 255, 255), 4)
              count:setName(string.format("count_%d",i))
              local mark =  ccui.ImageView:create()
              mark:loadTexture("recv_mark.png")
              mark:setPosition(cc.p(imageView:getContentSize().width/2,imageView:getContentSize().height/2-30))
              mark:setName(string.format("mark_%d",i))
              local tt = ccui.Text:create(LANG["daily_received_text"], "fonts/fzzy.ttf", 46)
              tt:setTextColor(cc.c4b(230, 76, 76, 255))
              tt:setPosition(cc.p(mark:getContentSize().width/2,mark:getContentSize().height/2-15))
             
              mark:addChild(tt)
              mark:setRotation(-55)
              mark:setVisible(false)
              imageView:addChild(lab)
              imageView:addChild(icon)
              imageView:addChild(count)
             imageView:addChild(mark)
            
            imageView:setName(string.format("item_%d",i))
            -- synProductData(imageView,product)
            self._bg:addChild(imageView)
            --it = it + 1
            print(string.format("page %d  ",i))
            
        end  
 
 
    local recv_button = ccui.Button:create( "name_input_btn.png", "name_input_btn.png")
    local function submit(sender,type)
        if type~=2 then
        	   return
        end
        playSound(GAME_SFXS.buttonClick)
        if self.recv_day.day>0 then
            self.ownView:getApp():showLoadingInView(self.ownView)
            local count = self.recv_day.coin_count
            local day = self.recv_day.day
            local client = self.ownView.app_.client
            local app = self.ownView.app_
            client:request("signdaily",{day = day } , function(obj)
                               --print("obj.result ", obj.result )
                               app:hideLoadingView()
                               if obj.result then
                                   playDropCoins(own)
                                  -- promptText(string.format( LANG["daily_recv_succ_text"],self.recv_day.coin_count),own)
                                   promptText(string.format( LANG["daily_recv_succ_text"],count),own)
                                   -- local view = self.ownView.app_:enterScene("MainView")
                                   self.ownView:refreshUserInfo()
                                   self:dismiss()
                               else
                                   promptText(LANG["error_text"],self)
                               end
             end)
         else
             promptText(LANG["error_text"],self)
         end
       
    end
    recv_button:setPosition(self._bg:getContentSize().width/2,recv_button:getContentSize().height+40 )
    recv_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 60})
    --recv_button:setTitleColor(cc.c3b(255, 255, 255))
    recv_button:setTitleText(LANG["daily_recv_text"] )
    recv_button:addTouchEventListener(submit)
    self._bg:addChild(recv_button)
       
  
  
  
  
  
  
	
	self.ownView:addChild(self,100)
    if #items==0 then
        self:loadDaily()
    else
        self:syncItems(items)
    end
end
function DailyView:syncItems(items)
      --state 1 able recv  2 recved  3 unable recv
     for i=1,#items do
          local item = self._bg:getChildByName(string.format( "item_%d",items[i].day))
          local dayl =  item:getChildByName(string.format("day_%d",items[i].day))
          local countv =  item:getChildByName(string.format("count_%d",items[i].day))
          countv:setString(string.format("x%d",items[i].coin_count))
          countv:setTextColor(cc.c4b(203, 138, 72, 255))
          dayl:setTextColor(cc.c4b(143, 84, 8, 255))
          if items[i].state == 1 then
             item:loadTexture( "daily_item_bg_0.png" )
             countv:setTextColor(cc.c4b(255, 255, 255, 255))
             dayl:setTextColor(cc.c4b(55, 106, 0, 255))
             self.recv_day = items[i]
          elseif items[i].state == 2 then
             item:loadTexture( "daily_item_bg_1.png" )
          elseif items[i].state == 3 then
             
          end
          
     end
       
end
function DailyView:loadDaily()
   self.ownView:getApp():showLoadingInView(self.ownView)
   self.ownView.app_.client:request("daily",{} , function(obj)
         items = obj.items
         print(string.format("itmes %d",#obj.items))
          self.ownView:getApp():hideLoadingView()
         self:syncItems(items)
         for k,v in ipairs(obj.items) do
           print("k,v ",k,v) 
         end

    end)
end
function DailyView:onTouch(event)

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
function DailyView:dismiss()
   -- LuaObjcBridge.callStaticMethod("AppController","addPage",{hello=""})
    items = {}
    self.ownView:removeChild(self)
    insertGooglePageAd_bar()
end
return DailyView