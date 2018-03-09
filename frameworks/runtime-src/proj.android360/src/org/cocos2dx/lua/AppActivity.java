/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2011      Zynga Inc.
Copyright (c) 2013-2014 Chukong Technologies Inc.
 
http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package org.cocos2dx.lua;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.ArrayList;

import net.iapploft.games.battletetris.Functions;
import net.iapploft.games.battletetris.GooglePlayPurchase;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxHelper;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.json.JSONObject;

 
import com.google.ads.Ad;
import com.google.ads.AdListener;
import com.google.ads.AdRequest;
import com.google.ads.AdRequest.ErrorCode;
import com.google.ads.AdSize;
import com.google.ads.AdView;
import com.google.ads.InterstitialAd;
import com.parse.Parse;
import com.parse.ParseInstallation;
import com.qihoo.gamecenter.sdk.activity.ContainerActivity;
import com.qihoo.gamecenter.sdk.common.IDispatcherCallback; 
import com.qihoo.gamecenter.sdk.matrix.Matrix;
import com.qihoo.gamecenter.sdk.protocols.ProtocolConfigs;
import com.qihoo.gamecenter.sdk.protocols.ProtocolKeys;
 
import android.app.ActionBar.LayoutParams;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.DialogInterface.OnCancelListener;
import android.content.pm.ApplicationInfo;
import android.content.pm.ActivityInfo;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.preference.PreferenceManager.OnActivityResultListener;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.text.format.Formatter;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import android.widget.Toast;
import android.provider.Settings.Secure;

import com.facebook.AccessToken;
import com.facebook.AccessTokenTracker;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookOperationCanceledException;
import com.facebook.FacebookSdk;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.facebook.share.model.GameRequestContent;
import com.facebook.share.model.GameRequestContent.ActionType;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.GameRequestDialog;
import com.facebook.share.widget.ShareDialog;

 
public class AppActivity extends Cocos2dxActivity{

	
	    protected QihooUserInfo mQihooUserInfo;

	    protected boolean mIsLandscape;

	    protected String mAccessToken = null;

	    private boolean mIsInOffline = false;

	    public static final String SHOW_CHAT_FROM_QINJIA = "show_im_from_qinjia";

	    /**
	     * AccessToken是否有效
	     */
	    protected static boolean isAccessTokenValid = true;
	    /**
	     * QT是否有效
	     */
	    protected static boolean isQTValid = true;

	    
	private AdView adView;
    static String hostIPAdress = "0.0.0.0";
    private String deviceId;
    private int luaFunc; 
    public GooglePlayPurchase pay = GooglePlayPurchase.instance();
    
    //private final String adBarUnitId = "ca-app-pub-2340084892588583/7478309757"; 
    //private final String interstitialUnitId = "ca-app-pub-2340084892588583/9768968156"; 
    private final String adBarUnitId = "ca-app-pub-2340084892588583/6684152158"; 
    private final String interstitialUnitId = "ca-app-pub-2340084892588583/9637618557"; 
    
    //插页广告
    public InterstitialAd mInterstitialAd;
    //facebook 
    ShareDialog shareDialog;
    GameRequestDialog requestDialog;
    CallbackManager callbackManager;
    
    AccessTokenTracker accessTokenTracker;
    AccessToken accessToken;
    private void requestNewInterstitial() {
    	 
//    	final int curSize = sizeEnum;
//		AdSize size = AdSize.BANNER;
//		switch (curSize) {
//		case AdsAdmob.ADMOB_SIZE_BANNER:
//			size = AdSize.BANNER;
//			break;
//		case AdsAdmob.ADMOB_SIZE_IABMRect:
//			size = AdSize.IAB_MRECT;
//			break;
//		case AdsAdmob.ADMOB_SIZE_IABBanner:
//			size = AdSize.IAB_BANNER;
//			break;
//		case AdsAdmob.ADMOB_SIZE_IABLeaderboard:
//			size = AdSize.IAB_LEADERBOARD;
//			break;
//		case AdsAdmob.ADMOB_SIZE_Skyscraper:
//		    size = AdSize.IAB_WIDE_SKYSCRAPER;
//		    break;
//		default:
//			break;
//		}
		AdRequest adRequest = new AdRequest();
		 
//        AdRequest adRequest = new AdRequest.Builder()
//                  .addTestDevice(AdRequest.DEVICE_ID_EMULATOR)
//                  .build();

        mInterstitialAd.loadAd(adRequest);
    }

  //  private String android_id = Secure.getString(getContext().getContentResolver(),
   //                                                         Secure.ANDROID_ID); 
    
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Parse.enableLocalDatastore(this);
        
        pay.initGoogleData(this);
        mInterstitialAd = new InterstitialAd(this,interstitialUnitId);
        //mInterstitialAd.setAdUnitId(interstitialUnitId);
        requestNewInterstitial();
        //facebook 
        FacebookSdk.sdkInitialize(getApplicationContext());
        callbackManager = CallbackManager.Factory.create();
        shareDialog = new ShareDialog(this);
        requestDialog = new GameRequestDialog(this);
        
        accessTokenTracker = new AccessTokenTracker() {
            @Override
            protected void onCurrentAccessTokenChanged(
                AccessToken oldAccessToken,
                AccessToken currentAccessToken) {
                    // Set the access token using 
                    // currentAccessToken when it's loaded or set.
            }
        };
        // If the access token is available already assign it.
        accessToken = AccessToken.getCurrentAccessToken();
        
        LoginManager.getInstance().registerCallback(callbackManager,
                new FacebookCallback<LoginResult>() {
                    @Override
                    public void onSuccess(LoginResult loginResult) {
                    	AccessToken token = loginResult.getAccessToken();
                     	String result = "{\"playerId\":\""+token.getUserId()+"\"}";
        		     	Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFunc, result);
        		  		Cocos2dxLuaJavaBridge.releaseLuaFunction(luaFunc);
                       // App code
                    	Log.d("Facebook","Success");
                    }

                    @Override
                    public void onCancel() {
                         // App code
                    	Log.d("Facebook","Cancel");
                    }

                    @Override
                    public void onError(FacebookException exception) {
                         // App code   
                    	Log.d("Facebook",exception.toString());
                    }
        });
    	
        
        // this part is optional
      //  shareDialog.registerCallback(callbackManager, new FacebookCallback<Sharer.Result>() { });
        shareDialog.registerCallback(callbackManager, new FacebookCallback<ShareDialog.Result>() {

			@Override
			public void onSuccess(ShareDialog.Result result) {
				// TODO Auto-generated method stub
				String id = result.getPostId();
				Log.d("facebook","post success id = "+id);
				
			}

			@Override
			public void onCancel() {
				// TODO Auto-generated method stub
				Log.d("facebook","share  is cancel " );
			}

			@Override
			public void onError(FacebookException error) {
				// TODO Auto-generated method stub
				Log.d("facebook","share  is error " + error);
			} });
        
        requestDialog.registerCallback(callbackManager, new FacebookCallback<GameRequestDialog.Result>() {
            public void onSuccess(GameRequestDialog.Result result) {
                String id = result.getRequestId();
            	Log.d("facebook","game request success id = "+id);
            	
                
            }

            public void onCancel() {
            	Log.d("facebook","game request is cancel ");
            }

            public void onError(FacebookException error) {
            	Log.d("facebook","game request is error " + error);
            }
        });
        
        
        mInterstitialAd.setAdListener(new AdListener() {
//            @Override
//            public void onAdClosed() {
//               // requestNewInterstitial();
//               // beginPlayingGame();
//            	requestNewInterstitial();
//            	Log.d("click","onAdClosed");
//            }

			@Override
			public void onDismissScreen(Ad arg0) {
				// TODO Auto-generated method stub
				requestNewInterstitial();
            	Log.d("click","onAdClosed");
			}

			@Override
			public void onFailedToReceiveAd(Ad arg0, ErrorCode arg1) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void onLeaveApplication(Ad arg0) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void onPresentScreen(Ad arg0) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void onReceiveAd(Ad arg0) {
				// TODO Auto-generated method stub
				
			}
 
        });
        
        deviceId = ((TelephonyManager) this.getSystemService( Context.TELEPHONY_SERVICE )).getDeviceId();
        Log.d("tgs","deviceId = "+deviceId);
        Functions.init(this);
     // Create and load the AdView.
      
        adView = new AdView(this,com.google.ads.AdSize.BANNER,adBarUnitId);
       
        //adView = new AdView(this);
     //   adView.setAdUnitId("ca-app-pub-2340084892588583/7478309757");
      //  adView.setAdUnitId(adBarUnitId);
      //  adView.setAdSize(AdSize.SMART_BANNER);
      
         
        Parse.initialize(this, "SKo0KdiWLhAjNLjSyWGaZTiXqO0xcgroHAYNYZe8", "vsEn3h52xpAIwJnvIcTfyzaMAsbRvifXfsDHyMpG");
        //ParseInstallation.getCurrentInstallation().saveInBackground();
        if(nativeIsLandScape()) {
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
        } else {
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT);
        }
       
      
        // Add adView to the bottom of the screen.
        FrameLayout.LayoutParams adParams = new FrameLayout.LayoutParams(
                LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);
        
        mFrameLayout.setPadding(0, mFrameLayout.getPaddingTop(), 0, mFrameLayout.getPaddingBottom());
        mFrameLayout.addView(adView,adParams);
        
        //this.showBanner();
        //2.Set the format of window
        
        // Check the wifi is opened when the native is debug.
        if(nativeIsDebug())
        {
            getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
            if(!isNetworkConnected())
            {
                AlertDialog.Builder builder=new AlertDialog.Builder(this);
                builder.setTitle("Warning");
                builder.setMessage("Please open WIFI for debuging...");
                builder.setPositiveButton("OK",new DialogInterface.OnClickListener() {
                    
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        startActivity(new Intent(Settings.ACTION_WIFI_SETTINGS));
                        finish();
                        System.exit(0);
                    }
                });

                builder.setNegativeButton("Cancel", null);
                builder.setCancelable(true);
                builder.show();
            }
            hostIPAdress = getHostIpAddress();
        }
        doSdkLogin(false);
    }
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data)
    {
       if( pay.onActivityResult(requestCode, resultCode, data))
       {
    	   super.onActivityResult(requestCode, resultCode, data);  
       }
       callbackManager.onActivityResult(requestCode, resultCode, data);
         
      
        
    }
    /**
     * 生成调用360SDK登录接口的Intent
     * @param isLandScape 是否横屏
     * @return intent
     */
    private Intent getLoginIntent(boolean isLandScape) {

        Intent intent = new Intent(this, ContainerActivity.class);

        // 界面相关参数，360SDK界面是否以横屏显示。
        intent.putExtra(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);

        // 必需参数，使用360SDK的登录模块。
        intent.putExtra(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_LOGIN);
 
        return intent;
    }
    private void getUserInfo() {

        isAccessTokenValid = true;
        isQTValid = true;
        final QihooUserInfoTask mUserInfoTask = QihooUserInfoTask.newInstance();
      
        // 提示用户进度
        final ProgressDialog progress = ProgressUtil.show(this,
                "获取Qihoo UserInfo",
                "正在请求应用服务器,请稍候……",
                new OnCancelListener() {

                    @Override
                    public void onCancel(DialogInterface dialog) {
                        if (mUserInfoTask != null) {
                            mUserInfoTask.doCancel();
                        }
                    }
                });
       String key = Matrix.getAppKey(this);
       Log.d("key = ", key);
        // 请求应用服务器，用AccessToken换取UserInfo
        mUserInfoTask.doRequest(this, mAccessToken, Matrix.getAppKey(this), new QihooUserInfoListener() {

            @Override
            public void onGotUserInfo(QihooUserInfo userInfo) {
                progress.dismiss();
                if (null == userInfo || !userInfo.isValid()) {
                	
                   // Toast.makeText(this, "从应用服务器获取用户信息失败", Toast.LENGTH_LONG).show();
                } else {
                    this.onGotUserInfo(userInfo);
                }
            }
        });
    }
    private boolean isCancelLogin(String data) {
        try {
            JSONObject joData = new JSONObject(data);
            int errno = joData.optInt("errno", -1);
            if (-1 == errno) {
                Toast.makeText(this, data, Toast.LENGTH_LONG).show();
                return true;
            }
        } catch (Exception e) {}
        return false;
    }
    // ---------------------------------360SDK接口的回调-----------------------------------

    private String parseAccessTokenFromLoginResult(String loginRes) {
        try {

            JSONObject joRes = new JSONObject(loginRes);
            JSONObject joData = joRes.getJSONObject("data");
            return joData.getString("access_token");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 登录、注册的回调
    private IDispatcherCallback mLoginCallback = new IDispatcherCallback() {

        @Override
        public void onFinished(String data) {
            // press back
            if (isCancelLogin(data)) {
                return;
            }
            // 显示一下登录结果
            //Toast.makeText(this, data, Toast.LENGTH_LONG).show();
            mIsInOffline = false;
            mQihooUserInfo = null;
//            Log.d(TAG, "mLoginCallback, data is " + data);
            // 解析access_token
            mAccessToken = parseAccessTokenFromLoginResult(data);

            if (!TextUtils.isEmpty(mAccessToken)) {
                // 需要去应用的服务器获取用access_token获取一下带qid的用户信息
                getUserInfo();
            } else {
                //Toast.makeText(this, "get access_token failed!", Toast.LENGTH_LONG).show();
            }
        }
    };


    private IDispatcherCallback mLoginCallbackSupportOffline = new IDispatcherCallback() {

        @Override
        public void onFinished(String data) {
            if (isCancelLogin(data)) {
                return;
            }

//            Log.d(TAG, "mLoginCallbackSupportOffline, data is " + data);
            try {
                JSONObject joRes = new JSONObject(data);
                JSONObject joData = joRes.getJSONObject("data");
                String mode = joData.optString("mode", "");
                if (!TextUtils.isEmpty(mode) && mode.equals("offline")) {
                   // Toast.makeText(this, "login success in offline mode", Toast.LENGTH_SHORT).show();
                    mIsInOffline = true;
                    // 显示一下登录结果
                    //Toast.makeText(this, data, Toast.LENGTH_LONG).show();
                } else {
                    mLoginCallback.onFinished(data);
                }
            } catch (Exception e) {
                Log.e("e", "mLoginCallbackSupportOffline exception", e);
            }

        }
    };
    /**
     * 使用360SDK的登录接口
     *
     * @param isLandScape 是否横屏显示登录界面
     */
    protected void doSdkLogin(boolean isLandScape) {
        mIsInOffline = false;
        Intent intent = getLoginIntent(isLandScape);
        IDispatcherCallback callback = mLoginCallback;
      
        Matrix.execute(this, intent, callback);
    }

    public void facebookLogin(int luaFunc)
    {
    	this.luaFunc = luaFunc;
//    	LoginManager.getInstance().logInWithPublishPermissions(this, Arrays.asList("public_profile", "user_friends"));
    	//LoginManager.getInstance().logInWithReadPermissions(this, Arrays.asList("public_profile", "user_friends"));

    
    }
    public void showBanner() {
    	
    	  adView.setVisibility(View.VISIBLE);
    	  adView.loadAd(new AdRequest());
    	  
//    	  adView.loadAd(new AdRequest.Builder()
//    	      .addTestDevice(AdRequest.DEVICE_ID_EMULATOR)
//    	       //.addTestDevice(deviceId)
//    	      .build());
    	}
    public void hideBanner() {
    	  adView.setVisibility(View.GONE);
    	}
    private boolean isNetworkConnected() {
            ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);  
            if (cm != null) {  
                NetworkInfo networkInfo = cm.getActiveNetworkInfo();  
            ArrayList networkTypes = new ArrayList();
            networkTypes.add(ConnectivityManager.TYPE_WIFI);
            try {
                networkTypes.add(ConnectivityManager.class.getDeclaredField("TYPE_ETHERNET").getInt(null));
            } catch (NoSuchFieldException nsfe) {
            }
            catch (IllegalAccessException iae) {
                throw new RuntimeException(iae);
            }
            if (networkInfo != null && networkTypes.contains(networkInfo.getType())) {
                    return true;  
                }  
            }  
            return false;  
        } 
     
    public String getHostIpAddress() {
        WifiManager wifiMgr = (WifiManager) getSystemService(WIFI_SERVICE);
        WifiInfo wifiInfo = wifiMgr.getConnectionInfo();
        int ip = wifiInfo.getIpAddress();
        return ((ip & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF));
    }
    
    public static String getLocalIpAddress() {
        return hostIPAdress;
    }

//    @Override
//    protected void onDestroy() {
//    	pay.onDestroy();
//        super.onDestroy();
//    }

    private static native boolean nativeIsLandScape();
    private static native boolean nativeIsDebug();
    
    
    
    
    
    
    
    
    //invite
    public void inviteDialog(String title,String msg)
    { 
    	 
    	if(GameRequestDialog.canShow())
    	{
    		 GameRequestContent content = new GameRequestContent.Builder()
             .setMessage(msg)
             .setTitle(title) 
             //.setActionType(ActionType.SEND)
             .build();
             requestDialog.show(content);
    	}
    	
    }
    
    
    
    //facebook 
    public void postDialog()  
    {  
    	
    	if (ShareDialog.canShow(ShareLinkContent.class)) {
    	    ShareLinkContent linkContent = new ShareLinkContent.Builder()
    	          //.setContentTitle("Hello Facebook")
    	          //.setContentDescription(
    	          //       "The 'Hello Facebook' sample  showcases simple Facebook integration")
    	            .setContentUrl(Uri.parse("http://www.iapploft.net"))
    	            .setImageUrl(Uri.parse("https://secure.gravatar.com/avatar/12af64b0dc1a159f4009293ecf2cf87b?size=220&default=https%3A%2F%2Fwww.parse.com%2Fimages%2Faccounts%2Fno_avatar.png"))
    	            .build();
    	    
    	    shareDialog.show(linkContent);
    	}
      
    }  
    
}
