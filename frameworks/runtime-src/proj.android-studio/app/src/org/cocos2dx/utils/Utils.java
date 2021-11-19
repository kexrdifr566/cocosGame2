package org.cocos2dx.utils;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.telephony.TelephonyManager;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.UUID;

public class Utils {
	//获取uuid
	public static String getUUID(Application context)
	{
		if (null == context)
		{
			return "";
		}
		int imei = 0;
		int machineID = 0;
		int macAddress = 0;
		
		String sImeiString = getIMEI(context);
		if(sImeiString != null)
		{
			imei = sImeiString.hashCode();
		}
		
		String sMachineIdString = getMachineID(context);
		if(sMachineIdString != null)
		{
			machineID = sMachineIdString.hashCode();
		}
		
		String sMacAddresString = getMacAddress(context);
		if(sMacAddresString != null)
		{
			macAddress = sMacAddresString.hashCode();
		}
		String deviceUuid = new UUID(imei, ((long) machineID << 32) | macAddress).toString();
		if (deviceUuid == null || deviceUuid.equals("")) 
		{
			deviceUuid = UUID.randomUUID().toString();
		}
		return deviceUuid.replace("-", "");
	}
	
	public static boolean isNetworkConnected(Activity context)
	{
		ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);  
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
	
	public static String getHostIpAddress(Application context)
	{
		WifiManager wifiMgr = (WifiManager) context.getSystemService(context.WIFI_SERVICE);
        WifiInfo wifiInfo = wifiMgr.getConnectionInfo();
        int ip = wifiInfo.getIpAddress();
        return ((ip & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF));
	}

	/**
	 * 获取现在时间
	 *
	 * @return返回字符串格式 yyyyMMddHHmmss
	 */
	@SuppressLint("SimpleDateFormat")
	public static String getStringDate() {
		Date currentTime = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		String dateString = formatter.format(currentTime);
		return dateString;
	}

	public static String getSDCardDocPath(Activity context)
	{
		File file = context.getExternalFilesDir(null);
		if (null != file) 
			return file.getPath();
		return context.getFilesDir().getAbsolutePath();
	}
	
	private static String getMachineID(Application context)
	{
		TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
		final String tmDevice, tmSerial, androidId;
		tmDevice = "" + tm.getDeviceId();
		tmSerial = "" + tm.getSimSerialNumber();
		androidId = "" + android.provider.Settings.Secure.getString(context.getContentResolver(), android.provider.Settings.Secure.ANDROID_ID);
		UUID deviceUuid = new UUID(androidId.hashCode(), ((long) tmDevice.hashCode() << 32) | tmSerial.hashCode());
		return deviceUuid.toString();
	}

	/** IMEI **/
	private static String getIMEI(Application context)
	{
		TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
		return tm.getSubscriberId();
	}
    
	/** Mac **/
	private static String getMacAddress(Application context)
	{
		WifiManager wifi = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
		String szmac = wifi.getConnectionInfo().getMacAddress();
		if (szmac == null || szmac.equals("")) 
		{
			szmac = getMacAddressLinux();
			if (szmac == null || szmac.equals("")) 
			{
				return "11-22-33-44-55";
			}
		}
		return szmac.replace(":", "-");
	}

	/** MacLinux **/
	private static String getMacAddressLinux() 
	{
		try 
		{
			String szmac = loadFileAsString("/sys/class/net/eth0/address").toUpperCase().substring(0, 17);
			if (szmac == null || szmac.equals("")) 
			{
				szmac = loadFileAsString("/sys/class/net/wlan0/address").toUpperCase().substring(0, 17);
			}
			return szmac;
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
			return null;
		}
	}
	
	private static String loadFileAsString(String filePath)
			throws java.io.IOException 
			{
		StringBuffer fileData = new StringBuffer(1000);
		BufferedReader reader = new BufferedReader(new FileReader(filePath));
		char[] buf = new char[1024];
		int numRead = 0;
		while ((numRead = reader.read(buf)) != -1) 
		{
			String readData = String.valueOf(buf, 0, numRead);
			fileData.append(readData);
		}
		reader.close();
		return fileData.toString();
	}
}
