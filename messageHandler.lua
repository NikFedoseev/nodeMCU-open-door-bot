local commands = {}
commands["/on"] = function () gpio.write(ledPin, 0) end
commands["/off"] = function () gpio.write(ledPin, 1) end
commands["/open"] = function (chatId) openDoor(chatId) end

function openDoor(chatId)
    local openTimer = tmr.create() 
    gpio.write(ledPin, 0)
    sendMessage(chatId)
    openTimer:register(1000, tmr.ALARM_SINGLE, function(t) gpio.write(ledPin, 1); t:unregister() end)
    openTimer:start()
end

function mysplit(inputstr, sep)
    if sep == nil then
      sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      table.insert(t, str)
    end
    return t
end

function sendMessage(chatId)
    print('{"chatId":"'..chatId..'"}')
    http.post('http://178021.simplecloud.ru/sendMessage',
      'Content-Type: application/json\r\n',
      '{"chatId":"'..chatId..'"}'
   )
end
    

function makeRequest() 
    http.post('http://178021.simplecloud.ru/getUpdates',
      'Content-Type: application/json\r\n',
      '{}',
      function(code, data)
        if (code < 0) then
          print("HTTP request failed")  
        else
          print(code, data)
          local table = mysplit(data)
          if(table[1] ~= "no" and commands[table[1]] ~= nil) 
            then
                commands[table[1]](table[2]) 
            end
        end
      end)
end

local mytimer = tmr.create()
mytimer:register(5000, tmr.ALARM_SEMI, function() makeRequest(); mytimer:start(); end)
mytimer:start()