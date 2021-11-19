package org.cocos2dx.thirdparty;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager.NameNotFoundException;
import android.net.Uri;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationClientOption.AMapLocationMode;
import com.amap.api.location.AMapLocationListener;
import com.amap.api.maps2d.AMapUtils;
import com.amap.api.maps2d.model.LatLng;
import com.tencent.mm.sdk.constants.Build;
import com.tencent.mm.sdk.modelpay.PayReq;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.umeng.socialize.PlatformConfig;
import com.umeng.socialize.ShareAction;
import com.umeng.socialize.UMAuthListener;
import com.umeng.socialize.UMShareAPI;
import com.umeng.socialize.UMShareListener;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.media.UMImage;
import com.umeng.socialize.media.UMWeb;

import org.cocos2dx.lua.PayInterfaceActivity;
import org.cocos2dx.thirdparty.ThirdDefine.ShareParam;
import org.cocos2dx.thirdparty.alipay.PayResult;
import org.cocos2dx.thirdparty.alipay.ZhifubaoPay;
import org.cocos2dx.utils.Constant;
import org.cocos2dx.utils.HttpUtil;
import org.cocos2dx.utils.Md5Util;
import org.cocos2dx.utils.Utils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import sdk.pay.PayUtil;
import sdk.pay.listener.PayGetPayTypeListener;
import sdk.pay.listener.PayUtilCallBack;
import sdk.pay.model.PayTypeModel;
import sdk.pay.model.TokenParam;
import sdk.pay.utils.PayMD5Util;
import dtyl.game.com.R;

public class ThirdParty implements PayUtilCallBack {
	public enum PLATFORM {
		INVALIDPLAT(-1), WECHAT(0), WECHAT_CIRCLE(1), ALIPAY(2), JFT(3), AMAP(4), IAP(
				5), SMS(6), ZFPAY(7), YYBPAY(8),HFBPAY(9),QQ(10);

		private int nNum = -1;

		private PLATFORM(int n) {
			nNum = n;
		}

		public int toNumber() {
			return this.nNum;
		}
	}

	// 登陆监听
	public static interface OnLoginListener {
		public void onLoginStart(PLATFORM plat, String msg);

		public void onLoginSuccess(PLATFORM plat, String msg);

		public void onLoginFail(PLATFORM plat, String msg);

		public void onLoginCancel(PLATFORM plat, String msg);
	}

	// 分享监听
	public static interface OnShareListener {
		public void onComplete(PLATFORM plat, int eCode, String msg);

		public void onError(PLATFORM plat, String msg);

		public void onCancel(PLATFORM plat);
	}

	// 支付监听
	public static interface OnPayListener {
		public void onPaySuccess(PLATFORM plat, String msg);

		public void onPayFail(PLATFORM plat, String msg);

		public void onPayNotify(PLATFORM plat, String msg);

		public void onGetPayList(boolean bOk, String msg);
	}

	// 定位监听
	public static interface OnLocationListener {
		public void onLocationResult(boolean bSuccess, int errorCode,
				String backMsg);
	}

	// 授权删除监听
	public static interface OnDelAuthorListener {
		public void onDeleteResult(boolean bSuccess, int errorCode,
				String backMsg);
	}

	private static ThirdParty m_tInstance = new ThirdParty();
	private Activity m_Context = null;
	// 友盟
	private UMShareAPI mShareAPI = null;
	// 第三方平台列表
	private List<PLATFORM> m_ThridPlatList = null;
	// 友盟第三方平台列表
	private Map<PLATFORM, SHARE_MEDIA> m_UMPartyList = null;
	// 支付回调
	private OnPayListener m_OnPayListener = null;
	private PLATFORM m_enPayPlatform = PLATFORM.INVALIDPLAT;
	// 支付宝
	private ZhifubaoPay m_AliPay = null;
	// 骏付通
	private PayUtil m_PayUtil = null;
	//支付信息
	private TokenParam tokenParam = null;
	// 高德
	private AMapLocationClient locationClient = null;
	private AMapLocationClientOption locationOption = new AMapLocationClientOption();
	// 定位监听
	private AMapLocationListener locationListener = null;
	// 定位回调
	private OnLocationListener m_LocationListener = null;

	public static ThirdParty getInstance() {
		return m_tInstance;
	}

	public static void destroy() {
		if (null != m_tInstance.locationClient) {
			m_tInstance.locationClient.onDestroy();
		}

		if (null != m_tInstance.m_PayUtil) {
			m_tInstance.m_PayUtil.destroy();
		}

		if(null != m_tInstance.mShareAPI)
		{
			m_tInstance.mShareAPI.release();
		}
	}

	public void init(Activity context) {
		m_Context = context;
		mShareAPI = UMShareAPI.get(m_Context);

		// 第三方平台
		m_ThridPlatList = new ArrayList<ThirdParty.PLATFORM>();
		m_ThridPlatList.add(0, ThirdParty.PLATFORM.WECHAT);
		m_ThridPlatList.add(1, ThirdParty.PLATFORM.WECHAT_CIRCLE);
		m_ThridPlatList.add(2, ThirdParty.PLATFORM.ALIPAY);
		m_ThridPlatList.add(3, ThirdParty.PLATFORM.JFT);
		m_ThridPlatList.add(4, ThirdParty.PLATFORM.AMAP);
		m_ThridPlatList.add(5, ThirdParty.PLATFORM.IAP);
		m_ThridPlatList.add(6, ThirdParty.PLATFORM.SMS);
		m_ThridPlatList.add(7, ThirdParty.PLATFORM.ZFPAY);
		m_ThridPlatList.add(8, ThirdParty.PLATFORM.YYBPAY);
		m_ThridPlatList.add(9, ThirdParty.PLATFORM.HFBPAY);

		// 添加友盟平台
		m_UMPartyList = new HashMap<ThirdParty.PLATFORM, SHARE_MEDIA>();
		m_UMPartyList.put(ThirdParty.PLATFORM.WECHAT, SHARE_MEDIA.WEIXIN);
		m_UMPartyList.put(ThirdParty.PLATFORM.WECHAT_CIRCLE,
				SHARE_MEDIA.WEIXIN_CIRCLE);
		m_UMPartyList.put(ThirdParty.PLATFORM.ALIPAY, SHARE_MEDIA.ALIPAY);
		m_UMPartyList.put(ThirdParty.PLATFORM.SMS, SHARE_MEDIA.SMS);
	}

	public PLATFORM getPlatform(final int nPart) {
		// 判断友盟平台
		int len = m_ThridPlatList.size();
		if (nPart < 0 || nPart >= len) {
			return ThirdParty.PLATFORM.INVALIDPLAT;
		}
		return m_ThridPlatList.get(nPart);
	}

	public PLATFORM getPlatformFrom(SHARE_MEDIA mdia) {
		// 判断友盟平台
		Set<PLATFORM> ptSet = m_UMPartyList.keySet();
		for (PLATFORM pt : ptSet) {
			if (m_UMPartyList.get(pt) == mdia) {
				return pt;
			}
		}
		return PLATFORM.INVALIDPLAT;
	}

	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (null != mShareAPI) {
			mShareAPI.onActivityResult(requestCode, resultCode, data);
		}
	}

	public void onPayResult(boolean bOk, String msg) {
		if (null != m_OnPayListener) {
			if (bOk) {
				m_OnPayListener.onPaySuccess(m_enPayPlatform, msg);
			} else {
				m_OnPayListener.onPayFail(m_enPayPlatform, msg);
			}
		}
		m_OnPayListener = null;
	}

	public void onPayNotify(String msg) {
		if (null != m_OnPayListener) {
			m_OnPayListener.onPayNotify(m_enPayPlatform, msg);
		}
	}

	@Override
	public void onPayException(String s) {
		m_OnPayListener.onPayNotify(PLATFORM.JFT, "支付失败");
	}

	public void configThirdParty(PLATFORM plat, String configstr) {
		switch (plat) {
		case WECHAT:
			doConfigWeChat(configstr);
			break;
		case ALIPAY:
			doConfigAlipay(configstr);
			break;
		case JFT:
			doConfigJFT(configstr);
			break;
		case AMAP:
			doConfigAMAP(configstr);
			break;
		default:
			break;
		}
	}

	public void configSocialShare() {
		if (null == mShareAPI) {
			return;
		}
	}

	public void thirdPartyLogin(PLATFORM plat, OnLoginListener listener) {
		// 判断友盟
		if (m_UMPartyList.containsKey(plat)) {
			SHARE_MEDIA mdia = m_UMPartyList.get(plat);
			if (mdia == SHARE_MEDIA.WEIXIN) {
				doWeChatLogin(listener);
			}
		}
	}

	public void deleteThirdPartyAuthorization(PLATFORM plat,
			final OnDelAuthorListener listener) {
		if (m_UMPartyList.containsKey(plat)) {
			SHARE_MEDIA mdia = m_UMPartyList.get(plat);

			mShareAPI.deleteOauth(m_Context, mdia, new UMAuthListener() {
				@Override
				public void onCancel(SHARE_MEDIA arg0, int arg1) {
					listener.onDeleteResult(false, 2, "");
				}

				@Override
				public void onComplete(SHARE_MEDIA arg0, int arg1,
						Map<String, String> arg2) {
					listener.onDeleteResult(true, 1, "");
				}

				@Override
				public void onError(SHARE_MEDIA arg0, int arg1, Throwable arg2) {
					listener.onDeleteResult(false, 0, "");
				}

				@Override
				public void onStart(SHARE_MEDIA arg0) {

				}
			});
		} else {
			listener.onDeleteResult(true, 2, "");
		}
	}

	public void openShare(final OnShareListener listener, ShareParam param) {
		if (null == m_Context) {
			listener.onError(m_enPayPlatform, "init error");
			return;
		}
		final SHARE_MEDIA[] displaylist = new SHARE_MEDIA[] {
				SHARE_MEDIA.WEIXIN, SHARE_MEDIA.WEIXIN_CIRCLE };
		ShareAction sAct = newShareAction(param, false);
		sAct.setDisplayList(displaylist)
				.setCallback(newShareListener(listener)).open();
	}

	public void targetShare(final OnShareListener listener, ShareParam param) {
		ThirdParty.PLATFORM plat = ThirdParty.getInstance().getPlatform(
				param.nTarget);
		if (m_UMPartyList.containsKey(plat)) {
			UMImage img = UMAsset.getUmImage(m_Context, param.sMedia);
			if (null == img) {
				img = new UMImage(m_Context, R.mipmap.ic_launcher);
			}
			SHARE_MEDIA mdia = m_UMPartyList.get(plat);
			ShareAction sAct = newShareAction(param,
					mdia == SHARE_MEDIA.WEIXIN_CIRCLE);
			sAct.setPlatform(mdia).setCallback(newShareListener(listener))
					.share();
		} else {
			listener.onError(plat, "do not support target");
		}
	}

	public void thirdPartyPay(PLATFORM plat, String payparam,
			final OnPayListener listener) {
		m_enPayPlatform = plat;
		// 解析支付参数
		try {

			JSONObject jObject = new JSONObject(payparam);
			m_OnPayListener = listener;

			// 判断平台
			switch (plat) {
			case WECHAT:
				JSONObject infoObject = jObject.getJSONObject("info");
				doWeChatPay(infoObject);
				break;
			case ALIPAY: {
				ThirdDefine.PayParam param = new ThirdDefine.PayParam();
				param.sOrderId = jObject.getString("orderid");
				param.fPrice = (float) jObject.getDouble("price");
				param.sProductName = jObject.getString("name");
				doAliPay(param);
			}
				break;
			case JFT: {
				int nPayType = (int) jObject.getInt("paytype");
				doJtfPay(nPayType);
			}
			case HFBPAY: {
					String appID = jObject.getString("uid");
					String appKey = jObject.getString("paykey");
					String sOrderId = jObject.getString("oid");
					String notifUrl = jObject.getString("nurl");
					String returnUrl = jObject.getString("rurl");
					float fPrice = (float) jObject.getDouble("mon");
					String payUrl = jObject.getString("payurl");
					int nPayType = (int) jObject.getInt("paytype");
					doHfbPay(payUrl,nPayType,appID,appKey,notifUrl,returnUrl,sOrderId,fPrice);
				}
				break;
			case ZFPAY: {
				String appID = jObject.getString("zfID");
				String appKey = jObject.getString("zfKEY");
				String sOrderId = jObject.getString("orderid");
				String notifUrl = jObject.getString("notifUrl");
				String backUrl = jObject.getString("backUrl");
				String payUrl = jObject.getString("payUrl");

				float fPrice = (float) jObject.getDouble("price");
				String sProductName = jObject.getString("name");
				doZFPay(payUrl,appID,appKey,notifUrl,backUrl,sOrderId,sProductName,fPrice);
				}
				break;
				case YYBPAY: {
					String payUrl = jObject.getString("PAYURL");
					doYYBPay(payUrl);
				}
				break;
			default:
				break;
			}

		} catch (JSONException e) {
			e.printStackTrace();
			listener.onPayFail(m_enPayPlatform, "订单数据解析失败");
		}
	}

	public void getPayList(String sztokenparam, final OnPayListener listener) {
		if (null == listener) {
			return;
		}
		if (false == ThirdDefine.bConfigJFT) {
			listener.onGetPayList(false, "竣付通配置异常");
			return;
		}
		m_OnPayListener = listener;
		if (null != m_PayUtil) {
			m_PayUtil.destroy();
		}

		try {
			JSONObject jObject = new JSONObject(sztokenparam);
			String mon = jObject.getString("mon");
			String rurl = jObject.getString("rurl");
			String nurl = jObject.getString("nurl");
			String oid = jObject.getString("oid");
			Date date = new Date();
			DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			tokenParam = new TokenParam();
			tokenParam.setP1_usercode(ThirdDefine.JFTPartnerID);
			tokenParam.setP2_order(oid);
			tokenParam.setP3_money(mon);
			tokenParam.setP4_returnurl(rurl);
			tokenParam.setP5_notifyurl(nurl);
			tokenParam.setP6_ordertime(dateFormat.format(date));
			tokenParam.setP14_customname("user");// user name
			tokenParam.setP7_sign(PayMD5Util.getMD5(
					ThirdDefine.JFTPartnerID + "&" + oid + "&" + mon + "&"
							+ rurl + "&" + nurl + "&" + dateFormat.format(date)
							+ ThirdDefine.JFTPayKey).toUpperCase());

			m_PayUtil = new PayUtil(m_Context, this, true);
			m_PayUtil.setPayParam(ThirdDefine.JFTAppID, ThirdDefine.JFTKey,
					ThirdDefine.JFTVector, "jft", ThirdDefine.JFTPartnerID);
			m_PayUtil.getPayTypes(new PayGetPayTypeListener() {
				@Override
				public void onPayDataResult() {
					if (null == m_OnPayListener || null == m_PayUtil) {
						Log.e("JFT", "监听异常");
						return;
					}

					List<PayTypeModel> payTypeModelList = m_PayUtil.getPayTypeModels();
					if (payTypeModelList.size() > 0) {
						Log.v("获取通道成功", "竣付通支付");
						JSONArray jArray = new JSONArray();
						@SuppressWarnings("unchecked")
						ArrayList<PayTypeModel> arrayList = (ArrayList<PayTypeModel>) payTypeModelList;
						for (int idx = 0; idx < arrayList.size(); ++idx) {
							jArray.put(arrayList.get(idx).getTypeid());
						}
						String jsonStr = jArray.toString();
						m_OnPayListener.onGetPayList(true, jsonStr);
					} else {
						Log.v("未获取到支付通道", "竣付通支付");
						m_OnPayListener.onGetPayList(false, "未获取到支付通道");
					}
				}
			});

			//m_PayUtil.getToken(tokenParam,1);
		} catch (JSONException e) {
			e.printStackTrace();
			onPayResult(false, "竣付通数据解析异常");
		}
	}

	public boolean isPlatformInstalled(PLATFORM plat) {
		String packageName = "";
		if (plat == ThirdParty.PLATFORM.WECHAT) {
			packageName = "com.tencent.mm";
		} else if (plat == ThirdParty.PLATFORM.ALIPAY) {
			packageName = "com.eg.android.AlipayGphone";
		} else if (plat == ThirdParty.PLATFORM.QQ)
			packageName = "com.tencent.mobileqq";
		else {
			return false;
		}
		android.content.pm.ApplicationInfo info = null;
		try {
			info = m_Context.getPackageManager().getApplicationInfo(
					packageName, 0);
			return info != null;
		} catch (NameNotFoundException e) {
			return false;
		}
	}

	// 请求单次定位
	public void requestLocation(OnLocationListener listener) {
		m_LocationListener = listener;
		if (null != locationClient && null != locationListener) {
			locationClient.stopLocation();
			// 设置定位监听
			locationClient.setLocationListener(locationListener);
			// 定位请求
			locationClient.startLocation();
		} else {
			listener.onLocationResult(false, -1, "定位服务初始化失败!");
		}
	}

	// 停止定位
	public void stopLocation() {
		locationClient.stopLocation();
	}

	// 距离计算
	public String metersBetweenLocation(String loParam) {
		String msg = "0";
		try {
			JSONObject jObject = new JSONObject(loParam);
			double myLatitude = jObject.getDouble("myLatitude");
			double myLongitude = jObject.getDouble("myLongitude");

			double otherLatitude = jObject.getDouble("otherLatitude");
			double otherLongitude = jObject.getDouble("otherLongitude");

			LatLng my2d = new LatLng(myLatitude, myLongitude);
			LatLng or2d = new LatLng(otherLatitude, otherLongitude);
			msg = String.valueOf(AMapUtils.calculateLineDistance(my2d, or2d));
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return msg;
	}

	// 是否授权
	public boolean isAuthorized(PLATFORM plat) {
		if (m_UMPartyList.containsKey(plat)) {
			SHARE_MEDIA mdia = m_UMPartyList.get(plat);
			return UMShareAPI.get(m_Context).isAuthorize(m_Context, mdia);
		}
		return false;
	}

	private void doConfigWeChat(String configstr) {
		try {
			JSONObject jObject = new JSONObject(configstr);
			ThirdDefine.WeixinAppID = jObject.getString("AppID");
			ThirdDefine.WeixinAppSecret = jObject.getString("AppSecret");
			ThirdDefine.WeixinPartnerid = jObject.getString("PartnerID");
			ThirdDefine.WeixinPayKey = jObject.getString("PayKey");
			ThirdDefine.bConfigWeChat = true;

			PlatformConfig.setWeixin(ThirdDefine.WeixinAppID,
					ThirdDefine.WeixinAppSecret);
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	private void doConfigAlipay(String configstr) {
		try {
			JSONObject jObject = new JSONObject(configstr);

			ThirdDefine.ZFBPARTNER = jObject.getString("PartnerID");
			ThirdDefine.ZFBSELLER = jObject.getString("SellerID");
			ThirdDefine.ZFBNOTIFY_URL = jObject.getString("NotifyURL");
			ThirdDefine.ZFBRSA_PRIVATE = jObject.getString("RsaKey");
			ThirdDefine.bConfigAlipay = true;

			PlatformConfig.setAlipay(ThirdDefine.ZFBPARTNER);
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	private void doConfigJFT(String configstr) {
		try {
			JSONObject jObject = new JSONObject(configstr);

			String appid = jObject.getString("JftAppID");
			String key = jObject.getString("JftAesKey");
			String vec = jObject.getString("JftAesVec");
			String partId = jObject.getString("PartnerID");
			String payKey = jObject.getString("PayKey");

			ThirdDefine.JFTKey = key;
			ThirdDefine.JFTVector = vec;
			ThirdDefine.JFTAppID = appid;
			ThirdDefine.JFTPartnerID = partId;
			ThirdDefine.JFTPayKey = payKey;
			ThirdDefine.bConfigJFT = true;
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	private void doConfigAMAP(String configstr) {
		locationOption = new AMapLocationClientOption();
		locationOption.setLocationMode(AMapLocationMode.Hight_Accuracy);// 可选，设置定位模式，可选的模式有高精度、仅设备、仅网络。默认为高精度模式

		locationOption.setOnceLocation(true);// 可选，设置是否单次定位。默认是false

		// 定位监听
		locationListener = new AMapLocationListener() {
			@Override
			public void onLocationChanged(AMapLocation loc) {
				boolean bRes = false;
				int errorCode = AMapLocation.ERROR_CODE_UNKNOWN;
				String backMsg = "";
				if (null != loc) {
					// 解析定位结果
					if (0 == loc.getErrorCode()) {
						JSONObject jObject = new JSONObject();
						try {
							bRes = true;
							jObject.put("berror", false);
							jObject.put("latitude", loc.getLatitude());
							jObject.put("longitude", loc.getLongitude());
							jObject.put("accuracy", loc.getAccuracy());
							backMsg = jObject.toString();
						} catch (JSONException e) {
							backMsg = "定位数据解析异常!" + loc.getErrorInfo();
							e.printStackTrace();
						}
					} else {
						JSONObject jObject = new JSONObject();
						try {
							bRes = true;
							jObject.put("berror", true);
							jObject.put("msg",
									errorCode + ",定位失败! " + loc.getErrorInfo());
							backMsg = jObject.toString();
						} catch (JSONException e) {
							backMsg = "定位数据解析异常!" + loc.getErrorInfo();
							e.printStackTrace();
						}
						locationClient.stopLocation();
					}
				} else {
					backMsg = "定位数据异常!";
				}

				if (null != m_LocationListener) {
					m_LocationListener.onLocationResult(bRes, errorCode,
							backMsg);
				}
				locationClient.stopLocation();
			}
		};

		// 初始化client
		locationClient = new AMapLocationClient(
				m_Context.getApplicationContext());
		// 设置定位参数
		locationClient.setLocationOption(locationOption);
	}

	private void doWeChatLogin(final OnLoginListener listener) {
		if (false == mShareAPI.isInstall(m_Context, SHARE_MEDIA.WEIXIN)) {
			listener.onLoginFail(PLATFORM.WECHAT, "微信客户端未安装,无法授权登陆");
			return;
		}

		if (null == m_Context || false == ThirdDefine.bConfigWeChat) {
			listener.onLoginFail(PLATFORM.WECHAT, "");
			return;
		}

		mShareAPI.doOauthVerify(m_Context, SHARE_MEDIA.WEIXIN,
				new UMAuthListener() {
					@Override
					public void onCancel(SHARE_MEDIA arg0, int arg1) {
						listener.onLoginCancel(PLATFORM.WECHAT, "");
					}

					@Override
					public void onComplete(SHARE_MEDIA arg0, int arg1,
							Map<String, String> arg2) {
						// parseAuthorData(listener, PLATFORM.WECHAT, arg1,
						// arg2);
						getPlatFormInfo(SHARE_MEDIA.WEIXIN, listener);
					}

					@Override
					public void onError(SHARE_MEDIA arg0, int arg1,
							Throwable arg2) {
						listener.onLoginFail(PLATFORM.WECHAT, "");
					}

					@Override
					public void onStart(SHARE_MEDIA arg0) {
						// TODO Auto-generated method stub

					}
				});
	}

	private void doWeChatPay(final JSONObject info) {
		if (null == m_Context || false == ThirdDefine.bConfigWeChat) {
			onPayResult(false, "初始化失败");
			return;
		}

		IWXAPI msgApi = WXAPIFactory.createWXAPI(m_Context,
				ThirdDefine.WeixinAppID);
		msgApi.registerApp(ThirdDefine.WeixinAppID);
		if (msgApi.getWXAppSupportAPI() >= Build.PAY_SUPPORTED_SDK_INT) {
			try {
				PayReq request = new PayReq();
				request.appId = info.getString("appid");
				request.partnerId = info.getString("partnerid");
				request.prepayId = info.getString("prepayid");
				request.packageValue = info.getString("package");
				request.nonceStr = info.getString("noncestr");
				request.timeStamp = info.getString("timestamp");
				request.sign = info.getString("sign");
				msgApi.sendReq(request);
			} catch (JSONException e) {
				e.printStackTrace();
				onPayResult(false, "订单数据解析异常");
			}
		} else {
			onPayResult(false, "未安装微信或微信版本过低");
		}
	}

	private void doAliPay(ThirdDefine.PayParam param) {
		if (null == m_Context || false == ThirdDefine.bConfigAlipay) {
			onPayResult(true, "初始化失败");
			return;
		}
		if (null == m_AliPay) {
			m_AliPay = new ZhifubaoPay(new Handler() {

				@Override
				public void handleMessage(Message msg) {
					if (msg.what == ThirdDefine.ZFB_Pay) {
						PayResult payResult = new PayResult((String) msg.obj);

						String resultStatus = payResult.getResultStatus();
						// 判断resultStatus 为“9000”则代表支付成功，具体状态码代表含义可参考接口文档
						if (TextUtils.equals(resultStatus, "9000")) {
							onPayResult(true, payResult.getResult());
						} else {
							// 判断resultStatus 为非"9000"则代表可能支付失败
							// "8000"代表支付结果因为支付渠道原因或者系统原因还在等待支付结果确认，最终交易是否成功以服务端异步通知为准（小概率状态）
							if (TextUtils.equals(resultStatus, "8000")) {
								onPayNotify("支付结果确认中");
							} else {
								// 其他值就可以判断为支付失败，包括用户主动取消支付，或者系统返回的错误
								onPayResult(false, payResult.getResult());
							}
						}
					}
				}

			}, m_Context);
		}
		m_AliPay.setOrderNo(param.sOrderId);
		m_AliPay.pay(param.fPrice, param.sProductName);
	}

	private void doJtfPay(int nPayType) {
		if (null != m_PayUtil) {
			m_PayUtil.pay(tokenParam,nPayType);
		}
		tokenParam = null;
		onPayResult(true, "");
	}

	private void doYYBPay(String payURL)
	{
		//String msg = jObject.getString("msg");
		Intent intent= new Intent();
		intent.setAction("android.intent.action.VIEW");
		Uri content_url = Uri.parse(payURL);
		intent.setData(content_url);
		m_Context.startActivity(intent);

	}

	private void doHfbPay(String payURL,int nPayType,String appid,String appKey,String notifUrl,String returnUrl,String orderid,float price)
	{
		int payType = nPayType == 3 ? 30 : 22;
		String version = "2";
		String is_phone = "1";
		String is_frame = "0";
		String agent_id = appid;
		String key = appKey;
		String agent_bill_time = Utils.getStringDate();
		String agent_bill_id = orderid;
		String pay_amt = price + "";
		String notify_url = notifUrl;
		String return_url = "http://www.jnhyhk.com";
		String user_ip = Utils.getHostIpAddress(m_Context.getApplication());
		String goods_name = "充值";
		String goods_num = "1";
		String remark = "wzpay";
		String goods_note = "wzpay";
		String meta_option = "{\"isInnerWap\":\"1\",\"s\":\"wap\",\"n\":\"万众互娱\",\"id\":\"wzhy.game.com\"}";

		StringBuilder sbSign = new StringBuilder();
		sbSign.append("version=" + 2);
		sbSign.append("&agent_id=" + agent_id);
		sbSign.append("&agent_bill_id=" + agent_bill_id);
		sbSign.append("&agent_bill_time=" + agent_bill_time);
		sbSign.append("&pay_type=" + payType);
		sbSign.append("&pay_amt=" + pay_amt);
		sbSign.append("&notify_url=" + notify_url);
		sbSign.append("&return_url=" + return_url);
		sbSign.append("&user_ip=" + user_ip);
		sbSign.append("&key=" + key);//商户签名key
		System.out.println(sbSign.toString() + "1---------------------");
		String initSign = Md5Util.md5(sbSign.toString()).toLowerCase();//md5加密
		System.out.println(initSign + "2---------------------");
		String md5 = initSign;

		final HashMap<String, String> parameters = new HashMap<String,String>();
		try {
			parameters.put(Constant.VERSION, URLEncoder.encode(version, "UTF-8"));
			parameters.put(Constant.IS_PHONE, URLEncoder.encode(is_phone, "UTF-8"));
			parameters.put(Constant.IS_FRAME, URLEncoder.encode(is_frame, "UTF-8"));
			parameters.put(Constant.AGENT_ID, URLEncoder.encode(agent_id, "UTF-8"));
			parameters.put(Constant.AGENT_BILL_ID, URLEncoder.encode(agent_bill_id, "UTF-8"));
			parameters.put(Constant.AGENT_BILL_TIME, agent_bill_time);
			parameters.put(Constant.PAY_TYPE, URLEncoder.encode(payType+"", "UTF-8"));
			parameters.put(Constant.PAY_AMT, URLEncoder.encode(pay_amt, "UTF-8"));
			parameters.put(Constant.GOODS_NAME, URLEncoder.encode(goods_name, "gb2312"));
			parameters.put(Constant.GOODS_NUM, URLEncoder.encode(goods_num, "UTF-8"));
			parameters.put(Constant.GOODS_NOTE, URLEncoder.encode(goods_note, "gb2312"));
			parameters.put(Constant.REMARK, URLEncoder.encode(remark, "gb2312"));
			parameters.put(Constant.UESR_IP, URLEncoder.encode(user_ip, "UTF-8"));
			parameters.put(Constant.NOTIFY_URL, URLEncoder.encode(notify_url, "UTF-8"));
			parameters.put(Constant.RETURN_URL, URLEncoder.encode("http://www.jnhyhk.com", "UTF-8"));
			parameters.put(Constant.META_OPTION, URLEncoder.encode(Base64.encodeToString(meta_option.getBytes("gb2312"), Base64.DEFAULT), "UTF-8"));
			parameters.put(Constant.SIGN_TYPE, "MD5");
			parameters.put(Constant.MD5, URLEncoder.encode(md5, "gb2312"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		//此处只为演示，微信H5页面地址需要商户下单到商户服务器获取
		String result = HttpUtil.getInstance().getWapUrl(m_Context, parameters, Constant.H5_PAYINIT_URL);

		Intent intent = new Intent(m_Context, PayInterfaceActivity.class);
		intent.putExtra("payUrl", result);
		intent.putExtra(Constant.VERSION, version);
		intent.putExtra(Constant.AGENT_ID, agent_id);
		intent.putExtra(Constant.AGENT_BILL_ID, agent_bill_id);
		intent.putExtra(Constant.AGENT_BILL_TIME, agent_bill_time);
		intent.putExtra("key", key);
		m_Context.startActivity(intent);
	}

	private void doZFPay(String payURL,String appid,String appKey,String notifUrl,String back_url,String orderid,String name,float price)
	{

//		OkHttpClient mOkHttpClient = new OkHttpClient();
//		final Request request = new Request.Builder()
//				.url(url)
//				.build();
//		Call call = mOkHttpClient.newCall(request);
//		//请求加入调度
//		call.enqueue(new Callback() {
//			@Override
//			public void onFailure(Call call, IOException e) {
//				m_OnPayListener.onPayFail(m_enPayPlatform, "支付失败,请重试");
//			}
//
//			@Override
//			public void onResponse(Call call, Response response) throws IOException {
//				String responseStr =  response.body().string();
//				try {
//					JSONObject jObject = new JSONObject(responseStr);
//					String code = jObject.getString("code");
//					if(code.equals("success"))
//					{
//						String msg = jObject.getString("msg");
//						Intent intent= new Intent();
//						intent.setAction("android.intent.action.VIEW");
//						Uri content_url = Uri.parse(msg);
//						intent.setData(content_url);
//						m_Context.startActivity(intent);
//					}
//					else
//					{
//						m_OnPayListener.onPayFail(m_enPayPlatform, "支付失败,请重试");
//					}
//				} catch (JSONException e) {
//					e.printStackTrace();
//					m_OnPayListener.onPayFail(m_enPayPlatform, "支付失败,请重试");
//				}
//			}
//		});

	}
	private void getPlatFormInfo(final SHARE_MEDIA mdia,
			final OnLoginListener listener) {
		final PLATFORM plat = getPlatformFrom(mdia);
		mShareAPI.getPlatformInfo(m_Context, mdia, new UMAuthListener() {

			@Override
			public void onError(SHARE_MEDIA arg0, int arg1, Throwable arg2) {
				listener.onLoginFail(plat, arg2.getMessage());
			}

			@Override
			public void onComplete(SHARE_MEDIA arg0, int arg1,
					Map<String, String> arg2) {
				parseAuthorData(listener, plat, arg1, arg2);
			}

			@Override
			public void onCancel(SHARE_MEDIA arg0, int arg1) {
				listener.onLoginFail(plat, "" + arg1);
			}

			@Override
			public void onStart(SHARE_MEDIA arg0) {
				// TODO Auto-generated method stub

			}
		});
	}

	private void parseAuthorData(final OnLoginListener listener, PLATFORM plat,
			int arg1, Map<String, String> arg2) {
		if (/* arg1 == 0 && */arg2 != null) {
			// 登陆成功
			JSONObject jObject = new JSONObject(arg2);
			try {
				jObject.put("valid", true);
				jObject.put("um_code", arg1);
				listener.onLoginSuccess(plat, jObject.toString());
			} catch (JSONException e) {
				listener.onLoginFail(plat, "");
				e.printStackTrace();
			}
		} else {
			JSONObject jObject = new JSONObject();
			try {
				jObject.put("valid", false);
				jObject.put("errorcode", arg1);
				listener.onLoginFail(plat, jObject.toString());
			} catch (JSONException e) {
				listener.onLoginFail(plat, "登陆发生错误：" + arg1);
				e.printStackTrace();
			}
		}
	}

	private ShareAction newShareAction(ShareParam param, boolean bCycleShare) {
		UMImage img = UMAsset.getUmImage(m_Context, param.sMedia);
		if (null == img) {
			img = new UMImage(m_Context, R.mipmap.ic_launcher);
		}

		ShareAction sAct = new ShareAction(m_Context);
		if ("" != param.sContent && false == param.bImageOnly) {
			sAct.withText(param.sContent);
		}
		if ("" != param.sTitle && false == param.bImageOnly) {
			sAct.withSubject(param.sTitle);
		}
		if ("" != param.sTargetURL && false == param.bImageOnly) {
			UMWeb web = new UMWeb(param.sTargetURL);
			web.setDescription(param.sContent);
			// 朋友圈分享特殊处理
			if (bCycleShare) {
				web.setTitle(param.sContent);
			} else {
				web.setTitle(param.sTitle);
			}
			web.setThumb(img);
			sAct.withMedia(web);
		}
		if (true == param.bImageOnly) {
			sAct.withMedia(img);
		}
		return sAct;
	}

	private UMShareListener newShareListener(final OnShareListener listener) {
		return new UMShareListener() {
			@Override
			public void onResult(SHARE_MEDIA arg0) {
				PLATFORM pt = getPlatformFrom(arg0);
				if (pt != PLATFORM.INVALIDPLAT) {
					listener.onComplete(pt, 200, "");
				} else {
					listener.onError(pt, "invalid platform " + pt.toString());
				}
			}

			@Override
			public void onError(SHARE_MEDIA arg0, Throwable arg1) {
				PLATFORM pt = getPlatformFrom(arg0);
				listener.onError(pt, "invalid platform " + arg1.getMessage());
			}

			@Override
			public void onCancel(SHARE_MEDIA arg0) {
				PLATFORM pt = getPlatformFrom(arg0);
				listener.onCancel(pt);
			}

			@Override
			public void onStart(SHARE_MEDIA arg0) {
				// TODO Auto-generated method stub
			}
		};
	}
}
