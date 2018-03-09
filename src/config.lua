
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 0

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = false

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = true

-- screen orientation
CONFIG_SCREEN_ORIENTATION = "portrait"

-- for module display
CC_DESIGN_RESOLUTION = {
    width = 1080,
    height = 1920,
    autoscale = "FIXED_HEIGHT",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "FIXED_WIDTH"}
        end
    end
}
EFFECTIVE_SWIPE_DISTANCE_THRESHOLD = 40.0
-- design direction
DIRECTION = {
    left = 1,
    right = 2,
    up = 3,
    down = 4,
}
GAME_GROUP = {
    G_ONE = "one",--1,
    G_TWO = "two",--2,
    G_THREE = "three",--3,

}
Robot = {
  one = 100,
  two = 50,
  three = 15,
}
AVATER_TYPE = {
   "profile_1.png","profile_2.png","profile_3.png","profile_4.png",
   "profile_5.png","profile_6.png","profile_7.png","profile_8.png",
}

GAME_OP_CODES = {
    --http--
    PRODUCT = 1002,
    LOGIN = 1003,
    USER_INFO = 1004,
    UPDATE_SCORE = 1006,
    UPDATE_STAR = 1007,
    LEAGUE_FRIEND = 1008,
    LEAGUE_RANK = 1009,
    LEAGUE_SCORE = 1010,
    GET_INBOX = 1011,
    READ_ACTION_INBOX = 1012,
    APPECT_ACTION_INBOX = 1013,
    GET_UNREAD_COUNT_INBOX = 1014,
    GET_DAILY = 1015,
    --socket--
    AUTH_BATTLE = "2001",
    START_MATCH = "randomjoin",--"2002",
    SEND_MATCH_DATA = "2003",
    RECV_MATCH_DATA = "2004",
    CANCEL_MATCH = "leave"

}
STAR_MAP_TABLE = {
  1,1,1,
  2,2,2,
  3,3,3,
  4,4,4,
  5,5,5,
  6,6,6,6,
  7,7,7,7,
  8,8,8,8,
  9,9,9,9,
  10,10,10,10,
  11,11,11,11,11,
  12,12,12,12,12,
  13,13,13,13,13,
  14,14,14,14,14,
  15,15,15,15,15,
  16,16,16,16,16,16,
  17,17,17,17,17,17,
  18,18,18,18,18,18,
  19,19,19,19,19,19,
  20,20,20,20,20,20,
  21,21,21,21,21,21,21,
  22,22,22,22,22,22,22,
  23,23,23,23,23,23,23,
  24,24,24,24,24,24,24,
  25,25,25,25,25,25,25,
  26,26,26,26,26,26,26,26,
  27,27,27,27,27,27,27,27,
  28,28,28,28,28,28,28,28,
  29,29,29,29,29,29,29,29,
  30,30,30,30,30,30,30,30
}
GAME_CENTER_ID = ""
K_GAME_CENTER_ID = "K_GAME_CENTER_ID"
K_GAME_PWD_ID = "K_GAME_PWD_ID"
K_FACEBOOK_ACCESSTOKEN = "K_FACEBOOK_ACCESSTOKEN"
targetPlatform_ = cc.Application:getInstance():getTargetPlatform()
-- 传入DrawNode对象，画圆角矩形
function drawNodeRoundRect(drawNode, rect, borderWidth, radius, color, fillColor)
  -- segments表示圆角的精细度，值越大越精细
  local segments    = 100
  local origin      = cc.p(rect.x, rect.y)
  local destination = cc.p(rect.x + rect.width, rect.y - rect.height)
  local points      = {}

  -- 算出1/4圆
  local coef     = math.pi / 2 / segments
  local vertices = {}

  for i=0, segments do
    local rads = (segments - i) * coef
    local x    = radius * math.sin(rads)
    local y    = radius * math.cos(rads)

    table.insert(vertices, cc.p(x, y))
  end

  local tagCenter      = cc.p(0, 0)
  local minX           = math.min(origin.x, destination.x)
  local maxX           = math.max(origin.x, destination.x)
  local minY           = math.min(origin.y, destination.y)
  local maxY           = math.max(origin.y, destination.y)
  local dwPolygonPtMax = (segments + 1) * 4
  local pPolygonPtArr  = {}

  -- 左上角
  tagCenter.x = minX + radius;
  tagCenter.y = maxY - radius;

  for i=0, segments do
    local x = tagCenter.x - vertices[i + 1].x
    local y = tagCenter.y + vertices[i + 1].y

    table.insert(pPolygonPtArr, cc.p(x, y))
  end

  -- 右上角
  tagCenter.x = maxX - radius;
  tagCenter.y = maxY - radius;

  for i=0, segments do
    local x = tagCenter.x + vertices[#vertices - i].x
    local y = tagCenter.y + vertices[#vertices - i].y

    table.insert(pPolygonPtArr, cc.p(x, y))
  end

  -- 右下角
  tagCenter.x = maxX - radius;
  tagCenter.y = minY + radius;

  for i=0, segments do
    local x = tagCenter.x + vertices[i + 1].x
    local y = tagCenter.y - vertices[i + 1].y

    table.insert(pPolygonPtArr, cc.p(x, y))
  end

  -- 左下角
  tagCenter.x = minX + radius;
  tagCenter.y = minY + radius;

  for i=0, segments do
    local x = tagCenter.x - vertices[#vertices - i].x
    local y = tagCenter.y - vertices[#vertices - i].y

    table.insert(pPolygonPtArr, cc.p(x, y))
  end

  if fillColor == nil then
    fillColor = cc.c4f(0, 0, 0, 0)
  end
  -- for i=1,#pPolygonPtArr do
  --   print(string.format("point(x=%f,x=%f)",pPolygonPtArr[i].x,pPolygonPtArr[i].y))
  -- end

  --drawNode:drawPoints(pPolygonPtArr, #pPolygonPtArr, cc.c4f(math.random(0,1), math.random(0,1), math.random(0,1), 1))
  drawNode:drawPolygon(pPolygonPtArr, table.getn(pPolygonPtArr), fillColor, borderWidth, color)

 -- drawNode:drawPolygon(pPolygonPtArr, #pPolygonPtArr, fillColor, borderWidth, color)
end
MsgHandlers = {} -- 消息处理函数


LANG = nil

KM_LEVEL = {
    300, --map need xp up
    300,
    300,
    300,
    300,
    400,
    400,
    400,
    400,
    400,
    500,
    500,
    500,
    500,
    500,
    600,
    600,
    600,
    600,
    600,
    700,
    700,
    700,
    700,
    700,
    800,
    850,
    900,
    950,
    1000
}
KM_LEVEL.groups={
    {id=1,title="普通1对1",name="one",win_xp=50,lose_xp=25,enterfee=300,prize=600}, --map group get xp value
    {id=2,title="高手1对1",name="two",win_xp=100,lose_xp=35,enterfee=2000,prize=4000},
    {id=3,title="大神1对1",name="three",win_xp=150,lose_xp=45,enterfee=10000,prize=20000}
    --{id=4,title="马拉松",name="marathon"}
}
group_map ={one=KM_LEVEL.groups[1],two=KM_LEVEL.groups[2],three=KM_LEVEL.groups[3]}
currentSelectedGroup=""
currentLoginID=""
currentLoginUser = nil
GAME_SETTING = {
    MUSIC = 1,--1,
    SOUND = 1,--2,
}
GAME_PARTICLES = {
    flowCoins = "particles/flow_coins.plist",
    win = "particles/win.plist",
    broken = "particles/broken.plist"
}
GAME_SFXS = {
    buttonClick =   "sound/button_click.mp3",
    collectCoins = "sound/coins_collect_01.mp3",
    matching = "sound/sfx_matching.wav",
    matchFound = "sound/sfx_matchFound.mp3",
    bgMusic1 = "sound/bg_choose_main.mp3",
    bgMusic2 = "sound/title.mp3",
    bgMusic3 = "sound/back1.mp3",
    transform = "sound/transform.mp3",
    move = "sound/move.mp3",
    drop = "sound/drop.mp3",
    fixup = "sound/fixup.mp3",
    win ="sound/win.mp3",
    lost = "sound/lost.mp3",
    clear1 =  "sound/clear1.mp3",
    clear2 =  "sound/clear2.mp3",
    clear3 =  "sound/clear3.mp3",
    clear4 =  "sound/clear4.mp3",
    broken =  "sound/broken.mp3",
}
function stretchSprite(sprite,w,h)
    local spx =  sprite:getTextureRect().width
    local spy =  sprite:getTextureRect().height
    sprite:setScaleX(w/spx) --设置精灵宽度缩放比例
    sprite:setScaleY(h/spy)
    sprite:setContentSize(cc.size(w,h))
end
function stretchNode(sprite,w,h)
    local spx =  sprite:getContentSize().width
    local spy =  sprite:getContentSize().height
    sprite:setScaleX(w/spx) --设置精灵宽度缩放比例
    sprite:setScaleY(h/spy)
    sprite:setContentSize(cc.size(w,h))
end


function playSound(filename,repart)
     repart = repart or false
     if GAME_SETTING.SOUND == 1 then
        audio.playSound(filename,repart)
     end

end
function playMusic(filename,repart)
     --repart = repart or true
     if GAME_SETTING.MUSIC == 1 then
         if repart ~= nil then
              audio.playMusic(filename,repart)
         else
              audio.playMusic(filename)
         end

     end

end
prompts = {}
function promptText(text,view)
    local function changeOld(oldObj)
        local old = cc.p(oldObj:getPosition())
        oldObj:setPosition( cc.p(old.x,old.y+ oldObj:getContentSize().height) )
    end
    if #prompts>0 then
        for i=1, #prompts do
           if prompts[i] then
               pcall(changeOld,prompts[i])

             -- local old = cc.p(prompts[i]:getPosition())
             -- prompts[i]:setPosition( cc.p(old.x,old.y+ prompts[i]:getContentSize().height) )
           end

        end

    end

    local prompt = ccui.Text:create(text, "fonts/fzzy.ttf", 52)

    prompt:setTextHorizontalAlignment(1)
    local autosize =  52
    local autoOutline = 4
    if  prompt:getStringLength()>20 then
        autosize = 30
        autoOutline = 2
    end
    prompt:setFontSize(autosize)
    prompt:addTo(view,2000)
    prompt:enableOutline(cc.c4b(221, 129, 0, 255), autoOutline)
    local screenSize = cc.Director:getInstance():getWinSize()
    prompt:move(screenSize.width / 2.0, screenSize.height / 1.4 )
    local delay = cc.DelayTime:create(2.5)
    local v = cc.FadeOut:create(1)

    local function remove(n)
        n:removeFromParent()
        for i=1, #prompts do
            if prompts[i]==n then
            	 table.remove(prompts,i)
                 -- print("prompts count ",#prompts)
                 return
            end
        end
    end
    table.insert(prompts,prompt)
    -- print("add to prompts count ",#prompts)
     local clear = cc.CallFunc:create(remove)
     prompt:runAction(cc.Sequence:create(delay,v,clear))

end
function playDropCoins(view,type)
    type = type or 0

    playSound(GAME_SFXS.collectCoins)
    local emitter = cc.ParticleSystemQuad:create(GAME_PARTICLES.flowCoins)
    emitter:setAutoRemoveOnFinish(true)
    if type == 0 then
        emitter:setStartSize(5)
        emitter:setEndSize(5)
    else
        emitter:setStartSize(40)
        emitter:setEndSize(40)
    end

    emitter:setPosition(cc.p(display.width/2,display.height/1.3))
    view:addChild(emitter,2001)
end
function timeago(ptime)
    local etime =os.time() - ptime
    if (etime < 1) then
      return LANG['ago_just_text']--'刚刚'
    end
    local interval_ = {
       {secs = 12 * 30 * 24 * 60 * 60,str=os.date(LANG['ago_year_text'], ptime)} ,--'年前'
       {secs = 30 * 24 * 60 * 60     ,str=os.date(LANG['ago_month_text'], ptime)} ,--'个月前'
       {secs = 7 * 24 * 60 * 60      ,str=os.date(LANG['ago_week_text'], ptime)},--'周前'
       {secs = 24 * 60 * 60          ,str=LANG['ago_day_text']},--'天前'
       {secs = 60 * 60               ,str=LANG['ago_hours_text']},--'小时前'
       {secs = 60                    ,str=LANG['ago_min_text']},--'分钟前'
       {secs = 1                     ,str=LANG['ago_sed_text']}--'秒前'
    }
    for i=1,#interval_ do
        local d = etime/interval_[i].secs
        if d >= 1 then
           return math.floor(d)..interval_[i].str
        end
    end
end
function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end
function coin_to_string(number)
  local k = 1000
  local m = 1000 * k
  local b = 1000 * m
  local num = nil
  local idp = ""
  if number >= b then
      num = round(number/b,3)
      idp = "b"
  elseif  number >= m then
      num = round(number/m,3)
      idp = "m"
  elseif  number >= 100 * k then
      num = round(number/k,3)
      idp = "k"
  else
      num = number
      idp = ""
  end
  return num,idp
  --print(string.format('%d',num))
end
if DEBUG > 0  then
G_LOGIN_SERVER = "10.7.7.108"
G_LOGIN_SERVER_PORT = 8001
G_LOGIC_SERVER = "10.7.7.108"
G_LOGIC_SERVER_PORT = 8888
G_LOGIN_SERVER = "47.94.98.55"
G_LOGIN_SERVER_PORT = 8001
G_LOGIC_SERVER = "47.94.98.55"
G_LOGIC_SERVER_PORT = 8888
else
G_LOGIN_SERVER = "10.7.7.108"
G_LOGIN_SERVER_PORT = 8001
G_LOGIC_SERVER = "10.7.7.108"
G_LOGIC_SERVER_PORT = 8888
end


---------------------------------------
-- Test connection to the internet
---------------------------------------
local socket = require("socket")
function testsocket(callback, timeout)

    local scheduler = cc.Director:getInstance():getScheduler()
    if timeout == nil then timeout = 1000 end
    local connection = socket.tcp()
    connection:settimeout(0)
    connection:connect(G_LOGIN_SERVER, G_LOGIN_SERVER_PORT)
    local nb = nil
    local function check(dt)
        local r = socket.select({connection}, nil, 0)
        if r[1] or timeout == 0 then
            connection:close()
            callback(timeout > 0)
            print("connect www.google.com ...")
            scheduler:unscheduleScriptEntry(nb)

        end
        timeout = timeout - 10
    end
    nb = scheduler:scheduleScriptFunc(check, 0.5,false)

end


function iLog(msg)
    if cc.PLATFORM_OS_ANDROID == targetPlatform_ then
        local args = {msg}
        local sigs = "(Ljava/lang/String;)V"
        local className = "net/iapploft/games/battletetris/Functions"
        local ok = LuaJavaBridge.callStaticMethod(className,"iapploftLog",args,sigs)
        if not ok then
            print("luaj error")
        end
    end
end
function showGoogleAd_bar()

   if currentLoginUser.pay_times == 0 then
    if cc.PLATFORM_OS_ANDROID == targetPlatform_ then
        --local args = { handler(self.matchController, self.matchController.onGetPlayIdSuccessed)}
        local args = { 2 }
        local sigs = "(I)V"
        local className = "net/iapploft/games/battletetris/Functions"
        local ok = LuaJavaBridge.callStaticMethod(className,"showAdBar",args,sigs)
        if not ok then
            print("luaj error")

        end
    elseif (cc.PLATFORM_OS_IPHONE == targetPlatform_) or (cc.PLATFORM_OS_IPAD == targetPlatform_) or (cc.PLATFORM_OS_MAC == targetPlatform_) then
        LuaObjcBridge.callStaticMethod("AppController","showBar",nil)
    end
   end
end

function hiddenGoogleAd_bar(user)
  -- if currentLoginUser.pay_times == 0 then
     -- LuaObjcBridge.callStaticMethod("AppController","hiddenBar",nil)
  -- end

  if cc.PLATFORM_OS_ANDROID == targetPlatform_ then
        --local args = { handler(self.matchController, self.matchController.onGetPlayIdSuccessed)}
        local args = { 2 }
        local sigs = "(I)V"
        local className = "net/iapploft/games/battletetris/Functions"
        local ok = LuaJavaBridge.callStaticMethod(className,"hiddenAdBar",args,sigs)
        if not ok then
            print("luaj error")
        end
   elseif (cc.PLATFORM_OS_IPHONE == targetPlatform_) or (cc.PLATFORM_OS_IPAD == targetPlatform_) or (cc.PLATFORM_OS_MAC == targetPlatform_) then
         LuaObjcBridge.callStaticMethod("AppController","hiddenBar",nil)
   end
end
function insertGooglePageAd_bar()
   if currentLoginUser.pay_times == 0 then
    if cc.PLATFORM_OS_ANDROID == targetPlatform_ then
        print("PLATFORM_OS_ANDROID")
        local args = { 2 }
        local sigs = "(I)V"
        local className = "net/iapploft/games/battletetris/Functions"
        local ok = LuaJavaBridge.callStaticMethod(className,"showAdPage",args,sigs)
        if not ok then
            print("luaj error")
        end


    elseif (cc.PLATFORM_OS_IPHONE == targetPlatform_) or (cc.PLATFORM_OS_IPAD == targetPlatform_) or (cc.PLATFORM_OS_MAC == targetPlatform_) then
        LuaObjcBridge.callStaticMethod("AppController","addPage",nil)
    end



   end
end
function romShowGoogleAdPage()
   if currentLoginUser.pay_times == 0 then
      local r = math.random(1, 8)
     -- print("--->",r)
      if r == 7 then
        if cc.PLATFORM_OS_ANDROID == targetPlatform_ then
             print("PLATFORM_OS_ANDROID")
              local args = { 2 }
               local sigs = "(I)V"
               local className = "net/iapploft/games/battletetris/Functions"
               local ok = LuaJavaBridge.callStaticMethod(className,"showAdPage",args,sigs)
               if not ok then
                  print("luaj error")
               end


        elseif (cc.PLATFORM_OS_IPHONE == targetPlatform_) or (cc.PLATFORM_OS_IPAD == targetPlatform_) or (cc.PLATFORM_OS_MAC == targetPlatform_) then
             LuaObjcBridge.callStaticMethod("AppController","addPage",nil)
        end
       -- LuaObjcBridge.callStaticMethod("AppController","addPage",nil)
      end
   end
end
function facebookPost()
    if cc.PLATFORM_OS_ANDROID == targetPlatform_ then
        print("PLATFORM_OS_ANDROID")
         local args = { LANG["send_message_app_name_text"] }
               local sigs = "(Ljava/lang/String;)V"
               local className = "net/iapploft/games/battletetris/Functions"
               local ok = LuaJavaBridge.callStaticMethod(className,"post",args,sigs)
               if not ok then
                  print("luaj error")
               end
    elseif (cc.PLATFORM_OS_IPHONE == targetPlatform_) or (cc.PLATFORM_OS_IPAD == targetPlatform_) or (cc.PLATFORM_OS_MAC == targetPlatform_) then
        LuaObjcBridge.callStaticMethod("FacebookManager","post",{name=LANG["send_message_app_name_text"],title=LANG["send_message_title_text"],message=LANG["send_message_message_text"]})
    end
end
-- function facebookSend()
--     if cc.PLATFORM_OS_ANDROID == targetPlatform_ then
--               print("PLATFORM_OS_ANDROID")
--               local args = { 2 }
--                local sigs = "(I)V"
--                local className = "net/iapploft/games/battletetris/Functions"
--                local ok = LuaJavaBridge.callStaticMethod(className,"showAdPage",args,sigs)
--                if not ok then
--                   print("luaj error")
--                end
--     elseif (cc.PLATFORM_OS_IPHONE == targetPlatform_) or (cc.PLATFORM_OS_IPAD == targetPlatform_) or (cc.PLATFORM_OS_MAC == targetPlatform_) then
--                 LuaObjcBridge.callStaticMethod("FacebookManager","Send",{name=LANG["send_message_app_name_text"],title=LANG["send_message_title_text"],message=LANG["send_message_message_text"]})
--     end
-- end
function facebookInvite()
    if cc.PLATFORM_OS_ANDROID == targetPlatform_ then
              print("PLATFORM_OS_ANDROID")
              local args = { LANG["invite_message_text"], LANG["invite_title_text"]}
               local sigs = "(Ljava/lang/String;Ljava/lang/String;)V"
               local className = "net/iapploft/games/battletetris/Functions"
               local ok = LuaJavaBridge.callStaticMethod(className,"invite",args,sigs)
               if not ok then
                  print("luaj error")
               end
    elseif (cc.PLATFORM_OS_IPHONE == targetPlatform_) or (cc.PLATFORM_OS_IPAD == targetPlatform_) or (cc.PLATFORM_OS_MAC == targetPlatform_) then
           LuaObjcBridge.callStaticMethod("FacebookManager","invite",{message=LANG["invite_message_text"],title=LANG["invite_title_text"]})
    end
end


function showBindTip(view)
    if cc.PLATFORM_OS_ANDROID == targetPlatform_ then
        local str = string.gsub(LANG["prompt_bind_gc_text"],"GameCenter","Facebook")
        promptText(str,view)
    elseif (cc.PLATFORM_OS_IPHONE == targetPlatform_) or (cc.PLATFORM_OS_IPAD == targetPlatform_) or (cc.PLATFORM_OS_MAC == targetPlatform_) then
        promptText(LANG["prompt_bind_gc_text"],view)
    end


end

function print_r(root)
    local print = print
    local tconcat = table.concat
    local tinsert = table.insert
    local srep = string.rep
    local type = type
    local pairs = pairs
    local tostring = tostring
    local next = next

    --function print_r(root)
        local cache = {  [root] = "." }
        local function _dump(t,space,name)
            local temp = {}
            for k,v in pairs(t) do
                local key = tostring(k)
                if cache[v] then
                    tinsert(temp,"+" .. key .. " {" .. cache[v].."}")
                elseif type(v) == "table" then
                    local new_key = name .. "." .. key
                    cache[v] = new_key
                    tinsert(temp,"+" .. key .. _dump(v,space .. (next(t,k) and "|" or " " ).. srep(" ",#key),new_key))
                else
                    tinsert(temp,"+" .. key .. " [" .. tostring(v).."]")
                end
            end
            return tconcat(temp,"n"..space)
        end
        print(_dump(root, "",""))
   -- end
end
