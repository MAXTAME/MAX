--[[
BY : MAXTIME
Channel Files : https://t.me/MAXFiles
]]
local function keko_MAX(data)
local msg = data.message_
redis = (loadfile "./libs/redis.lua")()
database = Redis.connect('127.0.0.1', 6379)
sudos = dofile('sudo.lua')
https = require("ssl.https")
bot_id_keko = {string.match(token, "^(%d+)(:)(.*)")}
bot_id = tonumber(bot_id_keko[1])
JSON = (loadfile  "./libs/dkjson.lua")()
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
  function is_owner(msg)
user_id = msg.sender_user_id_
chat_id = msg.chat_id_
local var = false
local admin = database:sismember('MAX:'..bot_id..'admins:', user_id)  
local owner = database:sismember('MAX:'..bot_id..'owners:'..chat_id, user_id)
local creator = database:sismember('MAX:'..bot_id..'creator:'..chat_id, user_id)  
if owner then var = true
end if admin then
var = true end if creator then var = true end
for k,v in pairs(sudo_users) do
if user_id == v then
var = true
end end
local keko_add_sudo = redis:get('MAX:'..bot_id..'sudoo'..user_id..'')
if keko_add_sudo then var = true end
return var
end
local msg = data.message_
text = msg.content_.text_
if text == 'بوت' and database:get('MAX:'..bot_id..'lock_geam'..msg.chat_id_) then
database:del('MAX:'..bot_id..'l:ids'..msg.chat_id_)
katu = {'نعم','اشتغل'}
name = katu[math.random(#katu)]
database:set('MAX:'..bot_id..'klmos'..msg.chat_id_,name) string.gsub(name,'اشتغل','اشتغل')
name = string.gsub(name,'نعم','نعم')
end
end

if  (text and text == 'تفعيل ردود') and is_owner(msg) then
if not database:get('MAX:'..bot_id..'rep:mute'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '☑┇ردود البوت بالفعل تم تفعيلها', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇تم تفعيل ردود البوت', 1, 'md')
database:del('MAX:'..bot_id..'rep:mute'..msg.chat_id_) 
end
end
if(text and text == 'تعطيل ردود') and is_owner(msg) then
if database:get('MAX:'..bot_id..'rep:mute'..msg.chat_id_) then
send(msg.chat_id_, msg.id_, 1, '☑┇ردود البوت بالفعل تم تعطيلها', 1, 'md')
else
send(msg.chat_id_, msg.id_, 1, '☑┇تم تعطيل ردود البوت', 1, 'md')
database:set('MAX:'..bot_id..'rep:mute'..msg.chat_id_,true)
end
end

end
return {
	keko_MAX = keko_MAX,
}
--[[
BY : MAXTEAM
Channel Files : https://t.me/MAXFiles
]]
