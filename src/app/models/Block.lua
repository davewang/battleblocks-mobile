--local BTCommon = import("..BTCommon")
local Block = class("Block", function()
    return display.newNode()
end)
function Block:ctor(config)
   -- self.w = 15
   -- self.h = 15
    self.w = config.w--50
    self.h = config.h--50
   
    self.x = 0
    self.y = 0
    self.offset = 1 -- space between blocks
    self.color = config.color
    self:init(config.alpha)
end

function Block:init(alpha)
    local boxSize = cc.size(self.w,self.h)
    --,cc.rect(0, 0, self.w,self.h
    self.newBlock = cc.Sprite:create(self.color)-- cc.Sprite:create("block_1.png")--cc.LayerColor:create(cc.c4b(self.color[1],self.color[2],self.color[3],alpha))

    local spx =  self.newBlock:getTextureRect().width
    local spy =  self.newBlock:getTextureRect().height
    self.newBlock:setScaleX(self.w/spx) --设置精灵宽度缩放比例
    self.newBlock:setScaleY(self.h/spy)
    self.newBlock:setOpacity(alpha)
   -- local b = cc.LayerColor:create(cc.c4b(0x25,0x2c,0x38,255))
   -- b:setAnchorPoint(cc.p(0.5,0.5))
    -- b:setContentSize( cc.size( (math.floor(self.w/2 - 0.25)), (math.floor(self.h/2 - 0.25)) ))
    -- b:setPosition(cc.p(math.ceil(self.w/4),math.ceil(self.h/4)))
    self.newBlock:setAnchorPoint(cc.p(0,0))
    --self.newBlock:addChild(b)
    --newBlock:setAnchorPoint(cc.p(0.5,0.5))
   -- self.newBlock:setContentSize( boxSize )
    self.newBlock:setTag(111)
   -- newBlock:ignoreAnchorPointForPosition(false)
    self:addChild(self.newBlock)
end

 
--function Block.create(w,h,color,alpha) 
--    --print(string.format(  "w : %d h : %d color : %s",w,h,color))
--    --color
--    alpha = alpha or 255
--    local block = Block.new()
--    block.w = w 
--    block.h = h
--    block.color = color
--    block:init(alpha)
--    return block
--end
-- 
 
--function Block:updatePosition(x, y)    
--    local lx = field.offset.x + (x-1)*(block.w + block.offset)
--    local ly = field.offset.y + (y-1)*(block.h + block.offset)
--    self:setPosition(cc.p(lx, ly))
--end

 
return Block
 