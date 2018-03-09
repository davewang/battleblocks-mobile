------------------------------------------------------------------------------
--define UpdateScene
------------------------------------------------------------------------------
local UpdateScene = class("UpdateScene", function()
    return display.newScene("UpdateScene")
end)

local asset_code_file_name = "game.zip"

local function checkDirOK( path )
    local lfs = require "lfs"
    local oldpath = lfs.currentdir()
    if lfs.chdir(path) then
        lfs.chdir(oldpath)
        return true
    end
    if lfs.mkdir(path) then
        return true
    end
end
function UpdateScene:ctor()
    display.newSprite("down-hd.png")
        :move(display.center)
        :addTo(self,-1)
    print(" UpdateScene:ctor()")
    self.path = device.writablePath.."upd/"
    checkDirOK(self.path)  
    print(self.path) 
    self.loadingBar = ccui.LoadingBar:create()
    self.loadingBar:setTag(0)
    self.loadingBar:setName("LoadingBar")
    --prog_bg.png
    --prog_bar.png
    self.loadingBar:loadTexture("prog_bar.png")
    --self.loadingBar:loadTexture("silder_progressBar.png")
    self.loadingBar:setDirection(0)
    self.loadingBar:setPercent(0)
    self.loadingBar:move(cc.p(display.cx,display.cy-300))
    self.loadingBar:addTo(self)
    self.loadingBar:setScale(1.5)
    self.p_bg=display.newSprite("prog_bg.png")
        :move(cc.p(display.cx,display.cy-300))
        :addTo(self,-1)
         self.p_bg:setScale(1.5)
    self.progressLable = cc.Label:createWithTTF("Downloading...","fonts/fzzy.ttf",30)
    self.progressLable:setAnchorPoint(cc.p(0.5, 0.5))
    self.progressLable:move(cc.p(display.cx,display.cy-300))
    self.progressLable:addTo(self)
    self.progressLable:setColor(cc.c4b(255,255,255,255))
    self.progressLable:enableShadow(cc.c4b(34, 113, 42, 255))
    
 
    
    
    self.assetsManager = cc.AssetsManager:new("http://www.iapploft.net/update/game.zip",
        "http://www.iapploft.net/update/version",
        self.path)
    self.assetsManager:retain()
    self.assetsManager:setDelegate(handler(self,self.onError), 2 )
    self.assetsManager:setDelegate(handler(self,self.onProgress), 0)
    self.assetsManager:setDelegate(handler(self,self.onSuccess), 1 )
    self.assetsManager:setConnectionTimeout(30)
    self:enableNodeEvents()
    
    
end


function UpdateScene:onEnter()
    
   -- print("UpdateScene onEnter ") 
    --self:getAssetsManager():update()
    self.assetsManager:update()
end
function UpdateScene:onError(errorCode)
     -- print("UpdateScene onError ") 
    if errorCode == 2 then--cc.ASSETSMANAGER_NO_NEW_VERSION
        --self.progressLable:setString("no new version")
        self.loadingBar:setPercent(100)
        self.progressLable:setString(" No new version!")
        cc.LuaLoadChunksFromZIP(self.path..asset_code_file_name)
        require "config"
        print("assetsManager errorCode 2 G_LOGIN_SERVER = ",G_LOGIN_SERVER)
        print("assetsManager errorCode 2 G_LOGIC_SERVER = ",G_LOGIC_SERVER)
    elseif errorCode == 1 then --cc.ASSETSMANAGER_NETWORK
        --self.progressLable:setString("network error")
        self.loadingBar:setPercent(100)
        self.progressLable:setString(" Complete!")
        cc.LuaLoadChunksFromZIP(self.path..asset_code_file_name)
        require "config"
        print("assetsManager errorCode 1 G_LOGIN_SERVER = ",G_LOGIN_SERVER)
        print("assetsManager errorCode 1 G_LOGIC_SERVER = ",G_LOGIC_SERVER)
    end
    require  "appentry" 
end
function UpdateScene:onProgress(percent)
    if percent<0 then
    	return
    end
    --print("UpdateScene onProgress ") 
    self.loadingBar:setPercent(math.floor(percent))
    local progress = string.format("Downloading...%d%%",math.floor(percent))
    self.progressLable:setString(progress)
end
function UpdateScene:onSuccess()
   -- print("UpdateScene onProgress ") 
    self.progressLable:setString(" Complete!")
    cc.LuaLoadChunksFromZIP(self.path..asset_code_file_name)
    require "config"
    print("assetsManager onSuccess G_LOGIN_SERVER = ",G_LOGIN_SERVER)
    print("assetsManager onSuccess G_LOGIC_SERVER = ",G_LOGIC_SERVER)
    require  "appentry" 
end
function UpdateScene:onExit()

    
end

--function UpdateScene:getAssetsManager()
--    local function onError(errorCode)
--        if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
--            self.progressLable:setString("no new version")
--        elseif errorCode == cc.ASSETSMANAGER_NETWORK then
--            self.progressLable:setString("network error")
--        end
--    end
--
--    local function onProgress( percent )
--        local progress = string.format("downloading %d%%",percent)
--        self.progressLable:setString(progress)
--    end
--
--    local function onSuccess()
--        self.progressLable:setString("downloading ok")
--    end
--
--
--    if nil == self.assetsManager then
--        self.assetsManager = cc.AssetsManager:new("https://raw.github.com/samuele3hu/AssetsManagerTest/master/package.zip",
--            "https://raw.github.com/samuele3hu/AssetsManagerTest/master/version",
--            self.path)
--        self.assetsManager:retain()
--        self.assetsManager:setDelegate(onError, cc.ASSETSMANAGER_PROTOCOL_ERROR )
--        self.assetsManager:setDelegate(onProgress, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
--        self.assetsManager:setDelegate(onSuccess, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
--
--        self.assetsManager:setConnectionTimeout(3)
--    end
--
--    return self.assetsManager
--end

 

local upd = UpdateScene:create()
display.runScene(upd)