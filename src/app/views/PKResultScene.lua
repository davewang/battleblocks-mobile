local PKResultScene = class("PKResultScene", cc.load("mvc").ViewBase)
 
function PKResultScene:onCreate()
    
    self.resultLabel = cc.Label:createWithSystemFont("You win", "Arial", 56)
        :align(display.CENTER, display.center)
        :addTo(self)

    -- add exit button
    local exitButton = cc.MenuItemImage:create("ExitButton.png", "ExitButton.png")
        :onClicked(function()
            self:getApp():enterScene("MainView")
        end)
    cc.Menu:create(exitButton)
        :move(display.cx, display.cy - 200)
        :addTo(self)
end

function PKResultScene:success()
	 
    self.resultLabel:setString("You win! your star +1.")
end
function PKResultScene:fail()

    self.resultLabel:setString("You fail! your star -1.")
end

return PKResultScene