--[[
BY : MAXTAME
Channel Files : https://t.me/MAXFiles
]]
local function keko_MAX(data)
    local msg = data.message_
    redis = (loadfile "./libs/redis.lua")()
    database = Redis.connect('127.0.0.1', 6379)
    sudos = dofile('sudo.lua')
    HTTPS = require("ssl.https")
    JSON = (loadfile  "./libs/dkjson.lua")()
    bot_id_keko = {string.match(token, "^(%d+)(:)(.*)")}
bot_id = tonumber(bot_id_keko[1])
    msg = data.message_
    text = msg.content_.text_
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
    function is_sudo(msg)
local var = false
for k,v in pairs(sudo_users) do
if msg.sender_user_id_ == v then var = true end
end
local keko_add_sudo = redis:get('MAX:'..bot_id..'sudoo'..msg.sender_user_id_..'')
if keko_add_sudo then var = true end return var
end
    if (text and text == 'تفعيل' and  is_sudo(msg)) then 
    if not database:get('MAX:'..bot_id.."charge:"..msg.chat_id_) then 
    if not database:get('MAX:'..bot_id..'akeko:sudo'..bot_id..msg.sender_user_id_..msg.chat_id_) then 
    database:incrby('MAX:'..bot_id..'keko:sudo'..bot_id..msg.sender_user_id_, 1)
    database:set('MAX:'..bot_id..'akeko:sudo'..bot_id..msg.sender_user_id_..msg.chat_id_, "keko")
    end  
    end
    end
  
    if (text and text == 'تعطيل' and  is_sudo(msg)) then 
    if database:get('MAX:'..bot_id.."charge:"..msg.chat_id_) then 
    if not database:get('MAX:'..bot_id..'aakeko:sudo'..bot_id..msg.sender_user_id_..msg.chat_id_) then 
    database:incrby('MAX:'..bot_id..'keko:sudo2'..bot_id..msg.sender_user_id_, 1)
    database:set('MAX:'..bot_id..'aakeko:sudo'..bot_id..msg.sender_user_id_..msg.chat_id_, "keko")
    end  
    end
    end
   
    if text then 
    if (text == 'احصائيات المبرمجين' and tonumber(msg.sender_user_id_) == tonumber(sudo_add) )then 
    local user_info = database:hgetall('MAX:'..bot_id..'user:'..sudo_add)
    local username = nil
    if user_info and user_info.username then
    username = "@"..user_info.username
    end
    local sudo_keko = redis:smembers('MAX:'..bot_id..'dev')
    local keko = "💬┇احصائيات المبرمجين : \n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉\n\n"
    local keko2 = database:get('MAX:'..bot_id..'keko:sudo'..bot_id..sudo_add)
    local keko3 = database:get('MAX:'..bot_id..'keko:sudo2'..bot_id..sudo_add)
    keko = keko.."👤┇المطور الاساسي\n|0| ["..(username or sudo_add)..'] \n  مفعل ~⪼ *{'..(keko2 or 0)..'}* | معطل  ~⪼ *{'..(keko3 or 0)..'}*\n┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉\n👤┇المبرمجين\n'
    for i=1,#sudo_keko do
    if tonumber(sudo_keko[i]) ~= tonumber(sudo_add) then
    local user_info = database:hgetall('MAX:'..bot_id..'user:'..sudo_keko[i])
    local username = nil
    if user_info and user_info.username then
    username = "@"..user_info.username
    end
    local keko2 = database:get('MAX:'..bot_id..'keko:sudo'..bot_id..sudo_keko[i])
    local keko3 = database:get('MAX:'..bot_id..'keko:sudo2'..bot_id..sudo_keko[i])
    keko = keko.."|"..i.."| ["..(username or sudo_keko[i])..'] \n  مفعل ~⪼ *{'..(keko2 or 0)..'}* | معطل  ~⪼ *{'..(keko3 or 0)..'}*\n'
    end
    end
    if #sudo_keko == 0 or #sudo_keko == 1 and tonumber(sudo_keko[i]) == tonumber(sudo_add) then
    keko = keko.."\n ⚠️┇لا يوجد مطورين"
    end
    if #sudo_keko == 1 and tonumber(sudo_keko[1]) == tonumber(sudo_add) then
    keko = keko.."\n ⚠️┇لا يوجد مطورين"
    end
    send(msg.chat_id_, msg.id_, 1, keko, 1, 'md')
    end
    end
    
    end
    return {
        keko_MAX = keko_MAX,
    }
    --[[
    BY : MAXTAME
    Channel Files : https://t.me/MAXFiles
    ]]
    