-- BackgroundView is a combination of view and controller
local BackgroundView = class("BackgroundView", cc.load("mvc").ViewBase)

function BackgroundView:onCreate()
    -- local star_name
    -- local earth_name
    -- star_name = "starfield-hd.png"
   -- earth_name = "earth-hd.png" 
--    if  (cc.PLATFORM_OS_IPAD == self.app_.platform) or (cc.PLATFORM_OS_MAC == self.app_.platform)  then
--        star_name = "starfield-hd.jpg"
--        earth_name = "earth-hd.png" 
--    elseif (cc.PLATFORM_OS_IPHONE == self.app_.platform)  then
--        star_name = "starfield-hd.jpg"
--        earth_name = "earth-hd.png"  
--    end
    self.stars = display.newSprite("starfield-hd.png")
        :move(display.center)
        :addTo(self,-1)
    
   -- self.stars:runAction(cc.RepeatForever:create(cc.RotateBy:create(360,360)))
    -- self.earth = display.newSprite(earth_name)
    --     :move(display.center)
    --     :addTo(self,1)
        
--    cc.Label:createWithTTF("Authenticating ...", "fonts/Bebas.ttf", 11) 
--        :move(display.center)
--        :addTo(self,2)
 
end
return BackgroundView