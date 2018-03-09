package net.iapploft.games.battletetris;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.lua.AppActivity;

import com.facebook.AccessToken;

import android.content.Context;
import android.os.Handler;
import android.util.Log;

public class Functions  {
    public static AppActivity ct;
    public static Handler handler = new Handler();
    public static DeviceUuidFactory factory;
    public static void init(AppActivity cct){
  		 ct = cct;
  		 factory = new DeviceUuidFactory(cct.getContext());
  	}
    public static int addTwoNumbers(final int num1,final int num2){
		return num1 + num2;
	}
    public static void iapploftLog(final String msg){
  		
  		handler.postDelayed(new Runnable(){

			@Override
			public void run() {
				Log.d("iapploft log : ", msg);
				
			}
		}, 1);
  	}
	
	public static void callbackLua(final String tipInfo,final int luaFunc){
		Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFunc, "success");
		Cocos2dxLuaJavaBridge.releaseLuaFunction(luaFunc);
	}
	
	public static void showAdPage(final int num1)
	{
		final AppActivity app = ct;
		System.out.print("showAdPage = "+num1);
		 handler.postDelayed(new Runnable(){

			@Override
			public void run() {
				// TODO Auto-generated method stub
				if(app.mInterstitialAd.isReady())
				{
					app.mInterstitialAd.show();
				}
//				if (app.mInterstitialAd.isLoaded()) 
//				{
//					app.mInterstitialAd.show();
//				}
				
			}
		}, 10);
	    
	}
	public static void showAdBar(final int num1)
	{
		final AppActivity app = ct;
		System.out.print("showAdBar = "+num1);
		 handler.postDelayed(new Runnable(){

			@Override
			public void run() {
				// TODO Auto-generated method stub
				app.showBanner();		
			}
		}, 10);
	    
	}
	 
	public static void hiddenAdBar(final int num1)
	{
		System.out.print("hiddenAdBar = "+num1); 
		 //ct.hideBanner();
		 final AppActivity app = ct;
			System.out.print("showAdBar = "+num1);
			 handler.postDelayed(new Runnable(){

				@Override
				public void run() {
					// TODO Auto-generated method stub
					app.hideBanner();		
				}
			}, 10);
		    
	}
	public static void buyForProduct(final String p_id,final int luaFunc)
	{
		 
		  handler.postDelayed(new Runnable() {
		 
		      @Override public void run() {
		        //Todo
		       ct.pay.buy(p_id,luaFunc);
		      }
		    }, 100);
	}
	public static void post(final String msg){
		 final AppActivity app = ct;
	  		handler.postDelayed(new Runnable(){
				@Override
				public void run() {
					app.postDialog();
				}
			}, 1);
    }
	public static void invite(final String msg,final String title){
		 final AppActivity app = ct;
		 
	  		handler.postDelayed(new Runnable(){
				@Override
				public void run() {
					app.inviteDialog(title, msg);
				}
			}, 1);
   }
    public static void logIn(final int luaFunc)
    {
    	final AppActivity app = ct;
    	handler.postDelayed(new Runnable(){
			@Override
			public void run() {
				app.facebookLogin(luaFunc);
			}
		}, 1);
    }
    public static void getPlayerId(final int luaFunc){
    		final AppActivity app = ct;
    		handler.postDelayed(new Runnable(){
    			@Override
    			public void run() {
    				AccessToken accessToken = AccessToken.getCurrentAccessToken();
    		    	if(accessToken != null)
    		    	{
    		    		String result = "{\"playerId\":\""+accessToken.getUserId()+"\"}";
        		     	Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFunc, result);
        		  		Cocos2dxLuaJavaBridge.releaseLuaFunction(luaFunc);
    		    	}else{
    				    app.facebookLogin(luaFunc);
    		    	}
    			}
    		}, 1);
    	 
	}
//    public static void getPlayerId(final int luaFunc){
//		final String gameCenterId = DeviceUuidFactory.getUuidByContext(ct);
//		final String uuid = factory.uuid.toString();
//		handler.postDelayed(new Runnable() {
//			  String gid = gameCenterId;
//			  String ud = uuid;
//		      @Override public void run() {
//		        //Todo
//		    	ud=ud.replaceAll("-", "");
//		    	String result = "{\"playerId\":\""+ud+"\"}";
//		        System.out.println("id = "+result); 
//		        System.out.println("ud = "+ud); 
//		         
//		    	Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFunc, result);
//		  		Cocos2dxLuaJavaBridge.releaseLuaFunction(luaFunc);
//		      }
//		    }, 100);
//	}
	
}