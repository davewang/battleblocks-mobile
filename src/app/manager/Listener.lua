local Listener = class("Listener")
function Listener:ctor()
    self.listeners = {}
end

function Listener:addListener(obj)
    for i=1,#self.listeners  do
        if self.listeners[i]==obj then
            return
        end
    end
    self.listeners[#self.listeners+1] = obj
end
function Listener:removeListener(obj)
    for i=1,#self.listeners  do
        if self.listeners[i]==obj then
            table.remove(self.listeners,i)
            break
        end
    end
end
return Listener