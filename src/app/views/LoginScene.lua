
local LoginScene = class("LoginScene", cc.load("mvc").ViewBase)
 
function LoginScene:onCreate()


    self.stars = display.newSprite("starfield-hd.jpg")
        :move(display.center)
        :addTo(self,-1)
    self.stars:runAction(cc.RepeatForever:create(cc.RotateBy:create(360,360)))

   
    local scheduler = cc.Director:getInstance():getScheduler()
    cc.MenuItemFont:setFontName("CGF Locust Resistance")
    cc.MenuItemFont:setFontSize(44)
    local connectRequest =  cc.MenuItemFont:create("login msg")
        :onClicked(function()
            local islogin = self:getApp().client:login("davewang","pass","ios")
            if islogin then
                self:getApp().client:request("userinfo",{username="davewang"} , function(obj)
                  print(obj.username)
                  print(obj.nickname) 
                  print(obj.xp)
                end)
            	   print("login success")
            	else
                print("login fail")
            end
            
        end)
    
    local authRequest =  cc.MenuItemFont:create("auth msg")
        :onClicked(function()
          
        end)

    
    local matchRequest =  cc.MenuItemFont:create("match msg")
        :onClicked(function()
           
        end)
    local battleRequest =  cc.MenuItemFont:create("battle msg")
        :onClicked(function()
            
        end)
    local moreRequest =  cc.MenuItemFont:create("more msg")
        :onClicked(function()
           
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
 

return LoginScene