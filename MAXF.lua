--[[
BY : MAXTAME
Channel Files : https://t.me/MAXFILE
]]
local function keko_MAX(data)
    JSON = (loadfile  "./libs/dkjson.lua")()
    local msg = data.message_
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
function is_mod(msg)
user_id = msg.sender_user_id_
chat_id = msg.chat_id_
local var = false
local mod = database:sismember('MAX:'..bot_id..'mods:'..chat_id, user_id)  
local admin = database:sismember('MAX:'..bot_id..'admins:', user_id)  
local owner = database:sismember('MAX:'..bot_id..'owners:'..chat_id, user_id)
local creator = database:sismember('MAX:'..bot_id..'creator:'..chat_id, user_id)  
if mod then var = true end
if owner then var = true end
if creator then var = true end
if admin then var = true end
for k,v in pairs(sudo_users) do
if user_id == v then var = true end end
local keko_add_sudo = redis:get('MAX:'..bot_id..'sudoo'..user_id..'')
if keko_add_sudo then var = true end
return var
end
if (text and text == 'قفل الفارسيه' and is_mod(msg)) then 
send(msg.chat_id_, msg.id_, 1,"☑️┇تم قفل الفارسيه", 1, 'html')
database:set("keko:bantext"..bot_id..msg.chat_id_,"keko")
end
if (text and text == 'فتح الفارسيه' and is_mod(msg)) then
send(msg.chat_id_, msg.id_, 1,"☑️┇تم فتح الفارسيه",1, 'html')
database:del("keko:bantext"..bot_id..msg.chat_id_)
end
local ikeko = database:get("keko:bantext"..bot_id..msg.chat_id_)
if (ikeko and ikeko == 'keko') then
if (not is_mod(msg) and text) then 
local keko = { -- the List By : t.me/r_rrt
        '۶۵',
        '۴۵',
        '۶۴', -- the List By : t.me/r_rrt
        '۶۳',
        'مک',
        'زدن',
        'سکس',
        'xxnx',
        'XXNX',
        'xxxn',
        'سکسی',
        'کسی',
        'دخترا',
        'دیوث',
        'کلیپشن',
        'خوششون',
        'میدا',
        'های',
        'که',
        'بدانیم',
        'باید',
        'عرب',
        'از',
        'زناشویی',
        'رابطه',
        'آموزش',
        'زنا',
        'شویی',
        'اپ',
        'بالا',
        'کن',
        'گن',
        'نیک',
        'زوکن',
        'آیت', -- the List By : t.me/r_rrt
        'صوتی',
        'دانلودریگان',
        'با',
        'گپی',
        'بسیارزیبا',
        'هر',
        'روز',
        '۵۰۰',
        'خونه',
        'فیلم',
        'ایرونی',
        'کصمو',
        'داغه',
        '18+',
        '۱۸+',
        'میخوی',
        'ایرانی',
        'XXX',
        'كيرى',
        'كيرى كن امك',
        'پ',
        'اینچا',
        'بی ناموس',
        'کسکش',
        'كير خوار',
        'كسليس',
        'ننه گوزو',
        'ننه كسكش',
        'بی پدر',
        'پدر کونی',
        'كسننه',
        'جنده',
        'مادره جنده',
        'بي ناموس',
        'بي شرف',
        'كسننت',
        'بي پدر ومادر',
        'خواهر جنده',
        'ننه كونى',
        'پسر کونی',
        'کیرم تو مادرت',
        'کیرم تو خانوادت',-- the List By : t.me/r_rrt
        'پدر سگ',
        'پدر کونی',
        'خواهرت گاییدم',
        'مادرت گاییدم'
} -- the List By : t.me/r_rrt
function delete_msg(chatid,mid)
    tdcli_function ({
    ID="DeleteMessages",
    chat_id_=chatid,
    message_ids_=mid
    },
    dl_cb, nil)
end
for i,v in ipairs(keko) do
if text:match("^()("..v..")(.*)$") then 
delete_msg(msg.chat_id_,{[0] = msg.id_})
end
end
end
end
end
    return {
        keko_MAX = keko_MAX,
    }
    --[[
    BY : MAXTAME
    Channel Files : https://t.me/MAXFILE
    ]]
    
