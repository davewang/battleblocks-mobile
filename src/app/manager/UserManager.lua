
local Listener = import(".Listener")
local UserManager = class("UserManager",Listener)
local userDefault = cc.UserDefault:getInstance()

require "app.MessageDispatchCenter"
function UserManager:ctor()
    UserManager.super.ctor(self)
    self.currentUser = nil
end

function UserManager:loginWithUserNameAndPass(username,password)


    local loged = self.app_.client:login(username,password,self.app_.platform_type)
    if loged then
        userDefault:setStringForKey(K_GAME_CENTER_ID, username)
        userDefault:setStringForKey(K_GAME_PWD_ID, password)
        self.app_.client:request("userinfo",{username=username} , function(obj)
            self.currentUser = obj.user
            currentLoginUser = self.currentUser
            if self.currentUser.fixnickname == nil or self.currentUser.fixnickname == 0 then
                self.app_:enterScene("FaceView")
            else
                local view = self.app_:enterScene("MainView")
                view:onLoginReceived()
                insertGooglePageAd_bar()
            end
        end)
        --notify
        local function notify()
            self.app_.client:request("matchnotify", {sid=""} , function(obj)
                if obj then
                    obj.state = "found"
                    --local msg = {msgtype = GAME_OP_CODES.START_MATCH, msgdata = obj}
                    --                    print(string.format( "matchnotify -----------> %s  ",msg.msgtype))
                    --                    local f = MsgHandlers[msg.msgtype]
                    --                    if not f then
                    --                        print("没有处理函数",msg.msgtype)
                    --                        return
                    --                    end
                    --                    self.app_:getMatchManager():onReceivedMatched("",msg)
                    MessageDispatchCenter:dispatchMessage(MessageDispatchCenter.MessageType.MATCH_NOTIFY,obj)
                    notify()
                end
            end)
        end
        notify()
        return true
    else
        return false
    end
end
function UserManager:login(username,platform)
    local loged = self.app_.client:login(username,"password",platform)
    if loged then
        self.app_.client:request("userinfo",{username=username} , function(obj)
            self.currentUser = obj.user
            currentLoginUser = self.currentUser 
            if self.currentUser.fixnickname == nil or self.currentUser.fixnickname == 0 then
                 self.app_:enterScene("FaceView")
            else
                 
                  local view = self.app_:enterScene("MainView")
                  view:onLoginReceived()
                  insertGooglePageAd_bar()
--                  self:addListener(view)
--                  for i=1,#self.listeners  do
--                     self.listeners[i]:onLoginReceived()
--                  end
            end
            
          
            --self:onLoginReceived()
           
        end)
        
        --notify
        local function notify()
            self.app_.client:request("matchnotify", {sid=""} , function(obj)
                if obj then
                    obj.state = "found"
                    --local msg = {msgtype = GAME_OP_CODES.START_MATCH, msgdata = obj}
--                    print(string.format( "matchnotify -----------> %s  ",msg.msgtype))
--                    local f = MsgHandlers[msg.msgtype]
--                    if not f then
--                        print("没有处理函数",msg.msgtype)
--                        return
--                    end
--                    self.app_:getMatchManager():onReceivedMatched("",msg)
                    MessageDispatchCenter:dispatchMessage(MessageDispatchCenter.MessageType.MATCH_NOTIFY,obj)
                    notify()
                end
            end)
        end
        notify()
    end       
end

function UserManager:refreshUserInfo()
       self.app_.client:request("userinfo",{username=""} , function(obj)
 
            self.currentUser=obj.user 
            currentLoginUser = self.currentUser
        end)
end
function UserManager:onLoginReceived()
      insertGooglePageAd_bar()
--    self.app_.client:request("daily",{} , function(obj)
--    
--          print(string.format("itmes %d",#obj.items))
--            for k,v in ipairs(obj.items) do
--           print("k,v ",k,v) 
--         end
--
--    end)
--    self.app_.client:request("product",{} , function(obj)
--
--            print(string.format("goods %d",#obj.goods))
--            for k,v in ipairs(obj.goods) do
--                print("k,v ",k,v) 
--            end
--
--    end)
--    
--    self.app_.client:request("friendrank",{} , function(obj)
--
--            print(string.format("ranks %d",#obj.ranks))
--            for k,v in ipairs(obj.ranks) do
--                print("k,v ",k,v) 
--            end
--
--    end)
--    self.app_.client:request("scorerank",{} , function(obj)
--
--            print(string.format("ranks %d",#obj.ranks))
--            for k,v in ipairs(obj.ranks) do
--                print("k,v ",k,v) 
--            end
--
--    end)
--    self.app_.client:request("worldrank",{} , function(obj)
--
--            print(string.format("ranks %d",#obj.ranks))
--            for k,v in ipairs(obj.ranks) do
--                print("k,v ",k,v) 
--            end
--
--    end)
--    self.app_.client:request("onlineinfo",{} , function(obj)
--
--            print(string.format("groups %d",#obj.groups))
--            for k,v in pairs(obj.groups) do
--                print("k,v ",k,v.count) 
--            end
--
--    end)
    
end
function UserManager:requestUpdateScore(score_) 
     self.app_.client:request("updatescore",{score = score_} , function(obj)
             if obj.result then
                 self.currentUser.score = score_
             end  
     end)
end
function UserManager:dispatch(event) 
    return false
end
function UserManager:getCurrentUser()
    return self.currentUser
end
 
return UserManager