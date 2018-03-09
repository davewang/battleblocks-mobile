local RegisterView = class("RegisterView",cc.Node)

local crypt = require "crypt"
local BTN_TAGS = {
    SIGN_IN = 1001,
    SIGN_UP = 1002,

}
function RegisterView:ctor(view)
    self.ownView = view
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255/2))
    self.bg:setTouchEnabled(false)
    self:addChild(self.bg)
    --print("LoginView" )
    --print(view )
    display.newLayer()
    :onTouch(handler(self, self.onTouch),false,true)
    :addTo(self)
    self._bg = display.newSprite("daily_bg.png")
    :move(display.center)
    :addTo(self)

    local titlel = ccui.Text:create(LANG["register_title_text"], "fonts/fzzy.ttf", 68)
    titlel:setTextHorizontalAlignment(1)
    titlel:addTo(self._bg)
    --  print(prompt:getStringLength())
    titlel:enableOutline(cc.c4b(116, 54, 26, 255), 4)
    titlel:move(cc.p(self._bg:getContentSize().width / 2.0,self._bg:getContentSize().height-titlel:getContentSize().height) )

    local function textFieldEvent(sender, eventType)
        print("textFieldEvent:",eventType)
        local attach_with_ime = 0
        local detach_with_ime = 1
        local insert_text = 2
        local delete_backward = 3
        if eventType ==  attach_with_ime then
            local textField = sender
        elseif eventType ==  detach_with_ime then
            local textField = sender
        elseif eventType ==  insert_text then
            local textField = sender

        elseif eventType == delete_backward then
            local textField = sender
        end
    end

    local userNameFiledBg = ccui.ImageView:create()
    userNameFiledBg:loadTexture("text_field_bg.png")
    --inputBg:setAnchorPoint(cc.p(0,0))
    userNameFiledBg:setPosition(cc.p(self._bg:getContentSize().width / 2.0, self._bg:getContentSize().height / 1.4))
    -- inputBg:setName("uread1")
    self._bg:addChild(userNameFiledBg)

    local userNameFiled = ccui.TextField:create()
    userNameFiled:setMaxLengthEnabled(true)
    userNameFiled:setMaxLength(8)
    userNameFiled:setTouchEnabled(true)
    userNameFiled:setFontName("fonts/fzzy.ttf")
    userNameFiled:setFontSize(46)
    userNameFiled:setPlaceHolderColor(cc.c4b(225, 225, 225,255))
    userNameFiled:setTextColor(cc.c4b(25, 25, 25,255))
    userNameFiled:setPlaceHolder(LANG["login_username_tip_text"])
    userNameFiled:setPosition(cc.p(userNameFiledBg:getContentSize().width / 2.0, userNameFiledBg:getContentSize().height / 2))
    userNameFiled:addEventListener(textFieldEvent)
    userNameFiledBg:addChild(userNameFiled)
    userNameFiled:attachWithIME()

    local passFiledBg = ccui.ImageView:create()
    passFiledBg:loadTexture("text_field_bg.png")
    --inputBg:setAnchorPoint(cc.p(0,0))
    passFiledBg:setPosition(cc.p(self._bg:getContentSize().width / 2.0, self._bg:getContentSize().height / 1.8))
    -- inputBg:setName("uread1")
    self._bg:addChild(passFiledBg)

    local passFiled = ccui.TextField:create()
    passFiled:setMaxLengthEnabled(true)
    passFiled:setMaxLength(8)
    passFiled:setTouchEnabled(true)
    passFiled:setFontName("fonts/fzzy.ttf")
    passFiled:setFontSize(46)
    passFiled:setPlaceHolderColor(cc.c4b(225, 225, 225,255))

    passFiled:setTextColor(cc.c4b(25, 25, 25,255))
    passFiled:setPlaceHolder(LANG["login_pwd_tip_text"])
    passFiled:setPosition(cc.p(passFiledBg:getContentSize().width / 2.0, passFiledBg:getContentSize().height / 2))
    passFiled:addEventListener(textFieldEvent)
    passFiledBg:addChild(passFiled)


    local passFiledBg1 = ccui.ImageView:create()
    passFiledBg1:loadTexture("text_field_bg.png")
    --inputBg:setAnchorPoint(cc.p(0,0))
    passFiledBg1:setPosition(cc.p(self._bg:getContentSize().width / 2.0, self._bg:getContentSize().height / 2.5))
    -- inputBg:setName("uread1")
    self._bg:addChild(passFiledBg1)

    local passFiled1 = ccui.TextField:create()
    passFiled1:setMaxLengthEnabled(true)
    passFiled1:setMaxLength(8)
    passFiled1:setTouchEnabled(true)
    passFiled1:setFontName("fonts/fzzy.ttf")
    passFiled1:setFontSize(46)
    passFiled1:setPlaceHolderColor(cc.c4b(225, 225, 225,255))

    passFiled1:setTextColor(cc.c4b(25, 25, 25,255))
    passFiled1:setPlaceHolder(LANG["login_pwd_again_tip_text"])
    passFiled1:setPosition(cc.p(passFiledBg1:getContentSize().width / 2.0, passFiledBg1:getContentSize().height / 2))
    passFiled1:addEventListener(textFieldEvent)
    passFiledBg1:addChild(passFiled1)
    --passFiled:attachWithIME()
    --setDetachWithIME
    --textField:setDetachWithIME(false)


    local submit_button = ccui.Button:create( "name_input_btn.png", "name_input_btn.png")
    local register_button = ccui.Button:create( "name_input_btn.png", "name_input_btn.png")
    local function sha1(text)
        local c = crypt.sha1(text)
        return crypt.hexencode(c)
    end
    local httpc = self.ownView:getApp():getHttpClient()
    function submit(sender,type)
        print(type )
        if type~=2 then
            return
        end

        userNameFiled:didNotSelectSelf()
        passFiled:didNotSelectSelf()
        playSound(GAME_SFXS.buttonClick)
        local t = sender:getTag()
        if  t == BTN_TAGS.SIGN_IN then
            self.ownView:getApp():enterScene("LoginWindow")
            return
        end
        local userName = userNameFiled:getString()
        local password = passFiled:getString()
        local password1 = passFiled1:getString()
        if password1 ~= password then
            promptText(LANG["prompt_input_password_match_text"],self)
            return;
        end
        if (string.len(userName)>4 and string.len(password)>4 ) then
            self.ownView:getApp():showLoadingInView(self.ownView)
            print("getHttpClient = ",httpc)
            --print_r(httpc)
            print("userName = ",userName)
            print("sha1 = ",sha1(password))
            local encodePwd = sha1(password)
            print("platform = ",self.ownView:getApp().platform_type)
            httpc:request("register",{username = userName,password=encodePwd,platform=self.ownView:getApp().platform_type} , function(obj)
                --print("obj.result ", obj.result )
                self.ownView:getApp():hideLoadingView()
                if obj.result then

                    promptText(LANG["prompt_regist_success_text"],self.ownView)
                    local call1 = cc.CallFunc:create(function ()
                        self.ownView:getApp():showLoadingInView(self.ownView,LANG["prompt_auto_login_text"])
                    end)
                    local call2 = cc.CallFunc:create(function ()
                        self.ownView:getApp():hideLoadingView()
                        self.ownView:getApp():getUserManager():loginWithUserNameAndPass(userName,encodePwd)

                    end)
                    local sp = cc.Sequence:create(cc.DelayTime:create(0.5),call1,cc.DelayTime:create(2.6),call2)
                    self.ownView:runAction(sp)

                else
                    promptText(LANG["prompt_regist_fail_text"],self.ownView)
                    --print("dispatchMessage ", LANG["prompt_regist_fail_text"])
                end
            end)
        else
            promptText(LANG["prompt_input_len_name_text"],self.ownView)
        end

    end
    submit_button:setPosition(submit_button:getContentSize().width/1.5,  submit_button:getContentSize().height+45)
    submit_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 60})
    submit_button:setTitleColor(cc.c3b(255, 255, 255))
    submit_button:setTitleText(LANG["register_title_text"] )
        submit_button:setTag(BTN_TAGS.SIGN_UP)
    submit_button:addTouchEventListener(submit)
    self._bg:addChild(submit_button)


    register_button:setPosition(self._bg:getContentSize().width-register_button:getContentSize().width/1.5, submit_button:getContentSize().height+45 )
    register_button:getTitleRenderer():setTTFConfig({fontFilePath = "fonts/fzzy.ttf",fontSize = 60})
    register_button:setTitleColor(cc.c3b(255, 255, 255))
    register_button:setTitleText(LANG["login_title_text"] )
    register_button:setTag(BTN_TAGS.SIGN_IN)
    register_button:addTouchEventListener(submit)
    self._bg:addChild(register_button)

    -- local close_button = ccui.Button:create( "red_close_btn.png", "red_close_btn.png")
    -- local function close()
    --       print("close-----")
    --      -- textField:setDetachWithIME(true)
    --        --textField:attachWithIME()
    --       --textField:didNotSelectSelf()
    --   --  self:dismiss()
    --   --  playSound(GAME_SFXS.buttonClick)
    -- end
    -- close_button:setPosition(self._bg:getContentSize().width-close_button:getContentSize().width/2-60,self._bg:getContentSize().height-145+close_button:getContentSize().height/2+10)
    --
    -- close_button:addTouchEventListener(close)
    -- self._bg:addChild(close_button)
    self.ownView:addChild(self,100)
end
function RegisterView:onTouch(event)

    local label = string.format("swipe: %s", event.name)

    if event.name == 'began' then
        --print("began")
        return true
    elseif event.name == 'moved' then

        --  print("moved")
    elseif event.name == 'ended' then
        --print("ended")
        --self:dismiss()
    end

end
function RegisterView:dismiss()

    self.ownView:removeChild(self)
end
return RegisterView
