HttpHead = HttpHead or {}
HttpHead =
{
    getphonecode    =   "/gameCenter/check/sendMsg",            --获取手机验证码
    phoneregist     =   "/gameCenter/check/regist",             --微信和手机注册
    phonelogin      =   "/gameCenter/check/login",              --手机登陆
    changePw        =   "/gameCenter/check/changePw",           --手机密码修改
    UpUserinfo      =   "/gameCenter/check/updateUserInfo",     --更新个人信息OR实名认证/绑定手机/重置密码
    GetClubNotice	=	"/gameCenter/group/selectNotice" ,		--获取俱乐部公告
    UpClubNotice	=	"/gameCenter/group/saveNotice" ,		--更新俱乐部公告
    getCode         =   "/gameCenter/group/getYqm",             --获取本人的邀请码
    bindTelphone    =  "/gameCenter/check/bindTelphone",        --绑定手机
    changeMac       =  "/gameCenter/check/changeMac",           --手机短信验证更改唯一码
    --------------------------排行
    Rankju			=	"/gameCenter/group/selectTopInnings",	--局数排行
    Rankda			=	"/gameCenter/group/selectTopWinCoin",	--大赢家排行
    Ranktu			=	"/gameCenter/group/selectTopRechargeCoin",	--土豪排行
    Rankji			=	"/gameCenter/group/selectTopAccountCoin",	--积分排行
    Rankfu			=	"/gameCenter/group/selectTopLoseCoin",	--负分排行
    groupKf         =   "/gameCenter/group/groupKf",            --获取盟的客服


    ------------------------加入俱乐部
    JoinCulb        =   "/gameCenter/group/applyJoinGoroupByYqm", --填写俱乐部验证码申请

    ------------------------合伙人信息
    querymezu       =   "/gameCenter/team/selectTeamInGroup",      --会员管理查询我的小组
    cjhhr           =   "/gameCenter/team/createTeam",            --创建合伙人
    dehhr           =   "/gameCenter/team/deleteTeamInGroup",       --删除合伙人
    changeUserFcbl  =   "/gameCenter/team/changeTeamFcbl",           --调整比例

    ----------------------统计---------------------------------
    tjcx            =   "/gameCenter/group/getConiHistory",          --玩家详情查询
    tjshou          =   "/gameCenter/group/getStatistics",            --统计首页
    tjshouteam      =   "/gameCenter/group/getStatisticsTeam",        --统计里面的会员
    tjwjxq          =   "/gameCenter/group/getStatisticsUser",        --统计页面工作详情
    jtwjxq          =   "/gameCenter/group/getRoleBrokerageList",     --统计页面工作具体详情

    --游戏记录
    getrecord       =       "/gameCenter/group/getTeamGameList",          --获取小组信息游戏记录
    getshirecord    =       "/gameCenter/group/getTenGameHis",            --获取俱乐部最近10局战绩
    todayrecord     =       "/gameCenter/group/getTeamUserGameListNew",      --当天合伙人下所有成员游戏局数列表
    todaywjrecord   =       "/gameCenter/group/getUserTodayGameHis",      --获取玩家当天对战游戏桌号列表
    cxrecord        =       "/gameCenter/group/getGameHisByTableID",      --按照桌号和局号查询对战详情
    getTeamUser     =       "/gameCenter/group/getTeamUserAndGame",       --点击会员弹出会员下面的玩家信息
    getTeamGameListBR =     "/gameCenter/group/getTeamGameListBR" ,        --获取百人游戏数据
    getGameGroupByTableID = "/gameCenter/group/getGameGroupByTableID",      --根据桌子号查战绩
    getGameGroupByParams = "/gameCenter/group/getGameGroupByParams",      --根据桌子号查战绩
    
    lockroom        =   "/gameCenter/group/yhszfj",                   --点击会员弹出会员下面的玩家信息
    findroom        =   "/gameCenter/group/joinRom",                  --加入房间
    
    getActivity     =   "/gameCenter/group/getActivity",                 --获取比赛活动
    
    
    qbzuanru        =   "/gameCenter/qianbao/youxiJbToQianBao",                  --转入钱包
    qbchaxun        =   "/gameCenter/zfTxjl/cxqb",                               --查询钱包
    qbzuanchu       =   "/gameCenter/qianbao/qianBaoToyouxiJb",                 --转出
    qbjilu          =   "/gameCenter/qianbao/qianbaoJl",                         --记录
    qbmima          =   "/gameCenter/qianbao/xgmima",                           --修改密码
    qbjzfzc         =   "/gameCenter/qianbao/jzjbToQianBao",                  --转出赠送分
    youxiJbZs       =   "/gameCenter/qianbao/youxiJbZs",                     --游戏金币赠送给别人

    
    ticxbd          =   "/gameCenter/zfTxjl/getBk",                              --查询银行卡绑定
    tibangding      =   "/gameCenter/zfTxjl/bk" ,                                --绑定
    tijilu          =   "/gameCenter/zfTxjl/listAllZfTxjl" ,                     --查询
    tixian          =   "/gameCenter/zfTxjl/txsq",                               --体现申请
    
    xzfbz           =   "/gameCenter/qun/xzfbz",                                 --设置副群主
    scfbz           =   "/gameCenter/qun/scfbz",                                 --取消副群主
    
    getCoinStatisticsUser = "/gameCenter/group/getCoinStatisticsUser",           --新得详情界面
}