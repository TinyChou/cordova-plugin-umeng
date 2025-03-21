package com.umeng.plugin;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import android.content.Context;
import android.util.Log;
import com.umeng.analytics.MobclickAgent;
import com.umeng.analytics.MobclickAgent.EScenarioType;
import com.umeng.analytics.dplus.UMADplus;
import com.umeng.analytics.game.UMGameAgent;
import com.umeng.commonsdk.UMConfigure;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by wangfei on 17/9/26.
 */

public class AnalyticsSDK extends CordovaPlugin {
    private Context mContext = null;
    /**
     * 可以设置是否为游戏，如果是游戏会进行初始化
     */
    private boolean isGameInited = false;

    /**
     * 初始化游戏
     */
    private void initGame() {
        UMGameAgent.init(mContext);
        UMGameAgent.setPlayerLevel(1);
        MobclickAgent.setScenarioType(mContext, EScenarioType.E_UM_GAME);
        isGameInited = true;
    }

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        this.mContext = cordova.getActivity();
    }

    @Override
    public void onResume(boolean multitasking) {
        super.onResume(multitasking);

        MobclickAgent.onResume(mContext);
    }

    @Override
    public void onPause(boolean multitasking) {
        super.onPause(multitasking);
        Log.d("UMPlugin", "onPause");
        MobclickAgent.onPause(mContext);
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        Log.d("UMPlugin", "execute action:" + action + "|||args:" + args);
        if (action.equals("init")) {
            String appKey = args.getString(0);
            String channel = args.getString(1);
            PGCommonSDK.setLogEnabled(true);
            PGCommonSDK.init(mContext, appKey, channel, UMConfigure.DEVICE_TYPE_PHONE,
                "bellai2018");
        } else if (action.equals("onEvent")) {
            String eventId = args.getString(0);
            MobclickAgent.onEvent(mContext, eventId);
            return true;
        } else if (action.equals("onEventWithLabel")) {
            String eventId = args.getString(0);
            String label = args.getString(1);
            MobclickAgent.onEvent(mContext, eventId, label);
            return true;
        } else if (action.equals("onEventWithParameters")) {
            String eventId = args.getString(0);
            JSONObject obj = args.getJSONObject(1);
            Map<String, String> map = new HashMap<String, String>();
            Iterator<String> it = obj.keys();
            while (it.hasNext()) {
                String key = String.valueOf(it.next());
                Object o = obj.get(key);
                if (o instanceof Integer) {
                    String value = String.valueOf(o);
                    map.put(key, value);
                } else if (o instanceof String) {
                    String strValue = (String) o;
                    map.put(key, strValue);
                }
            }
            MobclickAgent.onEvent(mContext, eventId, map);
            return true;
        } else if (action.equals("onEventWithCounter")) {
            String eventId = args.getString(0);
            JSONObject obj = args.getJSONObject(1);
            Map<String, String> map = new HashMap<String, String>();
            Iterator<String> it = obj.keys();
            while (it.hasNext()) {
                String key = String.valueOf(it.next());
                Object o = obj.get(key);
                if (o instanceof Integer) {
                    String value = String.valueOf(o);
                    map.put(key, value);
                } else if (o instanceof String) {
                    String strValue = (String) o;
                    map.put(key, strValue);
                }
            }
            int value = args.getInt(2);
            MobclickAgent.onEventValue(mContext, eventId, map, value);
            return true;
        } else if (action.equals("onPageBegin")) {
            String pageName = args.getString(0);
            MobclickAgent.onPageStart(pageName);
            return true;
        } else if (action.equals("onPageEnd")) {
            String pageName = args.getString(0);
            MobclickAgent.onPageEnd(pageName);
            return true;
        } else if (action.equals("getDeviceId")) {
            try {
                android.telephony.TelephonyManager tm = (android.telephony.TelephonyManager) mContext
                    .getSystemService(Context.TELEPHONY_SERVICE);
                String deviceId = tm.getDeviceId();
                callbackContext.success(deviceId);
            } catch (Exception e) {
                e.printStackTrace();
            }
            return true;
        } else if (action.equals("setLogEnabled")) {
            boolean enabled = args.getBoolean(0);
            MobclickAgent.setDebugMode(enabled);
            return true;
        } else if (action.equals("profileSignInWithPUID")) {
            String puid = args.getString(0);
            MobclickAgent.onProfileSignIn(puid);
            return true;
        } else if (action.equals("profileSignInWithPUIDWithProvider")) {
            String puid = args.getString(0);
            String provider = args.getString(1);
            MobclickAgent.onProfileSignIn(puid, provider);
            return true;
        } else if (action.equals("profileSignOff")) {
            MobclickAgent.onProfileSignOff();
            return true;
        } else if (action.equals("setUserLevelId")) {
            if (!isGameInited) {
                initGame();
            }
            int level = args.getInt(0);
            UMGameAgent.setPlayerLevel(level);
            return true;
        } else if (action.equals("startLevel")) {
            if (!isGameInited) {
                initGame();
            }
            String level = args.getString(0);
            UMGameAgent.startLevel(level);
            return true;
        } else if (action.equals("finishLevel")) {
            if (!isGameInited) {
                initGame();
            }
            String level = args.getString(0);
            UMGameAgent.failLevel(level);
            return true;
        } else if (action.equals("failLevel")) {
            if (!isGameInited) {
                initGame();
            }
            String level = args.getString(0);
            UMGameAgent.finishLevel(level);

            return true;
        } else if (action.equals("exchange")) {
            if (!isGameInited) {
                initGame();
            }
            double currencyAmount = args.getDouble(0);
            String currencyType = args.getString(1);
            double virtualAmount = args.getDouble(2);
            int channel = args.getInt(3);
            String orderId = args.getString(4);
            UMGameAgent.exchange(currencyAmount, currencyType, virtualAmount, channel, orderId);
            return true;
        } else if (action.equals("pay")) {
            if (!isGameInited) {
                initGame();
            }
            double money = args.getDouble(0);
            double coin = args.getDouble(1);
            int source = args.getInt(2);
            UMGameAgent.pay(money, coin, source);
            return true;
        } else if (action.equals("payWithItem")) {
            if (!isGameInited) {
                initGame();
            }
            double money = args.getDouble(0);
            String item = args.getString(1);
            int number = args.getInt(2);
            double price = args.getDouble(3);
            int source = args.getInt(4);
            UMGameAgent.pay(money, item, number, price, source);
            return true;
        } else if (action.equals("buy")) {
            if (!isGameInited) {
                initGame();
            }
            String item = args.getString(0);
            int number = args.getInt(1);
            double price = args.getDouble(2);
            UMGameAgent.buy(item, number, price);
            return true;
        } else if (action.equals("use")) {
            if (!isGameInited) {
                initGame();
            }
            String item = args.getString(0);
            int number = args.getInt(1);
            double price = args.getDouble(2);
            UMGameAgent.use(item, number, price);
            return true;
        } else if (action.equals("bonus")) {
            if (!isGameInited) {
                initGame();
            }
            double coin = args.getDouble(0);
            int source = args.getInt(1);
            UMGameAgent.bonus(coin, source);
            return true;
        } else if (action.equals("bonusWithItem")) {
            if (!isGameInited) {
                initGame();
            }
            String item = args.getString(0);
            int number = args.getInt(1);
            double price = args.getDouble(2);
            int source = args.getInt(3);
            UMGameAgent.bonus(item, number, price, source);
            return true;
        } else if (action.equals("track")) {
            String eventName = args.getString(0);
            Log.d("UMPlugin", "track="+eventName);
            UMADplus.track(mContext, eventName);
            return true;
        } else if (action.equals("trackWithProperty")) {
            String eventName = args.getString(0);
            JSONObject obj = args.getJSONObject(1);
            Map<String, Object> map = new HashMap<String, Object>();
            Iterator<String> it = obj.keys();
            while (it.hasNext()) {
                String key = String.valueOf(it.next());
                Object o = obj.get(key);
                map.put(key, o);
            }
            UMADplus.track(mContext, eventName, map);
            return true;
        } else if (action.equals("registerSuperProperty")) {
            String propertyKey = args.getString(0);
            String propertyValue = args.getString(1);
            UMADplus.registerSuperProperty(mContext, propertyKey, propertyValue);
            return true;
        } else if (action.equals("unregisterSuperProperty")) {
            String propertyName = args.getString(0);
            UMADplus.unregisterSuperProperty(mContext, propertyName);
            return true;
        } else if (action.equals("getSuperProperty")) {
            String propertyName = args.getString(0);
            String res = (String) UMADplus.getSuperProperty(mContext, propertyName);
            callbackContext.success(res);
            return true;
        } else if (action.equals("getSuperProperties")) {
            String res = UMADplus.getSuperProperties(mContext);
            callbackContext.success(res);
            return true;
        } else if (action.equals("clearSuperProperties")) {
            UMADplus.clearSuperProperties(mContext);
            return true;
        } else if (action.equals("setFirstLaunchEvent")) {
            JSONArray array = args.getJSONArray(0);
            List<String> list = new ArrayList<String>();
            for (int i = 0; i < array.length(); i++) {
                list.add(array.getString(i));
            }
            UMADplus.setFirstLaunchEvent(mContext, list);

            return true;
        }
        return false;
    }
}
