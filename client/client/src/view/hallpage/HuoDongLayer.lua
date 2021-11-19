local HuoDongLayer = class("HuoDongLayer", function ()
	local HuoDongLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return HuoDongLayer
end)
cc.exports.HdDownloadListener = function (ncode, msg, filename)
	local event = cc.EventCustom:new(FACEDOWNLOAD_LISTENER)
	event.code = ncode
	event.msg = msg
	event.filename = filename
	cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end
function HuoDongLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/HuoDongLayer.csb", self)
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
    self.bb={}
	for i = 1, 3 do
		local str =string.format("B%d",i)
		self.bb[i]=self.bj:getChildByName(str)
		self.bb[i]:setTag(i)
		:addTouchEventListener(btcallback)
        -- if i ~=1 then
        --     self.bb[i]:setVisible(false)
        -- end
	end
    self.pages={}
    	for i = 1, 3 do
		local str =string.format("page%d",i)
		self.pages[i]=self.bj:getChildByName(str)
	end
    local pk =self.bj:getChildByName("page2")
    self.pp=self.bj:getChildByName("P")
    self.Image_1=self.bj:getChildByName("Image_1")
    self.userlist={}
    self.userTableview = cc.TableView:create(pk:getContentSize())	
    self.userTableview:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.userTableview:setPosition(cc.p(0,0))
	self.userTableview:setDelegate()
    self.userTableview:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	self.userTableview:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
	self.userTableview:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
	self.userTableview:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	pk:addChild(self.userTableview)
    
    self.selec=1
    self.activity={}
    self:selectB(1)
    
end
function HuoDongLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
        if nil ~= self.m_downListener then
            cc.Director:getInstance():getEventDispatcher():removeEventListener(self.m_downListener)
            self.m_downListener = nil
        end
        self:removeFromParent()
    elseif tag >=1 and tag <11 then
    	self:selectB(tag)
    end
end
function HuoDongLayer:selectB(index)
	if self.bb[index] ==nil then
		return
	end
	for k,v in pairs(self.bb) do
		v:setEnabled(true)
        v:getChildByName("Text_1"):setColor(cc.c3b(114,69,21))
        if k == index then
            v:setEnabled(false)
            v:getChildByName("Text_1"):setColor(cc.c3b(255,255,255))
        end
	end
    for k,v in pairs(self.pages) do
		v:setVisible(false)
        if k == index then
            v:setVisible(true)
        end
	end
    if index == 2 then
        self.bj:getChildByName("PP"):setVisible(true)
        self.Image_1:setVisible(true)
    else
        self.bj:getChildByName("PP"):setVisible(false)
        self.Image_1:setVisible(false)
    end
    if index ~= 2 then
        if self.activity[index] then
            self:getActivity(self.activity[index],index)
        end
    end
    
    self.selec=index
    self:getData()
end
function HuoDongLayer:getData()
    function Senddata(datas)
		if datas.activityContent then
            --print(datas.activityContent)
            --self.pages[3]:getChildByName("Text_1"):setString()
            self.activity[1]=datas.activityContent
            self:getActivity(datas.activityContent,1)
        end
        if datas.activityRule then
            self.activity[3]=datas.activityRule
            --self.pages[1]:getChildByName("Text_1"):setString(datas.activityRule)
        end
        if datas.users then
            self:inint(datas.users)
        end
	end
    local clubinfo = public.getclubinfo(public.enterclubid)
	local data={}
	data.groupCode=clubinfo.groupCode
    data.userCode =public.userCode
    if self.selec == 2 then
        data.type=1
    end
	--发送
	httpnect.send(HttpHead.getActivity,data,Senddata)
end
function HuoDongLayer:cellSizeForTable( view, idx )
    local x=self.pp:getContentSize().width
    local y=self.pp:getContentSize().height
	return x,y
end
function HuoDongLayer:tableCellAtIndex( view, idx )
    local cell = view:dequeueCell()
    local item =nil
    if cell ==nil then
        cell = cc.TableViewCell:new()
        item=self.pp:clone()
        item:setSwallowTouches(false)
        item:setName("user_item")
        self:newUserItem(item,idx)
        item:setAnchorPoint(0,0)
        item:setPosition(0,0)
        cell:addChild(item)
    else
       item = cell:getChildByName("user_item")
       self:newUserItem(item,idx)
    end
	return cell
end
function HuoDongLayer:numberOfCellsInTableView( view )
	return #self.userlist
end
function HuoDongLayer:newUserItem(item,idx)
    local v=self.userlist[idx+1]
    if v.rank >3 then
        item:getChildByName("pai"):setVisible(false)
        item:getChildByName("num"):setString(v.rank)
    else
        local str =string.format("%d.png",v.rank)
        item:getChildByName("pai"):loadTexture(str,ccui.TextureResType.plistType)
        item:getChildByName("pai"):setVisible(true)
    end
    local headbg=item:getChildByName("head")
    --设置头像
       
    ExternalFun.createClipHead(headbg,v.userCode,v.logoUrl,67)
    item:getChildByName("T1"):setString(v.userName)
    item:getChildByName("T2"):setString("ID:"..v.userCode)
    item:getChildByName("T3"):setString(v.winCore)
end
function HuoDongLayer:inint(data)
    if data ==nil or next(data) ==nil then
        return
    end
        local item=self.bj:getChildByName("PP")
        local v=data[#data]
        if v.rank >3 then
            item:getChildByName("pai"):setVisible(false)
            item:getChildByName("num"):setString(v.rank)
        else
            local str =string.format("j%d.png",v.rank)
            item:getChildByName("pai"):loadTexture(str,ccui.TextureResType.plistType)
        end
        local headbg=item:getChildByName("head")
        --设置头像
       
        ExternalFun.createClipHead(headbg,v.userCode,v.logoUrl,67)
        item:getChildByName("T1"):setString(v.userName)
        item:getChildByName("T2"):setString("ID:"..v.userCode)
        item:getChildByName("T3"):setString(v.winCore)
        
        self.userlist=data
        self.userTableview:reloadData()
        
end
function HuoDongLayer:getActivity(acturl,index)
    local this = self
    if  nil ~= acturl and string.len(acturl) > 0 then
        local clubinfo = public.getclubinfo(public.enterclubid)
        local filename = string.gsub(acturl, "[/.:+]", "") .. ".png"
        local framename = filename
		local path = device.writablePath .. "Activity/" .. clubinfo.groupCode
		local filepath = path .. "/" .. filename
		local bHave = self:haveCacheOrLocalFile(framename, filepath, index) 
		if bHave == false then
            --网络请求
			local url = acturl
			self:downloadtu(url, path, filename, function(downloadfile)
				local selffile = filename
				if selffile == downloadfile then
                    if this and this.updateUi then
                        this:updateUi(filepath,index)
					end
            	end
			end)	
        end
    end
end
function HuoDongLayer:haveCacheOrLocalFile(framename, filepath,index)
	--判断是否有缓存

    local path = filepath
	if cc.FileUtils:getInstance():isFileExist(path) then
        self:updateUi(filepath,index)
        return true
    end
	return false
end
function HuoDongLayer:updateUi(filepath,index)
    local bg = ccui.ImageView:create(filepath)
    self.pages[index]:removeAllChildren()
    local y=self.pages[index]:getContentSize().width
    local bjy=bg:getContentSize().width
    local scale=y/bjy
    bg:setScale(scale)
    local hegith=bg:getContentSize().height*(scale)
    self.pages[index]:setInnerContainerSize(cc.size(y,hegith))
    bg:setPosition(y/2,hegith/2)
    self.pages[index]:addChild(bg)
end

--下载头像
function HuoDongLayer:downloadtu(url, path, filename, onDownLoadSuccess)
	local downloader = CurlAsset:createDownloader("HdDownloadListener",url)			
	if false == cc.FileUtils:getInstance():isDirectoryExist(path) then
		cc.FileUtils:getInstance():createDirectory(path)
	end			

	local function eventCustomListener(event)
        if nil ~= event.filename and 0 == event.code then
        	if nil ~= onDownLoadSuccess 
        		and type(onDownLoadSuccess) == "function" 
        		and nil ~= event.filename 
        		and type(event.filename) == "string" then
        		onDownLoadSuccess(event.filename)
        	end        	
        end
	end
	if nil ~= self.m_downListener then
		cc.Director:getInstance():getEventDispatcher():removeEventListener(self.m_downListener)
		self.m_downListener = nil
	end
	self.m_downListener = cc.EventListenerCustom:create(FACEDOWNLOAD_LISTENER,eventCustomListener)
	cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(self.m_downListener, 1)
	downloader:downloadFile(path, filename)
end
return HuoDongLayer