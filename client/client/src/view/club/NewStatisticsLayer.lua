local NewStatisticsLayer = class("NewStatisticsLayer", function ()
	local NewStatisticsLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return NewStatisticsLayer
end)
local riqiLayer=appdf.req(appdf.VIEW.."club.riqiLayer")
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function NewStatisticsLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/NewStatisticsLayer.csb", self)
	self.bj=csbNode:getChildByName("bj")
    self.xs=csbNode:getChildByName("xs")
    self.xs:setVisible(false)
    
    local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
			ExternalFun.playClickEffect()
            
			self:onButtonClickedEvent(ref:getTag(),ref)
		elseif type == ccui.TouchEventType.began then
                ref:setScale(public.btscale)
			return true
		elseif type == ccui.TouchEventType.canceled then
                ref:setScale(1)
		end
	end
	----------------------bj----------------------------s
    self.bj:getChildByName("B_C")
	:setTag(100)
	:addTouchEventListener(btcallback)
    	--查询ID
	local TF=self.bj:getChildByName("Image")
	self.TF = ExternalFun.cteartTFtwo(TF:getChildByName("Image"),TF:getChildByName("Image"),"请输入ID",true,nil,nil,35)
    
    self.btn_back= self.bj:getChildByName("BH")
	self.btn_back:setTag(1)
	self.btn_back:addTouchEventListener(btcallback)
    self.btn_back:setVisible(false)
    
    self.bj:getChildByName("B_WD")
	:setTag(2)
	:addTouchEventListener(btcallback)
    
    self.bj:getChildByName("B_CX")
	:setTag(3)
	:addTouchEventListener(btcallback)
    
    self.bjpk=self.bj:getChildByName("PK")
    self.bjp=self.bj:getChildByName("P")
    
    self.Bp1=self.bj:getChildByName("Bp1")
    self.yeshu=self.bj:getChildByName("yeshu")
    self.yeshuz=self.bj:getChildByName("yeshuz")
    self.Bp2=self.bj:getChildByName("Bp2")
    self.yeshuzg=self.bj:getChildByName("yeshuzg")
    self.Bp1:setTag(21)
	:addTouchEventListener(btcallback)
    
    self.Bp2:setTag(23)
	:addTouchEventListener(btcallback)
    -----------------------------------------xs--------------
    self.xs:getChildByName("B_C")
	:setTag(99)
	:addTouchEventListener(btcallback)
    
    self.xspk=self.xs:getChildByName("PK")
    self.xsp=self.xs:getChildByName("P")
    self.chaxun=6
    self.userCode = public.userCode
	self:sendData()
    
    self._Bp1=self.xs:getChildByName("Bp1")
    self._yeshu=self.xs:getChildByName("yeshu")
    self._yeshuz=self.xs:getChildByName("yeshuz")
    self._Bp2=self.xs:getChildByName("Bp2")
    self._yeshuzg=self.xs:getChildByName("yeshuzg")
    self._Bp1:setTag(31)
	:addTouchEventListener(btcallback)
    
    self._Bp2:setTag(33)
	:addTouchEventListener(btcallback)
    self:guanbipage()
    AnimationHelper.jumpInEx(self.bj, 1)
end

function NewStatisticsLayer:onButtonClickedEvent(tag,ref)
	print("界面按下"..tag)
    if tag == 100 then
        self:removeFromParent()
	elseif    tag == 99    then
        self.xs:setVisible(false)
    elseif    tag == 1    then
        self.userCode=public.userCode
        self.chaxun=6
        self:sendData()
    elseif    tag == 2    then
        self.chaxun=0
        self:sendData()
    elseif  tag >20 and tag <24 then
        self.curtPage=self.curtPage+tag-22
        self:sendData() 
    elseif  tag >30 and tag <34 then
        self._curtPage=self._curtPage+tag-32
        self:sendData()  
    elseif    tag == 3    then
        if ExternalFun.checkTFIDtwo(self.TF) then
			self.userCode=self.TF:getString()
            self.chaxun=6
            self:sendData()
		end 
        
    end
end
function NewStatisticsLayer:guanbipage()
    self.curtPage=1
    self.Bp1:setVisible(false)
    self.yeshu:setVisible(false)
    self.yeshuz:setVisible(false)
    self.Bp2:setVisible(false)
    self.yeshuzg:setVisible(false)
    
    self._curtPage=1
    self._Bp1:setVisible(false)
    self._yeshu:setVisible(false)
    self._yeshuz:setVisible(false)
    self._Bp2:setVisible(false)
    self._yeshuzg:setVisible(false)
end
function NewStatisticsLayer:inintbj(data)
    self.bjpk:removeAllChildren()
	for k ,v in pairs (data) do
        local item=self.bjp:clone()
        
        local btcallback = function (ref, type)
            if type == ccui.TouchEventType.ended then
                ExternalFun.playClickEffect()
                ref:setScale(1)
            if ref:getTag()  == 1 then
                self.userCode=v.userCode
                self.chaxun=6
                self:sendData()
                
            else
                self.userCode=v.userCode
                self.chaxun=0
                self:sendData()
            end    
            elseif type == ccui.TouchEventType.began then
                ref:setScale(public.btscale)
            elseif type == ccui.TouchEventType.canceled then
                ref:setScale(1)
            end
        end
        item:getChildByName("B_1")
        :setTag(1)
        :addTouchEventListener(btcallback)
        
        item:getChildByName("B_2")
        :setTag(2)
        :addTouchEventListener(btcallback)
        
        local headbg=item:getChildByName("head")
                --设置头像
        ExternalFun.createClipHead(headbg,v.userCode,v.logUrl,67)
        item:getChildByName("T"):setString(k)
        item:getChildByName("T_1"):setString(v.userName)
        item:getChildByName("T_2"):setString(v.yesBigwinCount)
        item:getChildByName("T_3"):setString(v.yesCount)
        item:getChildByName("T_4"):setString(v.yesLoseOrWinCoin)
        item:getChildByName("T_5"):setString(v.todayLoseOrWinCoin)
        item:getChildByName("T_6"):setString(v.userCode)
        self.bjpk:pushBackCustomItem(item)
    end
end
function NewStatisticsLayer:inintxs(data)
	self.xspk:removeAllChildren()
	for k ,v in pairs (data) do
        local item=self.xsp:clone()
        local headbg=item:getChildByName("head")
                --设置头像
        ExternalFun.createClipHead(headbg,v.userCode,v.logUrl,67)
        item:getChildByName("T"):setString(k)
        item:getChildByName("T_1"):setString(v.userName)
        item:getChildByName("T_2"):setString(v.yesBigwinCount)
        item:getChildByName("T_3"):setString(v.yesCount)
        item:getChildByName("T_4"):setString(v.yesLoseOrWinCoin)
        item:getChildByName("T_5"):setString(v.todayLoseOrWinCoin)
        item:getChildByName("T_6"):setString(v.userCode)
        self.xspk:pushBackCustomItem(item)
    end
end
function NewStatisticsLayer:sendData()
    function Senddata(datas)
       --dump(datas,"详情数据"..self.chaxun)
        if self.chaxun == 6 then
            self:inintbj(datas.childDetail)
            self.bj:getChildByName("T"):setString(datas.yesCount)
            self.bj:getChildByName("TT"):setString(datas.yesLoseOrWinCoin)
            if self.userCode ~= public.userCode then
                self.btn_back:setVisible(true)
            else
                self.btn_back:setVisible(false)
            end
            if datas.totalPage and datas.totalPage >0  then
                self.Bp1:setVisible(true)
                if self.curtPage == 1 then
                    self.Bp1:setEnabled(false)
                else
                    self.Bp1:setEnabled(true)
                end
                self.Bp2:setVisible(true)
                if self.curtPage < datas.totalPage then
                    self.Bp2:setEnabled(true)
                else
                    self.Bp2:setEnabled(false)
                end
                self.yeshu:setString(self.curtPage)
                self.yeshu:setVisible(true)
                
                self.yeshuz:setString(datas.totalPage.."页")
                self.yeshuz:setVisible(true)
                
                self.yeshuzg:setString("总"..datas.total.."条")
                self.yeshuzg:setVisible(true)
            end
        elseif self.chaxun == 0 then
           -- dump(datas,"dd")
            self:inintxs(datas.childDetail)
            self.xs:getChildByName("T"):setString(datas.yesCount)
            self.xs:getChildByName("TT"):setString(datas.yesLoseOrWinCoin)
            self.xs:setVisible(true)
            if datas.totalPage and datas.totalPage >0  then
                self._Bp1:setVisible(true)
                if self._curtPage == 1 then
                    self._Bp1:setEnabled(false)
                else
                    self._Bp1:setEnabled(true)
                end
                self._Bp2:setVisible(true)
                if self._curtPage < datas.totalPage then
                    self._Bp2:setEnabled(true)
                else
                    self._Bp2:setEnabled(false)
                end
                self._yeshu:setString(self._curtPage)
                self._yeshu:setVisible(true)
                
                self._yeshuz:setString(datas.totalPage.."页")
                self._yeshuz:setVisible(true)
                
                self._yeshuzg:setString("总"..datas.total.."条")
                self._yeshuzg:setVisible(true)
            end
        end
    end
    local clubinfo = public.getclubinfo(public.enterclubid)
    local data ={}
    data.userCode = self.userCode--public.userCode --self.userCode
    data.groupCode= clubinfo.groupCode
    data.userGroupRole = self.chaxun
    data.searhStr=self.userCode
    if self.xs:isVisible() then
        data.curtPage =self._curtPage
    else
        data.curtPage =self.curtPage
    end
    httpnect.send(HttpHead.getCoinStatisticsUser,data,Senddata)
end
return NewStatisticsLayer

