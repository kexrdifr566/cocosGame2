//
//  NetworkAPI.h
//  Service
//
//  Created by yue on 2017/9/26.
//  Copyright © 2017年 潴潴侠. All rights reserved.
//

#ifndef NetworkAPI_h
#define NetworkAPI_h

/*
 获取主菜单
 http://www.ouye521.cn/WS/CustomerInterface.ashx?action=GetQuestionType
 获取热点问题
 http://www.ouye521.cn/WS/CustomerInterface.ashx?action=GetQuestionList&hot=1
 获取子问题
 http://www.ouye521.cn/WS/CustomerInterface.ashx?action=GetQuestionList&typeId=类别ID
 查询问题
 http://www.ouye521.cn/WS/CustomerInterface.ashx?action=GetQuestionList&title=查询条件
 
 
 举报
 http://www.ouye521.cn/WS/CustomerInterface.ashx?action=Report&userid=用户ID&signature=签名&time=签名时间&gameid=举报ID&typeid=类型ID&content=举报内容
 
 举报历史
 http://www.ouye521.cn/WS/CustomerInterface.ashx?action=GetReport&userid=用户ID&signature=签名&time=签名时间
 
 留言
 http://www.ouye521.cn/WS/CustomerInterface.ashx?action=LeavingMessage&userid=用户ID&signature=签名&time=签名时间&contact=联系方式&typeid=类型ID&content=留言内容
 
 留言历史
 http://www.ouye521.cn/WS/CustomerInterface.ashx?action=GetMessage&userid=用户ID&signature=签名&time=签名时间
 
 //53客服
 http://www.ouye521.cn/WS/CustomerInterface.ashx?action=GetKefu
 */

//#define BaseURL        @"http://www.ouye521.cn"

//  获取主菜单
#define GetQuestionType(BaseURL)    [NSString stringWithFormat:@"%@%@",BaseURL,@"/WS/CustomerInterface.ashx?action=GetQuestionType"]

//  获取热点问题
#define GetQuestionListHot(BaseURL) [NSString stringWithFormat:@"%@%@",BaseURL,@"/WS/CustomerInterface.ashx?action=GetQuestionList&hot=1"]

//  获取子问题
#define GetQuestionListTypeId(BaseURL,typeId)   [NSString stringWithFormat:@"%@%@%@",BaseURL,@"/WS/CustomerInterface.ashx?action=GetQuestionList&typeId=",typeId]

//  查询问题
#define GetQuestionListTitle(BaseURL,title)    [NSString stringWithFormat:@"%@%@%@",BaseURL,@"/WS/CustomerInterface.ashx?action=GetQuestionList&title=",title]

//举报类型
#define ReportTypeID(BaseURL)  [NSString stringWithFormat:@"%@%@",BaseURL,@"/WS/CustomerInterface.ashx?action=GetQuestionType&typeid=3"]
//  举报
#define Report(BaseURL,userid,signature,time,gameid,typeid,content)    [NSString stringWithFormat:@"%@/WS/CustomerInterface.ashx?action=Report&userid=%@&signature=%@&time=%@&gameid=%@&typeid=%@&content=%@",BaseURL,userid,signature,time,gameid,typeid,content]
//举报历史
#define ReportList(BaseURL,userid,signature,time)    [NSString stringWithFormat:@"%@/WS/CustomerInterface.ashx?action=GetReport&userid=%@&signature=%@&time=%@",BaseURL,userid,signature,time]

//留言类型
#define GetMessageTypeID(BaseURL)  [NSString stringWithFormat:@"%@%@",BaseURL,@"/WS/CustomerInterface.ashx?action=GetQuestionType&typeid=2"]
//留言
#define GetMessage(BaseURL,userid,signature,time,contact,typeid,content)    [NSString stringWithFormat:@"%@/WS/CustomerInterface.ashx?action=LeavingMessage&userid=%@&signature=%@&time=%@&contact=%@&typeid=%@&content=%@",BaseURL,userid,signature,time,contact,typeid,content]
//留言历史
#define GetMessageList(BaseURL,userid,signature,time)    [NSString stringWithFormat:@"%@/WS/CustomerInterface.ashx?action=GetMessage&userid=%@&signature=%@&time=%@",BaseURL,userid,signature,time]

//留言历史
#define GetKefu(BaseURL)  [NSString stringWithFormat:@"%@/WS/CustomerInterface.ashx?action=GetKefu",BaseURL]

#endif /* NetworkAPI_h */
