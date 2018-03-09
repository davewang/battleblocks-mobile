#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <sys/time.h>
#include <lua.h>
#include <lauxlib.h>
//#if LUA_VERSION_NUM == 501
//#define luaL_newlib(L,funcs) lua_newtable(L); luaL_register(L, NULL, funcs)
//#define luaL_setfuncs(L,funcs,x) luaL_register(L, NULL, funcs)
//#endif

#ifndef luaL_newlib /* using LuaJIT */
/*
 ** set functions from list 'l' into table at top - 'nup'; each
 ** function gets the 'nup' elements at the top as upvalues.
 ** Returns with only the table at the stack.
 */
void luaL_setfuncs (lua_State *L, const luaL_Reg *l, int nup) ;
//{
//#ifdef luaL_checkversion
//    luaL_checkversion(L);
//#endif
//    luaL_checkstack(L, nup, "too many upvalues");
//    for (; l->name != NULL; l++) {  /* fill the table with given functions */
//        int i;
//        for (i = 0; i < nup; i++)  /* copy upvalues to the top */
//            lua_pushvalue(L, -nup);
//        lua_pushcclosure(L, l->func, nup);  /* closure with those upvalues */
//        lua_setfield(L, -(nup + 2), l->name);
//    }
//    lua_pop(L, nup);  /* remove upvalues */
//}

#define luaL_newlibtable(L,l) \
lua_createtable(L, 0, sizeof(l)/sizeof((l)[0]) - 1)

#define luaL_newlib(L,l)  (luaL_newlibtable(L,l), luaL_setfuncs(L,l,0))
#endif

#if LUA_VERSION_NUM < 503

// lua_isinteger is lua 5.3 api
#define lua_isinteger lua_isnumber

#endif

struct time {
	uint64_t start_time;
	int time_elapse;	// init -1, the time elapse from first time sync
	int time_shift;	// shift time from first time sync, (local timer may faster or slower than global timer)
	int time_sync;	// sync time (in local time)
	int estimate_from;	// estimate global time [from , to] . 
	int estimate_to;
};

static uint64_t
gettime() {
	uint64_t t;
	struct timeval tv;
	gettimeofday(&tv, NULL);
	t = (uint64_t)tv.tv_sec * 100;
	t += tv.tv_usec / 10000;
	return t;
}

static int
llocaltime(lua_State *L) {
	struct time * t = lua_touserdata(L, lua_upvalueindex(1));
	uint64_t ct = gettime();
	lua_pushinteger(L, ct - t->start_time);
	return 1;
}

/*
	integer: sync request time (use local time)
	integer: global time
 */
static int
lsync(lua_State *L) {
     
	int request_time = luaL_checkinteger(L,1);
	int global_time = luaL_checkinteger(L,2);
	struct time * t = lua_touserdata(L, lua_upvalueindex(1));
	uint64_t now = gettime();
	int local_time = (int)(now - t->start_time);
	int lag = local_time - request_time;
	int elapse_from_last_sync = local_time - t->time_sync;
	if (local_time < request_time) {
		// invalid sync
		return 0;
	}
	if (t->time_elapse < 0 || elapse_from_last_sync < 0) {
		// first time sync
		t->time_elapse = 0;
		t->time_shift = 0;
		t->time_sync = local_time;
		t->estimate_from = global_time;
		t->estimate_to = global_time + lag;
	} else {
		int estimate = global_time + lag/2;
		t->estimate_from += elapse_from_last_sync;
		t->estimate_to += elapse_from_last_sync;
		int estimate_last = t->estimate_from + (t->estimate_to - t->estimate_from)/2;
		t->time_elapse += elapse_from_last_sync;
		t->time_shift += estimate - estimate_last;
		t->time_sync = local_time;
		if (estimate < t->estimate_from || estimate > t->estimate_to) {
			// estimate time is not in last estimate section, use this section instead
			t->estimate_from = global_time;
			t->estimate_to = global_time + lag;
		} else {
			if (global_time > t->estimate_from)
				t->estimate_from = global_time;
			if (global_time + lag < t->estimate_to)
				t->estimate_to = global_time + lag;
		}
	}
	lua_pushinteger(L, lag/2);
	if (t->time_shift == 0 || t->time_elapse <=0) {
		lua_pushinteger(L, 0);
	} else {
		lua_pushnumber(L, (double)t->time_shift / t->time_elapse);
	}
	return 2;
}

static int
lglobaltime(lua_State *L) {
	struct time * t = lua_touserdata(L, lua_upvalueindex(1));
	if (t->time_elapse < 0) {
		return 0;
	}
	uint64_t now = gettime();
	int local_time = (int)(now - t->start_time);
	int lag = (t->estimate_to - t->estimate_from)/2;
	int estimate = t->estimate_from + lag + (local_time - t->time_sync);
	lua_pushinteger(L, estimate);
	lua_pushinteger(L, lag);
	return 2;
}

static void
init(struct time * t) {
	memset(t, 0, sizeof(*t));
	t->start_time = gettime();
	t->time_elapse = -1;
}

// debug use
static int
lsleep(lua_State *L) {
	int t = luaL_checkinteger(L,1);
	usleep(t * 10000);
	return 0;
}

int
luaopen_timesync(lua_State *L) {
	//luaL_checkversion(L);
	luaL_Reg l[] = {
		{ "localtime", llocaltime },
		{ "sync", lsync },
		{ "globaltime", lglobaltime },
		{ "sleep", lsleep },
		{ NULL, NULL },
	};
    //luaL_newlib(L, l);

	luaL_newlibtable(L,l);
	struct time * t = lua_newuserdata(L, sizeof(*t));
	init(t);
	luaL_setfuncs(L,l,1);

	return 1;
}
