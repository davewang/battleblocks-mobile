
local LoginWindow = class("LoginWindow", cc.load("mvc").ViewBase)
--local BackgroundView = import(".BackgroundView")
local LoginView = import("app.views.LoginView")

function LoginWindow:onCreate()
    self.bg = display.newSprite("bg.png")
        :move(display.center)
        :addTo(self,-1)
    self.bg:setGlobalZOrder(-2)
    LoginView:create(self)
  --  showBindTip(self)
    --promptText(LANG["prompt_bind_gc_text"],self)
end
return LoginWindow
