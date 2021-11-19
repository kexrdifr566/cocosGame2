package org.cocos2dx.utils;

/**
 * 正则表达式枚举
 */
public enum Regex {

    NONE(""),
    // 中国手机号区号
    CHINESE_AREA_CODE("+86"),
    // 加号
    PLUS("+"),
    // 减号
    MINUS("-"),
    // 空格
    SPACE(" "),
    // 逗号
    COMMA(","),
    // 句点
    POINT("."),
    // 问号
    QUESTION_MARK("?"),
    // 等于号
    EQUALS("="),
    // 冒号
    COLON(":"),
    // AND
    AND("&"),
    // 左括号
    LEFT_PARENTHESIS("("),
    // 右括号
    RIGHT_PARENTHESIS(")"),
    // 斜线
    SLASH("/"),
    // 井号
    SUPERSCRIPT("#"),
    // 回车换行
    ENTER("[\r\n]+|[\n]+|[\r]+"),
    // 日期格式
    DATE_FORMAT("yyyy-MM-dd HH:mm:ss"),
    // 读写权限
    PERMISSION("777"),
    // 文件名称
    FILE_NAME("/DownloadFile.apk"),
    // 文件协议头
    FILE_HEAD("file://"),
    // 文件类型
    FILE_TYPE("application/vnd.android.package-archive"),
    // JPG图片
    IMAGE_JPG(".jpg");

    private String mRegext;

    private Regex(String regex) {
        this.mRegext = regex;
    }

    public String getRegext() {
        return mRegext;
    }

}
