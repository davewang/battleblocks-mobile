
package org.cocos2dx.lua;

import com.qihoo.gamecenter.sdk.activity.ContainerActivity;
import com.qihoo.gamecenter.sdk.common.IDispatcherCallback; 
 
import com.qihoo.gamecenter.sdk.matrix.Matrix;
import com.qihoo.gamecenter.sdk.protocols.ProtocolConfigs;
import com.qihoo.gamecenter.sdk.protocols.ProtocolKeys;

import net.iapploft.games.blocks.R;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnCancelListener;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Toast;

/**
 * SdkUserBaseActivity这个基类，处理请求360SDK
 */
public abstract class SdkUserBaseActivity extends Activity{

    private static final String TAG = "SdkUserBaseActivity";

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

    public void onGotUserInfo(QihooUserInfo userInfo) {
    	Log.d("dave", userInfo.getId());
              
    }

    private void getUserInfo() {

        isAccessTokenValid = true;
        isQTValid = true;
        final QihooUserInfoTask mUserInfoTask = QihooUserInfoTask.newInstance();
       
        // 提示用户进度
        final ProgressDialog progress = ProgressUtil.show(this,
                R.string.get_user_title,
                R.string.get_user_message,
                new OnCancelListener() {

                    @Override
                    public void onCancel(DialogInterface dialog) {
                        if (mUserInfoTask != null) {
                            mUserInfoTask.doCancel();
                        }
                    }
                });

        // 请求应用服务器，用AccessToken换取UserInfo
        mUserInfoTask.doRequest(this, mAccessToken, Matrix.getAppKey(this), new QihooUserInfoListener() {

            @Override
            public void onGotUserInfo(QihooUserInfo userInfo) {
                progress.dismiss();
                if (null == userInfo || !userInfo.isValid()) {
                    Toast.makeText(SdkUserBaseActivity.this, "从应用服务器获取用户信息失败", Toast.LENGTH_LONG).show();
                } else {
                    SdkUserBaseActivity.this.onGotUserInfo(userInfo);
                }
            }
        });
    }

    // 获取用来在demo上显示登录结果的字符串
    protected String getLoginResultText() {
        String result = "";

        try {
            if (mQihooUserInfo != null && mQihooUserInfo.isValid()) {
                JSONObject joUserInfo = new JSONObject();
                JSONObject joUserInfoData = new JSONObject();
                joUserInfo.put("data", joUserInfoData);
                joUserInfoData.put("name", mQihooUserInfo.getName());
                joUserInfoData.put("id", mQihooUserInfo.getId());
                joUserInfoData.put("avatar", mQihooUserInfo.getAvatar());
                joUserInfo.put("error_code", 0);
                result = "TokenInfo=" + mAccessToken +"\n\n" + "QihooUserInfo=" + joUserInfo.toString();
            }
        } catch (Throwable tr) {
            tr.printStackTrace();
        }

        return result;
    }

    // ---------------------------------调用360SDK接口------------------------------------

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // 调用其他SDK接口之前必须先调用init
        // 注意：参数一定是主界面对应activity的context，我们依赖这个activity来显示浮窗的，
        //       还有就是这个activity的manifest属性里添加android:configChanges="orientation|keyboardHidden|screenSize"
        //       为了防止横竖屏切换时此activity重新创建，引起的一些问题。
        Matrix.init(this);
    }

    @Override
    protected void onDestroy() {
        // 游戏退出前，不再调用SDK其他接口时，需要调用Matrix.destroy接口
        onDemoActivityDestroy(true);
    }

    protected void onDemoActivityDestroy(boolean releaseSdk) {
        // 请务必调用Matrix.destroy接口，
        // 如果不调用此接口，某些机型会发生窗口泄漏问题。
        if (releaseSdk) {
            Matrix.destroy(this);
        }
        super.onDestroy();
    }

    /*
     * 当用户要退出游戏时，需要调用SDK的退出接口。
     */
//    @Override
//    public boolean onKeyDown(int keyCode, KeyEvent event) {
//        switch (keyCode) {
//            case KeyEvent.KEYCODE_BACK:
//                doSdkQuit(mIsLandscape);
//                return true;
//            default:
//                return super.onKeyDown(keyCode, event);
//        }
//    }

    /**
     * 使用360SDK的登录接口
     *
     * @param isLandScape 是否横屏显示登录界面
     */
     void doSdkLogin(boolean isLandScape) {
        mIsInOffline = false;
        Intent intent = getLoginIntent(isLandScape);
        IDispatcherCallback callback = mLoginCallback;
         
        Matrix.execute(this, intent, callback);
    }
 
    // -----------------------------------登录选项-------------------------------------

    private boolean getCheckBoxBoolean(int id) {
        CheckBox cb = (CheckBox)findViewById(id);
        if (cb != null) {
            return cb.isChecked();
        }
        return false;
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

    /***
     * 生成调用360SDK切换账号接口的Intent
     *
     * @param isLandScape 是否横屏
     * @return Intent
     */
    private Intent getSwitchAccountIntent(boolean isLandScape) {

        Intent intent = new Intent(this, ContainerActivity.class);

        // 必须参数，360SDK界面是否以横屏显示。
        intent.putExtra(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);

        // 必需参数，使用360SDK的切换账号模块。
        intent.putExtra(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_SWITCH_ACCOUNT);

       

        /*
         * 指定界面背景（可选参数）：
         *  1.ProtocolKeys.UI_BACKGROUND_PICTRUE 使用的系统路径，如/sdcard/1.png
         *  2.ProtocolKeys.UI_BACKGROUND_PICTURE_IN_ASSERTS 使用的assest中的图片资源，
         *    如传入bg.png字符串，就会在assets目录下加载这个指定的文件
         *  3.图片大小不要超过5M，尺寸不要超过1280x720
         */
       
         
       

        return intent;
    }

    // ---------------------------------360SDK接口的回调-----------------------------------

    // 登录、注册的回调
    private IDispatcherCallback mLoginCallback = new IDispatcherCallback() {

        @Override
        public void onFinished(String data) {
            // press back
            if (isCancelLogin(data)) {
                return;
            }
            // 显示一下登录结果
            Toast.makeText(SdkUserBaseActivity.this, data, Toast.LENGTH_LONG).show();
            mIsInOffline = false;
            mQihooUserInfo = null;
//            Log.d(TAG, "mLoginCallback, data is " + data);
            // 解析access_token
            mAccessToken = parseAccessTokenFromLoginResult(data);

            if (!TextUtils.isEmpty(mAccessToken)) {
                // 需要去应用的服务器获取用access_token获取一下带qid的用户信息
                getUserInfo();
            } else {
                Toast.makeText(SdkUserBaseActivity.this, "get access_token failed!", Toast.LENGTH_LONG).show();
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
                    Toast.makeText(SdkUserBaseActivity.this, "login success in offline mode", Toast.LENGTH_SHORT).show();
                    mIsInOffline = true;
                    // 显示一下登录结果
                    Toast.makeText(SdkUserBaseActivity.this, data, Toast.LENGTH_LONG).show();
                } else {
                    mLoginCallback.onFinished(data);
                }
            } catch (Exception e) {
                Log.e(TAG, "mLoginCallbackSupportOffline exception", e);
            }

        }
    };

    // 切换账号的回调
    private IDispatcherCallback mAccountSwitchCallback = new IDispatcherCallback() {

        @Override
        public void onFinished(String data) {
            // press back
            if (isCancelLogin(data)) {
                return;
            }

            // 显示一下登录结果
            Toast.makeText(SdkUserBaseActivity.this, data, Toast.LENGTH_LONG).show();

//            Log.d(TAG, "mAccountSwitchCallback, data is " + data);
            // 解析access_token
            mAccessToken = parseAccessTokenFromLoginResult(data);

            if (!TextUtils.isEmpty(mAccessToken)) {
                // 需要去应用的服务器获取用access_token获取一下带qid的用户信息
                getUserInfo();
            } else {
                Toast.makeText(SdkUserBaseActivity.this, "get access_token failed!", Toast.LENGTH_LONG).show();
            }
        }
    };

    // 支持离线模式的切换账号的回调
    private IDispatcherCallback mAccountSwitchSupportOfflineCB = new IDispatcherCallback() {

        @Override
        public void onFinished(String data) {
            // press back
            if (isCancelLogin(data)) {
                return;
            }
            // 显示一下登录结果
            Toast.makeText(SdkUserBaseActivity.this, data, Toast.LENGTH_LONG).show();
//            Log.d(TAG, "mAccountSwitchSupportOfflineCB, data is " + data);
            // 解析access_token
            mAccessToken = parseAccessTokenFromLoginResult(data);

            if (!TextUtils.isEmpty(mAccessToken)) {
                // 登录结果直接返回的userinfo中没有qid，需要去应用的服务器获取用access_token获取一下带qid的用户信息
                getUserInfo();
            } else {
                Toast.makeText(SdkUserBaseActivity.this, "get access_token failed!", Toast.LENGTH_LONG).show();
            }
        }
    };

    private boolean isCancelLogin(String data) {
        try {
            JSONObject joData = new JSONObject(data);
            int errno = joData.optInt("errno", -1);
            if (-1 == errno) {
                Toast.makeText(SdkUserBaseActivity.this, data, Toast.LENGTH_LONG).show();
                return true;
            }
        } catch (Exception e) {}
        return false;
    }

    // ------------------------获取社交服务器初始化信息接口--------------
    protected void doSDKGetSocialInitInfo(QihooUserInfo usrInfo) {
        if (!checkLoginInfo(usrInfo)) {
            return;
        }

        Intent intent = getSocialInitInfoIntent();
        Matrix.execute(this, intent, new IDispatcherCallback() {

            @Override
            public void onFinished(String data) {
                Toast.makeText(SdkUserBaseActivity.this, data, Toast.LENGTH_SHORT).show();
            }
        });
    }

    private Intent getSocialInitInfoIntent() {
        Intent intent = new Intent();
        // function_code : 必须参数，表示调用SDK接口执行的功能为获取社交模块初始化信息
        intent.putExtra(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_GET_SOCIAL_INIT_INFO);
        return intent;
    }

     
 
     

  
    


    private Intent getShareIntent(String title, String desc, String picture, String icon, String uibg, boolean isLandScape){

        Intent intent = new Intent();

        /*
         * 必须参数：
         *  function_code : 必须参数，标识通知SDK要执行的功能
         *  screen_orientation: 可选参数，指定横竖屏，默认为横屏
         *  ui_background_picture: 可选参数，分享界面的背景图，不传就是透明
         *  share_title: 必须参数，分享的标题
         *  share_desc: 必须参数，分享的描述
         *  share_pic: 可选参数，分享的图片路径（必须是本地路径如：/sdcard/1.png，后缀可以是png、jpg、jpeg，大小不能超过5M，尺寸不能超过1280x720）
         *  share_icon: 可选参数，分享的icon路径（必须是本地路径，最好是png文件，32k以内）
        */
        intent.putExtra(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_SHARE);
        intent.putExtra(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);
        if (!TextUtils.isEmpty(uibg)) {
            intent.putExtra(ProtocolKeys.UI_BACKGROUND_PICTRUE, uibg);
        }
        intent.putExtra(ProtocolKeys.SHARE_TITLE, title);
        intent.putExtra(ProtocolKeys.SHARE_DESC, desc);
        intent.putExtra(ProtocolKeys.SHARE_PIC, picture);
        intent.putExtra(ProtocolKeys.SHARE_ICON, icon);
        return intent;
    }

 // ------------------注销登录----------------
    protected void doSdkLogout(QihooUserInfo usrInfo){
        if(!checkLoginInfo(usrInfo)) {
            return;
        }
        Intent intent = getLogoutIntent();
        Matrix.execute(this, intent, new IDispatcherCallback() {
            @Override
            public void onFinished(String data) {
                Toast.makeText(SdkUserBaseActivity.this, data, Toast.LENGTH_SHORT).show();
//                System.out.println(data);
            }
        });
    }

    private Intent getLogoutIntent(){

        /*
         * 必须参数：
         *  function_code : 必须参数，表示调用SDK接口执行的功能
        */
        Intent intent = new Intent();
        intent.putExtra(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_LOGOUT);
        return intent;
    }

    private boolean checkLoginInfo(QihooUserInfo info){
        if (mIsInOffline) {
            return true;
        }
        if(null == info || !info.isValid()){
            Toast.makeText(this, "需要登录才能执行此操作", Toast.LENGTH_SHORT).show();
            return false;
        }
        return true;
    }
  
  
 
  
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

    protected void doSdkGetUserInfo(QihooUserInfo usrinfo) {
        if (!checkLoginInfo(usrinfo)) {
            return;
        }

        Intent intent = getUserInfoIntent();
        Matrix.execute(this, intent, new IDispatcherCallback() {

            @Override
            public void onFinished(String data) {
//                System.out.println(data);
                Toast.makeText(SdkUserBaseActivity.this, data, Toast.LENGTH_LONG).show();
            }
        });
    }

    private Intent getUserInfoIntent() {
     //   EditText et = (EditText) findViewById(R.id.et_get_user_info);
       // String qid = et.getText().toString();

        Intent intent = new Intent();
        // function code
        intent.putExtra(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_GET_USER_INFO);
        // 用户QID
        //intent.putExtra(ProtocolKeys.QID, qid);

        return intent;
    }

    /**
     * 使用360SDK的论坛接口
     *
     * @param isLandScape 是否横屏显示支付界面
     */
    protected void doSdkBBS(QihooUserInfo usrinfo, boolean isLandScape) {
        if (!checkLoginInfo(usrinfo)) {
            return;
        }

        if (!Utils.isNetAvailable(this)) {
            Toast.makeText(this, "网络不可用", Toast.LENGTH_SHORT).show();
            return;
        }

        Intent intent = getBBSIntent(isLandScape);

        Matrix.invokeActivity(this, intent, null);
    }

    /***
     * 生成调用360SDK论坛接口的Intent
     *
     * @param isLandScape
     * @return Intent
     */
    private Intent getBBSIntent(boolean isLandScape) {

        Bundle bundle = new Bundle();

        // 界面相关参数，360SDK界面是否以横屏显示。
        bundle.putBoolean(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);

        // 必需参数，使用360SDK的论坛模块。
        bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_BBS);

        Intent intent = new Intent(this, ContainerActivity.class);
        intent.putExtras(bundle);

        return intent;
    }

    /**
     * 使用360SDK的退出接口
     *
     * @param isLandScape 是否横屏显示支付界面
     */
    protected void doSdkQuit(boolean isLandScape) {

        Bundle bundle = new Bundle();

        // 界面相关参数，360SDK界面是否以横屏显示。
        bundle.putBoolean(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);

        // 必需参数，使用360SDK的退出模块。
        bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_QUIT);

        // 可选参数，登录界面的背景图片路径，必须是本地图片路径
        bundle.putString(ProtocolKeys.UI_BACKGROUND_PICTRUE, "");

        Intent intent = new Intent(this, ContainerActivity.class);
        intent.putExtras(bundle);

        Matrix.invokeActivity(this, intent, mQuitCallback);
    }

    // 退出的回调
    private IDispatcherCallback mQuitCallback = new IDispatcherCallback() {

        @Override
        public void onFinished(String data) {
//            Log.d(TAG, "mQuitCallback, data is " + data);
            JSONObject json;
            try {
                json = new JSONObject(data);
                int which = json.optInt("which", -1);
                String label = json.optString("label");

                Toast.makeText(SdkUserBaseActivity.this,
                        "按钮标识：" + which + "，按钮描述:" + label, Toast.LENGTH_LONG)
                        .show();

                switch (which) {
                    case 0: // 用户关闭退出界面
                        return;
                    default:// 退出游戏
                        finish();
                        return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

    };

    // 实名注册
    protected void doSdkRealNameRegister(QihooUserInfo usrinfo, boolean isLandScape) {
        if (!checkLoginInfo(usrinfo)) {
            return;
        }
        Intent intent = getRealNameRegisterIntent(isLandScape, (usrinfo != null) ? usrinfo.getId() : null);

        Matrix.invokeActivity(this, intent, new IDispatcherCallback() {
            @Override
            public void onFinished(String data) {
//                Log.d(TAG, "RealNameRegisterCallback, data is " + data);
            }
        });
    }

    private Intent getRealNameRegisterIntent(boolean isLandScape, String qihooUserId) {

        Bundle bundle = new Bundle();
        // 界面相关参数，360SDK界面是否以横屏显示。
        bundle.putBoolean(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);

        // 必需参数，360账号id，整数。
        bundle.putString(ProtocolKeys.QIHOO_USER_ID, qihooUserId);

        // 可选参数，登录界面的背景图片路径，必须是本地图片路径
        bundle.putString(ProtocolKeys.UI_BACKGROUND_PICTRUE, "");

        // 必需参数，使用360SDK的实名注册模块。
        bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_REAL_NAME_REGISTER);

        Intent intent = new Intent(this, ContainerActivity.class);
        intent.putExtras(bundle);
        return intent;
    }

    /**
     * 本方法中的callback实现仅用于测试, 实际使用由游戏开发者自己处理
     *
     * @param accessToken
     * @param userInfo 奇虎360用户信息
     */
    protected void doSdkAntiAddictionQuery(String accessToken, QihooUserInfo userInfo) {

        if (!checkLoginInfo(userInfo)) {
            return;
        }

        Intent intent = getAntAddictionIntent(accessToken, (userInfo != null) ? userInfo.getId() : null);
        Matrix.execute(this, intent, new IDispatcherCallback() {

            @Override
            public void onFinished(String data) {
//                Log.d("demo,anti-addiction query result = ", data);
                if (!TextUtils.isEmpty(data)) {
                    try {
                        JSONObject resultJson = new JSONObject(data);
                        int errorCode = resultJson.optInt("error_code");
                        if (errorCode == 0) {
                            JSONObject contentData = resultJson.getJSONObject("content");
                            if(contentData != null) {
                                // 保存登录成功的用户名及密码
                                JSONArray retData = contentData.getJSONArray("ret");
//                                Log.d(TAG, "ret data = " + retData);
                                if(retData != null && retData.length() > 0) {
                                    int status = retData.getJSONObject(0).optInt("status");
//                                    Log.d(TAG, "status = " + status);
                                    switch (status) {

                                        case 0:  // 查询结果:无此用户数据
                                            Toast.makeText(SdkUserBaseActivity.this,
                                                    getString(R.string.anti_addiction_query_result_0),
                                                    Toast.LENGTH_LONG).show();
                                            break;

                                        case 1:  // 查询结果:未成年
                                            Toast.makeText(SdkUserBaseActivity.this,
                                                    getString(R.string.anti_addiction_query_result_1),
                                                    Toast.LENGTH_LONG).show();
                                            break;

                                        case 2:  // 查询结果:已成年
                                            Toast.makeText(SdkUserBaseActivity.this,
                                                    getString(R.string.anti_addiction_query_result_2),
                                                    Toast.LENGTH_LONG).show();
                                            break;

                                        default:
                                            break;
                                    }
                                    return;
                                }
                            }
                        } else {
                            Toast.makeText(SdkUserBaseActivity.this,
                                    resultJson.optString("error_msg"), Toast.LENGTH_SHORT).show();
                            return;
                        }

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                    Toast.makeText(SdkUserBaseActivity.this,
                            getString(R.string.anti_addiction_query_exception),
                            Toast.LENGTH_LONG).show();
                }
            }
        });
    }

    private Intent getAntAddictionIntent(String token, String qid) {
        Bundle bundle = new Bundle();

        // 必需参数，用户access token，要使用注意过期和刷新问题，最大64字符。
        bundle.putString(ProtocolKeys.ACCESS_TOKEN, token);

        // 必需参数，360账号id，整数。
        bundle.putString(ProtocolKeys.QIHOO_USER_ID, qid);

        // 必需参数，使用360SDK的防沉迷查询模块。
        bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_ANTI_ADDICTION_QUERY);

        Intent intent = new Intent(this, ContainerActivity.class);
        intent.putExtras(bundle);
        return intent;
    }

    /**
     * 本方法中的callback实现仅用于测试, 实际使用由游戏开发者自己处理
     *
     *
     */
    @SuppressLint("NewApi")
    protected void doSdkGameLevelQuery(QihooUserInfo userInfo) {

        if (!checkLoginInfo(userInfo)) {
            return;
        }

        Bundle bundle = new Bundle();

        // 必需参数，使用360SDK的游戏关卡查询
        bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_GAME_LEVEL);

        Intent intent = new Intent(this, ContainerActivity.class);
        intent.putExtras(bundle);
        Matrix.execute(this, intent, new IDispatcherCallback() {

            @Override
            public void onFinished(String data) {
                if (!TextUtils.isEmpty(data)) {
                    try {
                        JSONObject resultJson = new JSONObject(data);
                        int errorCode = resultJson.optInt("errno");
                        if (errorCode == 0) {
                            JSONObject mData = resultJson.getJSONObject("data");
                            if(mData != null) {
                                //用户关卡信息
                                String mContent = mData.optString("content");
                                if(mContent.isEmpty()){
                                    Toast.makeText(SdkUserBaseActivity.this,"没有配置关卡信息", Toast.LENGTH_SHORT).show();
                                }else{
                                    Toast.makeText(SdkUserBaseActivity.this,"关卡信息为:"+mContent, Toast.LENGTH_SHORT).show();
                                }
                                return;
                            }
                        } else {
                            Toast.makeText(SdkUserBaseActivity.this,data, Toast.LENGTH_SHORT).show();
                            return;
                        }

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                    Toast.makeText(SdkUserBaseActivity.this,
                            getString(R.string.anti_addiction_query_exception),
                            Toast.LENGTH_LONG).show();
                }
            }
        });
    }
       
}
