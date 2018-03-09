
local function loadResource()

   G_LOGIN_SERVER = "47.94.98.55"
   G_LOGIN_SERVER_PORT = 8001
   G_LOGIC_SERVER = "47.94.98.55"
   G_LOGIC_SERVER_PORT = 8888

   print("appentre loadResource G_LOGIN_SERVER = ",G_LOGIN_SERVER)
   print("appentre loadResource G_LOGIC_SERVER = ",G_LOGIC_SERVER)


   display.loadSpriteFrames("profile/profile.plist", "profile/profile.png",nil)
   display.loadSpriteFrames("main.plist", "main.png",nil)
   display.loadSpriteFrames("atlas.plist", "atlas.png",nil)
   display.loadImage("option_card_bg.png",nil)
   local platform = cc.Application:getInstance():getTargetPlatform()
   local fontsize = 48
   local app = require("app.Game"):create()
   local view = app:run("BackgroundView")

   local group = {}
   local function dataEnd()

       local last = table.remove(group,1)
       if  (#group == 0) then
           app:loadComplete()

           -- local label = cc.Label:createWithTTF("Loading ...", "fonts/Bebas.ttf", fontsize)
            --    :move(display.center)
            --    :addTo(view,2)
           -- label:setColor(cc.c4b(0,255,255,255))
       end


   end
   table.insert(group,"c")
   ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("armature/jiguang.png", "armature/jiguang.plist", "armature/jiguang.xml", dataEnd)

end
loadResource()
