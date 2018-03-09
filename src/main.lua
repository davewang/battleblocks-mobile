
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"
local function loadResource()
   display.loadSpriteFrames("profile/profile.plist", "profile/profile.png",nil)
   display.loadSpriteFrames("main.plist", "main.png",nil)
   display.loadSpriteFrames("atlas5.plist", "atlas5.png",nil)
   display.loadImage("option_card_bg.png",nil)
   local platform = cc.Application:getInstance():getTargetPlatform()
   local fontsize = 48

   local group = {}
   local function dataEnd()

       local last = table.remove(group,1)
       if  (#group == 0) then
           local app = require("app.Game"):create()
           local view = app:run("BackgroundView")

           -- local label = cc.Label:createWithTTF("Loading ...", "fonts/Bebas.ttf", fontsize)
            --    :move(display.center)
            --    :addTo(view,2)
           -- label:setColor(cc.c4b(0,255,255,255))
       end


   end
   table.insert(group,"a")
   ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("armature/sousuoduishouzhizhen.png", "armature/sousuoduishouzhizhen.plist", "armature/sousuoduishouzhizhen.xml", dataEnd)
   table.insert(group,"b")
   ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("armature/bisaikaishi.png", "armature/bisaikaishi.plist", "armature/bisaikaishi.xml", dataEnd)
   table.insert(group,"c")
   ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("armature/new_crazy_mode_bg3.png", "armature/new_crazy_mode_bg3.plist", "armature/new_crazy_mode_bg3.xml", dataEnd)
 
end 
local function test()
   display.loadSpriteFrames("profile/profile.plist", "profile/profile.png",nil)
   display.loadSpriteFrames("main.plist", "main.png",nil)
   display.loadSpriteFrames("atlas.plist", "atlas.png",nil)
   display.loadImage("option_card_bg.png",nil)
   local platform = cc.Application:getInstance():getTargetPlatform()
   local fontsize = 48

   local group = {}
   local function dataEnd()

       local last = table.remove(group,1)
       if  (#group == 0) then
           print("dataEnd ")
           local app = require("app.Game"):create()
           local view = app:run("FighterView")

           -- local label = cc.Label:createWithTTF("Loading ...", "fonts/Bebas.ttf", fontsize)
            --    :move(display.center)
            --    :addTo(view,2)
           -- label:setColor(cc.c4b(0,255,255,255))
       end


   end
   table.insert(group,"a")
   ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("armature/sousuoduishouzhizhen.png", "armature/sousuoduishouzhizhen.plist", "armature/sousuoduishouzhizhen.xml", dataEnd)
   table.insert(group,"b")
   ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("armature/bisaikaishi.png", "armature/bisaikaishi.plist", "armature/bisaikaishi.xml", dataEnd)
   table.insert(group,"c")
   ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("armature/new_crazy_mode_bg3.png", "armature/new_crazy_mode_bg3.plist", "armature/new_crazy_mode_bg3.xml", dataEnd)
   
   table.insert(group,"c")
   ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("armature/addRowsAni.png", "armature/addRowsAni.plist", "armature/addRowsAni.xml", dataEnd)
   table.insert(group,"c")
   ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("armature/attack_ani.png", "armature/attack_ani.plist", "armature/attack_ani.xml", dataEnd)
   table.insert(group,"c")
   ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("armature/be_attack_ani.png", "armature/be_attack_ani.plist", "armature/be_attack_ani.xml", dataEnd)
   table.insert(group,"c")
   ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("armature/bindong.png", "armature/bindong.plist", "armature/bindong.xml", dataEnd)
   table.insert(group,"c")
   ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("armature/block_drop_ani.png", "armature/block_drop_ani.plist", "armature/block_drop_ani.xml", dataEnd)
   table.insert(group,"c")
   ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("armature/fireworks1.png", "armature/fireworks1.plist", "armature/fireworks1.xml", dataEnd)
   table.insert(group,"c")
   ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("armature/jiguang.png", "armature/jiguang.plist", "armature/jiguang.xml", dataEnd)
   table.insert(group,"c")
   ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("armature/new_crazy_ani_2.png", "armature/new_crazy_ani_2.plist", "armature/new_crazy_ani_2.xml", dataEnd)
   
   table.insert(group,"c")
   ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("armature/new_crazy_mode_bg1.png", "armature/new_crazy_mode_bg1.plist", "armature/new_crazy_mode_bg1.xml", dataEnd)
   
   
   print("load end ")
end 
local function main()
        print("main .... main")
        print("main G_LOGIN_SERVER = ",G_LOGIN_SERVER)
        print("main G_LOGIC_SERVER = ",G_LOGIC_SERVER)
        
        --print(string.format("respath = %s",device.workPath))
        -- if DEBUG > 0  then
        --     --loadResource()
        --     test()
        -- else 
             local scene = require("assetUpdate"):create() 
             display.runScene(scene)
        --end
     
--            local args = { 2 , 3}
--            local sigs = "(II)I"
--            --local luaj = require "cocos.cocos2d.luaj"
--            local className = "net/iapploft/games/battletetris/Functions"
--            local ok,ret  = LuaJavaBridge.callStaticMethod(className,"addTwoNumbers",args,sigs)
--            if not ok then
--                print("luaj error:", ret)
--            else
--                print("The ret is:", ret)
--            end


--
--    local app = require("app.Game"):create()
--    local view = app:run("BackgroundView")
--
--    local label = cc.Label:createWithTTF("Loading ...", "fonts/Bebas.ttf", 48)
--        :move(display.center)
--        :addTo(view,2)
--    label:setColor(cc.c4b(0,255,255,255))

     --local app = require("app.Game"):create()
    --local view = app:run("TimeMachineView")
    -- local view = app:run("LoginScene")
  
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
