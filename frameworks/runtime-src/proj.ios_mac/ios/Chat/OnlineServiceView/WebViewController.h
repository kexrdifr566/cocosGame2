//
//  WebViewController.h
//  Service
//
//  Created by yue on 2017/9/27.
//  Copyright © 2017年 潴潴侠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UIView+Extension.h"
@interface WebViewController : BaseViewController

@property (nonatomic,strong) NSString *webViewURL;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

