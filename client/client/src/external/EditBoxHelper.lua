local EditBoxHelper = {}


--TextField替换为editbox
function EditBoxHelper.replaceTextField(widget, iMaxLength, image)
    if widget == nil then
        return
    end;
    if widget.getDescription == nil then
        return;
    end
    if widget:getDescription() ~= "TextField" then
        return;
    end
    --九宫格,输入框背景
    if image == nil then
        image = ccui.Scale9Sprite:create()
    end
    --TextField的属性
    local pos = cc.p(widget:getPosition());
    local pAnchorPoint = widget:getAnchorPoint();
    local size = widget:getContentSize();
    local iZOrder = widget:getLocalZOrder();
    local parent = widget:getParent();
    local pName = widget:getName();
    local sPlaceHolder = widget:getPlaceHolder();
    local iTag = widget:getTag();
    local fontSize = widget:getFontSize();
    local max=widget:getMaxLength()
    widget:removeFromParent();

    --创建并设置属性
    local editBox = ccui.EditBox:create(size, image);
    editBox:setAnchorPoint(pAnchorPoint);               --锚点
    editBox:setPosition(pos);                           --位置
    editBox:setLocalZOrder(iZOrder);                    --层级
    editBox:setName(pName);                             --名称
    editBox:setTag(iTag);                               --Tag
    editBox:setFontSize(fontSize);                      --文本尺寸
    editBox:setPlaceHolder(sPlaceHolder);               --占位文本
    editBox:setPlaceholderFontSize(fontSize);           --占位文本尺寸
    if iMaxLength ~= nil then
        editBox:setMaxLength(iMaxLength);               --字数限制
    else
        editBox:setMaxLength(max or 10)
    end
    editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)  --键盘返回类型

    if parent ~= nil then
        parent:addChild(editBox);                  
    end
    
    return editBox;
end

return EditBoxHelper;
