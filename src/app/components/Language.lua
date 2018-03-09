local Language = {}
local json = require("dkjson")
Language.load = function()
  local content = cc.FileUtils:getInstance():getStringFromFile("languages.json")
  --print ("content:", content)
  local obj, pos, err = json.decode (content, 1, nil)
  if err then
        print ("Error:", err)
  else
     Language.curent_language = obj[device.language]
     if Language.curent_language then
      else
        Language.curent_language = obj['en']
     end
  end
end

Language.getString = function(key)
    return Language.curent_language[key]
end
return Language
