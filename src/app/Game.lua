local Game = class("Game", cc.load("mvc").AppBase)
--local targetPlatform = cc.Application:getInstance():getTargetPlatform()
local lang = require("app.components.Language")
local userDefault = cc.UserDefault:getInstance()
local json = require("dkjson")
require "app.MessageDispatchCenter"
function Game:onCreate()
    math.randomseed(os.time())
    lang.load()
    LANG = lang.curent_language
  --  print( "------->",  LANG["league_head_lab_winrate_text"])
  --  print( "------->",LANG.getString("league_head_lab_winrate_text"))
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    self.platform = targetPlatform
    self.httpClient = require("app.HttpClient"):create()
    --self.httpClient:retain()
   -- self.httpClient = require("app.HttpClient"):getInstance() -- require("app.HttpClient"):create()
    self.matchController = require("app.controller.MatchController"):create()
    self.userManager = require("app.manager.UserManager"):create()
    self.userManager.app_ = self

    self.productManager = require("app.manager.ProductManager"):create()
    self.productManager.app_ = self

    self.leagueManager = require("app.manager.LeagueManager"):create()
    self.leagueManager.app_ = self

    self.dailyManager = require("app.manager.DailyManager"):create()
    self.dailyManager.app_ = self

    self.inboxManager = require("app.manager.InboxManager"):create()
    self.inboxManager.app_ = self

    self.matchManager = require("app.manager.MatchManager"):create(self.matchController)
    self.matchManager.app_ = self
    self.matchController.app_ = self

    self.client = require("app.NetClient"):create()

    self.loading = require("app.components.LoadingView"):create()
    self.loading:retain()
    if (cc.PLATFORM_OS_IPHONE == self.platform) or (cc.PLATFORM_OS_IPAD == self.platform) or (cc.PLATFORM_OS_MAC == self.platform)  then
        self.platform_type = "ios"
    else
        self.platform_type = "android"
    end

    -- self.httpClient:addEventHandler(self.userManager)
    -- self.httpClient:addEventHandler(self.productManager)
    -- self.httpClient:addEventHandler(self.leagueManager)
    -- self.httpClient:addEventHandler(self.dailyManager)
    -- self.httpClient:addEventHandler(self.inboxManager)

    -- if (cc.PLATFORM_OS_IPHONE == self.platform) or (cc.PLATFORM_OS_IPAD == self.platform) or (cc.PLATFORM_OS_MAC == self.platform)  then
    --     self.platform_type = "ios"
    --     --self:enterScene("LoginWindow")
    --     print("LoginWindow......ios")
    --     self:enterScene("FaceView")
    --     --LoginWindow:create(self);
    --
    --     --LuaObjcBridge.callStaticMethod("AppController","auth",{onGameCenterAuthSuccessedHandler=handler(self.matchController, self.matchController.onGameCenterAuthSuccessed)})
    -- else
    --
    --     self.platform_type = "android"
    --   --  self:enterScene("LoginWindow")
    --     print("LoginWindow......android")
    --     -- local args = { handler(self.matchController, self.matchController.onGetPlayIdSuccessed)}
    --     -- local sigs = "(I)V"
    --     -- local className = "net/iapploft/games/battletetris/Functions"
    --     -- local ok = LuaJavaBridge.callStaticMethod(className,"getPlayerId",args,sigs)
    --     -- if not ok then
    --     --     print("luaj error")
    --     --
    --     -- end
    --
    -- end
     --audio.playMusic("sound/bg_choose_main.mp3")
     self:reloadSetting()
--     local oldId = userDefault:getStringForKey(K_GAME_CENTER_ID)
--     print(string.format( "oldid = %s language = %s",oldId,  device.language))
--     if string.len(oldId)>2 then
--        --self.userManager:login(oldId,self.platform_type)
--         local function checkAction()
--             testsocket(function(connectIsAble)
--                      if connectIsAble then
--                        currentLoginID = oldId
--                        self.userManager:login(oldId,self.platform_type)
--                        --LuaObjcBridge.callStaticMethod("AppController","addPage",nil)
--                        --insertGooglePageAd_bar()
--                      else
--                        self:showLoadingInView(cc.Director:getInstance():getRunningScene(),LANG["disconnect_title_text"],function()
--                            print("cbcb")
--                            self:hideLoadingView(cc.Director:getInstance():getRunningScene())
--                            --self.userManager:login(oldId,self.platform_type)
--                            checkAction()
--                        end )
--                      end
--                    end,1)
--         end
--         checkAction()
--     end
     local function onDisconnect(msg)
             self:showLoadingInView(cc.Director:getInstance():getRunningScene(),LANG["disconnect_title_text"],function()
                            print("cbcb")
                            self:hideLoadingView(cc.Director:getInstance():getRunningScene())
                            --self.userManager:login(oldId,self.platform_type)
                            --self.userManager:login(currentLoginID,self.platform_type)
                            self.userManager:loginWithUserNameAndPass(currentLoginID,currentLoginPWD)
              end )
     end
     MessageDispatchCenter:registerMessage(MessageDispatchCenter.MessageType.DISCONNECTION,onDisconnect)

end
function Game:loadComplete()
   local oldId = userDefault:getStringForKey(K_GAME_CENTER_ID)
   local oldPwd = userDefault:getStringForKey(K_GAME_PWD_ID)

   if string.len(oldId)>2 and string.len(oldPwd)>2 then
       currentLoginID = oldId
       currentLoginPWD = oldPwd
       local islogin = self:getUserManager():loginWithUserNameAndPass(oldId,oldPwd);
       if islogin == false then
           self:enterScene("LoginWindow")
       end
       return
   end
   self:enterScene("LoginWindow")
--  if (cc.PLATFORM_OS_IPHONE == self.platform) or (cc.PLATFORM_OS_IPAD == self.platform) or (cc.PLATFORM_OS_MAC == self.platform)  then
--      self.platform_type = "ios"
--      print("LoginWindow......ios")
--      self:enterScene("LoginWindow")
--      --self:enterScene("RegisterWindow")
--  else
--      self.platform_type = "android"
--      print("LoginWindow......android")
--      self:enterScene("LoginWindow")
--
--  end

end
function Game:reloadSetting()
     local soundSet = userDefault:getIntegerForKey("SOUND_SET")
     local musicSet = userDefault:getIntegerForKey("MUSIC_SET")
     if soundSet == 0 then
        GAME_SETTING.SOUND = 1
     else
        GAME_SETTING.SOUND = soundSet
        if  GAME_SETTING.SOUND==2  then
            print("pauseAllSounds")
            audio.stopAllSounds()

        end

     end
     if musicSet == 0 then
        GAME_SETTING.MUSIC = 1
        audio.resumeMusic()
     else
        GAME_SETTING.MUSIC = musicSet
        if  GAME_SETTING.MUSIC==2  then
            audio.pauseMusic()
        else
            audio.resumeMusic()
        end
     end
end
function Game:showLoadingInView(view,string,cb)
    self.loading:showInView(view,string,cb)
end
function Game:hideLoadingView(view)
    self.loading:dismiss()
end
function Game:getUserManager()
    return self.userManager
end
function Game:getMatchController()
    return self.matchController
end
function Game:getMatchManager()
    return self.matchManager
end
function Game:getClient()
    return self.client
end
function Game:getLeagueManager()
    return self.leagueManager
end
function Game:getProductManager()
    return self.productManager
end
function Game:getHttpClient()
    return self.httpClient
end
function Game:getDailyManager()
    return self.dailyManager
end
function Game:getInboxManager()
    return self.inboxManager
end
function Game:getCurrentUser()
    return self.userManager:getCurrentUser()
end
return Game
