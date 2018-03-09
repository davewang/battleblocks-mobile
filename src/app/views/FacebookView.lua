
local FacebookView = class("FacebookView", cc.load("mvc").ViewBase)
local app_secret = "043c5ca76c20033e6cebe361e0b6e98a"
local app_id = "842963855824402"
local graphApi = "https://graph.facebook.com/"
local dialogBase="https://m.facebook.com/dialog/"
local userDefault = cc.UserDefault:getInstance()
function FacebookView:onCreate()
    self.bg = display.newSprite("bg.png")
        :move(display.center)
        :addTo(self,-1)
    self.bg:setGlobalZOrder(-2)
 
    self.webview=WebView:create()  
    self:addChild(self.webview,10)  
    self.webview:move(display.center) 
    self.webview:setContentSize(display.width/1.5,display.height/1.5)  
    
    self.redirectUrlString ="http://www.facebook.com/connect/login_success.html"
    local function shouldStart(url,sender)
        print("shouldStart",sender:getString())
        
    end
    local function finishloading(url,sender)
        print("finishloading",sender:getString())
        if self.access_token == nil and self:checkLogin(sender:getString()) then
             print("islogin")
             self:me()
             userDefault:setStringForKey(K_FACEBOOK_ACCESSTOKEN,self.access_token )
        end
    end
    local function failloading(url,sender)
        print("failStart",sender:getString())
    end
    local function jsCallBack(url,sender)
        print("jsCallBack",sender:getString())
    end
    
	
    self.webview:setDelegate()
    
    self.webview:registerScriptHandler(shouldStart,0)
    self.webview:registerScriptHandler(finishloading,1)
    self.webview:registerScriptHandler(failloading,2)
    self.webview:registerScriptHandler(jsCallBack,3)
    self.webview:setScalesPageToFit(false)
    
    local access_token = userDefault:getStringForKey(K_FACEBOOK_ACCESSTOKEN)
    print(string.format( "oldid = %s language = %s",access_token,  device.language))
   
    if string.len(access_token)<2 then
        self:login()
    else
       self.access_token = access_token
       --self:me()
       self:invites("invites","invites friends","")
    end
 
end 
function FacebookView:login() 
    self.permissions = "user_about_me,user_friends,user_actions.news,user_actions.fitness,publish_actions,user_posts,user_events,read_stream"--,
   
    self.authFormatString ="https://graph.facebook.com/oauth/authorize?client_id=%s&redirect_uri=%s&scope=%s&type=user_agent&display=touch"
    self.webview:loadURL(string.format(self.authFormatString,app_id,self.redirectUrlString,self.permissions))  
end
function FacebookView:friends()
    self.webview:loadURL(graphApi..'me')
end
function FacebookView:invites(title,message,unInstalled)
    --self.webview:loadURL(graphApi..'me')
    local  url = dialogBase.."apprequests"
    
    url = url.. string.format("?app_id=%s&display=touch&frictionless=1&message=%s&title=%s&maxRecipients=50&redirect_uri=%s&sdk=2&access_token=%s",app_id,title,message,self.redirectUrlString,self.access_token )
    print("url:"..url)
    self.webview:loadURL(url)
       
end

function FacebookView:me()
    
    self.webview:loadURL(graphApi..'me?fields'.."&access_token=".. self.access_token )
     
end
function FacebookView:checkLogin(url)
    for k,v in string.gmatch(url,"(access_token)=(%w+)") do   
        if k =="access_token" then
            print("access_token=",v)
            self.access_token = v
            return true
        end
    end              
    return false
end
return FacebookView
