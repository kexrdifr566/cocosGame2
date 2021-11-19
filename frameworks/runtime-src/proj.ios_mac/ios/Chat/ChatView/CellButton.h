//
//  CellButton.h
//  Service
//
//  Created by 潴潴俠 on 2017/9/25.
//  Copyright © 2017年 潴潴侠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellButton : UIButton

@property(nonatomic,strong) NSDictionary *data;
@property(nonatomic,assign) NSInteger   cellRow;
@end
