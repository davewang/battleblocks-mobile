local BTCommon = import("..common.BTCommon")
local Figure = import(".Figure")
local Field = import(".Field")
local Block = import(".Block")
local TetrisBase = class("TetrisBase")

function TetrisBase:ctor(view,match)
    
    --print("...TetrisBase create ")
    self.state = '' --'running', 'clearing', 'game_over', 'spawning', 'paused', 'on_floor'(when lock delay>0)
    
    self.state_names = {on_floor = 'On floor', clearing = 'Clearing full lines',game_over = 'Game over', paused = 'Paused', in_air = 'Falling', spawning = 'Spawning'}
    self.last_state = '' -- stores state before pausing
    self.view = view -- draw view
    self.timer = 0 --in seconds

    self.frame = 1  -- in frames
    self.autorepeat_timer = 1  -- in frames
    self.hold_timer = 1  --in frames, frames since left or right is holded

    self.gravity = 1 
    self.gravities = {{delay = 64, distance = 1}, BTCommon.rules.soft_gravity}  -- delay with which figure fall occurs.

    self.hold_dir = 0  -- -1 left, 1 right, 0 none

    self.lines_to_remove = {} 
    self.matchAble = true
    if match then
        self.matchManager = match
    else
        self.matchAble = false
    end
    self.showNext = true
    self.showHold = true
    self.score = 0
    self.level = 1
    self.history = {}
    self.random_gen_data = {}
    self.holds = {}
    --self.isSimulation = false
    self:init()
    self.lock_state_names ={lock="lock",unlock="unlock"}
 
    self.lock_state ="unlock"

    self.hold_times = 0   
end
function TetrisBase:rotate()
    
    if self.matchAble and self.figure:rotate() then
        self.matchManager:sendRotateMsg()
    end
end
function TetrisBase:loadBoardWithGrid(gird)
 
    print("BTCommon.height =".. tostring(gird.h))
    for y = 1,gird.h   do
        for x = 1, gird.w do
            -- print("back") cc.c4b(0x25,0x2c,0x38,255)
          --  local back = cc.LayerColor:create(cc.c4b(0x25,33,0x38,255),BTCommon.block.w,BTCommon.block.h)
            local back = cc.LayerColor:create(cc.c4b(0x25,33,0x38,255),self.block_config.w,self.block_config.h)
          
            back:setPosition(BTCommon.locationOfPosition(gird,{x=x,y=y},self.block_config))
            self.view:addChild(back) 
            --bk:addChild(back) 
        end
    end
    --bk:setPosition(0,0)
end
function TetrisBase:random_fig()
          
        local result = BTCommon.randomizers[BTCommon.rules.randomizer](self.history, self.random_gen_data)
        local figure = {}
        for _, line in ipairs(BTCommon.figures[result]) do
            table.insert(figure, line)
        end
        figure.index = result
        table.remove(self.history)
        table.insert(self.history, 1, result)
        return figure
end
function TetrisBase:hold()
   if self.hold_times == 0 then
        local hold = table.remove(self.holds,1)
        self:hold_spawn_fig(hold)
   end

end
function TetrisBase:hold_spawn_fig(hold)
    self.hold_times = self.hold_times+1
    print("...hold_spawn_fig ")
    local random_fig = self:random_fig()
    if self.matchAble then
        self.matchManager:sendHoldSimMsg(random_fig.index)
    end


    local current = hold --table.remove(self.figure.next, 1)
    if current then
        table.insert(self.holds, self.figure.current)
        self.figure.current = current 
    else
        table.insert(self.holds, self.figure.current)
        self.figure.current = table.remove(self.figure.next, 1)
        table.insert(self.figure.next, random_fig)
    end
    self.figure:clear()
    self.figure.x = math.ceil((#self.field[1])/2) - math.ceil((#self.figure.current[1])/2) + 1
    self.figure.y = self.field.h+1
    self.figure:spawn()
end
function TetrisBase:spawn_fig()
    self.hold_times=0
    --print("...spawn_fig ")
    local random_fig = self:random_fig()
    if self.matchAble then
        local nextIndex = {}
        for i=1,#self.figure.next do
            table.insert(nextIndex,self.figure.next[i].index) 
        end
         
        self.matchManager:sendInitSimMsg(nextIndex,random_fig.index)
    end
    
  
    local current = table.remove(self.figure.next, 1)
    if current then
        self.figure.current = current
        table.insert(self.figure.next, random_fig)
    else
        self.figure.current = random_fig
    end

    --figure.currentDraw = Figure.new()

    self.figure.x = math.ceil((#self.field[1])/2) - math.ceil((#self.figure.current[1])/2) + 1
    self.figure.y = self.field.h+1
    self.figure:spawn()
    
    
end
function TetrisBase:step(dt)
    local game = self
    if game.state ~= 'game_over' and game.state ~= 'paused' then
        game.timer = game.timer + dt
        if game.timer >= game.frame_delay then
            --print("do_frame")
            self:doFrame()
            game.timer = game.timer - game.frame_delay
        end
    end
end
function TetrisBase:doFrame()
    local game = self
    
    local gravity = game.gravities[game.gravity]
 
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

function TetrisBase:around(dx)
    if self.matchAble then    
        self.matchManager:sendAroundMsg(dx)
    end 
 
    if not BTCommon.collides_with_blocks(self.figure.current, self.field, self.figure.x + dx, self.figure.y) then
        self.figure.x = self.figure.x + dx
    else
        return 
    end
    
    self.figure:move()
    if BTCommon.is_on_floor(self.field,self.figure) then
        self.state = 'on_floor'
    else
        self.state = 'in_air'
    end

    if BTCommon.rules.move_reset then
        self.frame = 1
    end
end
function TetrisBase:merge_figure(figure,grid)
    self.lock_state = "lock"
    for y = 1, #figure.figureBlocks do
        for x = 1, #figure.figureBlocks[1] do
            if figure.figureBlocks[y][x] ~= ' ' then 
                grid[y+figure.y - 1][x+figure.x - 1] = figure.figureBlocks[y][x]
                local function remove()
                    figure.figureBlocks[y][x].shadow:stopAllActions()
                    figure.figureBlocks[y][x].shadow:removeFromParent()
                    figure.figureBlocks[y][x].shadow=nil
                end 

                local removeShadow = cc.CallFunc:create(remove)
                figure.figureBlocks[y][x]:runAction(removeShadow)
                 
            end
        end
    end
   
   -- self.figure.figureBlocks = nil
    self.lock_state = "unlock"
end
function TetrisBase:full_lines()
    local lines_to_remove = {}

    for y = #self.field, 1, -1 do
        local all_filled = true
        for x = 1, #self.field[1] do
            if self.field[y][x] == 0 then
                all_filled = false
                break
            end
        end
        if all_filled then
            table.insert(lines_to_remove, y)
        end
    end

    return lines_to_remove
	
end

function TetrisBase:updateScore()
end
function TetrisBase:on_lines_removed(num)
    if num == 0 then return end
    print("on_lines_removed num = ",num)
    self.score = self.score + (2^(num-1)*100)
    --audio.clear1:play()
    local solid_count = 1 
    if self.matchAble and num > 1 then
        if num > 1 then
            if num==2 then
                solid_count=1  
            elseif num==3 then
                solid_count=2  
            elseif num==4 then
                solid_count=3  
            end
        end
        self.matchManager:sendSolidMsg(solid_count)
        
    end
    self.delegate:updateScore(self.score)
end
function TetrisBase:downDelay(dy)
    for y = #self.field, 1, -1 do
        for x = 1, #self.field[1] do
            if self.field[y][x] ~= 0 and y >= dy  then
                self.field[y][x].x = x
                self.field[y][x].y = y
                local function callback(n)
                    n:setPosition(BTCommon.locationOfPosition(self.field,{x=n.x,y=n.y},self.block_config))
                end
                local wait = cc.DelayTime:create(BTCommon.animationDuration)
                local move = cc.CallFunc:create(callback)
                self.field[y][x]:runAction(cc.Sequence:create({wait,move}))
            end
        end
    end
end
function TetrisBase:remove_lines()
    local lines_removed = #self.lines_to_remove
    for i = 1, #self.lines_to_remove  do
        local dy = self.lines_to_remove[i]
        local removedBlocks = table.remove(self.field, dy)
        for j=1,#removedBlocks do
            if removedBlocks[j] ~= 0 then
                local function callback(n)
                    n:removeFromParent()
                end 

                local action1 = cc.Spawn:create(cc.MoveBy:create(BTCommon.animationDuration*1, cc.p(3*(j-3),10)),
                    cc.ScaleTo:create(BTCommon.animationDuration*1, 1.2)) 
                local action2 = cc.Spawn:create(
                    cc.MoveBy:create(BTCommon.animationDuration*2, cc.p(3*(j-3),-80)),
                    cc.ScaleTo:create(BTCommon.animationDuration*2, 1))
                local remove = cc.CallFunc:create(callback)
                removedBlocks[j]:runAction(cc.Sequence:create({action1,action2,remove}))
                removedBlocks[j]:setLocalZOrder(13)
                 
            end
        end
        self:downDelay(dy)
    end
    
    local function callback(n)
        self.state = 'spawning'
    end

    local wait = cc.DelayTime:create(BTCommon.animationDuration*11)
    local remove = cc.CallFunc:create(callback)
    self.delegate:runAction(cc.Sequence:create({wait,remove}))
     

    for i = 1, lines_removed do
        table.insert(self.field,#self.field+1, {})
        for j=1, #self.field[#self.field-2] do
            self.field[#self.field][j] = 0
        end
    end
    self:on_lines_removed(lines_removed)
end
function TetrisBase:on_game_over()
    print("on_game_over")
    if self.matchAble and self.delegate  then
        self.matchManager:sendGameOverMsg()
        self.delegate:onGameOver()
        return
    end
    if self.delegate then
        self.delegate:onGameOver()
    end
end
function TetrisBase:hard_drop()
    if self.matchAble then
          self.matchManager:sendDropMsg()
    end
    while true do
        if self.figure:fall() then break end
    end
    
    if not BTCommon.rules.hard_drop_lock_delay then self:lock() end
end
function TetrisBase:lock()
    self:merge_figure(self.figure, self.field)

    if BTCommon.collides_with_spawn_zone(self.figure.current, self.field, self.figure.x, self.figure.y) then
        self.state = 'game_over' -- [partial] lock out
        self:on_game_over()
        return
    end

    self.lines_to_remove = self:full_lines()

    if #self.lines_to_remove > 0 then
        self.state = 'clearing'
    else
        -- audio.drop:play()
        playSound(GAME_SFXS.drop)
        self.state = 'spawning'
    end
end
function TetrisBase:onReceived(msg)
    if msg.msg_type == 1 then
        --print("TetrisBase:onReceived")
        if msg.msgid==2001 then
            self:addSolidRows(msg.solid_count)
            --self:build_next(msg.next)
            --self:spawn_build_fig(msg.random_fig)
        end
        if msg.msgid==9001 then
              --print(#msg.data)
              for i=1,#msg.data do 
                 print(string.format("{a=%d,b=%d}",msg.data[i].a,msg.data[i].b))
              end 
              self.view.ownView:getApp():hideLoadingView() 
              self.view:start()
            --self:build_next(msg.next)
            --self:spawn_build_fig(msg.random_fig)
        end
    end
end
 

function TetrisBase:upDelay(dy)
    for y = #self.field, 1, -1 do
        for x = 1, #self.field[1] do
            if self.field[y][x] ~= 0 and y >= dy  then
                self.field[y][x].x = x
                self.field[y][x].y = y
                local function callback(n)
                    n:setPosition(BTCommon.locationOfPosition(self.field,{x=n.x,y=n.y},self.block_config))
                end
                local wait = cc.DelayTime:create(BTCommon.animationDuration)
                local move = cc.CallFunc:create(callback)
                self.field[y][x]:runAction(cc.Sequence:create({wait,move}))
            end
        end
    end
end
function TetrisBase:addSolidRows(solid_count)
    
    
    local gap_index = math.random(#self.field[#self.field-2])
    for i = 1, solid_count do
        local dy = 1
        local solidBlocks = table.insert(self.field,1,{})
        for j=1, #self.field[#self.field-2] do
            self.field[dy][j] = 0
            
            if j == gap_index then
                self.field[dy][j] = 0
            else
                local tile = Block:create({color = BTCommon.colors[#BTCommon.colors], alpha=255,w=self.block_config.w,h=self.block_config.h})--({255,255,255},255) 
                tile.x = j
                tile.y = dy
                self.view:addChild(tile,11) 
                tile:setPosition(BTCommon.locationOfPosition(self.field,{x=tile.x,y=tile.y},self.block_config))
                self.field[dy][j] = tile
            end
        end
        self:upDelay(dy)
    end
    self.matchManager:sendSolidSimMsg(solid_count,gap_index)
end
function TetrisBase:sendReadyMsg()
    if self.matchAble then
        self.matchManager:sendReadyMsg()
    end
end

function TetrisBase:init()
        self.score = 0
        self.level = 1
        self.curr_interval = 0
        self.frame_delay = 1/BTCommon.rules.fps
        self.frame_timer = 0
        self.block_config = {
          w = 73.5,
          h = 93,
          offset = 1 -- space between blocks
        }
        self.block_show_config = {
          w = 28,
          h = 28,
          offset = 1 -- space between blocks
        }
        self.gravities = {{delay = 64, distance = 1}, BTCommon.rules.soft_gravity}
        self.history = {}
        self.random_gen_data = {}
        self.figure = Figure:create()
        self.figure.next = {}
        self.figure.game = self
        if self.matchAble then
           self.figure:setNextOffset({x = -6.5, y = 26})
           self.figure:setHoldOffset({x = -6.5, y = 4})
        else 
           self.figure:setNextOffset({x = -6.5, y = 32})
           self.figure:setHoldOffset({x = -6.5, y = 8})
    
        end 
        self.field = Field:create()
        --if self.matchAble then    --324 17
          --self.field:setOffset({x = 324, y = 22})
        --end
        self.field:setOffset({x = 324, y = 22})
        
        self.figure.view = self.view
        self.figure.grid = self.field
        for i=1, BTCommon.rules.next_visible do
            table.insert(self.figure.next, self:random_fig())
        end
        --spawn_fig()
        --print("...TetrisBase init ")
        --self:loadBoardWithGrid(self.field)
        self.state = 'in_air'
end
return TetrisBase
