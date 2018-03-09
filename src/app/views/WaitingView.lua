-- BackgroundView is a combination of view and controller
local WaitingView = class("BackgroundView", cc.load("mvc").ViewBase)

function WaitingView:onCreate()
    self:getApp():createView("BackgroundView"):addTo(self)   
    
    audio.playMusic("sound/bg_search.mp3")
    self:getApp():reloadSetting()
    cc.Label:createWithTTF("WAITING FOR OPPONENT ...", "fonts/Bebas.ttf", 44)
        :move(display.center)
        :addTo(self,1)
        
 
        cc.MenuItemFont:setFontName("CGF Locust Resistance")
        cc.MenuItemFont:setFontSize(44)
         
        local cancelRequest =  cc.MenuItemFont:create("CANCEL")--cc.MenuItemImage:create("PlayButton.png", "PlayButton.png")
            :onClicked(function()
                printLog("MainScene","go to menu")
               -- self:getApp().matchController:cancelMatchmakingRequest()  --game center
                self:getApp():getMatchManager():cancelMatchmakingOpponent()
                self:getApp():enterScene("MainView")
                
            end)
        cancelRequest:setColor(cc.c4b(0,255,255,255))
        cc.Menu:create(cancelRequest)
            :move(display.cx, display.cy-350)
            :addTo(self)
            :alignItemsVertically()
       

end
return WaitingView