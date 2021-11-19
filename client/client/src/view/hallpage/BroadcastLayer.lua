local BroadcastLayer = class("BroadcastLayer", function(scene)
		local BroadcastLayer = display.newLayer(cc.c4b(0, 0, 0, 0))
    return BroadcastLayer
end)

local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local movespeed = 10
function BroadcastLayer:ctor(scene,notify,data)

    	-- 系统公告列表
	self.scene = scene
  self.m_tabSystemNotice = data or {}
  self.m_tabGameTips = {}
  self._sysIndex = 1
	self._notify = notify
	self.lababgWidth = notify:getContentSize().width
    self._notifyText = cc.Label:createWithTTF("", "fonts/round_body.ttf", 24)
    :addTo(self)
    :setTextColor(cc.c4b(255,191,123,255))
    :setAnchorPoint(cc.p(0,0))
    :enableOutline(cc.c4b(79,48,35,255), 1)

end

function BroadcastLayer:setNoticeData(data)

   self.finishSystemNotice = #data == 0
   self.m_tabSystemNotice = data or {}
   if #self.m_tabSystemNotice > 0 then
      self:onChangeNotify(self.m_tabSystemNotice[1])
   else
    self._notifyText:removeAllChildren()
    self._notifyText:setString("")
    self:onChangeNotify()
  end
end

--跑马灯更新
function BroadcastLayer:onChangeNotify(msg)
  self._notifyText:removeAllChildren()
  self._notifyText:stopAllActions()
  if not msg or not msg.content or #msg.content == 0 then
    self._notifyText:setString("")
    self.m_bNotifyRunning = false
    if self.scene.setLabaVisible then
      self.scene:setLabaVisible(false)
    else
      self._notify:setVisible(false)
    end
    self._tipIndex = 1
    self._sysIndex = 1
    return
  end
  self.inRunning =  true
  msg.content =  string.gsub(msg.content,"\n","")
  msg.content =  string.gsub(msg.content," ","")
  local tb = string.split(msg.content,"^")
  if #tb > 1 then
    self:onChangeScorllNotifyList(tb)
  else 
    self:onChangeScorllNotify(tb[1])
  end
end

function BroadcastLayer:onChangeScorllNotifyList(list)
     
      self.m_bNotifyRunning = true
      self._notifyText:setVisible(false)
      self._notifyText:setString(list[1])
      local color = string.split(list[2],",")
      if color then
        self._notifyText:setTextColor(cc.c4b(tonumber(color[1] or 255),tonumber(color[2] or 250),tonumber(color[3] or 255),255))
      end
      local tmpWidth = self._notifyText:getContentSize().width
      if list[3] and #list[3] > 0  then
        local sp = display.newSprite(list[3])
        if sp then
          local size = sp:getContentSize()
          sp:addTo(self._notifyText)
          sp:setPositionX(tmpWidth+size.width/2)
          tmpWidth = tmpWidth + size.width
        end
      end
      local len = #list
      local curidx = 4
      while len > 3 do
        local _notifyText2 = cc.Label:createWithTTF(list[curidx], "fonts/round_body.ttf", 24)
        :addTo(self._notifyText)
        :setAnchorPoint(cc.p(0,0))
        :enableOutline(cc.c4b(79,48,35,255), 1)
        :setPositionX(tmpWidth)

        local tmpWidth2 = _notifyText2:getContentSize().width
        tmpWidth = tmpWidth + tmpWidth2
        local color = string.split(list[curidx+1],",")
        if color then
          _notifyText2:setTextColor(cc.c4b(tonumber(color[1] or 255),tonumber(color[2] or 250),tonumber(color[3] or 255),255))
        end
        local sp = display.newSprite(list[curidx+2])
        if sp then
          local size = sp:getContentSize()
          sp:addTo(self._notifyText)
          sp:setAnchorPoint(cc.p(0.5,0.5))
          sp:setPositionX(tmpWidth+size.width/2)
          tmpWidth = tmpWidth + size.width
        end
        len = len - 3
        curidx = curidx + 3
      end
    local seqact =cc.Sequence:create(
        cc.CallFunc:create(	function ()
          self._notifyText:move(self.lababgWidth,-12)
          self._notifyText:setVisible(true)
          if self.scene.setLabaVisible then
        self.scene:setLabaVisible(true)
      else
        self._notify:setVisible(true)
      end
    end),
    cc.MoveTo:create(movespeed + (tmpWidth / 172),cc.p(0-tmpWidth,-12)),
    cc.CallFunc:create(	function ()
      local tipsSize = 0
      local tips = {}
      local index = 1
      if 0 ~= #self.m_tabGameTips and self.finishSystemNotice then
        --游戏喇叭等  播放一次
        -- self._notifyText:removeAllChildren()
        -- self:onChangeGameNotify(table.remove(self.m_tabGameTips,1))
      else
        -- 系统公告
        self._sysIndex =  self._sysIndex + 1
        if self._sysIndex > #self.m_tabSystemNotice then
          self._sysIndex = 1
        end
        if self._sysIndex == #self.m_tabSystemNotice then
          self.finishSystemNotice =  true
        end
        self._notifyText:removeAllChildren()
        self:onChangeNotify(self.m_tabSystemNotice[self._sysIndex])
      end
    end)
    )
	  seqact:setTag(128)
    self._notifyText:runAction(seqact)
end

function BroadcastLayer:removeGamenotice()
	  self.m_tabGameTips = {}
end

function BroadcastLayer:onChangeScorllNotify(msg)

    self.m_bNotifyRunning = true
    
    self._notifyText:setVisible(false)
    self._notifyText:setString(msg)
    self._notifyText:setTextColor(cc.c4b(255,250,255,255))
    
    local tmpWidth = self._notifyText:getContentSize().width
    local seqact = cc.Sequence:create(
    cc.CallFunc:create(	function ()
        self._notifyText:move(public.WIDTH,-12)
        self._notifyText:setVisible(true)
        self._notify:setVisible(true)
    end),
    cc.MoveTo:create(movespeed + (tmpWidth / 172),cc.p(0-tmpWidth,-12)),
    cc.CallFunc:create(	function ()
        self._notify:setVisible(false)
        end
    ),
    -- cc.DelayTime:create(60),
    cc.CallFunc:create(	function ()
      local tipsSize = 0
      local tips = {}
      local index = 1
      if 0 ~= #self.m_tabGameTips and self.finishSystemNotice then
        -- 游戏喇叭等  播放一次
        self._notifyText:removeAllChildren()
      else
        -- 系统公告
        self._sysIndex =  self._sysIndex + 1
        if self._sysIndex > #self.m_tabSystemNotice then
          self._sysIndex = 1
        end
        if self._sysIndex == #self.m_tabSystemNotice then
          self.finishSystemNotice =  true
        end
        self._notifyText:removeAllChildren()
        self:onChangeNotify(self.m_tabSystemNotice[self._sysIndex])
      end
    end)
    )
    seqact:setTag(128)
    self._notifyText:runAction(seqact)
end

return BroadcastLayer