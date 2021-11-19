//
//  BaseNavigationController.m
//  Ninele-mobile
//
//  Created by yue on 2017/11/18.
//

#import "BaseNavigationController.h"

@implementation BaseNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = [UIColor whiteColor];
}

//支持旋转
-(BOOL)shouldAutorotate{
    return YES;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
