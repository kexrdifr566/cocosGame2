#include <memory>

#include <android/log.h>
#include <jni.h>

#include "AppDelegate.h"
#include "runtime/ConfigParser.h"

#define  LOG_TAG    "main"
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)

namespace {
std::unique_ptr<AppDelegate> appDelegate;
}

void cocos_android_app_init(JNIEnv* env) {
    LOGD("cocos_android_app_init");
    appDelegate.reset(new AppDelegate());
}

extern "C"
{
bool Java_org_cocos2dx_lua_AppActivity_nativeIsLandScape(JNIEnv *env, jobject thisz)
{
    return ConfigParser::getInstance()->isLanscape();
}

bool Java_org_cocos2dx_lua_AppActivity_nativeIsDebug(JNIEnv *env, jobject thisz)
{
#if (COCOS2D_DEBUG > 0) && (CC_CODE_IDE_DEBUG_SUPPORT > 0)
    return true;
#else
    return false;
#endif
}
}