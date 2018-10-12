sudo_MAX = dofile("sudo.lua")
https = require("ssl.https")
JSON = dofile("./libs/JSON.lua")
local MAX_dev = io.open("MAX_online.lua")
if MAX_dev then
MAX_on = {string.match(MAX_dev:read('*all'), "^(.*)/(%d+)")}
local MAX_file = io.open("sudo.lua", 'w')
MAX_file:write("token = '" ..MAX_on[1].."'\n\nsudo_add = "..MAX_on[2].."" )
MAX_file:close()
https.request("https://api.telegram.org/bot"..MAX_on[1].."/sendMessage?chat_id="..MAX_on[2].."&text=Bot_MAX_is_start_new")
os.execute('cd .. && rm -rf .telegram-cli')
os.execute('rm -rf MAX_online.lua')  
os.execute('./tg -s ./Max.lua $@ --bot='..MAX_on[1])
end
function chack(tokenCk)
local getme = "https://api.telegram.org/bot" ..tokenCk.. '/getme'
local req = https.request(getme)
local data = JSON:decode(req)
if data.ok == true then
print("\27[31m✓ تم تحقق من التوكن\27[m \27[1;34m»»ارسل ايدي المبرمج الاساسي««\27[m")
local sudo_send  = io.read()
print("\27[31m✓ تم التحقق من الايدي\27[m")
local MAX_file = io.open("sudo.lua", 'w')
MAX_file:write("token = '" ..tokenCk.."'\n\nsudo_add = "..sudo_send.."" )
MAX_file:close()
os.execute('cd .. && rm -fr .telegram-cli')
os.execute('cd && rm -fr .telegram-cli')
os.execute('./tg -s ./MAX.lua $@ --bot='..tokenCk)
else
print("\27[31m»»التوكن غير صحيح , اعد ارسال التوكن««\27[m")
local token_send = io.read()
chack(token_send)
end
end
os.execute('cd .. && rm -rf .telegram-cli')
if token and token == "TOKEN" then 
print("\27[1;34m»»ارسل توكن البوت««\27[m")
local token_send = io.read()
chack(token_send)
else 
os.execute('cd .. && rm -fr .telegram-cli')
os.execute('cd && rm -fr .telegram-cli')
sudo_MAX = dofile("sudo.lua")
local getme = "https://api.telegram.org/bot" ..token.. '/getme'
local req = https.request(getme)
local data = JSON:decode(req)
if data.ok == true then
os.execute('./tg -s ./MAX.lua $@ --bot='..token)
else
print("\27[31mالتوكن غير صيح , اعد ارسال التوكن««\27[m")
local token_send = io.read()
chack(token_send)
end
end
