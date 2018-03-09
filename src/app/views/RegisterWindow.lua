
local RegisterWindow = class("RegisterWindow", cc.load("mvc").ViewBase)
--local BackgroundView = import(".BackgroundView")
local RegisterView = import("app.views.RegisterView")

function RegisterWindow:onCreate()
    self.bg = display.newSprite("bg.png")
        :move(display.center)
        :addTo(self,-1)
    self.bg:setGlobalZOrder(-2)
    RegisterView:create(self)
    --showBindTip(self)
    --promptText(LANG["prompt_bind_gc_text"],self)
end
return RegisterWindow
