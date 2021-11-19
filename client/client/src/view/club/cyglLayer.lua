local cyglLayer = class("cyglLayer", function ()
	local cyglLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return cyglLayer
end)
local cjhhrLayer =appdf.req(appdf.VIEW.."club.cjhhrLayer")					--创建合伙人
local delhhrLayer =appdf.req(appdf.VIEW.."club.delhhrLayer")				--删除合伙人
local delwjLayer =appdf.req(appdf.VIEW.."club.delwjLayer")					--删除玩家
local wjxyLayer =appdf.req(appdf.VIEW.."club.wjxyLayer")					--玩家详情
local yqwjLayer =appdf.req(appdf.VIEW.."club.yqwjLayer")					--邀请玩家
local drculdLayer =appdf.req(appdf.VIEW.."club.drculdLayer")				--导入群组
local scoreSetLayer =appdf.req(appdf.VIEW.."club.scoreSetLayer")			--分数设置
local AnimationHelper = appdf.req(appdf.EXTERNAL_SRC .. "AnimationHelper")
function cyglLayer:ctor(_scene,clubinfo,cheng)
    EventMgr.registerEvent(self,"cyglLayer")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Club/ClubPage.plist")
	self.clubinfo = clubinfo
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Club/Layer/cygl.csb", self)
	self.bj=csbNode:getChildByName("bj")
    local btcallback = function (ref, type)
		if type == ccui.TouchEventType.ended then
			ExternalFun.playClickEffect()
			--ref:setScale(1)
			self:onButtonClickedEvent(ref:getTag(),ref)
		elseif type == ccui.TouchEventType.began then
			--ref:setScale(public.btscale)
			return true
		elseif type == ccui.TouchEventType.canceled then
			--ref:setScale(1)
		end
	end
    self.bj:getChildByName("B_C")
	:setTag(100)
	:addTouchEventListener(btcallback)
	self.Bs=self.bj:getChildByName("Bs")
	self.Bs:setTag(101)
	self.Bs:addTouchEventListener(btcallback)
	

	self.bb={}
	for i = 1, 5 do
		local str =string.format("B_%d",i)
		self.bb[i]=self.bj:getChildByName(str)
		self.bb[i]:setTag(i)
		:addTouchEventListener(btcallback)
	end
	--切换滑动容器
	self.pk={}
    self.pkimage={}
	for i = 1, 2 do
		local str =string.format("PK%d",i)
		self.pk[i]=self.bj:getChildByName(str)
        str =string.format("Image_%d",i)
        self.pkimage[i]=self.bj:getChildByName(str)
	end

	--标题
	self.TT={}
	for i = 1, 5 do
		local str =string.format("T%d",i)
		self.TT[i]=self.bj:getChildByName(str)
	end

	--个人信息
	self.PP={}
	for i =3, 5 do
		local str =string.format("PP%d",i)
		self.PP[i]=self.bj:getChildByName(str)
	end

	self.PP[3]:getChildByName("B1")
	:setTag(11)
	:addTouchEventListener(btcallback)
	self.PP[3]:getChildByName("B2")
	:setTag(12)
	:addTouchEventListener(btcallback)
	self.PP[3]:getChildByName("B2_0")
	:setTag(17)
	:addTouchEventListener(btcallback)

	self.PP[4]:getChildByName("B1")
	:setTag(13)
	:addTouchEventListener(btcallback)
	self.PP[4]:getChildByName("B2")
	:setTag(14)
	:addTouchEventListener(btcallback)

	self.PP[5]:getChildByName("B1")
	:setTag(15)
	:addTouchEventListener(btcallback)
	self.PP[5]:getChildByName("B2")
	:setTag(16)
	:addTouchEventListener(btcallback)

	--单元项
	self.P={}
	for i =1, 5 do
		local str =string.format("P%d",i)
		self.P[i]=self.bj:getChildByName(str)
	end
    ----隐藏的按钮
    if self.clubinfo.groupRoleCode  ~= public.culbCode.qunzhu then
        self.PP[3]:getChildByName("B1"):setVisible(false)
        self.PP[4]:getChildByName("B2"):setVisible(false)
    end
	--查询ID
	self.image=self.bj:getChildByName("Image")
    self.TF = ExternalFun.cteartTFtwo(self.image,self.bj,"输入玩家ID",true,nil,nil,35)
    
    self.Bp1=self.bj:getChildByName("Bp1")
    self.yeshu=self.bj:getChildByName("yeshu")
    self.yeshuz=self.bj:getChildByName("yeshuz")
    self.Bp2=self.bj:getChildByName("Bp2")
    self.yeshuzg=self.bj:getChildByName("yeshuzg")
    self.Bp1:setTag(21)
	:addTouchEventListener(btcallback)
    
    self.Bp2:setTag(23)
	:addTouchEventListener(btcallback)
    self:guanbipage()
	--选择页面
	if cheng then
		self.select=3
	else
		self.select=1
	end
    for k,v in pairs(self.bb) do
		v:setEnabled(true)
        v:getChildByName("Text"):setColor(cc.c3b(114,69,21))
	end
	self:selectPage()
    AnimationHelper.jumpInEx(self.bj, 1)
end
function cyglLayer:guanbipage()
    self.curtPage=1
    self.zongPage=1
    self.Bp1:setVisible(false)
    self.yeshu:setVisible(false)
    self.yeshuz:setVisible(false)
    self.Bp2:setVisible(false)
    self.yeshuzg:setVisible(false)
end
function cyglLayer:selectPage(ischarger)
	self:reUi()
	self.bb[self.select]:setEnabled(false)
    self.bb[self.select]:getChildByName("Text"):setColor(cc.c3b(255,255,255))
	if self.select == 1 or self.select == 2 then					--页面1
		self.pk[1]:setVisible(true)
	else
		self.pk[2]:setVisible(true)
		self.PP[self.select]:setVisible(true)
	end
	if self.select == 2 or self.select == 5 or self.select == 4 then										--显示or隐藏单独查询玩家信息
		self.TF:setVisible(false)
		self.image:setVisible(false)
		self.Bs:setVisible(false)
	else
		self.TF:setVisible(true)
		self.image:setVisible(true)
		self.Bs:setVisible(true)
	end
	if self.select  == 4 then
		self.PP[4]:getChildByName("T1"):setString(public.userName)
        local headbg=self.PP[4]:getChildByName("head")
        --设置头像
        ExternalFun.createClipHead(headbg,public.userCode,public.logoUrl,67)
            --房间标识
        local Im =self.PP[4]:getChildByName("I")
        local str=nil
        if self.clubinfo.groupRoleCode  == public.culbCode.qunzhu then
            str=string.format("qunzhu.png")
        elseif self.clubinfo.groupRoleCode  == public.culbCode.fuqunzhu  then
            str=string.format("fuqunzhu.png")
        elseif self.clubinfo.groupRoleCode  == public.culbCode.hehuoren  then
            str=string.format("huoren.png")
        else
            Im:setVisible(false)
        end
        if str then
            Im:loadTexture(str,ccui.TextureResType.plistType)
        end    
	end
	self.TT[self.select]:setVisible(true)
    if ischarger ==nil then
        self:guanbipage()
    end
	self:send()
end
function cyglLayer:send()
	for k,v in pairs(self.pk) do
		v:removeAllChildren()
	end
	local data = {}
	if self.select == 3 then
		data.teamLeaderCode=public.userCode
		data.groupCode=self.clubinfo.groupCode
        data.curtPage =self.curtPage
		st.send(HallHead.cyxzcy,data)
	elseif self.select == 2 then
		data.curtPage=public.curtPage
		data.userCode=public.userCode
        data.curtPage =self.curtPage
		st.send(HallHead.xxculb,data)
        
	elseif self.select == 1 then
		data.groupCode = self.clubinfo.groupCode
        data.curtPage =self.curtPage
		st.send(HallHead.cyglcy,data)
	elseif self.select == 4 then
		data.groupCode = self.clubinfo.groupCode
        data.curtPage =self.curtPage
		data.userCode = public.userCode
		st.send(HallHead.wodecy,data)
	elseif self.select == 5 then
		data.groupCode = self.clubinfo.groupCode
        data.curtPage =self.curtPage
		--data.userCode = public.userCode
		st.send(HallHead.cycyxy,data)
	end
	--showWait(5)
end
function cyglLayer:reUi()
	for k,v in pairs(self.pk) do
		v:setVisible(false)
	end
    for k,v in pairs(self.pkimage) do
		v:setVisible(false)
	end
    
	for k,v in pairs(self.TT) do
		v:setVisible(false)
	end
	for k,v in pairs(self.PP) do
		v:setVisible(false)
	end
end
function cyglLayer:onButtonClickedEvent(tag,ref)
	local layer =nil 
	local name =""
    if tag == 100 then
        self.scene:upCoin()
		self:onClose()
	elseif tag >=1 and tag <=5 then
		if (tag == 1 ) and (self.clubinfo.groupRoleCode  == public.culbCode.huiyuan ) then  --只有群主才可以打or self.clubinfo.groupRoleCode  == public.culbCode.hehuoren 
			showToast("您没有权限!",1)
			return
        elseif  tag == 2 and (self.clubinfo.groupRoleCode  == public.culbCode.huiyuan or self.clubinfo.groupRoleCode  == public.culbCode.hehuoren ) then
            showToast("您没有权限!",1)
			return
		end
		self:selectB(tag)
	elseif tag == 11 then   --删除玩家
		layer = delwjLayer:create(self,self.clubinfo)
	elseif tag  == 12 then ---导入玩家
		layer = drculdLayer:create(self,self.clubinfo)
		local data = {}
		data.groupCode=self.clubinfo.groupCode
		st.send(HallHead.drcy,data)
		showWait(5)
	elseif tag   == 13 then  --创建合伙人
		layer = cjhhrLayer:create(self,self.fencengbili)
	elseif tag   == 14 then  --删除合伙人
		layer = delhhrLayer:create(self,self.clubinfo)
	elseif tag 	== 15 then   --我的成员
		self.scene:onButtonClickedEvent(101)
		local data = {}
		data.teamLeaderCode=public.userCode
		data.groupCode=self.clubinfo.groupCode
		st.send(HallHead.cyxzcy,data)
		showWait(5)
	elseif tag   == 16 then	 --自己调整自己的信用界面
        self:openscoreSetLayer(public.userCode)
	elseif tag  == 17 then  --添加玩家
		layer = yqwjLayer:create(self)
    elseif tag >20 and tag <24 then
        if ( tag == 21 and self.curtPage >1) or tag ==23 then
            if self.zongPage<= self.curtPage and tag == 23 then
                showToast("已经是最后一页了！")
                return
            end
            self.curtPage=self.curtPage+tag-22
            self:send()
        end
        
    elseif tag == 101 then
        local number=self.TF:getString()--:getText()
        if number=="" then
            showToast("请输入查询的ID号")
            return
        elseif string.len(number) ~= 6 then
            showToast("请正确输入ID号")
            return
        end
        local data = {}
        if self.select == 3 then
            data.teamLeaderCode=public.userCode
            data.groupCode=self.clubinfo.groupCode
            data.serchStr =self.TF:getString()
            st.send(HallHead.cyxzcy,data)

        elseif self.select == 1 then
            data.groupCode = self.clubinfo.groupCode
            data.serchStr =self.TF:getString()
            st.send(HallHead.cyglcy,data)
        end
    end
	if layer then
		if name ~= "" then
			layer:setName(name)
		end
		self:add(layer)
	end
end
function cyglLayer:onClose()
    EventMgr.removeEvent("cyglLayer")
    self:removeFromParent()
end
function cyglLayer:selectB(index)
	if self.bb[index] ==nil then
		return
	end
	for k,v in pairs(self.bb) do
		v:setEnabled(true)
        v:getChildByName("Text"):setColor(cc.c3b(114,69,21))
	end
	self.select = index
	self:selectPage()
end
function cyglLayer:inintP3(wdrs,zrs)
	self.PP[3]:getChildByName("T1"):setString(public.userName)--teamInfo.leaderValue)
	self.PP[3]:getChildByName("T2"):setString("ID:"..public.userCode)--teamInfo.leaderCode)
	self.PP[3]:getChildByName("T3"):setString("总成员:"..zrs)
	self.PP[3]:getChildByName("T4"):setString("我的成员:"..wdrs)
    local headbg=self.PP[3]:getChildByName("head")
    
    --设置头像
    ExternalFun.createClipHead(headbg,public.userCode,public.logoUrl,67)
    local Im =self.PP[3]:getChildByName("I")
        local str=nil
        if self.clubinfo.groupRoleCode  == public.culbCode.qunzhu then
            str=string.format("qunzhu.png")
            Im:loadTexture(str,ccui.TextureResType.plistType)
        elseif self.clubinfo.groupRoleCode  == public.culbCode.fuqunzhu  then
            str=string.format("fuqunzhu.png")
            Im:loadTexture(str,ccui.TextureResType.plistType)
        elseif self.clubinfo.groupRoleCode  == public.culbCode.hehuoren  then
            str=string.format("huoren.png")
            Im:loadTexture(str,ccui.TextureResType.plistType)
        else
            Im:setVisible(false)
        end  
end
function cyglLayer:inintP5(data)
	self.PP[5]:getChildByName("T1"):setString(data.userName)--teamInfo.leaderValue)
	self.PP[5]:getChildByName("T2"):setString("管理分:"..data.manageCoin)--teamInfo.leaderCode)
	self.PP[5]:getChildByName("T3"):setString("游戏分:"..data.gameCoin)
	self.PP[5]:getChildByName("T4"):setString("整组总分:"..data.allCoin)
    local headbg=self.PP[5]:getChildByName("head")
       --设置头像
    ExternalFun.createClipHead(headbg,data.userCode,data.logoUrl,67)
    
    local Im =self.PP[5]:getChildByName("I")
        local str=nil
        if data.groupRoleCode  == public.culbCode.qunzhu then
            str=string.format("qunzhu.png")
        elseif data.groupRoleCode  == public.culbCode.fuqunzhu  then
            str=string.format("fuqunzhu.png")
        elseif self.clubinfo.groupRoleCode  == public.culbCode.hehuoren  then
            str=string.format("huoren.png")
        else
            Im:setVisible(false)
        end
        if str then
            Im:loadTexture(str,ccui.TextureResType.plistType)
        end    
end
function cyglLayer:inint(data)
    --dump(data,"信息")
	--清理之前数据
	for k,v in pairs(self.pk) do
		v:removeAllChildren()
	end

	local PK =self.pk[2]
	if self.select == 1 or self.select == 2 then
		PK= self.pk[1]
	end
    if data == nil then
        return
    end
  
    local datas= data 
    if data.result then
        datas = data.result
    end
	for k,v in pairs(datas) do
		local item = self.P[self.select]:clone()
		if self.select == 2 then  --过滤消息
			if  v.toGroupCode == self.clubinfo.groupCode then
				self:pushitem(item,v)
				PK:pushBackCustomItem(item)
			end
		else
			self:pushitem(item,v)
			PK:pushBackCustomItem(item)
		end
        item:setVisible(true)
	end
    
    ---显示页数筹码
    --  self.Bp1:setVisible(false)
    -- self.yeshu:setVisible(false)
    -- self.yeshuz:setVisible(false)
    -- self.Bp2:setVisible(false)
    -- self.yeshuzg:setVisible(false)
    if data.totalPage and data.totalPage >0  then
        self.Bp1:setVisible(true)
        if self.curtPage == 1 then
            self.Bp1:setEnabled(false)
        else
            self.Bp1:setEnabled(true)
        end
        self.Bp2:setVisible(true)
        if self.curtPage < data.totalPage then
            self.Bp2:setEnabled(true)
        else
            self.Bp2:setEnabled(false)
        end
        self.zongPage=data.totalPage
        self.yeshu:setString(self.curtPage)
        self.yeshu:setVisible(true)
        
        self.yeshuz:setString(data.totalPage.."页")
        self.yeshuz:setVisible(true)
        
        self.yeshuzg:setString("总"..data.total.."条")
        self.yeshuzg:setVisible(true)
    end
end

function cyglLayer:pushitem(item,data)
    local Touxiangback = function (ref, type)
		if type == ccui.TouchEventType.ended then
		elseif type == ccui.TouchEventType.began then
            if data then
                if  data.userCode then
                    self.scene:openPlayerInfo(data.userCode)
                elseif data.teamLeaderCode then
                    self.scene:openPlayerInfo(data.teamLeaderCode)
                end
            end
			return true
		elseif type == ccui.TouchEventType.canceled then
		end
    end
	if self.select == 1 then
		item:getChildByName("T1"):setString(data.userName)
		item:getChildByName("T2"):setString(data.userCode)
		item:getChildByName("T3"):setString(data.fcbl)
		item:getChildByName("T4"):setString(data.zsf)
		item:getChildByName("T5"):setString(data.gameCoin)
		item:getChildByName("T6"):setString(data.manageCoin)
		item:getChildByName("T7"):setString(data.parentUserValue)
		item:getChildByName("T8"):setString(data.teamValue)
        local headbg =item:getChildByName("head")
        --设置头像
        ExternalFun.createClipHead(headbg,data.userCode,data.logoUrl,67)
        item:getChildByName("b_h"):addTouchEventListener(Touxiangback)
	elseif self.select  == 3 then
        --dump(data,"我的成员")
		local btcallback = function (ref, type)
			if type == ccui.TouchEventType.ended then
				ExternalFun.playClickEffect()
				--ref:setScale(1)
				local index= ref:getTag()
				local layer= nil
				local name = ""
				if index ==1 then
                    self:openscoreSetLayer(data.userCode)
                elseif index == 3 or index == 4 then
                    index=index-2
                    function Senddata(datas)
                        if index == 1 then
                            item:getChildByName("B3"):setVisible(false)
                            item:getChildByName("B4"):setVisible(true)
                        else
                            item:getChildByName("B3"):setVisible(true)
                            item:getChildByName("B4"):setVisible(false)
                        end
                    end
                        local clubinfo = public.getclubinfo(public.enterclubid)
                        local Http={HttpHead.xzfbz,HttpHead.scfbz}
                        local url=Http[index]
                        local datas ={}
                        datas.userCode =data.userCode
                        datas.groupCode=clubinfo.groupCode
                        httpnect.send(url,data,Senddata)
                else
					layer = wjxyLayer:create(self,data.userCode)
                    name="wjxyLayer"
				end
				if name ~= "" then
                    self:add(layer)
					layer:setName(name)
				end
			elseif type == ccui.TouchEventType.began then
				--ref:setScale(public.btscale)
				return true
			elseif type == ccui.TouchEventType.canceled then
				--ref:setScale(1)
			end
		end
		item:getChildByName("B1")
		:setTag(1)
		:addTouchEventListener(btcallback)
		item:getChildByName("B2")
		:setTag(2)
		:addTouchEventListener(btcallback)
        item:getChildByName("B3")
		:setTag(3)
		:addTouchEventListener(btcallback)
        item:getChildByName("B4")
		:setTag(4)
		:addTouchEventListener(btcallback)

		item:getChildByName("T1"):setString(data.userName)
		item:getChildByName("T2"):setString(data.userCode)--ExternalFun.showUserCode(data.userCode))
		item:getChildByName("T3"):setString(data.gameCoin)
		item:getChildByName("T4"):setString(data.manageCoin)
        local headbg=item:getChildByName("head")
        --设置头像
        ExternalFun.createClipHead(headbg,data.userCode,data.logoUrl,67)
        if self.clubinfo.groupRoleCode  == public.culbCode.qunzhu then
            if data.groupRoleCode  == public.culbCode.fuqunzhu then
                item:getChildByName("B3"):setVisible(false)
                item:getChildByName("B4"):setVisible(true)
            else
                item:getChildByName("B4"):setVisible(false)
                item:getChildByName("B3"):setVisible(true)
            end
        else
            item:getChildByName("B4"):setVisible(false)
            item:getChildByName("B3"):setVisible(false)
        end
        item:getChildByName("b_h"):addTouchEventListener(Touxiangback)
	elseif self.select == 2 then
		local btcallback = function (ref, type)
			if type == ccui.TouchEventType.ended then
				ExternalFun.playClickEffect()
				--ref:setScale(1)
				local sdata={}						--消息处理
				sdata.messageId=data.id
				sdata.acceptOrReject=ref:getTag()
				st.send(HallHead.xxcculb,sdata)
			elseif type == ccui.TouchEventType.began then
				--ref:setScale(public.btscale)
				return true
			elseif type == ccui.TouchEventType.canceled then
				--ref:setScale(1)
			end
		end
		item:getChildByName("B1")
		:setTag(1)
		:addTouchEventListener(btcallback)
		item:getChildByName("B2")
		:setTag(2)
		:addTouchEventListener(btcallback)
		item:getChildByName("T1"):setString(data.fromUserValue)
		item:getChildByName("T2"):setString("ID:"..data.fromUserCode)--ExternalFun.showUserCode(data.fromUserCode))
		local str= string.sub(data.createTime,1,10)
		item:getChildByName("T3"):setString(str)
        local headbg=item:getChildByName("head")
        --设置头像
        ExternalFun.createClipHead(headbg,data.fromUserCode,data.logoUrl,67)
        item:getChildByName("b_h"):addTouchEventListener(Touxiangback)
	elseif self.select == 4 then
		local btcallback = function (ref, type)
			if type == ccui.TouchEventType.ended then
				ExternalFun.playClickEffect()
				--ref:setScale(1)
                if ref:getTag() == 1 then
                    self.scene:onButtonClickedEvent(101)
                    local datas = {}
                    datas.teamLeaderCode=data.teamLeaderCode
                    datas.groupCode=self.clubinfo.groupCode
                    datas.userCode = public.userCode
                    st.send(HallHead.cyxzcy,datas)
                    elseif ref:getTag() == 2 then
                    item:getChildByName("B3"):setVisible(true)
                    item:getChildByName("B2"):setVisible(false)
                    item:getChildByName("Image"):setVisible(true)
                    elseif ref:getTag() == 3 then
                     --调整比例
                    local bili=item:getChildByName("Image"):getChildByName("Image"):getChildByName("TF"):getString()
                        
                        function Senddata(datas)
                            item:getChildByName("T4"):setString(bili)
                            item:getChildByName("B2"):setVisible(true)
                            item:getChildByName("B3"):setVisible(false)
                            item:getChildByName("Image"):setVisible(false)
                        end
                       if bili == nil then
                           showToast("比例调整错误",2)
                            return
                       end
                    bili=tonumber(bili)
                    if tonumber(bili) and bili < tonumber(data.fcbl) and bili >= 100 then
                        showToast("比例调整错误",2)
                        return
                    end
                    local datas = {}
                    datas.teamLeaderCode=data.teamLeaderCode
                    datas.groupCode=self.clubinfo.groupCode
                    datas.userCode = public.userCode
                    datas.fcbl2 =bili
                    httpnect.send(HttpHead.changeUserFcbl,datas,Senddata)

                end
			elseif type == ccui.TouchEventType.began then
				--ref:setScale(public.btscale)
				return true
			elseif type == ccui.TouchEventType.canceled then
				--ref:setScale(1)
			end
		end
		item:getChildByName("B1")
		:setTag(1)
		:addTouchEventListener(btcallback)
        item:getChildByName("B2")
		:setTag(2)
		:addTouchEventListener(btcallback)
        item:getChildByName("B3")
		:setTag(3)
		:addTouchEventListener(btcallback)
         item:getChildByName("B3"):setVisible(false)
        
                --查询ID
        local shuru=item:getChildByName("Image")
        -- local ttt=self.bj:getChildByName("TF")
        local TF = ExternalFun.cteartTFtwo(shuru:getChildByName("Image"),shuru,data.fcbl,true,nil,nil,30)
        item:getChildByName("Image"):setVisible(false)
        
		item:getChildByName("T1"):setString(data.teamLeaderValue)
		item:getChildByName("T2"):setString("ID:"..data.teamLeaderCode)--ExternalFun.showUserCode(data.teamLeaderCode))
		item:getChildByName("T3"):setString(data.teamValue)
		item:getChildByName("T4"):setString(data.fcbl)
        local headbg =item:getChildByName("head")
        --设置头像
        ExternalFun.createClipHead(headbg,data.teamLeaderCode,data.teamLeaderLogourl,67)
        item:getChildByName("b_h"):addTouchEventListener(Touxiangback)
	elseif self.select == 5 then
		local btcallback = function (ref, type)
			if type == ccui.TouchEventType.ended then
				ExternalFun.playClickEffect()
				--ref:setScale(1)
				local index= ref:getTag()
				local layer= nil
				local name = ""
				if index ==1 then
                    self:openscoreSetLayer(data.userCode)
				elseif index == 2 then
					self.scene:onButtonClickedEvent(101)
					local datas = {}
					datas.teamLeaderCode=data.userCode
					datas.groupCode=self.clubinfo.groupCode
					datas.userCode = public.userCode
					st.send(HallHead.cyxzcy,datas)
					showWait(5)
				elseif index == 3 then
					layer = wjxyLayer:create(self,data.userCode)
				end
				if layer ~= nil then
					self:add(layer)
				end
				if name ~= "" then
					layer:setName(name)
				end
			elseif type == ccui.TouchEventType.began then
				--ref:setScale(public.btscale)
				return true
			elseif type == ccui.TouchEventType.canceled then
				--ref:setScale(1)
			end
		end
		item:getChildByName("B1")
		:setTag(1)
		:addTouchEventListener(btcallback)
		item:getChildByName("B2")
		:setTag(2)
		:addTouchEventListener(btcallback)
		item:getChildByName("B3")
		:setTag(3)
		:addTouchEventListener(btcallback)

		item:getChildByName("T1"):setString(data.userName)
		item:getChildByName("T2"):setString("ID:"..data.userCode)--ExternalFun.showUserCode(data.userCode))
		item:getChildByName("T3"):setString(data.manageCoin)
		item:getChildByName("T4"):setString(data.gameCoin)
		item:getChildByName("T5"):setString(data.allCoin)
        local headbg =item:getChildByName("head")
        --设置头像
        ExternalFun.createClipHead(headbg,data.userCode,data.logoUrl,67)
        item:getChildByName("b_h"):addTouchEventListener(Touxiangback)
	end
end
--打开赠送页面
function cyglLayer:openscoreSetLayer(userCode)
    local data={}
	data.userCode = userCode
	data.groupCode=self.clubinfo.groupCode
	st.send(HallHead.cxculbwj,data)
    
    local layer = scoreSetLayer:create(self.scene,self.clubinfo)
    name="scoreSetLayer"
    self.scene:add(layer)
	layer:setName(name)
    showWait(5)
end
--消息处理
function cyglLayer:message(code,data)
    if code == HallHead.cyglcy or code == HallHead.xxculb or code == HallHead.wodecy
		or code == HallHead.cyxzcy or code == HallHead.cycyxy then
		local datas= data
		if HallHead.wodecy == code  then
            if data.teamInfo and data.teamInfo.fcbl then
                local fencengbili=tonumber(data.teamInfo.fcbl)
                if fencengbili >0 then
                    local str="分成比例:"..fencengbili
                    self.PP[4]:getChildByName("T2"):setString(str)
                    self.fencengbili=fencengbili
                end
            else
                fencengbili=0
                local str="分成比例:"..fencengbili
                self.PP[4]:getChildByName("T2"):setString(str)
                self.fencengbili=fencengbili
            end
		end
		if HallHead.cyxzcy == code then
			self:inintP3(data.wdzrs,data.zrs)
		end
		if HallHead.cycyxy == code then
			self:inintP5(data.myInfo)
		end
        if HallHead.wodecy == code  and self.select ~= 4  then
            return
        elseif HallHead.cyxzcy == code and self.select ~= 3 then
            return
        elseif HallHead.cycyxy == code and self.select ~= 5 then
            return
        end
		self:inint(datas)
	end
end

return cyglLayer
