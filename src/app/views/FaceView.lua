
local FaceView = class("FaceView", cc.load("mvc").ViewBase)
--local BackgroundView = import(".BackgroundView")
local NameSetView = import("app.views.NameSetView")

function FaceView:onCreate()
    self.bg = display.newSprite("bg.png")
        :move(display.center)
        :addTo(self,-1)
    self.bg:setGlobalZOrder(-2)
    NameSetView:create(self)
    showBindTip(self)
    --promptText(LANG["prompt_bind_gc_text"],self)
end 
return FaceView
