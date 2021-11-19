LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := bugly_native_prebuilt
LOCAL_SRC_FILES := ../../../prebuilt/android/$(TARGET_ARCH_ABI)/libBugly.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libmp3lame
LOCAL_SRC_FILES := ../../../prebuilt/android/armeabi/libmp3lame.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE := cocos2dlua_shared

LOCAL_MODULE_FILENAME := libmmyx_qp

LOCAL_SRC_FILES := \
../../../Classes/AppDelegate.cpp \
../../../Classes/ClientKernel.cpp \
../../../Classes/cjson/strbuf.c \
../../../Classes/cjson/fpconv.c \
../../../Classes/cjson/lua_cjson.c \
../../../Classes/cjson/lua_extensions.c \
../../../Classes/LuaAssert/CMD_Data.cpp \
../../../Classes/LuaAssert/LuaAssert.cpp \
../../../Classes/LuaAssert/ry_MD5.cpp \
../../../Classes/LuaAssert/ImageToByte.cpp \
../../../Classes/LuaAssert/ClientSocket.cpp \
../../../Classes/LuaAssert/DownAsset.cpp \
../../../Classes/LuaAssert/UnZipAsset.cpp \
../../../Classes/LuaAssert/CurlAsset.cpp \
../../../Classes/LuaAssert/LogAsset.cpp \
../../../Classes/LuaAssert/CircleBy.cpp \
../../../Classes/LuaAssert/QR_Encode.cpp \
../../../Classes/LuaAssert/QrNode.cpp \
../../../Classes/LuaAssert/AESEncrypt.cpp \
../../../Classes/LuaAssert/AudioRecorder/AudioRecorder.cpp \
../../../Classes/LuaAssert/MobileClientKernel/Cipher.cpp \
../../../Classes/LuaAssert/MobileClientKernel/MCKernel.cpp \
../../../Classes/LuaAssert/MobileClientKernel/MobileClientKernel.cpp \
../../../Classes/LuaAssert/MobileClientKernel/SocketService.cpp \
../../../Classes/LuaAssert/MobileClientKernel/TCPSocket.cpp \
../../../../cocos2d-x/external/lua/lpack/lpack.c \
hellolua/main.cpp \

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../Classes \
					$(LOCAL_PATH)/../../../Classes/cjson \
					$(LOCAL_PATH)/../../../Classes/GlobalDefine \
					$(LOCAL_PATH)/../../../Classes/LuaAssert \
					$(LOCAL_PATH)/../../../Classes/LuaAssert/MobileClientKernel \
					$(LOCAL_PATH)/../../../../cocos2d-x/external/lua \
					$(LOCAL_PATH)/../../../../cocos2d-x/external/lua/lpack \
					$(LOCAL_PATH)/../../../../cocos2d-x/external/libiconv/include \

# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END

LOCAL_STATIC_LIBRARIES := cocos2d_lua_static
LOCAL_STATIC_LIBRARIES += cocos_curl_static
LOCAL_STATIC_LIBRARIES += cocos2d_simulator_static
LOCAL_STATIC_LIBRARIES += bugly_crashreport_cocos_static
LOCAL_STATIC_LIBRARIES += bugly_agent_cocos_static_lua
LOCAL_STATIC_LIBRARIES += libiconv_static
LOCAL_WHOLE_STATIC_LIBRARIES += android_support

# _COCOS_LIB_ANDROID_BEGIN
# _COCOS_LIB_ANDROID_END

include $(BUILD_SHARED_LIBRARY)

$(call import-module,curl/prebuilt/android)
$(call import-module,scripting/lua-bindings/proj.android)
$(call import-module,tools/simulator/libsimulator/proj.android)
$(call import-module,android/support)
$(call import-module,external/libiconv)
$(call import-module,external/bugly)
$(call import-module,external/bugly/lua)

# _COCOS_LIB_IMPORT_ANDROID_BEGIN
# _COCOS_LIB_IMPORT_ANDROID_END
