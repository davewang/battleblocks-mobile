------------------------------------------------------------------------------
--Load origin framework
------------------------------------------------------------------------------
--cc.LuaLoadChunksFromZIP("res/framework_precompiled.zip")

------------------------------------------------------------------------------
--If you would update the modoules which have been require here,
--you can reset them, and require them again in modoule "appentry"
------------------------------------------------------------------------------
--require("config")
--require("framework.init")
--require "config"
--require "cocos.init"

------------------------------------------------------------------------------
--define UpdateScene
------------------------------------------------------------------------------
local UpdateScene = class("UpdateScene", function()
    return display.newScene("UpdateScene")
end)

local NEEDUPDATE = true
local server = "http://www.iapploft.net/update/"
  
local param = "dev="..device.platform
local list_filename = "flist"
local downList = {}

local function hex(s)
 s=string.gsub(s,"(.)",function (x) return string.format("%02X",string.byte(x)) end)
 return s
end

local function readFile(path)
    local file = io.open(path, "rb")
    if file then
        local content = file:read("*all")
        io.close(file)
        return content
    end
    return nil
end

local function removeFile(path)
    --CCLuaLog("removeFile: "..path)
    io.writefile(path, "")
    if device.platform == "windows" then
        --os.execute("del " .. string.gsub(path, '/', '\\'))
    else
        os.execute("rm " .. path)
    end
end

local function checkFile(fileName, cryptoCode)
    print("checkFile:", fileName)
    print("cryptoCode:", cryptoCode)

    if not io.exists(fileName) then
        return false
    end

    local data=readFile(fileName)
    if data==nil then
        return false
    end

    if cryptoCode==nil then
        return true
    end
 
    local ms = hex(data)
    
    print("ms = ",string.sub(ms,10,20))
    if string.sub(ms,10,20)==cryptoCode then
        print("ms = ok")
    	return true
    end
 
    return false
end

local function checkDirOK( path )
        
        local lfs = require "lfs"
      
        local oldpath = lfs.currentdir()
        print("old path------> "..oldpath)

         if lfs.chdir(path) then
            lfs.chdir(oldpath)
            print("path check OK------> "..path)
            return true
         end

         if lfs.mkdir(path) then
            print("path create OK------> "..path)
            return true
         end
end

function UpdateScene:ctor()
    self.path = device.writablePath.."upd/"
    local label = cc.Label:createWithTTF("check updateing...", "fonts/Bebas.ttf", 36) 
        :move(display.center)
        :addTo(self)
        
--    local loadingBar = ccui.LoadingBar:create()
--    loadingBar:setTag(0)
--    loadingBar:setName("LoadingBar")
--    loadingBar:loadTexture("sliderProgress.png")
--    loadingBar:setDirection(0)
--    loadingBar:setPercent(80)
--    loadingBar:move(display.center)
--    loadingBar:addTo(self)
    self:enableNodeEvents()
    cc.bind(self, "event")
end

function UpdateScene:updateFiles()
    print("updateFiles")
    local data = readFile(self.newListFile)
    io.writefile(self.curListFile, data)
    self.fileList = dofile(self.curListFile)
    if self.fileList==nil then
        self:endProcess()
        return
    end
    removeFile(self.newListFile)

    for i,v in ipairs(downList) do
        print(i,v)
        local data=readFile(v)
        local fn = string.sub(v, 1, -5)
        print("fn: ", fn)
        io.writefile(fn, data)
        removeFile(v)
    end
    self:endProcess()
end

function UpdateScene:reqNextFile()

    self.numFileCheck = self.numFileCheck+1
    self.curStageFile = self.fileListNew.stage[self.numFileCheck]
    print("self.numFileCheck = ",self.numFileCheck)
    if self.curStageFile and self.curStageFile.name then
        local fn = self.path..self.curStageFile.name
        if checkFile(fn, self.curStageFile.code) then
            self:reqNextFile()
            return
        end
        fn = fn..".upd"
        if checkFile(fn, self.curStageFile.code) then
            table.insert(downList, fn)
            self:reqNextFile()
            return
        end
        self:requestFromServer(self.curStageFile.name)
        return
    end
    print("UpdateScene:reqNextFile() ")
    self:updateFiles()
end

function UpdateScene:onEnterFrame(dt)
	if self.dataRecv then
		if self.requesting == list_filename then
			io.writefile(self.newListFile, self.dataRecv)
			self.dataRecv = nil

			self.fileListNew = dofile(self.newListFile)
			if self.fileListNew==nil then
                print(self.newListFile,": Open Error!")
				self:endProcess()
				return
			end

            print("new ="..self.fileListNew.ver)
            print("old ="..self.fileList.ver)
			if self.fileListNew.ver==self.fileList.ver then
				self:endProcess()
				return
			end

            self.numFileCheck = 0
            self.requesting = "files"
            self:reqNextFile()
            return
		end
        if self.requesting == "files" then
            local fn = self.path..self.curStageFile.name..".upd"
            io.writefile(fn, self.dataRecv)
            self.dataRecv = nil
            if checkFile(fn, self.curStageFile.code) then
                table.insert(downList, fn)
                self:reqNextFile()
            else
                self:endProcess()
            end
            return
        end
        return
	end

end

function UpdateScene:onEnter()
    print("UpdateScene onEnter ") 
    if not checkDirOK(self.path) then
        require  "appentry" 
        return
    end
    self.curListFile =  self.path..list_filename               
	self.fileList = nil
    print("self.curListFile = ",self.curListFile) 
	if io.exists(self.curListFile) then
		self.fileList = dofile(self.curListFile)
    end
	if self.fileList==nil then
    	self.fileList = {
			ver = "1.0.0",
			stage = {},
			remove = {},
		}
	end
    print("self.fileList= ",self.fileList) 
	self.requestCount = 0
	self.requesting = list_filename
    print("list_filename = ",list_filename) 
    self.newListFile = self.curListFile..".upd"
    print("self.newListFile = ",self.newListFile) 
	self.dataRecv = nil
	self:requestFromServer(self.requesting)
    
    self:scheduleUpdate(handler(self, self.onEnterFrame))
    
end

function UpdateScene:onExit()
end

function UpdateScene:endProcess()
            if self.fileList and self.fileList.stage then
                local checkOK = true
                for i,v in ipairs(self.fileList.stage) do
                    if not checkFile(self.path..v.name, v.code) then
                print("----------------------------------------Check Files Error")
                        checkOK = false
                        break
                    end
                end

                if checkOK then
                    for i,v in ipairs(self.fileList.stage) do
                        if v.act=="load" then
                           
                            print(" path = ", self.path..v.name)
                            cc.LuaLoadChunksFromZIP(self.path..v.name)
                        end
                    end
                    for i,v in ipairs(self.fileList.remove) do
                        removeFile(self.path..v)
                    end
                else
                    removeFile(self.curListFile)
                end
              end

    require  "appentry" 
end

function UpdateScene:requestFromServer(filename, waittime)
    local url = server..filename --.."&"..param
    print("url--> ",url)
    self.requestCount = self.requestCount + 1
    local index = self.requestCount
    local request = nil
    if NEEDUPDATE then
        request = cc.XMLHttpRequest:new()
        --request.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
        request:open("GET",url)
        local function onStateChange()
            self:onResponse(request,index)
        end
        request:registerScriptHandler(onStateChange)
        
    end
    if request then
        --request:setTimeout(waittime or 30)
        --request:start()
        request:send()
    else
        self:endProcess()
    end
end

function UpdateScene:onResponse(request, index)
 
   
    --local request = event.request
    printf("REQUEST %d - request.response = %s", index, request.response)
  
        if request.status ~= 200 then
        	self:endProcess()
        else
           -- printf("REQUEST %d - getDataSize() = %d", index, request:getDataSize())
           --     printf("REQUEST %d - getResponseString() =\n%s", index, request.response)
            self.dataRecv = request.response
        end
  

    print("----------------------------------------")
end

local upd = UpdateScene:create()
display.runScene(upd)
