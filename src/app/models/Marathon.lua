 
local TetrisBase = import(".TetrisBase")

local BTCommon = import("..common.BTCommon")
local Figure = import(".Figure")
local Field = import(".Field")
local Block = import(".Block")
local Marathon = class("Marathon",TetrisBase)
function Marathon:ctor(view)
    self.levels = {{delay = 64, distance = 1},{delay = 60, distance = 1},{delay = 56, distance = 1},{delay = 52, distance = 1},{delay = 48, distance = 1},
                   {delay = 44, distance = 1},{delay = 40, distance = 1},{delay = 36, distance = 1},{delay = 32, distance = 1},{delay = 28, distance = 1},
                   {delay = 24, distance = 1},{delay = 20, distance = 1},{delay = 16, distance = 1},{delay = 12, distance = 1},{delay = 8, distance = 1},
                   {delay = 4, distance = 1}} 
    self.level = 1
    Marathon.super.ctor(self,view)
  
    self.clean_counts = {5,5,5,5,5,10,10,10,10,10,15,15,15,15,15}
    
    self.current_clean = 0
   
    
    
end
function Marathon:uplevel()
    self.current_clean = 0
    if self.level==16 then
    	return
    end
    self.level = self.level+1
    print("uplevel to ",self.level)
    playSound(GAME_SFXS.fixup) 
end
function Marathon:on_lines_removed(num)
    if num == 0 then return end
    print("on_lines_removed num = ",num)
    self.score = self.score + (2^(num-1)*100)
    if num == 1 then
          playSound(GAME_SFXS.clear1) 
    elseif num == 2 then
          playSound(GAME_SFXS.clear2) 
    elseif num == 3 then
          playSound(GAME_SFXS.clear3) 
    elseif num == 4 then 
          playSound(GAME_SFXS.clear4) 
    end 
    self.delegate:updateScore(self.score)
    self.current_clean = self.current_clean + num
    if self.current_clean >= self.clean_counts[self.level] then
        self:uplevel()
    end
--    
 
end

function Marathon:step(dt)
    local game = self
    --print("do_frame")
    if game.state ~= 'game_over' and game.state ~= 'paused' then
        game.timer = game.timer + dt
        if game.timer >= game.frame_delay then
            
            self:doFrame()
            game.timer = game.timer - game.frame_delay
        end
    end
end
function Marathon:doFrame()
    local game = self
    local gravity = game.gravities[1]
    if  game.gravity==2 then
        gravity = game.gravities[game.gravity]
    else
        gravity = self.levels[self.level]
    end
     --game.gravities[game.gravity]

    if game.hold_dir ~= 0 then
        game.hold_timer = game.hold_timer + 1
        if game.hold_timer >= BTCommon.rules.autorepeat_delay then
            game.autorepeat_timer = game.autorepeat_timer + 1

            if game.autorepeat_timer >= BTCommon.rules.autorepeat_interval then

                game.autorepeat_timer = 1
            end
        end
    end

    if game.state == 'in_air' and game.frame >= gravity.delay then
        for i=1, gravity.distance do

            self.figure:fall()

            if self.matchAble then
                self.matchManager:sendFallMsg()
            end

        end
        if BTCommon.is_on_floor(self.field,self.figure) then
            game.state = 'on_floor'
        end
    elseif game.state == 'on_floor' and
        (game.frame >= BTCommon.rules.lock_delay) then
        print("on_floor")
        self:lock() -- can cause game over
        if self.matchAble then

            self.matchManager:sendLockMsg()
        end
    elseif game.state == 'clearing' and game.frame >= BTCommon.rules.clear_delay then
        self:remove_lines()

        game.state = 'paused'
        if self.matchAble then

            self.matchManager:sendRemoveMsg()
        end
    elseif game.state == 'spawning' then
        game.state = 'in_air'
        game:spawn_fig()
        print("spawning")
    end

    game.frame = game.frame + 1
end
return Marathon