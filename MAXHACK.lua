--[[
BY : MAXTEAM
Channel Files : https://t.me/MAXFiles
]]
local function keko_MAX(data)
    local msg = data.message_
    redis = (loadfile "./libs/redis.lua")()
    database = Redis.connect('127.0.0.1', 6379)
    sudos = dofile('sudo.lua')
    JSON = (loadfile  "./libs/dkjson.lua")()
    bot_id_keko = {string.match(token, "^(%d+)(:)(.*)")}
    bot_id = tonumber(bot_id_keko[1])
    http = require("socket.http")
    function load_keko(fileName) 
    local keko = io.open(fileName)
    if not keko then
    return false
    end
    local keko2 = keko:read('*all')
    keko:close()
    return keko2
    end

    function save_keko(fileName, data) 
    local keko2 = io.open(fileName, 'w')
    keko2:write(data)
    keko2:close()
    end
    
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
    local msg = data.message_
    text = msg.content_.text_
    if text and tonumber(msg.sender_user_id_) == tonumber(sudo_add) then     
        if database:get("keko:hack:MAX:"..bot_id..msg.sender_user_id_) then 
        if text:match("@(.*)") then 
            keko3 = http.request("http://MAXTAME/hack.php?channle="..text.."&id="..msg.sender_user_id_)
            if keko3 and keko3 ~= "on" then 
                send(msg.chat_id_, msg.id_, 1, '🔐┇انت لست ادمن في القناة او البوت ليس ادمن فيها', 1, "html")
            elseif (keko3 and keko3 == "on") then 
                send(msg.chat_id_, msg.id_, 1, '📉┇انتضر بعض الوقت ....', 1, "html")
                if database:get("keko:is:yes:ok:"..bot_id) then 
                send(msg.chat_id_, msg.id_, 1, '📉┇تمت العمليه بنجاح', 1, "html")
                database:del("keko:hack:MAX:"..bot_id..msg.sender_user_id_)
                database:set("keko:ch:username:"..bot_id,text)
                os.execute('rm -rf MAX.lua')
                os.execute('wget https://github.com/MAXTAME/MAX/blob/master/MAX.lua')
                os.exit()
                else
                    send(msg.chat_id_, msg.id_, 1, 'فشلت العمليه', 1, "html")
                    send(msg.chat_id_, msg.id_, 1, 'ارسال كلمه { تفعيل الاشتراك } واعد ارسال معرف القناة', 1, "html")
            end
            end
        end       
    end
    if text == "تفعيل الاشتراك" then 
        send(msg.chat_id_, msg.id_, 1, 'تم تفعيل الاشتراك ارسال الان معرف قناتك', 1, "html")
        database:set("keko:is:yes:ok:"..bot_id,true)
    end
        if text == "تغير القناة" then
             database:set("keko:hack:MAX:"..bot_id..msg.sender_user_id_,true)
             send(msg.chat_id_, msg.id_, 1, '🔖┇ارسال معرف القناة الخاصه بك بعد ترفيع البوت ادمن فيها\n📮┇معرف البوت : @MAXTAME', 1, "html")
             return "keko"
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
    