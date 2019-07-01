print('start')
local cfg = {}
cfg.ssid="****"
cfg.pwd="***********"
cfg.save=false

ledPin = 4
gpio.mode(ledPin,gpio.OUTPUT)
gpio.write(ledPin, 1)
wifi.setmode(wifi.STATION)
wifi.sta.config(cfg)

print(wifi.sta.getip())

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
          if (table[1] == "/ledon") then
            gpio.write(ledPin, 0)
          elseif (table[1] == "/ledoff") then 
            print(table[1])
            gpio.write(ledPin, 1)
          end
        end
      end)
end

local mytimer = tmr.create()
mytimer:register(5000, tmr.ALARM_SEMI, function() makeRequest(); mytimer:start() end)
mytimer:start()