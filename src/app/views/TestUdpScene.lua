local TestUdpScene = class("TestUdpScene", cc.load("mvc").ViewBase)
local socket = require "csocket"
local socket1 = require "csocket"
local proto = require "proto"
local timesync = require "timesync"
local open = 1
local timesync1 = require "timesync"
local scheduler = cc.Director:getInstance():getScheduler()
local function request(fd, type, obj, cb)
    local data, tag = proto.request(type, obj)
    local function callback(ok, msg)
        if ok then
            return cb(proto.response(tag, msg))
        else
            print("error:", msg)
        end
    end
    
    fd:request(data, callback)
end
local function dispatch(fd)
    local cb, ok, blob = fd:dispatch(0)
    if cb then
        cb(ok, blob)
    end
end
function TestUdpScene:onCreate()
    print("time.globaltime() == %d",timesync.globaltime()) 

    self.stars = display.newSprite("starfield-hd.jpg")
        :move(display.center)
        :addTo(self,-1)
    self.stars:runAction(cc.RepeatForever:create(cc.RotateBy:create(360,360)))
    local __connectTimeTick = function ()
        --printInfo("%s.connectTimeTick", self.name)
        if open==1 then
            if self.fd  then
                dispatch(self.fd) 
            end
        else
            if self.fd1  then
                dispatch(self.fd1) 
            end
        end
--        if self.fd and self.fd1 then
--            dispatch(self.fd)
--            dispatch(self.fd1)
--        end
       
    end 

    self.connectTimeTickScheduler = scheduler:scheduleScriptFunc(__connectTimeTick, 0.1,false)
    local __recvTimeTick = function ()
        --printInfo("%s.connectTimeTick", self.name)
        
            if open == 1  then
                if self.udp then
                	
                
                local time, session, data = self.udp:recv()
                if time then
                    print("UDP", "time=", time, "session =", session," client session =", self.fd.__session, "data=", data)
                end
               end
            else 
                if self.udp1 then
                local  time, session, data = self.udp1:recv()
                if time then
                    print("UDP", "time=", time, "session =", session," client session =", self.fd1.__session, "data=", data)
                end
                end
            end
        
    end 

    self.recvTimeTick = scheduler:scheduleScriptFunc(__recvTimeTick, 0.1,false)

    local scheduler = cc.Director:getInstance():getScheduler()
    cc.MenuItemFont:setFontName("CGF Locust Resistance")
    cc.MenuItemFont:setFontSize(44)
    local connectRequest =  cc.MenuItemFont:create("login")
        :onClicked(function()
            self.IP = "192.168.1.7"
            if open == 1  then
                self.fd = assert(socket.login {
                    host = self.IP,
                    port = 8001,
                    server = "sample",
                    user = "emma",
                    pass = "password",
                })
                self.fd:connect(self.IP, 8888)
            else
                self.fd1 = assert(socket1.login {
                    host = self.IP,
                    port = 8001,
                    server = "sample",
                    user = "dave",
                    pass = "password",
                })
                self.fd1:connect(self.IP, 8888)
            end
           
            
            --self.fd:connect(self.IP, 8888)
           -- self.fd1:connect(self.IP, 8888)
        end)
    
    local authRequest =  cc.MenuItemFont:create("connect")
        :onClicked(function()
         if open == 1  then
                request(self.fd, "matchnotify", { sid = "one" } , function(obj)
                    print(string.format("matchnotify %s",#obj.players))
                    print(string.format("notify count %s",#obj.players))
                    print(string.format("notify uid %s",obj.players[1].uid))
                    -- for k in pairs(vi) do
                    --    skynet.error(string.format("notify vi key = %s value = %s",k,vi[k]))
                    --  end
                    print(string.format("notify username %s",obj.players[1].nickname))
                    print(string.format("notify avatarid %d",obj.players[1].avatarid))
                    print(string.format("notify ranklevel %d",obj.players[1].ranklevel))
                    --print(string.format("matchnotify result:%s", obj))

                    for i=1,1000 do

                        if (i == 100 or i == 200 or i ==300 or i == 600) and self.udp then
                            local gtime = timesync1.globaltime()
                            if gtime then
                                print("send time", gtime)
                                self.udp:send ("dave" .. i .. ":1")
                            end
                        end
--                        if self.udp then
--                            local time, session, data = self.udp:recv()
--                            if time then
--                                print("UDP", "time=", time, "session =", session," client session =", self.fd.__session, "data=", data)
--                            end
--                        end

                    end


                end)
                
                request(self.fd, "info", {nickname="dave",uid="wang",ranklevel=12,avatarid=1} , function(obj)
                    print(string.format("result:", obj.result))
                end)
         
         else
                request(self.fd1, "matchnotify", { sid = "one" } , function(obj)
                    print(string.format("matchnotify %s",#obj.players))
                    print(string.format("notify count %s",#obj.players))
                    print(string.format("notify uid %s",obj.players[1].uid))
                    -- for k in pairs(vi) do
                    --    skynet.error(string.format("notify vi key = %s value = %s",k,vi[k]))
                    --  end
                    print(string.format("notify username %s",obj.players[1].nickname))
                    print(string.format("notify avatarid %d",obj.players[1].avatarid))
                    print(string.format("notify ranklevel %d",obj.players[1].ranklevel))
                    --print(string.format("matchnotify result:%s", obj))



                    for i=1,1000 do

                        if (i == 100 or i == 200 or i ==300 or i == 600) and self.udp then
                            local gtime = timesync.globaltime()
                            if gtime then
                                print("send time", gtime)
                                self.udp1:send ("emma" .. i .. ":1")
                            end
                        end
                        --                        if self.udp1 then
                        --                            local time, session, data = self.udp1:recv()
                        --                            if time then
                        --                                print("UDP", "time=", time, "session =", session," client session =", self.fd1.__session, "data=", data)
                        --                            end
                        --                        end

                    end
                end)
         
                request(self.fd1, "info", {nickname="emma",uid="qin",ranklevel=12,avatarid=1} , function(obj)
                    print(string.format("result:", obj.result))
                end)
 
         end
               
               
                --dispatch(self.fd)
                
               
                --dispatch(self.fd1)
                
               
                -- dispatch(self.fd)
               
                --dispatch(self.fd1)
        end)

  
    local matchRequest =  cc.MenuItemFont:create("Match")
        :onClicked(function()
        if open == 1  then
            request(self.fd, "randomjoin", { group = "one" } , function(obj)
                obj.secret = self.fd.secret
                print("host:",obj.host)
                print("port:",obj.port)
                
                self.udp = socket.udp(obj)
                self.udp:sync()
                print("ok 1")
            end)
        else
            -- dispatch(self.fd)
           -- timesync.sleep(1)
            request(self.fd1, "randomjoin", { group = "one" } , function(obj)
                obj.secret = self.fd1.secret
                self.udp1 = socket1.udp(obj)
                self.udp1:sync()
                print("ok 2")
            end)
         end
           
            --dispatch(self.fd1)

        end)
    local battleRequest =  cc.MenuItemFont:create("battle")
        :onClicked(function()
           
            for i=1,1000 do
                   -- timesync.sleep(1)
                    if (i == 100 or i == 200 or i ==300 or i == 600) and self.udp then
                        local gtime = timesync.globaltime()
                        if gtime then
                            print("send time", gtime)
                            if open==1 then
                               self.udp:send ("dave" .. i .. ":1")
                            else
                               self.udp1:send ("emma" .. i .. ":2")
                            end
--                            self.udp:send ("Hello" .. i .. ":2")
--                            self.udp:send ("Hello" .. i .. ":3")
                            --request(fd, "leave", { uid = "" } , function(obj)
                            --  print(string.format("result:%s", obj.result))
                            --end)
                        end
                    end
--                    if self.udp then
--                        local time, session, data = self.udp:recv()
--                        if time then
--                            print("UDP", "time=", time, "session =", session," client session =", self.fd.__session, "data=", data)
--                        end
--                    end
                    --dispatch(self.fd)
                    --dispatch(self.fd1)

                end
            
            
        end)
    local moreRequest =  cc.MenuItemFont:create("leave")
        :onClicked(function()
            request(self.fd, "leave", { uid = "" } , function(obj)
              print(string.format("result:", obj.result))
            end)
            --dispatch(self.fd)
            request(self.fd1, "leave", { uid = "" } , function(obj)
                print(string.format("result:", obj.result))
            end)
           
            --dispatch(self.fd1)
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



 
end

--function TestUdpScene:onEnter() 
--    print("onEnter TestUdpScene  ")
--
--end
--function TestUdpScene:onExit() 
--
--    print("onExit TestUdpScene  ")
--
--end


return TestUdpScene