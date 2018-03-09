
#include "lua_extensions.h"

#if __cplusplus
extern "C" {
#endif
// socket
#include "luasocket/luasocket.h"
#include "luasocket/luasocket_scripts.h"
#include "luasocket/mime.h"
        int luaopen_lsocket(lua_State *L);
        int luaopen_timesync(lua_State *L);
        int luaopen_crypt(lua_State *L);
        int luaopen_sproto_core(lua_State *L);
    int luaopen_lpeg (lua_State *L);
static luaL_Reg luax_exts[] = {
    {"socket.core", luaopen_socket_core},
    {"mime.core", luaopen_mime_core},
    
    {"sproto.core", luaopen_sproto_core},
    {"crypt", luaopen_crypt},
    {"timesync", luaopen_timesync},
    {"lsocket", luaopen_lsocket},
    {"lpeg", luaopen_lpeg},
   
    {NULL, NULL}
};

void luaopen_lua_extensions(lua_State *L)
{
    // load extensions
    luaL_Reg* lib = luax_exts;
    lua_getglobal(L, "package");
    lua_getfield(L, -1, "preload");
    for (; lib->func; lib++)
    {
        lua_pushcfunction(L, lib->func);
        lua_setfield(L, -2, lib->name);
    }
    lua_pop(L, 2);

    luaopen_luasocket_scripts(L);
}

#if __cplusplus
} // extern "C"
#endif
