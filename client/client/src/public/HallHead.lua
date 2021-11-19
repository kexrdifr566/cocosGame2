HallHead = HallHead or {}
HallHead =
{
	ws 			=		appdf.WS_URL.ws,
	port        =       appdf.WS_URL.port,                       --大厅端口
    url         =       "/gameCenter/gateEndpoint",             --大厅连接地址
    gameurl     =       "/gameCenter/gameEndpoint",             --游戏连接地址
    cjculb      =       "000002",                               --创建俱乐部
    sqculb      =       "000003",                               --申请加入俱乐部
    xxculb      =       "000009",                               --消息列表（申请或者加入）
    xxcculb     =       "000005",                               --消息列表处理（申请或者加入）
    cxculb      =       "000008",                               --查询俱乐部
    deculb		=		"000010",								--删除俱乐部
    tcculb      =       "000022",                               --退出已经进入的俱乐部
    inculb      =       "000013",                               --进入俱乐部
    intalbe     =       "000001",                               --进入桌子(获取桌子地址)
    Upcoin      =       "000040",                               --更新积分

    cjctupdate  =       "000025",                               --更新创建界面数据
    cjroom      =       "000024",                               --创建房间
    cjcowwf     =       "002000",                               --牛牛获取特殊玩法
    roomjf      =       "000034",                               --房间进入底分
    roomzss     =       "000035",                               --房间消耗钻石数目
    roomzdf     =       "000036",                               --最低分  
    
    cyglcy      =       "000014",                               --查询俱乐部成员列表
    wodecy      =       "000016",                               --我的成员
    cxculbwj    =       "000019",                               --单独查询俱乐部成员
    cyxzcy      =       "000026",                               --查询小组成员
    yqxzcy      =       "000015",                               --邀请玩家进入小组
    scxzcy      =       "000029",                               --删除小组成员
    drcy        =       "000027",                               --导入小组
    drcycz      =       "000017",                               --导入成员操作
    scorecy     =       "000028",                               --分数管理
    cycyxy      =       "000030",                               --查询信用
    jlbscf      =       "000033",                               --俱乐部删除房间
    notice      =       "000048",                               --公告
    jsroom      =       "000049",                               --解散房间
    quanxian    =       "000050",                               --提升权限反馈
    upzuanshi   =       "000051",                               --更新钻石数目
    
    grxx        =       "000061",                               --查询个人信息
    qlgrfs      =       "000062",                               --清理个人分数
    tableinfo   =       "000063",                               --桌子信息
    djwj        =       "000064",                               --冻结玩家
    GGnotice    =       "000065",                               --大厅公告
    
    hqtalbe     =       "000000",                               --获取桌子消息    
    sctable     =       "000995",                               --删除桌子信息
    Addtable     =      "000994",                               --添加桌子信息
    
    heart       =       "999999",								--大厅心跳
    getroominfo      =  "000997",                               --取桌子信息
    inroom      =       "000998",                               --进入桌子房间
    outroom     =       "000999",                               --退出俱乐部
    xiaoxipd    =       "001000",                               --消息判断
    tuichu      =       "001111",                               --服务端强制退出
}