package org.cocos2dx.lua;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.View;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import org.cocos2dx.utils.Constant;
import org.cocos2dx.utils.HttpUtil;
import org.cocos2dx.utils.Md5Util;
import org.cocos2dx.utils.PayResultInfo;

import java.io.UnsupportedEncodingException;
import java.lang.ref.WeakReference;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.Executors;

public class PayInterfaceActivity extends Activity {
    private WebView mWebView;
    private String payUrl;
    protected int mFlag = 0;
    private String version;
    private String agentId;
    private String agentBillId;
    private String agentBillTime;
    private String key;
    private Timer mTimer;
    public ProgressDialog mProgressDialog;
    private H5Handler mH5Handler;

    private class H5Handler extends Handler {
        private WeakReference<PayInterfaceActivity> mActivitys;

        public H5Handler(PayInterfaceActivity activity) {
            mActivitys = new WeakReference<PayInterfaceActivity>(activity);
        }

        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            PayInterfaceActivity activity = mActivitys.get();
            if (activity != null) {
                activity.hideProgressDialog();
                switch (msg.what) {
                    case Constant.QUERY_SUCCESS:
                        PayResultInfo resultInfo = PayResultInfo.parse(msg.obj.toString());
                        if (TextUtils.isEmpty(resultInfo.getErrorMsg())) {
                            int billState = resultInfo.getResult();
                            setPayResult(billState);
                        } else {
                            Toast.makeText(activity, resultInfo.getErrorMsg(), Toast.LENGTH_SHORT).show();
                        }
                        break;
                    case Constant.QUERY_FAILED:
                        Toast.makeText(activity, "查询失败", Toast.LENGTH_SHORT).show();
                        break;
                    case Constant.QUERY_ERROR:
                        Toast.makeText(activity, "查询错误", Toast.LENGTH_SHORT).show();
                        break;
                }
            }
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent intent = getIntent();
        if (intent != null) {
            if (intent.hasExtra("payUrl")) {
                payUrl = intent.getStringExtra("payUrl");
            }

            if (intent.hasExtra(Constant.VERSION)) {
                version = intent.getStringExtra(Constant.VERSION);
            }
            if (intent.hasExtra(Constant.AGENT_ID)) {
                agentId = intent.getStringExtra(Constant.AGENT_ID);
            }
            if (intent.hasExtra(Constant.AGENT_BILL_ID)) {
                agentBillId = intent.getStringExtra(Constant.AGENT_BILL_ID);
            }
            if (intent.hasExtra(Constant.AGENT_BILL_TIME)) {
                agentBillTime = intent.getStringExtra(Constant.AGENT_BILL_TIME);
            }

            if (intent.hasExtra("key")) {
                key = intent.getStringExtra("key");
            }

        }
        //此处商户可根据需要自行处理跳转中间页
        setView();
        if (!TextUtils.isEmpty(payUrl)) {
            mProgressDialog = showProgressDialog(this, "", "正在启动...");
            mWebView.loadUrl(payUrl);
        } else {
            finish();
        }
    }


    private void setView() {
        mH5Handler = new H5Handler(this);
        mWebView = new WebView(this);
        mWebView.setVisibility(View.GONE);
        setContentView(mWebView);
        setWebViewClient();
        setWebViewProperty();
    }

    @Override
    protected void onResume() {
        super.onResume();
        this.mFlag += 1;
        if (mFlag % 2 != 0) {
            if (mTimer == null) {
                mTimer = new Timer();
            }
            mTimer.schedule(new TimerTask() {
                @Override
                public void run() {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            hideProgressDialog();
                            mWebView.setVisibility(View.VISIBLE);
                        }
                    });
                }
            }, 10000);

            return;
        }
        //再次进入支付页面时，进行订单查询，供仅参考，查询需要商户到商户服务器去查询
        doH5Query();
    }


    @Override
    protected void onPause() {
        super.onPause();
        if (mTimer != null) {
            mTimer.cancel();
            mTimer = null;
        }
    }

    /**
     * 查询订单模拟
     */

    private void doH5Query() {
        mProgressDialog = showProgressDialog(this, "", "正在查询...");
        final HashMap<String, String> params = new HashMap<String, String>();
        try {
            if (TextUtils.isEmpty(agentBillId)) {
                Toast.makeText(this, "订单号为空，请先提交订单!", Toast.LENGTH_SHORT).show();
                return;
            }

            params.put(Constant.VERSION, URLEncoder.encode(version, "UTF-8"));
            params.put(Constant.AGENT_ID, URLEncoder.encode(agentId, "UTF-8"));
            params.put(Constant.AGENT_BILL_ID, URLEncoder.encode(agentBillId, "UTF-8"));
            params.put(Constant.AGENT_BILL_TIME, agentBillTime);
            params.put(Constant.RETURN_MODE, URLEncoder.encode("1", "UTF-8"));
            params.put(Constant.REMARK, URLEncoder.encode("无", "gb2312"));
            params.put(Constant.SIGN_TYPE, "MD5");
            params.put(Constant.MD5, URLEncoder.encode(queryMd5(), "gb2312"));

            Executors.newScheduledThreadPool(1).execute(new Runnable() {
                @Override
                public void run() {
                    //进行订单查询，供仅参考，查询需要商户到商户服务器去查询
                    HttpUtil.getInstance().doPost(PayInterfaceActivity.this, params, Constant.H5_QUERY_URL, Constant.GB2312, mH5Handler, Constant.QUERY_SUCCESS, Constant.QUERY_FAILED, Constant.QUERY_ERROR);
                }
            });
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
    }

    private String queryMd5() {
        StringBuilder sbSign = new StringBuilder();
        sbSign.append("version=" + version);
        sbSign.append("&agent_id=" + agentId);
        sbSign.append("&agent_bill_id=" + agentBillId);
        sbSign.append("&agent_bill_time=" + agentBillTime);
        sbSign.append("&return_mode=" + "1");
        sbSign.append("&key=" + key);//商户签名key
        String initSign = Md5Util.md5(sbSign.toString()).toLowerCase();//md5加密
        return initSign;
    }

    //将支付结果返回给上一个页面，仅供参考
    private void setPayResult(int code) {
        Intent intent = new Intent();
        intent.putExtra("code", code);
        setResult(Constant.RESULTCODE, intent);
        finish();
    }

    //配置webview
    protected void setWebViewClient() {
        mWebView.setWebViewClient(new WebViewClient() {

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                if (url.startsWith("weixin:") || url.startsWith("alipayqr:") || url.startsWith("alipays:")|| url.startsWith("qq")|| url.startsWith("mqqapi:")) {
                    try {
                        hideProgressDialog();
                        startActivity(new Intent("android.intent.action.VIEW", Uri.parse(url)));
                    } catch (ActivityNotFoundException localActivityNotFoundException) {
                        Toast.makeText(PayInterfaceActivity.this, "请检查是否安装客户端", Toast.LENGTH_SHORT).show();
                        finish();
                    }
                    return true;
                } else {
                    return super.shouldOverrideUrlLoading(view, url);
                }
            }

            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                super.onPageStarted(view, url, favicon);

            }

            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
            }

            @Override
            public void onReceivedError(WebView view, int errorCode,
                                        String description, String failingUrl) {
                super.onReceivedError(view, errorCode, description, failingUrl);
            }

        });
    }

    //配置webview
    @SuppressLint({"SetJavaScriptEnabled", "JavascriptInterface"})
    protected void setWebViewProperty() {
        WebSettings settings = mWebView.getSettings();
        // 支持JavaScript
        settings.setJavaScriptEnabled(true);
        // 支持通过js打开新的窗口
        settings.setJavaScriptCanOpenWindowsAutomatically(true);
        settings.setDomStorageEnabled(true);
    }

    protected ProgressDialog showProgressDialog(Context context, String title, String message) {
        mProgressDialog = ProgressDialog.show(context, title, message, false, true);
        mProgressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        mProgressDialog.setOnCancelListener(mCanListener);
        mProgressDialog.setCanceledOnTouchOutside(false);
        mProgressDialog.setCancelable(false);
        return mProgressDialog;
    }

    /**
     * Dialog关闭监听
     */
    protected DialogInterface.OnCancelListener mCanListener = new DialogInterface.OnCancelListener() {
        public void onCancel(DialogInterface dlg) {
            dlg.dismiss();
        }
    };

    public void hideProgressDialog() {
        if (mProgressDialog != null && mProgressDialog.isShowing()) {
            mProgressDialog.dismiss();
        }
    }


}
