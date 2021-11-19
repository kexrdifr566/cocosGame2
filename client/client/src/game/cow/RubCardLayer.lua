--[[ 
    @Description: 搓牌
    
    @Function: 描述这个类的功能
    
    @Author: wangjiajun
    
    @Date:   2018-12-15 10:11:28
    
    @Change the time:   wangjiajun on 2018-12-17 16:54:24
    
]]
-- 从下往上
local moveVertSourceDown = [[
#ifdef GL_ES
precision mediump float;    // shader默认精度为double，openGL为了提升渲染效率将精度设为float
#endif

attribute vec2 a_position;
attribute vec2 a_texCoord;

#ifdef GL_ES
varying lowp vec4 v_fragmentColor;  // 颜色
varying mediump vec2 v_texCoord;    // 坐标
#else
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
#endif

uniform float ratio;                    //比例
uniform float radius;                   //半径
uniform float width;                    //宽度
uniform float height;                   //高度
uniform float offx;                     //X轴偏移
uniform float offy;                     //Y轴偏移
uniform float rotation;                 //旋转

void main()
{
    vec4 tmp_pos = vec4(0.0, 0.0, 0.0, 0.0);
    tmp_pos = vec4(a_position.x, a_position.y, 1.0, 1.0);
    
    float halfPeri = radius * 3.1415926;
    float hr = height * ratio;
    if (hr > 0.0 && hr <= halfPeri) {
        if (tmp_pos.y < hr) {
            float rad = hr/ 3.1415926;
            float arc = (hr-tmp_pos.y)/rad;
            tmp_pos.y = hr - sin(arc)*rad;
            tmp_pos.z = rad * (1.0-cos(arc));
        }
    }
    if (hr > halfPeri) {
        float straight = (hr - halfPeri)/2.0;
        if (tmp_pos.y < straight) {
            tmp_pos.y = hr  - tmp_pos.y;
            tmp_pos.z = radius * 2.0;
        } else if (tmp_pos.y < (straight + halfPeri)) {
            float dy = halfPeri - (tmp_pos.y - straight);
            float arc = dy/radius;
            tmp_pos.y = hr - straight - sin(arc)*radius;
            tmp_pos.z = radius * (1.0-cos(arc));
        }
    }
    float y1 = tmp_pos.y;
    float z1 = tmp_pos.z;
    float y2 = height;
    float z2 = 0.0;
    float sinRat = sin(rotation);
    float cosRat = cos(rotation);

    tmp_pos.y=(y1-y2)*cosRat-(z1-z2)*sinRat+y2;
    tmp_pos.z=(z1-z2)*cosRat+(y1-y2)*sinRat+z2;

    tmp_pos.y = tmp_pos.y - height/2.0*(1.0-cosRat);
    tmp_pos += vec4(offx, offy, 0.0, 0.0);

    gl_Position = CC_MVPMatrix * tmp_pos;
    v_texCoord = a_texCoord;
}
]]

-- 从上往下
local moveVertSourceUp = [[
#ifdef GL_ES
precision mediump float;    // shader默认精度为double，openGL为了提升渲染效率将精度设为float
#endif

attribute vec2 a_position;
attribute vec2 a_texCoord;

#ifdef GL_ES
varying lowp vec4 v_fragmentColor;  // 颜色
varying mediump vec2 v_texCoord;    // 坐标
#else
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
#endif

uniform float ratio;                    //比例
uniform float radius;                   //半径
uniform float width;                    //宽度
uniform float height;                   //高度
uniform float offx;                     //X轴偏移
uniform float offy;                     //Y轴偏移
uniform float rotation;                 //旋转

void main()
{
    vec4 tmp_pos = vec4(0.0, 0.0, 0.0, 0.0);
    tmp_pos = vec4(a_position.x, height - a_position.y, 0.0, 1.0);

    float halfPeri = radius * 3.1415926;
    float hr = height * ratio;
    if (hr > 0.0 && hr <= halfPeri) {
        if (tmp_pos.y < hr) {
            float rad = hr/ 3.1415926;
            float arc = (hr-tmp_pos.y)/rad;
            tmp_pos.y = hr - sin(arc)*rad;
            tmp_pos.z = rad * (1.0-cos(arc));
        }
    }
    if (hr > halfPeri) {
        float straight = (hr - halfPeri)/2.0;
        if (tmp_pos.y < straight) {
            tmp_pos.y = hr  - tmp_pos.y;
            tmp_pos.z = radius * 2.0;
        } else if (tmp_pos.y < (straight + halfPeri)) {
            float dy = halfPeri - (tmp_pos.y - straight);
            float arc = dy/radius;
            tmp_pos.y = hr - straight - sin(arc)*radius;
            tmp_pos.z = radius * (1.0-cos(arc));
        }
    }
    tmp_pos.y = height - tmp_pos.y;
    float y1 = tmp_pos.y;
    float z1 = tmp_pos.z;
    float y2 = height;
    float z2 = 0.0;
    float sinRat = sin(rotation);
    float cosRat = cos(rotation);

    tmp_pos.y=(y1-y2)*cosRat-(z1-z2)*sinRat+y2;
    tmp_pos.z=(z1-z2)*cosRat+(y1-y2)*sinRat+z2;

    tmp_pos.y = tmp_pos.y - height/2.0*(1.0-cosRat);
    tmp_pos += vec4(offx, offy, 0.0, 0.0);

    gl_Position = CC_MVPMatrix * tmp_pos;
    v_texCoord = a_texCoord;
}
]]

-- 从左往右
local moveVertSourceLeft = [[
#ifdef GL_ES
precision mediump float;    // shader默认精度为double，openGL为了提升渲染效率将精度设为float
#endif

attribute vec2 a_position;
attribute vec2 a_texCoord;

#ifdef GL_ES
varying lowp vec4 v_fragmentColor;  // 颜色
varying mediump vec2 v_texCoord;    // 坐标
#else
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
#endif

uniform float ratio;                    //比例
uniform float radius;                   //半径
uniform float width;                    //宽度
uniform float height;                   //高度
uniform float offx;                     //X轴偏移
uniform float offy;                     //Y轴偏移
uniform float rotation;                 //旋转

void main()
{
    vec4 tmp_pos = vec4(0.0, 0.0, 0.0, 0.0);
    tmp_pos = vec4(a_position.x, a_position.y, 0.0, 1.0);

    float halfPeri = radius * 3.1415926;
    float hr = width * ratio;
    if (hr > 0.0 && hr <= halfPeri) {
        if (tmp_pos.x < hr) {
            float rad = hr/ 3.1415926;
            float arc = (hr-tmp_pos.x)/rad;
            tmp_pos.x = hr - sin(arc)*rad;
            tmp_pos.z = rad * (1.0-cos(arc));
        }
    }
    if (hr > halfPeri) {
        float straight = (hr - halfPeri)/2.0;
        if (tmp_pos.x < straight) {
            tmp_pos.x = hr  - tmp_pos.x;
            tmp_pos.z = radius * 2.0;
        } else if (tmp_pos.x < (straight + halfPeri)) {
            float dx = halfPeri - (tmp_pos.x - straight);
            float arc = dx/radius;
            tmp_pos.x = hr - straight - sin(arc)*radius;
            tmp_pos.z = radius * (1.0-cos(arc));
        }
    }
    float x1 = tmp_pos.x;
    float z1 = tmp_pos.z;
    float x2 = width;
    float z2 = 0.0;
    float sinRat = sin(rotation);
    float cosRat = cos(rotation);

    tmp_pos.x=(x1-x2)*cosRat-(z1-z2)*sinRat+x2;
    tmp_pos.z=(z1-z2)*cosRat+(x1-x2)*sinRat+z2;

    tmp_pos.x = tmp_pos.x - width/2.0*(1.0-cosRat);
    tmp_pos += vec4(offx, offy, 0.0, 0.0);

    gl_Position = CC_MVPMatrix * tmp_pos;
    v_texCoord = a_texCoord;
}
]]

-- 从右往左
local moveVertSourceRight = [[
#ifdef GL_ES
precision mediump float;    // shader默认精度为double，openGL为了提升渲染效率将精度设为float
#endif

attribute vec2 a_position;
attribute vec2 a_texCoord;

#ifdef GL_ES
varying lowp vec4 v_fragmentColor;  // 颜色
varying mediump vec2 v_texCoord;    // 坐标
#else
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
#endif

uniform float ratio;                    //比例
uniform float radius;                   //半径
uniform float width;                    //宽度
uniform float height;                   //高度
uniform float offx;                     //X轴偏移
uniform float offy;                     //Y轴偏移
uniform float rotation;                 //旋转

void main()
{
    vec4 tmp_pos = vec4(0.0, 0.0, 0.0, 0.0);
    tmp_pos = vec4(width - a_position.x, a_position.y, 0.0, 1.0);

    float halfPeri = radius * 3.1415926;
    float hr = width * ratio;
    if (hr > 0.0 && hr <= halfPeri) {
        if (tmp_pos.x < hr) {
            float rad = hr/ 3.1415926;
            float arc = (hr-tmp_pos.x)/rad;
            tmp_pos.x = hr - sin(arc)*rad;
            tmp_pos.z = rad * (1.0-cos(arc));
        }
    }
    if (hr > halfPeri) {
        float straight = (hr - halfPeri)/2.0;
        if (tmp_pos.x < straight) {
            tmp_pos.x = hr  - tmp_pos.x;
            tmp_pos.z = radius * 2.0;
        } else if (tmp_pos.x < (straight + halfPeri)) {
            float dx = halfPeri - (tmp_pos.x - straight);
            float arc = dx/radius;
            tmp_pos.x = hr - straight - sin(arc)*radius;
            tmp_pos.z = radius * (1.0-cos(arc));
        }
    }
    tmp_pos.x = width -tmp_pos.x;
    float x1 = tmp_pos.x;
    float z1 = tmp_pos.z;
    float x2 = width;
    float z2 = 0.0;
    float sinRat = sin(rotation);
    float cosRat = cos(rotation);

    tmp_pos.x=(x1-x2)*cosRat-(z1-z2)*sinRat+x2;
    tmp_pos.z=(z1-z2)*cosRat+(x1-x2)*sinRat+z2;

    tmp_pos.x = tmp_pos.x - width/2.0*(1.0-cosRat);
    tmp_pos += vec4(offx, offy, 0.0, 0.0);

    gl_Position = CC_MVPMatrix * tmp_pos;
    v_texCoord = a_texCoord;
}
]]


local smoothVertSource = [[
#ifdef GL_ES
precision mediump float;    // shader默认精度为double，openGL为了提升渲染效率将精度设为float
#endif

attribute vec2 a_position;
attribute vec2 a_texCoord;
varying vec2 v_texCoord;

uniform float width;
uniform float height;
uniform float offx;
uniform float offy;
uniform float rotation;

void main()
{
    vec4 tmp_pos = vec4(0.0, 0.0, 0.0, 0.0);
    tmp_pos = vec4(a_position.x, a_position.y, 0.0, 1.0);

    float cl = height/5.0;
    float sl = (height - cl)/2.0;
    float radii = (cl/rotation)/2.0;
    float sinRot = sin(rotation);
    float cosRot = cos(rotation);
    float distance = radii*sinRot;
    float centerY = height/2.0;
    float poxY1 = centerY - distance;
    float poxY2 = centerY + distance;
    float posZ = sl*sinRot;

    if (tmp_pos.y <= sl) {
        float length = sl - tmp_pos.y;
        tmp_pos.y = poxY1 - length*cosRot;
        tmp_pos.z = posZ - length*sinRot;
    } else if (tmp_pos.y < (sl+cl)) {
        float el = tmp_pos.y - sl;
        float rotation2 = -el/radii;
        float y1 = poxY1;
        float z1 = posZ;
        float y2 = centerY;
        float z2 = posZ - radii*cosRot;
        float sinRot2 = sin(rotation2);
        float cosRot2 = cos(rotation2);
        tmp_pos.y=(y1-y2)*cosRot2-(z1-z2)*sinRot2+y2;
        tmp_pos.z=(z1-z2)*cosRot2+(y1-y2)*sinRot2+z2;
    } else {
        float length = tmp_pos.y - cl - sl;
        tmp_pos.y = poxY2 + length*cosRot;
        tmp_pos.z = posZ - length*sinRot;
    }

    tmp_pos += vec4(offx, offy, 0.0, 0.0);
    gl_Position = CC_MVPMatrix * tmp_pos;
    v_texCoord = vec2(a_texCoord.x, 1.0 - a_texCoord.y);
}
]]

local smoothVertSourceLR = [[
#ifdef GL_ES
precision mediump float;    // shader默认精度为double，openGL为了提升渲染效率将精度设为float
#endif

attribute vec2 a_position;
attribute vec2 a_texCoord;
varying vec2 v_texCoord;

uniform float width;
uniform float height;
uniform float offx;
uniform float offy;
uniform float rotation;

void main()
{
    vec4 tmp_pos = vec4(0.0, 0.0, 0.0, 0.0);
    tmp_pos = vec4(width - a_position.x, a_position.y, 0.0, 1.0);

    float cl = width/5.0;
    float sl = (width - cl)/2.0;
    float radii = (cl/rotation)/2.0;
    float sinRot = sin(rotation);
    float cosRot = cos(rotation);
    float distance = radii*sinRot;
    float centerX = width/2.0;
    float poxX1 = centerX - distance;
    float poxX2 = centerX + distance;
    float posZ = sl*sinRot;

    if (tmp_pos.x <= sl) {
        float length = sl - tmp_pos.x;
        tmp_pos.x = poxX1 - length*cosRot;
        tmp_pos.z = posZ - length*sinRot;
    } else if (tmp_pos.x < (sl+cl)) {
        float el = tmp_pos.x - sl;
        float rotation2 = -el/radii;
        float x1 = poxX1;
        float z1 = posZ;
        float x2 = centerX;
        float z2 = posZ - radii*cosRot;
        float sinRot2 = sin(rotation2);
        float cosRot2 = cos(rotation2);
        tmp_pos.x=(x1-x2)*cosRot2-(z1-z2)*sinRot2+x2;
        tmp_pos.z=(z1-z2)*cosRot2+(x1-x2)*sinRot2+z2;
    } else {
        float length = tmp_pos.x - cl - sl;
        tmp_pos.x = poxX2 + length*cosRot;
        tmp_pos.z = posZ - length*sinRot;
    }

    tmp_pos += vec4(offx, offy, 0.0, 0.0);
    gl_Position = CC_MVPMatrix * tmp_pos;
    v_texCoord = vec2(a_texCoord.x, a_texCoord.y);
}
]]


local endVertSource = [[
#ifdef GL_ES
    precision mediump float;    // shader默认精度为double，openGL为了提升渲染效率将精度设为float
#endif

attribute vec2 a_position;
attribute vec2 a_texCoord;
varying vec2 v_texCoord;        // 坐标

uniform float width;
uniform float height;
uniform float offx;
uniform float offy;

void main()
{
    vec4 tmp_pos = vec4(0.0, 0.0, 0.0, 0.0);
    tmp_pos = vec4(a_position.x, a_position.y, 0.0, 1.0);

    tmp_pos += vec4(offx, offy, 0.0, 0.0);
    gl_Position = CC_MVPMatrix * tmp_pos;
    v_texCoord = vec2(a_texCoord.x, 1.0 - a_texCoord.y);
}
]]

local endVertSourceLR = [[
#ifdef GL_ES
    precision mediump float;    // shader默认精度为double，openGL为了提升渲染效率将精度设为float
#endif

attribute vec2 a_position;
attribute vec2 a_texCoord;
varying vec2 v_texCoord;        // 坐标

uniform float width;
uniform float height;
uniform float offx;
uniform float offy;

void main()
{
    vec4 tmp_pos = vec4(0.0, 0.0, 0.0, 0.0);
    tmp_pos = vec4(width - a_position.x, a_position.y, 0.0, 1.0);

    tmp_pos += vec4(offx, offy, 0.0, 0.0);
    gl_Position = CC_MVPMatrix * tmp_pos;
    v_texCoord = vec2(a_texCoord.x, a_texCoord.y);
}
]]

local strFragSource = [[
#ifdef GL_ES
    precision mediump float;    // shader默认精度为double，openGL为了提升渲染效率将精度设为float
#endif

// varying变量为顶点shader经过光栅化阶段的线性插值后传给片段着色器
varying vec4 v_fragmentColor;   // 颜色
varying vec2 v_texCoord;        // 坐标

void main()
{
    //TODO, 这里可以做些片段着色特效
    gl_FragColor = texture2D(CC_Texture0, v_texCoord);
}
]]

local RubCardLayer = class("RubCardLayer", function()
    local node = display.newLayer()
    return node
end)

local direction = {
    up = 1,
    down = 2,
    left = 3,
    right = 4
}

local RubCardLayer_Pai = 3.1415926
local RubCardLayer_State_Move = 1
local RubCardLayer_State_Smooth = 2

local RubCardLayer_RotationFrame = 10
local RubCardLayer_RotationAnger = RubCardLayer_Pai/3

local RubCardLayer_SmoothFrame = 10
local RubCardLayer_SmoothAnger = RubCardLayer_Pai/6

function RubCardLayer:ctor(szBack,strdian, szFont, posX, posY, endCallBack)
    local csbNode = cc.CSLoader:createNode("Game/cowLayer/cuoLayer.csb")
    csbNode:addTo(self)
    self.csbNode=csbNode
    self._rootNode =  cc.Node:create()
    self._rootNode:setContentSize(display.width,display.height)
    self._rootNode:addTo(csbNode,4)
    self:__init(szBack,strdian, szFont, posX, posY, endCallBack)
end

function RubCardLayer:__init(szBack, strdian,szFont, posX, posY, endCallBack)
    self.posX = posX
    self.posY = posY
    self.endCallBack = endCallBack
    self.strdian=strdian
    local scale =1
    self.scale = scale
    -- 绘制状态
    self.state = RubCardLayer_State_Move

    local glNode = gl.glNodeCreate()
    self.glNode = glNode
    self._rootNode:addChild(glNode)

    -- 从下向上
    local moveGlProgramDown = cc.GLProgram:createWithByteArrays(moveVertSourceDown, strFragSource)
    self.moveGlProgramDown = moveGlProgramDown
    moveGlProgramDown:retain()
    moveGlProgramDown:updateUniforms()

    -- 从上向下
    local moveGlProgramUp = cc.GLProgram:createWithByteArrays(moveVertSourceUp, strFragSource)
    self.moveGlProgramUp = moveGlProgramUp
    moveGlProgramUp:retain()
    moveGlProgramUp:updateUniforms()

    -- 从左向右
    local moveGlProgramLeft = cc.GLProgram:createWithByteArrays(moveVertSourceLeft, strFragSource)
    self.moveGlProgramLeft = moveGlProgramLeft
    moveGlProgramLeft:retain()
    moveGlProgramLeft:updateUniforms()

    -- 从右向左
    local moveGlProgramRight = cc.GLProgram:createWithByteArrays(moveVertSourceRight, strFragSource)
    self.moveGlProgramRight = moveGlProgramRight
    moveGlProgramRight:retain()
    moveGlProgramRight:updateUniforms()

    -- 上下使用
    local smoothGlProgram = cc.GLProgram:createWithByteArrays(smoothVertSource, strFragSource)
    self.smoothGlProgram = smoothGlProgram
    smoothGlProgram:retain()
    smoothGlProgram:updateUniforms()

    -- 左右使用
    local smoothGlProgramLR = cc.GLProgram:createWithByteArrays(smoothVertSourceLR, strFragSource)
    self.smoothGlProgramLR = smoothGlProgramLR
    smoothGlProgramLR:retain()
    smoothGlProgramLR:updateUniforms()

    -- 上下使用
    local endGlProgram = cc.GLProgram:createWithByteArrays(endVertSource, strFragSource)
    self.endGlProgram = endGlProgram
    endGlProgram:retain()
    endGlProgram:updateUniforms()

    -- 左右使用
    local endGlProgramLR = cc.GLProgram:createWithByteArrays(endVertSourceLR, strFragSource)
    self.endGlProgramLR = endGlProgramLR
    endGlProgramLR:retain()
    endGlProgramLR:updateUniforms()

    self:__registerTouchEvent()
    
    -- 创建扑克显示对象
    self:createSprites(szBack, szFont)

    -- OpenGL绘制函数
    local function draw(transform, transformUpdated)
        if self.state == RubCardLayer_State_Move then
            self:__drawByMoveProgram(0)

        elseif self.state == RubCardLayer_State_Smooth then
            if self.smoothFrame == nil then
                self.smoothFrame = 1
            end
            if self.smoothFrame <= RubCardLayer_RotationFrame then
                local rotation = -RubCardLayer_RotationAnger * self.smoothFrame / RubCardLayer_RotationFrame
                if direction.up == self.direction or direction.right == self.direction then
                    rotation = 0 - rotation
                end

                self:__drawByMoveProgram(rotation)

            elseif self.smoothFrame < (RubCardLayer_RotationFrame + RubCardLayer_SmoothFrame) then
                local _scale = (self.smoothFrame - RubCardLayer_RotationFrame)/RubCardLayer_SmoothFrame
                self:__drawBySmoothProgram(math.max(0.01, RubCardLayer_SmoothAnger*(1-_scale)))

            else
                self:__drawByEndProgram()
                self:remove()
            end
            self.smoothFrame = self.smoothFrame + 1
        end
    end
    glNode:registerScriptDrawHandler(draw)
    --glNode:setRotation(90)
end
--[[--
这里不需要做长按限制
]]
function RubCardLayer:__registerTouchEvent()
    local function onNodeEvent(event)
        if "exit" == event then
            ----print("释放内存====================")
            gl._deleteBuffer(self.cardMesh[1][2][1].buffer_id)
            gl._deleteBuffer(self.cardMesh[1][2][2].buffer_id)
            gl._deleteBuffer(self.cardMesh[2][2][1].buffer_id)
            gl._deleteBuffer(self.cardMesh[2][2][2].buffer_id)

            gl._deleteBuffer(self.cardMesh_lf[1][2][1].buffer_id)
            gl._deleteBuffer(self.cardMesh_lf[1][2][2].buffer_id)
            gl._deleteBuffer(self.cardMesh_lf[2][2][1].buffer_id)
            gl._deleteBuffer(self.cardMesh_lf[2][2][2].buffer_id)

            self.moveGlProgramDown:release()
            self.moveGlProgramUp:release()
            self.moveGlProgramRight:release()
            self.moveGlProgramLeft:release()

            self.smoothGlProgram:release()
            self.smoothGlProgramLR:release()
            self.endGlProgram:release()
            self.endGlProgramLR:release()
            
            self:stopAllActions()
        end
    end
    self._rootNode:registerScriptHandler(onNodeEvent)

    local touchBeginPos = nil
    self.direction = nil

    local function countDirection(beginPos,movePos)
        if self.direction then
            ----print("已经选择方向了", self.direction)
            return true
        end

        -- xy的偏移度
        local offx = math.abs(beginPos.x - movePos.x)
        local offy = math.abs(beginPos.y - movePos.y)

        if offx - offy > 5 then
            if beginPos.x > self.posX then
                ----print("点击区域在右部分")
                -- 点击区域在右部分
                self.direction = direction.right
            elseif beginPos.x <= self.posX then
                ----print("点击区域在左部分")
                -- 点击区域在左部分
                self.direction = direction.left
            end
        elseif offx - offy < -5 then
            if beginPos.y > self.posY then
                ----print("点击区域在上部分")
                -- 点击区域在上部分
                self.direction = direction.up
            elseif beginPos.y <= self.posY then
                ----print("点击区域在下部分")
                -- 点击区域在下部分
                self.direction = direction.down
            end
        else
            ----print("不在点击区域")
            self.direction = nil
            return false
        end
        return true
    end

    local function touchBegin(touch, event)
        ----print("touchBegin")
        local point = touch:getLocation()
        --dump(point, "开始触摸事件", 9)
        if not touchBeginPos then
            touchBeginPos = point
        else 
            return false
        end
        self.direction = nil
        return true
    end

    local function touchMove(touch, event)
        --print("touchMove")
        local location = touch:getLocation()
        --dump(location, "移动触摸事件", 9)
        countDirection(touchBeginPos, location)

        if not self.direction then return end

        if self.direction == direction.up or self.direction == direction.down then
            self.ratioVal = (location.y - self.offy) / self.pokerHeight
            self.ratioVal = math.max(0, self.ratioVal)
            self.ratioVal = math.min(1, self.ratioVal)

            if self.direction == direction.up then
                --print("direction.up", direction.up, self.ratioVal)
                self.ratioVal = 1.0 - self.ratioVal
            end
        else
            self.ratioVal = (location.x - self.offx) / self.pokerWidth
            self.ratioVal = math.max(0, self.ratioVal)
            self.ratioVal = math.min(1, self.ratioVal)

            if self.direction == direction.right then
                --print("direction.right", direction.right, self.ratioVal)
                self.ratioVal = 1.0 - self.ratioVal
            end
        end

        --print("self.ratioVal", self.ratioVal)

        return true
    end

    local function touchEnd(touch, event)
        touchBeginPos = nil
      
        if self.ratioVal >= 0.85 then
            --print("展示牌值")
            self:endfunc()
            self.state = RubCardLayer_State_Smooth
        else
            --print("还原开始的样子")
            self:runAction(cc.RepeatForever:create( cc.Sequence:create(
                cc.CallFunc:create(function ()
                    self.ratioVal = self.ratioVal - 0.1

                    if self.ratioVal < 0 then
                        self.ratioVal = 0
                    end

                    if self.ratioVal == 0 then
                        self:endfunc()
                    end
                end),
                cc.DelayTime:create(0.02)
            )))
        end
        return transformUpdated
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    --设置吞噬事件为true，房子按键事件穿透到下层
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(touchBegin, cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(touchMove, cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(touchEnd, cc.Handler.EVENT_TOUCH_ENDED )
    self.listener = listener
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self._rootNode)
    
    
end

-- 结束时调用
function RubCardLayer:endfunc()
    --print('结束动画')
    self:stopAllActions()
end

-- 创建搓牌所用对象
function RubCardLayer:createSprites(szBack, szFont)
    -- 扑克牌背面图片
    local backSprite = cc.Sprite:create(szBack)
    local pokerSize = backSprite:getContentSize()
    local id1 = backSprite:getTexture():getName()          --纹理ID
    -- backSprite:retain()
    self.backFrameSprite = backSprite

    -- 扑克牌正面图片
    local frontSprite = cc.Sprite:create(szFont)
    local id2 = frontSprite:getTexture():getName()          --纹理ID
    -- frontSprite:setVisible(false)
    -- frontSprite:retain()
    self.frontFrameSprite = frontSprite

    local sz1 = {pokerSize.width, pokerSize.height}
    self.sz1 = sz1

    self.ratioVal = 0
    self.radiusVal = sz1[2] * self.scale / 10 

    self.pokerWidth = sz1[1] * self.scale
    self.pokerHeight = sz1[2] * self.scale

    self.offx = self.posX - self.sz1[1] / 2 * self.scale
    self.offy = self.posY - self.sz1[2] / 2 * self.scale

    local msh1, nVerts1 = self:__initCardVertex(cc.size(sz1[1] * self.scale, sz1[2] * self.scale), true)
    local msh2, nVerts2 = self:__initCardVertex(cc.size(sz1[1] * self.scale, sz1[2] * self.scale), false)

    -- 牌的渲染信息 (上下)
    local cardMesh = {{id1, msh1, nVerts1},{id2, msh2, nVerts2}}
    self.cardMesh = cardMesh

    local lf_msh1, lf_nVerts1 = self:__initCardVertex_lr(cc.size(sz1[1] * self.scale, sz1[2] * self.scale), true)
    local lf_msh2, lf_nVerts2 = self:__initCardVertex_lr(cc.size(sz1[1] * self.scale, sz1[2] * self.scale), false)
    -- 牌的渲染信息(左右)
    local lf_cardMesh = {{id1, lf_msh1, lf_nVerts1},{id2, lf_msh2, lf_nVerts2} }
    self.cardMesh_lf = lf_cardMesh
end

-- 计算上下
function RubCardLayer:__initCardVertex(size, isBack)
    local nDiv = 40                 --将宽分成100份
    
    local verts = {}                --位置坐标
    local texs = {}                 --纹理坐标
    local dh = size.height/nDiv
    local dw = size.width

    -- 计算顶点位置
    for c = 1, nDiv do
        local x, y = 0, (c-1)*dh
        local quad = {}
        if isBack then
            quad = {x, y, x+dw, y, x, y+dh, x+dw, y, x+dw, y+dh, x, y+dh}
        else
            quad = {x, y, x, y+dh, x+dw, y, x+dw, y, x, y+dh, x+dw, y+dh}
        end
        for _, v in ipairs(quad) do table.insert(verts, v) end
    end

    local bXTex = true
    for _, v in ipairs(verts) do
        if bXTex then
            table.insert(texs, v/size.width)
        else
            table.insert(texs, v/size.height)
        end
        bXTex = not bXTex
    end

    local res = {}
    local tmp = {verts, texs}
    for _, v in ipairs(tmp) do 
        local buffid = gl.createBuffer()
        gl.bindBuffer(gl.ARRAY_BUFFER, buffid)
        gl.bufferData(gl.ARRAY_BUFFER, table.getn(v), v, gl.STATIC_DRAW)
        gl.bindBuffer(gl.ARRAY_BUFFER, 0)
        table.insert(res, buffid)
    end
    return res, #verts
end

-- 计算左右
function RubCardLayer:__initCardVertex_lr(size, isBack)
    local nDiv = 40                 --将高分成100份
    
    local verts = {} --位置坐标
    local texs = {} --纹理坐标
    local dh = size.height
    local dw = size.width/nDiv

    --计算顶点位置
    for c = 1, nDiv do 
        local x, y = (c-1)*dw, 0
        local quad = {}
        if isBack then
            quad = {x, y, x+dw, y, x, y+dh, x+dw, y, x+dw, y+dh, x, y+dh}
        else
            quad = {x, y, x, y+dh, x+dw, y, x+dw, y, x, y+dh, x+dw, y+dh}
        end
        for _, v in ipairs(quad) do table.insert(verts, v) end
    end

    local bXTex = true
    for _, v in ipairs(verts) do
        if bXTex then
            table.insert(texs, v/size.width)
        else
            table.insert(texs, v/size.height)
        end
        bXTex = not bXTex
    end

    local res = {}
    local tmp = {verts, texs}
    for _, v in ipairs(tmp) do 
        local buffid = gl.createBuffer()
        gl.bindBuffer(gl.ARRAY_BUFFER, buffid)
        gl.bufferData(gl.ARRAY_BUFFER, table.getn(v), v, gl.STATIC_DRAW)
        gl.bindBuffer(gl.ARRAY_BUFFER, 0)
        table.insert(res, buffid)
    end
    return res, #verts
end

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- OpenGL绘制函数
function RubCardLayer:__drawByMoveProgram(rotation)
    gl.enable(gl.CULL_FACE)

    local cardMesh = self.cardMesh
    local glProgram = self.moveGlProgramDown

    if self.direction == direction.up then
        glProgram = self.moveGlProgramUp

    elseif self.direction == direction.left then
        cardMesh = self.cardMesh_lf
        glProgram = self.moveGlProgramLeft

    elseif self.direction == direction.right then
        cardMesh = self.cardMesh_lf
        glProgram = self.moveGlProgramRight
    end

    glProgram:use()
    glProgram:setUniformsForBuiltins()

    for index, _cardMesh in ipairs(cardMesh) do
        gl._bindTexture(gl.TEXTURE_2D, _cardMesh[1])

        -- 比例
        local ratio = gl.getUniformLocation(glProgram:getProgram(), "ratio")
        glProgram:setUniformLocationF32(ratio, self.ratioVal)
        -- 半径
        local radius = gl.getUniformLocation(glProgram:getProgram(), "radius")
        glProgram:setUniformLocationF32(radius, self.radiusVal)
        -- 宽度
        local width = gl.getUniformLocation(glProgram:getProgram(), "width")
        glProgram:setUniformLocationF32(width, self.sz1[1]*self.scale)
        -- 高度
        local height = gl.getUniformLocation(glProgram:getProgram(), "height")
        glProgram:setUniformLocationF32(height, self.sz1[2]*self.scale)
        -- X轴偏移量
        local offx = gl.getUniformLocation(glProgram:getProgram(), "offx")
        glProgram:setUniformLocationF32(offx, self.offx)
        -- Y轴偏移量
        local offy = gl.getUniformLocation(glProgram:getProgram(), "offy")
        glProgram:setUniformLocationF32(offy, self.offy)
        -- 旋转
        local rotationLc = gl.getUniformLocation(glProgram:getProgram(), "rotation")
        glProgram:setUniformLocationF32(rotationLc, rotation)

        self:__drawArrays(_cardMesh)
    end

    gl.disable(gl.CULL_FACE)
end

function RubCardLayer:__drawBySmoothProgram(rotation)
    local glProgram = self.smoothGlProgram

    local _cardMesh = self.cardMesh[2]
    if direction.left == self.direction or direction.right == self.direction then
        _cardMesh = self.cardMesh_lf[2]
        glProgram = self.smoothGlProgramLR
    end

    glProgram:use()
    glProgram:setUniformsForBuiltins()

    gl._bindTexture(gl.TEXTURE_2D, _cardMesh[1])

    -- 旋转
    local rotationLc = gl.getUniformLocation(glProgram:getProgram(), "rotation")
    glProgram:setUniformLocationF32(rotationLc, rotation)
    -- X轴偏移量
    local offx = gl.getUniformLocation(glProgram:getProgram(), "offx")
    glProgram:setUniformLocationF32(offx, self.offx)
    -- Y轴偏移量
    local offy = gl.getUniformLocation(glProgram:getProgram(), "offy")
    glProgram:setUniformLocationF32(offy, self.offy)
    -- 宽度
    local width = gl.getUniformLocation(glProgram:getProgram(), "width")
    glProgram:setUniformLocationF32(width, self.sz1[1]*self.scale)
    -- 高度
    local height = gl.getUniformLocation(glProgram:getProgram(), "height")
    glProgram:setUniformLocationF32(height, self.sz1[2]*self.scale)

    self:__drawArrays(_cardMesh)
end

function RubCardLayer:__drawByEndProgram()
    local glProgram = self.endGlProgram

    local _cardMesh = self.cardMesh[2]
    if direction.left == self.direction or direction.right == self.direction then
        _cardMesh = self.cardMesh_lf[2]
        glProgram = self.endGlProgramLR
    end

    glProgram:use()
    glProgram:setUniformsForBuiltins()

    gl._bindTexture(gl.TEXTURE_2D, _cardMesh[1])

    -- X轴偏移量
    local offx = gl.getUniformLocation(glProgram:getProgram(), "offx")
    glProgram:setUniformLocationF32(offx, self.offx)
    -- Y轴偏移量
    local offy = gl.getUniformLocation(glProgram:getProgram(), "offy")
    glProgram:setUniformLocationF32(offy, self.offy)
    -- 宽度
    local width = gl.getUniformLocation(glProgram:getProgram(), "width")
    glProgram:setUniformLocationF32(width, self.sz1[1]*self.scale)
    -- 高度
    local height = gl.getUniformLocation(glProgram:getProgram(), "height")
    glProgram:setUniformLocationF32(height, self.sz1[2]*self.scale)

    self:__drawArrays(_cardMesh)
end

function RubCardLayer:__drawArrays(cardMesh)
    gl.glEnableVertexAttribs(bit:_or(cc.VERTEX_ATTRIB_FLAG_TEX_COORDS, cc.VERTEX_ATTRIB_FLAG_POSITION))
    gl.bindBuffer(gl.ARRAY_BUFFER, cardMesh[2][1])

    gl.vertexAttribPointer(cc.VERTEX_ATTRIB_POSITION, 2, gl.FLOAT, false, 0, 0)
    gl.bindBuffer(gl.ARRAY_BUFFER, cardMesh[2][2])

    gl.vertexAttribPointer(cc.VERTEX_ATTRIB_TEX_COORD, 2, gl.FLOAT, false, 0, 0)
    gl.drawArrays(gl.TRIANGLES, 0, cardMesh[3])

    gl.bindBuffer(gl.ARRAY_BUFFER, 0)
end

function RubCardLayer:remove()
    self.glNode:setVisible(false)
    if self.listener then
        local eventDispatcher = self:getEventDispatcher()
        eventDispatcher:removeEventListener(self.listener)
        self.listener = nil
    end
    print("self.strdian"..self.strdian)
    --self._rootNode =  cc.Node:create()
    local str=cc.Sprite:create(self.strdian)
    str:setPosition(display.width/2,display.height/2)
    self._rootNode:addChild(str,5)
    --self.frontFrameSprite:setTexture(self.strdian)
    local function callBack()
        self.endCallBack()
        self:removeFromParent()
    end
    local callFunc = cc.CallFunc:create(callBack)
    local delay = cc.DelayTime:create(1.20)
    local sequence = cc.Sequence:create(delay, callFunc)
    self:runAction(cc.RepeatForever:create(sequence))
end

return RubCardLayer
