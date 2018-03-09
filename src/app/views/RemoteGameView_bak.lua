local Simulation = import("..models.Simulation")
local RemoteGameView = class("RemoteGameView", cc.load("mvc").ViewBase)

RemoteGameView.events = {
    PLAYER_DISCONNECTED_EVENT = "PLAYER_DISCONNECTED_EVENT",
    PLAYER_GAME_OVER_EVENT = "PLAYER_GAME_OVER_EVENT",
}
function RemoteGameView:onCreate()
    self.score = 0
    self.game_ = Simulation:create(self)
    self.game_.state = 'paused'

    self.game_.delegate = self  
                 
    self:getApp().matchManager:addListener(self.game_)
    cc.bind(self, "event")
 
end
function RemoteGameView:onPlayerDisconnected()
    self.game_.state = 'paused'
    print("RemoteGameView:onPlayerDisconnected")
    self:getApp():getMatchManager():cancelMatchmakingOpponent()
    self:getApp().matchManager:removeListener(self.game_)
    self:dispatchEvent({name = RemoteGameView.events.PLAYER_DISCONNECTED_EVENT})
    
    
   
end
function RemoteGameView:onPlayerGameOver()
    self.game_.state = 'paused'
    print("RemoteGameView:onPlayerGameOver")
    self:getApp():getMatchManager():cancelMatchmakingOpponent()
    self:getApp().matchManager:removeListener(self.game_)
    self:dispatchEvent({name = RemoteGameView.events.PLAYER_GAME_OVER_EVENT})
    
    
    
end
return RemoteGameView