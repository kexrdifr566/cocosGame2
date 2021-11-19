local wjxyLayer = class("wjxyLayer", function ()
	local wjxyLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return wjxyLayer
end)
local btn={"所有分值变化","游戏分","钱包"}--,"管理分""捐赠分"
local btntype={"all","gameCoin","qianbao"}--,"manageCoin"
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function wjxyLayer:ctor(_scene,userCode)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/wjxy.csb", self)
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
	self.bj:getChildByName("BT")
	:setTag(101)
	:addTouchEventListener(btcallback)
	self.tcBB={}
	for i = 1, 3 do
		local str =string.format("B%d",i)
		self.tcBB[i]=self.bj:getChildByName(str)
		self.tcBB[i]:setTag(i)
		:addTouchEventListener(btcallback)
	end
	local listcallback = function (index)
		self:onListClickedEvent(index)
	end

	self.btnlist=ExternalFun.BtnList(self.bj:getChildByName("BT"),btn,listcallback)
	self.btnlist:setVisible(false)
	self.bj:addChild(self.btnlist)
	self.userCode =userCode
	self.pk=self.bj:getChildByName("PK")
	self.p=self.bj:getChildByName("P")
    
    self._Bp1=self.bj:getChildByName("Bp1")
    self._yeshu=self.bj:getChildByName("yeshu")
    self._yeshuz=self.bj:getChildByName("yeshuz")
    self._Bp2=self.bj:getChildByName("Bp2")
    self._yeshuzg=self.bj:getChildByName("yeshuzg")
    self._Bp1:setTag(201)
	:addTouchEventListener(btcallback)
    self._Bp2:setTag(203)
	:addTouchEventListener(btcallback)
    self:guanbipage()
    
    self.select=1 
	self:selectbjBB(1)
    AnimationHelper.jumpInEx(self.bj, 1)
end
function wjxyLayer:guanbipage()
    self._curtPage=1
    self._Bp1:setVisible(false)
    self._yeshu:setVisible(false)
    self._yeshuz:setVisible(false)
    self._Bp2:setVisible(false)
    self._yeshuzg:setVisible(false)
end
function wjxyLayer:onListClickedEvent(index)
	--print("列表界面按下"..index)
	self.bj:getChildByName("BT"):getChildByName("T"):setString(btn[index])
	self.select=index
	self:selectbjBB(1)
end

function wjxyLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
		self:removeFromParent()
	elseif tag >0 and tag <=3 then
		self:selectbjBB(tag)
	elseif tag == 101 then
		self.btnlist:setVisible(true)
    elseif  tag >200 and tag <204 then
        self._curtPage=self._curtPage+tag-202
        self:getData()
    end
end
function wjxyLayer:selectbjBB(index)
	if self.tcBB[index] ==nil then
		return
	end
	for k,v in pairs(self.tcBB) do
		v:setEnabled(true)
        if k == index then
            v:setEnabled(false)
        end
	end
	self.setcetTime=index
	self:getData()
end
function wjxyLayer:initPK(data)
	self.pk:removeAllChildren()
	for k,v  in pairs(data.result) do
		local item=self.p:clone()
		local str= string.sub(v.createTime,1,10)
		item:getChildByName("T_1"):setString(str)
        str= string.sub(v.createTime,12,20)
        item:getChildByName("T_9"):setString(str)
		local index=nil
		for i,j in pairs(btntype) do
			if v.coinType ==j then
				index= i
			end
		end

        local qian=""
        if v.coinType == "gameCoin" then
            item:getChildByName("T_4"):setString("游戏分")
            qian="游戏分"
        elseif v.coinType == "manageCoin" then
            item:getChildByName("T_4"):setString("管理分")
            qian="管理分"
        elseif v.coinType == "qianbao" then
            item:getChildByName("T_4"):setString("钱包")
            qian="钱包"
        end
        
        if v.ocoinType == "gameCoin" then
            item:getChildByName("T_5"):setString("游戏分")
        elseif v.ocoinType == "manageCoin" then
            item:getChildByName("T_5"):setString("管理分")
        elseif v.ocoinType == "qianbao" then
            item:getChildByName("T_5"):setString("钱包")
        end
        

		item:getChildByName("T_8"):setString(v.rechargeCoins)
		if v.rechargeCoins >= 0 then
			item:getChildByName("T_8"):setColor(cc.c3b(239,97,18))
		else
			item:getChildByName("T_8"):setColor(cc.c3b(0,187,27))
		end
        if v.rechargeCoins  < 0 then
			item:getChildByName("i2"):setVisible(false)
		else
			item:getChildByName("i1"):setVisible(false)
		end
		if  index == 2 then
			item:getChildByName("T_2"):setString(qian.."前:"..v.startgamecoin)
			item:getChildByName("T_3"):setString(qian.."后:"..v.endgamecoin)
		elseif index == 3 then
			item:getChildByName("T_2"):setString(qian.."前:"..v.startgamecoin)
			item:getChildByName("T_3"):setString(qian.."后:"..v.endgamecoin)
		elseif index == 4 then
			item:getChildByName("T_2"):setString(qian.."前:"..v.startbrokeragecoin)
			item:getChildByName("T_3"):setString(qian.."后:"..v.endbrokeragecoin)
		end
		item:getChildByName("T_6"):setString(v.toUserName)
		item:getChildByName("T_7"):setString("ID:"..v.toUserCode)
		self.pk:pushBackCustomItem(item)
	end
    if data.totalPage and data.totalPage >0  then
        self._Bp1:setVisible(true)
        if self._curtPage == 1 then
            self._Bp1:setEnabled(false)
        else
            self._Bp1:setEnabled(true)
        end
        self._Bp2:setVisible(true)
        if self._curtPage < data.totalPage then
            self._Bp2:setEnabled(true)
        else
            self._Bp2:setEnabled(false)
        end
        self._yeshu:setString(self._curtPage)
        self._yeshu:setVisible(true)
        self._yeshuz:setString(data.totalPage.."页")
        self._yeshuz:setVisible(true)
                
        self._yeshuzg:setString("总"..data.total.."条")
        self._yeshuzg:setVisible(true)
    end
end
function wjxyLayer:getData()
	function Senddata(datas)
		self:initPK(datas)
	end
	local clubinfo = public.getclubinfo(public.enterclubid)
	local data={}
	data.groupCode=clubinfo.groupCode
	data.userCode = self.userCode
	data.coinType =btntype[self.select]
	local lindate = os.date("%Y-%m-%d")
	if self.setcetTime == 1 then
		data.date=ExternalFun.day_step(os.date("%Y-%m-%d"),0)
	elseif self.setcetTime == 2 then
		data.date=ExternalFun.day_step(os.date("%Y-%m-%d"),-1)
	elseif self.setcetTime == 3 then
		data.date=ExternalFun.day_step(os.date("%Y-%m-%d"),-2)
	end
    data.curtPage =self._curtPage
	--发送
	httpnect.send(HttpHead.tjcx,data,Senddata)
end
return wjxyLayer

