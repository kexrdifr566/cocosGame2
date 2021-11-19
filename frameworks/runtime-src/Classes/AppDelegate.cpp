#include "AppDelegate.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "cocos2d.h"
#include "lua_module_register.h"
#include "lua_extensions.h"
#include "FileAsset.h"
#include "LuaAssert/MobileClientKernel/MobileClientKernel.h"
#include "LuaAssert/CurlAsset.h"
#include "LuaAssert/LogAsset.h"
#include "LuaAssert/CircleBy.h"
#include "LuaAssert/QrNode.h"
#include "LuaAssert/AESEncrypt.h"
#include "LuaAssert/AudioRecorder/AudioRecorder.h"

#define USE_AUDIO_ENGINE 1
//#define USE_SIMPLE_AUDIO_ENGINE 1

#if USE_AUDIO_ENGINE && USE_SIMPLE_AUDIO_ENGINE
#error "Don't use AudioEngine and SimpleAudioEngine at the same time. Please just select one in your game!"
#endif

#if USE_AUDIO_ENGINE
#include "audio/include/AudioEngine.h"
using namespace cocos2d::experimental;
#elif USE_SIMPLE_AUDIO_ENGINE
#include "audio/include/SimpleAudioEngine.h"
using namespace CocosDenshion;
#endif

#if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 

#elif  CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
#include "platform/android/jni/JniHelper.h"
#include "bugly/CrashReport.h"
#include "bugly/lua/BuglyLuaAgent.h"
#include "SimpleAudioEngine.h"
using namespace CocosDenshion;
#elif CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_MAC
#include "CrashReport.h"
#include "BuglyLuaAgent.h"
#endif

#include "ClientKernel.h"
#include "ImageToByte.h"
#include "LuaAssert.h"
#include "ClientSocket.h"
#include "Integer64.h"
#include "CMD_Data.h"
#include "ry_MD5.h"
#include "UnZipAsset.h"
#include "DownAsset.h"

USING_NS_CC;
using namespace std;

#define SCHEDULE CCDirector::sharedDirector()->getScheduler()

AppDelegate* AppDelegate::m_instance = NULL;

AppDelegate::AppDelegate()
{
	m_instance = this;
	m_pClientKernel = new CClientKernel();
	m_ImageToByte = new CImageToByte();
	m_BackgroundCallBack = 0;
}

AppDelegate::~AppDelegate()
{
#if USE_AUDIO_ENGINE
	AudioEngine::end();
#elif USE_SIMPLE_AUDIO_ENGINE
	SimpleAudioEngine::end();
#endif
	CC_SAFE_DELETE(m_pClientKernel);
	CC_SAFE_DELETE(m_ImageToByte);

#if (COCOS2D_DEBUG > 0) && (CC_CODE_IDE_DEBUG_SUPPORT > 0)
	// NOTE:Please don't remove this call if you want to debug with Cocos Code IDE
	RuntimeEngine::getInstance()->end();
#endif

}

// if you want a different context, modify the value of glContextAttrs
// it will affect all platforms
void AppDelegate::initGLContextAttrs()
{
	// set OpenGL context attributes: red,green,blue,alpha,depth,stencil
	GLContextAttrs glContextAttrs = { 8, 8, 8, 8, 24, 8 };

	GLView::setGLContextAttrs(glContextAttrs);
}

static int toLua_AppDelegate_MD5(lua_State* tolua_S)
{
	int argc = lua_gettop(tolua_S);
	if (argc == 1)
	{
		const char* szData = lua_tostring(tolua_S, 1);
		if (EMPTY_CHAR(szData) == false)
		{
			string md5pass = md5(szData);
			lua_pushstring(tolua_S, md5pass.c_str());
			return 1;
		}
	}
	return 0;
}

static int toLua_AppDelegate_LoadImageByte(lua_State* tolua_S)
{
	bool result = false;
	int argc = lua_gettop(tolua_S);
	if (argc == 1)
	{
		const char* szData = lua_tostring(tolua_S, 1);
		if (EMPTY_CHAR(szData) == false)
		{
			CImageToByte* help = (CImageToByte*)AppDelegate::getAppInstance()->m_ImageToByte;
			if (help)
				result = help->onLoadData(szData);
		}
	}
	lua_pushboolean(tolua_S, result ? 1 : 0);
	return 1;
}

static int toLua_AppDelegate_CleanImageByte(lua_State* tolua_S)
{
	CImageToByte* help = (CImageToByte*)AppDelegate::getAppInstance()->m_ImageToByte;
	if (help)
		help->onCleanData();
	return 0;
}

static int toLua_AppDelegate_checkData(lua_State* tolua_S)
{
	int argc = lua_gettop(tolua_S);
	if (argc == 2)
	{
		CImageToByte* help = (CImageToByte*)AppDelegate::getAppInstance()->m_ImageToByte;
		if (help)
		{
			int x = lua_tointeger(tolua_S, 1);
			int y = lua_tointeger(tolua_S, 2);
			unsigned int data = help->getData(x, y);
			int r = data & 0xff;
			int g = (data >> 8) & 0xff;
			int b = (data >> 16) & 0xff;
			int a = (data >> 24) & 0xff;
			lua_pushinteger(tolua_S, r);
			lua_pushinteger(tolua_S, g);
			lua_pushinteger(tolua_S, b);
			lua_pushinteger(tolua_S, a);
		}
		return 4;
	}
	return 0;
}

static int toLua_AppDelegate_SaveByEncrypt(lua_State* tolua_S)
{
	int argc = lua_gettop(tolua_S);
	if (argc == 3)
	{
		const char* filename = lua_tostring(tolua_S, 1);
		const char* szKey = lua_tostring(tolua_S, 2);
		const char* szData = lua_tostring(tolua_S, 3);

		std::string filePath = FileUtils::getInstance()->getWritablePath();
		std::string sp = "";
		if (filePath[filePath.length() - 1] == '/')
		{
			sp = "";
		}
		else
		{
			sp = '/';
		}
		filePath = FileUtils::getInstance()->fullPathForFilename(filePath + sp + filename);
		CCLOG("save_path:%s", filePath.c_str());
		ValueMap valueMap = FileUtils::getInstance()->getValueMapFromFile(filePath);
		ValueVector dataArray;
		int len = strlen(szData);
		if (len > 0)
		{

			char *pData = new char[len + 4];
			memset(pData, 0, len + 4);
			memcpy(pData + 4, szData, len);
			//CCipher::encryptBuffer(pData,len+4);
			for (int i = 0; i < len + 4; i++)
			{
				int tmp = pData[i];
				dataArray.push_back(Value(tmp));
			}
			CC_SAFE_DELETE(pData);
		}
		valueMap[szKey] = Value(dataArray);
		FileUtils::getInstance()->writeToFile(valueMap, filePath);
	}
	return 0;
}

static int toLua_AppDelegate_ReadByDecrypt(lua_State* tolua_S)
{
	int argc = lua_gettop(tolua_S);
	if (argc == 2)
	{
		const char* filename = lua_tostring(tolua_S, 1);
		const char* szKey = lua_tostring(tolua_S, 2);
		std::string filePath = FileUtils::getInstance()->getWritablePath();
		std::string sp = "";
		if (filePath[filePath.length() - 1] == '/')
		{
			sp = "";
		}
		else
		{
			sp = '/';
		}
		filePath = FileUtils::getInstance()->fullPathForFilename(filePath + sp + filename);
		ValueMap valueMap = FileUtils::getInstance()->getValueMapFromFile(filePath);
		if (valueMap[szKey].isNull())
		{
			lua_pushstring(tolua_S, "");
		}
		else
		{
			ValueVector& dataArray = valueMap[szKey].asValueVector();
			int len = dataArray.size();
			if (len == 0)
			{
				lua_pushstring(tolua_S, "");
			}
			else
			{
				BYTE *pData = new BYTE[len + 1];
				memset(pData, 0, len + 1);
				for (int i = 0; i < len; i++)
				{
					pData[i] = dataArray.at(i).asByte();
				}
				//CCipher::decryptBuffer(pData,len);
				lua_pushstring(tolua_S, (char*)(pData + 4));
				CC_SAFE_DELETE(pData);
			}
		}
		return 1;
	}
	return 0;
}

static int toLua_AppDelegate_downFileAsync(lua_State* tolua_S)
{

	int argc = lua_gettop(tolua_S);
	if (argc == 4)
	{

		const char* szUrl = lua_tostring(tolua_S, 1);
		const char* szSaveName = lua_tostring(tolua_S, 2);
		const char* szSavePath = lua_tostring(tolua_S, 3);
		int handler = toluafix_ref_function(tolua_S, 4, 0);
		if (handler != 0)
		{
			CDownAsset::DownFile(szUrl, szSaveName, szSavePath, handler);
			lua_pushboolean(tolua_S, 1);
			return 1;
		}
		else
		{
			CCLOG("toLua_AppDelegate_setHttpDownCallback hadler or listener is null");
		}
	}
	else
	{
		CCLOG("toLua_AppDelegate_setHttpDownCallback arg error now is %d", argc);
	}

	return 0;
}

static int toLua_AppDelegate_unZipAsync(lua_State* tolua_S)
{
	int argc = lua_gettop(tolua_S);
	if (argc == 3)
	{
		const char* file = lua_tostring(tolua_S, 1);
		const char* path = lua_tostring(tolua_S, 2);
		int handler = toluafix_ref_function(tolua_S, 3, 0);
		if (handler != 0)
		{
			CUnZipAsset::UnZipFile(file, path, handler);
			lua_pushboolean(tolua_S, 1);
			return 1;
		}
		else{
			if (handler == NULL)
				CCLOG("toLua_AppDelegate_unZipAsync error handler is null");
		}
	}
	else{
		CCLOG("toLua_AppDelegate_unZipAsync error argc is %d", argc);
	}
	return 0;
}

static int toLua_AppDelegate_setbackgroundcallback(lua_State* tolua_S)
{
	int argc = lua_gettop(tolua_S);
	if (argc == 1)
	{
		int handler = toluafix_ref_function(tolua_S, 1, 0);

		if (handler != 0)
		{
			AppDelegate::getAppInstance()->setBackgroundListener(handler);
			lua_pushboolean(tolua_S, 1);
			return 1;
		}

	}
	return 0;
}
static int toLua_AppDelegate_removebackgroundcallback(lua_State* tolua_S)
{
	AppDelegate::getAppInstance()->setBackgroundListener(0);
	return 0;
}

static int toLua_AppDelegate_onUpDateBaseApp(lua_State* tolua_S)
{
	const char* path = lua_tostring(tolua_S, 1);
	if (path != NULL)
	{
#if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 
		WCHAR wszClassName[256] = {};
		MultiByteToWideChar(CP_ACP, 0, path, strlen(path) + 1, wszClassName, sizeof(wszClassName) / sizeof(wszClassName[0]));
		ShellExecute(NULL, L"open", L"explorer.exe", wszClassName, NULL, SW_SHOW);
#endif
		lua_pushboolean(tolua_S, 1);
		return 1;
	}
	return 0;
}

static int toLua_AppDelegate_createDirectory(lua_State* tolua_S)
{

	const char* path = lua_tostring(tolua_S, 1);
	if (path != NULL)
	{
		bool result = createDirectory(path);
		lua_pushboolean(tolua_S, result ? 1 : 0);
		return 1;
	}

	return 0;
}

static int toLua_AppDelegate_removeDirectory(lua_State* tolua_S)
{
	const char* path = lua_tostring(tolua_S, 1);
	if (path != NULL)
	{
		bool result = removeDirectory(path);
		lua_pushboolean(tolua_S, result ? 1 : 0);
		return 1;
	}

	return 0;
}

static unsigned char* getBMPFileData(const std::string &path, bool &haveData)
{
	haveData = false;
	//文件判断
	if (!FileUtils::getInstance()->isFileExist(path))
	{
		log("%s not exist!", path.c_str());
		return nullptr;
	}
	Data tmp = FileUtils::getInstance()->getDataFromFile(path);
	unsigned char* pBmpData = tmp.getBytes();
	//文件长度判断
	if (tmp.getSize() < 2)
	{
		log("%s not exist!", path.c_str());
		return nullptr;
	}
	//bmp格式判断
	static const unsigned char BMP[] = { 0X42, 0X4d };
	if (memcmp(BMP, pBmpData, sizeof(BMP)) != 0)
	{
		log("%s is not .bmp type file!", path.c_str());
		return nullptr;
	}

	unsigned char *bytecs = new unsigned char[96 * 96 * 4 + 1];
	int idx1 = 0;
	int idx2 = 0;
	for (int i = 0; i < 96; ++i)
	{
		for (int j = 0; j < 96; ++j)
		{
			idx1 = ((95 - i) * 96 + j) * 4;
			idx2 = (i * 96 + j) * 4;
			bytecs[idx1] = pBmpData[54 + idx2 + 2];          //R
			bytecs[idx1 + 1] = pBmpData[54 + idx2 + 1];      //G
			bytecs[idx1 + 2] = pBmpData[54 + idx2];          //B
			bytecs[idx1 + 3] = 0xff;                         //A
		}
	}
	haveData = true;
	return bytecs;
}

static int toLua_AppDelegate_createSpriteByBMPFile(lua_State* tolua_S)
{
	const char* path = lua_tostring(tolua_S, 1);

	cocos2d::Texture2D* tex = nullptr;
	bool bInit = false;
	//判断是否存在纹理缓存
	auto it = AppDelegate::getAppInstance()->m_cachedBmpTex.find(path);
	if (it != AppDelegate::getAppInstance()->m_cachedBmpTex.end())
	{
		tex = it->second;
		bInit = true;
	}
	else
	{
		bool bHave = false;
		unsigned char *data = getBMPFileData(path, bHave);
		if (nullptr == data || false == bHave)
		{
			object_to_luaval<cocos2d::Sprite>(tolua_S, "cc.Sprite", nullptr);
			CC_SAFE_DELETE_ARRAY(data);
			return 1;
		}

		tex = new Texture2D();
		bInit = tex->initWithData(data, 96 * 96 * 4, Texture2D::PixelFormat::RGBA8888, 96, 96, cocos2d::Size(96, 96));
		if (bInit)
		{
			//缓存纹理
			AppDelegate::getAppInstance()->m_cachedBmpTex.insert(std::make_pair(path, tex));
		}
		CC_SAFE_DELETE_ARRAY(data);
	}
	if (nullptr != tex && true == bInit)
	{
		//创建
		cocos2d::Sprite* ret = cocos2d::Sprite::createWithTexture(tex);
		object_to_luaval<cocos2d::Sprite>(tolua_S, "cc.Sprite", (cocos2d::Sprite*)ret);
	}
	else
	{
		log("init texture error");
		object_to_luaval<cocos2d::Sprite>(tolua_S, "cc.Sprite", nullptr);
		CC_SAFE_DELETE(tex);
	}
	return 1;
}

static int toLua_AppDelegate_createSpriteFrameByBMPFile(lua_State* tolua_S)
{
	const char* path = lua_tostring(tolua_S, 1);

	cocos2d::Texture2D* tex = nullptr;
	bool bInit = false;
	//判断是否存在纹理缓存
	auto it = AppDelegate::getAppInstance()->m_cachedBmpTex.find(path);
	if (it != AppDelegate::getAppInstance()->m_cachedBmpTex.end())
	{
		tex = it->second;
		bInit = true;
	}
	else
	{
		bool bHave = false;
		unsigned char *data = getBMPFileData(path, bHave);
		if (nullptr == data || false == bHave)
		{
			object_to_luaval<cocos2d::SpriteFrame>(tolua_S, "cc.SpriteFrame", nullptr);
			CC_SAFE_DELETE_ARRAY(data);
			return 1;
		}

		tex = new Texture2D();
		bInit = tex->initWithData(data, 96 * 96 * 4, Texture2D::PixelFormat::RGBA8888, 96, 96, cocos2d::Size(96, 96));
		if (bInit)
		{
			//缓存纹理
			AppDelegate::getAppInstance()->m_cachedBmpTex.insert(std::make_pair(path, tex));
		}
		CC_SAFE_DELETE_ARRAY(data);
	}
	if (nullptr != tex && true == bInit)
	{
		//创建
		cocos2d::SpriteFrame* ret = cocos2d::SpriteFrame::createWithTexture(tex, Rect(0, 0, 96, 96));
		object_to_luaval<cocos2d::SpriteFrame>(tolua_S, "cc.SpriteFrame", (cocos2d::SpriteFrame*)ret);
	}
	else
	{
		log("init texture error");
		object_to_luaval<cocos2d::SpriteFrame>(tolua_S, "cc.SpriteFrame", nullptr);
		CC_SAFE_DELETE(tex);
	}
	return 1;

}

static int toLua_AppDelegate_reSizeGivenFile(lua_State* tolua_S)
{
	auto argc = lua_gettop(tolua_S);
	if (argc == 4)
	{
		std::string path = lua_tostring(tolua_S, 1);
		std::string newpath = lua_tostring(tolua_S, 2);
		std::string notifyfun = lua_tostring(tolua_S, 3);
		if (FileUtils::getInstance()->isFileExist(path))
		{
			auto sp = Sprite::create(path);
			if (nullptr != sp)
			{
				int nSize = lua_tonumber(tolua_S, 4);
				auto size = sp->getContentSize();
				auto scale = nSize / size.width;
				sp->setScale(scale);
				sp->setAnchorPoint(Vec2(0.0f, 0.0f));

				auto render = RenderTexture::create(nSize, nSize);
				render->retain();
				render->beginWithClear(0, 0, 0, 0);
				sp->visit();
				render->end();
				Director::getInstance()->getRenderer()->render();
				render->saveToFile("tmp.png", true, [=](RenderTexture* render, const std::string& fullpath)
				{
					if (newpath != "")
					{
						Director::getInstance()->getTextureCache()->removeTextureForKey(path);
						FileUtils::getInstance()->renameFile(fullpath, newpath);

						lua_getglobal(tolua_S, notifyfun.c_str());
						if (!lua_isfunction(tolua_S, -1))
						{
							CCLOG("value at stack [%d] is not function", -1);
							lua_pop(tolua_S, 1);
						}
						else
						{
							lua_pushstring(tolua_S, fullpath.c_str());
							lua_pushstring(tolua_S, newpath.c_str());
							int iRet = lua_pcall(tolua_S, 2, 0, 0);
							if (iRet)
							{
								log("call lua fun error:%s", lua_tostring(tolua_S, -1));
								lua_pop(tolua_S, 1);
							}
						}
					}
					render->release();
				});
			}
		}

	}
	return 0;
}

static int toLua_AppDelegate_nativeMessageBox(lua_State* tolua_S)
{
	auto argc = lua_gettop(tolua_S);
	if (2 == argc)
	{
		std::string msg = lua_tostring(tolua_S, 1);
		std::string title = lua_tostring(tolua_S, 2);

		MessageBox(msg.c_str(), title.c_str());
	}
	return 1;
}

static int toLua_AppDelegate_nativeIsDebug(lua_State* tolua_S)
{
#if (COCOS2D_DEBUG > 0) && (CC_CODE_IDE_DEBUG_SUPPORT > 0)
	lua_pushboolean(tolua_S, 1);
#else
	lua_pushboolean(tolua_S, 0);
#endif
	return 1;
}

static int toLua_AppDelegate_containEmoji(lua_State* tolua_S)
{
	bool bContain = false;
	auto argc = lua_gettop(tolua_S);
	if (1 == argc)
	{
		std::string msg = lua_tostring(tolua_S, 1);
		std::u16string ut16;
		if (StringUtils::UTF8ToUTF16(msg, ut16))
		{
			if (false == ut16.empty())
			{
				size_t len = ut16.length();
				for (size_t i = 0; i < len; ++i)
				{
					char16_t hs = ut16[i];
					if (0xd800 <= hs && hs <= 0xdbff)
					{
						if (ut16.length() >(i + 1))
						{
							char16_t ls = ut16[i + 1];
							int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
							if (0x1d000 <= uc && uc <= 0x1f77f)
							{
								bContain = true;
								break;
							}
						}
					}
					else
					{
						if (0x2100 <= hs && hs <= 0x27ff)
						{
							bContain = true;
						}
						else if (0x2B05 <= hs && hs <= 0x2b07)
						{
							bContain = true;
						}
						else if (0x2934 <= hs && hs <= 0x2935)
						{
							bContain = true;
						}
						else if (0x3297 <= hs && hs <= 0x3299)
						{
							bContain = true;
						}
						else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
						{
							bContain = true;
						}
					}
				}
			}
		}
	}
	lua_pushboolean(tolua_S, bContain);
	return 1;
}

static int toLua_AppDelegate_convertToGraySprite(lua_State* tolua_S)
{
	bool bSuccess = false;
	auto argc = lua_gettop(tolua_S);
	if (1 == argc)
	{
		Sprite *sp = (Sprite*)tolua_tousertype(tolua_S, 1, nullptr);
		if (nullptr != sp)
		{
			const GLchar* pszFragSource =
				"#ifdef GL_ES \n \
								            precision mediump float; \n \
																		            #endif \n \
																															            uniform sampler2D u_texture; \n \
																																															            varying vec2 v_texCoord; \n \
																																																																		            varying vec4 v_fragmentColor; \n \
																																																																																								            void main(void) \n \
																																																																																																																	            { \n \
																																																																																																																																													            // Convert to greyscale using NTSC weightings \n \
																																																																																																																																																																												            vec4 col = texture2D(u_texture, v_texCoord); \n \
																																																																																																																																																																																																														            float grey = dot(col.rgb, vec3(0.299, 0.587, 0.114)); \n \
																																																																																																																																																																																																																																																			            gl_FragColor = vec4(grey, grey, grey, col.a); \n \
																																																																																																																																																																																																																																																																																											            }";
			GLProgram* pProgram = new GLProgram();
			pProgram->initWithByteArrays(ccPositionTextureColor_noMVP_vert, pszFragSource);
			sp->setGLProgram(pProgram);
			pProgram->release();

			sp->getGLProgram()->bindAttribLocation(GLProgram::ATTRIBUTE_NAME_POSITION, GLProgram::VERTEX_ATTRIB_POSITION);
			sp->getGLProgram()->bindAttribLocation(GLProgram::ATTRIBUTE_NAME_COLOR, GLProgram::VERTEX_ATTRIB_COLOR);
			sp->getGLProgram()->bindAttribLocation(GLProgram::ATTRIBUTE_NAME_TEX_COORD, GLProgram::VERTEX_ATTRIB_TEX_COORD);

			sp->getGLProgram()->link();
			sp->getGLProgram()->updateUniforms();
			bSuccess = true;
		}
	}
	lua_pushboolean(tolua_S, bSuccess);
	return 1;
}

static int toLua_AppDelegate_convertToNormalSprite(lua_State* tolua_S)
{
	bool bSuccess = false;
	auto argc = lua_gettop(tolua_S);
	if (1 == argc)
	{
		Sprite *sp = (Sprite*)tolua_tousertype(tolua_S, 1, nullptr);
		if (nullptr != sp)
		{
			const GLchar* pszFragSource =
				"#ifdef GL_ES \n \
								            precision mediump float; \n \
																		            #endif \n \
																															            uniform sampler2D u_texture; \n \
																																															            varying vec2 v_texCoord; \n \
																																																																		            varying vec4 v_fragmentColor; \n \
																																																																																								            void main(void) \n \
																																																																																																																	            { \n \
																																																																																																																																													            // Convert to greyscale using NTSC weightings \n \
																																																																																																																																																																												            vec4 col = texture2D(u_texture, v_texCoord); \n \
																																																																																																																																																																																																														            gl_FragColor = vec4(col.r, col.g, col.b, col.a); \n \
																																																																																																																																																																																																																																																			            }";
			GLProgram* pProgram = new GLProgram();
			pProgram->initWithByteArrays(ccPositionTextureColor_noMVP_vert, pszFragSource);
			sp->setGLProgram(pProgram);
			pProgram->release();

			sp->getGLProgram()->bindAttribLocation(GLProgram::ATTRIBUTE_NAME_POSITION, GLProgram::VERTEX_ATTRIB_POSITION);
			sp->getGLProgram()->bindAttribLocation(GLProgram::ATTRIBUTE_NAME_COLOR, GLProgram::VERTEX_ATTRIB_COLOR);
			sp->getGLProgram()->bindAttribLocation(GLProgram::ATTRIBUTE_NAME_TEX_COORD, GLProgram::VERTEX_ATTRIB_TEX_COORD);

			sp->getGLProgram()->link();
			sp->getGLProgram()->updateUniforms();
			bSuccess = true;
		}
	}
	lua_pushboolean(tolua_S, bSuccess);
	return 1;
}

static int toLua_AppDelegate_DeCode(lua_State* tolua_S)
{
	auto argc = lua_gettop(tolua_S);
	if (2 == argc)
	{
		const char* data = lua_tostring(tolua_S, 1);
		int buflen = lua_tointeger(tolua_S, 2);

		char* pInOutBuf = nullptr;              //初始化char*类型
		pInOutBuf = const_cast<char*>(data);

		int nowindex = 0;
		unsigned char tempkeyvalue = 0xAA;
		char tempvalue;

		while (nowindex < buflen)
		{
			tempvalue = pInOutBuf[nowindex];
			pInOutBuf[nowindex] = tempkeyvalue ^ (8 * pInOutBuf[nowindex] | ((unsigned char)pInOutBuf[nowindex] >> 5));
			++nowindex;
			tempkeyvalue = tempvalue;
		}

		lua_pushstring(tolua_S, pInOutBuf);
	}
	return 1;
}

static int toLua_AppDelegate_EnCode(lua_State* tolua_S)
{
	auto argc = lua_gettop(tolua_S);
	if (2 == argc)
	{
		const char* data = lua_tostring(tolua_S, 1);
		int buflen = lua_tointeger(tolua_S, 2);

		char* pInOutBuf = nullptr;              //初始化char*类型
		pInOutBuf = const_cast<char*>(data);

		auto R0 = pInOutBuf;
		int R1 = buflen;
		int R2 = 0xAA;
		int R3 = 0;
		unsigned char R4;

		while (R3 < R1)
		{
			R4 = R0[R3] & 0xFF;
			R2 ^= R4;
			R4 = (R2 >> 3) & 0xFF;
			R2 = R4 | (R2 << 5);
			R2 &= 0xFF;

			R0[R3++] = R2;
		}
		lua_pushstring(tolua_S, pInOutBuf);
	}
	return 1;
}

static unsigned int crc16(const char *pInputBuf, int buflen)
{
	const static short keyarray[] = {
		0, 0x1021, 0x2042, 0x3063, 0x4084, 0x50A5, 0x60C6
		, 0x70E7, 0x8108, 0x9129, 0xA14A, 0xB16B, 0xC18C, 0xD1AD
		, 0xE1CE, 0xF1EF, 0x1231, 0x210, 0x3273, 0x2252, 0x52B5
		, 0x4294, 0x72F7, 0x62D6, 0x9339, 0x8318, 0xB37B, 0xA35A
		, 0xD3BD, 0xC39C, 0xF3FF, 0xE3DE, 0x2462, 0x3443, 0x420
		, 0x1401, 0x64E6, 0x74C7, 0x44A4, 0x5485, 0xA56A, 0xB54B
		, 0x8528, 0x9509, 0xE5EE, 0xF5CF, 0xC5AC, 0xD58D, 0x3653
		, 0x2672, 0x1611, 0x630, 0x76D7, 0x66F6, 0x5695, 0x46B4
		, 0xB75B, 0xA77A, 0x9719, 0x8738, 0xF7DF, 0xE7FE, 0xD79D
		, 0xC7BC, 0x48C4, 0x58E5, 0x6886, 0x78A7, 0x840, 0x1861
		, 0x2802, 0x3823, 0xC9CC, 0xD9ED, 0xE98E, 0xF9AF, 0x8948
		, 0x9969, 0xA90A, 0xB92B, 0x5AF5, 0x4AD4, 0x7AB7, 0x6A96
		, 0x1A71, 0xA50, 0x3A33, 0x2A12, 0xDBFD, 0xCBDC, 0xFBBF
		, 0xEB9E, 0x9B79, 0x8B58, 0xBB3B, 0xAB1A, 0x6CA6, 0x7C87
		, 0x4CE4, 0x5CC5, 0x2C22, 0x3C03, 0xC60, 0x1C41, 0xEDAE
		, 0xFD8F, 0xCDEC, 0xDDCD, 0xAD2A, 0xBD0B, 0x8D68, 0x9D49
		, 0x7E97, 0x6EB6, 0x5ED5, 0x4EF4, 0x3E13, 0x2E32, 0x1E51
		, 0xE70, 0xFF9F, 0xEFBE, 0xDFDD, 0xCFFC, 0xBF1B, 0xAF3A
		, 0x9F59, 0x8F78, 0x9188, 0x81A9, 0xB1CA, 0xA1EB, 0xD10C
		, 0xC12D, 0xF14E, 0xE16F, 0x1080, 0xA1, 0x30C2, 0x20E3
		, 0x5004, 0x4025, 0x7046, 0x6067, 0x83B9, 0x9398, 0xA3FB
		, 0xB3DA, 0xC33D, 0xD31C, 0xE37F, 0xF35E, 0x2B1, 0x1290
		, 0x22F3, 0x32D2, 0x4235, 0x5214, 0x6277, 0x7256, 0xB5EA
		, 0xA5CB, 0x95A8, 0x8589, 0xF56E, 0xE54F, 0xD52C, 0xC50D
		, 0x34E2, 0x24C3, 0x14A0, 0x481, 0x7466, 0x6447, 0x5424
		, 0x4405, 0xA7DB, 0xB7FA, 0x8799, 0x97B8, 0xE75F, 0xF77E
		, 0xC71D, 0xD73C, 0x26D3, 0x36F2, 0x691, 0x16B0, 0x6657
		, 0x7676, 0x4615, 0x5634, 0xD94C, 0xC96D, 0xF90E, 0xE92F
		, 0x99C8, 0x89E9, 0xB98A, 0xA9AB, 0x5844, 0x4865, 0x7806
		, 0x6827, 0x18C0, 0x8E1, 0x3882, 0x28A3, 0xCB7D, 0xDB5C
		, 0xEB3F, 0xFB1E, 0x8BF9, 0x9BD8, 0xABBB, 0xBB9A, 0x4A75
		, 0x5A54, 0x6A37, 0x7A16, 0xAF1, 0x1AD0, 0x2AB3, 0x3A92
		, 0xFD2E, 0xED0F, 0xDD6C, 0xCD4D, 0xBDAA, 0xAD8B, 0x9DE8
		, 0x8DC9, 0x7C26, 0x6C07, 0x5C64, 0x4C45, 0x3CA2, 0x2C83
		, 0x1CE0, 0xCC1, 0xEF1F, 0xFF3E, 0xCF5D, 0xDF7C, 0xAF9B
		, 0xBFBA, 0x8FD9, 0x9FF8, 0x6E17, 0x7E36, 0x4E55, 0x5E74
		, 0x2E93, 0x3EB2, 0xED1, 0x1EF0
	};
	int R3 = 0;
	int nowindex = 0;
	int tempvalue;

	while (nowindex < buflen)
	{
		int R5 = pInputBuf[nowindex++] & 0xFF;
		R5 ^= (R3 >> 8);
		R5 = keyarray[R5] & 0xFFFF;

		R3 = R5 ^ (R3 << 8);
		R3 &= 0xFFFF;
		/*tempvalue = (unsigned char)pInputBuf[nowindex++];
		result = (keyarray[(2 * (tempvalue ^ (result >> 8))) & 0xFF] ^ (result << 8));*/
	}
	return R3;
}

static int toLua_AppDelegate_crc16Data(lua_State* tolua_S)
{
	auto argc = lua_gettop(tolua_S);
	if (2 == argc)
	{
		const char* data = lua_tostring(tolua_S, 1);
		int len = lua_tointeger(tolua_S, 2);
		int bufferlen = crc16(data, len);
		lua_pushinteger(tolua_S, bufferlen);
	}
	return 1;
}

#ifdef WIN32
static int win_gettimeofday(struct timeval * val, struct timezone *)
{
	if (val)
	{
		SYSTEMTIME wtm;
		GetLocalTime(&wtm);

		struct tm tTm;
		tTm.tm_year = wtm.wYear - 1900;
		tTm.tm_mon = wtm.wMonth - 1;
		tTm.tm_mday = wtm.wDay;
		tTm.tm_hour = wtm.wHour;
		tTm.tm_min = wtm.wMinute;
		tTm.tm_sec = wtm.wSecond;
		tTm.tm_isdst = -1;

		val->tv_sec = (long)mktime(&tTm);	   // time_t is 64-bit on win32
		val->tv_usec = wtm.wMilliseconds * 1000;
	}
	return 0;
}
#endif

static long long getCurrentTime()
{
	struct timeval tv;
#ifdef WIN32
	win_gettimeofday(&tv, NULL);
#else
	gettimeofday(&tv, NULL);
#endif 
	long long ms = tv.tv_sec;
	return ms * 1000 + tv.tv_usec / 1000;
}
static int toLua_AppDelegate_currentTime(lua_State* tolua_S)
{
	long long curtime = getCurrentTime();
#if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 
	//CCLOG("currentTime:%I64d",curtime);
#else
	//CCLOG("currentTime:%lld",curtime);
#endif
	lua_pushnumber(tolua_S, curtime);
	return 1;
}

// if you want to use the package manager to install more packages, 
// don't modify or remove this function
static int register_all_packages()
{
	lua_State* tolua_S = LuaEngine::getInstance()->getLuaStack()->getLuaState();
	luaopen_lua_extensions(tolua_S);

	register_all_cmd_data();
	register_all_Integer64();
	register_all_client_socket();
	register_all_curlasset();
	register_all_logasset();
	register_all_Circleasset();
	register_all_QrNode();
	register_all_AESEncrypt();
	register_all_recorder();

	lua_register(tolua_S, "checkData", toLua_AppDelegate_checkData);
	lua_register(tolua_S, "md5", toLua_AppDelegate_MD5);
	lua_register(tolua_S, "readByDecrypt", toLua_AppDelegate_ReadByDecrypt);
	lua_register(tolua_S, "saveByEncrypt", toLua_AppDelegate_SaveByEncrypt);
	lua_register(tolua_S, "loadImageByte", toLua_AppDelegate_LoadImageByte);
	lua_register(tolua_S, "cleanImageByte", toLua_AppDelegate_CleanImageByte);
	lua_register(tolua_S, "downFileAsync", toLua_AppDelegate_downFileAsync);
	lua_register(tolua_S, "unZipAsync", toLua_AppDelegate_unZipAsync);
	lua_register(tolua_S, "setbackgroundcallback", toLua_AppDelegate_setbackgroundcallback);
	lua_register(tolua_S, "removebackgroundcallback", toLua_AppDelegate_removebackgroundcallback);
	lua_register(tolua_S, "onUpDateBaseApp", toLua_AppDelegate_onUpDateBaseApp);
	lua_register(tolua_S, "createDirectory", toLua_AppDelegate_createDirectory);
	lua_register(tolua_S, "removeDirectory", toLua_AppDelegate_removeDirectory);
	lua_register(tolua_S, "currentTime", toLua_AppDelegate_currentTime);

	lua_register(tolua_S, "createSpriteWithBMPFile", toLua_AppDelegate_createSpriteByBMPFile);
	lua_register(tolua_S, "createSpriteFrameWithBMPFile", toLua_AppDelegate_createSpriteFrameByBMPFile);
	lua_register(tolua_S, "reSizeGivenFile", toLua_AppDelegate_reSizeGivenFile);
	lua_register(tolua_S, "nativeMessageBox", toLua_AppDelegate_nativeMessageBox);
	lua_register(tolua_S, "isDebug", toLua_AppDelegate_nativeIsDebug);
	lua_register(tolua_S, "containEmoji", toLua_AppDelegate_containEmoji);
	lua_register(tolua_S, "convertToGraySprite", toLua_AppDelegate_convertToGraySprite);
	lua_register(tolua_S, "convertToNormalSprite", toLua_AppDelegate_convertToNormalSprite);

	lua_register(tolua_S, "crc16Data", toLua_AppDelegate_crc16Data);
	lua_register(tolua_S, "DeCode", toLua_AppDelegate_DeCode);
	lua_register(tolua_S, "EnCode", toLua_AppDelegate_EnCode);
	return 0; //flag for packages manager
}

bool AppDelegate::applicationDidFinishLaunching()
{
	// set default FPS
	Director::getInstance()->setAnimationInterval(1.0 / 60.0f);

	auto listener = EventListenerCustom::create(EVENT_MESSAGEBOX_OK_CLICK, [](EventCustom *event)
	{
		__String *msg = (__String*)event->getUserData();
		if (0 == strcmp(msg->getCString(), "lua_src_error"))
		{
			cocos2d::log("lua_error");
			bool bHandle = false;
#if CC_ENABLE_SCRIPT_BINDING
			lua_State* tolua_S = LuaEngine::getInstance()->getLuaStack()->getLuaState();
			lua_getglobal(tolua_S, "g_LuaErrorHandle");
			if (lua_isfunction(tolua_S, -1))
			{
				int nRes = lua_pcall(tolua_S, 0, 1, 0);
				if (0 == nRes)
				{
					if (lua_isnumber(tolua_S, -1))
					{
						bHandle = lua_tointeger(tolua_S, -1) == 1;
					}
					else if (lua_isboolean(tolua_S, -1))
					{
						bHandle = lua_toboolean(tolua_S, -1);
					}
				}
			}
#endif
			if (false == bHandle)
			{
				Director::getInstance()->end();
			}
		}
	});
	Director::getInstance()->getEventDispatcher()->addEventListenerWithFixedPriority(listener, 1);
	// register lua module
	auto engine = LuaEngine::getInstance();

	auto isDebug = false;
#if (COCOS2D_DEBUG > 0) && (CC_CODE_IDE_DEBUG_SUPPORT > 0)
	isDebug = true;
#endif
	// Init the Bugly
#if CC_TARGET_PLATFORM != CC_PLATFORM_WIN32
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
	CrashReport::initCrashReport("a5f9bb958c", isDebug);
#elif CC_TARGET_PLATFORM == CC_PLATFORM_IOS
	CrashReport::initCrashReport("fb732f6832", isDebug);
#endif    
	BuglyLuaAgent::registerLuaExceptionHandler(engine);
#endif

	ScriptEngineManager::getInstance()->setScriptEngine(engine);
	lua_State* L = engine->getLuaStack()->getLuaState();
	lua_module_register(L);

	register_all_packages();

	Device::setKeepScreenOn(true);

	//if (((CClientKernel*)m_pClientKernel)->OnInit() == false)
	//{
	//	CCLOG("[_DEBUG]	ClientKernel_onInit_FALSE!");
	//	return false;
	//}



#if CC_64BITS
	//FileUtils::getInstance()->addSearchPath("src/64bit");
#endif
	//FileUtils::getInstance()->addSearchPath("src");
	//FileUtils::getInstance()->addSearchPath("res");

	
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32) //win开发环境,设置自己的路径
	FileUtils::getInstance()->addSearchPath("D:/git/cocosGame/client");
	FileUtils::getInstance()->addSearchPath("D:/git/cocosGame/client/base/");
	FileUtils::getInstance()->addSearchPath("D:/git/cocosGame/client/base/src");
	FileUtils::getInstance()->addSearchPath("D:/git/cocosGame/client/base/res");
	FileUtils::getInstance()->addSearchPath("D:/git/cocosGame/client/client/");
	FileUtils::getInstance()->addSearchPath("D:/git/cocosGame/client/client/src");
	FileUtils::getInstance()->addSearchPath("D:/git/cocosGame/client/client/res");

	if (engine->executeScriptFile("D:/git/cocosGame/client/base/src/main.lua"))
	{
		return false;
	}
#else	
	if (!FileUtils::getInstance()->isDirectoryExist(FileUtils::getInstance()->getWritablePath()+"base/"))
	{
		if(!CUnZipAsset::unzip(FileUtils::getInstance()->fullPathForFilename("base.zip").c_str(),FileUtils::getInstance()->getWritablePath().c_str(),NULL,true))
		{
			exit(0);
		}
	}
	if (!FileUtils::getInstance()->isDirectoryExist(FileUtils::getInstance()->getWritablePath() + "client/"))
	{
		if (!CUnZipAsset::unzip(FileUtils::getInstance()->fullPathForFilename("client.zip").c_str(), FileUtils::getInstance()->getWritablePath().c_str(), NULL, true))
		{
			exit(0);
		}
	}
	   FileUtils::getInstance()->addSearchPath(FileUtils::getInstance()->getWritablePath());
	   FileUtils::getInstance()->addSearchPath(FileUtils::getInstance()->getWritablePath()+"base/");
	   FileUtils::getInstance()->addSearchPath(FileUtils::getInstance()->getWritablePath()+"base/src");
	   FileUtils::getInstance()->addSearchPath(FileUtils::getInstance()->getWritablePath()+"base/res");
	FileUtils::getInstance()->addSearchPath(FileUtils::getInstance()->getWritablePath() + "client/");
	FileUtils::getInstance()->addSearchPath(FileUtils::getInstance()->getWritablePath() + "client/src");
	FileUtils::getInstance()->addSearchPath(FileUtils::getInstance()->getWritablePath() + "client/res");
	if (engine->executeScriptFile("base/src/main.lua"))
	{
		return false;
	}
#endif


	//IMCKernel *kernel = GetMCKernel();
	//if (kernel)
	//{
	//	kernel->SetLogOut((ILog*)((CClientKernel*)m_pClientKernel));
	//}
	//else{
	//	return false;
	//}
	SCHEDULE->schedule(schedule_selector(AppDelegate::GlobalUpdate), this, 0.1, kRepeatForever, 0, false);
	return true;
}

// This function will be called when the app is inactive. Note, when receiving a phone call it is invoked.
void AppDelegate::applicationDidEnterBackground()
{
	Director::getInstance()->stopAnimation();

#if USE_AUDIO_ENGINE
	AudioEngine::pauseAll();
#elif USE_SIMPLE_AUDIO_ENGINE
	SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
	SimpleAudioEngine::getInstance()->pauseAllEffects();
#endif

	if (m_BackgroundCallBack != 0)
	{
		lua_State* tolua_S = LuaEngine::getInstance()->getLuaStack()->getLuaState();
		toluafix_get_function_by_refid(tolua_S, m_BackgroundCallBack);
		if (lua_isfunction(tolua_S, -1))
		{
			lua_pushboolean(tolua_S, 0);
			LuaEngine::getInstance()->getLuaStack()->executeFunctionByHandler(m_BackgroundCallBack, 1) != 0;
		}
		else{
			CCLOG("applicationDidEnterBackground-luacallback-handler-false:%d", m_BackgroundCallBack);
		}
	}
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
	Director::getInstance()->startAnimation();
#if USE_AUDIO_ENGINE
	AudioEngine::resumeAll();
#elif USE_SIMPLE_AUDIO_ENGINE
	SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
	SimpleAudioEngine::getInstance()->resumeAllEffects();
#endif

	//处理缓存
	for (auto it = m_cachedBmpTex.cbegin(); it != m_cachedBmpTex.cend();)
	{
		Texture2D *tex = it->second;
		CCLOG("ref count %d", tex->getReferenceCount());
		if (tex->getReferenceCount() == 1)
		{
			CCLOG("removing unused bmp texture :%s", it->first.c_str());
			tex->release();
			m_cachedBmpTex.erase(it++);
		}
		else
		{
			++it;
		}
	}

	//重新加载数据
	for (auto it = m_cachedBmpTex.cbegin(); it != m_cachedBmpTex.cend(); ++it)
	{
		bool bHave = false;
		unsigned char *data = getBMPFileData(it->first.c_str(), bHave);
		if (nullptr != data && true == bHave)
		{
			it->second->initWithData(data, 96 * 96 * 4, Texture2D::PixelFormat::RGBA8888, 96, 96, cocos2d::Size(96, 96));
		}
	}

	if (m_BackgroundCallBack != 0)
	{
		lua_State* tolua_S = LuaEngine::getInstance()->getLuaStack()->getLuaState();
		toluafix_get_function_by_refid(tolua_S, m_BackgroundCallBack);
		if (lua_isfunction(tolua_S, -1))
		{
			lua_pushboolean(tolua_S, 1);
			LuaEngine::getInstance()->getLuaStack()->executeFunctionByHandler(m_BackgroundCallBack, 1) != 0;
		}
		else{
			CCLOG("applicationDidEnterBackground-luacallback-handler-false:%d", m_BackgroundCallBack);
		}
	}
}

void AppDelegate::GlobalUpdate(float dt)
{
	CClientKernel* pKernel = (CClientKernel*)AppDelegate::getAppInstance()->getClientKernel();
	if (pKernel)
		pKernel->GlobalUpdate(dt);
	else
		CCLOG("GlobalUpdate m_pClientKernel is null");
}
