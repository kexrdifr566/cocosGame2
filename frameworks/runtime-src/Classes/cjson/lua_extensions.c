
#include "lua_extensions.h"

#if __cplusplus
extern "C" {
#endif

// cjson
#include "lua_cjson.h"
#include "luasocket/luasocket.h"
#include "luasocket/luasocket_scripts.h"
#include "luasocket/mime.h"
#include "external/lua/lpack/lpack.h"

static luaL_Reg luax_exts[] = {
    { "cjson", luaopen_cjson},
	{ "socket.core", luaopen_socket_core },
	{ "mime.core", luaopen_mime_core },
	{ "pack", luaopen_pack },//添加包到脚本系统
    {NULL, NULL}
};

#include "tolua_fix.h"

void luaopen_lua_extensions(lua_State *L)
{
    luaL_Reg* lib = luax_exts;
    lua_getglobal(L, "package");
    lua_getfield(L, -1, "preload");
    for (; lib->func; lib++)
    {
        lua_pushcfunction(L, lib->func);
        lua_setfield(L, -2, lib->name);
    }
    lua_pop(L, 2);
}

#if __cplusplus
} // extern "C"
#endif
