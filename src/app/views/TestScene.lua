
local TestScene = class("TestScene", cc.load("mvc").ViewBase)
local SOCKET_TICK_TIME = 0.1 
function TestScene:onCreate()

 
    self.stars = display.newSprite("starfield-hd.jpg")
        :move(display.center)
        :addTo(self,-1)
    self.stars:runAction(cc.RepeatForever:create(cc.RotateBy:create(360,360)))

    self.client_a = require ("app.Client"):create()
    self.client_b = require ("app.Client"):create()
--    client.ConnectServer("127.0.0.1",8080)
    

    local scheduler = cc.Director:getInstance():getScheduler()
    cc.MenuItemFont:setFontName("CGF Locust Resistance")
    cc.MenuItemFont:setFontSize(44)
    local connectRequest =  cc.MenuItemFont:create("connect msg")
        :onClicked(function()
            self.client_a:ConnectServer("192.168.1.7",8080)
          --  self.client_b:ConnectServer("192.168.1.7",8080)

            --self:getApp():getUserManager():requestAuthBattle();

        end)
    local function authCb(client,data)
          print("auth ok!");
    end
    local authRequest =  cc.MenuItemFont:create("auth msg")
        :onClicked(function()
            local auth_a = {player_id="G:1152190469",user_name="noname5",rank_level=12,avatar_id=1}
            local auth_b = {player_id="G:1855665654",user_name="noname7",rank_level=12,avatar_id=1}
            MsgHandlers[GAME_OP_CODES.AUTH_BATTLE]= authCb
            self.client_a:SendJsonMsg(GAME_OP_CODES.AUTH_BATTLE,auth_a)
            self.client_b:SendJsonMsg(GAME_OP_CODES.AUTH_BATTLE,auth_b)

            --self:getApp():getUserManager():requestAuthBattle();

        end)
        
    local function matchedCb(client,data)
        print("auth ok!");
    end
    local function sendCb(client,data)
        print("auth ok!");
    end
    local function receivedCb(client,data)
        print("auth ok!");
    end
    local function cancelCb(client,data)
        print("cancel ok!");
    end
    local matchRequest =  cc.MenuItemFont:create("match msg")
        :onClicked(function()
            MsgHandlers[GAME_OP_CODES.START_MATCH]= matchedCb
            MsgHandlers[GAME_OP_CODES.SEND_MATCH_DATA]= sendCb
            MsgHandlers[GAME_OP_CODES.RECV_MATCH_DATA]= receivedCb
            MsgHandlers[GAME_OP_CODES.CANCEL_MATCH] = cancelCb
            MsgHandlers[GAME_OP_CODES.AUTH_BATTLE]= authCb
            local msg_a = {group=GAME_GROUP.G_ONE} 
            local msg_b = {group=GAME_GROUP.G_ONE} 
            self.client_a:SendJsonMsg(GAME_OP_CODES.START_MATCH,msg_a)
            self.client_b:SendJsonMsg(GAME_OP_CODES.START_MATCH,msg_b)
            
            --self:getApp():getMatchManager():requestMatchGameByGroup(GAME_GROUP.G_ONE);
 
        end)
    local battleRequest =  cc.MenuItemFont:create("battle msg")
        :onClicked(function()
            local msg_a = {a_say="nihao"} 
            local msg_b = {b_say="hello"} 
            for i=1,100 do  
            	 self.client_a:SendJsonMsg(GAME_OP_CODES.SEND_MATCH_DATA,msg_a)
                 self.client_b:SendJsonMsg(GAME_OP_CODES.SEND_MATCH_DATA,msg_b)
            end
           -- self.client_a:SendJsonMsg(GAME_OP_CODES.SEND_MATCH_DATA,msg_a)
           -- self.client_a:SendJsonMsg(GAME_OP_CODES.SEND_MATCH_DATA,msg_b)
            --self:getApp():getMatchManager():requestMatchGameByGroup(GAME_GROUP.G_ONE);

            end)
    local moreRequest =  cc.MenuItemFont:create("more msg")
        :onClicked(function()
            local msg_a = {a_say="nihao"} 
            local msg_b = {b_say="hello"} 
            local auth_a = {player_id="G:1152190469",user_name="noname5",rank_level=12,avatar_id=1}
           -- local auth_b = {player_id="G:1855665654",user_name="noname7",rank_level=12,avatar_id=1}
            MsgHandlers[GAME_OP_CODES.AUTH_BATTLE]= authCb
           
            for i=1,20 do  
                self.client_a:SendJsonMsg(GAME_OP_CODES.AUTH_BATTLE,auth_a)
                --self.client_a:SendJsonMsg(GAME_OP_CODES.AUTH_BATTLE,auth_a)
            end
            -- self.client_a:SendJsonMsg(GAME_OP_CODES.SEND_MATCH_DATA,msg_a)
            -- self.client_a:SendJsonMsg(GAME_OP_CODES.SEND_MATCH_DATA,msg_b)
            --self:getApp():getMatchManager():requestMatchGameByGroup(GAME_GROUP.G_ONE);

        end)
    connectRequest:setColor(cc.c4b(0,255,255,255))
    authRequest:setColor(cc.c4b(0,255,255,255))
    matchRequest:setColor(cc.c4b(0,255,255,255))
    battleRequest:setColor(cc.c4b(0,255,255,255))
    moreRequest:setColor(cc.c4b(0,255,255,255))
    cc.Menu:create(connectRequest,authRequest,matchRequest,battleRequest,moreRequest)
        :move(display.cx, display.cy-350)
        :addTo(self)
        :alignItemsVertically()
        
        
        
        
     
   
   -- self.connectTimeTickScheduler = scheduler:scheduleScriptFunc(__connectTimeTick, SOCKET_TICK_TIME,false)
--    local function update(dt)
--        client.RecvMsg();
--    end
--
--    local scheduler = cc.Director:getInstance():getScheduler()
--    local schedulerEntry = scheduler:scheduleScriptFunc(update, 1/30, false)
end
function TestScene:onReceived()
    
end
function TestScene:onEnter() 
    print("onEnter TestScene  ")

end
function TestScene:onExit() 
     
    print("onExit TestScene  ")

end


return TestScene