local BrNPlayerListLayer = class("BrNPlayerListLayer", function ()
	local BrNPlayerListLayer =  display.newLayer()
	return BrNPlayerListLayer
end)
function BrNPlayerListLayer:ctor(_scene)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Game/brpublicLayer/BrNPlayerListLayer.csb", self)
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
	
    self.p=self.bj:getChildByName("P")
    self.pk=self.bj:getChildByName("pk")
    self.userlist={}
    self.userTableview = cc.TableView:create(self.p:getContentSize())	
    self.userTableview:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.userTableview:setPosition(cc.p(0,0))
	self.userTableview:setDelegate()
    self.userTableview:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	self.userTableview:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
	self.userTableview:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
	self.userTableview:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	self.p:addChild(self.userTableview)
    
    --获取数据
    gst.send(BaiRenHead.OnLineUserlist,nil)
end

function BrNPlayerListLayer:onButtonClickedEvent(tag,ref)
    if tag == 100 then
		self:removeFromParent()
    end
end
function BrNPlayerListLayer:cellSizeForTable( view, idx )
    local x=self.pk:getContentSize().width
    local y=self.pk:getContentSize().height
	return x,y
end
function BrNPlayerListLayer:tableCellAtIndex( view, idx )
    local cell = view:dequeueCell()
    local item =nil
    if cell ==nil then
        cell = cc.TableViewCell:new()
        item=self.pk:clone()
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
function BrNPlayerListLayer:numberOfCellsInTableView( view )
	return #self.userlist
end
function BrNPlayerListLayer:newUserItem(item,idx)
    local v=self.userlist[idx+1]
    local head=item:getChildByName("head")
    ExternalFun.createClipHead(head,v.userCode,v.logoUrl,70)
    item:getChildByName("T1"):setString(v.userName)
    item:getChildByName("T2"):setString(ExternalFun.showUserCode(v.userCode))
    item:getChildByName("T3"):setString(v.betCount)
    item:getChildByName("T4"):setString(v.betCoins)
    item:getChildByName("T5"):setString(v.sl.."%")
    item:getChildByName("A"):setString(idx+1)
end
function BrNPlayerListLayer:inint(data)
    self.userlist=data
    self.userTableview:reloadData()
end
return BrNPlayerListLayer

