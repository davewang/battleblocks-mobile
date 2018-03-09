package net.iapploft.games.battletetris;

import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import net.iapploft.games.battletetris.util.IabHelper;
import net.iapploft.games.battletetris.util.IabResult;
import net.iapploft.games.battletetris.util.Inventory;
import net.iapploft.games.battletetris.util.Purchase;
import net.iapploft.games.battletetris.util.SkuDetails;
import android.app.Activity;
import android.app.AlertDialog;

import android.content.Intent;
import android.os.Handler;
import android.util.Log;


 
public class GooglePlayPurchase {

	static final String TAG = "googlePlay-inapp purchase";
	public Activity m_Activity;
	
    private boolean iap_is_ok;
    
	IabHelper mHelper;

    // Does the user have the premium upgrade?
    boolean mIsPremium = false;
    
    // Does the user have an active subscription to the infinite gas plan?
    boolean mSubscribedToInfiniteGas = false;
    

    private String SKU_Current;//当前的sku 即productID
    private int lua_Func;
 // (arbitrary) request code for the purchase flow
    public static final int RC_REQUEST=10001;
    
    private String payload="net.iapploft.games.battletetris";//这里是你的package,在Manifest里别忘了替换成自己的哈
    
//    private ProgressDialog mProgressDialog = null;
    
	private static GooglePlayPurchase m_instance = null;
	public static GooglePlayPurchase instance ()
	{
		if (m_instance == null)
		{
			m_instance = new GooglePlayPurchase();
		}
		
		return m_instance;
	}
	 
	/**
	 * 在自己的activity 的onActivityResult里调用此方法
	 * @param requestCode
	 * @param resultCode
	 * @param data
	 */
	 public boolean onActivityResult(int requestCode, int resultCode, Intent data)
	 {
		 Log.d(TAG, "onActivityResult(" + requestCode + "," + resultCode + "," + data);
         
		 if(!mHelper.handleActivityResult(requestCode, resultCode, data)) {
//			 super.onActivityResult(requestCode, resultCode, data);
            // 如果助手类没有处理该结果，则要自己手动处理
            // 写处理代码 ...
            // ...
           return true;
		 } else {
			 Log.d(TAG, "onActivityResult结果已被IABUtil处理.");
			 return false;
		 }
	 }
	
	void complain(final String message) {
        Log.e(TAG, "**** Battle Blocks Error: " + message);
        m_Activity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
		        alert("Error: " + message);
			}
		});
        
    }
	
	void alert(final String message) {
		 m_Activity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
		        AlertDialog.Builder bld = new AlertDialog.Builder(m_Activity);
		        bld.setMessage(message);
		        bld.setNeutralButton("OK", null);
		        Log.d(TAG, "Showing alert dialog: " + message);
		        bld.create().show();
			}
		});
    }
	/**
	 * 
	 * @param 在自己的activity 的onCreate里调用此方法
	 */
	public void initGoogleData(Activity activity)
    {
		m_Activity = activity;
    	iap_is_ok = false;
    	SKU_Current = "";
    	//SKU_Current = "android.test.purchased";
        String base64EncodedPublicKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAhwexxK718YveOV/U+tI9VF41XiB93OOLYUJcwH8YJ+U3LjdmhFvUQC0A9u+Q81dkexvIzgJLFGvdFG8bWBLbiMc8YF4iGIYQZoEmBIrWxeAIr5X2H1/o8ODuqf2uFB5HhVyVmw9IztXv25B96YQJsPXfgoKZDFl1LbfC5AU/9SY07GyesYri1cdq41Icc/sdK9CS76IqVLm5HKoSvw5mRw59nVi8/gOy447DByVLOkPQ2Z9GncbrAvoUBT0UQOFI31ZvxESnOHZfNIxcEGsBLphby9DuKAGLe4kd0c1VSgQ2Ylh54QWGgNNnd+UY0Mb1NszUkxivmz0kxKGlTByGGQIDAQAB"; 
    	//String base64EncodedPublicKey = m_Activity.getResources().getString(R.string.base64EncodedPublicKey);;//此处填写自己的publicKey
    	// 开始初始化
        Log.d(TAG, "创建IAB helper...");
        mHelper = new IabHelper(m_Activity, base64EncodedPublicKey);
        // enable debug logging (for a production application, you should set this to false).
        mHelper.enableDebugLogging(true);
        // will be called once setup completes.
        Log.d(TAG, "Starting setup.");
        mHelper.startSetup(new IabHelper.OnIabSetupFinishedListener() {
            public void onIabSetupFinished(IabResult result) {
            	Log.d(TAG, "初化完成.");
                if (!result.isSuccess()) {
                    // Oh noes, there was a problem.
                    Log.e(TAG, "Problem setting up in-app billing: " + result);
                	//alert("Error: Problem setting up in-app billing: " + result);
                    return;
                }
                iap_is_ok = true;
                // Hooray, IAB is fully set up. Now, let's get an inventory of stuff we own.
                Log.d(TAG, "初始化in-app biling成功. 查询我们已购买的物品..");
                //mHelper.queryInventoryAsync(iap_is_ok, mGotInventoryListener);
            }
        });
    }
	public void buy(String pid, int luaFunc) {
		// TODO Auto-generated method stub
		Log.d(TAG, "googlePlay productID is: " + pid);
		lua_Func = luaFunc ;
		if (iap_is_ok && mHelper != null) 
    	{
    		SKU_Current = pid;
    		mHelper.queryInventoryAsync(iap_is_ok, mGotInventoryListener);
    		
    		//mHelper.launchPurchaseFlow(m_Activity, SKU_Current, RC_REQUEST, mPurchaseFinishedListener, payload);
    	}else
    	{
    		new Handler(m_Activity.getMainLooper()).post(new Runnable() {
                @Override
                public void run() {
                	String result = "{\"success\":\"no\"}";
    		        Log.d(TAG, "Google Play init failed,You can't pay now,Make sure your area support Google Play or restart game again! " );
    		    	Cocos2dxLuaJavaBridge.callLuaFunctionWithString(lua_Func, result);
    		  		//Cocos2dxLuaJavaBridge.releaseLuaFunction(lua_Func);
                    // 在这里执行你要想的操作 比如直接在这里更新ui或者调用回调在 在回调中更新ui
                	complain("Google Play init failed,You can't pay now,Make sure your area support Google Play or restart game again!");
                }
            });
    		
    	}
		
	}
	// buy 之前 先查是否拥有
//	 
//	 public void buy (String pid)
//		{
//	    	Log.d(TAG, "googlePlay productID is: " + pid);
//	    	if (iap_is_ok && mHelper != null) 
//	    	{
//	    		SKU_Current = pid;
//	    		mHelper.queryInventoryAsync(iap_is_ok, mGotInventoryListener);
//	    		
//	    		//mHelper.launchPurchaseFlow(m_Activity, SKU_Current, RC_REQUEST, mPurchaseFinishedListener, payload);
//	    	}
//	    	else 	
//	    	{
//	            new Handler(m_Activity.getMainLooper()).post(new Runnable() {
//	                @Override
//	                public void run() {
//	                    // 在这里执行你要想的操作 比如直接在这里更新ui或者调用回调在 在回调中更新ui
//	                	complain("Google Play init failed,You can't pay now,Make sure your area support Google Play or restart game again!");
//	                }
//	            });
//	    	}
//
//		}
	
	 // Enables or disables the "please wait" screen.
    void setWaitScreen(boolean set) {
    	//可以做你自己的waiting screen
    }
    
	// Listener that's called when we finish querying the items and subscriptions we own
    IabHelper.QueryInventoryFinishedListener mGotInventoryListener = new IabHelper.QueryInventoryFinishedListener() {
        public void onQueryInventoryFinished(IabResult result, Inventory inventory) {
        	Log.d(TAG, "查询操作完成");
            if(result.isFailure()) {
               
                
                new Handler(m_Activity.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                    	String result = "{\"success\":\"no\"}";
        		        //Log.d(TAG, "Google Play init failed,You can't pay now,Make sure your area support Google Play or restart game again! " );
        		    	Cocos2dxLuaJavaBridge.callLuaFunctionWithString(lua_Func, result);
        		  		//Cocos2dxLuaJavaBridge.releaseLuaFunction(lua_Func);
        		  	    complain("Failed to query inventory:" + result);
                        // 在这里执行你要想的操作 比如直接在这里更新ui或者调用回调在 在回调中更新ui
                    	//complain("Google Play init failed,You can't pay now,Make sure your area support Google Play or restart game again!");
                    }
                });
                
                return;
            }
            Log.d(TAG, "查询成功！");
            // 因为SKU_GAS是可重复购买的产品，查询我们的已购买的产品，
            // 如果当中有SKU_GAS，我们应该立即消耗它，以方便下次可以重复购买。

            SkuDetails skuDetails=inventory.getSkuDetails(SKU_Current);// 
            if(skuDetails != null) {
            	Log.d(TAG, "skuDetails my:" + skuDetails);
                //System.out.println("skuDetails my:" + skuDetails);
            }

            Purchase gasPurchase=inventory.getPurchase(SKU_Current);
            if(gasPurchase != null && verifyDeveloperPayload(gasPurchase)) {
                Log.d(TAG, SKU_Current);
                Log.d(TAG, "属于SKU_Curent");
                mHelper.consumeAsync(inventory.getPurchase(SKU_Current), mConsumeFinishedListener);
                return;
            }else{
            	mHelper.launchPurchaseFlow(m_Activity, SKU_Current, RC_REQUEST, mPurchaseFinishedListener, payload);
        	    
            	
            }
           
            
            Log.d(TAG, "查询完成; 接下来可以操作UI线程了..");
           // updateUi();
          //  setWaitScreen(false);
            Log.d(TAG, "Initial inventory query finished; enabling main UI.");
        }
    };
    
    /** Verifies the developer payload of a purchase. */
    boolean verifyDeveloperPayload(Purchase p) {
        payload = p.getDeveloperPayload();
        Log.d(TAG, payload);
        Log.d(TAG,"p.getDeveloperPayload(): " + p.getDeveloperPayload());
//        if(payload.equalsIgnoreCase(p.getDeveloperPayload())) {
//
//            return true;
//        }
//
//        return false;
        /*
         * TODO: verify that the developer payload of the purchase is correct. It will be
         * the same one that you sent when initiating the purchase.
         *
         * WARNING: Locally generating a random string when starting a purchase and
         * verifying it here might seem like a good approach, but this will fail in the
         * case where the user purchases an item on one device and then uses your app on
         * a different device, because on the other device you will not have access to the
         * random string you originally generated.
         *
         * So a good developer payload has these characteristics:
         *
         * 1. If two different users purchase an item, the payload is different between them,
         *    so that one user's purchase can't be replayed to another user.
         *
         * 2. The payload must be such that you can verify it even when the app wasn't the
         *    one who initiated the purchase flow (so that items purchased by the user on
         *    one device work on other devices owned by the user).
         *
         * Using your own server to store and verify developer payloads across app
         * installations is recommended.
         */

        return true;
    }
    
    /* Called when consumption is complete
     * 如果是消耗品的话 需要调用消耗方法
     */
    IabHelper.OnConsumeFinishedListener mConsumeFinishedListener = new IabHelper.OnConsumeFinishedListener() {
        public void onConsumeFinished(Purchase purchase, IabResult result) {
            Log.d(TAG, "Consumption finished. Purchase: " + purchase + ", result: " + result);

            // if we were disposed of in the meantime, quit.
            if (mHelper == null) return;

            if (result.isSuccess()) {
                // successfully consumed, so we apply the effects of the item in our
	
                Log.d(TAG, "Consumption successful.");
                
                new Handler(m_Activity.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                    	
                    	String result = "{\"success\":\"yes\",\"pid\":\""+SKU_Current+"\"}";
        		    	Cocos2dxLuaJavaBridge.callLuaFunctionWithString(lua_Func, result);
        		  		//Cocos2dxLuaJavaBridge.releaseLuaFunction(lua_Func);
        		    }
                });
            }  

            else {
                //complain("Error while consuming: " + result);
                //setWaitScreen(false);
            	  Log.d(TAG, "Consumption Failure.");
            	  new Handler(m_Activity.getMainLooper()).post(new Runnable() {
                      @Override
                      public void run() {
                      	String result = "{\"success\":\"no\"}";
           		    	Cocos2dxLuaJavaBridge.callLuaFunctionWithString(lua_Func, result);
          		  		//Cocos2dxLuaJavaBridge.releaseLuaFunction(lua_Func);
          		  	    complain("Consumption Failure." );
                          // 在这里执行你要想的操作 比如直接在这里更新ui或者调用回调在 在回调中更新ui
                      	//complain("Google Play init failed,You can't pay now,Make sure your area support Google Play or restart game again!");
                      }
                  });
            }
           // updateUi();
            Log.d(TAG, "End consumption flow.");
        }
    };
    
    /* Called when consumption is complete
     * 如果是消耗品的话 需要调用消耗方法
     */
    IabHelper.OnConsumeFinishedListener mInitConsumeFinishedListener = new IabHelper.OnConsumeFinishedListener() {
        public void onConsumeFinished(Purchase purchase, IabResult result) {
            Log.d(TAG, "Consumption finished. Purchase: " + purchase + ", result: " + result);

            // if we were disposed of in the meantime, quit.
            if (mHelper == null) return;
            if (result.isSuccess()) {
                // successfully consumed, so we apply the effects of the item in our
                Log.d(TAG, "init Consumption successful.");
            }  

            else {
            	Log.d(TAG, "init Error while consuming: " + result);
            }

            Log.d(TAG, "End init consumption flow.");
        }
    };
    
 // updates UI to reflect model
    public void updateUi() {
    	
    }
    
    
    /* Callback for when a purchase is finished
     * 购买成功处理
     */
    IabHelper.OnIabPurchaseFinishedListener mPurchaseFinishedListener=new IabHelper.OnIabPurchaseFinishedListener() {

        public void onIabPurchaseFinished(IabResult result, Purchase purchase) {
            Log.d(TAG, "购买操作完成: " + result + ", 购买的产品: " + purchase);
            int response=result.getResponse();
            if(result.isFailure()) {
               
                //setWaitScreen(false);
                
                new Handler(m_Activity.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                    	String result = "{\"success\":\"no\"}";
        		    	Cocos2dxLuaJavaBridge.callLuaFunctionWithString(lua_Func, result);
        		  		//Cocos2dxLuaJavaBridge.releaseLuaFunction(lua_Func);
        		  	    complain("Error purchasing.");
        		    }
                });
                return;
            }
            if(!verifyDeveloperPayload(purchase)) {
               
                //setWaitScreen(false);
                
                new Handler(m_Activity.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                    	String result = "{\"success\":\"no\"}";
        		    	Cocos2dxLuaJavaBridge.callLuaFunctionWithString(lua_Func, result);
        		  		//Cocos2dxLuaJavaBridge.releaseLuaFunction(lua_Func);
        		  	    complain("fail verify.");
        		    }
                });
                return;
            }

            Log.d(TAG, "购买成功.");

            if(purchase.getSku().equals(SKU_Current)) {

//            	String purchaseData = purchase.toString();
                
                Log.d(TAG, "购买的产品是消耗品， 执行消耗操作。");
                mHelper.consumeAsync(purchase, mConsumeFinishedListener);
            }
        }
    };
    
//    public void buy (String pid)
//	{
//    	Log.d(TAG, "googlePlay productID is: " + pid);
//    	if (iap_is_ok) 
//    	{
//    		SKU_Current = pid;
//    		mHelper.launchPurchaseFlow(m_Activity, SKU_Current, RC_REQUEST, mPurchaseFinishedListener, payload);
//    	}
//    	else 	
//    	{
//            new Handler(m_Activity.getMainLooper()).post(new Runnable() {
//                @Override
//                public void run() {
//                    // 在这里执行你要想的操作 比如直接在这里更新ui或者调用回调在 在回调中更新ui
//                	complain("Google Play init failed,You can't pay now,Make sure your area support Google Play or restart game again!");
//                }
//            });
//    	}
//
//	}
    
	public void onDestroy ()
	{
		if (mHelper != null) {
			mHelper.dispose();
			mHelper = null;
		}
	}
	
	public boolean canMakePayMent()
	{
		return iap_is_ok;
	}

	

}
