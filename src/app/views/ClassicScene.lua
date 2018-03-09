local ClassicScene = class("ClassicScene", cc.load("mvc").ViewBase)
local ClassicGameView = import(".ClassicGameView")
local ClassicGameOverDialog = import("app.components.ClassicGameOverDialog")
function ClassicScene:onCreate()
    
    self.gameView_ = ClassicGameView:create()
        :addEventListener(ClassicGameView.events.GAME_OVER_EVENT, handler(self, self.onGameOver))
        :start()
        :addTo(self)
     self.gameView_.ownView = self
     audio.playMusic(GAME_SFXS.bgMusic2)
     
end

 
function ClassicScene:onGameOver(event)
    -- add game over text
    --local text = string.format("You scored is %d ", self.gameView_:getScore())
    local currentScore = self:getApp():getUserManager().currentUser.score
    local gameScore = self.gameView_:getScore()
    local clear = self.gameView_:getClear()
    local level = self.gameView_:getLevel()
    local info = {}
    info.score = gameScore
    info.bestScore = gameScore
    if currentScore < gameScore then
        self:getApp():getUserManager():requestUpdateScore(gameScore)
    else
        info.bestScore = currentScore
    end
    info.clear = clear 
    info.level = level
    local dialog = ClassicGameOverDialog:create(self)
    dialog:setInfo(info) 
    playSound(GAME_SFXS.lost) 
    
    -- cc.Label:createWithSystemFont(text, "Arial", 56)
    --     :align(display.CENTER, display.center)
    --     :addTo(self)

    -- -- add exit button
    -- local exitButton = cc.MenuItemImage:create("ExitButton.png", "ExitButton.png")
    --     :onClicked(function()
    --         self:getApp():enterScene("MainScene")
    --     end)
    -- cc.Menu:create(exitButton)
    --     :move(display.cx, display.cy - 200)
    --     :addTo(self)
end
return ClassicScene