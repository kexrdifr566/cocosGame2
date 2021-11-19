//
//  InformViewCell.h
//  Service
//
//  Created by yue on 2017/9/12.
//  Copyright © 2017年 潴潴侠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformViewCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *cellData;

@property (weak, nonatomic) IBOutlet UIButton *cellBT;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle_LB;
@property (weak, nonatomic) IBOutlet UILabel *cellTime_LB;
@property (weak, nonatomic) IBOutlet UILabel *cellNumber_LB;
@property (weak, nonatomic) IBOutlet UILabel *cellID_LB;
@property (weak, nonatomic) IBOutlet UILabel *cellType_LB;
@property (weak, nonatomic) IBOutlet UILabel *cellContent_LB;
@property (weak, nonatomic) IBOutlet UILabel *cellReply_LB;
@property (weak, nonatomic) IBOutlet UIImageView *jian_IV;

-(CGFloat)getCell_H:(NSDictionary *)cellData;

@end
