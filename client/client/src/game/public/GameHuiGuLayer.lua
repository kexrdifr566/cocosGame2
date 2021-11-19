local GameHuiGuLayer = class("GameHuiGuLayer", function ()
	local GameHuiGuLayer =  display.newLayer()
	return GameHuiGuLayer
end)
function GameHuiGuLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Game/publicLayer/GameHuiGuLayer.csb", self)
	self.bj=csbNode:getChildByName("bj")
        
    local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
			ExternalFun.playClickEffect()
			ref:setScale(1)
			self:onButtonClickedEvent(ref:getTag(),ref)
		elseif type == ccui.TouchEventType.began then
			ref:setScale(public.btscale)
			return true
		elseif type == ccui.TouchEventType.canceled then
			ref:setScale(1)
		end
	end
    self.bj:getChildByName("B_C")
	:setTag(100)
	:addTouchEventListener(btcallback)
    self.pcow=self.bj:getChildByName("pcow")
    self.p=self.bj:getChildByName("p")
    self.nodes={}
    for i=1,10 do
        local str = string.format("Node_%d",i)
        self.nodes[i]=self.bj:getChildByName(str)
    end
    self.bj:getChildByName("B_1")
	:setTag(1)
	:addTouchEventListener(btcallback)
    self.bj:getChildByName("B_2")
	:setTag(2)
	:addTouchEventListener(btcallback)
    
	self.counts=0
    self.index=0
    self.data={}
end

function GameHuiGuLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
		self:setVisible(false)
    elseif tag == 1 then
        self:setpage(false)
    elseif tag == 2 then
        self:setpage(true)        
    end
end
function GameHuiGuLayer:setpage(ble)
    local index= self.index
    if ble then
        index=index-1
    else
        index=index+1
    end
    if self.data[index]  == nil or  self.data[index].details ==nil  then
        return
    end
    --设置翻页
    self.index=index
    for k,v in pairs( self.nodes) do
        v:removeAllChildren()
    end
    -------重新绘画界面
    if public.entergame == public.game.dezhou or public.entergame == public.game.cow or public.entergame == public.game.dcow then
        self:intcow()  
    elseif public.entergame == public.game.sangong or public.entergame == public.game.sangongbi then
        self:intsg()
    end          
end
function GameHuiGuLayer:inint(data)
   -- dump(data,"回顾内容")
    if data ==nil or next(data) ==nil then
        return
    end
    
    self.counts=#data
    self.index=1
    self.data=data
    if public.entergame == public.game.dezhou or public.entergame == public.game.cow or public.entergame == public.game.dcow then
        self:intcow()  
    elseif public.entergame == public.game.sangong or public.entergame == public.game.sangongbi then
        self:intsg()
    end        
end
function GameHuiGuLayer:intsg()
    if self.index ~= 0 then
        local data = self.data[self.index].details
        ExternalFun.dump(data,"人物信息")
        for k,v in pairs(data) do
            local item = self.p:clone()
            local headbg=item:getChildByName("head")
            ExternalFun.createClipHead(headbg,v.userCode,v.logUrl,70)
            item:getChildByName("nickname"):setString(v.userName)
            item:getChildByName("gamecion"):setString(v.accountBalance)
            item:getChildByName("px"):setString(v.pokerStr)
            if v.loseOrWinCoin >= 0 then
                local str=string.format("Game/public/huigu/hui_y.png")
                item:loadTexture(str)
                item:getChildByName("shuying_2"):setString("/"..v.loseOrWinCoin)
                item:getChildByName("shuying_1"):setVisible(false)
            else
                local str=string.format("Game/public/huigu/hui_s.png")
                item:loadTexture(str)
                item:getChildByName("shuying_1"):setString("/"..v.loseOrWinCoin)
                item:getChildByName("shuying_2"):setVisible(false)
            end
            for a,b in pairs(v.pokerArr) do
                    local name=string.format("card%d",a)
                    local puke=item:getChildByName(name)
  
                  local str=string.format("card_%d_%d.png",(b.suit+1),b.rank)
                   -- puke:loadTexture(str)
                 puke:loadTexture(str,ccui.TextureResType.plistType)
            end 
            if v.qiangZhuangBs ==0 then 
                item:getChildByName("biao"):setString("不抢")
            else
                item:getChildByName("biao"):setString("x"..v.qiangZhuangBs)
            end
            -- if public.entergame == public.game.sangongbi then
            --     item:getChildByName("biao"):setString("不抢")
            -- end
            ----
            if v.banker and v.banker == 1 then
                item:getChildByName("z"):setVisible(true)
            else
                item:getChildByName("z"):setVisible(false)
            end
            item:setPosition(0,0)
            self.nodes[k]:addChild(item)
        end
        local counts=self.data[self.index].innings
        self.bj:getChildByName("page"):setString(counts)
        
        self.bj:getChildByName("B_1"):setVisible(true)
        self.bj:getChildByName("B_2"):setVisible(true)
            
        if counts ==1 then
            self.bj:getChildByName("B_1"):setVisible(false)   
        elseif counts == self.counts then
            self.bj:getChildByName("B_2"):setVisible(false)
        end
    end
end
function GameHuiGuLayer:intcow()
    if self.index ~= 0 then
        local data = self.data[self.index].details
         ExternalFun.dump(data,"人物信息")
        for k,v in pairs(data) do
            local item = self.pcow:clone()
            local headbg=item:getChildByName("head")
            ExternalFun.createClipHead(headbg,v.userCode,v.logUrl,70)
            item:getChildByName("nickname"):setString(v.userName)
            item:getChildByName("gamecion"):setString(v.accountBalance)
            item:getChildByName("px"):setString(v.pokerStr)
            if v.loseOrWinCoin >= 0 then
                local str=string.format("Game/public/huigu/hui_y.png")
                item:loadTexture(str)
                item:getChildByName("shuying_2"):setString("/"..v.loseOrWinCoin)
                item:getChildByName("shuying_1"):setVisible(false)
            else
                local str=string.format("Game/public/huigu/hui_s.png")
                item:loadTexture(str)
                item:getChildByName("shuying_1"):setString("/"..v.loseOrWinCoin)
                item:getChildByName("shuying_2"):setVisible(false)
            end
            for a,b in pairs(v.pokerArr) do
                    local name=string.format("card%d",a)
                    local puke=item:getChildByName(name)
  
                  local str=string.format("card_%d_%d.png",(b.suit+1),b.rank)
                    puke:loadTexture(str,ccui.TextureResType.plistType)
                if  v.laizi and  v.laizi.rank and v.laizi.rank==b.rank then
                    local str="xlaizi.png"
                    local spuke = CCSpriteFrameCache:getInstance():getSpriteFrame(str)
                    local sp =  CCSprite:createWithSpriteFrame(spuke)
                    sp:setScale(0.5)
                    sp:move(23,22)
                    sp:addTo(puke)
                end
            end 
            if public.entergame == public.game.cow then
                if v.qiangZhuangBs ==0 then 
                    item:getChildByName("biao"):setString("不抢")
                else
                    item:getChildByName("biao"):setString("x"..v.qiangZhuangBs)
                end
            else
                if v.isBanker ==0 then 
                    item:getChildByName("biao"):setString("闲家")
                elseif v.isBanker ==1 then
                    item:getChildByName("biao"):setString("庄家")
                elseif v.isBanker ==2 then
                    item:getChildByName("biao"):setString("小盲")
                elseif v.isBanker ==3 then
                    item:getChildByName("biao"):setString("大盲")
                end
            end
            if v.banker and v.banker == 1 then
                item:getChildByName("z"):setVisible(true)
            else
                item:getChildByName("z"):setVisible(false)
            end
            item:setPosition(0,0)
            self.nodes[k]:addChild(item)
        end
        local counts=self.data[self.index].innings
        self.bj:getChildByName("page"):setString(counts)
        
        self.bj:getChildByName("B_1"):setVisible(true)
        self.bj:getChildByName("B_2"):setVisible(true)
            
        if counts ==1 then
            self.bj:getChildByName("B_1"):setVisible(false)   
        elseif counts == self.counts then
            self.bj:getChildByName("B_2"):setVisible(false)
        end
    end
end
return GameHuiGuLayer

