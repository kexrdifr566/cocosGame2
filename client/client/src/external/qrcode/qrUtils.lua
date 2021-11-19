local qrencode = appdf.req(appdf.EXTERNAL_SRC .. 'qrcode.qrencode')
local bmp = appdf.req(appdf.EXTERNAL_SRC .. 'qrcode.bmp')

local imgName = "qrImageForShare.png"
local imgPath = device.writablePath

-- test:
-- local ok , tab_or_message = qrencode.qrcode("http://www.google.com")
-- if not ok then 
--         print(tab_or_message)
-- else
--     img_file = io.open('test.bmp','wb')
--     img_file:write(bmp(tab_or_message,250))
--     img_file:close()
-- end

local  QRUtils = class("QRUtils")

--@contents : contents to generate qrcode
--@imgSize :  the height or width  of image
--if success , return true , and image path(with image file name) 
--if fail , return false, and nil
function QRUtils:GenerateBMP(gurl,imgSize)
    if not gurl then
        return false,nil
    end
    local imagesize = 200
    if imgSize and imgSize > 0 then
        imagesize = imgSize
    end

    local _ret,_msg = os.remove(imgPath .. imgName)

    local ok,table_or_message = qrencode.qrcode(gurl)
    if not ok then
        print("generate image failed. error: " .. tostring(table_or_message))
        return false,nil
    else
        local img_file = io.open(imgPath .. imgName,'wb')
        img_file:write(bmp(table_or_message,imagesize))
        img_file:close()
        return true,imgPath .. imgName
    end

end


return QRUtils


--[[
    usage:

    local qrUtils = appdf.req(appdf.EXTERNAL_SRC .. '.qrcode.qrUtils')
    local isSuccess, imgPath = qrUtils.GenerateBMP('http://url',250)
]]