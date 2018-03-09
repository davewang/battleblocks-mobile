local LoadingView = class("ProfileView",cc.Node)
function LoadingView:ctor()
   -- self.ownView = view
    self.bg = cc.LayerColor:create(cc.c4b(0,0,0,255/2))
    self.bg:setTouchEnabled(false)
    self:addChild(self.bg)
    display.newLayer()
        :onTouch(handler(self, self.onTouch),false,true)
        :addTo(self)
    self.loadSpr = display.newSprite("loading.png")
        :move(display.center)
        :addTo(self)
       
    local sp = cc.p(self.loadSpr:getPosition())
    
    self.label = cc.Label:createWithTTF(LANG["loading_text"],"fonts/fzzy.ttf", 46) 
       -- :move(cc.p(sp.x + self.loadSpr:getContentSize().width/2,sp.y-self.loadSpr:getContentSize().height/2-50))
        :addTo( self )
    --self.label:setAnchorPoint(cc.p(1,0.5))
    self.label:move(cc.p(display.cx,display.cy-self.loadSpr:getContentSize().height/2-30))
  --  self.loadSpr:runAction(cc.RepeatForever:create(cc.RotateBy:create(1,360)))
   
end
function LoadingView:showInView(view,string,callback)

    --LANG["waitting_opp_text"]
     local _string = string and string or LANG["loading_text"]
     local _callback = callback 
     self.callback = _callback
     print(self.callback )
     self.label:setString(_string)
     self.loadSpr:runAction(cc.RepeatForever:create(cc.RotateBy:create(1,360)))
     self.ownView = view
     view:addChild(self,1000)
end

function LoadingView:dismiss()
    self.loadSpr:stopAllActions()
    self.ownView:removeChild(self)
end
function LoadingView:onTouch(event)

    local label = string.format("swipe: %s", event.name)
    print("LoadingView:onTouch")
    if event.name == 'began' then
        --print("began")
        return true
    elseif event.name == 'moved' then

      --  print("moved")
    elseif event.name == 'ended' then
       --print("ended")
       -- self:dismiss()
       
       print(self.callback)
          self.callback()
        
    end

end
return LoadingView