local loadingCircleLayer = class("loadingCircleLayer", function ()
	local loadingCircleLayer =  display.newLayer(cc.c4b(0, 0, 0, 180))
	return loadingCircleLayer
end)
local TAG={1,2,3,4}
function loadingCircleLayer:ctor(_scene,ble)
	self.scene=_scene
	local rootLayer, csbNode = ExternalFun.loadRootCSB("Layer/loadingCircleLayer.csb", self)
	self.bj=csbNode:getChildByName("bj")
    performWithDelay(self,function ()
            if self then
                self:removeFromParent()
            end
    end,20)
end
function loadingCircleLayer:guanbi()
   self:removeFromParent()
end
return loadingCircleLayer

