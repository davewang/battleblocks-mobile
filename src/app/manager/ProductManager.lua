
local Listener = import(".Listener")
local ProductManager = class("ProductManager",Listener)
--local json = require("dkjson")
function ProductManager:ctor()
    ProductManager.super.ctor(self)
    self.products = {}
end

function ProductManager:requestProducts()
    local msg = {username=GAME_CENTER_ID}

    --msg = json.encode(msg, { indent = true })
    --print("msg2:"..msg)
    self.app_.httpClient:sendJsonMessage(GAME_OP_CODES.PRODUCT,msg)
end
function ProductManager:getProducts()
    return self.products
end
 
function ProductManager:onProductsReceived(event)
  
    --self.products = {}
--    local obj, pos, err = json.decode (event.data, 1, nil)
--    if err then
--        print ("Error:", err)
--    else
--        print ("count:", #obj)
--        self.products = obj
--    end
    self.products = event.data
    for i=1,#self.listeners  do
        self.listeners[i]:onReceived()
    end
end
function ProductManager:dispatch(event)
    print("ProductManager:dispatch op_code:"..event.op_code .." data len:"..#event.data)
    if tonumber(event.op_code) == GAME_OP_CODES.PRODUCT  then
        self:onProductsReceived(event)
        return true
    end   
    return false
end 
return ProductManager
