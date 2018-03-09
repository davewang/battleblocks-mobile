local PopupView = import("app.components.PopupView")
local LeagueView = class("LeagueView",PopupView)

function LeagueView:ctor(owner)


    self.super.ctor(owner,nil)
    display.newSprite("dialog_settings_backgrd.png")
      :move(display.center)
      :addTo(self,1)
end
return LeagueView
