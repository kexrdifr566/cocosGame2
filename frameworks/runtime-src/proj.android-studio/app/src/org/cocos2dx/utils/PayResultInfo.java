package org.cocos2dx.utils;

/**
 * Created by huyj on 2017/4/24.
 */

public class PayResultInfo {
    private int result = -2;
    private String agentBillId;
    private String jnetBillNo;
    private String errorMsg;

    public String getErrorMsg() {
        return errorMsg;
    }

    public void setErrorMsg(String errorMsg) {
        this.errorMsg = errorMsg;
    }

    public int getResult() {
        return result;
    }

    public void setResult(int result) {
        this.result = result;
    }

    public String getAgentBillId() {
        return agentBillId;
    }

    public void setAgentBillId(String agentBillId) {
        this.agentBillId = agentBillId;
    }

    public String getJnetBillNo() {
        return jnetBillNo;
    }

    public void setJnetBillNo(String jnetBillNo) {
        this.jnetBillNo = jnetBillNo;
    }

    public static PayResultInfo parse(String params) {
        PayResultInfo payResult = new PayResultInfo();
        if((params!=null&&params.contains("agent_bill_id"))) {
            payResult.setAgentBillId(getItem(params, "agent_bill_id"));
            payResult.setJnetBillNo(getItem(params, "jnet_bill_no"));
            payResult.setResult(Integer.parseInt(getItem(params, "result")));
        }else {
            payResult.setErrorMsg(params);
        }
        return payResult;
    }

    private static String getItem(String params, String name) {
        if (params == null)
            return null;

        final String pattern = name + "=";
        int pos = params.indexOf(pattern);
        if (pos < 0) {
            return null;
        }

        int pos2 = params.indexOf('|', pos);
        String val = "";
        if (pos2 >= 0) {
            val = params.substring(pos + pattern.length(), pos2);
        } else {
            val = params.substring(pos + pattern.length());
        }
        return val;
    }

}
