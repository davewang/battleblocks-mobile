local MailView = class("MailView",cc.Node)
local Lab_Tag = 100
local friendMessages = {}
local systemMessages = {}
require "app.MessageDispatchCenter"
local function getCoinCount(ext)
     if ext == nil then
        ext = ""
     end
     for k,v in string.gmatch(ext, "(%w+):(%w+)") do   
           -- print(k,v)   
            if k=="coin" then
                return v
            end
     end
     return 0
end
function MailView:ctor(view)
    print("MailView ctor")
  --  LuaObjcBridge.callStaticMethod("AppController","showBar",nil)
    showGoogleAd_bar()
    self.ownView = view
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255/2))
    self.bg:setTouchEnabled(false)
    self:addChild(self.bg)
    display.newLayer()
        :onTouch(handler(self, self.onTouch),false,true)
        :addTo(self)
    self._bg = display.newSprite("mail_bg.png")
        :move(display.center)
        :addTo(self)
        
--           "mail_title_text":"Mail",
--      "mail_coin_text":"Coin",
--      "mail_sys_text":"System",
--      "mail_recv_all_text":"Receive All",
--      "mail_recv_text":"Receive"
    local titlel = cc.Label:createWithTTF(LANG["mail_title_text"], "fonts/fzzy.ttf", 68)
        :addTo(self._bg)    
    titlel:enableOutline(cc.c4b(116, 54, 25, 255), 4)
    titlel:setPosition(cc.p(self._bg:getContentSize().width/2,self._bg:getContentSize().height-32-titlel:getContentSize().height/2))
   
   
    local coin_button = ccui.Button:create( "mail_tab_btn_press.png", "mail_tab_btn_press.png")
    local sys_button = ccui.Button:create( "mail_tab_btn_normal.png", "mail_tab_btn_normal.png")
    
    self.uread1 = ccui.ImageView:create()
    self.uread1:loadTexture("uread_red_mark.png")
    self.uread1:setAnchorPoint(cc.p(0,0))
    self.uread1:setPosition(cc.p(coin_button:getContentSize().width-50,coin_button:getContentSize().height-40))
    self.uread1:setName("uread1") 
    coin_button:addChild(self.uread1)
    
    
    coin_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 46})
    coin_button:setTitleColor(cc.c3b(105, 32, 9))
    coin_button:setTitleText(LANG["mail_coin_text"] )
    
    sys_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 46})
    sys_button:setTitleColor(cc.c3b(211, 113, 36))
    sys_button:setTitleText(LANG["mail_sys_text"])
    
    
      self.uread2 = ccui.ImageView:create()
      self.uread2:loadTexture("uread_red_mark.png")
      self.uread2:setAnchorPoint(cc.p(0,0))
      self.uread2:setPosition(cc.p(sys_button:getContentSize().width-50,sys_button:getContentSize().height-40))
      self.uread2:setName("uread2") 
      sys_button:addChild( self.uread2 )
      self.uread1:setVisible(false)
      self.uread2:setVisible(false)
    
    coin_button:setPosition(coin_button:getContentSize().width/2+72,self._bg:getContentSize().height-317+coin_button:getContentSize().height/2)
    sys_button:setPosition(coin_button:getPositionX()+sys_button:getContentSize().width+13,self._bg:getContentSize().height-317+sys_button:getContentSize().height/2)
    
    self._bg:addChild(coin_button)
    self._bg:addChild(sys_button)
    
    
     local function selected(current)
        self.selected:setTitleColor(cc.c3b(211, 113, 36))
        self.selected:loadTextureNormal("mail_tab_btn_normal.png")
        self.selected = current
        self.selected:setTitleColor(cc.c3b(105, 32, 9))
        self.selected:loadTextureNormal("mail_tab_btn_press.png")
    end

 
    local function callback(ref, type)
        if type~=2 then
        	   return
        end
        local t = ref:getTag()
        if t==1001 then
            
            selected(ref)
            if #friendMessages==0 then
                self:loadData(t)
            else
                self:synFriendsMessages(friendMessages)
            end
        elseif t==1002 then
            self.receiveall_button:setVisible(false)
            selected(ref)
            if #systemMessages==0 then
                self:loadData(t)
            else
                self:synSystemMessages(systemMessages)
            end
        	 
        end
        print("type ",type)

    end
    coin_button:addTouchEventListener(callback)
    sys_button:addTouchEventListener(callback)
    sys_button:setTag(1002)
    coin_button:setTag(1001)
    self.selected = coin_button
    
    
    
    
    
    
  

    
    
    
    
    
    
    
    
    
    
    
    
    
    local function listViewEvent(sender, eventType)
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
   -- self.listView:setContentSize(cc.size(850,  950))
    self.listView:setContentSize(cc.size(870,  950-60))
    self.listView:setPosition(cc.p(80,300+60))
    self.listView:addEventListener(listViewEvent)
    self.listView:addScrollViewEventListener(scrollViewEvent)
    self._bg:addChild(self.listView)
    local function recv(sender,type)
    
    
         if type~=2 then
        	   return
         end
         print("msgid ", sender.msgid)   
         self.ownView.app_.client:request("delmessage",{id=sender.msgid} , function(obj)
              if obj.result then
              
                 local current = self.ownView.app_:getCurrentUser()
                 --play anmaition
                 if sender.msgtype == 0 then
                 
                       local recv_coin = getCoinCount(systemMessages[sender.index].extatt)
                       if tonumber(recv_coin) > 0 then
                          
                           self.ownView.app_.client:request("addCoin",{count = tonumber( recv_coin),type=0} , function(obj)
                               --print("obj.result ", obj.result )
                               
                           
                               if obj.result then
                                   print("playDropCoins", obj.result )
                                   playDropCoins(self)
                                   promptText(string.format( LANG["daily_recv_succ_text"],recv_coin),self)
                                   print("playDropCoins end")
                                   print("dispatchMessage ", obj.result )
                                   MessageDispatchCenter:dispatchMessage(MessageDispatchCenter.MessageType.REFRESH_USERINFO)
                               end
                                 
                          end)
                       end
                      
        	          table.remove(systemMessages,sender.index)
                      self:synSystemMessages(systemMessages)
                 elseif sender.msgtype == 1 then
                     local recv_coin = getCoinCount(friendMessages[sender.index].extatt)
                       if tonumber( recv_coin) > 0 then
                          self.ownView.app_.client:request("addCoin",{count = tonumber( recv_coin),type=0}, function(obj)
                               print("obj.result ", obj.result )
                               if obj.result then
                                 print("dispatchMessage ", obj.result )
                                 playDropCoins(self)
                                 promptText(string.format( LANG["daily_recv_succ_text"],recv_coin),self)

                                 MessageDispatchCenter:dispatchMessage(MessageDispatchCenter.MessageType.REFRESH_USERINFO)
                               end
                          end)
                       end
                      table.remove(friendMessages,sender.index)
                      self:synFriendsMessages(friendMessages)
                 end   
              end
         end)   
       
         -- local msgid = sender.msgid
         -- print("msgid ", msgid)
          
    end

    local function createMode() 
        local bg = ccui.Layout:create()
        bg:setTouchEnabled(true)
        bg:setContentSize(cc.size(850,222))
        
        local bgView = ccui.ImageView:create()
        bgView:loadTexture("row_bg.png")
        bgView:setAnchorPoint(cc.p(0,0))
        bgView:setPosition(cc.p(0,0))
        bgView:setName("bg") 
        bg:addChild(bgView)
        
     
        --
        local lab = ccui.Text:create("您收到好友霸王鸭20枚金币，快去感谢他吧。", "fonts/fzzy.ttf", 38)--cc.Label:createWithTTF("1", "fonts/fzzy.ttf", 52)
        lab:ignoreContentAdaptWithSize(false)
        bgView:addChild(lab)
        lab:setContentSize(cc.size(577,200))
        lab:setPosition(cc.p(48,bgView:getContentSize().height-lab:getContentSize().height/2-20))
        --goal_lab:move(42,bg:getContentSize().height/2)
        lab:setColor(cc.c4b(105, 32, 9, 255))

        local recv_button = ccui.Button:create( "recv_btn.png", "recv_btn.png")
        recv_button:setPosition( cc.p(cc.p(lab:getPosition()).x+lab:getContentSize().width+20,bg:getContentSize().height/2.6))
--        recv_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 42})
--        recv_button:setTitleColor(cc.c3b(255, 255, 255))
--       
--        recv_button:setTitleText(LANG["mail_recv_text"] )
        recv_button:addTouchEventListener(recv)
        recv_button:setAnchorPoint(cc.p(0,0.5))
        recv_button:setName("recvBtn") 
        bgView:addChild(recv_button)
        local t = ccui.Text:create(LANG["mail_recv_text"], "fonts/fzzy.ttf", 42)
         t:setPosition( cc.p( recv_button:getContentSize().width/2,recv_button:getContentSize().height/2))
          t:setName("title") 
        recv_button:addChild(t)


        local timelab = ccui.Text:create("10小时", "fonts/fzzy.ttf", 42)
            --:addTo(bg)
        bgView:addChild(timelab)
        timelab:setContentSize(cc.size(170,timelab:getContentSize().height))
        timelab:setPosition( cc.p(cc.p(lab:getPosition()).x+lab:getContentSize().width+timelab:getContentSize().width/2+40,bg:getContentSize().height/1.4))
        timelab:setColor(cc.c4b(213, 118, 41, 255))

        lab:setAnchorPoint(cc.p(0,0.5))
        timelab:setAnchorPoint(cc.p(0.5,0.5))
        timelab:setName("item2") 
        lab:setName("item1") 
        local uread = ccui.ImageView:create()
        uread:loadTexture("uread_red_mark.png")
        uread:setAnchorPoint(cc.p(0,0))
        uread:setPosition(cc.p(15,bgView:getContentSize().height-40))
        uread:setName("uread") 
        bgView:addChild(uread)
      
        return bg
    end
     -- create model
     self.listView:setItemModel(createMode())

    
    
    
    self.receiveall_button = ccui.Button:create( "recv_all_btn.png", "recv_all_btn.png")
    local function receiveAll(sender,type)
       if type~=2 and #friendMessages>0 then
        	   return
         end
         
         self.ownView.app_.client:request("recvall",{type=1} , function(obj)
              if obj.result then
                -- friendMessages = {}
                -- self:synFriendsMessages(friendMessages)
                 local sum = 0
                 for i=1,#friendMessages do
                    local msg = friendMessages[i]
                    local recv_coin = getCoinCount(msg.extatt)
                    if tonumber(recv_coin) > 0 then
                        sum = sum + tonumber(recv_coin) 
                    end
                 end
                 print("sum = ",sum)
                     if sum > 0 then
                          self.ownView.app_.client:request("addCoin",{count = sum,type=0} , function(obj)  
                               print("obj.result ", obj.result )
                               playDropCoins(self.ownView,1)
                               promptText(string.format( LANG["daily_recv_succ_text"],sum),self.ownView)

                               if obj.result then
                                   print("dispatchMessage ", obj.result )
                                   MessageDispatchCenter:dispatchMessage(MessageDispatchCenter.MessageType.REFRESH_USERINFO)
                               end
                                 
                          end)
                       end
                   friendMessages = {}
                   self:synFriendsMessages(friendMessages)
              end
         end)   
    end
    self.receiveall_button:setPosition(self._bg:getContentSize().width/2,self._bg:getContentSize().height/6)
    self.receiveall_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 56})
    self.receiveall_button:setTitleColor(cc.c3b(255, 255, 255))
    self.receiveall_button:setTitleText(LANG["mail_recv_all_text"])
    self.receiveall_button:addTouchEventListener(receiveAll)
    self._bg:addChild(self.receiveall_button)
    self.receiveall_button:setVisible(false)
    
    local close_button = ccui.Button:create( "red_close_btn.png", "red_close_btn.png")
    local function close()
       self:dismiss()
   
    end
    close_button:setPosition(self._bg:getContentSize().width-close_button:getContentSize().width/2-22,self._bg:getContentSize().height-183+close_button:getContentSize().height/2+10)

    close_button:addTouchEventListener(close)
    self._bg:addChild(close_button)
    self.ownView:addChild(self,100)
    
    if #friendMessages==0 then
        self:loadData(1001)
    else
        self:synFriendsMessages(friendMessages)
    end
    
end
 
function MailView:loadData(type)
       
      if type == 1001 then
          self.ownView.app_.client:request("inbox",{type=1} , function(obj)
                friendMessages = obj.messages 
               
                if friendMessages == nil then
                	   friendMessages = {}
                end
                print(string.format("friendMessages count = %d",#friendMessages))
                self:synFriendsMessages(friendMessages)
                
                 self.ownView.app_.client:request("readallmessagebytype",{type=1} , function(obj)
                      if obj.result then
                	      print("read ok!")
                          MessageDispatchCenter:dispatchMessage(MessageDispatchCenter.MessageType.CHECK_INBOX_NOTIFY,"")
                      end
                 end) 
                 
                
                
        end) 
      elseif type == 1002 then
          self.ownView.app_.client:request("inbox",{type=0}, function(obj)
                systemMessages = obj.messages
                --print(string.format("ranks %d",#obj.ranks))
                if systemMessages == nil then
                    systemMessages = {}
                end
                print(string.format("systemMessages count = %d",#systemMessages))
                self:synSystemMessages(systemMessages)
                
                
                self.ownView.app_.client:request("readallmessagebytype",{type=0} , function(obj)
                      if obj.result then
                	      print("read ok!")
                          MessageDispatchCenter:dispatchMessage(MessageDispatchCenter.MessageType.CHECK_INBOX_NOTIFY,"")
                      end
                end)
                
           end)
   
      end 
     
  
end

function MailView:synFriendsMessages(messages)
    self.listView:removeAllItems()
    for i = 1,#messages do
        self.listView:pushBackDefaultItem()
    end

    local items_count  = table.getn(self.listView:getItems())
    for i = 1,items_count do
        local item = self.listView:getItem(i - 1):getChildByName("bg")
        local contentLab = item:getChildByName("item1")
     	contentLab:setString(  string.format(LANG["mail_row_text"], messages[i].sendname,getCoinCount(messages[i].extatt)))
        
        self.receiveall_button:setVisible(true)
        local mark = item:getChildByName("uread")
        if messages[i].state > 0   then
            mark:setVisible(false)
        else
            mark:setVisible(true)
            
            self.uread1:setVisible(true)
        end
        local timeLab = item:getChildByName("item2")
        
        timeLab:setString(timeago(messages[i].sendtime)) 
        
        item:getChildByName("recvBtn").msgid = messages[i].id
         item:getChildByName("recvBtn").index = i
          item:getChildByName("recvBtn").msgtype = 1 
    end
    if #messages==0 then
        self.uread1:setVisible(false)
        self.noDataLabel =  ccui.Text:create(string.format("                   %s",LANG["no_data"]), "fonts/fzzy.ttf", 68)
        self.noDataLabel:setPosition(cc.p(200,self.listView:getContentSize().height/2))
        self.noDataLabel:setColor(cc.c4b(105, 32, 9, 255))
        self.listView:addChild(self.noDataLabel)
        self.receiveall_button:setVisible(false)
    end

end
function MailView:synSystemMessages(messages)
    self.listView:removeAllItems()
    for i = 1,#messages do
        self.listView:pushBackDefaultItem()
    end

    local items_count  = table.getn(self.listView:getItems())
    for i = 1,items_count do
        local item = self.listView:getItem(i - 1):getChildByName("bg")
        local timeLab = item:getChildByName("item2")
        timeLab:setString(timeago(messages[i].sendtime)) 
        local contentLab = item:getChildByName("item1")
        local coin = getCoinCount(messages[i].extatt)
        
        item:getChildByName("recvBtn").msgid = messages[i].id
        item:getChildByName("recvBtn").index = i
        item:getChildByName("recvBtn").msgtype = 0
        
        local mark = item:getChildByName("uread")
        if messages[i].state > 0   then
            mark:setVisible(false)
        else
            mark:setVisible(true)
            
            self.uread2:setVisible(true)
        end
        
        if  tonumber(coin) > 0 then
           contentLab:setString( string.format(LANG["mail_sys_row_text"],LANG["mail_sys_text"],coin))
        else
          local btnLab = item:getChildByName("recvBtn"):getChildByName("title")
           btnLab:setString(LANG["mail_del_text"])
           contentLab:setString(messages[i].content)
        end
    end
    if #messages==0 then
    
         self.uread2:setVisible(false)
        self.noDataLabel =  ccui.Text:create(string.format("                   %s",LANG["no_data"]), "fonts/fzzy.ttf", 68)
        self.noDataLabel:setPosition(cc.p(200,self.listView:getContentSize().height/2))
        self.noDataLabel:setColor(cc.c4b(105, 32, 9, 255))
        self.listView:addChild(self.noDataLabel)
    end

end
function MailView:onExit()
 
    friendMessages = {}
    systemMessages = {}
    print("MailView exit")
end
function MailView:onTouch(event)

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
function MailView:dismiss()
    self:onExit()
    playSound(GAME_SFXS.buttonClick)
    self.ownView:removeChild(self)
    --LuaObjcBridge.callStaticMethod("AppController","hiddenBar",nil)
    hiddenGoogleAd_bar()
end
return MailView