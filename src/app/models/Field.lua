local BTCommon = import("..common.BTCommon")

local Field = class("Field")
function Field:ctor()
    self.w = 0
    self.h = 0
    self.offset = {x = 250, y = 350}
    --self.offset = {x = 100, y = 100}
    self:init()
end
function Field:setOffset(offset)
    
	self.offset = offset
end
function Field:init()
        self.w = BTCommon.rules.playfield_width
        self.h = BTCommon.rules.playfield_height
        for y = 1, self.h+5 do
            self[y] = {}
            for x = 1, self.w do
                self[y][x] = 0
            end
        end
end

--function quicksort(arr,left,right)
--     if left < right then 
--       local key = arr[left]  
--       local low = left 
--       local high = right  
--       while (low < high) do
--            while (low< high) and (arr[high] > key) do 
--                   high = high - 1  
--            end 
--            arr[low] = arr[high] 
--            while (low<high) and (arr[low] < key) do 
--                   low = low + 1  
--            end
--            arr[high] = arr[low]
--        end
--        arr[low]=key
--        quicksort(arr,left,low-1)
--        quicksort(arr,low+1,right)
--      end 
--end
return Field