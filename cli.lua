 storevpsnet / SVcli
Code  Issues 0  Pull requests 0  Projects 0  Wiki  Pulse
cli.lua

-- developer unknown :D
serpent = require("serpent")
lgi = require('lgi')
redis = require('redis')
db = Redis.connect('127.0.0.1', 6379)
notify = lgi.require('Notify')
notify.init ("Telegram updates")
chats = {}
day = 86400
bot_id = 325211669 -- [[ضع معرفًا لحساب البوت]]
sudo_users = {107821693, 259019897} -- [[ضع الهداف]] + [[مدير البوت]]
bot_owner = {107821693} -- [[ موقع المعرف الأصلي للبوت ]]
-----------------------------------------------------------------------------------------------
---------------
-- Start Functions --
---------------
-----------------------------------------------------------------------------------------------
-----------Bot Owner-------------
function is_leader(msg)
  local var = false
  for k,v in pairs(bot_owner) do
    if msg.sender_user_id_ == v then
      var = true
    end
  end
  return var
end
--------------Sudo----------------
function is_sudo(msg)
  local var = false
  for k,v in pairs(sudo_users) do
    if msg.sender_user_id_ == v then
      var = true
    end
  end
  return var
end
---------------Admin-----------------
function is_admin(user_id)
  local var = false
  local hashsb =  'bot:admins:'
  local admin = db:sismember(hashsb, user_id)
  if admin then
    var = true
  end
  for k,v in pairs(sudo_users) do
    if user_id == v then
      var = true
    end
  end
  return var
end
---------------VIP--------------------
function is_vip_group(gp_id)
  local var = false
  local hashs =  'bot:vipgp:'
  local vip = db:sismember(hashs, gp_id)
  if vip then
    var = true
  end
  return var
end
---------------Owner-------------------
function is_owner(user_id, chat_id)
  local var = false
  local hash =  'bot:owners:'..chat_id
  local owner = db:sismember(hash, user_id)
  local hashs =  'bot:admins:'
  local admin = db:sismember(hashs, user_id)
  if owner then
    var = true
  end
  if admin then
    var = true
  end
  for k,v in pairs(sudo_users) do
    if user_id == v then
      var = true
    end
  end
  return var
end
------------------Mod-------------------
function is_mod(user_id, chat_id)
  local var = false
  local hash =  'bot:mods:'..chat_id
  local mod = db:sismember(hash, user_id)
  local hashs =  'bot:admins:'
  local admin = db:sismember(hashs, user_id)
  local hashss =  'bot:owners:'..chat_id
  local owner = db:sismember(hashss, user_id)
  if mod then
    var = true
  end
  if owner then
    var = true
  end
  if admin then
    var = true
  end
  for k,v in pairs(sudo_users) do
    if user_id == v then
      var = true
    end
  end
  return var
end
-------------------Banned---------------------
function is_banned(user_id, chat_id)
  local var = false
  local hash = 'bot:banned:'..chat_id
  local banned = db:sismember(hash, user_id)
  if banned then
    var = true
  end
  return var
end
------------------Muted----------------------
function is_muted(user_id, chat_id)
  local var = false
  local hash = 'bot:muted:'..chat_id
  local banned = db:sismember(hash, user_id)
  if banned then
    var = true
  end
  return var
end
--------------------GBan-------------------------
function is_gbanned(user_id)
  local var = false
  local hash = 'bot:gbanned:'
  local banned = db:sismember(hash, user_id)
  if banned then
    var = true
  end
  return var
end
--------------------Filter Word-------------------
local function check_filter_words(msg, value)
  local hash = 'bot:filters:'..msg.chat_id_
  if hash then
    local names = db:hkeys(hash)
    local text = ''
    for i=1, #names do
      if string.match(value:lower(), names[i]:lower()) and not is_mod(msg.sender_user_id_, msg.chat_id_)then
        local id = msg.id_
        local msgs = {[0] = id}
        local chat = msg.chat_id_
        delete_msg(chat,msgs)
      end
    end
  end
end
-----------------------------------------------------------------------------------------------
function resolve_username(username,cb)
  tdcli_function ({
    ID = "SearchPublicChat",
    username_ = username
  }, cb, nil)
end
-----------------------------------------------------------------------------------------------
local function deleteMessages(chat_id, message_ids)
  tdcli_function ({
    ID = "DeleteMessages",
    chat_id_ = chat_id,
    message_ids_ = message_ids -- vector
  }, dl_cb, nil)
end
-------------------------------------------------------------
function changeChatMemberStatus(chat_id, user_id, status)
  tdcli_function ({
    ID = "ChangeChatMemberStatus",
    chat_id_ = chat_id,
    user_id_ = user_id,
    status_ = {
      ID = "ChatMemberStatus" .. status
    },
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function getInputFile(file)
  if file:match('/') then
    infile = {ID = "InputFileLocal", path_ = file}
  elseif file:match('^%d+$') then
    infile = {ID = "InputFileId", id_ = file}
  else
    infile = {ID = "InputFilePersistentId", persistent_id_ = file}
  end

  return infile
end
-----------------------------------------------------------------------------------------------
function del_all_msgs(chat_id, user_id)
  tdcli_function ({
    ID = "DeleteMessagesFromUser",
    chat_id_ = chat_id,
    user_id_ = user_id
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function getChatId(id)
  local chat = {}
  local id = tostring(id)

  if id:match('^-100') then
    local channel_id = id:gsub('-100', '')
    chat = {ID = channel_id, type = 'channel'}
  else
    local group_id = id:gsub('-', '')
    chat = {ID = group_id, type = 'group'}
  end

  return chat
end
-----------------------------------------------------------------------------------------------
function chat_leave(chat_id, user_id)
  changeChatMemberStatus(chat_id, user_id, "Left")
end
-----------------------------------------------------------------------------------------------
function from_username(msg)
  function gfrom_user(extra,result,success)
    if result.username_ then
      F = result.username_
    else
      F = 'nil'
    end
    return F
  end
  local username = getUser(msg.sender_user_id_,gfrom_user)
  return username
end
-----------------------------------------------------------------------------------------------
function chat_kick(chat_id, user_id)
  changeChatMemberStatus(chat_id, user_id, "Kicked")
end
-----------------------------------------------------------------------------------------------
function do_notify (user, msg)
  local n = notify.Notification.new(user, msg)
  n:show ()
end
-----------------------------------------------------------------------------------------------
local function getParseMode(parse_mode)
  if parse_mode then
    local mode = parse_mode:lower()

    if mode == 'markdown' or mode == 'md' then
      P = {ID = "TextParseModeMarkdown"}
    elseif mode == 'html' then
      P = {ID = "TextParseModeHTML"}
    end
  end
  return P
end
-----------------------------------------------------------------------------------------------
local function getMessage(chat_id, message_id,cb)
  tdcli_function ({
    ID = "GetMessage",
    chat_id_ = chat_id,
    message_id_ = message_id
  }, cb, nil)
end
-----------------------------------------------------------------------------------------------
function sendContact(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, phone_number, first_name, last_name, user_id)
  tdcli_function ({
    ID = "SendMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = reply_to_message_id,
    disable_notification_ = disable_notification,
    from_background_ = from_background,
    reply_markup_ = reply_markup,
    input_message_content_ = {
      ID = "InputMessageContact",
      contact_ = {
        ID = "Contact",
        phone_number_ = phone_number,
        first_name_ = first_name,
        last_name_ = last_name,
        user_id_ = user_id
      },
    },
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function sendPhoto(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, photo, caption)
  tdcli_function ({
    ID = "SendMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = reply_to_message_id,
    disable_notification_ = disable_notification,
    from_background_ = from_background,
    reply_markup_ = reply_markup,
    input_message_content_ = {
      ID = "InputMessagePhoto",
      photo_ = getInputFile(photo),
      added_sticker_file_ids_ = {},
      width_ = 0,
      height_ = 0,
      caption_ = caption
    },
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function getUserFull(user_id,cb)
  tdcli_function ({
    ID = "GetUserFull",
    user_id_ = user_id
  }, cb, nil)
end
-----------------------------------------------------------------------------------------------
function delmsg(arg,data)
  for k,v in pairs(data.messages_) do
    delete_msg(v.chat_id_,{[0] = v.id_})
  end
end
-----------------------------------------------------------------------------------------------
function deleteChatHistory(chat_id, remove_from_chat_list)
  tdcli_function ({
    ID = "DeleteChatHistory",
    chat_id_ = chat_id,
    limit_ = remove_from_chat_list
  }, dl_cb, nil)
end
----------------------------------------------------------------------------------------------
function vardump(value)
  print(serpent.block(value, {comment=false}))
end
-----------------------------------------------------------------------------------------------
function dl_cb(arg, data)
end
-----------------------------------------------------------------------------------------------
local function send(chat_id, reply_to_message_id, disable_notification, text, disable_web_page_preview, parse_mode)
  local TextParseMode = getParseMode(parse_mode)

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
-----------------------------------------------------------------------------------------------
function sendaction(chat_id, action, progress)
  tdcli_function ({
    ID = "SendChatAction",
    chat_id_ = chat_id,
    action_ = {
      ID = "SendMessage" .. action .. "Action",
      progress_ = progress or 100
    }
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function changetitle(chat_id, title)
  tdcli_function ({
    ID = "ChangeChatTitle",
    chat_id_ = chat_id,
    title_ = title
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function edit(chat_id, message_id, reply_markup, text, disable_web_page_preview, parse_mode)
  local TextParseMode = getParseMode(parse_mode)
  tdcli_function ({
    ID = "EditMessageText",
    chat_id_ = chat_id,
    message_id_ = message_id,
    reply_markup_ = reply_markup,
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
-----------------------------------------------------------------------------------------------
function setphoto(chat_id, photo)
  tdcli_function ({
    ID = "ChangeChatPhoto",
    chat_id_ = chat_id,
    photo_ = getInputFile(photo)
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function add_user(chat_id, user_id, forward_limit)
  tdcli_function ({
    ID = "AddChatMember",
    chat_id_ = chat_id,
    user_id_ = user_id,
    forward_limit_ = forward_limit or 50
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function unpinmsg(channel_id)
  tdcli_function ({
    ID = "UnpinChannelMessage",
    channel_id_ = getChatId(channel_id).ID
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
local function blockUser(user_id)
  tdcli_function ({
    ID = "BlockUser",
    user_id_ = user_id
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
local function unblockUser(user_id)
  tdcli_function ({
    ID = "UnblockUser",
    user_id_ = user_id
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
local function getBlockedUsers(offset, limit)
  tdcli_function ({
    ID = "GetBlockedUsers",
    offset_ = offset,
    limit_ = limit
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function delete_msg(chatid ,mid)
  tdcli_function ({
    ID = "DeleteMessages",
    chat_id_ = chatid,
    message_ids_ = mid
  }, dl_cb, nil)
end
-------------------------------------------------------------------------------------------------
function chat_del_user(chat_id, user_id)
  changeChatMemberStatus(chat_id, user_id, 'Editor')
end
-----------------------------------------------------------------------------------------------
function getChannelMembers(channel_id, offset, filter, limit)
  if not limit or limit > 200 then
    limit = 200
  end
  tdcli_function ({
    ID = "GetChannelMembers",
    channel_id_ = getChatId(channel_id).ID,
    filter_ = {
      ID = "ChannelMembers" .. filter
    },
    offset_ = offset,
    limit_ = limit
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function getChannelFull(channel_id)
  tdcli_function ({
    ID = "GetChannelFull",
    channel_id_ = getChatId(channel_id).ID
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
local function channel_get_bots(channel,cb)
  local function callback_admins(extra,result,success)
    limit = result.member_count_
    getChannelMembers(channel, 0, 'Bots', limit,cb)
  end
  getChannelFull(channel,callback_admins)
end
-----------------------------------------------------------------------------------------------
local function getInputMessageContent(file, filetype, caption)
  if file:match('/') then
    infile = {ID = "InputFileLocal", path_ = file}
  elseif file:match('^%d+$') then
    infile = {ID = "InputFileId", id_ = file}
  else
    infile = {ID = "InputFilePersistentId", persistent_id_ = file}
  end

  local inmsg = {}
  local filetype = filetype:lower()

  if filetype == 'voice' then
    inmsg = {ID = "InputMessageVoice", voice_ = infile, caption_ = caption}
  elseif filetype == 'audio' then
    inmsg = {ID = "InputMessageAudio", audio_ = infile, caption_ = caption}
  elseif filetype == 'document' then
    inmsg = {ID = "InputMessageDocument", document_ = infile, caption_ = caption}
  elseif filetype == 'photo' then
    inmsg = {ID = "InputMessagePhoto", photo_ = infile, caption_ = caption}
  elseif filetype == 'sticker' then
    inmsg = {ID = "InputMessageSticker", sticker_ = infile, caption_ = caption}
  elseif filetype == 'video' then
    inmsg = {ID = "InputMessageVideo", video_ = infile, caption_ = caption}
  elseif filetype == 'animation' then
    inmsg = {ID = "InputMessageAnimation", animation_ = infile, caption_ = caption}
  end
  return inmsg
end

-----------------------------------------------------------------------------------------------
function send_file(chat_id, type, file, caption,wtf)
  local mame = (wtf or 0)
  tdcli_function ({
    ID = "SendMessage",
    chat_id_ = chat_id,
    reply_to_message_id_ = mame,
    disable_notification_ = 0,
    from_background_ = 1,
    reply_markup_ = nil,
    input_message_content_ = getInputMessageContent(file, type, caption),
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
function getUser(user_id, cb)
  tdcli_function ({
    ID = "GetUser",
    user_id_ = user_id
  }, cb, nil)
end
-----------------------------------------------------------------------------------------------
function pin(channel_id, message_id, disable_notification)
  tdcli_function ({
    ID = "PinChannelMessage",
    channel_id_ = getChatId(channel_id).ID,
    message_id_ = message_id,
    disable_notification_ = disable_notification
  }, dl_cb, nil)
end
-----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function tdcli_update_callback(data)
  -------------------------------------------
  if (data.ID == "UpdateNewMessage") then
    local msg = data.message_
    --vardump(data)
    local d = data.disable_notification_
    local chat = chats[msg.chat_id_]
    -------------------------------------------
    if msg.date_ < (os.time() - 30) then
      return false
    end
    -------------------------------------------
    if not db:get("bot:enable:"..msg.chat_id_) and not is_admin(msg.sender_user_id_, msg.chat_id_) then
      return false
    end
    -------------------------------------------
    if msg and msg.send_state_.ID == "MessageIsSuccessfullySent" then
      --vardump(msg)
      function get_mymsg_contact(extra, result, success)
        --vardump(result)
      end
      getMessage(msg.chat_id_, msg.reply_to_message_id_,get_mymsg_contact)
      return false
    end
    -------------* EXPIRE *-----------------
    if not db:get("bot:charge:"..msg.chat_id_) then
      if db:get("bot:enable:"..msg.chat_id_) then
        db:del("bot:enable:"..msg.chat_id_)
        for k,v in pairs(bot_owner) do
          send(v, 0, 1, "⭕️ موعد تجديد الدفع !\n🔹الرابط : "..(db:get("bot:group:link"..msg.chat_id_) or "لم يتم التعيين").."\n🔸معرف المجموعة :  "..msg.chat_id_..'\n\n🔹اگر میخواهید ربات گروه را ترک کند از دستور زیر استفاده کنید :\n\n🔖 leave'..msg.chat_id_..'\n\n🔸اگر قصد وارد شدن به گروه را دارید از دستور زیر استفاده کنید :\n\n🔖 join'..msg.chat_id_..'\n\n🔹اگر میخواهید ربات داخل گروه اعلام کند از دستور زیر استفاده کنید :\n\n🔖 meld'..msg.chat_id_..'\n\n🔅🔅🔅🔅🔅🔅\n\n📅 اگر قصد تمدید گروه را دارید از دستورات زیر استفاده کنید : \n\n⭕️برای شارژ به صورت یک ماه :\n🔖 plan1'..msg.chat_id_..'\n\n⭕️برای شارژ به صورت سه ماه :\n🔖 plan2'..msg.chat_id_..'\n\n⭕️برای شارژ به صورت نامحدود :\n🔖 plan3'..msg.chat_id_, 1, 'html')
        end
        --send(msg.chat_id_, 0, 1, '🔺لقد حان الوقت لتوسيع الروبوت إلى هذه المجموعة\n يرجى الرجوع إلى فريق دعم الروبوت في أقرب وقت ممكن وتوسيع البوت 🌹', 1, 'html')
      end
    end
    -------------------------------------------
    db:incr("bot:allmsgs")
    if msg.chat_id_ then
      local id = tostring(msg.chat_id_)
      if id:match('-100(%d+)') then
        if not db:sismember("bot:groups",msg.chat_id_) then
          db:sadd("bot:groups",msg.chat_id_)
        end
      elseif id:match('^(%d+)') then
        if not db:sismember("bot:userss",msg.chat_id_) then
          db:sadd("bot:userss",msg.chat_id_)
        end
      else
        if not db:sismember("bot:groups",msg.chat_id_) then
          db:sadd("bot:groups",msg.chat_id_)
        end
      end
    end
    -------------------------------------------
    -------------* MSG TYPES *-----------------
    if msg.content_ then
      if msg.reply_markup_ and  msg.reply_markup_.ID == "ReplyMarkupInlineKeyboard" then
        --if msg.reply_markup_.ID == "ReplyMarkupInlineKeyboard" then
          print("This is [ Inline ]")
          msg_type = 'MSG:Inline'
        end
        -------------------------
        if msg.content_.ID == "MessageText" then
          text = msg.content_.text_
          print("This is [ Text ]")
          msg_type = 'MSG:Text'
        end
        -------------------------
        if msg.content_.ID == "MessagePhoto" then
          print("This is [ Photo ]")
          if msg.content_.caption_ then
            caption_text = msg.content_.caption_
          end
          msg_type = 'MSG:Photo'
        end
        -------------------------
        if msg.content_.ID == "MessageChatAddMembers" then
          print("This is [ New User Add ]")
          msg_type = 'MSG:NewUserAdd'
        end
        -----------------------------------
        if msg.content_.ID == "MessageDocument" then
          print("This is [ File Or Document ]")
          msg_type = 'MSG:Document'
        end
        -------------------------
        if msg.content_.ID == "MessageSticker" then
          print("This is [ Sticker ]")
          msg_type = 'MSG:Sticker'
        end
        -------------------------
        if msg.content_.ID == "MessageAudio" then
          print("This is [ Audio ]")
          if msg.content_.caption_ then
            caption_text = msg.content_.caption_
          end
          msg_type = 'MSG:Audio'
        end
        -------------------------
        if msg.content_.ID == "MessageVoice" then
          print("This is [ Voice ]")
          if msg.content_.caption_ then
            caption_text = msg.content_.caption_
          end
          msg_type = 'MSG:Voice'
        end
        -------------------------
        if msg.content_.ID == "MessageVideo" then
          print("This is [ Video ]")
          if msg.content_.caption_ then
            caption_text = msg.content_.caption_
          end
          msg_type = 'MSG:Video'
        end
        -------------------------
        if msg.content_.ID == "MessageAnimation" then
          print("This is [ Gif ]")
          if msg.content_.caption_ then
            caption_text = msg.content_.caption_
          end
          msg_type = 'MSG:Gif'
        end
        -------------------------
        if msg.content_.ID == "MessageLocation" then
          print("This is [ Location ]")
          if msg.content_.caption_ then
            caption_text = msg.content_.caption_
          end
          msg_type = 'MSG:Location'
        end
        -------------------------
        if msg.content_.ID == "MessageChatJoinByLink" or msg.content_.ID == "MessageChatAddMembers" then
          print("This is [ Msg Join ]")
          msg_type = 'MSG:NewUser'
        end
        -------------------------
        if msg.content_.ID == "MessageChatJoinByLink" then
          print("This is [ Msg Join By Link ]")
          msg_type = 'MSG:JoinByLink'
        end
        -------------------------
        if msg.content_.ID == "MessageContact" then
          print("This is [ Contact ]")
          if msg.content_.caption_ then
            caption_text = msg.content_.caption_
          end
          msg_type = 'MSG:Contact'
        end
        -------------------------
      end
      -------------------------------------------
      if ((not d) and chat) then
        if msg.content_.ID == "MessageText" then
          do_notify (chat.title_, msg.content_.text_)
        else
          do_notify (chat.title_, msg.content_.ID)
        end
      end
      -----------------------------------------------------------------------------------------------
      -- end functions --
      -----------------------------------------------------------------------------------------------
      -----------------------------------------------------------------------------------------------
      ----------------------------------------Anti FLood---------------------------------------------
      --------------Flood Max --------------
      local flmax = 'flood:max:'..msg.chat_id_
      if not db:get(flmax) then
        floodMax = 5
      else
        floodMax = tonumber(db:get(flmax))
      end
      -----------------End-------------------
      -----------------Msg-------------------
      local pm = 'flood:'..msg.sender_user_id_..':'..msg.chat_id_..':msgs'
      if not db:get(pm) then
        msgs = 0
      else
        msgs = tonumber(db:get(pm))
      end
      -----------------End-------------------
      ------------Flood Check Time-----------
      local TIME_CHECK = 2
      -----------------End-------------------
      -------------Flood Check---------------
      local hashflood = 'anti-flood:'..msg.chat_id_
      if msgs > (floodMax - 1) then
        if db:get('floodstatus'..msg.chat_id_) == 'Kicked' then
          del_all_msgs(msg.chat_id_, msg.sender_user_id_)
          chat_kick(msg.chat_id_, msg.sender_user_id_)
        elseif db:get('floodstatus'..msg.chat_id_) == 'DelMsg' then
          del_all_msgs(msg.chat_id_, msg.sender_user_id_)
        else
          del_all_msgs(msg.chat_id_, msg.sender_user_id_)del_all_msgs(msg.chat_id_, msg.sender_user_id_)
        end
      end
      ------------------End-------------------
      -------------------------------------- Process mod --------------------------------------------
      -----------------------------------------------------------------------------------------------

      -------------------------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------------------------
      --------------------------******** START MSG CHECKS ********-------------------------------------------
      -------------------------------------------------------------------------------------------------------
      -------------------------------------------------------------------------------------------------------
      if is_banned(msg.sender_user_id_, msg.chat_id_) then
        local id = msg.id_
        local msgs = {[0] = id}
        local chat = msg.chat_id_
        chat_kick(msg.chat_id_, msg.sender_user_id_)
        return
      end
      if is_muted(msg.sender_user_id_, msg.chat_id_) then
        local id = msg.id_
        local msgs = {[0] = id}
        local chat = msg.chat_id_
        delete_msg(chat,msgs)
        return
      end
      if is_gbanned(msg.sender_user_id_) then
        local id = msg.id_
        local msgs = {[0] = id}
        local chat = msg.chat_id_
        chat_kick(msg.chat_id_, msg.sender_user_id_)
        return
      end
      if db:get('bot:muteall'..msg.chat_id_) and not is_mod(msg.sender_user_id_, msg.chat_id_) then
        local id = msg.id_
        local msgs = {[0] = id}
        local chat = msg.chat_id_
        delete_msg(chat,msgs)
        return
      end
      db:incr('user:msgs'..msg.chat_id_..':'..msg.sender_user_id_)
      db:incr('group:msgs'..msg.chat_id_)
      if msg.content_.ID == "MessagePinMessage" then
        if db:get('pinnedmsg'..msg.chat_id_) and db:get('bot:pin:mute'..msg.chat_id_) then
          unpinmsg(msg.chat_id_)
          local pin_id = db:get('pinnedmsg'..msg.chat_id_)
          pin(msg.chat_id_,pin_id,0)
        end
      end
      if db:get('bot:viewget'..msg.sender_user_id_) then
        if not msg.forward_info_ then
          send(msg.chat_id_, msg.id_, 1, 'خطأ في العملية ❌\n\n⭕️الرجاء إعادة إرسال الطلب ثم تنزيل عرض عداد العرض ', 1, 'md')
          db:del('bot:viewget'..msg.sender_user_id_)
        else
          send(msg.chat_id_, msg.id_, 1, '🔹عدد مشاركاتك : '..msg.views_..' زيارة', 1, 'md')
          db:del('bot:viewget'..msg.sender_user_id_)
        end
      end
      --Photo
      --Photo
      ------- --- Photo--------- Photo
      -- -----------------Photo
      --Photo
      --Photo
      if msg_type == 'MSG:Photo' then
        if not is_mod(msg.sender_user_id_, msg.chat_id_) then
          if db:get('anti-flood:'..msg.chat_id_) then
            db:setex(pm, TIME_CHECK, msgs+1)
          end
          if msg.forward_info_ then
            if db:get('bot:forward:mute'..msg.chat_id_) then
              if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [Fwd] [Photo] [NS1]")
              end
            end
          end
          if db:get('bot:photo:mute'..msg.chat_id_) then
            local id = msg.id_
            local msgs = {[0] = id}
            local chat = msg.chat_id_
            delete_msg(chat,msgs)
            print("Deleted [Lock] [Photo] [NS2]")
          end
          if not caption_text then
            return false
          else
            check_filter_words(msg, caption_text)
            if db:get('bot:links:mute'..msg.chat_id_) then
              if caption_text:match("[Hh][Tt][Tt][Pp][Ss]://%S+") or caption_text:match("[Hh][Tt][Tt][Pp]://%S+") then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [Link] [Photo] [NS3]")
                if db:get('bot:strict'..msg.chat_id_) then
                  chat_kick(msg.chat_id_, msg.sender_user_id_)
                end
              end
            end
            if db:get('tags:lock'..msg.chat_id_) then
              if caption_text:match("^@[%a%d]") then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [Tag] [Photo] [NS4]")
              end
            end
            if msg.content_.entities_[0].ID and msg.content_.entities_[0].ID == "MessageEntityMentionName" then
              if db:get('mention:lock'..msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
              end
            end
            if caption_text:match("#[%a%d]") then
              if db:get('bot:hashtag:mute'..msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [Hashtag] [Photo] [NS5]")
              end
            end
            if msg.content_.entities_[0].ID == "MessageEntityBold" or msg.content_.entities_[0].ID == "MessageEntityCode" or msg.content_.entities_[0].ID == "MessageEntityPre" or msg.content_.entities_[0].ID == "MessageEntityItalic" then
              if db:get('markdown:lock'..msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
              end
            end
            if caption_text:match("[Hh][Tt][Tt][Pp][Ss]://") or caption_text:match("[Hh][Tt][Tt][Pp]://") or caption_text:match(".[Ii][Rr]") or caption_text:match(".[Cc][Oo][Mm]") or caption_text:match(".[Oo][Rr][Gg]") or caption_text:match(".[Ii][Nn][Ff][Oo]") or caption_text:match("[Ww][Ww][Ww].") or caption_text:match(".[Tt][Kk]") then
              if db:get('bot:webpage:mute'..msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [Hashtag] [Photo] [NS6]")
              end
            end
            if caption_text:match("[\216-\219][\128-\191]") then
              if db:get('bot:arabic:mute'..msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [Farsi] [Photo] [NS7]")
              end
            end
            if caption_text:match("[ASDFGHJKLQWERTYUIOPZXCVBNMasdfghjklqwertyuiopzxcvbnm]") then
              if db:get('bot:english:mute'..msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [English] [Photo] [NS8]")
              end
            end
          end
        end
        --Document
        --Document
        ------- --- Document--------- Document
        -- -----------------Document
        --Document
        --Document
      elseif msg_type == 'MSG:Document' then
        if not is_mod(msg.sender_user_id_, msg.chat_id_) then
          if db:get('anti-flood:'..msg.chat_id_) then
            db:setex(pm, TIME_CHECK, msgs+1)
          end
          if msg.forward_info_ then
            if db:get('bot:forward:mute'..msg.chat_id_) then
              if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [Fwd] [Document] [NS9]")
              end
            end
          end
          if db:get('bot:document:mute'..msg.chat_id_) then
            local id = msg.id_
            local msgs = {[0] = id}
            local chat = msg.chat_id_
            delete_msg(chat,msgs)
            print("Deleted [Lock] [Document] [NS10]")
          end
          if not caption_text then
            return false
          else
            check_filter_words(msg, caption_text)
            if db:get('bot:links:mute'..msg.chat_id_) then
              if caption_text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/%S+") or caption_text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/%S+") or caption_text:match("[Tt].[Mm][Ee]/%S+") then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [Link] [Document] [NS11]")
                if db:get('bot:strict'..msg.chat_id_) then
                  chat_kick(msg.chat_id_, msg.sender_user_id_)
                end
              end
            end
            if db:get('tags:lock'..msg.chat_id_) then
              if caption_text:match("^@[%a%d]") then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [Tag] [Document] [NS12]")
              end
            end
            if msg.content_.entities_[0].ID and msg.content_.entities_[0].ID == "MessageEntityMentionName" then
              if db:get('mention:lock'..msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
              end
            end
            if caption_text:match("^#[%a%d]") then
              if db:get('bot:hashtag:mute'..msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [Hashtag] [Document] [NS13]")
              end
            end
            if msg.content_.entities_[0].ID == "MessageEntityBold" or msg.content_.entities_[0].ID == "MessageEntityCode" or msg.content_.entities_[0].ID == "MessageEntityPre" or msg.content_.entities_[0].ID == "MessageEntityItalic" then
              if db:get('markdown:lock'..msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
              end
            end
            if caption_text:match("[Hh][Tt][Tt][Pp][Ss]://") or caption_text:match("[Hh][Tt][Tt][Pp]://") or caption_text:match(".[Ii][Rr]") or caption_text:match(".[Cc][Oo][Mm]") or caption_text:match(".[Oo][Rr][Gg]") or caption_text:match(".[Ii][Nn][Ff][Oo]") or caption_text:match("[Ww][Ww][Ww].") or caption_text:match(".[Tt][Kk]") then
              if db:get('bot:webpage:mute'..msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [Web] [Document] [NS14]")
              end
            end
            if caption_text:match("[\216-\219][\128-\191]") then
              if db:get('bot:arabic:mute'..msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [Farsi] [Document] [NS15]")
              end
            end
            if caption_text:match("[ASDFGHJKLQWERTYUIOPZXCVBNMasdfghjklqwertyuiopzxcvbnm]") then
              if db:get('bot:english:mute'..msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [English] [Document] [NS16]")
              end
            end
          end
        end
        --Inline
        --Inline
        ------- --- Inline--------- Inline
        -- -----------------Inline
        --Inline
        --Inline
        --elseif msg_type == 'MSG:Inline' then
        elseif msg.via_bot_user_id_ ~= 0 then
          if not is_mod(msg.sender_user_id_, msg.chat_id_) then
            if db:get('anti-flood:'..msg.chat_id_) then
              db:setex(pm, TIME_CHECK, msgs+1)
            end
            if db:get('bot:inline:mute'..msg.chat_id_) then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
              print("Deleted [Lock] [Inline] [NS17]")
            end
          end
          --Sticker
          --Sticker
          ------- --- Sticker--------- Sticker
          -- -----------------Sticker
          --Sticker
          --Sticker
        elseif msg_type == 'MSG:Sticker' then
          if not is_mod(msg.sender_user_id_, msg.chat_id_) then
            if db:get('anti-flood:'..msg.chat_id_) then
              db:setex(pm, TIME_CHECK, msgs+1)
            end
            if db:get('bot:sticker:mute'..msg.chat_id_) then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
              print("Deleted [Lock] [Sticker] [NS18]")
            end
          end
        elseif msg_type == 'MSG:JoinByLink' then
          if db:get('bot:tgservice:mute'..msg.chat_id_) then
            local id = msg.id_
            local msgs = {[0] = id}
            local chat = msg.chat_id_
            delete_msg(chat,msgs)
            print("Deleted [Lock] [Tgservice] [JoinByLink] [NS19]")
            return
          end
          function get_welcome(extra,result,success)
            if db:get('welcome:'..msg.chat_id_) then
              text = db:get('welcome:'..msg.chat_id_)
            else
              text = 'مرحبا {firstname} مرحبا بك 🌹'
            end
            local text = text:gsub('{firstname}',(result.first_name_ or ''))
            local text = text:gsub('{lastname}',(result.last_name_ or ''))
            local text = text:gsub('{username}',(result.username_ or ''))
            send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
          end
          if db:get("bot:welcome"..msg.chat_id_) then
            getUser(msg.sender_user_id_,get_welcome)
          end
        elseif msg_type == 'MSG:NewUserAdd' then
          if db:get('bot:tgservice:mute'..msg.chat_id_) then
            local id = msg.id_
            local msgs = {[0] = id}
            local chat = msg.chat_id_
            delete_msg(chat,msgs)
            print("Deleted [Lock] [Tgservice] [NewUserAdd] [NS20]")
            return
          end
          if msg.content_.members_[0].username_ and msg.content_.members_[0].username_:match("[Bb][Oo][Tt]$") then
            if db:get('bot:bots:mute'..msg.chat_id_) and not is_mod(msg.content_.members_[0].id_, msg.chat_id_) then
              chat_kick(msg.chat_id_, msg.content_.members_[0].id_)
              return false
            end
          end
          if is_banned(msg.content_.members_[0].id_, msg.chat_id_) then
            chat_kick(msg.chat_id_, msg.content_.members_[0].id_)
            return false
          end
          if db:get("bot:welcome"..msg.chat_id_) then
            if db:get('welcome:'..msg.chat_id_) then
              text = db:get('welcome:'..msg.chat_id_)
            else
              text = 'اهلا وسهلا بك'
            end
            local text = text:gsub('{firstname}',(msg.content_.members_[0].first_name_ or ''))
            local text = text:gsub('{lastname}',(msg.content_.members_[0].last_name_ or ''))
            local text = text:gsub('{username}',('@'..msg.content_.members_[0].username_ or ''))
            send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
          end
          --Contact
          --Contact
          ------- --- Contact--------- Contact
          -- -----------------Contact
          --Contact
          --Contact
        elseif msg_type == 'MSG:Contact' then
          if not is_mod(msg.sender_user_id_, msg.chat_id_) then
            if db:get('anti-flood:'..msg.chat_id_) then
              db:setex(pm, TIME_CHECK, msgs+1)
            end
            if msg.forward_info_ then
              if db:get('bot:forward:mute'..msg.chat_id_) then
                if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Fwd] [Contact] [NS21]")
                end
              end
            end
            if db:get('bot:contact:mute'..msg.chat_id_) then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
              print("Deleted [Lock] [Contact] [NS22]")
            end
          end
          --Audio
          --Audio
          ------- --- Audio--------- Audio
          -- -----------------Audio
          --Audio
          --Audio
        elseif msg_type == 'MSG:Audio' then
          if not is_mod(msg.sender_user_id_, msg.chat_id_) then
            if db:get('anti-flood:'..msg.chat_id_) then
              db:setex(pm, TIME_CHECK, msgs+1)
            end
            if msg.forward_info_ then
              if db:get('bot:forward:mute'..msg.chat_id_) then
                if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Fwd] [Audio] [NS23]")
                end
              end
            end
            if db:get('bot:music:mute'..msg.chat_id_) then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
              print("Deleted [Lock] [Audio] [NS24]")
            end
            if not caption_text then
              return false
            else
              check_filter_words(msg, caption_text)
              if db:get('bot:links:mute'..msg.chat_id_) then
                if caption_text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/%S+") or caption_text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/%S+") or caption_text:match("[Tt].[Mm][Ee]/%S+") then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Link] [Audio] [NS25]")
                end
              end
              if db:get('tags:lock'..msg.chat_id_) then
                if caption_text:match("^@[%a%d]") then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Tag] [Audio] [NS26]")
                end
              end
              if msg.content_.entities_[0].ID and msg.content_.entities_[0].ID == "MessageEntityMentionName" then
                if db:get('mention:lock'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                end
              end
              if caption_text:match("#[%a%d]") then
                if db:get('bot:hashtag:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Hashtag] [Audio] [NS27]")
                end
              end
              if msg.content_.entities_[0].ID == "MessageEntityBold" or msg.content_.entities_[0].ID == "MessageEntityCode" or msg.content_.entities_[0].ID == "MessageEntityPre" or msg.content_.entities_[0].ID == "MessageEntityItalic" then
                if db:get('markdown:lock'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                end
              end
              if caption_text:match("[Hh][Tt][Tt][Pp][Ss]://") or caption_text:match("[Hh][Tt][Tt][Pp]://") or caption_text:match(".[Ii][Rr]") or caption_text:match(".[Cc][Oo][Mm]") or caption_text:match(".[Oo][Rr][Gg]") or caption_text:match(".[Ii][Nn][Ff][Oo]") or caption_text:match("[Ww][Ww][Ww].") or caption_text:match(".[Tt][Kk]") then
                if db:get('bot:webpage:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Web] [Audio] [NS28]")
                end
              end
              if caption_text:match("[\216-\219][\128-\191]") then
                if db:get('bot:arabic:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Farsi] [Audio] [NS29]")
                end
              end
              if caption_text:match("[ASDFGHJKLQWERTYUIOPZXCVBNMasdfghjklqwertyuiopzxcvbnm]") then
                if db:get('bot:english:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [English] [Audio] [NS30]")
                end
              end
            end
          end
          --Voice
          --Voice
          ------- --- Voice--------- Voice
          -- -----------------Voice
          --Voice
          --Voice
        elseif msg_type == 'MSG:Voice' then
          if not is_mod(msg.sender_user_id_, msg.chat_id_) then
            if db:get('anti-flood:'..msg.chat_id_) then
              db:setex(pm, TIME_CHECK, msgs+1)
            end
            if msg.forward_info_ then
              if db:get('bot:forward:mute'..msg.chat_id_) then
                if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Fwd] [Voice] [NS31]")
                end
              end
            end
            if db:get('bot:voice:mute'..msg.chat_id_) then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
              print("Deleted [Lock] [Voice] [NS32]")
            end
            if not caption_text then
              return false
            else
              check_filter_words(msg, caption_text)
              if db:get('bot:links:mute'..msg.chat_id_) then
                if caption_text:match("[Hh][Tt][Tt][Pp][Ss]://%S+") or caption_text:match("[Hh][Tt][Tt][Pp]://%S+") then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Link] [Voice] [NS33]")
                end
              end
              if db:get('tags:lock'..msg.chat_id_) then
                if caption_text:match("^@[%a%d]") then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Tag] [Voice] [NS34]")
                end
              end
              if msg.content_.entities_[0].ID and msg.content_.entities_[0].ID == "MessageEntityMentionName" then
                if db:get('mention:lock'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                end
              end
              if caption_text:match("#[%a%d]") then
                if db:get('bot:hashtag:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Hashtag] [Voice] [NS36]")
                end
              end
              if msg.content_.entities_[0].ID == "MessageEntityBold" or msg.content_.entities_[0].ID == "MessageEntityCode" or msg.content_.entities_[0].ID == "MessageEntityPre" or msg.content_.entities_[0].ID == "MessageEntityItalic" then
                if db:get('markdown:lock'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                end
              end
              if caption_text:match("[Hh][Tt][Tt][Pp][Ss]://") or caption_text:match("[Hh][Tt][Tt][Pp]://") or caption_text:match(".[Ii][Rr]") or caption_text:match(".[Cc][Oo][Mm]") or caption_text:match(".[Oo][Rr][Gg]") or caption_text:match(".[Ii][Nn][Ff][Oo]") or caption_text:match("[Ww][Ww][Ww].") or caption_text:match(".[Tt][Kk]") then
                if db:get('bot:webpage:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Web] [Voice] [NS37]")
                end
              end
              if caption_text:match("[\216-\219][\128-\191]") then
                if db:get('bot:arabic:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Farsi] [Voice] [NS38]")
                end
              end
              if caption_text:match("[ASDFGHJKLQWERTYUIOPZXCVBNMasdfghjklqwertyuiopzxcvbnm]") then
                if db:get('bot:english:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [English] [Voice] [NS39]")
                end
              end
            end
          end
          --Location
          --Location
          ------- --- Location--------- Location
          -- -----------------Location
          --Location
          --Location
        elseif msg_type == 'MSG:Location' then
          if not is_mod(msg.sender_user_id_, msg.chat_id_) then
            if db:get('anti-flood:'..msg.chat_id_) then
              db:setex(pm, TIME_CHECK, msgs+1)
            end
            if msg.forward_info_ then
              if db:get('bot:forward:mute'..msg.chat_id_) then
                if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [English] [Location] [NS40]")
                end
              end
            end
            if db:get('bot:location:mute'..msg.chat_id_) then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
              print("Deleted [Lock] [Location] [NS41]")
              --return
            end
            if not caption_text then
              return
            else
              check_filter_words(msg, caption_text)
              if db:get('bot:links:mute'..msg.chat_id_) then
                if caption_text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/%S+") or caption_text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/%S+") or caption_text:match("[Tt].[Mm][Ee]/%S+") then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Link] [Location] [NS42]")
                end
              end
              if db:get('tags:lock'..msg.chat_id_) then
                if caption_text:match("^@[%a%d]") then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Tag] [Location] [NS43]")
                end
              end
              if msg.content_.entities_[0].ID and msg.content_.entities_[0].ID == "MessageEntityMentionName" then
                if db:get('mention:lock'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                end
              end
              if caption_text:match("#[%a%d]") then
                if db:get('bot:hashtag:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Hashtag] [Location] [NS44]")
                end
              end
              if msg.content_.entities_[0].ID == "MessageEntityBold" or msg.content_.entities_[0].ID == "MessageEntityCode" or msg.content_.entities_[0].ID == "MessageEntityPre" or msg.content_.entities_[0].ID == "MessageEntityItalic" then
                if db:get('markdown:lock'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                end
              end
              if caption_text:match("[Hh][Tt][Tt][Pp][Ss]://") or caption_text:match("[Hh][Tt][Tt][Pp]://") or caption_text:match(".[Ii][Rr]") or caption_text:match(".[Cc][Oo][Mm]") or caption_text:match(".[Oo][Rr][Gg]") or caption_text:match(".[Ii][Nn][Ff][Oo]") or caption_text:match("[Ww][Ww][Ww].") or caption_text:match(".[Tt][Kk]") then
                if db:get('bot:webpage:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Web] [Location] [NS45]")
                end
              end
              if caption_text:match("[\216-\219][\128-\191]") then
                if db:get('bot:arabic:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Farsi] [Location] [NS46]")
                end
              end
              if caption_text:match("[ASDFGHJKLQWERTYUIOPZXCVBNMasdfghjklqwertyuiopzxcvbnm]") then
                if db:get('bot:english:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [English] [Location] [NS47]")
                end
              end
            end
          end
          --Video
          --Video
          ------- --- Video--------- Video
          -- -----------------Video
          --Video
          --Video
        elseif msg_type == 'MSG:Video' then
          if not is_mod(msg.sender_user_id_, msg.chat_id_) then
            if db:get('anti-flood:'..msg.chat_id_) then
              db:setex(pm, TIME_CHECK, msgs+1)
            end
            if msg.forward_info_ then
              if db:get('bot:forward:mute'..msg.chat_id_) then
                if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Fwd] [Video] [NS48]")
                end
              end
            end
            if db:get('bot:video:mute'..msg.chat_id_) then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
              print("Deleted [Lock] [Video] [NS49]")
            end
            if not caption_text then
              return
            else
              check_filter_words(msg, caption_text)
              if db:get('bot:links:mute'..msg.chat_id_) then
                if caption_text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/%S+") or caption_text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/%S+") or caption_text:match("[Tt].[Mm][Ee]/%S+") then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Link] [Video] [NS50]")
                end
              end
              if db:get('tags:lock'..msg.chat_id_) then
                if caption_text:match("^@[%a%d]") then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Tag] [Video] [NS51]")
                end
              end
              if msg.content_.entities_[0].ID and msg.content_.entities_[0].ID == "MessageEntityMentionName" then
                if db:get('mention:lock'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                end
              end
              if caption_text:match("#[%a%d]") then
                if db:get('bot:hashtag:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Hashtag] [Video] [NS52]")
                end
              end
              if msg.content_.entities_[0].ID == "MessageEntityBold" or msg.content_.entities_[0].ID == "MessageEntityCode" or msg.content_.entities_[0].ID == "MessageEntityPre" or msg.content_.entities_[0].ID == "MessageEntityItalic" then
                if db:get('markdown:lock'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                end
              end
              if caption_text:match("[Hh][Tt][Tt][Pp][Ss]://") or caption_text:match("[Hh][Tt][Tt][Pp]://") or caption_text:match(".[Ii][Rr]") or caption_text:match(".[Cc][Oo][Mm]") or caption_text:match(".[Oo][Rr][Gg]") or caption_text:match(".[Ii][Nn][Ff][Oo]") or caption_text:match("[Ww][Ww][Ww].") or caption_text:match(".[Tt][Kk]") then
                if db:get('bot:webpage:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Web] [Video] [NS53]")
                end
              end
              if caption_text:match("[\216-\219][\128-\191]") then
                if db:get('bot:arabic:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Farsi] [Video] [NS54]")
                end
              end
              if caption_text:match("[ASDFGHJKLQWERTYUIOPZXCVBNMasdfghjklqwertyuiopzxcvbnm]") then
                if db:get('bot:english:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [English] [Video] [NS55]")
                end
              end
            end
          end
          --Gif
          --Gif
          ------- --- Gif--------- Gif
          -- -----------------Gif
          --Gif
          --Gif
        elseif msg_type == 'MSG:Gif' then
          if not is_mod(msg.sender_user_id_, msg.chat_id_) then
            if db:get('anti-flood:'..msg.chat_id_) then
              db:setex(pm, TIME_CHECK, msgs+1)
            end
            if msg.forward_info_ then
              if db:get('bot:forward:mute'..msg.chat_id_) then
                if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Fwd] [Gif] [NS56]")
                end
              end
            end
            if db:get('bot:gifs:mute'..msg.chat_id_) then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
              print("Deleted [Lock] [Gif] [NS57]")
            end
            if not caption_text then
              return
            else
              check_filter_words(msg, caption_text)
              if db:get('bot:links:mute'..msg.chat_id_) then
                if caption_text:match("[Hh][Tt][Tt][Pp][Ss]://%S+") or caption_text:match("[Hh][Tt][Tt][Pp]://%S+") then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Link] [Gif] [NS57]")
                end
              end
              if db:get('tags:lock'..msg.chat_id_) then
                if caption_text:match("^@[%a%d]") then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Tag] [Gif] [NS58]")
                end
              end
              if msg.content_.entities_[0].ID and msg.content_.entities_[0].ID == "MessageEntityMentionName" then
                if db:get('mention:lock'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                end
              end
              if caption_text:match("#[%a%d]") then
                if db:get('bot:hashtag:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Hashtag] [Gif] [NS59]")
                end
              end
              if msg.content_.entities_[0].ID == "MessageEntityBold" or msg.content_.entities_[0].ID == "MessageEntityCode" or msg.content_.entities_[0].ID == "MessageEntityPre" or msg.content_.entities_[0].ID == "MessageEntityItalic" then
                if db:get('markdown:lock'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                end
              end
              if caption_text:match("[Hh][Tt][Tt][Pp][Ss]://") or caption_text:match("[Hh][Tt][Tt][Pp]://") or caption_text:match(".[Ii][Rr]") or caption_text:match(".[Cc][Oo][Mm]") or caption_text:match(".[Oo][Rr][Gg]") or caption_text:match(".[Ii][Nn][Ff][Oo]") or caption_text:match("[Ww][Ww][Ww].") or caption_text:match(".[Tt][Kk]") then
                if db:get('bot:webpage:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Web] [Gif] [NS560]")
                end
              end
              if caption_text:match("[\216-\219][\128-\191]") then
                if db:get('bot:arabic:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Farsi] [Gif] [NS61]")
                end
              end
              if caption_text:match("[ASDFGHJKLQWERTYUIOPZXCVBNMasdfghjklqwertyuiopzxcvbnm]") then
                if db:get('bot:english:mute'..msg.chat_id_) then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [English] [Gif] [NS62]")
                end
              end
            end
          end
          --Text
          --Text
          ------- --- Text--------- Text
          -- -----------------Text
          --Text
          --Text
        elseif msg_type == 'MSG:Text' then
          if db:get('anti-flood:'..msg.chat_id_) then
            db:setex(pm, TIME_CHECK, msgs+1)
          end
          --vardump(msg)
          if db:get("bot:group:link"..msg.chat_id_) == 'waiting' and is_mod(msg.sender_user_id_, msg.chat_id_) then
            if text:match("(https://telegram.me/joinchat/%S+)") or text:match("(https://t.me/joinchat/%S+)") then
              local glink = text:match("(https://telegram.me/joinchat/%S+)") or text:match("(https://t.me/joinchat/%S+)")
              local hash = "bot:group:link"..msg.chat_id_
              db:set(hash,glink)
              send(msg.chat_id_, msg.id_, 1, ' تم تسجيل رابط المجموعة ✅', 1, 'md')
            end
          end
          function check_username(extra,result,success)
            --vardump(result)
            local username = (result.username_ or '')
            local svuser = 'user:'..result.id_
            if username then
              db:hset(svuser, 'username', username)
            end
            if username and username:match("[Bb][Oo][Tt]$") or username:match("_[Bb][Oo][Tt]$") then
              if db:get('bot:bots:mute'..msg.chat_id_) and not is_mod(result.id_, msg.chat_id_) then
                chat_kick(msg.chat_id_, result.id_)
                return false
              end
            end
          end
          getUser(msg.sender_user_id_,check_username)
          db:set('bot:editid'.. msg.id_,msg.content_.text_)
          if not is_mod(msg.sender_user_id_, msg.chat_id_) then
            check_filter_words(msg, text)
            if text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/%S+") or text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/%S+") or text:match("[Tt].[Mm][Ee]/%S+") then
              if db:get('bot:links:mute'..msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [Link] [Text] [NS63]")
                if db:get('bot:strict'..msg.chat_id_) then
                  chat_kick(msg.chat_id_, msg.sender_user_id_)
                end
              end
            end
            if db:get('bot:text:mute'..msg.chat_id_) then
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              delete_msg(chat,msgs)
              print("Deleted [Lock] [Text] [NS64]")
            end
            if msg.forward_info_ then
              if db:get('bot:forward:mute'..msg.chat_id_) then
                if msg.forward_info_.ID == "MessageForwardedFromUser" or msg.forward_info_.ID == "MessageForwardedPost" then
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                  print("Deleted [Lock] [Fwd] [Text] [NS65]")
                end
              end
            end
            if text:match("@") then
              if db:get('tags:lock'..msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [Tag] [Text] [NS66]")
              end
            end
            if db:get('mention:lock'..msg.chat_id_) then
              if not msg.content_.entities_[0].ID and msg.content_.entities_[0].ID == "MessageEntityMentionName" then
                return false
              else
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
              end
            end
            if text:match("#[%a%d]") then
              if db:get('bot:hashtag:mute'..msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [Hashtag] [Text] [NS67]")
              end
            end
            if db:get('markdown:lock'..msg.chat_id_) then
              if not msg.content_.entities_[0].ID == "MessageEntityBold" or msg.content_.entities_[0].ID == "MessageEntityCode" or msg.content_.entities_[0].ID == "MessageEntityPre" or msg.content_.entities_[0].ID == "MessageEntityItalic" then
                return false
              else
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
              end
            end
            if text:match("[Hh][Tt][Tt][Pp][Ss]://") or text:match("[Hh][Tt][Tt][Pp]://") or text:match(".[Ii][Rr]") or text:match(".[Cc][Oo][Mm]") or text:match(".[Oo][Rr][Gg]") or text:match(".[Ii][Nn][Ff][Oo]") or text:match("[Ww][Ww][Ww].") or text:match(".[Tt][Kk]") then
              if db:get('bot:webpage:mute'..msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [Web] [Text] [NS68]")
              end
            end
            if text:match("[\216-\219][\128-\191]") then
              if db:get('bot:arabic:mute'..msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [Farsi] [Text] [NS69]")
              end
            end
            if text then
              local _nl, ctrl_chars = string.gsub(text, '%c', '')
              local _nl, real_digits = string.gsub(text, '%d', '')
              local id = msg.id_
              local msgs = {[0] = id}
              local chat = msg.chat_id_
              local hash = 'bot:sens:spam'..msg.chat_id_
              if not db:get(hash) then
                sens = 100
              else
                sens = tonumber(db:get(hash))
              end
              if db:get('bot:spam:mute'..msg.chat_id_) and string.len(text) > (sens) or ctrl_chars > (sens) or real_digits > (sens) then
                delete_msg(chat,msgs)
                print("Deleted [Lock] [Spam] [NS70]")
              end
            end
            if text:match("[ASDFGHJKLQWERTYUIOPZXCVBNMasdfghjklqwertyuiopzxcvbnm]") then
              if db:get('bot:english:mute'..msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                local chat = msg.chat_id_
                delete_msg(chat,msgs)
                print("Deleted [Lock] [English] [Text] [NS63]")
              end
            end
          end

          -------------------------------------------------------------------------------------------------------
          -------------------------------------------------------------------------------------------------------
          -------------------------------------------------------------------------------------------------------
          ---------------------------******** END MSG CHECKS ********--------------------------------------------
          -------------------------------------------------------------------------------------------------------
          -------------------------------------------------------------------------------------------------------
          if db:get('bot:cmds'..msg.chat_id_) and not is_mod(msg.sender_user_id_, msg.chat_id_) then
            return ""
          else
            ------------------------------------ With Pattern -------------------------------------------
            if text:match("^[Pp]ing$") then
              send(msg.chat_id_, msg.id_, 1, 'البوت فعال', 1, 'md')
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Ll]eave$") and is_admin(msg.sender_user_id_, msg.chat_id_) then
              chat_leave(msg.chat_id_, bot_id)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Pp]romote$") and is_owner(msg.sender_user_id_, msg.chat_id_) and msg.reply_to_message_id_ then
              function promote_by_reply(extra, result, success)
                local hash = 'bot:mods:'..msg.chat_id_
                if db:sismember(hash, result.sender_user_id_) then
                  send(msg.chat_id_, msg.id_, 1, '👤معرف المستخدم : '..result.sender_user_id_..' انه بالفعل مدير !', 1, 'md')
                else
                  db:sadd(hash, result.sender_user_id_)
                  send(msg.chat_id_, msg.id_, 1, '👤 معرف المستخدم : '..result.sender_user_id_..' تم رفعه مدير !', 1, 'md')
                end
              end
              getMessage(msg.chat_id_, msg.reply_to_message_id_,promote_by_reply)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Pp]romote @(.*)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
              local ap = {string.match(text, "^([Pp]romote) @(.*)$")}
              function promote_by_username(extra, result, success)
                if result.id_ then
                  db:sadd('bot:mods:'..msg.chat_id_, result.id_)
                  texts = '👤 معرف المستخدم : '..result.id_..' تم رفعه مدير !'
                else
                  texts = 'لم يتم العثور على المستخدم ❌'
                end
                send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
              end
              resolve_username(ap[2],promote_by_username)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Pp]romote (%d+)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
              local ap = {string.match(text, "^([Pp]romote) (%d+)$")}
              db:sadd('bot:mods:'..msg.chat_id_, ap[2])
              send(msg.chat_id_, msg.id_, 1, '👤 معرف المستخدم: '..ap[2]..' تم رفع مدير !', 1, 'md')
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Dd]emote$") and is_owner(msg.sender_user_id_, msg.chat_id_) and msg.reply_to_message_id_ then
              function demote_by_reply(extra, result, success)
                local hash = 'bot:mods:'..msg.chat_id_
                if not db:sismember(hash, result.sender_user_id_) then
                  send(msg.chat_id_, msg.id_, 1, '👤 معرف المستخدم : '..result.sender_user_id_..' ليس مدير !', 1, 'md')
                else
                  db:srem(hash, result.sender_user_id_)
                  send(msg.chat_id_, msg.id_, 1, '👤 معرف المستخدم : '..result.sender_user_id_..' تمت إزالته من الإدارة !', 1, 'md')
                end
              end
              getMessage(msg.chat_id_, msg.reply_to_message_id_,demote_by_reply)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Dd]emote @(.*)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
              local hash = 'bot:mods:'..msg.chat_id_
              local ap = {string.match(text, "^([Dd]emote) @(.*)$")}
              function demote_by_username(extra, result, success)
                if result.id_ then
                  db:srem(hash, result.id_)
                  texts = '👤 معرف المستخدم : '..result.id_..' عزل مقام شد'
                else
                  texts = 'لم يتم العثور على المستخدم ❌'
                end
                send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
              end
              resolve_username(ap[2],demote_by_username)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Dd]emote (%d+)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
              local hash = 'bot:mods:'..msg.chat_id_
              local ap = {string.match(text, "^([Dd]emote) (%d+)$")}
              db:srem(hash, ap[2])
              send(msg.chat_id_, msg.id_, 1, '👤 معرف المستخدم : '..ap[2]..' عزل مقام شد !', 1, 'md')
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Gg]p id$") then
              local text = "🔹معرف المجموعة : "..msg.chat_id_
              send(msg.chat_id_, msg.id_, 1, text, 1, 'md')
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Mm]y id$") then
              local text = "🔹معرف المجموعة  : "..msg.sender_user_id_
              send(msg.chat_id_, msg.id_, 1, text, 1, 'md')
            end
            -----------------------------------------------------------------------------------------------

            if text:match("^[Dd]el$") and is_sudo(msg) and msg.reply_to_message_id_ ~= 0 then
              local id = msg.id_
              local msgs = {[0] = id}
              delete_msg(msg.chat_id_,{[0] = msg.reply_to_message_id_})
              delete_msg(msg.chat_id_,msgs)
            end
            ----------------------------------------------------------------------------------------------
            if text:match("^[Bb]an$") and is_mod(msg.sender_user_id_, msg.chat_id_) and msg.reply_to_message_id_ then
              function ban_by_reply(extra, result, success)
                local hash = 'bot:banned:'..msg.chat_id_
                if is_mod(result.sender_user_id_, result.chat_id_) then
                  send(msg.chat_id_, msg.id_, 1, 'لا يمكنك منع المديرين !', 1, 'md')
                else
                  if db:sismember(hash, result.sender_user_id_) then
                    send(msg.chat_id_, msg.id_, 1, '👤 معرف المستخدم : '..result.sender_user_id_..' محظور حاليا !', 1, 'md')
                    chat_kick(result.chat_id_, result.sender_user_id_)
                  else
                    db:sadd(hash, result.sender_user_id_)
                    send(msg.chat_id_, msg.id_, 1, '👤 معرف المستخد : '..result.sender_user_id_..' العضو محظور !', 1, 'md')
                    chat_kick(result.chat_id_, result.sender_user_id_)
                  end
                end
              end
              getMessage(msg.chat_id_, msg.reply_to_message_id_,ban_by_reply)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Bb]an @(.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
              local ap = {string.match(text, "^([Bb]an) @(.*)$")}
              function ban_by_username(extra, result, success)
                if result.id_ then
                  if is_mod(result.id_, msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, 'لا يمكنك منع المديرين !', 1, 'md')
                  else
                    db:sadd('bot:banned:'..msg.chat_id_, result.id_)
                    texts = '👤 معرف المستخدم : '..result.id_..' تم حظره !'
                    chat_kick(msg.chat_id_, result.id_)
                  end
                else
                  texts = '> لم يتم العثور على المستخدم !'
                end
                send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
              end
              resolve_username(ap[2],ban_by_username)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Bb]an (%d+)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
              local ap = {string.match(text, "^([Bb]an) (%d+)$")}
              if is_mod(ap[2], msg.chat_id_) then
                send(msg.chat_id_, msg.id_, 1, 'لا يمكنك منع المديرين !', 1, 'md')
              else
                db:sadd('bot:banned:'..msg.chat_id_, ap[2])
                chat_kick(msg.chat_id_, ap[2])
                send(msg.chat_id_, msg.id_, 1, '👤 معرف المستخدم : '..ap[2]..' تم حظره !', 1, 'md')
              end
            end
            ---------------------------------------Ban ALL-------------------------------------------------
            if text:match("^[Bb]anall$") and is_sudo(msg) and msg.reply_to_message_id_ then
              function ban_by_reply(extra, result, success)
                local hash = 'bot:gbanned:'
                if is_mod(result.sender_user_id_, result.chat_id_) then
                  send(msg.chat_id_, msg.id_, 1, 'لا يمكنك منع المديرين !', 1, 'md')
                else
                  if db:sismember(hash, result.sender_user_id_) then
                    send(msg.chat_id_, msg.id_, 1, '👤 معرف المستخدم : '..result.sender_user_id_..' تم حظره بشكل عام !', 1, 'md')
                    chat_kick(result.chat_id_, result.sender_user_id_)
                  else
                    db:sadd(hash, result.sender_user_id_)
                    send(msg.chat_id_, msg.id_, 1, '👤 معرف المستخدم : '..result.sender_user_id_..' تم حظره بشكل عام !', 1, 'md')
                    chat_kick(result.chat_id_, result.sender_user_id_)
                  end
                end
              end
              getMessage(msg.chat_id_, msg.reply_to_message_id_,ban_by_reply)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Bb]anall @(.*)$") and is_sudo(msg) then
              local ap = {string.match(text, "^([Bb]anall) @(.*)$")}
              function ban_by_username(extra, result, success)
                if result.id_ then
                  if is_mod(result.id_, msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, 'لا يمكنك منع المديرين !', 1, 'md')
                  else
                    db:sadd('bot:gbanned:',result.id_)
                    chat_kick(msg.chat_id_, result.id_)
                    texts = '👤 کاربر با شناسه : '..result.id_..' ااا !'
                    chat_kick(msg.chat_id_, result.id_)
                  end
                else
                  texts = '> تم حظره بشكل عام !'
                end
                send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
              end
              resolve_username(ap[2],ban_by_username)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Bb]anall (%d+)$") and is_sudo(msg) then
              local ap = {string.match(text, "^([Bb]anall) (%d+)$")}
              if is_mod(ap[2], msg.chat_id_) then
                send(msg.chat_id_, msg.id_, 1, 'لايمكن منع مدراء !', 1, 'md')
              else
                db:sadd('bot:gbanned:',ap[2])
                send(msg.chat_id_, msg.id_, 1,' معرف المستخدم : '..ap[2]..' تم حظره !', 1, 'md')
              end
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Dd]elall$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
              if msg.reply_to_message_id_ then
                function delall_by_reply(extra, result, success)
                  del_all_msgs(result.chat_id_, result.sender_user_id_)
                  local id = msg.id_
                  local msgs = {[0] = id}
                  local chat = msg.chat_id_
                  delete_msg(chat,msgs)
                end
                getMessage(msg.chat_id_, msg.reply_to_message_id_,delall_by_reply)
              end
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Dd]elall (%d+)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
              local ass = {string.match(text, "^([Dd]elall) (%d+)$")}
              if is_mod(ass[2], msg.chat_id_) then
                send(msg.chat_id_, msg.id_, 1, 'لا يمكنك حذف رسالة الادارة ❌', 1, 'md')
              else
                del_all_msgs(msg.chat_id_, ass[2])
                send(msg.chat_id_, msg.id_, 1, 'تمامی پیام های ارسالی کاربر با شناسه : '..ass[2]..' حذف شد 🗑', 1, 'html')
              end
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Dd]elall @(.*)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
              local ap = {string.match(text, "^([Dd]elall) @(.*)$")}
              function delall_by_username(extra, result, success)
                if result.id_ then
                  if is_mod(result.id_, msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, 'شما نمیتوانید پیام مدیران را حذف کنید ❌', 1, 'md')
                    return false
                  end
                  del_all_msgs(msg.chat_id_, result.id_)
                  text = 'تمامی پیام های ارسالی کاربر با شناسه : '..result.id_..' حذف شد 🗑'
                else
                  text = 'کاربر یافت نشد ❌'
                end
                send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
              end
              resolve_username(ap[2],delall_by_username)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Uu]nban$") and is_mod(msg.sender_user_id_, msg.chat_id_) and msg.reply_to_message_id_ then
              function unban_by_reply(extra, result, success)
                local hash = 'bot:banned:'..msg.chat_id_
                if not db:sismember(hash, result.sender_user_id_) then
                  send(msg.chat_id_, msg.id_, 1, '👤 کاربر با شناسه : '..result.sender_user_id_..' مسدود نیست !', 1, 'md')
                else
                  db:srem(hash, result.sender_user_id_)
                  send(msg.chat_id_, msg.id_, 1, '👤 کاربر با شناسه : '..result.sender_user_id_..' آزاد شد !', 1, 'md')
                end
              end
              getMessage(msg.chat_id_, msg.reply_to_message_id_,unban_by_reply)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Uu]nban @(.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
              local ap = {string.match(text, "^([Uu]nban) @(.*)$")}
              function unban_by_username(extra, result, success)
                if result.id_ then
                  db:srem('bot:banned:'..msg.chat_id_, result.id_)
                  text = '👤 کاربر با شناسه : '..result.id_..' آزاد شد !'
                else
                  text = 'کاربر یافت نشد ❌'
                end
                send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
              end
              resolve_username(ap[2],unban_by_username)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Uu]nban (%d+)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
              local ap = {string.match(text, "^([Uu]nban) (%d+)$")}
              db:srem('bot:banned:'..msg.chat_id_, ap[2])
              send(msg.chat_id_, msg.id_, 1, '👤 کاربر با شناسه : '..ap[2]..' آزاد شد !', 1, 'md')
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Mm]uteuser$") and is_mod(msg.sender_user_id_, msg.chat_id_) and msg.reply_to_message_id_ then
              function mute_by_reply(extra, result, success)
                local hash = 'bot:muted:'..msg.chat_id_
                if is_mod(result.sender_user_id_, result.chat_id_) then
                  send(msg.chat_id_, msg.id_, 1, 'شما نمیتوانید مدیران را بی صدا کنید ❌', 1, 'md')
                else
                  if db:sismember(hash, result.sender_user_id_) then
                    send(msg.chat_id_, msg.id_, 1, '👤کاربر با شناسه : '..result.sender_user_id_..' هم اکنون بی صدا است !', 1, 'md')
                  else
                    db:sadd(hash, result.sender_user_id_)
                    send(msg.chat_id_, msg.id_, 1, '👤کاربر با شناسه : '..result.sender_user_id_..' بی صدا گردید !', 1, 'md')
                  end
                end
              end
              getMessage(msg.chat_id_, msg.reply_to_message_id_,mute_by_reply)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Mm]uteuser @(.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
              local ap = {string.match(text, "^([Mm]uteuser) @(.*)$")}
              function mute_by_username(extra, result, success)
                if result.id_ then
                  if is_mod(result.id_, msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, 'شما نمیتوانید مدیران را بی صدا کنید ❌', 1, 'md')
                  else
                    db:sadd('bot:muted:'..msg.chat_id_, result.id_)
                    texts = '👤کاربر با شناسه : '..result.id_..' بی صدا گردید !'
                    chat_kick(msg.chat_id_, result.id_)
                  end
                else
                  texts = 'کاربر یافت نشد ❌'
                end
                send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
              end
              resolve_username(ap[2],mute_by_username)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Mm]uteuser (%d+)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
              local ap = {string.match(text, "^([Mm]uteuser) (%d+)$")}
              if is_mod(ap[2], msg.chat_id_) then
                send(msg.chat_id_, msg.id_, 1, 'شما نمیتوانید مدیران را بی صدا کنید ❌', 1, 'md')
              else
                db:sadd('bot:muted:'..msg.chat_id_, ap[2])
                send(msg.chat_id_, msg.id_, 1, '👤کاربر با شناسه : '..ap[2]..' بی صدا گردید !', 1, 'md')
              end
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Uu]nmuteuser$") and is_mod(msg.sender_user_id_, msg.chat_id_) and msg.reply_to_message_id_ then
              function unmute_by_reply(extra, result, success)
                local hash = 'bot:muted:'..msg.chat_id_
                if not db:sismember(hash, result.sender_user_id_) then
                  send(msg.chat_id_, msg.id_, 1, '👤کاربر با شناسه : '..result.sender_user_id_..' بی صدا نیست !', 1, 'md')
                else
                  db:srem(hash, result.sender_user_id_)
                  send(msg.chat_id_, msg.id_, 1, '👤کاربر با شناسه : '..result.sender_user_id_..' از حالت بی صدا خارج گردید !', 1, 'md')
                end
              end
              getMessage(msg.chat_id_, msg.reply_to_message_id_,unmute_by_reply)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Uu]nmuteuser @(.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
              local ap = {string.match(text, "^([Uu]nmuteuser) @(.*)$")}
              function unmute_by_username(extra, result, success)
                if result.id_ then
                  db:srem('bot:muted:'..msg.chat_id_, result.id_)
                  text = '👤کاربر با شناسه : '..result.id_..' از حالت بی صدا خارج گردید !'
                else
                  text = 'کاربر یافت نشد ❌'
                end
                send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
              end
              resolve_username(ap[2],unmute_by_username)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Uu]nmuteuser (%d+)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
              local ap = {string.match(text, "^([Uu]nmuteuser) (%d+)$")}
              db:srem('bot:muted:'..msg.chat_id_, ap[2])
              send(msg.chat_id_, msg.id_, 1, '👤کاربر با شناسه : '..ap[2]..' از حالت بی صدا خارج گردید !', 1, 'md')
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Ss]etowner$") and is_admin(msg.sender_user_id_) and msg.reply_to_message_id_ then
              function setowner_by_reply(extra, result, success)
                local hash = 'bot:owners:'..msg.chat_id_
                if db:sismember(hash, result.sender_user_id_) then
                  send(msg.chat_id_, msg.id_, 1, '👤 کاربر '..result.sender_user_id_..' هم اکنون صاحب گروه میباشد !', 1, 'md')
                else
                  db:sadd(hash, result.sender_user_id_)
                  send(msg.chat_id_, msg.id_, 1, '👤 کاربر '..result.sender_user_id_..' به عنوان صاحب گروه انتخاب شد !', 1, 'md')
                end
              end
              getMessage(msg.chat_id_, msg.reply_to_message_id_,setowner_by_reply)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Ss]etowner @(.*)$") and is_admin(msg.sender_user_id_, msg.chat_id_) then
              local ap = {string.match(text, "^([Ss]etowner) @(.*)$")}
              function setowner_by_username(extra, result, success)
                if result.id_ then
                  db:sadd('bot:owners:'..msg.chat_id_, result.id_)
                  texts = '👤 کاربر '..result.id_..' به عنوان صاحب گروه انتخاب شد !'
                else
                  texts = 'کاربر یافت نشد ❌'
                end
                send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
              end
              resolve_username(ap[2],setowner_by_username)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Ss]etowner (%d+)$") and is_admin(msg.sender_user_id_, msg.chat_id_) then
              local ap = {string.match(text, "^([Ss]etowner) (%d+)$")}
              db:sadd('bot:owners:'..msg.chat_id_, ap[2])
              send(msg.chat_id_, msg.id_, 1, '👤 کاربر '..ap[2]..' به عنوان صاحب گروه انتخاب شد !', 1, 'md')
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Dd]emowner$") and is_admin(msg.sender_user_id_) and msg.reply_to_message_id_ then
              function deowner_by_reply(extra, result, success)
                local hash = 'bot:owners:'..msg.chat_id_
                if not db:sismember(hash, result.sender_user_id_) then
                  send(msg.chat_id_, msg.id_, 1, '👤 کاربر : '..result.sender_user_id_..' صاحب گروه نیست !', 1, 'md')
                else
                  db:srem(hash, result.sender_user_id_)
                  send(msg.chat_id_, msg.id_, 1, '👤 کاربر : '..result.sender_user_id_..' از مقام صاحب گروه حذف شد !', 1, 'md')
                end
              end
              getMessage(msg.chat_id_, msg.reply_to_message_id_,deowner_by_reply)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Dd]emowner @(.*)$") and is_admin(msg.sender_user_id_, msg.chat_id_) then
              local hash = 'bot:owners:'..msg.chat_id_
              local ap = {string.match(text, "^([Dd]emowner) @(.*)$")}
              function remowner_by_username(extra, result, success)
                if result.id_ then
                  db:srem(hash, result.id_)
                  texts = '👤 کاربر : '..result.id_..' از مقام صاحب گروه حذف شد !'
                else
                  texts = 'کاربر یافت نشد ❌'
                end
                send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
              end
              resolve_username(ap[2],remowner_by_username)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Dd]emowner (%d+)$") and is_admin(msg.sender_user_id_, msg.chat_id_) then
              local hash = 'bot:owners:'..msg.chat_id_
              local ap = {string.match(text, "^([Dd]emowner) (%d+)$")}
              db:srem(hash, ap[2])
              send(msg.chat_id_, msg.id_, 1, '👤 کاربر : '..ap[2]..' از مقام صاحب گروه حذف شد !', 1, 'md')
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Aa]ddadmin$") and is_sudo(msg) and msg.reply_to_message_id_ then
              function addadmin_by_reply(extra, result, success)
                local hash = 'bot:admins:'
                if db:sismember(hash, result.sender_user_id_) then
                  send(msg.chat_id_, msg.id_, 1, '👤 کاربر : '..result.sender_user_id_..' هم اکنون ادمین است !', 1, 'md')
                else
                  db:sadd(hash, result.sender_user_id_)
                  send(msg.chat_id_, msg.id_, 1, '👤 کاربر : '..result.sender_user_id_..' به ادمین ها اضافه شد !', 1, 'md')
                end
              end
              getMessage(msg.chat_id_, msg.reply_to_message_id_,addadmin_by_reply)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Aa]ddadmin @(.*)$") and is_sudo(msg) then
              local ap = {string.match(text, "^([Aa]ddadmin) @(.*)$")}
              function addadmin_by_username(extra, result, success)
                if result.id_ then
                  db:sadd('bot:admins:', result.id_)
                  texts = '👤 کاربر : '..result.id_..' به ادمین ها اضافه شد !'
                else
                  texts = 'کاربر یافت نشد ❌'
                end
                send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
              end
              resolve_username(ap[2],addadmin_by_username)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Aa]ddadmin (%d+)$") and is_sudo(msg) then
              local ap = {string.match(text, "^([Aa]ddadmin) (%d+)$")}
              db:sadd('bot:admins:', ap[2])
              send(msg.chat_id_, msg.id_, 1, '👤 کاربر : '..ap[2]..' به ادمین ها اضافه شد !', 1, 'md')
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Rr]emadmin$") and is_sudo(msg) and msg.reply_to_message_id_ then
              function deadmin_by_reply(extra, result, success)
                local hash = 'bot:admins:'
                if not db:sismember(hash, result.sender_user_id_) then
                  send(msg.chat_id_, msg.id_, 1, '👤 کاربر : '..result.sender_user_id_..' ادمین نیست !', 1, 'md')
                else
                  db:srem(hash, result.sender_user_id_)
                  send(msg.chat_id_, msg.id_, 1, '👤 کاربر : '..result.sender_user_id_..' از ادمینی حذف شد !', 1, 'md')
                end
              end
              getMessage(msg.chat_id_, msg.reply_to_message_id_,deadmin_by_reply)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Rr]emadmin @(.*)$") and is_sudo(msg) then
              local hash = 'bot:admins:'
              local ap = {string.match(text, "^([Rr]emadmin) @(.*)$")}
              function remadmin_by_username(extra, result, success)
                if result.id_ then
                  db:srem(hash, result.id_)
                  texts = '👤 کاربر : '..result.id_..' از ادمینی حذف شد !'
                else
                  texts = 'کاربر یافت نشد ❌'
                end
                send(msg.chat_id_, msg.id_, 1, texts, 1, 'html')
              end
              resolve_username(ap[2],remadmin_by_username)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Rr]emadmin (%d+)$") and is_sudo(msg) then
              local hash = 'bot:admins:'
              local ap = {string.match(text, "^([Rr]emadmin) (%d+)$")}
              db:srem(hash, ap[2])
              send(msg.chat_id_, msg.id_, 1, '👤 کاربر : '..ap[2]..' از ادمینی حذف شد !', 1, 'md')
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Mm]odlist$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
              local hash =  'bot:mods:'..msg.chat_id_
              local list = db:smembers(hash)
              local text = "👥 لیست مدیران گروه : \n\n"
              for k,v in pairs(list) do
                local user_info = db:hgetall('user:'..v)
                if user_info and user_info.username then
                  local username = user_info.username
                  text = text..k.." - @"..username.." ["..v.."]\n"
                else
                  text = text..k.." - "..v.."\n"
                end
              end
              if #list == 0 then
                text = "👥 لیست مدیران خالی است !"
              end
              send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Mm]utelist$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
              local hash =  'bot:muted:'..msg.chat_id_
              local list = db:smembers(hash)
              local text = "🔇 لیست افراد بی صدا : \n\n"
              for k,v in pairs(list) do
                local user_info = db:hgetall('user:'..v)
                if user_info and user_info.username then
                  local username = user_info.username
                  text = text..k.." - @"..username.." ["..v.."]\n"
                else
                  text = text..k.." - "..v.."\n"
                end
              end
              if #list == 0 then
                text = "🔇 لیست افراد بی صدا خالی است ! "
              end
              send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Oo]wner$") or text:match("^[Oo]wnerlist$") and is_sudo(msg) then
              local hash =  'bot:owners:'..msg.chat_id_
              local list = db:smembers(hash)
              local text = "👤 لیست صاحبان گروه : \n\n"
              for k,v in pairs(list) do
                local user_info = db:hgetall('user:'..v)
                if user_info and user_info.username then
                  local username = user_info.username
                  text = text..k.." - @"..username.." ["..v.."]\n"
                else
                  text = text..k.." - "..v.."\n"
                end
              end
              if #list == 0 then
                text = "👤 لیست صاحبان گروه خالی است !"
              end
              send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Bb]anlist$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
              local hash =  'bot:banned:'..msg.chat_id_
              local list = db:smembers(hash)
              local text = "📛 لیست افراد مسدود شده : \n\n"
              for k,v in pairs(list) do
                local user_info = db:hgetall('user:'..v)
                if user_info and user_info.username then
                  local username = user_info.username
                  text = text..k.." - @"..username.." ["..v.."]\n"
                else
                  text = text..k.." - "..v.."\n"
                end
              end
              if #list == 0 then
                text = "📛 لیست افراد مسدود شده خالی است !"
              end
              send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Aa]dminlist$") and is_leader(msg) then
              local hash =  'bot:admins:'
              local list = db:smembers(hash)
              local text = "👥 لیست ادمین ها :\n\n"
              for k,v in pairs(list) do
                local user_info = db:hgetall('user:'..v)
                if user_info and user_info.username then
                  local username = user_info.username
                  text = text..k.." - @"..username.." ["..v.."]\n"
                else
                  text = text..k.." - "..v.."\n"
                end
              end
              if #list == 0 then
                text = "👥 لیست ادمین ها خالی است !"
              end
              send(msg.chat_id_, msg.id_, 1, text, 'html')
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Ii]d$") and msg.reply_to_message_id_ ~= 0 then
              function id_by_reply(extra, result, success)
                local user_msgs = db:get('user:msgs'..result.chat_id_..':'..result.sender_user_id_)
                send(msg.chat_id_, msg.id_, 1, "🔹شناسه کاربر : "..result.sender_user_id_.."\n🔸تعداد پیام های ارسالی  : "..user_msgs, 1, 'md')
              end
              getMessage(msg.chat_id_, msg.reply_to_message_id_,id_by_reply)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Ii]d @(.*)$") then
              local ap = {string.match(text, "^([Ii]d) @(.*)$")}
              function id_by_username(extra, result, success)
                if result.id_ then
                  if is_sudo(result) then
                    t = '⭐️ مدیر ربات ⭐️'
                  elseif is_admin(result.id_) then
                    t = '⭐️ ادمین ربات ⭐️'
                  elseif is_owner(result.id_, msg.chat_id_) then
                    t = '👤 صاحب گروه 👤'
                  elseif is_mod(result.id_, msg.chat_id_) then
                    t = '👥 مدیر گروه 👥'
                  else
                    t = '🔅 کاربر 🔅'
                  end
                  texts = '🔹 یوزرنیم : @'..ap[2]..'\n🔸 شناسه : ('..result.id_..')\n 🔹 مقام : '..t
                else
                  texts = 'کاربر یافت نشد ❌'
                end
                send(msg.chat_id_, msg.id_, 1, texts, 1, 'md')
              end
              resolve_username(ap[2],id_by_username)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Kk]ick$") and msg.reply_to_message_id_ and is_mod(msg.sender_user_id_, msg.chat_id_) then
              function kick_reply(extra, result, success)
                if is_mod(result.sender_user_id_, result.chat_id_) then
                  send(msg.chat_id_, msg.id_, 1, '❌شما نمیتوانید مدیران را مسدود یا اخراج کنید !', 1, 'md')
                else
                  send(msg.chat_id_, msg.id_, 1, '👤کاربر با شناسه : '..result.sender_user_id_..' اخراج شد !', 1, 'html')
                  chat_kick(result.chat_id_, result.sender_user_id_)
                end
              end
              getMessage(msg.chat_id_,msg.reply_to_message_id_,kick_reply)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Ii]nvite$") and msg.reply_to_message_id_ and is_sudo(msg) then
              function inv_reply(extra, result, success)
                add_user(result.chat_id_, result.sender_user_id_, 5)
              end
              getMessage(msg.chat_id_, msg.reply_to_message_id_,inv_reply)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Ii]d$") and msg.reply_to_message_id_ == 0  then
              local user_msgs = db:get('user:msgs'..msg.chat_id_..':'..msg.sender_user_id_)
              local function getpro(extra, result, success)
                if db:get('getidstatus'..msg.chat_id_) == "Photo" then
                  if result.photos_[0] then
                    sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[0].sizes_[1].photo_.persistent_id_,'🔸شناسه شما : '..msg.sender_user_id_..'\n🔹تعداد پیام های ارسالی شما : '..user_msgs,msg.id_,msg.id_)
                  end
                elseif not result.photos_[0] then
                  send(msg.chat_id_, msg.id_, 1, "❌ شما عکس پروفایل ندارید !\n\n🔸شناسه شما : "..msg.sender_user_id_.."\n🔹تعداد پیام های ارسالی شما : "..user_msgs, 1, 'md')
                end
              end
              if db:get('getidstatus'..msg.chat_id_) == "Simple" then
                send(msg.chat_id_, msg.id_, 1, "🔸شناسه شما : "..msg.sender_user_id_.."\n🔹تعداد پیام های ارسالی شما : "..user_msgs, 1, 'md')
              end
              if not db:get('getidstatus'..msg.chat_id_) then
                send(msg.chat_id_, msg.id_, 1, "🔸شناسه شما : "..msg.sender_user_id_.."\n🔹تعداد پیام های ارسالی شما : "..user_msgs, 1, 'md')
              end
              tdcli_function ({
                ID = "GetUserProfilePhotos",
                user_id_ = msg.sender_user_id_,
                offset_ = 0,
                limit_ = 1
              }, getpro, nil)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Gg]etpro (%d+)$") and msg.reply_to_message_id_ == 0  then
              local pronumb = {string.match(text, "^([Gg]etpro) (%d+)$")}
              local function gpro(extra, result, success)
                --vardump(result)
                if pronumb[2] == '1' then
                  if result.photos_[0] then
                    sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[0].sizes_[1].photo_.persistent_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, "شما عکس پروفایل ندارید", 1, 'md')
                  end
                elseif pronumb[2] == '2' then
                  if result.photos_[1] then
                    sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[1].sizes_[1].photo_.persistent_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, "شما 2 عکس پروفایل ندارید", 1, 'md')
                  end
                elseif pronumb[2] == '3' then
                  if result.photos_[2] then
                    sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[2].sizes_[1].photo_.persistent_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, "شما 3 عکس پروفایل ندارید", 1, 'md')
                  end
                elseif pronumb[2] == '4' then
                  if result.photos_[3] then
                    sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[3].sizes_[1].photo_.persistent_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, "شما 4 عکس پروفایل ندارید", 1, 'md')
                  end
                elseif pronumb[2] == '5' then
                  if result.photos_[4] then
                    sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[4].sizes_[1].photo_.persistent_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, "شما 5 عکس پروفایل ندارید", 1, 'md')
                  end
                elseif pronumb[2] == '6' then
                  if result.photos_[5] then
                    sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[5].sizes_[1].photo_.persistent_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, "شما 6 عکس پروفایل ندارید", 1, 'md')
                  end
                elseif pronumb[2] == '7' then
                  if result.photos_[6] then
                    sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[6].sizes_[1].photo_.persistent_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, "شما 7 عکس پروفایل ندارید", 1, 'md')
                  end
                elseif pronumb[2] == '8' then
                  if result.photos_[7] then
                    sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[7].sizes_[1].photo_.persistent_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, "شما 8 عکس پروفایل ندارید", 1, 'md')
                  end
                elseif pronumb[2] == '9' then
                  if result.photos_[8] then
                    sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[8].sizes_[1].photo_.persistent_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, "شما 9 عکس پروفایل ندارید", 1, 'md')
                  end
                elseif pronumb[2] == '10' then
                  if result.photos_[9] then
                    sendPhoto(msg.chat_id_, msg.id_, 0, 1, nil, result.photos_[9].sizes_[1].photo_.persistent_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, "شما 10 عکس پروفایل ندارید", 1, 'md')
                  end
                else
                  send(msg.chat_id_, msg.id_, 1, "من فقط میتواند 10 عکس آخر را نمایش دهم", 1, 'md')
                end
              end
              tdcli_function ({
                ID = "GetUserProfilePhotos",
                user_id_ = msg.sender_user_id_,
                offset_ = 0,
                limit_ = pronumb[2]
              }, gpro, nil)
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Ll]ock (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
              local lockpt = {string.match(text, "^([Ll]ock) (.*)$")}
              if lockpt[2] == "edit" then
                if not db:get('editmsg'..msg.chat_id_) then
                  send(msg.chat_id_, msg.id_, 1, '> قفل ویرایش پیام #فعال شد ! ', 1, 'md')
                  db:set('editmsg'..msg.chat_id_,true)
                else
                  send(msg.chat_id_, msg.id_, 1, '> قفل ویرایش پیام از قبل #فعال است ! ', 1, 'md')
                end
              end
              if lockpt[2] == "cmd" then
                if not db:get('bot:cmds'..msg.chat_id_) then
                  send(msg.chat_id_, msg.id_, 1, '> حالت عدم جواب #فعال شد ! ', 1, 'md')
                  db:set('bot:cmds'..msg.chat_id_,true)
                else
                  send(msg.chat_id_, msg.id_, 1, '> حالت عدم جواب از قبل #فعال است ! ', 1, 'md')
                end
              end
              if lockpt[2] == "bots" then
                if not db:get('bot:bots:mute'..msg.chat_id_) then
                  send(msg.chat_id_, msg.id_, 1, '> قفل ورود ربات #فعال شد ! ', 1, 'md')
                  db:set('bot:bots:mute'..msg.chat_id_,true)
                else
                  send(msg.chat_id_, msg.id_, 1, '> قفل ورود ربات از قبل #فعال است ! ', 1, 'md')
                end
              end
              if lockpt[2] == "flood" then
                if not db:get('anti-flood:'..msg.chat_id_) then
                  send(msg.chat_id_, msg.id_, 1, '> قفل فلود #فعال شد ! ', 1, 'md')
                  db:set('anti-flood:'..msg.chat_id_,true)
                else
                  send(msg.chat_id_, msg.id_, 1, '> قفل فلود از قبل #فعال است ! ', 1, 'md')
                end
              end
              if lockpt[2] == "pin" then
                if not db:get('bot:pin:mute'..msg.chat_id_) then
                  send(msg.chat_id_, msg.id_, 1, "> قفل سنجاق پیام #فعال شد ! ", 1, 'md')
                  db:set('bot:pin:mute'..msg.chat_id_,true)
                else
                  send(msg.chat_id_, msg.id_, 1, "> قفل سنجاق پیام از قبل #فعال است ! ", 1, 'md')
                end
              end
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Ss]etflood (%d+)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
              local floodmax = {string.match(text, "^([Ss]etflood) (%d+)$")}
              if tonumber(floodmax[2]) < 2 then
                send(msg.chat_id_, msg.id_, 1, '🔺 عددی بزرگتر از 2 وارد کنید !', 1, 'md')
              else
                db:set('flood:max:'..msg.chat_id_,floodmax[2])
                send(msg.chat_id_, msg.id_, 1, '✳️ حساسیت فلود تنظیم شد به : '..floodmax[2], 1, 'md')
              end
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Ss]etstatus (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
              local status = {string.match(text, "^([Ss]etstatus) (.*)$")}
              if status[2] == "kick" then
                if db:get('floodstatus'..msg.chat_id_) == "Kicked" then
                  send(msg.chat_id_, msg.id_, 1, '>وضعیت فلود از قبل بر روی حالت #اخراج میباشد ! ', 1, 'md')
                else
                  send(msg.chat_id_, msg.id_, 1, '>وضعیت فلود بر روی حالت #اخراج تنظیم شد ! ', 1, 'md')

                  db:set('floodstatus'..msg.chat_id_,'Kicked')
                end
              end
              if status[2] == "del" then
                if db:get('floodstatus'..msg.chat_id_) == "DelMsg" then
                  send(msg.chat_id_, msg.id_, 1, '>وضعیت فلود از قبل بر روی حالت #حذف پیام میباشد !  ', 1, 'md')
                else
                  send(msg.chat_id_, msg.id_, 1, '>وضعیت فلود بر روی حالت #حذف پیام تنظیم شد ! ', 1, 'md')
                  db:set('floodstatus'..msg.chat_id_,'DelMsg')
                end
              end
            end
            -----------------------------------------------------------------------------------------------
            if text:match("^[Gg]etidstatus (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
              local status = {string.match(text, "^([Gg]etidstatus) (.*)$")}
              if status[2] == "photo" then
                if db:get('getidstatus'..msg.chat_id_) == "Photo" then
                  send(msg.chat_id_, msg.id_, 1, '>وضعیت دریافت آیدی از قبل بر روی حالت #ساده میباشد ! ', 1, 'md')
                else
                  send(msg.chat_id_, msg.id_, 1, '>وضعیت دریافت آیدی بر روی حالت #عکس تنظیم شد ! ', 1, 'md')
                  db:set('getidstatus'..msg.chat_id_,'Photo')
                end
              end
              if status[2] == "simple" then
                if db:get('getidstatus'..msg.chat_id_) == "Simple" then
                  send(msg.chat_id_, msg.id_, 1, '>وضعیت فلود از قبل بر روی حالت #حذف پیام میباشد !  ', 1, 'md')
                else
                  send(msg.chat_id_, msg.id_, 1, '>وضعیت دریافت آیدی بر روی حالت #ساده تنظیم شد ! ', 1, 'md')
                  db:set('getidstatus'..msg.chat_id_,'Simple')
                end
              end
            end
            -----------------------------------------------------------------------------------------------
            -- رد صلاحیت --
            --[[if text:match("^[Ss]how edit$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
              send(msg.chat_id_, msg.id_, 1, '⭕️نمایش پیام های ادیت شده #فعال شد !', 1, 'md')
              db:set('editmsg'..msg.chat_id_,'show')
              end]]
              -----------------------------------------------------------------------------------------------
              if text:match("^[Ss]etlink$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
                send(msg.chat_id_, msg.id_, 1, '🔹لطفا لینک گروه را ارسال نمایید :', 1, 'md')
                db:set("bot:group:link"..msg.chat_id_, 'waiting')
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Ll]ink$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
                local link = db:get("bot:group:link"..msg.chat_id_)
                if link then
                  send(msg.chat_id_, msg.id_, 1, '🌀لینک گروه :\n'..link, 1, 'html')
                else
                  send(msg.chat_id_, msg.id_, 1, '⭕️لینک گروه هنوز ذخیره نشده است ! \n لطفا با دستور Setlink آن را ذخیره کنید 🌹', 1, 'md')
                end
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Ff]ilter (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
                local filters = {string.match(text, "^([Ff]ilter) (.*)$")}
                local name = string.sub(filters[2], 1, 50)
                db:hset('bot:filters:'..msg.chat_id_, name, 'filtered')
                send(msg.chat_id_, msg.id_, 1, "🔹کلمه [ "..name.." ] فیلتر شد !", 1, 'md')
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Rr]w (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
                local rws = {string.match(text, "^([Rr]w) (.*)$")}
                local name = string.sub(rws[2], 1, 50)
                db:hdel('bot:filters:'..msg.chat_id_, rws[2])
                send(msg.chat_id_, msg.id_, 1, "🔹کلمه : ["..rws[2].."] از لیست فیلتر حذف شد !", 1, 'md')
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Ff]ilterlist$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
                local hash = 'bot:filters:'..msg.chat_id_
                if hash then
                  local names = db:hkeys(hash)
                  local text = '📋 لیست کلمات فیلتر شده : \n\n'
                  for i=1, #names do
                    text = text..'> *'..names[i]..'*\n'
                  end
                  if #names == 0 then
                    text = "📋 لیست کلمات فیلتر شده خالی است !"
                  end
                  send(msg.chat_id_, msg.id_, 1, text, 1, 'md')
                end
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Bb]roadcast (.*)$") and is_admin(msg.sender_user_id_, msg.chat_id_) then
                local gps = db:scard("bot:groups") or 0
                local gpss = db:smembers("bot:groups") or 0
                local rws = {string.match(text, "^([Bb]roadcast) (.*)$")}
                for i=1, #gpss do
                  send(gpss[i], 0, 1, rws[2], 1, 'md')
                end
                send(msg.chat_id_, msg.id_, 1, '📩 پیام مورد نظر شما به : '..gps..' گروه ارسال شد !', 1, 'md')
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Ss]tats$") and is_admin(msg.sender_user_id_, msg.chat_id_) then
                local gps = db:scard("bot:groups")
                local users = db:scard("bot:userss")
                local allmgs = db:get("bot:allmsgs")
                send(msg.chat_id_, msg.id_, 1, '🔹وضعیت ربات : \n\n👥تعداد گروه ها : '..gps..'\n👤 تعداد کاربر ها : '..users..'\n✉️ تعداد پیام ها : '..allmgs, 1, 'md')
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Rr]esmsg$") and is_sudo(msg) then
                db:del("bot:allmsgs")
                send(msg.chat_id_, msg.id_, 1, '⭕️ شمارش پیام های دریافتی ، از نو شروع شد !', 1, 'md')
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Uu]nlock (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
                local unlockpt = {string.match(text, "^([Uu]nlock) (.*)$")}
                if unlockpt[2] == "edit" then
                  if db:get('editmsg'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل ویرایش پیام #غیرفعال شد ! ', 1, 'md')
                    db:del('editmsg'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل ویرایش پیام از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unlockpt[2] == "cmd" then
                  if db:get('bot:cmds'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> حالت عدم جواب #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:cmds'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> حالت عدم جواب از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unlockpt[2] == "bots" then
                  if db:get('bot:bots:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل ورود ربات #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:bots:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل ورود ربات از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unlockpt[2] == "flood" then
                  if db:get('anti-flood:'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل فلود #غیرفعال شد ! ', 1, 'md')
                    db:del('anti-flood:'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل قلود از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unlockpt[2] == "pin" then
                  if db:get('bot:pin:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, "> قفل سنجاق پیام #غیرفعال شد ! ", 1, 'md')
                    db:del('bot:pin:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, "> قفل سنجاق پیام از قبل #غیرفعال است ! ", 1, 'md')
                  end
                end
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Ll]ock gtime (%d+)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
                local mutept = {string.match(text, "^[Ll]ock gtime (%d+)$")}
                local hour = string.gsub(mutept[1], 'h', '')
                local num1 = tonumber(hour) * 3600
                local num = tonumber(num1)
                db:setex('bot:muteall'..msg.chat_id_, num, true)
                send(msg.chat_id_, msg.id_, 1, "> قفل گروه [ همه چیز ] به مدت "..mutept[1].." ساعت #فعال شد !", 'md')
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Ll]ock (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
                local mutept = {string.match(text, "^([Ll]ock) (.*)$")}
                if mutept[2] == "all" then
                  if not db:get('bot:muteall'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل گروه [ همه چیز ] #فعال شد !', 1, 'md')
                    db:set('bot:muteall'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل گروه [ همه چیز ] از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "text" then
                  if not db:get('bot:text:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل متن [ چت ] #فعال شد !', 1, 'md')
                    db:set('bot:text:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل متن [ چت ] از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "inline" then
                  if not db:get('bot:inline:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل دکمه شیشه ایی #فعال شد !', 1, 'md')
                    db:set('bot:inline:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل دکمه شیشه ایی از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "photo" then
                  if not db:get('bot:photo:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل عکس #فعال شد !', 1, 'md')
                    db:set('bot:photo:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل عکس از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "spam" then
                  if not db:get('bot:spam:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل اسپم #فعال شد !', 1, 'md')
                    db:set('bot:spam:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل اسپم از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "video" then
                  if not db:get('bot:video:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل فیلم #فعال شد !', 1, 'md')
                    db:set('bot:video:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل فیلم از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "gif" then
                  if not db:get('bot:gifs:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل گیف #فعال شد !', 1, 'md')
                    db:set('bot:gifs:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل گیف از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "music" then
                  if not db:get('bot:music:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل موزیک #فعال شد !', 1, 'md')
                    db:set('bot:music:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل موزیک از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "voice" then
                  if not db:get('bot:voice:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل ویس #فعال شد !', 1, 'md')
                    db:set('bot:voice:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل ویس از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "links" then
                  if not db:get('bot:links:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل لینک #فعال شد ! ', 1, 'md')
                    db:set('bot:links:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل لینک از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "location" then
                  if not db:get('bot:location:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل موقعیت مکانی #فعال شد ! ', 1, 'md')
                    db:set('bot:location:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل موقعیت مکانی از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "tag" then
                  if not db:get('tags:lock'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل تگ #فعال شد ! ', 1, 'md')
                    db:set('tags:lock'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل تگ از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "strict" then
                  if not db:get('bot:strict'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> حالت [ سختگیرانه ] #فعال شد ! ', 1, 'md')
                    db:set('bot:strict'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> حالت [ سختگیرانه ] از قبل #فعال است ! ', 1, 'md')
                  end
                end
                if mutept[2] == "file" then
                  if not db:get('bot:document:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل فایل #فعال شد ! ', 1, 'md')
                    db:set('bot:document:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل فایل از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "hashtag" then
                  if not db:get('bot:hashtag:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل هشتگ #فعال شد ! ', 1, 'md')
                    db:set('bot:hashtag:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل هشتگ از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "contact" then
                  if not db:get('bot:contact:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل ارسال مخاطب #فعال شد ! ', 1, 'md')
                    db:set('bot:contact:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل ارسال مخاطب از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "webpage" then
                  if not db:get('bot:webpage:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل ارسال صفحه اینترنتی #فعال شد ! ', 1, 'md')
                    db:set('bot:webpage:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل ارسال صفحه اینترنتی از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "farsi" then
                  if not db:get('bot:arabic:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل نوشتار فارسی #فعال شد ! ', 1, 'md')
                    db:set('bot:arabic:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل نوشتار فارسی از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "english" then
                  if not db:get('bot:english:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل نوشتار انگلیسی #فعال شد ! ', 1, 'md')
                    db:set('bot:english:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل نوشتار انگلیسی از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "sticker" then
                  if not db:get('bot:sticker:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل استیکر #فعال شد ! ', 1, 'md')
                    db:set('bot:sticker:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل استیکر از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "mention" then
                  if not db:get('mention:lock'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل اسم اشاره #فعال شد ! ', 1, 'md')
                    db:set('mention:lock'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل اسم اشاره از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "markdown" then
                  if not db:get('markdown:lock'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل مدل نشانه گذاری #فعال شد ! ', 1, 'md')
                    db:set('markdown:lock'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل مدل نشانه گذاری از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "tgservice" then
                  if not db:get('bot:tgservice:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل سرویس تلگرام #فعال شد ! ', 1, 'md')
                    db:set('bot:tgservice:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل سرویس تلگرام از قبل #فعال است !', 1, 'md')
                  end
                end
                if mutept[2] == "fwd" then
                  if not db:get('bot:forward:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل فروارد #فعال شد ! ', 1, 'md')
                    db:set('bot:forward:mute'..msg.chat_id_,true)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل فروارد از قبل #فعال است !', 1, 'md')
                  end
                end
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Uu]nlock (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
                local unmutept = {string.match(text, "^([Uu]nlock) (.*)$")}
                if unmutept[2] == "all" or unmutept[2] == "gtime" then
                  if db:get('bot:muteall'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل گروه [ همه چیز ] #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:muteall'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل گروه [ همه چیز ] از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "text" then
                  if db:get('bot:text:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل متن [ چت ] #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:text:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل متن [ چت ] از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "photo" then
                  if db:get('bot:photo:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل عکس #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:photo:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل عکس از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "spam" then
                  if db:get('bot:spam:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل اسپم #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:spam:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل اسپم از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "video" then
                  if db:get('bot:video:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل فیلم #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:video:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل فیلم از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "file" then
                  if db:get('bot:document:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل فایل #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:document:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل فایل از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "inline" then
                  if db:get('bot:inline:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل دکمه شیشه ایی #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:inline:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل دکمه شیشه ایی از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "markdown" then
                  if db:get('markdown:lock'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل مدل نشانه گذاری #غیرفعال شد ! ', 1, 'md')
                    db:del('markdown:lock'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل مدل نشانه گذاری از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "gif" then
                  if db:get('bot:gifs:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل گیف #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:gifs:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل گیف از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "music" then
                  if db:get('bot:music:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل موزیک #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:music:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل موزیک از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "voice" then
                  if db:get('bot:voice:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل ویس #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:voice:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل ویس از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "links" then
                  if db:get('bot:links:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل لینک #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:links:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل لینک از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "location" then
                  if db:get('bot:location:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل موقعیت مکانی #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:location:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل موقعیت مکانی از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "tag" then
                  if db:get('tags:lock'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل تگ #غیرفعال شد ! ', 1, 'md')
                    db:del('tags:lock'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل تگ از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "strict" then
                  if db:get('bot:strict'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> حالت [ سختگیرانه ] #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:strict'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> حالت [ سختگیرانه ] از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "hashtag" then
                  if db:get('bot:hashtag:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل هشتگ #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:hashtag:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل هشتگ از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "contact" then
                  if db:get('bot:contact:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل مخاطب #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:contact:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '🔓 قفل #مخاطب فعال نیست !', 1, 'md')
                  end
                end
                if unmutept[2] == "webpage" then
                  if db:get('bot:webpage:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل صفحه اینترنتی #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:webpage:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل ارسال صفحه اینترنتی از قبل #غیرفعال است !', 1, 'md')
                  end
                end
                if unmutept[2] == "farsi" then
                  if db:get('bot:arabic:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل نوشتار فارسی #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:arabic:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل نوشتار فارسی از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "english" then
                  if db:get('bot:english:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل نوشتار انگلیسی #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:english:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل نوشتار انگلیسی از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "tgservice" then
                  if db:get('bot:tgservice:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل سرویس تلگرام #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:tgservice:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل سرویس تلگرام از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "sticker" then
                  if db:get('bot:sticker:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل استیکر #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:sticker:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل استیکر از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "mention" then
                  if db:get('mention:lock'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل اسم اشاره #غیرفعال شد ! ', 1, 'md')
                    db:del('mention:lock'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل اسم اشاره از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
                if unmutept[2] == "fwd" then
                  if db:get('bot:forward:mute'..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '> قفل فروارد #غیرفعال شد ! ', 1, 'md')
                    db:del('bot:forward:mute'..msg.chat_id_)
                  else
                    send(msg.chat_id_, msg.id_, 1, '> قفل فروارد از قبل #غیرفعال است ! ', 1, 'md')
                  end
                end
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Ss]etspam (%d+)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
                local sensspam = {string.match(text, "^([Ss]etspam) (%d+)$")}
                if tonumber(sensspam[2]) < 40 then
                  send(msg.chat_id_, msg.id_, 1, '🔺 عددی بزرگتر از 40 وارد کنید !', 1, 'md')
                else
                  db:set('bot:sens:spam'..msg.chat_id_,sensspam[2])
                  send(msg.chat_id_, msg.id_, 1, '> حساسیت اسپم به '..sensspam[2]..' کاراکتر تنظیم شد !\nجملاتی که بیش از '..sensspam[2]..' حرف داشته باشند ، حذف خواهند شد !', 1, 'md')
                end
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Ee]dit (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
                local editmsg = {string.match(text, "^([Ee]dit) (.*)$")}
                edit(msg.chat_id_, msg.reply_to_message_id_, nil, editmsg[2], 1, 'html')
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Uu]ser$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
                send(msg.chat_id_, msg.id_, 1, '*'..from_username(msg)..'*', 1, 'md')
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Cc]lean (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
                local txt = {string.match(text, "^([Cc]lean) (.*)$")}
                if txt[2] == 'banlist' then
                  db:del('bot:banned:'..msg.chat_id_)
                  send(msg.chat_id_, msg.id_, 1, '🗒لیست افراد مسدود پاکسازی شد !', 1, 'md')
                end
                if txt[2] == 'bots' then
                  local function g_bots(extra,result,success)
                    local bots = result.members_
                    for i=0 , #bots do
                      chat_kick(msg.chat_id_,bots[i].user_id_)
                    end
                  end
                  channel_get_bots(msg.chat_id_,g_bots)
                  send(msg.chat_id_, msg.id_, 1, '👽 تمامی ربات ها از گروه پاکسازی شدند !', 1, 'md')
                end
                if txt[2] == 'modlist' then
                  db:del('bot:mods:'..msg.chat_id_)
                  send(msg.chat_id_, msg.id_, 1, '🗒 لیست مدیران گروه پاکسازی شد !', 1, 'md')
                end
                if txt[2] == 'filterlist' then
                  db:del('bot:filters:'..msg.chat_id_)
                  send(msg.chat_id_, msg.id_, 1, '🗒 لیست کلمات فیلتر شده پاکسازی شد !', 1, 'md')
                end
                if txt[2] == 'mutelist' then
                  db:del('bot:muted:'..msg.chat_id_)
                  send(msg.chat_id_, msg.id_, 1, '🗒 لیست افراد بی صدا پاکسازی شد !', 1, 'md')
                end
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Ss]ettings$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
                if db:get('bot:muteall'..msg.chat_id_) then
                  mute_all = '#فعال'
                else
                  mute_all = '#غیرفعال'
                end
                ------------
                if db:get('bot:text:mute'..msg.chat_id_) then
                  mute_text = '#فعال'
                else
                  mute_text = '#غیرفعال'
                end
                ------------
                if db:get('bot:photo:mute'..msg.chat_id_) then
                  mute_photo = '#فعال'
                else
                  mute_photo = '#غیرفعال'
                end
                ------------
                if db:get('bot:video:mute'..msg.chat_id_) then
                  mute_video = '#فعال'
                else
                  mute_video = '#غیرفعال'
                end
                ------------
                if db:get('bot:gifs:mute'..msg.chat_id_) then
                  mute_gifs = '#فعال'
                else
                  mute_gifs = '#غیرفعال'
                end
                ------------
                if db:get('anti-flood:'..msg.chat_id_) then
                  mute_flood = '#فعال'
                else
                  mute_flood = '#غیرفعال'
                end
                ------------
                if not db:get('flood:max:'..msg.chat_id_) then
                  flood_m = 5
                else
                  flood_m = db:get('flood:max:'..msg.chat_id_)
                end
                ------------
                if not db:get('bot:sens:spam'..msg.chat_id_) then
                  spam_c = 250
                else
                  spam_c = db:get('bot:sens:spam'..msg.chat_id_)
                end
                ------------
                if db:get('floodstatus'..msg.chat_id_) == "DelMsg" then
                  floodstatus = "حذف پیام"
                elseif db:get('floodstatus'..msg.chat_id_) == "Kicked" then
                  floodstatus = "اخراج"
                elseif not db:get('floodstatus'..msg.chat_id_) then
                  floodstatus = "اخراج"
                end
                ----------------------------------------------------
                if db:get('bot:music:mute'..msg.chat_id_) then
                  mute_music = '#فعال'
                else
                  mute_music = '#غیرفعال'
                end
                ------------
                if db:get('bot:bots:mute'..msg.chat_id_) then
                  mute_bots = '#فعال'
                else
                  mute_bots = '#غیرفعال'
                end
                ------------
                if db:get('bot:inline:mute'..msg.chat_id_) then
                  mute_in = '#فعال'
                else
                  mute_in = '#غیرفعال'
                end
                ------------
                if db:get('bot:cmds'..msg.chat_id_) then
                  mute_cmd = '#فعال'
                else
                  mute_cmd = '#غیرفعال'
                end
                ------------
                if db:get('bot:voice:mute'..msg.chat_id_) then
                  mute_voice = '#فعال'
                else
                  mute_voice = '#غیرفعال'
                end
                ------------
                if db:get('editmsg'..msg.chat_id_) then
                  mute_edit = '#فعال'
                else
                  mute_edit = '#غیرفعال'
                end
                ------------
                if db:get('bot:links:mute'..msg.chat_id_) then
                  mute_links = '#فعال'
                else
                  mute_links = '#غیرفعال'
                end
                ------------
                if db:get('bot:pin:mute'..msg.chat_id_) then
                  lock_pin = '#فعال'
                else
                  lock_pin = '#غیرفعال'
                end
                ------------
                if db:get('bot:sticker:mute'..msg.chat_id_) then
                  lock_sticker = '#فعال'
                else
                  lock_sticker = '#غیرفعال'
                end
                ------------
                if db:get('bot:tgservice:mute'..msg.chat_id_) then
                  lock_tgservice = '#فعال'
                else
                  lock_tgservice = '#غیرفعال'
                end
                ------------
                if db:get('bot:webpage:mute'..msg.chat_id_) then
                  lock_wp = '#فعال'
                else
                  lock_wp = '#غیرفعال'
                end
                ------------
                if db:get('bot:strict'..msg.chat_id_) then
                  strict = '#فعال'
                else
                  strict = '#غیرفعال'
                end
                ------------
                if db:get('bot:hashtag:mute'..msg.chat_id_) then
                  lock_htag = '#فعال'
                else
                  lock_htag = '#غیرفعال'
                end
                ------------
                if db:get('tags:lock'..msg.chat_id_) then
                  lock_tag = '#فعال'
                else
                  lock_tag = '#غیرفعال'
                end
                ------------
                if db:get('bot:location:mute'..msg.chat_id_) then
                  lock_location = '#فعال'
                else
                  lock_location = '#غیرفعال'
                end
                ------------
                if db:get('bot:contact:mute'..msg.chat_id_) then
                  lock_contact = '#فعال'
                else
                  lock_contact = '#غیرفعال'
                end
                ------------
                if db:get('bot:english:mute'..msg.chat_id_) then
                  lock_english = '#فعال'
                else
                  lock_english = '#غیرفعال'
                end
                ------------
                if db:get('bot:arabic:mute'..msg.chat_id_) then
                  lock_arabic = '#فعال'
                else
                  lock_arabic = '#غیرفعال'
                end
                ------------
                if db:get('bot:forward:mute'..msg.chat_id_) then
                  lock_forward = '#فعال'
                else
                  lock_forward = '#غیرفعال'
                end
                ------------
                if db:get('bot:document:mute'..msg.chat_id_) then
                  lock_file = '#فعال'
                else
                  lock_file = '#غیرفعال'
                end
                ------------
                if db:get('mention:lock'..msg.chat_id_) then
                  mention = '#فعال'
                else
                  mention = '#غیرفعال'
                end
                ------------
                if db:get('markdown:lock'..msg.chat_id_) then
                  markdown = '#فعال'
                else
                  markdown = '#غیرفعال'
                end
                ------------
                if db:get('bot:spam:mute'..msg.chat_id_) then
                  lock_spam = '#فعال'
                else
                  lock_spam = '#غیرفعال'
                end
                ------------
                if db:get("bot:welcome"..msg.chat_id_) then
                  send_welcome = '#فعال'
                else
                  send_welcome = '#غیرفعال'
                end
                ------------
                local ex = db:ttl("bot:charge:"..msg.chat_id_)
                if ex == -1 then
                  exp_dat = 'Unlimited'
                else
                  exp_dat = math.floor(ex / 86400) + 1
                end
                ------------
                local TXT = "⚙ تنظیمات گروه :\n\n"
                .."> حالت سختگیرانه : "..strict.."\n"
                .."> حالت قفل کلی گروه : "..mute_all.."\n"
                .."> حالت عدم جواب : "..mute_cmd.."\n\n"
                .."🔃 قفل های اصلی :\n\n"
                .."> قفل اسپم : "..lock_spam.."\n"
                .."> قفل لینک : "..mute_links.."\n"
                .."️> قفل آدرس اینترنتی :  "..lock_wp.."\n"
                .."> قفل تگ : "..lock_tag.."\n"
                .."️> قفل هشتگ : "..lock_htag.."\n"
                .."> قفل فروارد : "..lock_forward.."\n"
                .."> قفل ورود ربات :  "..mute_bots.."\n"
                .."️> قفل ویرایش پیام :  "..mute_edit.."\n"
                .."️> قفل سنجاق پیام : "..lock_pin.."\n"
                .."> قفل دکمه شیشه ایی : "..mute_in.."\n"
                .."> قفل نوشتار فارسی :  "..lock_arabic.."\n"
                .."> قفل نوشتار انگلیسی : "..lock_english.."\n"
                .."> قفل اسم اشاره : "..mention.."\n"
                .."> قفل مدل نشانه گذاری : "..markdown.."\n"
                .."️> قفل سرویس تلگرام : "..lock_tgservice.."\n"
                .."> قفل فلود : "..mute_flood.."\n"
                .."> وضعیت فلود : "..floodstatus.."\n"
                .."> حساسیت فلود : [ "..flood_m.." ]\n"
                .."️> حساسیت اسپم : [ "..spam_c.." ]\n\n"
                .." 🔃قفل های رسانه :\n\n"
                .."> قفل متن [ چت ] : "..mute_text.."\n"
                .."> قفل عکس : "..mute_photo.."\n"
                .."> قفل فیلم : "..mute_video.."\n"
                .."> قفل گیف : "..mute_gifs.."\n"
                .."> قفل موزیک : "..mute_music.."\n"
                .."> قفل ویس : "..mute_voice.."\n"
                .."> قفل فایل : "..lock_file.."\n"
                .."> قفل استیکر : "..lock_sticker.."\n"
                .."> قفل ارسال مخاطب : "..lock_contact.."\n"
                .."️> قفل موقعیت مکانی : "..lock_location.."\n"
                send(msg.chat_id_, msg.id_, 1, TXT, 1, 'md')
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Ee]cho (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
                local txt = {string.match(text, "^([Ee]cho) (.*)$")}
                send(msg.chat_id_, msg.id_, 1, txt[2], 1, 'md')
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Ss]etrules (.*)$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
                local txt = {string.match(text, "^([Ss]etrules) (.*)$")}
                db:set('bot:rules'..msg.chat_id_, txt[2])
                send(msg.chat_id_, msg.id_, 1, '⭕️ قوانین گروه تنظیم شد !', 1, 'md')
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Nn]ote (.*)$") and is_leader(msg) then
                local txt = {string.match(text, "^([Nn]ote) (.*)$")}
                db:set('owner:note1', txt[2])
                send(msg.chat_id_, msg.id_, 1, '📝 ذخیره شد !', 1, 'md')
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Gg]etnote$") and is_leader(msg) then
                local note = db:get('owner:note1')
                send(msg.chat_id_, msg.id_, 1, note, 1, nil)
              end
              -------------------------------------------------------------------------------------------------
              if text:match("^[Rr]ules$") then
                local rules = db:get('bot:rules'..msg.chat_id_)
                send(msg.chat_id_, msg.id_, 1, rules, 1, nil)
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Ss]hare$") and is_sudo(msg) then
                sendContact(msg.chat_id_, msg.id_, 0, 1, nil, 989152033832, 'Sajjad', 'Momen', 228572542)
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Rr]ename (.*)$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
                local txt = {string.match(text, "^([Rr]ename) (.*)$")}
                changetitle(msg.chat_id_, txt[2])
                send(msg.chat_id_, msg.id_, 1, '✅ نام گروه تغییر یافت !', 1, 'md')
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Gg]etme$") then
                function guser_by_reply(extra, result, success)
                  --vardump(result)
                end
                getUser(msg.sender_user_id_,guser_by_reply)
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Ss]etphoto$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
                send(msg.chat_id_, msg.id_, 1, '🔹لطفا عکس را ارسال کنید :', 1, 'md')
                db:set('bot:setphoto'..msg.chat_id_..':'..msg.sender_user_id_,true)
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Cc]harge (%d+)$") and is_admin(msg.sender_user_id_, msg.chat_id_) then
                local a = {string.match(text, "^([Cc]harge) (%d+)$")}
                send(msg.chat_id_, msg.id_, 1, '⭕️گروه برای مدت '..a[2]..' روز شارژ شد !', 1, 'md')
                local time = a[2] * day
                db:setex("bot:charge:"..msg.chat_id_,time,true)
                db:set("bot:enable:"..msg.chat_id_,true)
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Ee]xpire") and is_mod(msg.sender_user_id_, msg.chat_id_) then
                local ex = db:ttl("bot:charge:"..msg.chat_id_)
                if ex == -1 then
                  send(msg.chat_id_, msg.id_, 1, '⭕️ بدون محدودیت ( نامحدود ) !', 1, 'md')
                else
                  local d = math.floor(ex / day ) + 1
                  send(msg.chat_id_, msg.id_, 1, "⭕️ گروه دارای "..d.." روز اعتبار میباشد ", 1, 'md')
                end
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Cc]harge stats (%d+)") and is_admin(msg.sender_user_id_, msg.chat_id_) then
                local txt = {string.match(text, "^([Cc]harge stats) (%d+)$")}
                local ex = db:ttl("bot:charge:"..txt[2])
                if ex == -1 then
                  send(msg.chat_id_, msg.id_, 1, '⭕️ بدون محدودیت ( نامحدود ) !', 1, 'md')
                else
                  local d = math.floor(ex / day ) + 1
                  send(msg.chat_id_, msg.id_, 1, "⭕️ گروه دارای "..d.." روز اعتبار میباشد ", 1, 'md')
                end
              end
              -----------------------------------------------------------------------------------------------
              if is_sudo(msg) then
                -----------------------------------------------------------------------------------------------
                if text:match("^[Ll]eave(-%d+)") and is_admin(msg.sender_user_id_, msg.chat_id_) then
                  local txt = {string.match(text, "^([Ll]eave)(-%d+)$")}
                  send(msg.chat_id_, msg.id_, 1, 'ربات با موفقیت از گروه '..txt[2]..' خارج شد.', 1, 'md')
                  send(txt[2], 0, 1, '⚠️ ربات به دلایلی گروه را ترک میکند\nبرای اطلاعات بیشتر میتوانید با پشتیبانی در ارتباط باشید ✅', 1, 'html')
                  chat_leave(txt[2], bot_id)
                end
                -----------------------------------------------------------------------------------------------
                if text:match('^[Pp]lan1(-%d+)') and is_admin(msg.sender_user_id_, msg.chat_id_) then
                  local txt = {string.match(text, "^([Pp]lan1)(-%d+)$")}
                  local timeplan1 = 2592000
                  db:setex("bot:charge:"..txt[2],timeplan1,true)
                  send(msg.chat_id_, msg.id_, 1, 'پلن 1 با موفقیت برای گروه '..txt[2]..' فعال شد\nاین گروه تا 30 روز دیگر اعتبار دارد! ( 1 ماه )', 1, 'md')
                  db:set("bot:enable:"..txt[2],true)
                end
                -----------------------------------------------------------------------------------------------
                if text:match('^[Pp]lan2(-%d+)') and is_admin(msg.sender_user_id_, msg.chat_id_) then
                  local txt = {string.match(text, "^([Pp]lan2)(-%d+)$")}
                  local timeplan2 = 7776000
                  db:setex("bot:charge:"..txt[2],timeplan2,true)
                  send(msg.chat_id_, msg.id_, 1, 'پلن 2 با موفقیت برای گروه '..txt[2]..' فعال شد\nاین گروه تا 90 روز دیگر اعتبار دارد! ( 3 ماه )', 1, 'md')
                  db:set("bot:enable:"..txt[2],true)
                end
                -----------------------------------------------------------------------------------------------
                if text:match('^[Pp]lan3(-%d+)') and is_admin(msg.sender_user_id_, msg.chat_id_) then
                  local txt = {string.match(text, "^([Pp]lan3)(-%d+)$")}
                  db:set("bot:charge:"..txt[2],true)
                  send(msg.chat_id_, msg.id_, 1, 'پلن 3 با موفقیت برای گروه '..txt[2]..' فعال شد\nاین گروه به صورت نامحدود شارژ شد!', 1, 'md')
                  db:set("bot:enable:"..txt[2],true)
                end
                -----------------------------------------------------------------------------------------------
                if text:match('^[Aa]dd$') and is_admin(msg.sender_user_id_, msg.chat_id_) then
                  local txt = {string.match(text, "^([Aa]dd)$")}
                  if db:get("bot:charge:"..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '☑️ گروه از قبل در لیست مدیریتی ربات میباشد !', 1, 'md')
                  end
                  if not db:get("bot:charge:"..msg.chat_id_) then
                    db:set("bot:charge:"..msg.chat_id_,true)
                    send(msg.chat_id_, msg.id_, 1, '✅ گروه به لیست مدیریتی ربات اضافه شد !', 1, 'md')
                    for k,v in pairs(bot_owner) do
                      send(v, 0, 1, '⭕️گروه جدیدی به لیست مدیریتی ربات اضافه شد !\n🌀 مشخصات فرد اضافه کننده :\n🔸آیدی کاربر : '..msg.sender_user_id_..'\n🌀مشخصات گروه :\n🔸آیدی گروه : '..msg.chat_id_..'\n\n🔹اگر میخواهید ربات گروه را ترک کند از دستور زیر استفاده کنید : \n\n🔖 leave'..msg.chat_id_..'\n\n🔸اگر قصد وارد شدن به گروه را دارید از دستور زیر استفاده کنید : \n\n🔖 join'..msg.chat_id_..'\n\n🔅🔅🔅🔅🔅🔅\n\n📅 اگر قصد تمدید گروه را دارید از دستورات زیر استفاده کنید : \n\n⭕️برای شارژ به صورت یک ماه :\n🔖 plan1'..msg.chat_id_..'\n\n⭕️برای شارژ به صورت سه ماه :\n🔖 plan2'..msg.chat_id_..'\n\n⭕️برای شارژ به صورت نامحدود :\n🔖 plan3'..msg.chat_id_..'\n' , 1, 'md')
                    end
                    db:set("bot:enable:"..msg.chat_id_,true)
                    db:sadd('sudo:data:'..msg.sender_user_id_, msg.chat_id_)
                  end
                end
                -----------------------------------------------------------------------------------------------
                if text:match('^[Rr]em$') and is_admin(msg.sender_user_id_, msg.chat_id_) then
                  local txt = {string.match(text, "^([Rr]em)$")}
                  if not db:get("bot:charge:"..msg.chat_id_) then
                    send(msg.chat_id_, msg.id_, 1, '🚫 گروه در لیست مدیریتی ربات نیست !', 1, 'md')
                  end
                  if db:get("bot:charge:"..msg.chat_id_) then
                    db:del("bot:charge:"..msg.chat_id_)
                    send(msg.chat_id_, msg.id_, 1, '🚫 گروه از لیست مدیریتی ربات حذف شد !', 1, 'md')
                    db:srem('sudo:data:'..msg.sender_user_id_, msg.chat_id_)
                    for k,v in pairs(bot_owner) do
                      send(v, 0, 1, "⭕️ گروهی با مشخصات زیر از لیست مدیریتی حذف شد !\n\n 🌀مشخصات فرد حذف کننده : \n 🔹آیدی فرد : "..msg.sender_user_id_.."\n\n 🌀مشخصات گروه :\n 🔸آیدی گروه : "..msg.chat_id_ , 1, 'md')
                    end
                  end
                end
                -----------------------------------------------------------------------------------------------
                if text:match('^[Ss]erverinfo') and is_sudo(msg) then
                  local s = io.popen("sh ./data.sh")
                  local text = ( s:read("*a") )
                  send(msg.chat_id_, msg.id_, 1, text, 1, 'html')
                end
                -----------------------------------------------------------------------------------------------
                if text:match('^[Aa]ddgp (%d+) (-%d+)') and is_sudo(msg) then
                  local txt = {string.match(text, "^([Aa]ddgp) (%d+) (-%d+)$")}
                  local sudo = txt[2]
                  local gp = txt[3]
                  send(msg.chat_id_, msg.id_, 1, "🔹گروه مورد نظر با موفقیت به لیست گروه های همکار با شناسه : "..txt[2].." #اضافه شد", 1, 'html')
                  db:sadd('sudo:data:'..sudo, gp)
                end
                -----------------------------------------------------------------------------------------------
                if text:match('^[Rr]emgp (%d+) (-%d+)') and is_sudo(msg) then
                  local txt = {string.match(text, "^([Rr]emgp) (%d+) (-%d+)$")}
                  local hash = 'sudo:data:'..txt[2]
                  local gp = txt[3]
                  send(msg.chat_id_, msg.id_, 1, "🔸گروه مورد نظر با موفقیت از لیست گروه های همکار با شناسه : "..txt[2].." #حذف شد", 1, 'html')
                  db:srem(hash, gp)
                end
                -----------------------------------------------------------------------------------
                if text:match('^[Jj]oin(-%d+)') and is_admin(msg.sender_user_id_, msg.chat_id_) then
                  local txt = {string.match(text, "^([Jj]oin)(-%d+)$")}
                  send(msg.chat_id_, msg.id_, 1, 'باموفقیت شما را به گروه '..txt[2]..' اضافه کردم !', 1, 'md')
                  add_user(txt[2], msg.sender_user_id_, 20)
                end
                ------------------------------------------------------------------------------------
                if text:match('^[Mm]eld(-%d+)') and is_admin(msg.sender_user_id_, msg.chat_id_) then
                  local meld = {string.match(text, "^([Mm]eld)(-%d+)$")}
                  send(msg.chat_id_, msg.id_, 1, '> با موفقیت در گروه مورد نظر اعلام گردید !', 1, 'md')
                  send(meld[2], 0, 1, '⚠️_ مدیران گرامی :\n\nاعتبار این گروه به پایان رسیده است !\n\nلطفا هرچه سریع تر برای شارژ مجدد به پشتیبانی ربات مراجعه فرمایید !_', 1, 'md')
                end
                -------------------------------------------------------------------------------------
              end
              -----------------------------------------------------------------------------------------------
              if text:match('^[Dd]el (%d+)$') and is_mod(msg.sender_user_id_, msg.chat_id_) then
                local matches = {string.match(text, "^([Dd]el) (%d+)$")}
                if msg.chat_id_:match("^-100") then
                  if tonumber(matches[2]) > 100 or tonumber(matches[2]) < 1 then
                    pm = '> لطفا از عددی بزرگتر از 1 و کوچکتر از 100 استفاده کنید !'
                    send(msg.chat_id_, msg.id_, 1, pm, 1, 'html')
                  else
                    tdcli_function ({
                      ID = "GetChatHistory",
                      chat_id_ = msg.chat_id_,
                      from_message_id_ = 0,
                      offset_ = 0,
                      limit_ = tonumber(matches[2])
                    }, delmsg, nil)
                    pm ='> '..matches[2]..' پیام اخیر حذف شد !'
                    send(msg.chat_id_, msg.id_, 1, pm, 1, 'html')
                  end
                else pm ='> در گروه معمولی این امکان وجود ندارد !'
                  send(msg.chat_id_, msg.id_, 1, pm, 1, 'html')
                end
              end
              ----------------------------------------------------------------------------------------------
              if text:match("^[Mm]e$") then
                if is_leader(msg) then
                  t = '👑 مدیر تیم 👑'
                elseif is_sudo(msg) then
                  t = '⭐️ مدیر ربات ⭐️'
                elseif is_admin(msg.sender_user_id_) then
                  t = '⭐️ ادمین ربات ⭐️'
                elseif is_owner(msg.sender_user_id_, msg.chat_id_) then
                  t = '👤 صاحب گروه 👤'
                elseif is_mod(msg.sender_user_id_, msg.chat_id_) then
                  t = '👥 مدیر گروه 👥'
                else
                  t = '🔅 کاربر 🔅'
                end
                send(msg.chat_id_, msg.id_, 1, '🔹شناسه شما : '..msg.sender_user_id_..'\n🔸مقام شما : '..t, 1, 'md')
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Pp]in$") and is_mod(msg.sender_user_id_, msg.chat_id_) then
                local id = msg.id_
                local msgs = {[0] = id}
                pin(msg.chat_id_,msg.reply_to_message_id_,0)
                send(msg.chat_id_, msg.id_, 1, '📌 پیام مورد نظر شما ، سنجاق شد !', 1, 'md')
                db:set('pinnedmsg'..msg.chat_id_,msg.reply_to_message_id_)
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Uu]npin$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
                unpinmsg(msg.chat_id_)
                send(msg.chat_id_, msg.id_, 1, '🖇 پیام سنجاق شده ، از حالت سنجاق خارج گردید !', 1, 'md')
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Rr]epin$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
                local pin_id = db:get('pinnedmsg'..msg.chat_id_)
                if not pin_id then
                  send(msg.chat_id_, msg.id_, 1, "🔸نمیتوانم پیام سنجاق شده سابق را پیدا کنم 🙁", 1, 'md')
                else
                  pin(msg.chat_id_,pin_id,0)
                  send(msg.chat_id_, msg.id_, 1, '🔹پیام سنجاق شده سابق ، مجدد سنجاق شد !', 1, 'md')
                end
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Hh]elp$") and is_owner(msg.sender_user_id_, msg.chat_id_) then
                local help = io.open("./Help/help.txt", "r")
                local helptime = 30
                local a = ( help:read("*a") )
                db:setex('helptime:'..msg.chat_id_, helptime, true)
                send(msg.chat_id_, msg.id_, 1, a, 1, 'md')
              end
              if db:get('helptime:'..msg.chat_id_) then
                if is_owner(msg.sender_user_id_, msg.chat_id_) then
                  local helplock = io.open("./Help/helplock.txt", "r")
                  local helpmedia = io.open("./Help/helpmedia.txt", "r")
                  local helpsetlink = io.open("./Help/helpsetlink.txt", "r")
                  local helpprodemo = io.open("./Help/helpprodemo.txt", "r")
                  local helpjanebi = io.open("./Help/helpjanebi.txt", "r")
                  local helpspamflood = io.open("./Help/helpfloodspam.txt", "r")
                  local helpvaziat = io.open("./Help/helpvaziat.txt", "r")
                  if text:match("^1$") then
                    db:del('helptime:'..msg.chat_id_)
                    local b = ( helpvaziat:read("*a") )
                    send(msg.chat_id_, msg.id_, 1, b, 1, 'md')
                  elseif text:match("^2$") then
                    db:del('helptime:'..msg.chat_id_)
                    local c = ( helplock:read("*a") )
                    send(msg.chat_id_, msg.id_, 1, c, 1, 'md')
                  elseif text:match("^3$") then
                    db:del('helptime:'..msg.chat_id_)
                    local d = ( helpmedia:read("*a") )
                    send(msg.chat_id_, msg.id_, 1, d, 1, 'md')
                  elseif text:match("^4$") then
                    db:del('helptime:'..msg.chat_id_)
                    local e = ( helpspamflood:read("*a") )
                    send(msg.chat_id_, msg.id_, 1, e, 1, 'md')
                  elseif text:match("^5$") then
                    db:del('helptime:'..msg.chat_id_)
                    local f = ( helpprodemo:read("*a") )
                    send(msg.chat_id_, msg.id_, 1, f, 1, 'md')
                  elseif text:match("^6$") then
                    db:del('helptime:'..msg.chat_id_)
                    local g = ( helpsetlink:read("*a") )
                    send(msg.chat_id_, msg.id_, 1, g, 1, 'md')
                  elseif text:match("^7$") then
                    db:del('helptime:'..msg.chat_id_)
                    local h = ( helpjanebi:read("*a") )
                    send(msg.chat_id_, msg.id_, 1, h, 1, 'md')
                  elseif text:match("^0$") then
                    send(msg.chat_id_, msg.id_, 1, '> عملیات لغو گردید !', 1, 'md')
                    db:del('help:'..msg.chat_id_)
                  else
                    if text:match("^%d+$") then
                      send(msg.chat_id_, msg.id_, 1, '>  شماره مورد نظر شما در لیست موجود نمیباشد !', 1, 'md')
                    end
                  end
                end
              end
              -----------------------------------------------------------------------------------------------
              if text:match("^[Gg]view$") then
                db:set('bot:viewget'..msg.sender_user_id_,true)
                send(msg.chat_id_, msg.id_, 1, '🔹لطفا مطلب خود را فروراد کنید : ', 1, 'md')
              end
            end
            -----------------------------------------------------------------------------------------------
          end
          -----------------------------------------------------------------------------------------------
          -- end code --
          -----------------------------------------------------------------------------------------------
        elseif (data.ID == "UpdateChat") then
          chat = data.chat_
          chats[chat.id_] = chat
          -----------------------------------------------------------------------------------------------
        elseif (data.ID == "UpdateMessageEdited") then
          local msg = data
          -- vardump(msg)
          function get_msg_contact(extra, result, success)
            local text = (result.content_.text_ or result.content_.caption_)
            --vardump(result)
            if result.id_ and result.content_.text_ then
              db:set('bot:editid'..result.id_,result.content_.text_)
            end
            if not is_mod(result.sender_user_id_, result.chat_id_) then
              check_filter_words(result, text)
              if db:get('editmsg'..msg.chat_id_) then
                local msgs = {[0] = data.message_id_}
                delete_msg(msg.chat_id_,msgs)
              end
              if text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or text:match("[Tt].[Mm][Ee]") then
                if db:get('bot:links:mute'..result.chat_id_) then
                  local msgs = {[0] = data.message_id_}
                  delete_msg(msg.chat_id_,msgs)
                end
              end
              if text:match("[Hh][Tt][Tt][Pp][Ss]://") or text:match("[Hh][Tt][Tt][Pp]://") or text:match(".[Ii][Rr]") or text:match(".[Cc][Oo][Mm]") or text:match(".[Oo][Rr][Gg]") or text:match(".[Ii][Nn][Ff][Oo]") or text:match("[Ww][Ww][Ww].") or text:match(".[Tt][Kk]") then
                if db:get('bot:webpage:mute'..result.chat_id_) then
                  local msgs = {[0] = data.message_id_}
                  delete_msg(msg.chat_id_,msgs)
                end
              end
              if text:match("@") then
                if db:get('tags:lock'..result.chat_id_) then
                  local msgs = {[0] = data.message_id_}
                  delete_msg(msg.chat_id_,msgs)
                end
              end
              if msg.content_.entities_[0].ID == "MessageEntityBold" or msg.content_.entities_[0].ID == "MessageEntityCode" or msg.content_.entities_[0].ID == "MessageEntityPre" or msg.content_.entities_[0].ID == "MessageEntityItalic" then
                if db:get('markdown:lock'..msg.chat_id_) then
                  local msgs = {[0] = data.message_id_}
                  delete_msg(msg.chat_id_,msgs)
                end
              end
              if msg.content_.entities_[0].ID and msg.content_.entities_[0].ID == "MessageEntityMentionName" then
                if db:get('mention:lock'..msg.chat_id_) then
                  local msgs = {[0] = data.message_id_}
                  delete_msg(msg.chat_id_,msgs)
                end
              end
              if text:match("#") then
                if db:get('bot:hashtag:mute'..result.chat_id_) then
                  local msgs = {[0] = data.message_id_}
                  delete_msg(msg.chat_id_,msgs)
                end
              end
              if text:match("[\216-\219][\128-\191]") then
                if db:get('bot:arabic:mute'..result.chat_id_) then
                  local msgs = {[0] = data.message_id_}
                  delete_msg(msg.chat_id_,msgs)
                end
              end
              if text:match("[ASDFGHJKLQWERTYUIOPZXCVBNMasdfghjklqwertyuiopzxcvbnm]") then
                if db:get('bot:english:mute'..result.chat_id_) then
                  local msgs = {[0] = data.message_id_}
                  delete_msg(msg.chat_id_,msgs)
                end
              end
            end
          end
          getMessage(msg.chat_id_, msg.message_id_,get_msg_contact)
          -----------------------------------------------------------------------------------------------
        elseif (data.ID == "UpdateOption" and data.name_ == "my_id") then
          tdcli_function ({ID="GetChats", offset_order_="9223372036854775807", offset_chat_id_=0, limit_=20}, dl_cb, nil)
        end
        -----------------------------------------------------------------------------------------------
      end
 Desktop version Sign out
