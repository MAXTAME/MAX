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
if not database:get('MAX:'..bot_id..'rep:mute'..msg.chat_id_) then
if text == 'الالعاب' then
moody = "• مرحبا بك في لعبه السمايلات اكتب العب حتى تبداء اللعب🏁ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end

if text == 'العب' then
moody = "• ماهو سمايل مختلف😙😙😙😙😙😙😙😙😙😗😙😙😙😙😙ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😗' then
moody = "• ماهو السمايل المختلف😃😃😃😃😃😃😃😃😃😃😃😃😀😃😃😃😃😃😃ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😀' then
moody = "• ماهو اليمايل المختلف😰😰😰😰😰😰😰😰😰😰😰😰😨😰😰😰😰😰😰😰ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😨' then
moody = "• ماهو السمايل المختلف😑😑😑😑😑😑😑😑😑😑😑😑😐😑😑😑😑😑😑😑ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😐' then
moody = "• ماهو السمايل المختلف😲😲😲😲😲😲😲😲😮😲😲😲😲😲😲ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😮'then
moody = "• لقد ربحت اكتب س2حتى تستمرֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س2' then
moody = "• ماهو السمايل المختلف😢😢😢😢😢😢😢😢😢😢😥😢😢😢😢😢😢😢😢ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😥' then
moody = "• ماهو السمايل المختلف😈😈😈😈😈😈😈😈👿😈😈😈😈😈😈😈ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '👿' then
moody = "• ماهو السمايل المختلف😸😸😸😸😸😸😸😸😸😺😸😸😸😸ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😺' then
moody = "• ماهو السمايل المختلف👨‍✈️👨‍✈️👨‍✈️👨‍✈️👨‍✈️👨‍✈️👨‍✈️👨‍✈️👩‍✈️👨‍✈️👨‍✈️👨‍✈️👨‍✈️👨‍✈️👨‍✈️ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '👩‍✈️' then
moody = "• ماهو السمايل المختلف👨‍🚀👨‍🚀👨‍🚀👨‍🚀👨‍🚀👨‍🚀👨‍🚀👨‍🚀👨‍🚀👨‍🚀👩‍🚀👨‍🚀👨‍🚀👨‍🚀👨‍🚀ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '👩‍🚀' then
moody = "• لقد ربحت اكتب س3 حتى تستمرֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س3' then
moody = "• ماهو السمايل المختلف🔹🔹🔹🔹🔹🔹🔹🔷🔹🔹🔹🔹🔹🔹ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🔷' then
moody = "• ماهو السمايل المختلف🏃‍♂🏃‍♂🏃‍♂🏃‍♂🏃‍♂🏃‍♂🏃‍♂🏃‍♂🏃‍♂🏃‍♂🏃‍♂🏃‍♀🏃‍♂🏃‍♂🏃‍♂🏃‍♂🏃‍♂🏃‍♂ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🏃‍♀' then
moody = "• ماهو السمايل المختلف🐑🐑🐑🐑🐑🐑🐑🐑🐑🐑🐑🐏🐑🐑🐑🐑🐑🐑ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🐏' then
moody = "• ماهو اليمايل المختلف🍀🍀🍀🍀🍀🍀🍀☘🍀🍀🍀🍀🍀"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '☘' then
moody = "• ماهو السمايل المختلف🎄🎄🎄🎄🎄🎄🎄🎄🌲🎄🎄🎄🎄🎄🎄🎄ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🌲' then
moody = "• لقد ربحت اكتب س3 حتى تستمرֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س3' then
moody = "• ماهو السمايل المختلف🕒🕒🕒🕒🕒🕒🕑🕒🕒🕒🕒ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🕑' then
moody = "• ماهو السمايل المختلف🕟🕟🕟🕟🕟🕟🕟🕟🕞🕟🕟🕟🕟ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🕞' then
moody = "• ماهو السمايل المختلف👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👨‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '👨‍🔬' then
moody = "• ماهو السمايل المختلف🚅🚅🚅🚅🚅🚅🚅🚅🚄🚅🚅🚅🚅🚅ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🚄' then
moody = "• ماهو السمايل المختلف🇲🇦🇲🇦🇲🇦🇲🇦🇲🇦🇲🇦🇲🇦🇲🇦🇲🇪🇲🇦🇲🇦🇲🇦🇲🇦🇲🇦🇲🇦🇲🇦ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🇲🇪' then
moody = "• لقد ربحت اكتب س4 حتى تستمر"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'س4' then
moody = "• ماهو السمايل المختلف◾️◾️◾️◾️◾️◾️◾️◾️◾️◾️◼️◾️◾️◾️◾️◾️◾️◾️ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '◼️' then
moody = "• ماهو السمايل المختاف🕕🕕🕕🕕🕕🕕🕧🕕🕕🕕🕕🕕🕕ֆ "
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🕧' then
moody = "• ماهو السمايل المختلف🔨🔨🔨🔨🔨🔨🔨⛏🔨🔨🔨🔨🔨🔨"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '⛏' then
moody = "• ماهو السمايل المختلف🛃🛃🛃🛃🛃🛃🛃🛃🛃🛃🛂🛃🛃🛃🛃🛃🛃ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '🛂' then
moody = "• ماهو السمايل المختلف💿💿💿💿💿💿💿💿📀💿💿💿💿💿💿💿💿ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '📀' then
moody = "• لقد ربحت مبروك في لعبه السمايلات لا تحزن تريد انتقال الى لعبه اخرى ممتعه اكتب نعم حتى نبدءֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'نعم' then
moody = "• هل تعرف ما هيه اللعبه  انها لعبه المحيبس😻 اكتب محيبس حتى نبدءֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'محيبس' then
moody = "• ماهي اليد الفيها المحيبسֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'h' then
moody = "• الاجابه خاطئه انها هناhֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'h' then
moody = "• تلعب وخوش تلعب hֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'h' then
moody = "• تلعب وخوش تلعبhֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'h' then
moody = "• تلعب وخوش تلعب h"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'h' then
moody = "• الاجابه خاطئه انها هنhֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'اها' then
moody = "• يَٰبٌِٰ قٍٰاَٰبٌِٰـﮧلْٰ اَٰغِِٰشَُـﮧكٍٰ شَُسٌٍاَٰلْٰفِٰـﮧهَٰہۧ حٌٰبٌِٰ😐🌝ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'شسمج' then
moody = "• حمديه ام اللبن😹👊ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'شسمك' then
moody = "• تحاسين😹💛ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'شوف' then
moody = "• شَُشَُـﮧﮧوٍّ໑فِٰ 🌝🌝ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'مساء الخير' then
moody = "• مساؤؤ حياتي🌛🔥ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'المدرسه' then
moody = "• لْٰتّٰجًِّيَٰـﮧبٌِٰ اَٰسٌٍمٍٰـﮧهَٰہۧ لْٰاَٰ اَٰطَُِـﮧرِٰدِٰكٍٰ🌞✨ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'منو ديحذف رسائلي' then
moody = "• اني 🌚ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'البوت واكف' then
moody = "• لْٰجًِّـﮧذَْبٌِٰ حٌٰبٌِٰـہيَٰ 🌞⚡️ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'غلس' then
moody = "• وٍّ໑كٍٰ بٌِٰـﮧسٌٍ سٌٍـﮧوٍّ୭لْٰفِٰلْٰيَٰ اَٰلْٰسٌٍـﮧاَٰلْٰفِٰهَٰہۧ بٌِٰعٍِّـﮧدِٰيَٰنٍٰ🌝🦅ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'حارة' then
moody = "• تّٰسٌٍـہمٍٰطَُِ سٌٍمٍٰـﮧطَُِ غِِٰيَٰـﮧرِٰ يَٰرِٰحٌٰمٍٰنٍٰـﮧهَٰہۧ اَٰلْٰاَٰعٍِّبٌِٰـاَٰدِٰيَٰ وٍّيَٰنٍٰـہطَُِيَٰ عٍِّطَُِلْٰـﮧهَٰہۧ 😾💔ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'هههه' then
moody = "• نٍٰشَُـﮧاَٰلْٰلْٰهَٰہۧ دِٰاَٰيَٰمٍٰـﮧهَٰہۧ💆🏻‍♂💘ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'ههههه' then
moody = "• نٍٰشَُـﮧاَٰلْٰلْٰهَٰہۧ دِٰاَٰيَٰمٍٰـﮧهَٰہۧ💆🏻‍♂💘ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == '😹' then
moody = "• نٍٰشَُـﮧاَٰلْٰلْٰهَٰہۧ دِٰاَٰيَٰمٍٰـﮧهَٰہۧ💆🏻‍♂💘ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'وين' then
moody = "• بٌِٰـﮧﮧأرِٰض اَٰلْٰلْٰهَٰہۧ اَٰلْٰـہوٍّاَٰسٌٍعٍِّـﮧهَٰہۧ😽💜ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'كافي لغوة' then
moody = "• كٍٰـيَٰفِٰنٍٰـﮧهَٰہۧ نٍٰتّٰـﮧهَٰہۧ شَُعٍِّـہلْٰيَٰكٍٰ😼👊ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'نايمين' then
moody = "• اَٰنٍٰـﮧيَٰ سٌٍهَٰہۧـہرِٰاَٰنٍٰ اَٰحٌٰرِٰسٌٍـﮧكٍٰمٍٰ مٍٰـﮧטּ تّٰـرِٰاَٰمٍٰـﮧبٌِٰ😿😹🙌ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'اكو احد' then
moody = "• يَٰ عٍِّيَٰـنٍٰـﮧيَٰ اَٰنٍٰـہيَٰ مٍٰـوٍّ૭جًِّـﮧوٍّدِٰ🌝✨ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'فديت' then
moody = "•فِٰـﮧﮧدِٰاَٰكٍٰ/جًِّ ثِْْـﮧوٍّ୪لْٰاَٰنٍٰ اَٰلْٰكٍٰـرِٰوٍّ୭بٌِٰ😟😂💚ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'شكو' then
moody = "• كٍٰلْٰـشَُـﮧﮧيَٰ مٍٰـہاَٰكٍٰـﮧوٍّ اَٰرِٰجًِّـعٍِّ نٍٰـاَٰمٍٰ🐼🌩ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'اوف' then
moody = "• هَٰہۧـﮧﮧاَٰيَٰ اَٰوٍّفِٰ مٍٰنٍٰ يَٰـاَٰ نٍٰـوٍّ୭عٍِّ صُِـاَٰرِٰتّٰ اَٰلْٰـسٌٍاَٰلْٰفِٰهَٰہۧ مٍٰتّٰـنٍٰعٍِّرِٰفِٰ🌚🌙ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'احبج' then
moody = "•جًِّـﮧذَْاَٰبٌِٰ يَٰـرِٰيَٰدِٰ يَٰطَُِـہكٍٰجًِّ😹🌞⚡️ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'هه' then
moody = "• شوكت تبطل ضحكتك مال فروخ😒😹ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'تخليني' then
moody "• اخليك بزاويه 180 وكته تعرف شيصير🐸😹ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end
if text == 'ههه' then
moody = "• خلي ضحكتك الك نفسيه😒ֆ"
send(msg.chat_id_, msg.id_, 1, moody, 1, 'md')
end

end
if  (text and text == 'تفعيل ردود البوت') and is_owner(msg) then
    if not database:get('MAX:'..bot_id..'rep:mute'..msg.chat_id_) then
  send(msg.chat_id_, msg.id_, 1, '☑┇ردود البوت بالفعل تم تفعيلها', 1, 'md')
    else
  send(msg.chat_id_, msg.id_, 1, '☑┇تم تفعيل ردود البوت', 1, 'md')
   database:del('MAX:'..bot_id..'rep:mute'..msg.chat_id_)
  end
  end
  if(text and text == 'تعطيل ردود البوت') and is_owner(msg) then
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
BY : MAXTIME
Channel Files : https://t.me/MAXFiles
]]
