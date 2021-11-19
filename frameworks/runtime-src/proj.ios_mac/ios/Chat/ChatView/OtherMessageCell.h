//
//  OtherMessageCell.h
//  Service
//
//  Created by yue on 2017/9/12.
//  Copyright © 2017年 潴潴侠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherMessageCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSMutableArray *issueAry;//问题列表

@property (weak, nonatomic) IBOutlet UILabel *cellTime_LB;
@property (weak, nonatomic) IBOutlet UIImageView *userImage_IV;
@property (weak, nonatomic) IBOutlet UIImageView *chatBGImage_IV;
@property (weak, nonatomic) IBOutlet UILabel *charContent_LB;

-(CGFloat)getCell_H:(NSDictionary *)cellData;

-(void)setupCellUIWithData:(NSDictionary *)cellData WithTarget:(id)target WithAction:(SEL)action WithIndexPath:(NSIndexPath *)indexPath;

@end




