package org.cocos2dx.utils;

import android.content.Context;
import android.os.Handler;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;


/**
 * http工具
 * 提供get和post提交
 */
public class HttpUtil {

    private static HttpUtil mHttpUtil;
    private StringBuffer mBuffer;

    private HttpUtil() {
        // cannot be instantiated
    }

    public static synchronized HttpUtil getInstance() {
        if (mHttpUtil == null) {
            mHttpUtil = new HttpUtil();
        }
        return mHttpUtil;
    }

    public static void releaseInstantce() {
        if (mHttpUtil != null) {
            mHttpUtil = null;
        }
    }

    public void doGet(Context ctx, HashMap<String, String> parameter, String url, String type, Handler handler, int... message) {
        if (parameter != null && parameter.size() != 0) {
            HttpURLConnection connection = null;
            try {
                mBuffer = new StringBuffer(url);
                mBuffer.append(Regex.QUESTION_MARK.getRegext());
                boolean isFirst = true;
                for (Map.Entry<String, String> entry : parameter.entrySet()) {
                    if (!isFirst) {
                        mBuffer.append(Regex.AND.getRegext());
                    }
                    mBuffer.append(entry.getKey());
                    mBuffer.append(Regex.EQUALS.getRegext());
                    mBuffer.append(entry.getValue());
                    isFirst = false;
                }
                connection = (HttpURLConnection) new URL(mBuffer.toString()).openConnection();
                connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
                connection.setRequestMethod("GET");
//                connection.setDoOutput(true);
                connection.setDoInput(true);
                connection.setUseCaches(false);
                connection.setInstanceFollowRedirects(true);
                connection.setConnectTimeout(30 * 1000);
                connection.setReadTimeout(18 * 1000);
                connection.connect();
                if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    handler.sendMessage(MessageUtil.getMessage(message[0], convertStreamToString(connection.getInputStream(), type)));
                } else {
                    handler.sendMessage(MessageUtil.getMessage(message[1], "服务器连接出错,请稍后重试"));
                }
            } catch (Exception e) {
                e.printStackTrace();
                handler.sendMessage(MessageUtil.getMessage(message[2], "服务器连接异常,请稍后重试"));
            } finally {
                if (connection != null) {
                    connection.disconnect();
                }
            }
        } else {
            Toast.makeText(ctx, "参数不能为空", Toast.LENGTH_LONG).show();
        }
    }

    public void doPost(Context ctx, HashMap<String, String> parameter, String url, String type, Handler handler, int... message) {
        if (parameter != null && parameter.size() != 0) {
            HttpURLConnection connection = null;
            StringBuffer buffer = new StringBuffer();
            try {
                for (Map.Entry<String, String> entry : parameter.entrySet()) {
                    buffer.append(entry.getKey()).append("=").append(URLEncoder.encode(entry.getValue(), "UTF-8")).append("&");
                }
                buffer.deleteCharAt(buffer.length() - 1);
                LogUtil.d("----->下单参数"," : "+buffer.toString());
                connection = (HttpURLConnection) new URL(url).openConnection();
                connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
                connection.setRequestMethod("POST");
                connection.setRequestProperty("Content-Length", String.valueOf(buffer.toString().getBytes().length));
                connection.setDoOutput(true);
                connection.setDoInput(true);
                connection.setUseCaches(false);
                connection.setInstanceFollowRedirects(true);
                connection.setConnectTimeout(30 * 1000);
                connection.setReadTimeout(18 * 1000);
                connection.connect();
                DataOutputStream outputStream = new DataOutputStream(connection.getOutputStream());
                outputStream.writeBytes(buffer.toString());
                outputStream.flush();
                outputStream.close();
                if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    //下面两个方法第一个是要直接在hangler中打印结果,第二个方法是要打印解析的token_id值
                    handler.sendMessage(MessageUtil.getMessage(message[0], convertStreamToString(connection.getInputStream(), type)));
                    LogUtil.i("HttpUtil", "----post成功----");
                    LogUtil.i("HttpUtil", url);
                } else {
                    handler.sendMessage(MessageUtil.getMessage(message[1], "连接服务器出错,请稍后重试"));
                    LogUtil.i("-----------", String.valueOf(connection.getResponseCode()));
                }
            } catch (Exception e) {
                e.printStackTrace();
                handler.sendMessage(MessageUtil.getMessage(message[2], "连接服务器异常,请稍后重试"));
            } finally {
                if (connection != null) {
                    connection.disconnect();
                }
            }
        } else {
            Toast.makeText(ctx, "参数不能为空", Toast.LENGTH_LONG).show();
        }
    }

    // 将服务器端传过来的字节流转换成String输出
    public String convertStreamToString(InputStream is, String type) {
        try {
            // 根据服务器端传过来的数据类型修改utf-8或gb2312
            BufferedReader reader = null;
            if (type.equals(Constant.GB2312)) {
                reader = new BufferedReader(new InputStreamReader(is, Constant.GB2312));
            } else if (type.equals(Constant.UTF_8)) {
                reader = new BufferedReader(new InputStreamReader(is, Constant.UTF_8));
            }
            StringBuilder builder = new StringBuilder();
            String line = null;
            try {
                while ((line = reader.readLine()) != null) {
                    builder.append(line);
                }
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            return builder.toString();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return null;
        }
    }

    public String getWapUrl(Context ctx, HashMap<String, String> parameter, String url) {
        if (parameter != null && parameter.size() != 0) {
            mBuffer = new StringBuffer(url);
            mBuffer.append(Regex.QUESTION_MARK.getRegext());
            boolean isFirst = true;
            for (Map.Entry<String, String> entry : parameter.entrySet()) {
                if (!isFirst) {
                    mBuffer.append(Regex.AND.getRegext());
                }
                mBuffer.append(entry.getKey());
                LogUtil.print("--------->1:" + entry.getKey());
                mBuffer.append(Regex.EQUALS.getRegext());
                mBuffer.append(entry.getValue());
                isFirst = false;
            }
            LogUtil.print("--------->2:" + mBuffer.toString());
            return mBuffer.toString();
        } else {
            Toast.makeText(ctx, "参数不能为空", Toast.LENGTH_LONG).show();
            return null;
        }
    }
}

