-- VSShowView is a combination of view and controller
local VSShowView = class("VSShowView", cc.load("mvc").ViewBase)

function VSShowView:onCreate()

    print("VSShowView:onCreate------------>1")

  
    --self:getApp():createView("VSShowView"):addTo(self)   
    self.stars = display.newSprite("starfield-hd.jpg")
        :move(display.center)
        :addTo(self,-1)
    self.stars:runAction(cc.RepeatForever:create(cc.RotateBy:create(360,360)))
    print("VSShowView:onCreate------------>2")
--  game center
--    local currentPlayerNode = display.newNode()
--    local avatar = self:getApp().matchController.currentPlayer.avatar or display.newSprite("defalut_photo.png")
--    local cs = avatar:getContentSize()
--    local cx,cy = avatar:getPosition()
--    local nameLab = cc.Label:createWithTTF(self:getApp().matchController.currentPlayer.name, "fonts/CGF Locust Resistance.ttf", 22)
--    currentPlayerNode:addChild(avatar)
--    currentPlayerNode:addChild(nameLab)
--    nameLab:move(cx, cy-cs.height/2-20)
--    
--    local remotePlayerNode = display.newNode()
--    local remoteAvatar = self:getApp().matchController.remotePlayer.avatar or display.newSprite("defalut_photo.png")
--    local rs = remoteAvatar:getContentSize()
--    local rx,ry = remoteAvatar:getPosition()
--    local remoteNameLab = cc.Label:createWithTTF(self:getApp().matchController.remotePlayer.name, "fonts/CGF Locust Resistance.ttf", 22)
--    remotePlayerNode:addChild(remoteAvatar)
--    remotePlayerNode:addChild(remoteNameLab)
--    remoteNameLab:move(rx, ry-rs.height/2-20)
--      
        
    local currentPlayerNode = display.newNode()
    local avatar = self:getApp():getCurrentUser().avatar or display.newSprite("defalut_photo.png")
    if self:getApp():getCurrentUser().avatarid then
        avatar:setSpriteFrame(AVATER_TYPE[self:getApp():getCurrentUser().avatarid])
    end
   
    
    local cs = avatar:getContentSize()
    local cx,cy = avatar:getPosition()
    local nameLab = cc.Label:createWithTTF(self:getApp():getCurrentUser().nickname, "fonts/CGF Locust Resistance.ttf", 22)
    currentPlayerNode:addChild(avatar)
    currentPlayerNode:addChild(nameLab)
    nameLab:move(cx, cy-cs.height/2-20)

    local remotePlayerNode = display.newNode()
    local remoteAvatar = self:getApp():getMatchManager().remotePlayer.avatar or display.newSprite("defalut_photo.png")
    if self:getApp():getMatchManager().remotePlayer.avatarid then
        remoteAvatar:setSpriteFrame(AVATER_TYPE[self:getApp():getMatchManager().remotePlayer.avatarid])
    end
    local rs = remoteAvatar:getContentSize()
    local rx,ry = remoteAvatar:getPosition()
    local remoteNameLab = cc.Label:createWithTTF(self:getApp():getMatchManager().remotePlayer.nickname, "fonts/CGF Locust Resistance.ttf", 22)
    remotePlayerNode:addChild(remoteAvatar)
    remotePlayerNode:addChild(remoteNameLab)
    remoteNameLab:move(rx, ry-rs.height/2-20)

    
 
    local armature = ccs.Armature:create("bisaikaishi")--addRowsAni--Dragon 
    local count = armature:getAnimation():getMovementCount()
    print("count = ",count)

    local function animationEvent(armatureBack,movementType,movementID)
        local id = movementID

        if movementType == 1 then
            print("movementID = ",movementID)
            if id == "play" then                
                armatureBack:getAnimation():play("play2")
            elseif id == "play2" then
                armatureBack:getAnimation():play("play3")
            elseif id == "play3" then
                print("end")  
                self:getApp():enterScene("BattleScene")
            end


        end
    end
    local localBone  = ccs.Bone:create("local")
    localBone:addDisplay(currentPlayerNode, 0)
    localBone:changeDisplayWithIndex(0, true)
    localBone:setIgnoreMovementBoneData(true)
    localBone:setLocalZOrder(100)
    localBone:setScale(0.5)
    localBone:setRotation(180); 
    armature:addBone(localBone, "body-50")
    local remoteBone  = ccs.Bone:create("remote")
    remoteBone:addDisplay(remotePlayerNode, 0)
    remoteBone:changeDisplayWithIndex(0, true)
    remoteBone:setIgnoreMovementBoneData(true)
    remoteBone:setLocalZOrder(100)
    remoteBone:setScale(0.5)
    armature:addBone(remoteBone, "body-5")
    armature:getAnimation():setMovementEventCallFunc(animationEvent)
    armature:getAnimation():play("play")
    armature:getAnimation():setSpeedScale(0.5)
    armature:setPosition(cc.p(display.cx, display.cy))
     

 
    self:addChild(armature)
 


end
return VSShowView