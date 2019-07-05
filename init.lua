print('start')
local cfg = {}
cfg.ssid="OnpointW"
cfg.pwd="onpoint0808"
cfg.save=false

wifi.setmode(wifi.STATION)
wifi.sta.config(cfg)

print(wifi.sta.getip())

ledPin = 0
gpio.mode(ledPin,gpio.OUTPUT)
gpio.write(ledPin, 1)

dofile("messageHandler.lua")
