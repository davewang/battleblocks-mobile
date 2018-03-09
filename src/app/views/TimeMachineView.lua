
local TimeMachineScene = class("TestScene", cc.load("mvc").ViewBase)
local SOCKET_TICK_TIME = 0.1 
function TimeMachineScene:onCreate()
    self.d2=display.newLayer():addTo(self);
         
   
    self.camControlNode = cc.Node:create()
    self.camControlNode:setNormalizedPosition(cc.p(0.5, 0.5))
    self.d2:addChild(self.camControlNode)

    self.camNode = cc.Node:create()
    self.camNode:setPositionZ(cc.Camera:getDefaultCamera():getPosition3D().z)
    self.camControlNode:addChild(self.camNode)
    
    self.billBoards = {}
    self.maxboards = 5
    for i=1,self.maxboards do
        local  board = cc.BillBoard:create("window.png")
        board:setPosition3D(cc.vec3(display.width/2, display.height/2+((i-1)*30), (i-1)*-100 ))
        --board:setColor(cc.c3b( math.random(0,255), math.random(0,255),  math.random(0,255)))
        board:setOpacity((1-(i-1)*0.2) *255)
        self.d2:addChild(board) 
        --self.billBoards[i]=board
        table.insert(self.billBoards,board)
    end
    
    self.stars = display.newSprite("starfield-hd.jpg")
        :move(display.center)
        :addTo(self,-1)
    self.stars:setGlobalZOrder(-2)
    --self.stars:setLocalZOrder(-200)
    self.stars:runAction(cc.RepeatForever:create(cc.RotateBy:create(360,360)))

    display.newLayer()
        :onTouch(handler(self, self.onTouch))
        :addTo(self)
    
    
    --Billboards
    --Yellow is at the back
--    self.bill1 = cc.BillBoard:create("window.png")
--    self.bill1:setPosition3D(cc.vec3(display.width/2, display.height/2, 0))
--    self.bill1:setColor(cc.c3b(255, 0,   0))
--    --self.bill1:setScale(0.6)
--    self:addChild(self.bill1)
--    self.bill2 = cc.BillBoard:create("window.png")
--    self.bill2:setPosition3D(cc.vec3(display.width/2, display.height/2+40, -30))
--    self.bill2:setColor(cc.c3b(255, 255,   0))
--    --self.bill1:setScale(0.6)
--    self:addChild(self.bill2)
--    self.win = display.newSprite("window.png")
--        :move(display.center)
--        :addTo(self,1)

     
end

function TimeMachineScene:onTouch(event)
--    if self.game_.state == 'paused' then
--        return
--    end
    local label = string.format("swipe: %s", event.name)
    -- self.stateLabel:setString(label)
    -- print("label = "..label)
    if event.name == 'began' then
        self.hasPendingSwipe=true
        self.mx=event.x;
        self.my=event.y;
        self.isDirectionTouch = false
        self.direction = nil
        return true
    elseif event.name == 'moved' then
        local tx = event.x
        local ty = event.y

        if self.hasPendingSwipe and (math.abs(self.mx-tx)>EFFECTIVE_SWIPE_DISTANCE_THRESHOLD or math.abs(self.my-ty)>EFFECTIVE_SWIPE_DISTANCE_THRESHOLD ) then
            self.isDirectionTouch = true
            self.hasPendingDir = false
            --self.hasPendingSwipe = false
            self.direction = nil
            if math.abs(self.mx-tx)>math.abs(self.my-ty)  then
--                self.hasPendingDir = true
--                if self.mx<tx then
--                    self.direction = DIRECTION.right
--                    label = string.format("swipe: %s", "right")
--
--                    self.game_:around(1)
--                    self.game_.hold_dir = 1
--                else
--                    self.direction = DIRECTION.left
--                    label = string.format("swipe: %s",  "left")
--                    self.game_:around(-1)
--                    self.game_.hold_dir = 1
--                end
            else
               -- self.hasPendingSwipe = false
                if self.my<ty then
                    if self.billBoards[1]:getNumberOfRunningActions() >0 then
                        return
                    end
                    local ponsition1 = self.billBoards[1]:getPosition3D()
                    if ponsition1.y == display.height/2 then
                    	   return
                    end
                    self.direction = DIRECTION.up
--                    label = string.format("swipe: %s",  "up")
--                    self.game_:hold()
                    print( string.format("swipe: %s",  "up"))
                    for i=1,#self.billBoards do
                        local ponsition = self.billBoards[i]:getPosition3D()
                        print( string.format("x: %d,y:%d,z:%d",ponsition.x,ponsition.y,ponsition.z))
                        local dz =  ponsition.z-100 
                        --self.billBoards[i]:setPosition3D(cc.vec3(ponsition.x, ponsition.y+(30), dz ))
                        self.billBoards[i]:stopAllActions()
                        local oldOp = self.billBoards[i]:getOpacity()
                        self.billBoards[i]:setOpacity( oldOp-(0.2*255))
                    	    local action = cc.MoveTo:create(0.1,cc.vec3(ponsition.x, ponsition.y+(30), dz ))
                        self.billBoards[i]:runAction(action)
                        if dz>0 then
                            self.billBoards[i]:setVisible(false)
                        else
                            self.billBoards[i]:setVisible(true)
                        end
                    end
                    
                    
                else
                    if self.billBoards[self.maxboards]:getNumberOfRunningActions() >0 then
                      return
                    end
                    local ponsition1 = self.billBoards[self.maxboards]:getPosition3D()
                    if ponsition1.y == display.height/2 then
                        return
                    end
                    self.direction = DIRECTION.down
--                    label = string.format("swipe: %s",  "down")
--                    self.game_.gravity = 2
                    print( string.format("swipe: %s",  "down"))
                    
                    for i=1,#self.billBoards do
                        local ponsition = self.billBoards[i]:getPosition3D()
                        print( string.format("x: %d,y:%d,z:%d",ponsition.x,ponsition.y,ponsition.z))
                        local dz = ponsition.z+100
                        --self.billBoards[i]:setPosition3D(cc.vec3(ponsition.x, ponsition.y-(30),dz))
                        -- cc.vec3(display.width/2, display.height/2+((i-1)*30), (i-1)*-100 )
                        --self.billBoards[i]
                        self.billBoards[i]:stopAllActions()
                        local oldOp = self.billBoards[i]:getOpacity()
                        self.billBoards[i]:setOpacity( oldOp+(0.2*255))
                        local action = cc.MoveTo:create(0.1,cc.vec3(ponsition.x, ponsition.y-(30),dz))
                        self.billBoards[i]:runAction(action)
                        
                        
                        
                        if dz>0 then
                        	    self.billBoards[i]:setVisible(false)
                        	else
                            self.billBoards[i]:setVisible(true)
                        end
                    end
                end
            end

            --self.killsLabel_:setString(label)
            self.mx=tx
            self.my=ty
        end

    elseif event.name == 'ended' then
    end

end

function TimeMachineScene:onEnter() 
    print("onEnter TimeMachineScene  ")

end
function TimeMachineScene:onExit() 

    print("onExit TimeMachineScene  ")

end


return TimeMachineScene