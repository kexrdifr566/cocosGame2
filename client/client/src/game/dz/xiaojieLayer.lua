local xiaojieLayer = class("xiaojieLayer", function ()
	local xiaojieLayer =  display.newLayer()
	return xiaojieLayer
end)
function xiaojieLayer:ctor(_scene)
	local rootLayer, csbNode = ExternalFun.loadzRootCSB("Game/dzLayer/xiaojieLayer.csb", self)
	self.csbNode=csbNode
    self.TT=csbNode:getChildByName("T")
    self.ii={}
    for i=1,5 do 
		local index =string.format("I%d",i)
		self.ii[i]=self.csbNode:getChildByName(index)
	end
end
function xiaojieLayer:inint(data)
	-- local cards={}
	-- local px=""
	-- for k,v in pairs(data.winers) do
		-- if v.userCode == data.maxPxUserCode then
			-- cards=v.cards
			-- px=v.px
		-- end
	-- end
    -- dump(cards,"手牌")
	self.TT:setString(data.maxPx)
	for i=1,5 do 
		self.ii[i]:setVisible(false)
	end
	for k,v in pairs(data.maxPxCards) do 
		local shuzhi = self:zhuanhuan(v.rank)
		self.ii[k]:setVisible(true)
		self.ii[k]:getChildByName("T"):setString(shuzhi)
	end

end
function xiaojieLayer:zhuanhuan(shuzhi)
	if shuzhi <=8 then
		shuzhi=shuzhi+2
	elseif shuzhi ==9 then
		shuzhi="J"
	elseif shuzhi ==10 then
		shuzhi="Q"
	elseif shuzhi ==11 then
		shuzhi="K"
	elseif shuzhi ==12 then
		shuzhi="A"
	end
	return shuzhi
end
return xiaojieLayer

--"cards" = *MAX NESTING*