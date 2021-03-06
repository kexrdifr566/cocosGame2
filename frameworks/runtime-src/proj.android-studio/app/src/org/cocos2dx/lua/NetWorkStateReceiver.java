package org.cocos2dx.lua;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

/**
 *  监听网络连接和断开的变化广播接收者
 * Created by zhien on 2017/11/11.
 */

public class NetWorkStateReceiver extends BroadcastReceiver {


    @Override
    public void onReceive(Context context, Intent intent) {

        // 监听网络连接，包括wifi和移动数据的打开和关闭,以及连接上可用的连接都会接到监听
        if (ConnectivityManager.CONNECTIVITY_ACTION.equals(intent.getAction())) {
            //获取联网状态的NetworkInfo对象
            NetworkInfo info = intent
                    .getParcelableExtra(ConnectivityManager.EXTRA_NETWORK_INFO);
            if (info != null) {
                //如果当前的网络连接成功并且网络连接可用
                String state = "1";
                if (NetworkInfo.State.CONNECTED == info.getState() && info.isAvailable()) {
                    if (info.getType() == ConnectivityManager.TYPE_WIFI
                            || info.getType() == ConnectivityManager.TYPE_MOBILE) {
                        //连上网络
                        state = "1";
                    }
                } else {
                    //断开网络
                    state = "0";
                }
                if(AppActivity.instance != null)
                {
                    AppActivity.instance.toLuaNetWorkState(state);
                }
            }
        }
    }
}
