public =public or {}

public.WIDTH								= 1280--1136--1334
public.HEIGHT								= 720--640--750

public.btscale                              = 0.96
public.TICK_COUNTS							= 5
public.SOCKET_TICK_TIME						= 5
public.tabv1pcen                            = 0
public.gamebacktime                         = 1

public.bVoiceAble 							=	false
public.bSoundAble 							=	false
public.bDayAble 							= 	false
public.bAutoAble 							=	false
--音量设置
public.nSound 								= 	100
public.nMusic 								= 	100
--震动设置
public.bShake 								= 	false
public.HallMusic 							=   1
public.GameMusic 							= 	1

public.userCode								=	''					--用户ID
public.userName                             =	''					--用户昵称
public.zsCoin								=	0					--用户钻石数目
public.webtoken                             =	''					--用户token
public.createGroupZs						=	0					--创建俱乐部耗费钻石
public.bindTelephone						=	0					--绑定手机与否 0未 1 是已经绑定
public.hasMessage							=	0					--有无新消息
public.logoUrl								=	""					--用户头像地址
public.registBy								=	0					--登陆方式1微信，2手机
public.roomCode								=	0					--是否再游戏中。
public.rzStatus								=	0					--是否已经认证
public.sexCode 								=	0					--男性女性
public.tel 									=	''					--电话
public.wxUuid								=	0					--用户微信ID
public.roles								=	{}					--拓展消息
public.clubinfo								=	{}					--俱乐部所有信息都放到这里
public.enterclubid							=	"0"					--打开俱乐部ID
public.entertable							=	{}					--进入俱乐部桌子
public.GameTalbeinfo                        =   {}
public.yqm									=	''
-- public.duanxian                             = nil

public.entergame                            =   0					--进入游戏ID
public.roomCode                             =   0					--进入房间ID
public.port                                 =   nil                 --游戏端口
public.host                                 =   nil                 --游戏域名
public.gamecode                             =   "000004"

public.regame                               =  false

public.url                                  ="https://share.ttxl666.com"

public.shouci                               = true

public.active                               = true                  --活动页面只显示一次标识

public.ingametype                           = 0

--第三方平台定义(同java/ios端定义值一致)
public.ThirdParty = 
{
	WECHAT 								= 0,	-- 微信
	WECHAT_CIRCLE						= 1,	-- 朋友圈
	ALIPAY								= 2,	-- 支付宝
	JFT								 	= 3,	-- 俊付通
	AMAP 								= 4,	-- 高德地图
	IAP 							 	= 5,	-- ios iap
    SMS                                 = 6,    -- 分享到短信
    LQ                                  = 7,    -- 零钱支付
}
--微信配置定义
public.WeChat = 
{
    AppID 								= "wxcf651c08766c1dc3", --@wechat_appid_wx
	AppSecret 							= "d0f8102dcb7f782ecf312d801dfd5ea2", --@wechat_secret_wx
	-- 商户id
	PartnerID 							= "", --@wechat_partnerid_wx
	-- 支付密钥					        
	PayKey 								= "", --@wechat_paykey_wx
	URL 								= "",
}
public.SocialShare =
{
	title 								= "天天互娱", --@share_title_social
	content 							= "天天互娱，打造专属娱乐交友棋牌平台！", --@share_content_social
	url 								= public.url,
    AppKey                              = "5ffcd2456a2a470e8f7517c9",
}
public.CLIENT_MSG_BACKGROUND_ENTER          = 115 -- 客户端从后台切换回来
-- 分享错误代码
public.ShareErrorCode = 
{
    NOT_CONFIG                          = 1
}

--支付宝配置
public.AliPay = 
{
	-- 应用id pid
	AppID							    = "2018120662454440", --@alipay_partnerid_zfb
	
	-- 合作者身份id
	PartnerID							= " ", --@alipay_partnerid_zfb
	-- 收款支付宝账号						
	SellerID							= " ", --@alipay_sellerid_zfb
	-- rsa密钥
	RsaKey								= " ", --@alipay_rsa_zfb
	NotifyURL							= public.url,
	-- ios支付宝Schemes
	AliSchemes							= "WHAliPay", --@alipay_schemes_zfb
}
--竣付通配置
public.JFT =
{
	--商户支付密钥
	PayKey 								= " ", --@jft_paykey_jtpay
	--商户id											
	PartnerID 							= " ", --@jft_partnerid_jtpay
	--token												
	TokenURL							= "http://api.jtpay.com/jft/sdk/token/", --@jft_tokenurl_jtpay
	--后台通知url
	NotifyURL							= public.url,
	--appid				
	JftAppID							= " ", --@jft_appid_jtpay								
	JftAesKey							= " ", --@jft_aeskey_jtpay
	JftAesVec 							= " ", --@jft_aesvec_jtpay
}

--高德配置
public.AMAP = 
{
	-- 开发KEY
	AmapKeyIOS							= "f799443488ddddddddd36241ec6", --@ios_devkey_amap
	AmapKeyAndroid						= "ddddsa312312312312312312312313", --@android_devkey_amap
}

--竣付通配置
public.LQ =
{
    --商户ID
    comp_id                              = "CP000126937584", --@
    --产品ID                                          
    prod_id                           = "PD000174926805", --@
    --支付URL                                            
    prepayUrl                            = "", --@
    --登录参数
    noPwdRegParam                           = "",
    --登录参数
    noPwdRegsign                           = "",
}
public.culbCode                             = {
	qunzhu = "1",                       --群主
    fuqunzhu="2",                       --副群主
	hehuoren = "6",                     --合伙人
	huiyuan = "0"                       --会员
}
--游戏
public.game = {
    dezhou                                  =   "1",
    cow                                     =   "2",
    sangong                                 =   "3",
    brgame                                  =   "4",
    dcow                                    =   "5",
    jinhua                                  =   "6",
    sangongbi                               =   "7",
}

public.brgame={
    sangong                                 =   "14",
    cow                                     =   "15",
    longhu                                  =   "16",
    shenshou                                =   "17",
    baoma                                   =   "18",
}

public.GameList={
    gamename={"德州扑克", "牛牛","三公","百人游戏","斗公牛","金花","三公比金花"},--游戏总汇
    gameicon={"quanbu","bairenjingji","sangong","niuniu","sangongbijinhua","dougongniu","paodekuai","dezhoupuke"},--俱乐部左侧游戏类型动画,"bcbm"
    SetRoomType={"ALL","BAIREN",public.game.sangong,public.game.cow,public.game.sangongbi,public.game.dcow,nil,public.game.dezhou},--俱乐部左侧游戏类型触发
}
public.brgamecode={
    "14","15","16","17","18",
    }
                    --,"赢三张",
public.cowwf={"明牌抢庄"}             --牛牛玩法 ,"自由抢庄","牛牛上庄"
public.sgwf={"自由抢庄","大吃小"}                              --三公玩法"自由抢庄",

public.brwf={                                             --百人玩法
    gamename={"百人三公","百人牛牛","龙虎斗","斗神兽","奔驰宝马"},--
    moshi={"独庄","拼庄"},
    kzscore={1000,2000,5000,10000,20000,50000},
    choushuims={"输赢双反","所有赢家"},
    cmbl={"1比1","1比10"},
}
public.isbaoma =true
if public.isbaoma ==false then
       public.brwf.gamename={"百人三公","百人牛牛","龙虎斗","斗神兽"}
end
public.choushuims={"输赢双反","所有赢家"}
public.dezhou=											--德州创建房间玩法
{
	renshu={6,8,10},
	bgrenshu={3,4,5,6,7,8,9,10},
    jushu={10},
	--jushu={6,8,10},
	difen={100,200,500,1000},
	mangzhu={2,5,10,20},
	canyu={2000,},
	qipai={15,20,30},
	zhifu={"房主支付","AA支付",},
}
public.cow=											--德州创建房间玩法
{
	renshu={6,8,10},
    jushu={10},
	--jushu={6,8,10},
	zhifu={"房主支付(12钻石)","AA支付(12钻石)",},
    beilv={0.1,0.2,0.3,0.5,1,2,5,10,20,50,100},
	bgrenshu={2,3,4,5,6,7,8,9,10},
	wanglai={"无癞子","王癞","随机癞",},
	difen={5,10,20,50,100},
	zqz={4,5},
	tuizhu={"不可推注",5,10,15,20,50,100},
    tfanbei={"不翻倍","翻倍"},
	fanbei={"牛牛 X3  牛九 X2  牛八 X2  牛七 X2","牛牛 X10  牛九 X9  。。。 牛二 X2"},
	teshu={"不选","全部",},
    zuidi={},
}
public.dcow=											--斗公牛房间玩法
{
	renshu={6,8,10},
    zjcj={3,6},
    szgd={1,2,3},
    szcs={1,2,3},
    hpxz={"有花牌","无花牌"},
    bgrenshu={2,3,4,5,6,7,8,9,10},
    xjlk={3,5},
    xjxz={5,10},
	teshu={"不选","全部",},
    fanbei={"牛牛 X3  牛九 X2  牛八 X2  牛七 X2","牛牛 X10  牛九 X9  。。。 牛二 X2"},
    zuidi={},
    fapai={"明三暗二","全暗"},
}
public.sangong=											--德州创建房间玩法
{
	renshu={6,8,10},
	bgrenshu={2,3,4,5,6,7,8,9,10},
    jushu={10},
	-- jushu={6,8,10},
	difen={100,200,500,1000},
	zgxiazhu={200,500,1000,2000},
	canyu={2000,},
	qipai={15,20,30},
	zhifu={"房主支付","AA支付",},
    zuidi={},
}
public.sangongbi=											--三公比金花房间玩法
{
	renshu={6,8,10},
	bgrenshu={2,3,4,5,6,7,8,9,10},
    jushu={10},
	-- jushu={6,8,10},
	difen={100,200,500,1000},
	zgxiazhu={200,500,1000,2000},
	canyu={2000,},
	qipai={15,20,30},
	zhifu={"房主支付","AA支付",},
    zuidi={},
}
--判断是否不是百人房间
function public.isBrGame(roomType)
    for k,v in pairs(public.brgame) do 
        if roomType == v then
            return true
        end
    end
    return false
end

function public.initgame()
	public.entergame                            =   0					--进入游戏ID
	public.roomCode                             =   0					--进入房间ID
	public.port                                 =   nil                 --游戏端口
	public.host                                 =   nil                 --游戏域名
end

function public.initdata(data)
	public.userCode								=  	data["userCode"]				--用户ID
	public.aliasName							=	data["aliasName"]				--真实姓名
	public.userName                             =	data["userName"]				--用户昵称
	public.zsCoin								=	tonumber(data["zsCoin"])		--用户钻石数目
	public.webtoken                             =	data["token"]					--用户token
	public.createGroupZs						=	tonumber(data["createGroupZs"]) --创建俱乐部耗费钻石
	public.bindTelephone						=	data["bindTelephone"]			--绑定手机与否 0未 1 是已经绑定
	public.hasMessage							=	data["hasMessage"]				--有无新消息
	public.logoUrl								=	data["logoUrl"]					--用户头像地址
	public.registBy								=	data["registBy"]				--登陆方式1微信，2手机
	public.roomCode								=	data["roomCode"]				--是否再游戏中。
	public.rzStatus								=	data["rzStatus"]				--是否已经认证
	public.sexCode 								=	data["sexCode"]					--男性女性
	public.tel 									=	data["tel"]						--电话
	public.wxUuid								=	data["wxUuid"]					--用户微信ID
	public.kfwx									=	data["kfwx"]					--客服微信
	public.roles								=	data["roles"]					--拓展消息
	public.yqm 									=	data["yqm"]						--邀请码
    public.kfurl                                =   data["kfurl"]				    --客服地址
    public.activity                             =   data["activity"]				--活动页面
    public.czurl                                =   data["czurl"]                   --充值页面
end

function public.initclubinfo(data)
	public.clubinfo=data
end
function public.newintclubinfo(data)
    table.insert(public.clubinfo,data)
end
function public.findclubinfo()
    for k,v in pairs(public.clubinfo) do
        if public.enterclubid == v.groupCode then
            return  v
        end
    end
    return nil
end
function public.inittableinfo(data)
	public.entertable=data
end
--设置进桌子信息
function public.setGameTalbeinfo(data)
    --dump(data,"设置桌子信息")
    if data then
        public.GameTalbeinfo=data
    else
        public.GameTalbeinfo={}
    end
end

function public.gettableinfo(roomCode)
    if roomCode == public.GameTalbeinfo.roomCode then
        return public.GameTalbeinfo
    end
    showToast("房间信息读取错误!!!",2)
	-- for k,v in pairs(public.entertable) do
	-- 	if v.roomCode ==roomCode then
	-- 		return v
	-- 	end
	-- end
	-- return nil
end


function public.getclubinfo(groupCode)
	for k,v in pairs(public.clubinfo) do
		if v.groupCode ==groupCode then
			return v
		end
	end
	return nil
end


function public.dezhouType(data)
    local str =""
    -- if data.texaTableType == "0" then
    --     str = "无限注"
    -- else
    --     str = "定注"
    -- end

    if data.texaBigBlind then
        str = str..string.format(" 最大注%d",data.texaBigBlind)
    end
    -- if data.texaMaxRaise then
    --     str = str..string.format(" %d次",data.texaMaxRaise)
    -- end

    return str
end

--读取配置
function public.LoadData()
	--声音设置
	public.bVoiceAble = cc.UserDefault:getInstance():getBoolForKey("vocieable",true)
	public.bSoundAble = cc.UserDefault:getInstance():getBoolForKey("soundable", true)
	--音量设置
	public.nMusic = cc.UserDefault:getInstance():getIntegerForKey("musicvalue",100)
	public.nSound = cc.UserDefault:getInstance():getIntegerForKey("soundvalue",100)
	--哪种音乐
	public.HallMusic = cc.UserDefault:getInstance():getIntegerForKey("hallmusic",1)
	public.GameMusic = cc.UserDefault:getInstance():getIntegerForKey("gamemusic",1)
	--震动设置
	public.bShake = cc.UserDefault:getInstance():getBoolForKey("shakeable",true)

	if public.bVoiceAble then
		AudioEngine.setMusicVolume(public.nMusic/100.0)		
	else
		AudioEngine.setMusicVolume(0)
	end
	
	if public.bSoundAble then
		AudioEngine.setEffectsVolume(public.nSound/100.00) 
	else
		AudioEngine.setEffectsVolume(0) 
	end
end
--开关音乐
function public.setVoiceAble(able)
	public.bVoiceAble = able
	if  public.bVoiceAble == true then
		AudioEngine.setMusicVolume(public.nMusic/100.0)
		AudioEngine.resumeMusic()
	else		
		AudioEngine.setMusicVolume(0)
		AudioEngine.pauseMusic() -- 暂停音乐  
	end
	cc.UserDefault:getInstance():setBoolForKey("vocieable",public.bVoiceAble)
end
--开关音乐
function public.setHallmusic(index)
	AudioEngine.pauseMusic()
	AudioEngine.setMusicVolume(public.nMusic/100.0)
	public.HallMusic=index
	cc.UserDefault:getInstance():setIntegerForKey("hallmusic",public.HallMusic)
end
--开关音乐
function public.setGamemusic(index)
	AudioEngine.pauseMusic()
	AudioEngine.setMusicVolume(public.nMusic/100.0)
	public.GameMusic=index
	cc.UserDefault:getInstance():setIntegerForKey("gamemusic",public.GameMusic)
end
--开关音效
function public.setSoundAble(able)
	public.bSoundAble = able
	if true == able then
		AudioEngine.setEffectsVolume(public.nSound/100.00)
	else
		AudioEngine.setEffectsVolume(0)
	end
	cc.UserDefault:getInstance():setBoolForKey("soundable",public.bSoundAble)
end

--设置音乐
function public.setMusicVolume(music)
	local tmp = music
	if tmp >100 then
		tmp = 100
	elseif tmp <= 0 then
		tmp = 0
	end

	if tmp > 0 and not public.bVoiceAble then
		public.setVoiceAble(true)
	end
	if tmp == 0 and public.bVoiceAble then
		public.setVoiceAble(false)
	end

	AudioEngine.setMusicVolume(tmp/100.0) 
	public.nMusic = tmp
	cc.UserDefault:getInstance():setIntegerForKey("musicvalue",public.nMusic)
end
---设置音效
function public.setEffectsVolume(sound)
	local tmp = sound
	if tmp >100 then
		tmp = 100
	elseif tmp <= 0 then
		tmp = 0
	end
	if tmp > 0 and not public.bSoundAble then
		public.setSoundAble(true)
	end
	if tmp == 0 and public.bSoundAble then
		public.setSoundAble(false)
	end
	AudioEngine.setEffectsVolume(tmp/100.00)
	public.nSound = tmp
	cc.UserDefault:getInstance():setIntegerForKey("soundvalue",public.nSound)
end

