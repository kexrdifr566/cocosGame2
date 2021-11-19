BaiRenHead = BaiRenHead or {}
BaiRenHead =
{
    --服务端消息
    Zhuang              =           "004002",                             --上庄下庄返回
    Wxiazhu             =           "004004",                             --玩家下注
    UpdateUserlist      =           "000037",                             --更新桌面上玩家列表消息
    UpdateZhuanglist    =           "000038",                             --更新庄家列表消息
    OnLineUserlist      =           "000039",                             --在线玩家
    Trend               =           "000041",                             --录单消息
    UpdateGameStatus    =           "",                                   --更新游戏状态(切到空闲时间)
    Gamestart           =           "00400126",                           --游戏开始
    GameOver            =           "00400200",                           --开牌,显示输赢结果
    GameKong            =           "00400128",                           --空闲状态
    --客户端处理消息
    Tcode      =       "004002",                                --
    action      =       {1,2,3,4},                                  --1,下注,2上庄,3下庄,4取消申请
    
    Gamestatus={kongxian="28",kaishi="26",jiesuan="27",}            --
    
}