local PopupView = class("PopupView",cc.Node)
function PopupView:ctor(view,callback)
    self.ownView = view
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255/2))
    self.bg:setTouchEnabled(false)
    self:addChild(self.bg)
    display.newLayer()
        :onTouch(handler(self, self.onTouch),false,true)
        :addTo(self)
    callback(self)
    self.ownView:addChild(self,100)
end
function PopupView:dismiss()
    self.ownView:removeChild(self)
end
function PopupView:onTouch(event)

    local label = string.format("swipe: %s", event.name)

    if event.name == 'began' then
        --print("began")
        return true
    elseif event.name == 'moved' then

      --  print("moved")
    elseif event.name == 'ended' then
       --print("ended")
        self:dismiss()
    end

end
return PopupView
