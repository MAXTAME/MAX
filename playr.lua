--[[
BY : MAXTAME
Channel Files : https://t.me/MAXFILE
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
if not database:get('MAX:'..bot_id..'rep:mute'..msg.chat_id_) then
if text == 'الالعاب' then
moody = "• مرحبا بك في قائمه الالعاب لعبه السمايلات اكتب لعب ليتم بدئ اللعب🏁ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end

if text == 'العب' then
moody = "• ما هو السمايل المختلف
☺️☺️☺️☺️☺️😊☺️☺️☺️☺️☺️ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😊' then
moody = "• الاجابه صحيحه اكتب س2 حتى تستمرֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س2' then
moody = "• ما هو السمايل المختلف
🙃🙃🙃🙃🙃🙂🙃🙃🙃🙃🙃ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🙂' then
moody = "• الاجابه صحيحه اكتب س3 حتى تستمر ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س3' then
moody = "• ما هو السمايل المختلف 
😰😰😰😰😰😨😰😰😰😰😰ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😨' then
moody = "• الاجابه صحيحه اكتب س4 حتى نستمر ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س4' then
moody = "• ماهو السمايل المختلف
😐😐😐😐😐😑😐😐😐😐ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😑' then
moody = "• الاجابه صحيحه اكتب س5 حتى تستمر ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س5' then
moody = "• ماهو السمايل المختلف
😮😮😮😮😮😲😮😮😮😮😮ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😲' then
moody = "• مبروك ربحت المستوى الاول سننتقل للمستوى الثاني🏃🏼‍♂️🏁ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😲' then
moody = "• الاجابه صحيحه اكتب س6 حتى تستمرֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س6' then
moody = "• ماهو السمايل المختلف
😡😡😡😡😡🤬😡😡😡😡ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🤬' then
moody = "• الاجابه صحيحه اكتب س7 حتى تستمرֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س7' then
moody = "• ماهو السمايل المختلف
😈😈😈😈😈👿😈😈😈😈ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '👿' then
moody = "• الاجابه صحيحه اكتب س8 حتى تستمر ֆ"
send(msg.chat_id_, msg.id_, 1,
, 'md')
end
if text == 'س8' then
moody = "• ما هو السمايل المختلف
😸😸😸😸😸😺😸😸😸😸😸ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😺' then
moody = "• الاجابه صحيحه اكتب س9  حتى تستمر ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س9' then
moody = "• ماهو السمايل المختلف
👨‍✈️👨‍✈️👨‍✈️👨‍✈️👨‍✈️👩‍✈️👨‍✈️👨‍✈️👨‍✈️👨‍✈️👨‍✈️ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '👩‍✈️' then
moody = "• الاجابه صحيحه اكتب س10 حتى تستمرֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س10' then
moody = "• ما هو السمايل المختلف
🚶🏼‍♂️🚶🏼‍♂️🚶🏼‍♂️🚶🏼‍♂️🚶🏼‍♂️🚶🏻‍♀️🚶🏼‍♂️🚶🏼‍♂️🚶🏼‍♂️🚶🏼‍♂️🚶🏼‍♂️ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🚶🏻‍♀️' then
moody = "• مبروك ربحت المستوى الثاني سننتقل للمستوى الثالث🏃🏼‍♂️🏁 ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🚶🏻‍♀️' then
moody = "• الاجابه صحيحه اكتب س11 حتى تستمرֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س11' then
moody = "• ما هو السمايل المختلف
🙊🙊🙊🙊🙊🐵🙊🙊🙊🙊🙊ֆ "
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🐵' then
moody = "• الاجابه صحيحه اكتب س12 حتى تستمر ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س12' then
moody = "• ما هو السمايل المختلف
🌲🌲🌲🌲🌲🎄🌲🌲🌲🌲🌲ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🎄' then
moody = "• الاجابه صحيحه اكتب س13 حتى تستمر ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س13' then
moody = "• ما هو السمايل المختلف 
🍀🍀🍀🍀🍀☘️🍀🍀🍀🍀🍀ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '☘️' then
moody = "• الاجابه صحيحه اكتب س14 حتى تستمر بالعبֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س14' then
moody = "• ماهو السمايل المختلف
🌟🌟🌟🌟🌟⭐️🌟🌟🌟🌟ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '⭐️' then
moody = "• الاجابه صحيحه اكتب س15 حتى تستمر ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س15' then
moody = "• ماهو السمايل المختلف
📀📀📀📀📀💿📀📀📀📀📀ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '💿' then
moody = "• مبروك ربحت المستوى الثالث سننتقل للمستوى الرابع🏃🏼‍♂️🏁ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '💿' then
moody = "• الاجابه صحيحه اكتب س16 حتى تستمرֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س16' then
moody = "• ما هو السمايل المختلف 
🔨🔨🔨🔨🔨⛏🔨🔨🔨🔨🔨ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '⛏' then
moody = "• الاجابه صحيحه اكتب س17 حتى تستمر ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س17' then
moody = "• ما هو السمايل المختلف 
📥📥📥📥📥📤📥📥📥📥📥ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '📤' then
moody = "• الاجابه صحيحه اكتب س18 حتى تستمرֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س18' then
moody = "• ما هو السمايل المختلف
📁📁📁📁📁📂📁📁📁📁📁ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '📂' then
moody = "• الاجابه صحيحه اكتب س19
ختى تستمر ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س19' then
moody = "• ما هو السمايل المختلف
🔒🔒🔒🔒🔒🔓🔒🔒🔒🔒🔒ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🔓' then
moody = "• الاجابه صحيحه اكتب س20 حتى تربح باللعبهֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س20' then
moody = "• ما هو السمايل المختلف
🔉🔉🔉🔉🔉🔈🔉🔉🔉🔉🔉ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🔈' then
moody = "• لقد ربحت في اللعبه مبروك الفوز انتضر جديدنا @MAXTAME"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end

end
if  (text and text == 'تفعيل الالعاب') and is_owner(msg) then
    if not database:get('MAX:'..bot_id..'rep:mute'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '☑┇الالعاب بالفعل تم تفعيلها', 1, 'md')
    else
  send(msg.chat_id_, msg.id_, 1, '☑┇تم تفعيل الالعاب', 1, 'md')
   database:del('MAX:'..bot_id..'rep:mute'..msg.chat_id_)
  end
  end
  if(text and text == 'تعطيل الالعاب') and is_owner(msg) then
    if database:get('MAX:'..bot_id..'rep:mute'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '☑┇الالعاب بالفعل تم تعطيلها', 1, 'md')
  else
  send(msg.chat_id_, msg.id_, 1, '☑┇تم تعطيل الالعاب', 1, 'md')
    database:set('MAX:'..bot_id..'rep:mute'..msg.chat_id_,true)
  end
    end

end
return {
 keko_MAX = keko_MAX,
}
--[[
BY : @MAXTAME
Channel Files : https://t.me/MAXFILE
]]
