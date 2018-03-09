local DrawerView = class("DrawerView", cc.Node)

function DrawerView:ctor(...)
--    self.camControlNode = cc.Node:create()
--    self.camControlNode:setNormalizedPosition(cc.p(0.5, 0.5))
--    self:addChild(self.camControlNode)
--    self.camNode = cc.Node:create()
--    self.camNode:setPositionZ(cc.Camera:getDefaultCamera():getPosition3D().z)
--    self.camControlNode:addChild(self.camNode)

    local layer3D = cc.Layer:create()
    self:addChild(layer3D,0)
    self._layerBillBorad = layer3D
    
--    local root = cc.Sprite3D:create( )
--    root:setNormalizedPosition(cc.p(.5,.25));
--    self:addChild(root) 
--    self._layerBillBorad = root
    self._camera = cc.Camera:createPerspective(60,  display.width/display.height, 1, 500)
    self._camera:setCameraFlag(cc.CameraFlag.USER1)
    self._layerBillBorad:addChild(self._camera)
    
    self.items = {}
    local its = {...}
    for i,v in ipairs(its) do
        table.insert(self.items,v)
        print("i")
    end
    self.z_size=100
    self.y_size=30

    self.count = #self.items
    display.newLayer()
        :onTouch(handler(self, self.onTouch))
        :addTo(self)
end
function DrawerView:setBasePosition(pos)
	self.basePos = pos
end
function DrawerView:setDepthAndSpacing(pos)
  self.z_size=pos.depth
  self.y_size=pos.spacing

end


function DrawerView:show()
    for i=1,self.count do
        local  board = self.items[i].board
        board:setPosition3D(cc.vec3(self.basePos.x, self.basePos.y+((i-1)*self.y_size), (i-1)*-self.z_size ))
        --board:setColor(cc.c3b( math.random(0,255), math.random(0,255),  math.random(0,255)))
        board:setOpacity((1-(i-1)*0.2) *255)
        self._layerBillBorad:addChild(board)
        --self:addChild(board)
    end
end
function DrawerView:onTouch(event)

    local label = string.format("swipe: %s", event.name)

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
            self.direction = nil
            if math.abs(self.mx-tx)>math.abs(self.my-ty)  then
            else

                if self.my<ty then

                    if self.items[1].board:getNumberOfRunningActions() >0 then
                        return
                    end
                    local ponsition1 = self.items[1].board:getPosition3D()
                    if ponsition1.y == self.basePos.y then
                        return
                    end
                    self.direction = DIRECTION.up

                    --print( string.format("swipe: %s",  "up"))
                    for i=1,#self.items do
                        local ponsition = self.items[i].board:getPosition3D()
                        -- print( string.format("x: %d,y:%d,z:%d",ponsition.x,ponsition.y,ponsition.z))
                        local dz =  ponsition.z-self.z_size
                        --self.billBoards[i]:setPosition3D(cc.vec3(ponsition.x, ponsition.y+(30), dz ))
                        self.items[i].board:stopAllActions()
                        local oldOp = self.items[i].board:getOpacity()
                        self.items[i].board:setOpacity(oldOp-(0.2*255))
                        local action = cc.MoveTo:create(0.1,cc.vec3(ponsition.x, ponsition.y+(self.y_size), dz ))
                        self.items[i].board:setPosition3D(cc.vec3(ponsition.x, ponsition.y+(self.y_size), dz ))
                        --self.items[i].board:runAction(action)
                        if dz>0 then
                        -- self.items[i].board:setVisible(false)
                        else
                            --self.items[i].board:setVisible(true)
                        end
                    end


                else
                    if self.items[self.count].board:getNumberOfRunningActions() >0 then
                        return
                    end
                    local ponsition1 = self.items[self.count].board:getPosition3D()
                    if ponsition1.y == self.basePos.y then
                        return
                    end
                    self.direction = DIRECTION.down
                    --                    label = string.format("swipe: %s",  "down")
                    --                    self.game_.gravity = 2
                   -- print( string.format("swipe: %s",  "down"))

                    for i=1,#self.items do
                        local ponsition = self.items[i].board:getPosition3D()
                        -- print( string.format("x: %d,y:%d,z:%d",ponsition.x,ponsition.y,ponsition.z))
                        local dz = ponsition.z+self.z_size
                        --self.billBoards[i]:setPosition3D(cc.vec3(ponsition.x, ponsition.y-(30),dz))
                        -- cc.vec3(display.width/2, display.height/2+((i-1)*30), (i-1)*-100 )
                        --self.billBoards[i]
                        self.items[i].board:stopAllActions()
                        local oldOp = self.items[i].board:getOpacity()
                        self.items[i].board:setOpacity( oldOp+(0.2*255))
                        local action = cc.MoveTo:create(0.1,cc.vec3(ponsition.x, ponsition.y-(self.y_size),dz))
                      --  self.items[i].board:runAction(action)

                        self.items[i].board:setPosition3D(cc.vec3(ponsition.x, ponsition.y-(self.y_size),dz))


                        if dz>0 then
                        --self.items[i].board:setVisible(false)
                        else
                        -- self.items[i].board:setVisible(true)
                        end
                    end
                end
            end

            --self.killsLabel_:setString(label)
            self.mx=tx
            self.my=ty
        end

    elseif event.name == 'ended' then
       if self.isDirectionTouch==false then
            for i=1,#self.items do
                local ponsition = self.items[i].board:getPosition3D()
                if ponsition.z==0 then
                --local position1 = cc.p(self.items[i].board:getPosition3D())
                local  s1 = self.items[i].board:getTexture():getContentSize()
                --print("x = ",ponsition.x," y = ",ponsition.y)
                local touchRect = cc.rect(-s1.width / 2 + ponsition.x, -s1.height / 2 + ponsition.y, s1.width, s1.height)
                --print("width = ",s1.width," height = ",s1.height)
                local b = cc.rectContainsPoint(touchRect, cc.p(self.mx,self.my))
                --print("x = ",ponsition.x," y = ",ponsition.y)
                --print("b = ",b)

                    if  b then
                    	    --print("touch")
                    	    self.items[i].callback()
                    	    return
                    end


                end

            end
       end
    end

end
return DrawerView
