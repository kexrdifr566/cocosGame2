GameHead = GameHead or {}
GameHead =
{
    --服务端发消息
	ingame			=		"000004",					--进入游戏
    zkts            =       "00000602",                 --庄开始提示
    swatchplayer    =       "00003101",                 --收到观战人列表
    online          =       "000023",                   --更新在线消息
    noonline        =       "00002301",                 --更新不在线消息
    ztjoinplayer    =       "00000603",                 --中途加入玩家去掉准备
    
    Userlist        =       "00000901",                  --用户列表操作zt=c新增 ，zt=u 更新 ，zt=d 删除，
    GzUserlist      =       "00000902",                 --观战准备用户列表
    
    --客户端发消息
	zbgame			=		"000006",					--开始准备
	tcgame			=		"000021",					--退出游戏(更新玩家列表)
	close      		=       "001010",					--退出游
	watchplayer		=		"000031",					--观战人列表
    zk              =       "000007",                   --庄发送开始
    huigu           =       "000047",                   --回顾
    continue        =       "000050",                   --继续游戏
    Upcoin          =       "000040",                   --继续游戏
}