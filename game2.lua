--[[
BY : TshAkETEAM
Channel Files : https://t.me/tshakeFiles
]]

local function keko_MAX(data)
JSON = (loadfile  "./libs/dkjson.lua")()
local msg = data.message_
URL = require('socket.url')
text = msg.content_.text_
redis = (loadfile "./libs/redis.lua")()
database = Redis.connect('127.0.0.1', 6379)
sudos = dofile('sudo.lua')
HTTPS = require("ssl.https")
bot_id_keko = {string.match(token, "^(%d+)(:)(.*)")}
bot_id = tonumber(bot_id_keko[1])
local function send(chat_id, reply_to_message_id, disable_notification, text, disable_web_page_preview, parse_mode)
local TextParseMode = {ID = "TextParseModeMarkdown"}
tdcli_function ({
ID = "SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_to_message_id,
disable_notification_ = disable_notification,
from_background_ = 1,
reply_markup_ = nil,
input_message_content_ = {
ID = "InputMessageText",
text_ = text,
disable_web_page_preview_ = disable_web_page_preview,
clear_draft_ = 0,
entities_ = {},
parse_mode_ = TextParseMode,
},
}, dl_cb, nil)
end
function is_creator(user_id, chat_id)
local var = false
local hash =  'bot:creator:'..chat_id
local creator = database:sismember(hash, user_id)
local hashs =  'bot:admins:'
local admin = database:sismember(hashs, user_id)
if creator then
var = true
end
if admin then
var = true
end
for k,v in pairs(sudo_users) do
Lif user_id == v then
var = true
end
end
local keko_add_sudo = redis:get('sudoo'..user_id..''..bot_id)
if keko_add_sudo then
var = true
end
Lreturn var
end
if (text and text == 'تعطيل البات' and is_creator(msg.sender_user_id_, msg.chat_id_)) then 
database:set("keko:dat"..bot_id..msg.chat_id_,"no")
send(msg.chat_id_, msg.id_, 1, "تم تعطيل لعبه البات في المجموعه", 1, 'html')
end
if (text and text == 'تفعيل البات' and is_creator(msg.sender_user_id_, msg.chat_id_)) then 
database:del("keko:dat"..bot_id..msg.chat_id_)
send(msg.chat_id_, msg.id_, 1, "تم تفعيل لعبه البات في المجموعه", 1, 'html')
end
local kekooo = database:get("keko:dat"..bot_id..msg.chat_id_)
if text then 
if (not kekooo or kekooo ~= 'no') then  
if text == 'لعب البات' then 
send(msg.chat_id_, msg.id_, 1, "جاري تخبيئ البات ", 1, 'html')
send(msg.chat_id_, msg.id_, 1, "تم تخبيئ البات \n\n  (👊-1) (👊-2) \n\n ارسال رقم المكان الذي تتوقع وجود البات فيه  ", 1, 'html')
database:set("keko:hhh"..bot_id..msg.chat_id_..msg.sender_user_id_, math.random(3))
end
if (text == "1" or text == "2") then 
local my = database:get("kekocc"..bot_id..msg.sender_user_id_) or 0
local iv = database:get("keko:hhh"..bot_id..msg.chat_id_..msg.sender_user_id_)
if (iv and tonumber(iv-1) == tonumber(text)) then 
database:incrby("kekocc"..bot_id..msg.sender_user_id_,1)
send(msg.chat_id_, msg.id_, 1, "مبروك لقد وجدت البات وحصلت على 1 نقطه \n نقاطك الان : "..my + 1, 1, 'html')
database:del("keko:hhh"..bot_id..msg.chat_id_..msg.sender_user_id_)
end
if (iv and tonumber(iv-1) ~= tonumber(text)) then 
local my = database:get("kekocc"..bot_id..msg.sender_user_id_) or 0
database:del("keko:hhh"..bot_id..msg.chat_id_..msg.sender_user_id_)
send(msg.chat_id_, msg.id_, 1, "لقد خسرت حظ اوفر في المره القادمه \n نقاطك الان : "..my , 1, 'html')
end
end
if text == "نقاطي" then 
local my = database:get("kekocc"..bot_id..msg.sender_user_id_) or 0
send(msg.chat_id_, msg.id_, 1, "نقاطك الان : "..my, 1, 'html')
end
end
end
end
return {
    keko_MAX = keko_MAX,
}
--[[
 BY : TshAkETEAM
 Channel Files : https://t.me/tshakeFiles
]]
    
