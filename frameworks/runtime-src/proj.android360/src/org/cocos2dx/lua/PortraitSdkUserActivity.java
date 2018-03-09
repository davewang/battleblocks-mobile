
package org.cocos2dx.lua;
 
import com.qihoo.gamecenter.sdk.matrix.Matrix;

import android.app.ProgressDialog;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;
import android.widget.Toast;


public class PortraitSdkUserActivity extends SdkUserBaseActivity implements
        OnClickListener {
    private static final String TAG = "PortraitSdkUserActivity";

    private TextView mLoginResultView;

    private ProgressDialog mProgress;

    @Override
    public void onClick(View v) {
         

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        mIsLandscape = true;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }
 

    private void clearLoginResult() {
        mLoginResultView.setText(null);
        mQihooUserInfo = null;
    }

    @Override
    public void onGotUserInfo(QihooUserInfo userInfo) {
        ProgressUtil.dismiss(mProgress);

        if (userInfo != null && userInfo.isValid()) {
            // 保存QihooUserInfo
            mQihooUserInfo = userInfo;

            // 界面显示QihooUser的Id和Name
            mLoginResultView.setText(getLoginResultText());

        } else {
           // Toast.makeText(this, R.string.get_user_fail, Toast.LENGTH_SHORT).show();
            clearLoginResult();
        }
    }

    /*
     * 当用户要退出游戏时，需要调用SDK的退出接口。
     */
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        switch (keyCode) {
            case KeyEvent.KEYCODE_BACK:
                doSdkQuit(mIsLandscape);
                return true;
            default:
                return super.onKeyDown(keyCode, event);
        }
    }
}
