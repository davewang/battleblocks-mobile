#include "lua_UIWebView_auto.hpp"
#include "UIWebView.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"
#include "CCLuaValue.h"
#include "cocos-ext.h"
#include "CCLuaEngine.h"
#include "LuaScriptHandlerMgr.h"
//#include "cocos2d.h"


class LuaWebViewDelegate:public Ref, public cocos2d::experimental::ui::WebViewDelegate
{
public:
    virtual ~LuaWebViewDelegate()
    {}
    virtual void onShouldStartLoading(cocos2d::experimental::ui::WebView* view,const std::string &url = "") override
    {
        if (nullptr != view)
        {
            int handler = ScriptHandlerMgr::getInstance()->getObjectHandler((void*)view, ScriptHandlerMgr::HandlerType::WEBVIEW_SHOULDSTARTLOADING);
            if (0 != handler)
            {
                view->setString(url);
                CommonScriptData data(handler,url.c_str(),view);
                ScriptEvent event(kCommonEvent,(void*)&data);
                LuaEngine::getInstance()->sendEvent(&event);
            }
            
        }
      
        
    };
    /**
     * @js NA
     * @lua NA
     */
    virtual void onDidFinishLoading(cocos2d::experimental::ui::WebView* view,const std::string &url = "") override {
        if (nullptr != view)
        {
            int handler = ScriptHandlerMgr::getInstance()->getObjectHandler((void*)view, ScriptHandlerMgr::HandlerType::WEBVIEW_DIDFINISHLOADING);
            if (0 != handler)
            {
                view->setString(url);
                 CommonScriptData data(handler,url.c_str(),view);
                ScriptEvent event(kCommonEvent,(void*)&data);
                LuaEngine::getInstance()->sendEvent(&event);
            }
            
        }
    };
    
    virtual void onDidFailLoading(cocos2d::experimental::ui::WebView* view,const std::string &url = "") override {
        if (nullptr != view)
        {
            int handler = ScriptHandlerMgr::getInstance()->getObjectHandler((void*)view, ScriptHandlerMgr::HandlerType::WEBVIEW_DIDFAILLOADING);
            if (0 != handler)
            {
                view->setString(url);
                 CommonScriptData data(handler,url.c_str(),view);
                ScriptEvent event(kCommonEvent,(void*)&data);
                LuaEngine::getInstance()->sendEvent(&event);
            }
            
        }
    };
    
    virtual void onJSCallback(cocos2d::experimental::ui::WebView* view,const std::string &url = "") override{
        if (nullptr != view)
        {
            int handler = ScriptHandlerMgr::getInstance()->getObjectHandler((void*)view, ScriptHandlerMgr::HandlerType::WEBVIEW_ONJSCALLBACK);
            if (0 != handler)
            {
                view->setString(url);
                 CommonScriptData data(handler,url.c_str(),view);
                ScriptEvent event(kCommonEvent,(void*)&data);
                LuaEngine::getInstance()->sendEvent(&event);
            }
            
        }
        
    };

    
//    virtual void scrollViewDidScroll(ScrollView* view) override
//    {
//        if (nullptr != view)
//        {
//            int handler = ScriptHandlerMgr::getInstance()->getObjectHandler((void*)view, ScriptHandlerMgr::HandlerType::SCROLLVIEW_SCROLL);
//            if (0 != handler)
//            {
//                CommonScriptData data(handler,"");
//                ScriptEvent event(kCommonEvent,(void*)&data);
//                LuaEngine::getInstance()->sendEvent(&event);
//            }
//            
//        }
//    }
//    
//    virtual void scrollViewDidZoom(ScrollView* view) override
//    {
//        if (nullptr != view)
//        {
//            int handler = ScriptHandlerMgr::getInstance()->getObjectHandler((void*)view, ScriptHandlerMgr::HandlerType::SCROLLVIEW_ZOOM);
//            if (0 != handler)
//            {
//                CommonScriptData data(handler,"");
//                ScriptEvent event(kCommonEvent,(void*)&data);
//                LuaEngine::getInstance()->sendEvent(&event);
//            }
//        }
//    }
};


int lua_UIWebView_WebView_getString(lua_State* tolua_S)
{
    int argc = 0;
     cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = ( cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_cocos2dx_ui_Text_getString'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_cocos2dx_ui_Text_getString'", nullptr);
            return 0;
        }
        const std::string& ret = cobj->getString();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccui.Text:getString",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_cocos2dx_ui_Text_getString'.",&tolua_err);
#endif
    
    return 0;
}

int lua_UIWebView_WebView_loadURL(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_loadURL'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 1)
    {
        std::string arg0;
        
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "ccexp.WebView:loadURL");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_loadURL'", nullptr);
            return 0;
        }
        cobj->loadURL(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:loadURL",argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_loadURL'.",&tolua_err);
#endif
    
    return 0;
}


int lua_UIWebView_WebView_registerScriptHandler(lua_State* tolua_S)
{
    if (NULL == tolua_S)
        return 0;
    
    int argc = 0;
    cocos2d::experimental::ui::WebView* self = nullptr;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    self = static_cast<cocos2d::experimental::ui::WebView*>(tolua_tousertype(tolua_S,1,0));
    
#if COCOS2D_DEBUG >= 1
    if (nullptr == self) {
        tolua_error(tolua_S,"invalid 'self' in function 'lua_UIWebView_WebView_registerScriptHandler'\n", NULL);
        return 0;
    }
#endif
    argc = lua_gettop(tolua_S) - 1;
    if (2 == argc)
    {
#if COCOS2D_DEBUG >= 1
        if (!toluafix_isfunction(tolua_S,2,"LUA_FUNCTION",0,&tolua_err) ||
            !tolua_isnumber(tolua_S, 3, 0, &tolua_err) )
        {
            goto tolua_lerror;
        }
#endif
        LUA_FUNCTION handler = (  toluafix_ref_function(tolua_S,2,0));
        ScriptHandlerMgr::HandlerType handlerType = (ScriptHandlerMgr::HandlerType) ((int)tolua_tonumber(tolua_S,3,0) + (int)ScriptHandlerMgr::HandlerType::WEBVIEW_SHOULDSTARTLOADING);
        
        ScriptHandlerMgr::getInstance()->addObjectHandler((void*)self, handler, handlerType);
        return 0;
    }
    
    luaL_error(tolua_S, "%s function of ScrollView has wrong number of arguments: %d, was expecting %d\n", "lua_UIWebView_WebView_registerScriptHandler",argc, 2);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_registerScriptHandler'.",&tolua_err);
    return 0;
#endif
}

int lua_UIWebView_WebView_canGoBack(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_canGoBack'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_canGoBack'", nullptr);
            return 0;
        }
        bool ret = cobj->canGoBack();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:canGoBack",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_canGoBack'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_loadHTMLString(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_loadHTMLString'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 1)
    {
        std::string arg0;
        
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "ccexp.WebView:loadHTMLString");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_loadHTMLString'", nullptr);
            return 0;
        }
        cobj->loadHTMLString(arg0,"");
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2)
    {
        std::string arg0;
        std::string arg1;
        
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "ccexp.WebView:loadHTMLString");
        
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "ccexp.WebView:loadHTMLString");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_loadHTMLString'", nullptr);
            return 0;
        }
        cobj->loadHTMLString(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:loadHTMLString",argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_loadHTMLString'.",&tolua_err);
#endif
    
    return 0;
}



int lua_UIWebView_WebView_setDelegate(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    //bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_setOnJSCallback'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    
    if (0 == argc)
    {
        LuaWebViewDelegate* delegate = new (std::nothrow) LuaWebViewDelegate();
        if (nullptr == delegate)
            return 0;
        
        cobj->setUserObject(delegate);
        cobj->setDelegate(delegate);
        
        delegate->release();
        
        return 0;
    }
    
    luaL_error(tolua_S, "'setDelegate' function of ScrollView wrong number of arguments: %d, was expecting %d\n", argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'setDelegate'.",&tolua_err);
    return 0;
#endif
}

int lua_UIWebView_WebView_setOnJSCallback(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_setOnJSCallback'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 1)
    {
        std::function<void (cocos2d::experimental::ui::WebView *, const std::basic_string<char> &)> arg0;
        
        do {
            // Lambda binding for lua is not supported.
            assert(false);
        } while(0)
            ;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_setOnJSCallback'", nullptr);
            return 0;
        }
        cobj->setOnJSCallback(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:setOnJSCallback",argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_setOnJSCallback'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_setOnShouldStartLoading(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_setOnShouldStartLoading'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 1)
    {
        std::function<bool (cocos2d::experimental::ui::WebView *, const std::basic_string<char> &)> arg0;
        
        do {
            // Lambda binding for lua is not supported.
            assert(false);
        } while(0)
            ;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_setOnShouldStartLoading'", nullptr);
            return 0;
        }
        cobj->setOnShouldStartLoading(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:setOnShouldStartLoading",argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_setOnShouldStartLoading'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_goForward(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_goForward'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_goForward'", nullptr);
            return 0;
        }
        cobj->goForward();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:goForward",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_goForward'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_goBack(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_goBack'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_goBack'", nullptr);
            return 0;
        }
        cobj->goBack();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:goBack",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_goBack'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_setJavascriptInterfaceScheme(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_setJavascriptInterfaceScheme'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 1)
    {
        std::string arg0;
        
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "ccexp.WebView:setJavascriptInterfaceScheme");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_setJavascriptInterfaceScheme'", nullptr);
            return 0;
        }
        cobj->setJavascriptInterfaceScheme(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:setJavascriptInterfaceScheme",argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_setJavascriptInterfaceScheme'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_evaluateJS(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_evaluateJS'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 1)
    {
        std::string arg0;
        
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "ccexp.WebView:evaluateJS");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_evaluateJS'", nullptr);
            return 0;
        }
        cobj->evaluateJS(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:evaluateJS",argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_evaluateJS'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_getOnJSCallback(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_getOnJSCallback'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_getOnJSCallback'", nullptr);
            return 0;
        }
        cocos2d::experimental::ui::WebView::ccWebViewCallback ret = cobj->getOnJSCallback();
#pragma warning NO CONVERSION FROM NATIVE FOR std::function;
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:getOnJSCallback",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_getOnJSCallback'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_reload(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_reload'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_reload'", nullptr);
            return 0;
        }
        cobj->reload();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:reload",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_reload'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_setScalesPageToFit(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_setScalesPageToFit'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 1)
    {
        bool arg0;
        
        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "ccexp.WebView:setScalesPageToFit");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_setScalesPageToFit'", nullptr);
            return 0;
        }
        cobj->setScalesPageToFit(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:setScalesPageToFit",argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_setScalesPageToFit'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_canGoForward(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_canGoForward'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_canGoForward'", nullptr);
            return 0;
        }
        bool ret = cobj->canGoForward();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:canGoForward",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_canGoForward'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_loadData(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_loadData'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 4)
    {
        cocos2d::Data arg0;
        std::string arg1;
        std::string arg2;
        std::string arg3;
        
        //        ok &= luaval_to_object<cocos2d::Data>(tolua_S, 2, "cc.Data",&arg0);
        
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "ccexp.WebView:loadData");
        
        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "ccexp.WebView:loadData");
        
        ok &= luaval_to_std_string(tolua_S, 5,&arg3, "ccexp.WebView:loadData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_loadData'", nullptr);
            return 0;
        }
        cobj->loadData(arg0, arg1, arg2, arg3);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:loadData",argc, 4);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_loadData'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_getOnShouldStartLoading(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_getOnShouldStartLoading'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_getOnShouldStartLoading'", nullptr);
            return 0;
        }
        std::function<bool (cocos2d::experimental::ui::WebView *, const std::basic_string<char> &)> ret = cobj->getOnShouldStartLoading();
#pragma warning NO CONVERSION FROM NATIVE FOR std::function;
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:getOnShouldStartLoading",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_getOnShouldStartLoading'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_loadFile(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_loadFile'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 1)
    {
        std::string arg0;
        
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "ccexp.WebView:loadFile");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_loadFile'", nullptr);
            return 0;
        }
        cobj->loadFile(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:loadFile",argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_loadFile'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_stopLoading(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_stopLoading'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_stopLoading'", nullptr);
            return 0;
        }
        cobj->stopLoading();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:stopLoading",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_stopLoading'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_setOnDidFinishLoading(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_setOnDidFinishLoading'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 1)
    {
        std::function<void (cocos2d::experimental::ui::WebView *, const std::basic_string<char> &)> arg0;
        
        do {
            // Lambda binding for lua is not supported.
            assert(false);
        } while(0)
            ;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_setOnDidFinishLoading'", nullptr);
            return 0;
        }
        cobj->setOnDidFinishLoading(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:setOnDidFinishLoading",argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_setOnDidFinishLoading'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_setOnDidFailLoading(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_setOnDidFailLoading'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 1)
    {
        std::function<void (cocos2d::experimental::ui::WebView *, const std::basic_string<char> &)> arg0;
        
        do {
            // Lambda binding for lua is not supported.
            assert(false);
        } while(0)
            ;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_setOnDidFailLoading'", nullptr);
            return 0;
        }
        cobj->setOnDidFailLoading(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:setOnDidFailLoading",argc, 1);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_setOnDidFailLoading'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_getOnDidFinishLoading(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_getOnDidFinishLoading'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_getOnDidFinishLoading'", nullptr);
            return 0;
        }
        cocos2d::experimental::ui::WebView::ccWebViewCallback ret = cobj->getOnDidFinishLoading();
#pragma warning NO CONVERSION FROM NATIVE FOR std::function;
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:getOnDidFinishLoading",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_getOnDidFinishLoading'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_getOnDidFailLoading(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::experimental::ui::WebView* cobj = nullptr;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    cobj = (cocos2d::experimental::ui::WebView*)tolua_tousertype(tolua_S,1,0);
    
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_UIWebView_WebView_getOnDidFailLoading'", nullptr);
        return 0;
    }
#endif
    
    argc = lua_gettop(tolua_S)-1;
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_getOnDidFailLoading'", nullptr);
            return 0;
        }
        cocos2d::experimental::ui::WebView::ccWebViewCallback ret = cobj->getOnDidFailLoading();
#pragma warning NO CONVERSION FROM NATIVE FOR std::function;
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccexp.WebView:getOnDidFailLoading",argc, 0);
    return 0;
    
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_getOnDidFailLoading'.",&tolua_err);
#endif
    
    return 0;
}
int lua_UIWebView_WebView_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;
    
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif
    
#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"ccexp.WebView",0,&tolua_err)) goto tolua_lerror;
#endif
    
    argc = lua_gettop(tolua_S) - 1;
    
    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_UIWebView_WebView_create'", nullptr);
            return 0;
        }
        cocos2d::experimental::ui::WebView* ret = cocos2d::experimental::ui::WebView::create();
        object_to_luaval<cocos2d::experimental::ui::WebView>(tolua_S, "ccexp.WebView",(cocos2d::experimental::ui::WebView*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "ccexp.WebView:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_UIWebView_WebView_create'.",&tolua_err);
#endif
    return 0;
}
static int lua_UIWebView_WebView_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (WebView)");
    return 0;
}

int lua_register_UIWebView_WebView(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"ccexp.WebView");
    tolua_cclass(tolua_S,"WebView","ccexp.WebView","ccui.Widget",nullptr);
    
    tolua_beginmodule(tolua_S,"WebView");
    tolua_function(tolua_S,"loadURL",lua_UIWebView_WebView_loadURL);
    tolua_function(tolua_S,"canGoBack",lua_UIWebView_WebView_canGoBack);
    tolua_function(tolua_S,"loadHTMLString",lua_UIWebView_WebView_loadHTMLString);
    tolua_function(tolua_S,"setOnJSCallback",lua_UIWebView_WebView_setOnJSCallback);
    tolua_function(tolua_S,"setOnShouldStartLoading",lua_UIWebView_WebView_setOnShouldStartLoading);
    tolua_function(tolua_S,"goForward",lua_UIWebView_WebView_goForward);
    tolua_function(tolua_S,"goBack",lua_UIWebView_WebView_goBack);
    tolua_function(tolua_S,"setJavascriptInterfaceScheme",lua_UIWebView_WebView_setJavascriptInterfaceScheme);
    tolua_function(tolua_S,"evaluateJS",lua_UIWebView_WebView_evaluateJS);
    tolua_function(tolua_S,"getOnJSCallback",lua_UIWebView_WebView_getOnJSCallback);
    tolua_function(tolua_S,"reload",lua_UIWebView_WebView_reload);
    tolua_function(tolua_S,"setScalesPageToFit",lua_UIWebView_WebView_setScalesPageToFit);
    tolua_function(tolua_S,"canGoForward",lua_UIWebView_WebView_canGoForward);
    tolua_function(tolua_S,"loadData",lua_UIWebView_WebView_loadData);
    tolua_function(tolua_S,"getOnShouldStartLoading",lua_UIWebView_WebView_getOnShouldStartLoading);
    tolua_function(tolua_S,"loadFile",lua_UIWebView_WebView_loadFile);
    tolua_function(tolua_S,"stopLoading",lua_UIWebView_WebView_stopLoading);
    tolua_function(tolua_S,"setOnDidFinishLoading",lua_UIWebView_WebView_setOnDidFinishLoading);
    tolua_function(tolua_S,"setOnDidFailLoading",lua_UIWebView_WebView_setOnDidFailLoading);
    tolua_function(tolua_S,"getOnDidFinishLoading",lua_UIWebView_WebView_getOnDidFinishLoading);
    tolua_function(tolua_S,"getOnDidFailLoading",lua_UIWebView_WebView_getOnDidFailLoading);
    
    tolua_function(tolua_S,"setDelegate",lua_UIWebView_WebView_setDelegate);
    tolua_function(tolua_S,"registerScriptHandler",lua_UIWebView_WebView_registerScriptHandler);
    tolua_function(tolua_S,"getString",lua_UIWebView_WebView_getString);
    
    
    tolua_function(tolua_S,"create", lua_UIWebView_WebView_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(cocos2d::experimental::ui::WebView).name();
    g_luaType[typeName] = "ccexp.WebView";
    g_typeCast["WebView"] = "ccexp.WebView";
    return 1;
}
TOLUA_API int register_all_UIWebView(lua_State* tolua_S)
{  
    tolua_open(tolua_S);  
    
    tolua_module(tolua_S,nullptr,0);  
    tolua_beginmodule(tolua_S,nullptr);  
    
    lua_register_UIWebView_WebView(tolua_S);  
    
    tolua_endmodule(tolua_S);  
    return 1;  
}