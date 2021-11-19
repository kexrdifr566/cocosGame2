
ExternalFun =ExternalFun or {}
ExternalFun.tryTime = 1

ExternalFun.armatureNameAddList={}
ExternalFun.armatureNameList = {}


function ExternalFun.initExternalFun( ... )
	yl.armatureNameAddingList={}
	yl.armatureNameAsyncAddList ={}
	yl.loadplistidx = {}
end

function currentTime() 
	local clock = os.clock() 
	return clock*1000
end

function  ExternalFun.playOpenLayerAnimation( node )
--	local nodeanchor = node:getAnchorPoint()
--	node:setAnchorPoint(0.5,0.5)
		node:setScale(0.7)
		local act3 = cc.ScaleTo:create(0.1,1.05)
		local act4 = cc.ScaleTo:create(0.05,1)
		local call = cc.CallFunc:create(function ()
	--		node:setAnchorPoint(nodeanchor)
		end)
		
			node:runAction(cc.Sequence:create(cc.EaseElasticOut:create(cc.ScaleTo:create(0.5,appdf.g_scaleY,appdf.g_scaleY),0.95),call))
end
function ExternalFun.playSubLoading(parent,pos)
	local parentsize = parent:getContentSize()
	local node = display.newNode()
	local pos = pos or cc.p(parentsize.width/2,parentsize.height/2)
	local groundsp = display.newSprite("public/loadground.png"):move(pos):addTo(node)
	local iconsp = display.newSprite("public/loadicon.png"):move(pos):addTo(node)
	groundsp:runAction(cc.RepeatForever:create(cc.RotateBy:create(2 , 360)))
	parent:addChild(node)
	return node
end
function  ExternalFun.removeSameSearPath( ... )
	local oldPaths = cc.FileUtils:getInstance():getSearchPaths();
	-- dump(oldPaths,"oldPaths111")
	for j=#oldPaths,1,-1 do
		for i=j-1,1,-1 do
			if oldPaths[j] == oldPaths[i] then
				print("getSearchPaths>>>>>",j,i,oldPaths[j])
				table.remove(oldPaths,j)
				break
			end
		end
	end
	-- dump(oldPaths,"oldPaths111")
	cc.FileUtils:getInstance():setSearchPaths(oldPaths)
end
--选择性
function  ExternalFun.selectBandP(b,p,index)
	if b[index] ==nil or p[index] ==nil then
		return
	end
	for k,v in pairs(b) do
		v:setEnabled(true)
        if k == index then
            v:setEnabled(false)
        end
	end
	for k,v in pairs(p) do
		v:setVisible(false)
        if k == index then
            v:setVisible(true)
        end
	end
end
--获取适配Y的距离
function ExternalFun.getCenterFixY()
	local scaleFactor = display.height/750
	return 750*(scaleFactor-1)/2
end
--获取适配Y的距离
function ExternalFun.getTopFixY()
	local scaleFactor = display.height/750
	return 750*(scaleFactor-1)
end

--适配函数 缩放
function ExternalFun.FixScalePoint(tbPoint,viewid,side,adptScale)
	local scaleFactor = display.height/750
	--print("FixScaleUI>>>>>>",scaleFactor)
	if not tbPoint or scaleFactor >= 1 then
		return 
	end
	adptScale = adptScale or 0
	local sidevalue = side and -1 or 1
	for i=1,#tbPoint do
		if i~=viewid then
			local p = tbPoint[i]
			p.y = p.y - (1-(scaleFactor))*p.y*sidevalue - adptScale
		end
	end
end
--适配函数 缩放
function ExternalFun.FixScalePointX(tbPoint)
	local scaleFactor = display.width/1334
	print("FixScaleUI>>>>>>",scaleFactor)


	for i=1,#tbPoint do
		local p = tbPoint[i]
		p.x = p.x - (1-(scaleFactor))*p.x

	end
end

function ExternalFun.FixPointY(py,side,offset)
	side = side and -1 or 1
	offset = offset or 0
	local scaleFactor = display.height/750
	if scaleFactor >= 1 then
		return py
	end
	return py - (1-scaleFactor)*py*side + offset
end

function ExternalFun.FixGridY(py,gridsize,side)
	side = side and -1 or 1
	local scaleFactor = display.height/750
	if scaleFactor >= 1 then
		return py
	end
	return py - (1-scaleFactor)*side*1.6-gridsize
end

function ExternalFun.FixDeltaPointY(py,side)
	local scaleFactor = display.height/750
	if scaleFactor >= 1 then
		return py
	end
	local side = side and -1 or 1
	return py - (750-display.height)*scaleFactor*side
end

function ExternalFun.FixNodeOffsetPointY(node,py)
	local scaleFactor = display.height/750
	if scaleFactor >= 1 then
		return 
	end
	local posy = node:getPositionY()
	node:setPositionY(posy+py)
	
end


function ExternalFun.FixNodeDeltaPointY(node,side)
	local scaleFactor = display.height/750
	if scaleFactor >= 1 then
		return
	end
	local py = node:getPositionY()
	local side = side and -1 or 1
	py = py - (1-scaleFactor)*py*scaleFactor*side
	node:setPositionY(py)
end

--适配函数 靠中
function ExternalFun.FixCenterPosY(node,py,_scale,side,offsetY)
	py = py or node:getPositionY()
	local scaleFactor = _scale or display.height/750
	if display.height/750 >= 1 then
		return py
	end
	offsetY = offsetY or 0
	side = side and -1 or 1
	if not node then
		return py-(750-display.height)*scaleFactor*side-offsetY
	else
		node:setPositionY(py-(750-display.height)*scaleFactor*side-offsetY)
	end
end

function ExternalFun.FixCenterScalePoint(tbPoint,viewid)
	local scaleFactor = display.height/750
	if not tbPoint then
		return
	end
	if scaleFactor >= 1 then
		return 
	end
	for i=1,#tbPoint do
		local p = tbPoint[i]
		if i~=viewid then
			p.y = p.y-(750-display.height)*(1-(1-scaleFactor)/2)
		else
			p.y = p.y-(750-display.height)
		end
	end
end

function ExternalFun.FixScaleUIPoint(pt,fixOffsetY,side,fixOffsetX,bottomAnch)
	local scaleFactor = display.height/750
	if scaleFactor >= 1 then
		return 
	end
	local scaleDisX = (display.width/2-pt.x)*(1-scaleFactor)
	pt.x =  pt.x + scaleDisX + (fixOffsetX or 0)

	local scaleDisY = math.abs(display.height/2-pt.y)*(1-scaleFactor)
	if bottomAnch then  
		scaleDisY = pt.y*(1-scaleFactor)
	end
	side = side or 1
	pt.y =  pt.y - scaleDisY*side + (fixOffsetY or 0 )
	
end

--适配函数 缩放
function ExternalFun.FixScaleUI(node,notOffsetY,notOffsetX,_scale,bFixView,bmoveX)
	local scaleFactor = display.height/750
	print("FixScaleUI>>>>>>",scaleFactor)
	if tolua.isnull(node) or scaleFactor >= 1 then
		return 0,0
	end
	local anch = node:getAnchorPoint()
	local posy = node:getPositionY()
	local posx = node:getPositionX()
	local tbsize = node:getContentSize()
	if tbsize.height == 0 then
		tbsize.height = display.height
	end
	local sidex = notOffsetX and -1 or 1
	local sidey = notOffsetY and -1 or 1
	local sizeScaleY = _scale or 1
	local offsetY = 0
	local offsetX = 0
	if anch.y == 0  then
		offsetY=tbsize.height*(1-scaleFactor)*sidey*sizeScaleY
	elseif anch.y == 0.5 then
		offsetY=tbsize.height*(1-scaleFactor)*sidey*0.4*sizeScaleY
	end

	if anch.x == 0 or bmoveX then
		offsetX = tbsize.width*(1-scaleFactor)*sidex/2
		node:setPositionX(posx+offsetX)
	end
	node:setPositionY(posy+offsetY)
	dump(anch,"anch FixScaleUI")
	node:setScale(scaleFactor)
	if bFixView  then
		local size = node:getContentSize()
		node:setContentSize(cc.size(size.width/scaleFactor,size.height))
	end
	return offsetY,offsetX
end

function ExternalFun.FixViewHeight(node,notOffset)
	local scaleFactor = display.height/750
	print("FixScaleUI>>>>>>",scaleFactor)
	if tolua.isnull(node) or scaleFactor >= 1 then
		return 0
	end

	local anch = node:getAnchorPoint()
	local posy = node:getPositionY()
	local size = node:getContentSize()
	local tbsize = node:getContentSize()
	local side = notOffset and -1 or 1
	local offsetY = 0
	if anch.y == 0  then
		offsetY=tbsize.height*(1-scaleFactor)*side
	elseif anch.y == 0.5 then
		offsetY=tbsize.height*(1-scaleFactor)*side*0.4
	end
	node:setPositionY(posy+offsetY)
	dump(anch,"anch FixScaleUI")
	node:setContentSize(cc.size(size.width,size.height*scaleFactor))
	return offsetY
end

function ExternalFun.FixScaleNode(node)
	local scaleFactor = display.height/750
	print("FixScaleUI>>>>>>",scaleFactor)
	if tolua.isnull(node) or scaleFactor >= 1 then
		return
	end
	node:setScale(scaleFactor)
end

function ExternalFun.FixNodeScaleX(node)
	local w = node:getContentSize().width
	local scaleFactor = display.width/w
	if scaleFactor >= 1 then
		return
	end
	node:setScale(scaleFactor)
end


function ExternalFun.FixScalePosX(pos)
	local scaleFactor = display.height/750
	print("FixScaleUI>>>>>>",scaleFactor)
	if scaleFactor >= 1 then
		return pos
	end
	return pos*scaleFactor
end

--适配函数 靠上
function ExternalFun.FixTopUI(node,bscale)
	local scaleFactor = display.height/750
	if tolua.isnull(node) then
		return
	end
	if scaleFactor >= 1 then
		-- return 
	end
	local nodeY = node:getPositionY()--yl.SCENE_DELTA_HEIGHT
	local offsety = nodeY+(750*(scaleFactor-1))
	node:setPositionY(offsety)
	if bscale then
		node:setScale(scaleFactor)
	end
end

--适配函数 靠中
function ExternalFun.FixCenterUI(node,side)
	local scaleFactor = display.height/750
	if scaleFactor >= 1 then
		return 
	end
	side =  side and -1 or 1
	local nodeY = node:getPositionY()
	node:setPositionY(nodeY-(750*(scaleFactor-1))*side/4)
end

function ExternalFun.FixTopSize(node)
	local size = node:getContentSize()
	node:setContentSize(cc.size(size.width,size.height+ExternalFun.getTopFixY()))
	return node
end
--添加骨骼动画
--notloop  true 不循环 false循环
function ExternalFun.addSpineWithCustomNode(ArmName,parent,AnimationName,point,notloop) 
		AnimationName = AnimationName or "animation"
		local spine =  parent:getChildByName(ArmName..AnimationName)
		if not spine  or notClear then
			-- pcall(function( ... )
				-- body
				local jsonstr = string.format("%s.json",ArmName)
				local atlasstr = string.format("%s.atlas",ArmName)
				local spine = sp.SkeletonAnimation:create(jsonstr,atlasstr , 1)
				spine:setName(ArmName..AnimationName)
				parent:addChild(spine) 
				if point then
					spine:setPosition(point.x, point.y )       
				else
					spine:setPosition(parent:getContentSize().width /2,  parent:getContentSize().height/2)       
				end
				spine:setAnimation(0, AnimationName, not notloop)
				return spine
			-- end)
		end
		spine:setAnimation(0, AnimationName, not notloop)
		if point then
			spine:setPosition(point.x, point.y )       
		else
			spine:setPosition(parent:getContentSize().width /2,  parent:getContentSize().height/2)       
		end
		return spine
end
function ExternalFun.PlayGameAction(atype,node)
    local str="animation"
    if atype ==4 then 
        str="animation2"
    end
    local spine=ExternalFun.addSpineWithCustomNode("Game/brAction/newaction/tongsha_pei",node,str,cc.p(640,420),true) 
    spine:registerSpineEventHandler(function (event)
        performWithDelay(self,function ()
            spine:removeFromParent()
            end,0.2)
    end, sp.EventType.ANIMATION_COMPLETE)
end
--添加骨骼动画
function ExternalFun.addArmatureWithCustomNode(ArmName,parent,AnimationName,point,noInsert,notClear) 
		AnimationName = AnimationName or "Animation1"
		local armature =  parent:getChildByName(ArmName..AnimationName)
		if not armature  or notClear then
			-- pcall(function( ... )
				-- body
				armature = ccs.Armature:create(ArmName) 
				armature:setName(ArmName..AnimationName)
				parent:addChild(armature) 
				local size = armature:getContentSize()
				if point then
					armature:setPosition(point.x, point.y )       
				else
					armature:setPosition(parent:getContentSize().width /2,  parent:getContentSize().height/2)       
				end
				local animation = armature:getAnimation()
				animation:play(AnimationName)
				return armature,animation
			-- end)
		end
		local animation = armature:getAnimation()
		animation:play(AnimationName)
		if point then
			armature:setPosition(point.x, point.y )       
		else
			armature:setPosition(parent:getContentSize().width /2,  parent:getContentSize().height/2)       
		end
		return armature,animation
end


function ExternalFun.setCustomGameDefine(tb)
	yl.loadplistidx = tb
end

function ExternalFun.updateAddingArmatureList( )
	-- ExternalFun.armatureNameAddList[ArmName]
	if yl.armatureNameAddingList then
		for v,data in pairs(yl.armatureNameAddingList) do
			if yl.armatureNameAsyncAddList[v] then
				while yl.armatureNameAsyncAddList[v] and #data > 0 do
					local armParams= table.remove(data,1)
					if  ExternalFun.addArmatureAsyncWithCustomNode(armParams) == 1  then
						break
					end
				end
				if #data == 0 then
					yl.armatureNameAddingList[v] = nil
				end
				break
			end
		end
	end
end


--异步添加骨骼动画
function ExternalFun.addArmatureAsyncWithCustomNode(armParams,bforceload)

	if not armParams.file_path or not armParams.armName then
		return
	end
	local filepath = armParams.file_path
	local ArmName = armParams.armName
	local parent = armParams.node
	local AnimationName = armParams.animationName
	local point = armParams.pos
	local callback = armParams.callback
	local color = armParams.color
	local opacity = armParams.opacity
	local scale = armParams.scale
	local tag = armParams.tag
	local zorder = armParams.zorder
	local isNotAdd = armParams.isNotAdd
	local name = armParams.name
	AnimationName = AnimationName or "Animation1"
	local addArm = function( ... )
		xpcall(function( ... )
			local armature = ccs.Armature:create(ArmName) 
			armature.name = name;
			if not isNotAdd then
				if not tolua.isnull(parent) then
					parent:addChild(armature,zorder or 0) 
				end
				armature.scale = scale
				armature:setName(ArmName..AnimationName)
				if scale then
					armature:setScale(scale or 1)
				end
				if tag then
					armature:setTag(tag);
				end
				if point then
					armature:setPosition(point)       
				end
				local animation = armature:getAnimation()
				animation:play(AnimationName)
				if color then
					armature:setColor(color)
					armature:setOpacity(opacity)
				end
			end
			if callback then
				callback(armature,animation)
			end
			return armature
		end,function( e )
			local runScene = cc.Director:getInstance():getRunningScene()
			showToast(runScene,"load "..ArmName.." failed "..e,2)
			yl.armatureNameAsyncAddList[ArmName] = nil
			-- ExternalFun.armatureNameAddingList[ArmName] = nil
			ExternalFun.addArmatureAsyncWithCustomNode(armParams,true)
			return 1
		end)

	end

	if yl.armatureNameAsyncAddList[ArmName] and not bforceload then
		return addArm()
	else
		if not yl.armatureNameAddingList[ArmName] then
			yl.armatureNameAddingList[ArmName] = {}
			table.insert(yl.armatureNameAddingList[ArmName],armParams )
		else
			table.insert(yl.armatureNameAddingList[ArmName],armParams )
			if not bforceload then
				return
			end
		end
		local datalist = {}
		local plistTb = yl.loadplistidx[ArmName] or {0}
		for i,v in ipairs(plistTb) do
			local imagepath = filepath..ArmName..v..".png"
			local plistpath = filepath..ArmName..v..".plist"
			table.insert(datalist,{plistpath,imagepath})
		end
		ExternalFun.addSpriteFramesCacheAsync(datalist,function( ... )
			print("addArmatureFileInfoAsync>>>>",filepath..ArmName)
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(filepath..ArmName..".ExportJson",function(args)
				-- local runScene = parent or cc.Director:getInstance():getRunningScene()
				-- ExternalFun.finishArmName = ArmName
				yl.armatureNameAsyncAddList[ArmName] = true
				-- performWithDelay(runScene,function( ... )
				-- 	ExternalFun.updateAddingArmatureList(ArmName)
				-- end,0.01)
			end)
		  end) 
		
	end
end



function ExternalFun.removeArmatureCache() 
	for k,v in pairs(ExternalFun.armatureNameList) do
		ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(v)
	end
	ExternalFun.armatureNameAddList={}
	ExternalFun.armatureNameList = {}
end

function ExternalFun.addArmatureCache(tbfileName) 
	for k,v in pairs(tbfileName) do
		if ExternalFun.checkFileIsExit(v) then
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(v)
			table.insert(ExternalFun.armatureNameList,v)
			ExternalFun.armatureNameAddList[v] = true
		end
	end
end
function ExternalFun.addArmatureCacheNew(data) 
	for k,v in pairs(data) do
		if  v.format == "cocos" then
			if ExternalFun.checkFileIsExit(v.file)  then
				ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(v.file)
				table.insert(ExternalFun.armatureNameList,v.file)
				ExternalFun.armatureNameAddList[v.file] = true
			end
		else
			if ExternalFun.checkFileIsExit(v.file..".json")  then
				v.ani = sp.SkeletonAnimation:create(v.file..".json",v.file..".atlas",1)
			end
		end
	end
end

function ExternalFun.addArmatureCacheAsync(tbfileName,cb) 
	local loadlen = #tbfileName
	print("ExternalFun.addArmatureCacheAsync>>",loadlen)
	local inloading = 0
	local callback = function( loadname )
		loadlen = loadlen - 1
		inloading = inloading - 1
		if loadlen == 0 and cb then
			cb()
		elseif inloading == 0 and #tbfileName > 0 then
			ExternalFun.addArmatureCacheAsync(tbfileName,cb) 
		end
		if loadname then
			ExternalFun.armatureNameAddList[loadname] = true
			table.insert(ExternalFun.armatureNameList,loadname)
		end
	end
	for i=1, 5 do
		if #tbfileName > 0 then
			local v = table.remove(tbfileName,1)
			print("addArmatureCacheAsync>>>",v)
			inloading = inloading + 1
			if ExternalFun.armatureNameAddList[v] and not ExternalFun.checkFileIsExit(v) then
				callback(v)
			else
				ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(v,function( ... )
					callback(v)
				end)
				
			end
		else
			return
		end
	end
end

function ExternalFun.addSpriteFramesCacheAsync(tbfileName,cb) 
	local loadlen = #tbfileName
	if loadlen < 1 and cb then
		cb()
		return
	end
	print("addSpriteFramesCacheAsync>>>>>>",loadlen)
	local inloading = 0
	local callback = function( ... )
		loadlen = loadlen - 1
		inloading = inloading - 1
		print("callback>>22222>>>>",loadlen)
		if loadlen == 0 and cb then
			cb()
		elseif inloading == 0 and #tbfileName > 0 then
			ExternalFun.addSpriteFramesCacheAsync(tbfileName,cb) 
		end
	end
	for i=1,loadlen do
		if i < 10 then
			inloading = inloading + 1
			local v = table.remove(tbfileName,1)
			--dump(v,"addSpriteFramesCacheAsync")
			if v then
				display.loadSpriteFrames(v[1], v[2], callback)
			else
				callback()
			end
		else
			break
		end
	end
end

--改变比例
function ExternalFun.ChangeScore(score,point,symbol,isZheng,isNumberThous) 
    score = score or GlobalUserItem.lUserScore or 0

    local str = 0
	str = string.format("%.2f",score)
	local returnScore =  tonumber(str)  --保留不为0的小数点
	if not returnScore  then
		return str
	else
		return returnScore
	end
    
end

--改变比例
function ExternalFun.ChangeScorePoint(score,point,symbol,isZheng,isNumberThous) 
    score = score or GlobalUserItem.lUserScore

    local str = 0
	local scoreInt
	score = string.gsub(score,",","")
	score = tonumber(score)
	point = point or 1
	symbol = symbol or " "

	-- print("ChangeScore>>>>>>>",score,appdf.Ratio,appdf.bili)
    if appdf.Ratio then
	
		scoreInt = score/appdf.bili
		scoreInt = 0.01*math.floor(scoreInt*100)
		if isZheng then --isZheng
			scoreInt = math.modf(scoreInt)
		end
		if scoreInt >= 1000 then
			str = string.formatNumberThousands( string.format("%."..(point or 1) .."f",scoreInt),true,symbol or "/") 
		else
			str = string.format("%."..(point or 1) .."f",scoreInt)
		end 
    else
       str = string.formatNumberThousands( score,true,symbol or "/")
		scoreInt = score
    end
	if true  then -- isNumberThous
		str = string.gsub(str,",","")
		return str 
	else
		return  str
	end
    
end


function ExternalFun.ChangeSicScore(score,point,symbol,isZheng,isNumberThous) 
    score = score or GlobalUserItem.lUserScore

    local str = 0
	local scoreInt
	score = string.gsub(score,",","")
	score = tonumber(score)

	-- print("ChangeScore>>>>>>>",score,appdf.Ratio,appdf.bili)

    if appdf.Ratio then
	
		scoreInt = score/appdf.bili
		scoreInt = 0.01*math.floor(scoreInt*100)
		if isZheng then
			scoreInt = math.modf(scoreInt)
		end
       str = string.formatNumberThousands( string.format("%."..point .."f",scoreInt),true,symbol or "/") 
    else
       str = string.formatNumberThousands( score,true,symbol or "/")
	   scoreInt = score
    end
	if isNumberThous then
		str = string.gsub(str,",","")
		return tonumber(str) 
	else
	return  str
	end
    
end

function ExternalFun.ChangeScore_bank(score,point,symbol,isZheng) 
    score = score or GlobalUserItem.lUserScore
    local str = 0
	local scoreInt
	local fushu = false
	if string.find(score,"-",1) then
		fushu = true
		score = string.gsub(score,"-","")
	else
		fushu = false
		score = string.gsub(score,"+","")
	end
    if appdf.Ratio then
		score = string.gsub(score,",","")

		scoreInt = score/appdf.bili
		scoreInt = 0.01*math.floor(scoreInt*100)
		if isZheng then
			scoreInt = math.modf(scoreInt)
		end
       str = string.formatNumberThousands( string.format("%."..point .."f",scoreInt),true,symbol or "/") 
       else
       str = string.formatNumberThousands( score,true,symbol or "/")
		scoreInt = score
    end
	if fushu then
		return  "-"..str,"取出："
	else
		return  "+"..str,"存入："
	end
    
end

--枚举声明
function ExternalFun.declarEnum( ENSTART, ... )
	local enStart = 1;
	if nil ~= ENSTART then
		enStart = ENSTART;
	end

	local args = {...};
	local enum = {};
	for i=1,#args do
		enum[args[i]] = enStart;
		enStart = enStart + 1;
	end

	return enum;
end

function ExternalFun.declarEnumWithTable( ENSTART, keyTable )
	local enStart = 1;
	if nil ~= ENSTART then
		enStart = ENSTART;
	end

	local args = keyTable;
	local enum = {};
	for i=1,#args do
		enum[args[i]] = enStart;
		enStart = enStart + 1;
	end

	return enum;
end

function ExternalFun.SAFE_RELEASE( var )
	if nil ~= var then
		var:release();
	end
end

function ExternalFun.SAFE_RETAIN( var )
	if nil ~= var then
		var:retain();
	end
end

function ExternalFun.enableBtn( btn, bEnable, bHide )
	if nil == bEnable then
		bEnable = false;
	end
	if nil == bHide then
		bHide = false;
	end

	btn:setTouchEnabled(bEnable);
	if bEnable then
		btn:setVisible(true);
		btn:setOpacity(255);
	else
		if bHide then
			btn:setVisible(false);
		else
			btn:setOpacity(125);
		end
	end
end

--格式化长整形
function ExternalFun.formatScore( llScore )
	local str = string.formatNumberThousands(llScore);
	if string.len(str) >= 4 then
		str = string.sub(str, 1, -4);
		str = (string.gsub(str, ",", ""))
		return str;
	else
		return ""
	end	
end

--无小数点 NumberThousands
function ExternalFun.numberThousands( llScore )
	-- if true then
	-- 	print("numberThousands>>>>>",llScore)
	-- 	return ExternalFun.ChangeScore(llScore,2,"") 
	-- end
	local str = string.formatNumberThousands(llScore);
	if string.len(str) >= 4 then
		return string.sub(str, 1, -4)
	else
		return ""
	end	
end

local debug_mode = nil

--导入包
function ExternalFun.req_var( module_name )
	if (nil ~= module_name) and ("string" == type(module_name)) then
		return require(module_name);
	end
end

--加载界面根节点，设置缩放达到适配
function ExternalFun.loadRootCSB( csbFile, parent,Zorder )
	local rootlayer = ccui.Layout:create()
		:setContentSize(1280,720) --这个是资源设计尺寸
		:setScaleX(display.width / 1280)
		:setScaleY(display.height / 720)
	if nil ~= parent then
		if Zorder then
			parent:addChild(rootlayer,Zorder);
		else
			parent:addChild(rootlayer);
		end
	end
	local csbnode = cc.CSLoader:createNode(csbFile);
	rootlayer:addChild(csbnode);

	return rootlayer, csbnode;
end
function ExternalFun.loadzRootCSB( csbFile, parent,Zorder )
	local rootlayer = ccui.Layout:create()
	if nil ~= parent then
		if Zorder then
			parent:addChild(rootlayer,Zorder);
		else
			parent:addChild(rootlayer);
		end
	end
	local csbnode = cc.CSLoader:createNode(csbFile);
	rootlayer:addChild(csbnode);

	return rootlayer, csbnode;
end
function ExternalFun.loadziRootCSB( csbFile, parent,Zorder )
	local rootlayer = ccui.Layout:create()
   
	if nil ~= parent then
		if Zorder then
			parent:addChild(rootlayer,Zorder);
		else
			parent:addChild(rootlayer);
		end
	end
	local csbnode = cc.CSLoader:createNode(csbFile);
	rootlayer:addChild(csbnode);
    
     if csbnode:getChildByName("bj") then
        csbnode:getChildByName("bj"):setScale(display.height / 720)
     end
     

	return rootlayer, csbnode;
end
--加载csb资源
function ExternalFun.loadCSB( csbFile, parent )
	local csbnode = cc.CSLoader:createNode(csbFile);
	if nil ~= parent and csbnode then
		parent:addChild(csbnode);
	end
	return csbnode;	
end

--加载 帧动画
function ExternalFun.loadTimeLine( csbFile )
	return cc.CSLoader:createTimeline(csbFile);	 
end

--注册node事件
function ExternalFun.registerNodeEvent(node)
	if nil == node then
		return
	end
	local function onNodeEvent( event )
		if event == "enter" and nil ~= node.onEnter then
			node:onEnter()
		elseif event == "enterTransitionFinish" 
			and nil ~= node.onEnterTransitionFinish then
			node:onEnterTransitionFinish()
		elseif event == "exitTransitionStart" 
			and nil ~= node.onExitTransitionStart then
			node:onExitTransitionStart()
        elseif event == "exit" and nil ~= node.onExit then
			node:onExit()
		elseif event == "cleanup" and nil ~= node.onCleanup then
			node:onCleanup()
		end
	end 
    node:registerScriptHandler(onNodeEvent)
end

--注册touch事件
function ExternalFun.registerTouchEvent( node, bSwallow )
	if nil == node then
		return false
	end
	local function onNodeEvent( event )
		if event == "enter" and nil ~= node.onEnter then
			node:onEnter()
		elseif event == "enterTransitionFinish" then
			--注册触摸
			local function onTouchBegan( touch, event )
				if nil == node.onTouchBegan then
					return false
				end
				return node:onTouchBegan(touch, event)
			end

			local function onTouchMoved(touch, event)
				if nil ~= node.onTouchMoved then
					node:onTouchMoved(touch, event)
				end
			end

			local function onTouchEnded( touch, event )
				if nil ~= node.onTouchEnded then
					node:onTouchEnded(touch, event)
				end       
			end

			local listener = cc.EventListenerTouchOneByOne:create()
			bSwallow = bSwallow or false
			listener:setSwallowTouches(bSwallow)
			node._listener = listener
		    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
		    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
		    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
		    local eventDispatcher = node:getEventDispatcher()
		    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)

			if nil ~= node.onEnterTransitionFinish then
				node:onEnterTransitionFinish()
			end
		elseif event == "exitTransitionStart" 
			and nil ~= node.onExitTransitionStart then
			node:onExitTransitionStart()
		elseif event == "exit" and nil ~= node.onExit then	
			if nil ~= node._listener then
				local eventDispatcher = node:getEventDispatcher()
				eventDispatcher:removeEventListener(node._listener)
			end			

			if nil ~= node.onExit then
				node:onExit()
			end
		elseif event == "cleanup" and nil ~= node.onCleanup then
			node:onCleanup()
		end
	end
	node:registerScriptHandler(onNodeEvent)
	return true
end

local filterLexicon = {}

--判断是否包含过滤词
function ExternalFun.isContainBadWords( str )
	local startTime = os.clock()

	print("origin ==> " .. str)
	--特殊字符过滤
	str = string.gsub(str, "[%w '|/?·`,;.~!@#$%^&*()-_。，、+]", "")
	print("gsub ==> " .. str)
	--是否直接为敏感字符
	local res = filterLexicon[str]
	--是否包含
	for k,v in pairs(filterLexicon)	do
		local b,e = string.find(str, k)
		if nil ~= b or nil ~= e then
			res = true
			break
		end
	end

	local endTime = os.clock()
	print("excute time ==> " .. endTime - startTime)

	return res ~= nil
end

--utf8字符串分割为单个字符
function ExternalFun.utf8StringSplit( str )
	local strTable = {}
	for uchar in string.gfind(str, "[%z\1-\127\194-\244][\128-\191]*") do
		strTable[#strTable+1] = uchar
	end
	return strTable
end

function ExternalFun.replaceAll(src, regex, replacement)
	return string.gsub(src, regex, replacement)
end

function ExternalFun.cleanZero(s)
	-- 如果传入的是空串则继续返回空串
    if"" == s then    
        return ""
    end

    -- 字符串中存在多个'零'在一起的时候只读出一个'零'，并省略多余的单位
    
    local regex1 = {"零仟", "零佰", "零拾"}
    local regex2 = {"零亿", "零万", "零元"}
    local regex3 = {"亿", "万", "元"}
    local regex4 = {"零角", "零分"}
    
    -- 第一轮转换把 "零仟", 零佰","零拾"等字符串替换成一个"零"
    for i = 1, 3 do    
        s = ExternalFun.replaceAll(s, regex1[i], "零")
    end

    -- 第二轮转换考虑 "零亿","零万","零元"等情况
    -- "亿","万","元"这些单位有些情况是不能省的，需要保留下来
    for i = 1, 3 do
        -- 当第一轮转换过后有可能有很多个零叠在一起
        -- 要把很多个重复的零变成一个零
        s = ExternalFun.replaceAll(s, "零零零", "零")
        s = ExternalFun.replaceAll(s, "零零", "零")
        s = ExternalFun.replaceAll(s, regex2[i], regex3[i])
    end

    -- 第三轮转换把"零角","零分"字符串省略
    for i = 1, 2 do
        s = ExternalFun.replaceAll(s, regex4[i], "")
    end

    -- 当"万"到"亿"之间全部是"零"的时候，忽略"亿万"单位，只保留一个"亿"
    s = ExternalFun.replaceAll(s, "亿万", "亿")
    
    --去掉单位
    s = ExternalFun.replaceAll(s, "元", "")
    return s
end
--数字缩写
function ExternalFun.numberTrans(str)
	local n1,n2 = math.modf(tonumber(str))
	-- local numStr
	-- if num >= 100000000 then
	-- 	numStr = (math.floor(num*10/100000000)/10).."亿"
	-- elseif num>= 10000000 then
	-- 	numStr = (math.floor(num*10/10000000)/10).."千万"
	-- elseif num>= 10000 then
	-- 	numStr = (math.floor(num*10/10000)/10).."万"
	-- else
	-- 	numStr = num
	-- end
    return n1
end
--人民币阿拉伯数字转大写
function ExternalFun.numberTransiform(strCount)
	local big_num = {"零","壹","贰","叁","肆","伍","陆","柒","捌","玖"}
	local big_mt = {__index = function() return "" end }
	setmetatable(big_num,big_mt)
	local unit = {"元", "拾", "佰", "仟", "万",
                  --拾万位到千万位
                  "拾", "佰", "仟",
                  --亿万位到万亿位
                  "亿", "拾", "佰", "仟", "万",}
    local unit_mt = {__index = function() return "" end }
    setmetatable(unit,unit_mt)
    local tmp_str = ""
    local len = string.len(strCount)
    for i = 1, len do
    	tmp_str = tmp_str .. big_num[string.byte(strCount, i) - 47] .. unit[len - i + 1]
    end
    return ExternalFun.cleanZero(tmp_str)
end

--播放音效 (根据性别不同播放不同的音效)
function ExternalFun.playSoundEffect( path,ispubilc,sexCode,soundtype )
    
    --音频格式
	soundtype = soundtype  and "."..soundtype or ".mp3"

	local sound_path = path
    --男女
	if sexCode ==nil or sexCode=="0" then
		sexCode="man"
    else
        sexCode="woman"
	end
    local game=nil
    if public.entergame==public.game.dezhou then
        game="dz"
    elseif public.entergame==public.game.cow then
        game="cow"
    elseif public.entergame==public.game.dcow then
        game="cow"
    elseif public.entergame==public.game.sangong then
        game="sg"
    elseif public.entergame==public.game.sangongbi then
        game="sgbjh"
    end
        
    --是否是公用资源
    if ispubilc then
        sound_path = string.format("music/game/%s%s",path,soundtype)
        --print("sound_path"..sound_path)
    else
        sound_path = string.format("music/game/%s/%s/%s%s",game,sexCode,path,soundtype)
        if public.entergame==public.game.sangong then
             sound_path = string.format("music/game/%s/%s%s",game,path,soundtype)
        end
    end
	
    if public.bSoundAble then
		return AudioEngine.playEffect(sound_path,false)
	end	
end

--播放音效 (根据性别不同播放不同的音效)
function ExternalFun.playBuyuSoundEffect( path, useritem,soundtype )
	if GlobalUserItem.inloadingBuyuSound then
		return
	end
	soundtype = soundtype  and "."..soundtype or ".mp3"

	local sound_path = path
	if nil == useritem then
		sound_path = "sound_res/" .. path..soundtype
	else
		-- 0:女/1:男
		local gender  = useritem.wFaceID > 4 and 1 or 0
		
		sound_path = string.format("sound_res/%d/%s%s", gender,path,soundtype)
	end
	if GlobalUserItem.bSoundAble then
		return AudioEngine.playEffect(sound_path,false)
	end	
end

function ExternalFun.playClickEffect()
	if public.bSoundAble then
		return AudioEngine.playEffect(cc.FileUtils:getInstance():fullPathForFilename("music/audio_button_click.mp3"),false)
	end
end
--循环播放音响
function ExternalFun.playSoundEffectLoop( path, useritem,soundtype )
	soundtype = soundtype  and "."..soundtype or ".mp3"

	local sound_path = path
	if nil == useritem then
		sound_path = "sound_res/" .. path..soundtype
	else
		-- 0:女/1:男
		local gender  = useritem.wFaceID > 4 and 1 or 0
		
		sound_path = string.format("sound_res/%d/%s%s", gender,path,soundtype)
	end
	if GlobalUserItem.bSoundAble then
		return AudioEngine.playEffect(sound_path,true)
	end	
end
function ExternalFun.stopEffect(soundid )

	if targetPlatform == cc.PLATFORM_OS_IPHONE or targetPlatform == cc.PLATFORM_OS_IPAD then
        ccexp.AudioEngine:stop(soundid)
    else
        AudioEngine.stopEffect(soundid)
	end
	
end

function ExternalFun.destoryInstance( )
	AudioEngine.destroyInstance()
	-- AudioEngine.destoryInstance()
end
--播放背景音乐
function ExternalFun.playBackgroudAudio( bgfile )
	AudioEngine.setMusicVolume(10)
	local strfile = bgfile
	if nil == bgfile then
		strfile = "backgroud01.wav"
	end
	strfile = "sound_res/" .. strfile
	local path = cc.FileUtils:getInstance():fullPathForFilename(strfile)
	if GlobalUserItem.bVoiceAble then
		public.playMusic(path,true)
	end	
end

function ExternalFun.preloadMusic( bgfile )
	local strfile = bgfile
	if nil == bgfile then
		strfile = "backgroud01.wav"
	end
	strfile = "sound_res/" .. strfile
	public.preloadMusic(strfile,true)
end

function ExternalFun.preloadEffect( bgfile )
	local strfile = bgfile
	if nil == bgfile then
		return
	end
	strfile = "sound_res/" .. strfile
	AudioEngine.preloadEffect(strfile,true)
end

function ExternalFun.pauseMusic()
	if public.bVoiceAble then
		AudioEngine.pauseMusic(strfile,true)
	end	
end

function ExternalFun.resumeMusic()
	if public.bVoiceAble then
		AudioEngine.pauseMusic(strfile,true)
	end	
end

--播放大厅背景音乐
function ExternalFun.playPlazzBackgroudAudio( )
	if public.bVoiceAble then
		local str=string.format("music/lobbyMusic/%d.mp3",public.HallMusic)
		AudioEngine.playMusic(cc.FileUtils:getInstance():fullPathForFilename(str),true)
	end
end
function ExternalFun.setPlazzBackgroudMusic(index)
	public.setHallmusic(index)
	ExternalFun.playPlazzBackgroudAudio( )
end
function ExternalFun.stopBackgroudMusic( )
	AudioEngine.stopMusic()
end
function ExternalFun.setgameBackgroudMusic(index)
	public.setGamemusic(index)
	ExternalFun.playgameBackgroudAudio( )
end
--播放大厅背景音乐
function ExternalFun.playgameBackgroudAudio( )
	if public.bVoiceAble then
		local str=string.format("music/roomMusic/%d.mp3",public.GameMusic)
		AudioEngine.playMusic(cc.FileUtils:getInstance():fullPathForFilename(str),true)
	end
end

-- 获取最长文字
function ExternalFun.getMaxStringLen(szText,maxlen)
	local len = 0
	local i = 1
	maxlen = maxlen or 0
	local maxstrlen
	while true do
		local cur = string.sub(szText,i,i)
		local byte = string.byte(cur)
		if byte == nil then
			break
		end
		if byte > 128 then
			if len+2 > maxlen and not maxstrlen then
				maxstrlen = i
			end
			i = i + 3
			local returnstr = string.sub( szText, 1, i-1 )
			len = len + 2
			a=1
		else
			if len+1 > maxlen and not maxstrlen then
				maxstrlen = i
			end

			i = i + 1
			len = len + 1
		end
	end
	local returnstr = string.sub( szText, 1, maxstrlen and maxstrlen-1 or #szText )
	return returnstr,maxstrlen
end

--中文长度计算(同步pc,中文长度为2)
function ExternalFun.stringLen(szText)
	local len = 0
	local i = 1
	while true do
		local cur = string.sub(szText,i,i)
		local byte = string.byte(cur)
		if byte == nil then
			break
		end
		if byte > 128 then
			i = i + 3
			len = len + 2
		else
            i = i + 1
			len = len + 1
		end
	end
	return len
end

-- 过滤emoji表情
-- 编码为 226 的emoji字符,不确定是否是某个中文字符
-- [%z\48-\57\64-\126\226-\233][\128-\191] 正则匹配式去除了226
function ExternalFun.filterEmoji(str)
	local newstr = ""
	print(string.byte(str))
	for unchar in string.gfind(str, "[%z\25-\57\64-\126\227-\240][\128-\191]*") do
		newstr = newstr .. unchar
	end
	print(newstr)
	return newstr
end

-- 判断是否包含emoji
-- 编码为 226 的emoji字符,不确定是否是某个中文字符
function ExternalFun.isContainEmoji(str)
	if nil ~= containEmoji then
		return containEmoji(str)
	end
	local origincount = string.utf8len(str)
	print("origin " .. origincount)
	local count = 0
	for unchar in string.gfind(str, "[%z\25-\57\64-\126\227-\240][\128-\191]*") do
		--[[print(string.len(unchar))
		print(string.byte(unchar))]]
		if string.len(unchar) < 4 then
			count = count + 1
		end		
	end
	print("newcount " .. count)
	return count ~= origincount
end

local TouchFilter = class("TouchFilter", function(showTime, autohide, msg)
		return display.newLayer(cc.c4b(0, 0, 0, 0))
	end)
function TouchFilter:ctor(showTime, autohide, msg)
	ExternalFun.registerTouchEvent(self, true)
	showTime = showTime or 2
	self.m_msgTime = showTime
	if autohide then
		self:runAction(cc.Sequence:create(cc.DelayTime:create(showTime), cc.RemoveSelf:create(true)))
	end	
	self.m_filterMsg = msg
end

function TouchFilter:onTouchBegan(touch, event)
	return self:isVisible()
end

function TouchFilter:onTouchEnded(touch, event)
	print("TouchFilter:onTouchEnded")
	if type(self.m_filterMsg) == "string" and "" ~= self.m_filterMsg then
		showToast(self, self.m_filterMsg, self.m_msgTime)
	end
end

local TOUCH_FILTER_NAME = "__touch_filter_node_name__"
--触摸过滤
function ExternalFun.popupTouchFilter( showTime, autohide, msg, parent )
	local filter = TouchFilter:create(showTime, autohide, msg)
	local runScene = parent or cc.Director:getInstance():getRunningScene()
	if nil ~= runScene then
		local lastfilter = runScene:getChildByName(TOUCH_FILTER_NAME)
		if nil ~= lastfilter then
			lastfilter:stopAllActions()
			lastfilter:removeFromParent()
		end
		if nil ~= filter then
			filter:setName(TOUCH_FILTER_NAME)
			runScene:addChild(filter)
		end
	end
end

function ExternalFun.dismissTouchFilter()
	local runScene = cc.Director:getInstance():getRunningScene()
	if nil ~= runScene then
		local filter = runScene:getChildByName(TOUCH_FILTER_NAME)
		if nil ~= filter then
			filter:stopAllActions()
			filter:removeFromParent()
		end
	end
end

-- eg: 10000 转 1.0万
function ExternalFun.formatScoreText(score)
	local scorestr = ExternalFun.formatScore(score)
	if score < 10000 then
		return scorestr
	end

	if score < 100000000 then
		scorestr = string.format("%.2f万", score / 10000)
		return scorestr
	end
	scorestr = string.format("%.2f亿", score / 100000000)
	return scorestr
end


--倒序排列
function ExternalFun.reverseTable(tab)
	local tmp = {}
	for i = 1, #tab do
		local key = #tab
		tmp[i] = table.remove(tab)
	end

	return tmp
end
 --进制转换，英文不行只好用拼音
 --@dec 10进制数据，好吧，只要是数字就呆以了
 --@bitNum_  返回的数据长度  需要解析的二进制前几位
 function ExternalFun.Dec2X( dec ,bitNum_ )

	-- bit.band(1,v),bit.band(2,v),bit.band(4,v),bit.band(8,v),bit.band(16,v)
	--计算结果存储在这里
	local bitNum = bitNum_ or 4
    local new_number = {}
	for i=1,bitNum do
		local value = bit.band(math.pow(2,(i-1)),dec)  
		value  = value > 0 and 1 or 0
		table.insert( new_number,1,value)
	end
	return new_number

end

 --进制转换，英文不行只好用拼音
 --@dec 10进制数据，好吧，只要是数字就呆以了
 --@bitNum_  返回的数据长度  需要解析的二进制前几位
 function ExternalFun.Dec2X_Rev( dec ,bitNum_ )

	-- bit.band(1,v),bit.band(2,v),bit.band(4,v),bit.band(8,v),bit.band(16,v)
	--计算结果存储在这里
	local bitNum = bitNum_ or 4
    local new_number = {}
	for i=1,bitNum do
		local value = bit.band(math.pow(2,(i-1)),dec)  
		value  = value > 0 and 1 or 0
		table.insert( new_number,value)
	end
	return new_number

end

--将某个数据转成X进制
--以 9527，10进制为例，{7, 2, 5, 9}
function ExternalFun.numberTable2X(  number_tbl,x )
    local result = 0
    for i,v in ipairs(number_tbl) do
        print(result,x, i, v)
        result = result + v*math.pow(x, i - 1)
    end
    return result
end

-- 获取余数
function math.mod(a, b)
    return a - math.floor(a/b)*b
end

local grayCache = setmetatable({},{_mode="k"});  
function ExternalFun.addGray(target)  
    if(not target or target.getChildren == nil) then return end  
    local len,children = target:getChildrenCount(),target:getChildren();  
    if len == 0 or tolua.type(target) =="CCScale9Sprite" then  
        if(tolua.type(target) =="CCScale9Sprite") then  
            target = tolua.cast(target:getChildren():objectAtIndex(0),"CCSpriteBatchNode");  
        end  
        local type = tolua.type(target);  
        if((type == "CCSprite" or type == "CCSpriteBatchNode")  and not grayCache[target]) then  
            CCColorUtil:addGray(target)  
            grayCache[target] = true;  
        end  
    else  
        for i = 0, children:count() - 1 do  
            ExternalFun.addGray(children:objectAtIndex(i))  
        end  
    end  
end  
  
function ExternalFun.removeGray(target)  
    if(not target or target.getChildren == nil) then return end  
      
    local len,children = target:getChildrenCount(),target:getChildren();  
    if len == 0 or tolua.type(target) =="CCScale9Sprite" then  
        if(tolua.type(target) =="CCScale9Sprite" and grayCache[target]) then  
            target = tolua.cast(target:getChildren():objectAtIndex(0),"CCSpriteBatchNode");  
        end  
        local type = tolua.type(target)  
        if((type == "CCSprite" or type == "CCSpriteBatchNode")and grayCache[target]) then  
            CCColorUtil:removeGray(target)  
            grayCache[target] = nil;  
        end  
    else  
        for i = 0, children:count() - 1 do  
            ExternalFun.removeGray(children:objectAtIndex(i))  
        end  
    end  
end  

function ExternalFun.filter_spec_chars(s,maxlen)
	s = string.gsub (s, "\r", "")
	s = string.gsub (s, "\n", "")
	local ss = {}
	local bhaveOtherchar =  false
	maxlen = maxlen or #s
	for k = 1, #s do
		local c = string.byte(s,k)
		print("filter_spec_chars>>>>",c)
		if k > maxlen then break end
		if not c then break end
		if (c>=48 and c<=57) or (c>= 65 and c<=90) or (c>=97 and c<=122) then
			table.insert(ss, string.char(c))
		elseif c>=228 and c<=233 then
			local c1 = string.byte(s,k+1)
			local c2 = string.byte(s,k+2)
			if c1 and c2 then
					k = k + 2
					table.insert(ss, string.char(c,c1,c2))
				-- end
			end 
		elseif c > 233 or c == 227 then
			local  regEx="！@％#￥&*（）——+|{}【】‘；：”“’。，、？～。１２３４５６７８９０"
			local c1 = string.byte(s,k+1)
			local c2 = string.byte(s,k+2)
			local str = string.char(c,c1,c2)
			if string.find( regEx, str ) then
				k = k + 2
				table.insert(ss, str)
			else
				bhaveOtherchar =  true			
			end
		else
			local s1 = string.sub( s,k,1)
			table.insert(ss, s1)
			
		end
	end
	return table.concat(ss),bhaveOtherchar
end


function ExternalFun.checkWordCount(s)
	local ss = {}
	local bhaveOtherchar =  false
	local hanzi = {}
	local shuzilab = {}
	for k = 1, #s do
		local c = string.byte(s,k)
		if not c then break end
		if (c>=48 and c<=57) or (c>= 65 and c<=90) or (c>=97 and c<=122) then
			table.insert(shuzilab, string.char(c))
		elseif c>=228 and c<=233 then
			local c1 = string.byte(s,k+1)
			local c2 = string.byte(s,k+2)
			if c1 and c2 then
				local a1,a2,a3,a4 = 128,191,128,191
				if c == 228 then a1 = 184
				elseif c == 233 then a2,a4 = 190,165
				end
				if c1>=a1 and c1<=a2 and c2>=a3 and c2<=a4 then
					k = k + 2
					table.insert(hanzi, string.char(c,c1,c2))
				end
			end
		end
	end
	local totallen = #hanzi+#shuzilab
	return totallen,#hanzi,#shuzilab
end
--根据 sprite存到本地
function  ExternalFun.saveSpToLocal(imgpath)
	local spName = os.time()..".png"
	local savesp = display.newSprite(imgpath)
	savesp:setAnchorPoint(0,0)
	local writablePath = cc.FileUtils:getInstance():getWritablePath()
	local spsize = savesp:getContentSize()
	local _render = cc.RenderTexture:create(spsize.width,spsize.height)
	_render:begin()
	savesp:visit()
	_render:endToLua()
	_render:saveToFile(spName,cc.IMAGE_FORMAT_PNG) 
	return writablePath..spName
end

--同步版本
function ExternalFun.httpNewVersion(_scene,callback)	
	if not tolua.isnull(_scene.updateApkTip) then
		if callback then
			callback()
		end
		return
	end
	local this = _scene
	--数据解析
	local vcallback = function(datatable)
		--dump(datatable,"datatable")
		if not datatable then
			if callback then
				callback()
			end
			return
		end
	 	local succeed = false
	 	local msg = "网络配置获取失败！"
	 	if type(datatable) == "table" then	 		
			succeed =  datatable["data"] and datatable.code
	 	end
		if succeed  then
			local databuffer = datatable["data"]
			if databuffer then
				appdf.bili = databuffer.bili or 1000   --金币比例
				appdf.Ratio =  databuffer.Ratio   --是否切换比例
				--dump(databuffer,"读取网络配置")
				_scene:getApp()._serverConfig = databuffer	 	
				URL_REQUEST_LIST = databuffer.confighostList or URL_REQUEST_LIST
				if callback then
					callback(databuffer)
				end
				print("ExternalFun.httpNewVersion>>>>>>", GlobalUserItem.curClientVer , databuffer.version)
				-- 优先整包更新
				local cur_package_ver =  cc.UserDefault:getInstance():getStringForKey("package_ver") or ""
				if  not GlobalUserItem.indownapk and databuffer.apkversion and cur_package_ver ~= databuffer.apkversion then
					local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
					local storagePath = MultiPlatform:getExternalStorageDirectory("weixiao")
					if  databuffer.autoInstall then  -- 安卓后台下载后自动提示安装
						MultiPlatform:downloadAPK(databuffer.apkurl,databuffer.apkname,storagePath,"/weixiao/")
					else
						local curScene = _scene._sceneRecord[#_scene._sceneRecord]
						if curScene then
							if curScene ~= yl.SCENE_GAME then
								local QueryExit = appdf.req(appdf.CLIENT_SRC.."app.views.layer.other.QueryDialog")
								if  ExternalFun.checkFileIsExit(storagePath..databuffer.apkname) then
									_scene.updateApkTip = QueryExit:create("新游戏版本已经下载完成\n点确定安装最新的安装包", function (bReTry)
										MultiPlatform:installClient(storagePath..databuffer.apkname)
									end)
									:setCanTouchOutside(not databuffer.forceUpdateClient)
									:addTo(_scene,yl.MAX_INT)
								else
									_scene.updateApkTip = QueryExit:create("游戏版本已经更新\n点确定下载安装包", function (bReTry)
											if not bReTry then
												return
											end
											local callback =  function( code )  -- 下载完成后
												if code == appdf.DOWN_COMPELETED then
													GlobalUserItem.indownapk =  false
													_scene.updateApkTip = QueryExit:create("新游戏版本已经下载完成\n点确定安装最新的安装包", function (bReTry)
														MultiPlatform:installClient(storagePath..databuffer.apkname)
													end)
													:setCanTouchOutside(true)
													:addTo(_scene,yl.MAX_INT)
												end
											end
											GlobalUserItem.indownapk =  true
											downZipApkAsync(databuffer.apkurl,databuffer.apkname,storagePath,
											databuffer.apkzipmd5,callback,parent)
										end)
										:setCanTouchOutside(not databuffer.forceUpdateClient)
										:addTo(_scene,yl.MAX_INT)
								end
							end 
						end
					end
				elseif GlobalUserItem.curClientVer ~= databuffer.version then  -- 热更新
					GlobalUserItem.curClientVer = databuffer.version
					local curScene = _scene._sceneRecord[#_scene._sceneRecord]
					if curScene then
						if curScene ~= yl.SCENE_GAME then
							local QueryExit = appdf.req(appdf.CLIENT_SRC.."app.views.layer.other.QueryDialog")
							_scene.updateApkTip = QueryExit:create("大厅版本已经更新\n请退出游戏重新启动游戏进行更新", function (bReTry)
									if databuffer.forceUpdateClient then
										require("app.MyApp"):create():run()
									end
								end)
								:setCanTouchOutside(not databuffer.forceUpdateClient)
								:addTo(_scene,yl.MAX_INT)
						end 
					end
				

				end	
			else
				if callback then
					callback()
				end				
			end
			cc.FileUtils:getInstance():writeStringToFile(cjson.encode(datatable),device.writablePath .."config.txt");
		else
			if callback then
				callback()
			end
	 	end	 	
	end

	local mark = cc.UserDefault:getInstance():getStringForKey("mark")
	local utils = appdf.req(appdf.EXTERNAL_SRC .. "Utils")
	local paramssign = utils.genSig({mark=mark})
	print("URL_REQUEST params>>>",sign,params)

	URL_REQUEST = URL_REQUEST_LIST[math.random( 1,#URL_REQUEST_LIST)] or URL_REQUEST
	if URL_REQUEST then
		appdf.onHttpJsionTable(URL_REQUEST.."?"..os.time(),"POST",paramssign,vcallback)
	end

end


function ExternalFun.closeWaitingTip(...)
	if not tolua.isnull(ExternalFun.wait_nex_game) then
		ExternalFun.wait_nex_game:removeSelf()
		ExternalFun.wait_layer:removeSelf()
	end
	ExternalFun.wait_nex_game = nil
end

function ExternalFun.showWaitingTip(parent,idx)

	if  tolua.isnull(ExternalFun.wait_nex_game) then
		local runScene = cc.Director:getInstance():getRunningScene()
		local tiplayer = require("client.src.plaza.views.layer.plaza.TipLayer")
		ExternalFun.wait_layer = tiplayer:create()
		:addTo(parent or runScene, idx or 1000)
		ExternalFun.wait_layer:initWaitTip()
		ExternalFun.wait_nex_game = ExternalFun.wait_layer.wait_nex_game
	end
	ExternalFun.wait_nex_game:setVisible(true)
	ExternalFun.waitNextGame()
end

function ExternalFun:waitNextGame( idx )
	idx = idx or 1
	if ExternalFun.wait_nex_game and ExternalFun.wait_nex_game:isVisible() then
		ExternalFun.wait_nex_game:setTextureRect(cc.rect(0,0,705-60+(idx-1)*20,78))
		performWithDelay(ExternalFun.wait_nex_game,function( ... )
			idx = idx + 1
			if idx > 4 then
				idx = 1
			end
			ExternalFun:waitNextGame(idx)
		end,1)
	end
end

--获取移动动画
--inorout,0表示加速飞出,1表示加速飞入
--isreverse,0表示不反转,1表示反转
function ExternalFun.getMoveBezierAction(beginpos, endpos, offset,time)
	local offsety =(endpos.y - beginpos.y) * 1
	offsety = offset or 80
	local deltaX = (endpos.x - beginpos.x)/3

	local controlpos1 = cc.p(beginpos.x+deltaX,beginpos.y+offsety/2)
	local controlpos2 = cc.p(beginpos.x+deltaX*2,beginpos.y+offsety)

	local bezier = {
		controlpos1,
		controlpos2,
		endpos
	}
	local beaction = cc.MoveTo:create(time or 1.5, endpos)
	return beaction
end
function ExternalFun.getMoveBezierActionback(beginpos, endpos, offset,time)
	local offsety =(endpos.y - beginpos.y) * 1
	offsety = offset or 80
	local deltaX = (endpos.x - beginpos.x)/3

	local controlpos1 = cc.p(beginpos.x+deltaX,beginpos.y+offsety/2)
	local controlpos2 = cc.p(beginpos.x+deltaX*2,beginpos.y+offsety)

	local bezier = {
		controlpos1,
		controlpos2,
		endpos
	}
	local beaction = cc.BezierTo:create(time or 1.5, bezier)
	return beaction
end
local director = cc.Director:getInstance()
local textureCache = director:getTextureCache()
local spriteFrameCache = cc.SpriteFrameCache:getInstance()

function display.addImageFramesAsync(dataFilename, imageFilename, callback)
	local cb =  function( texture )
		if tolua.isnull(texture) then
            return
        end
        if imageFilename and display.TEXTURES_PIXEL_FORMAT[imageFilename] then
            cc.Texture2D:setDefaultAlphaPixelFormat(display.TEXTURES_PIXEL_FORMAT[imageFilename])
        end
        spriteFrameCache:addSpriteFrames(dataFilename, texture)
        if imageFilename and display.TEXTURES_PIXEL_FORMAT[imageFilename] then
            cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_BGR_A8888)
        end
        if callback then
            callback()
        end
    end
    textureCache:addImageAsync(imageFilename, cb)
end


function display.loadSpriteFrames(dataFilename, imageFilename, callback)
    if not callback then
        if display.TEXTURES_PIXEL_FORMAT[imageFilename] then
            cc.Texture2D:setDefaultAlphaPixelFormat(display.TEXTURES_PIXEL_FORMAT[imageFilename])
        end
        spriteFrameCache:addSpriteFrames(dataFilename, imageFilename)
        if display.TEXTURES_PIXEL_FORMAT[imageFilename] then
            cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_BGR_A8888)
        end
    else
        display.addImageFramesAsync(dataFilename, imageFilename, callback)
        -- spriteFrameCache:addSpriteFramesAsync(dataFilename, imageFilename, callback)
    end
end


function ExternalFun.addSitdownAnimal(targetsp,viewid,myviewid,bLeave,callback,begpos)
	targetsp:stopAllActions()
	local offsetX = viewid > myviewid and 400 or -400
	local begpos = clone(targetsp.begpos)
	-- print("addSitdownAnimal>>>",viewid,begpos.x,offsetX)

	-- targetsp:setPosition(begpos)
	if not bLeave then
		targetsp:setPositionX(begpos.x+offsetX)
	else
		targetsp:setPositionX(begpos.x)
		begpos.x = begpos.x+offsetX
	end
	-- print("addSitdownAnimal>>>",begpos.x,"  /  ",targetsp:getPosition())
	local move = cc.MoveTo:create(0.4, cc.p(begpos.x,begpos.y))
	if callback then
		local call = cc.CallFunc:create(function()
            callback()
        end)
		targetsp:runAction(cc.Sequence:create(move, call))
	else
		targetsp:runAction(move)
	end
end


--==============================--
--desc:登录界面背景骨骼动画  适配
--time:2018-04-09 09:09:08
--@parentnode:
--@orderz:
--@return 
--==============================-- 
function ExternalFun.addLogonLoadingArm( parentnode ,orderz )
	local backnode = display.newNode()
	backnode:setAnchorPoint(cc.p(0.5,0))
	parentnode:addChild(backnode)

		local sp_patch = "Logon/background_1.jpg"

		local ba_sp = display.newSprite(sp_patch)
		ba_sp:setPosition(cc.p(display.width/2,display.height/2))
		local size = ba_sp:getContentSize()
		local framesize = display.sizeInPixels
		if display.width>size.width then
			backnode:setScale(display.width/size.width)
		end
		backnode:addChild(ba_sp)

		-- if not appdf.APPSTORE_VERSION then
		-- 	local armat = ExternalFun.addArmatureWithCustomNode("denglujiemian",backnode,nil,cc.p(display.width/2,display.height/2))
		-- end

		if orderz then
			backnode:setLocalZOrder(orderz)
		end
		local armture = ExternalFun.addArmatureWithCustomNode("denglujiemian",backnode,nil,cc.p(display.width/2,display.height/2))
		ExternalFun.FixScaleUI(armture)
		local officbtn = ccui.Button:create("Logon/guanw.png","Logon/guanw.png")
		officbtn:move(display.width-85,display.height-65)
		officbtn:addTo(backnode)
		officbtn:addTouchEventListener(function(ref,type)
		if type == ccui.TouchEventType.ended then
			ref:setScale(1)
			local url = cc.UserDefault:getInstance():getStringForKey("weburl",office_url)
			cc.Application:getInstance():openURL(url)
		elseif type == ccui.TouchEventType.began then
			ref:setScale(0.97)
			return true
		elseif type == ccui.TouchEventType.canceled then
			ref:setScale(1)
	
		end
		end)
		return backnode
end

function performWithDelay(node, callback, delay)
	if tolua.isnull(node) then
		return
	end
    local fun = function( ... )
        if node and not tolua.isnull(node) and callback then
            callback()
        end
    end
    local delay = cc.DelayTime:create(delay or 1)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(fun))
    node:runAction(sequence)
    return sequence
end
--目标移动到位置
function ExternalFun.nodeMove(node, beginpos,endpos,time)
	if tolua.isnull(node) then
		return
	end
    node:setPosition(beginpos)
    local sequence = cc.MoveTo:create(time or 0.7, endpos)
    node:runAction(sequence)
end
--目标缩放
function ExternalFun.nodeScale(node,time)
	if tolua.isnull(node) then
		return
	end
    node:setScale(0)
    local sequence = cc.ScaleTo:create(time or 0.7, 1,1)
    node:runAction(sequence)
end

function ExternalFun.cleanGameCache(  )
	local fileUtil = cc.FileUtils:getInstance()
	device.writablePath = cc.FileUtils:getInstance():getWritablePath()
	fileUtil:removeFile(device.writablePath.."UserDefault.xml")

	fileUtil:removeDirectory(device.writablePath.."baseupdate/")
	fileUtil:removeDirectory(device.writablePath.."download/")
	fileUtil:removeFile(device.writablePath.."version.plist")
	fileUtil:removeDirectory(device.writablePath.."command/")
	cc.UserDefault:getInstance():deleteValueForKey("extra_command_version")
	cc.UserDefault:getInstance():flush()
end



local pi_mul_180 = 180 / math.pi
function math.radian2angle(radian)
    return radian * pi_mul_180
end

function ExternalFun.subString( str, k )
	if not str  then
		return 
	end
	ts = string.reverse(str)
	_, i = string.find(ts, k)
	if not i then
		return
	end
	m = string.len(ts) - i + 1
	local str1 = string.sub(str, m+1)
	if not str1 then
		return
	end
	return str1
end

function ExternalFun.downloadFace(target, url, savePath, filename, onDownLoadSuccess,onDownFailed)
	if not onDownLoadSuccess  then
		onDownLoadSuccess = function( ... )
			target:loadTexture(savePath..filename)
		end
	end
	if ExternalFun.checkFileIsExit(savePath..filename) then
		onDownLoadSuccess()
		return
	end

	local callback = function( ret )
		if ret == appdf.DOWN_COMPELETED then
			onDownLoadSuccess()
		elseif  ret == appdf.DOWN_ERROR_NET then
			if onDownFailed then
				if not target.retrytime then  --重试一次
					target.retrytime = 1
					ExternalFun.downloadFace(target, url, savePath, filename, onDownLoadSuccess,onDownFailed)
				else
					onDownFailed()
				end
			end
			
		end
	end
	appdf.onHttpDownUrl(url,filename,savePath,callback )
end


function trim(str)
    return (string.gsub(str, "^%s*(.-)%s*$", "%1")) or ""
end

function downZipFileAsync( url,filename,storagePath,zipmd5,callback,parent )
	cc.FileUtils:getInstance():removeFile(storagePath..filename)
	cc.FileUtils:getInstance():removeFile(storagePath .. filename..".tmp")
	local assetsManagerEx = cc.AssetsManagerEx:create("project.manifest", storagePath)
	print("assetsManagerEx>>>>",url,filename,storagePath,callback)
	assetsManagerEx:retain()
	local eventListenerAssetsManagerEx 
	local dispatcher = cc.Director:getInstance():getEventDispatcher()

    -- 设置下载消息listener
	local function handleAssetsManagerEx(event)

		local eventcode  = event:getEventCode()
		print("upDateClient>>>>>>>",eventcode)
        if (cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION ==eventcode) then
			print("更新进度=" .. event:getPercent())
			callback(appdf.DOWN_PRO_INFO,event:getPercent())
			return
        end

        if (cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED == eventcode) then
            print("更新完毕，重新启动>>>")
			dispatcher:removeEventListener(eventListenerAssetsManagerEx)
			if not tolua.isnull(assetsManagerEx) then
				assetsManagerEx:release()
            else
                return
            end
			assetsManagerEx=nil
			local path = cc.FileUtils:getInstance():fullPathForFilename(filename) 
			if not path or path == "" or not ExternalFun.checkFileIsExit(path) then
				path = cc.FileUtils:getInstance():fullPathForFilename("0_"..filename)
				if not path or path == "" or not ExternalFun.checkFileIsExit(path) then
					local btmp =  ExternalFun.checkFileIsExit(filename..".tmp") 
					cc.FileUtils:getInstance():removeFile(storagePath..filename)
					cc.FileUtils:getInstance():removeFile(storagePath .. filename..".tmp")
					callback("找不到更新文件"..filename..tostring(btmp))
				end
			end
            local filemd5 =  MD5File(path) or ""
            
            print("handleAssetsManagerEx>>>>>>>>>>",filename,zipmd5 ," / ", filemd5,path)
            if string.upper(trim(zipmd5)) ~= string.upper(filemd5) then
				callback("md5_error")
				cc.FileUtils:getInstance():removeFile(path)
				cc.FileUtils:getInstance():removeFile(path..".tmp")
                return 
            end
			unZipAsync(path,storagePath,function(result)
				print("onUnZipBase result client >>>>>",result)
				-- parent._txtTips:setString("解压文件，请稍候....")
				if checkint(result) == 1 then
					callback(appdf.DOWN_COMPELETED)
					cc.FileUtils:getInstance():removeFile(path)
					cc.FileUtils:getInstance():removeFile(path..".tmp")
				else
					cc.FileUtils:getInstance():removeFile(path)
					cc.FileUtils:getInstance():removeFile(path..".tmp")
					callback("解压失败")
				end
			end)
            return
        -- elseif (cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING == eventcode) then
        --     return
        end

		print("发生错误:更新失败")
		callback(appdf.DOWN_ERROR_NET,eventcode)
		-- cc.FileUtils:getInstance():removeFile(storagePath..filename)
		cc.FileUtils:getInstance():removeFile(storagePath .. filename..".tmp")
        if not tolua.isnull(assetsManagerEx) then
			assetsManagerEx:release()
			dispatcher:removeEventListener(eventListenerAssetsManagerEx)
			assetsManagerEx=nil
        end
    end
 
    eventListenerAssetsManagerEx = cc.EventListenerAssetsManagerEx:create(assetsManagerEx, handleAssetsManagerEx)
	dispatcher:addEventListenerWithFixedPriority(eventListenerAssetsManagerEx, 1)
	
    -- 检查版本并升级
	assetsManagerEx:toload(url,storagePath..filename)
	-- assetsManagerEx:update()
	return assetsManagerEx,dispatcher
end


function downZipApkAsync( url,filename,storagePath,zipmd5,callback,parent )
	local assetsManagerEx = cc.AssetsManagerEx:create("project.manifest", storagePath)
	print("assetsManagerEx>>>>",url,filename,storagePath,callback)
	assetsManagerEx:retain()
	local eventListenerAssetsManagerEx 
	local dispatcher = cc.Director:getInstance():getEventDispatcher()

    -- 设置下载消息listener
	local function handleAssetsManagerEx(event)

		local eventcode  = event:getEventCode()
		print("upDateClient>>>>>>>",eventcode)
        if (cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION ==eventcode) then
			print("更新进度=" .. event:getPercent())
			callback(appdf.DOWN_PRO_INFO,event:getPercent())
			return
        end

        if (cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED == eventcode) then
            print("更新完毕，重新启动>>>")
			dispatcher:removeEventListener(eventListenerAssetsManagerEx)
			if not tolua.isnull(assetsManagerEx) then
				assetsManagerEx:release()
            else
                return
            end
			assetsManagerEx=nil
            local filemd5 =  MD5File(storagePath..filename) or ""
            
            print("handleAssetsManagerEx>>>>>>>>>>",filename,zipmd5 ," / ", filemd5,path)
            if string.upper(trim(zipmd5)) ~= string.upper(filemd5) then
				callback("md5_error")
				cc.FileUtils:getInstance():removeFile(path)
				cc.FileUtils:getInstance():removeFile(path..".tmp")
                return 
            end
			callback(appdf.DOWN_COMPELETED)
            return
        -- elseif (cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING == eventcode) then
        --     return
        end

		print("发生错误:更新失败")
		callback(appdf.DOWN_ERROR_NET,eventcode)
		-- cc.FileUtils:getInstance():removeFile(storagePath..filename)
		cc.FileUtils:getInstance():removeFile(storagePath .. filename..".tmp")
        if not tolua.isnull(assetsManagerEx) then
			assetsManagerEx:release()
			dispatcher:removeEventListener(eventListenerAssetsManagerEx)
			assetsManagerEx=nil
        end
    end
 
    eventListenerAssetsManagerEx = cc.EventListenerAssetsManagerEx:create(assetsManagerEx, handleAssetsManagerEx)
	dispatcher:addEventListenerWithFixedPriority(eventListenerAssetsManagerEx, 1)
	
    -- 检查版本并升级
	assetsManagerEx:toload(url,storagePath..filename)
	-- assetsManagerEx:update()
	return assetsManagerEx,dispatcher
end

-- 显示 emoji表情
function ExternalFun.showEmoji( ntype,parent,tbPostion)
	ntype = ntype - 200 
	local emojilist = {"daxiao_biaoqingdonghua","hanyan_biaoqingdonghua",
	"fanzao_biaoqingdonghua","dahaqian_biaoqingdonghua",
	"shaogaoxiang_biaoqingdonghua","liukoushui_biaoqingdonghua",
	"yaobaiqi_biaoqingdonghua","damuzhi_biaoqingdonghua","fanu_biaoqingdonghua","jiong_biaoqingdonghua",
	"shihua_biaoqingdonghua","yun_biaoqingdonghua"}

	local pos = cc.p(tbPostion.x,tbPostion.y)
	local armstr = emojilist[ntype]
	print("ExternalFun.showEmoji"..ntype.."armstr===="..armstr)

	
	ExternalFun.addArmatureCache({"Armature/Emoji/"..armstr.."/"..armstr..".ExportJson"}) 
	local arm = ExternalFun.addArmatureWithCustomNode(armstr,parent,nil,pos)
	arm:setLocalZOrder(1000)
	
	--local node = cc.Node:create()
	--cc.Director:getInstance():getRunningScene():addChild(node)
	performWithDelay(arm,function( ... )
		print("ExternalFun.showEmoji performWithDelay run>>>>")
		---node:removeFromParent()
		arm:stopAllActions()
		arm:removeFromParent()
	end,2)
end 

-- 表现互动  动画
function ExternalFun.showBiaoQing( ntype,parent,begpos,endpos)
	local biaoqinglist = {"jianjiaoji_mofabiaoqing","meiguihua_mofabiaoqing","pijiu_mofabiaoqing",
	"tuoxie_mofabiaoqing"}
	if GlobalUserItem.bSoundAble then
		 AudioEngine.playEffect("GameChatSound/ani"..ntype..".mp3",false)
	end
	
	local biaoqing = biaoqinglist[ntype]
	local arm
	local arm2
	local arm3
	local animat
	if ntype == 4 then
		ExternalFun.addArmatureCache({"Armature/biaoqing/"..biaoqing.."/"..biaoqing..".ExportJson"}) 
		arm,animat = ExternalFun.addArmatureWithCustomNode(biaoqing,parent,"Animation2",begpos)
		arm:setLocalZOrder(1000)
	else
		ExternalFun.addArmatureCache({"Armature/biaoqing/"..biaoqing.."/"..biaoqing..".ExportJson"}) 
		arm,animat = ExternalFun.addArmatureWithCustomNode(biaoqing,parent,nil,begpos)
		arm:setLocalZOrder(1000)
	end

	if  animat and endpos  then
		if ntype == 2 or ntype == 3 then
			animat:gotoAndPause(1)
		end
		local move = ExternalFun.getMoveBezierAction(begpos,endpos,40,0.4)
		arm:runAction(cc.Sequence:create(move,cc.CallFunc:create(
		function()
			if ntype == 4 then
				arm2 = ExternalFun.addArmatureWithCustomNode(biaoqing,parent,nil,endpos)
				arm2:setLocalZOrder(999)
				
				--local node = cc.Node:create()
				--cc.Director:getInstance():getRunningScene():addChild(node)
				performWithDelay(arm,function( ... )
					arm:removeFromParent()
					arm = nil
					--node:removeFromParent()
				end,1)
			elseif ntype == 1 then 
				-- arm2 = ExternalFun.addArmatureWithCustomNode(biaoqing,parent,"Animation2",endpos)
				-- arm2:setLocalZOrder(999)
			else
				animat:gotoAndPlay(1)
			end
		end
		),
		cc.DelayTime:create(ntype == 1  and 1 or 2),
		cc.CallFunc:create(
			function()
				if arm then
					arm:removeFromParent()
				end
				if ntype ~= 1 then
					if arm2 then
						arm2:removeFromParent()
						arm2 = nil
					end
				else
					arm2 = ExternalFun.addArmatureWithCustomNode(biaoqing,parent,"Animation2",endpos)
					arm2:setLocalZOrder(999)
					arm3 = ExternalFun.addArmatureWithCustomNode(biaoqing,parent,"Animation3",endpos)
					arm3:setLocalZOrder(998)
					--local node = cc.Node:create()
					--cc.Director:getInstance():getRunningScene():addChild(node)
					performWithDelay(arm2,function( ... )
						arm2:removeFromParent()
						arm3:removeFromParent()
						--node:removeFromParent()
					end,2)
				end
			end
		))
	)	
	end
end 


function ExternalFun.isWebGame( gameid )
	if gameid == 108 then
		return true
	end
end

function ExternalFun.enterGameAction( gameid )
	if not yl.GAME_TYPE_BAIREN[gameid] and gameid ~= yl.buyu then
		return true
	end
	return false
end


function ExternalFun.checkFileIsExit( path )
	if not yl or not yl.isFileExit then
		return cc.FileUtils:getInstance():isFileExist(path)
	end
	if yl.isFileExit[path] == 1 then
		return true
	end
	local isExit = cc.FileUtils:getInstance():isFileExist(path)
	yl.isFileExit[path] = isExit and 1 or 2
	return isExit
end

-- 获取绑定推荐码
function ExternalFun.getBindData(callback)
	local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
	local str = MultiPlatform:getBindData()   -- 从sdk获取
	local clipcall =  function( data )
		--dump(data,"clipcall")
		if not appdf.isNullString(data) then
			callback(data)
		end
	end
	if not appdf.isNullString( str ) then
		local sj = cjson.decode(str)
		if sj.data then
			sj = cjson.decode(cjson.decode(sj.data))
		end
		if sj then
			if sj.data then
				sj = cjson.decode(cjson.decode(sj.data))
			end
			callback(sj,true)
		else
			MultiPlatform:getInstance():getClipboardData(clipcall)
		end
	else
		MultiPlatform:getInstance():getClipboardData(clipcall)
	end
end

function ExternalFun.checkBindCode()  --自动绑定全民代理   登陆界面 和 进入游戏界面  各请求一次
	local code = cc.UserDefault:getInstance():getStringForKey("bindSuccess") or ""
	print("checkBindCode>>>",code)
		if appdf.isNullString(code) then
			ExternalFun.getBindData(function (data,bindsdk)
				local str
				if not bindsdk then
					local pstart,pend = string.find(data,"weitjagent%-")
					if   pend then
						str = string.sub(data,pend+1,string.len(data))
						if not appdf.isNullString( str ) then
							-- 自动绑定
							pstart,pend = string.find(str,"%.")
							if pend then
								str = string.sub(str,1,pend-1)
							end
						end
					end
				else
					str = data.code or "success"
				end
				local function cb( data )
					if data.repeat_request == 0 then
						cc.UserDefault:getInstance():setStringForKey("bindSuccess","true")
					end
				end
				local utils = appdf.req(appdf.EXTERNAL_SRC .. "Utils")
				if type(data) ~= "table" then
					if str and type(str) == "string" then
						utils.bindTuiJiaRen( {invitecode = str or "",machine_code = appdf.MachineCode or "",user_id = GlobalUserItem.dwUserID},cb )
						utils.bindIntrodution( {invitecode = str or "",machine_code = appdf.MachineCode or "",user_id = GlobalUserItem.dwUserID},cb )
					end
					return
				end
				if data.type == 1 then
					utils.bindTuiJiaRen( {invitecode = data.code or "",machine_code = appdf.MachineCode or "",user_id = GlobalUserItem.dwUserID},cb )
				else
					utils.bindIntrodution( {invitecode = data.code or "",machine_code = appdf.MachineCode or "",user_id = GlobalUserItem.dwUserID},cb )
				end
			end)
		end
end

function ExternalFun.getOrderID()
	math.randomseed(os.time())
	local tb = {}
	local seed = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'}
	--填充5位时间戳
	local timestamp = string.format("%X", os.time())
	for i = 1, 5 do
		table.insert(tb, string.sub(timestamp, i, i))
	end

	--填充5位随机码
	for i = 1, 5 do
		table.insert(tb, seed[math.random(1, 10)])
	end
	
	local sid=table.concat(tb)
	return sid
end
function ExternalFun.checkLunPanRedPoint(parent,pos)
	if not parent then
		return
	end
	if GlobalUserItem.turnData and GlobalUserItem.turnData.grade and GlobalUserItem.turnData.grade >= 500 then
		if not parent.tunredpoint then
			parent.tunredpoint = display.newSprite("kefu/redpoint.png")
			-- self.redpoint:setAnchorPoint(1, 0.5)
			parent.tunredpoint:move(pos.x,pos.y)
			parent.tunredpoint:addTo(parent)
		else
			parent.tunredpoint:setVisible(true)
		end
	elseif parent.tunredpoint then
		parent.tunredpoint:setVisible(false)
	end

end
--查找指定名称控件，返回第一个找到的控件
function ExternalFun.seekWigetByName(node,name)
	local child = node:getChildByName(name)
	if nil ~= child then
		return child
	end
	
	local children = node:getChildren()
	for i=1, #children do
		local result = ExternalFun.seekWigetByName(children[i], name)
		if nil ~= result then
			return result
		end
	end
	
	return nil
end
function ExternalFun.fillItem(item,fields,data,call)
	
	if call==nil then
		call={}
	end
	-- dump(data,"aaaa")
	-- 	dump(fields,"fields")	
	item:setVisible(data~=nil)
	if data==nil then
		return ;
	end
	
	for i=1,#fields do
		local txt=item:getChildByName("Text_"..i)
		local f=fields[i]
		
		if txt==nil then
			return;
		end
		local val=data[f]
		if type(val)=='userdata' then
			val='0'
		end
		-- print( type(data[f]))
		if call[f]~=nil then
			txt:setString(""..call[f](val))
		elseif val~=nil then
			txt:setString(""..val)
		else
			-- print("空数据",f)
			txt:setString("")
		end
	end
end
-- 可以搞两个长度 &&表情处理
function ExternalFun.limitName(name,isBig)
	name=ExternalFun.filterEmoji(name)
	return name
end
--计算某一天的前几天
function ExternalFun.day_step(old_day,step)
   local y,m,d
   if("0" ~= string.sub(old_day,6,6)) then
      m=string.sub(old_day,6,7)
   else
      m=string.sub(old_day,7,7)
   end

   if("0" ~= string.sub(old_day,9,9)) then
      d=string.sub(old_day,9,10)
   else
      d=string.sub(old_day,10,10)
   end

   y=string.sub(old_day,0,4)
   local old_time=os.time{year=y,month=m,day=d}
   local new_time=old_time+86400*step

   local new_day=os.date("*t",new_time)
   local res=""

   if(tonumber(new_day.day)<10 and tonumber(new_day.month)<10)then
      res=new_day.year.."-".."0"..new_day.month.."-".."0"..new_day.day
   elseif tonumber(new_day.month)<10 then
      res=new_day.year.."-".."0"..new_day.month.."-"..new_day.day
   elseif tonumber(new_day.day)<10 then
      res=new_day.year.."-"..new_day.month.."-".."0"..new_day.day
   else
      res=new_day.year.."-"..new_day.month.."-"..new_day.day
   end
   return res
end
--btnlist
function ExternalFun.BtnList(btn,btnname,call)
	local btnvw = ccui.ListView:create()
	btnvw:setTouchEnabled(false)
	btnvw:setItemsMargin(0)
	btnvw:setAnchorPoint(cc.p(0.5,1))
	btnvw:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	btnvw:setSwallowTouches(false)
	btnvw:setScrollBarOpacity(0)
	btnvw:setPosition(btn:getPosition())
	btnvw:setContentSize(btn:getContentSize().width,45* #btnname) --btn:getContentSize().height 
	for k,v in pairs (btnname) do
		--local item =--btn:clone()
        local item =ccui.Button:create("Public/duoxuananniubj.png","Public/duoxuananniubj.png")
        item:setScale9Enabled(true)
        item:setContentSize(btn:getContentSize().width,45)
        item:setTitleText(v)
        item:setTitleFontName("font/FZY4JW.TTF")
        item:setTitleFontSize(28)
		if item:getChildByName("T") then
			item:getChildByName("T"):setString(v)
		end
		if  item:getChildByName("I") then
			item:getChildByName("I"):setVisible(false)
		end
		item:setName(k)
		local btcallback = function (ref, type)
			if type == ccui.TouchEventType.ended then
				ExternalFun.playClickEffect()
				btnvw:setVisible(false)
				call(ref:getTag())
	        end
	    end
	    item:addTouchEventListener(btcallback)
	    item:setTag(k)
		btnvw:pushBackCustomItem(item)
	end
	return btnvw
end
function  ExternalFun.cteartTF(TF,str,isnumber,isphone,ispass,size,isback)				---创建输入框
	if nil == TF then
		return
	end
	local moshi = cc.EDITBOX_INPUT_MODE_SINGLELINE
	local index = 1000000
	if isphone  then
		moshi = cc.EDITBOX_INPUT_MODE_PHONENUMBER
		index = 11
	end
	if  isnumber then
		moshi = cc.EDITBOX_INPUT_MODE_NUMERIC
		index = 10
	end 
	if  ispass then
		moshi = cc.EDITBOX_INPUT_FLAG_PASSWORD
		index = 11
	end 
    if  isback then
        moshi = cc.EDITBOX_INPUT_MODE_PHONENUMBER
		index = 21
    end
    local fontsizes=20
    if size then
        fontsizes=size
    end
	local NewTF = ccui.EditBox:create(TF:getContentSize(),"Public/shuru.png")
	:setPosition(TF:getPosition())
	:setAnchorPoint(TF:getAnchorPoint())
	:setFontSize(fontsizes)--TF:getFontSize())
	:setInputMode(moshi)
	:setMaxLength(index)
    
    -- :setFontColor(cc.c3b(255, 255, 255))

	:setPlaceHolder(str)
    -- 给EditBox 注册回调函数
    local handler = function(event, pSender)
        local edit = tolua.cast(pSender,"ccui.EditBox")
        if event == "began" then
            NewTF:setText("")
        end
        
    end
    NewTF:registerScriptEditBoxHandler(handler)

	return NewTF
end
function  ExternalFun.cteartTFtwo(TF,nodebj,str,isnumber,isphone,ispass,size,isback)				---创建输入框
	if nil == TF then
		return
	end
	local moshi = cc.EDITBOX_INPUT_MODE_SINGLELINE
	local index = 20
	if isphone  then
		moshi = cc.EDITBOX_INPUT_MODE_PHONENUMBER
		index = 11
	end
	if  isnumber then
		moshi = cc.EDITBOX_INPUT_MODE_NUMERIC
		index = 8
	end 
	if  ispass then
		moshi = cc.EDITBOX_INPUT_FLAG_PASSWORD
		index = 11
	end 
    if  isback then
        moshi = cc.EDITBOX_INPUT_MODE_PHONENUMBER
		index = 21
    end
    local fontsizes=20
    if size then
        fontsizes=size
    end
	local NewTF = ccui.EditBox:create(cc.size(TF:getContentSize().width-10,TF:getContentSize().height),"Public/shuru.png")
   
	:setFontSize(0)
    :setPosition(TF:getPosition())
	:setInputMode(moshi)
	:setMaxLength(index)
	:setPlaceHolder("")
    :setFontColor(cc.c3b(102, 102, 102))
    :addTo(nodebj,-1)
    -- 给EditBox 注册回调函数TF:getContentSize().width-10,TF:getContentSize().height
    local NewTFW =cc.Label:createWithTTF(str, "font/FZY4JW.TTF", fontsizes,cc.size(TF:getContentSize()))
    	--:setPosition(TF:getPosition())
        :setWidth(TF:getContentSize().width-15)
        :setHeight(fontsizes)
        :setPosition(cc.p(5,TF:getContentSize().height/2))
        :setAnchorPoint(0,0.5)
        :setName("TF")
        :addTo(TF)
    local handler = function(event, pSender)
        local edit = tolua.cast(pSender,"ccui.EditBox")
        if event == "began" then
            NewTFW:setString("")
            NewTF:setText("")
        end
        
        if event == "changed" then
            local strs = NewTF:getText()
            NewTFW:setString(strs)
        end
        
                
        if event == "return" then
            local strs = NewTF:getText()
            local tmpStr = string.gsub(strs, " ", "")
            if tmpStr == "" then
                NewTFW:setString(str)
            else
                NewTFW:setString(strs)
            end
        end
    end
    NewTF:registerScriptEditBoxHandler(handler)

	return NewTFW
end
function ExternalFun.checkTFIDtwo(TF)				--检查输入框ID
	if nil == TF then
		return
	end
	local chatnum =tonumber(TF:getString()) --TF:getString() --
	--chatstr = string.gsub(chatstr, " " , "")
    local chatstr =TF:getString()
    if chatnum ==nil  then
        showToast("请输入玩家ID",2)
        return
    end
    
    if ExternalFun.stringLen(chatstr) > 8  then
        showToast("您输入的ID太长",1)
    	return false
    end
    if ExternalFun.stringLen(chatstr) ==nil or ExternalFun.stringLen(chatstr) < 4  then
		showToast("您输入的ID太短",1)
    	return	false
	end
	if tonumber(chatstr) == tonumber(public.userCode) then
		showToast("不能输入自己的ID",1)
		return	false
	end
	return true
end

function ExternalFun.checkTFID(TF)				--检查输入框ID
	if nil == TF then
		return
	end
	local chatstr = TF:getText()
	chatstr = string.gsub(chatstr, " " , "")
    if ExternalFun.stringLen(chatstr) > 12  then
        showToast("您输入的ID太长",1)
    	return false
    end
    if ExternalFun.stringLen(chatstr) ==nil or ExternalFun.stringLen(chatstr) < 4  then
		showToast("您输入的ID太短",1)
    	return	false
	end
	-- if tonumber(chatstr) == tonumber(public.userCode) then
	-- 	showToast("不能输入自己的ID",1)
	-- 	return	false
	-- end
	return true
end
function ExternalFun.checkStringID(str)				--检查输入框ID
	local chatstr = str
	chatstr = string.gsub(chatstr, " " , "")
    if ExternalFun.stringLen(chatstr) > 8  then
        showToast("您输入的ID太长",1)
    	return false
    end
    if ExternalFun.stringLen(chatstr) ==nil or ExternalFun.stringLen(chatstr) < 4  then
		showToast("您输入的ID太短",1)
    	return	false
	end
	if tonumber(chatstr) == tonumber(public.userCode) then
		showToast("不能输入自己的ID",1)
		return	false
	end
	return true
end
function ExternalFun.checkName(TF)				--检查输入框ID
	if nil == TF then
		return
	end
	local chatstr = TF:getText()
	chatstr = string.gsub(chatstr, " " , "")
    if ExternalFun.stringLen(chatstr) > 33  then
        showToast("您输入的名字太长",1)
    	return false
    end
    if ExternalFun.stringLen(chatstr) ==nil or ExternalFun.stringLen(chatstr) < 4  then
		showToast("您输入的名字太短",1)
    	return	false
	end
	return true
end
--贝塞尔抛物线
function ExternalFun.sendcardBezier(aniTime,startPoint,endPoint,height,angle) --抛物线高度
	angle = angle or 270
	local radian = angle*3.14159/180.0
	local q1x = startPoint.x+(endPoint.x-startPoint.x)/4
	local q1 = cc.p(q1x,height+startPoint.y+math.cos(radian)*q1x)
	
	local q2x = startPoint.x + (endPoint.x - startPoint.x)/2.0
	local q2 = cc.p(q2x, height + startPoint.y+math.cos(radian)*q2x)
	
	local bezier = {
		q1,
		q2,
		endPoint
	}
	return cc.BezierTo:create(aniTime,bezier)--cc.EaseInOut:create(,0.5)
end
function ExternalFun.createClipHead(headnode,usercode,Url,headSize,headimage)
    if headnode ==nil then
        return
    end
    
    local HeadSprite = require(appdf.EXTERNAL_SRC .. "HeadSprite")
   
    local    str="Public/frame.png"
    local headbb=nil
    if headimage then
        str=headimage
        headbb=true
    end
--end
    local head = HeadSprite:create(usercode,Url, headSize)
    head:setName(usercode)
    headnode:addChild(head)
    --head:setPosition(headSize/2,headSize/2)
    head:setPosition(headnode:getContentSize().width/2,headnode:getContentSize().height/2)
end
function ExternalFun.is_include(value, tab)
    for k,v in ipairs(tab) do
      if v == value then
          return true
      end
    end
    return false
end
function ExternalFun.showUserCode(userCode)
    local clubinfo=public.getclubinfo(public.enterclubid)
    if string.len(userCode) ~= 6 then
        return ""
    end
    if userCode == public.userCode then
        return userCode
    end
    --只有群主和副群主才能全部显示
    if clubinfo.groupRoleCode  == public.culbCode.qunzhu 
    or clubinfo.groupRoleCode  == public.culbCode.fuqunzhu  then
         return userCode
    end
    local a =string.sub(userCode,1,1)
    local b =string.sub(userCode,6,6)
    local Code = string.format("%s****%s",a,b)
    return Code
end
function ExternalFun.dump(data,str)
    if device.platform == "windows" then 
        dump(data,str)
    end
end
function ExternalFun.print(str)
    if device.platform == "windows" then 
       print(str)
    end
end

function ExternalFun.Rnd_Number(num)
	local key='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
	local str=""
	local x = 1
	for i=1,num,1 do
		x = math.random(1,64)
		str = str..string.sub(key, x, x)
	end
	return str
end
--保留小数点后N位
function ExternalFun.GetPreciseDecimal(nNum, n)
    if type(nNum) ~= "number" then
        tonumber(nNum)
    end
    n = n or 0;
    n = math.floor(n)
    if n < 0 then
        n = 0;
    end
    local nDecimal = 10 ^ n
    local nTemp = math.floor(nNum * nDecimal)
    if nNum < 0 then
        nTemp = math.ceil(nNum * nDecimal)
    end
    local nRet = nTemp / nDecimal;
    return nRet;
end
--获取移动动画
--inorout,0表示加速飞出,1表示加速飞入
--isreverse,0表示不反转,1表示反转
function ExternalFun.getMoveAction(beginpos, endpos, callback, rtime, bScale, inorout, isreverse)
	inorout = inorout or 0
	isreverse = isreverse or 0
	rtime = rtime or 0
	local dis =(endpos.x - beginpos.x) *(endpos.x - beginpos.x) +(endpos.y - beginpos.y) *(endpos.y - beginpos.y)
	dis = math.sqrt(dis)
	local ts = dis / 1500
	if ts < 0.1 then
		ts = 0.1
	elseif ts > 0.3 then
		ts = 0.3
	end
	local act
	local move = cc.MoveTo:create(ts, endpos)
	if inorout == 0 then
		act = cc.EaseOut:create(move, ts)
	else
		act = cc.EaseIn:create(move, ts)
	end
	
	local actions = {}
	if rtime > 0 then
		local ranmove = cc.MoveTo:create(rtime, cc.p(beginpos.x +(math.random() - 0.5) * 50, beginpos.y +(math.random() - 0.5) * 50))
		table.insert(actions, ranmove)
	end
	table.insert(actions, act)
	if callback then
		local fun = cc.CallFunc:create(callback)
		table.insert(actions, fun)
	end
	if bScale then
		local scaleact1 = cc.ScaleTo:create(0.1, 0.5)
		local scaleact2 = cc.ScaleTo:create(0.1, 0.3)
		local scaleact3 = cc.ScaleTo:create(0.1, 0.4)
		table.insert(actions, scaleact1)
		table.insert(actions, scaleact2)
		table.insert(actions, scaleact3)
	end
	
	return cc.Sequence:create(actions)
	
end
