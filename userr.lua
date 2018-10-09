--[[
BY : TshAkETEAM
Channel Files : https://t.me/tshakeFiles
]]
local function keko_tshake(data)
local msg = data.message_
redis = (loadfile "./libs/redis.lua")()
database = Redis.connect('127.0.0.1', 6379)
sudos = dofile('sudo.lua')
HTTPS = require("ssl.https")
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
  function getname(name_id, cb)
    tdcli_function ({
  ID = "GetName",
  name_id = name_id
    }, cb, nil)
  end
local msg = data.message_
text = msg.content_.text_
if text then 
function keko(extra,result,success)
if result.id_ then 
local keko2 = database:get("keko:Name"..result.id_)
if not result.name_ then 
if keko2 then 
send(msg.chat_id_, msg.id_, 1, "حذف معرفه خمطو بساع بساع  \n هاذه معرفه : @"..keko2, 1, 'html')
database:del("keko:name"..result.id_) 
end
end
if result.name then 
if keko2 and keko2 ~= result.name then 
local keko_text = {
  'شكو غيرت معرفك شنو نشروك بقنوات نحراف 🌞😹😹😹',
  "هاها شو غيرت معرفك بس لا هددوك 🤞😂😂",
  "شسالفه شو غيرت معرفك 😐🌝",
  "غير معرفه خمطو بساع بساع \n هاذه معرفه : @"..result.name_.."",
  'ها عار مو جان معرفك \n شكو غيرته ل @'..result.name_..' ',
  'ها يول شو مغير معرفك', 
  "منور معرف جديد : "..result.name_.."",
}
keko3 = math.random(#keko_text)
send(msg.chat_id_, msg.id_, 1, keko_text[keko3], 1, 'html')
end  
database:set("keko:Name"..result.id_, result.name_) 
end
end
end
getName(msg.sender_name_id_, keko)
end
end
return {
	keko_tshake = keko_tshake,
}
--[[
BY : TshAkETEAM
Channel Files : https://t.me/tshakeFiles
]]
