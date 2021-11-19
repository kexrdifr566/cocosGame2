//
//  MessageViewCell.m
//  Service
//
//  Created by yue on 2017/9/27.
//  Copyright © 2017年 潴潴侠. All rights reserved.
//

#import "MessageViewCell.h"
#import "UIView+Extension.h"

@implementation MessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellData:(NSDictionary *)cellData{
    
    self.cellTitle_LB.text      =   [NSString stringWithFormat:@"%@",cellData[@"FeedbackContent"]];
    self.cellTime_LB.text       =   [NSString stringWithFormat:@"%@",cellData[@"FeedbackDate"]];
    self.cellNumber_LB.text     =   [NSString stringWithFormat:@"%@",cellData[@"Contact"]];
    self.cellID_LB.text         =   [NSString stringWithFormat:@"%@",cellData[@"FeedbackID"]];
    self.cellType_LB.text       =   [NSString stringWithFormat:@"%@",cellData[@"TypeName"]];
    self.cellContent_LB.text    =   [NSString stringWithFormat:@"%@",cellData[@"FeedbackContent"]];
    self.cellReply_LB.text      =   [NSString stringWithFormat:@"%@",cellData[@"RevertContent"]];
    
}

-(CGFloat)getCell_H:(NSDictionary *)cellData{
    [self setCellData:cellData];
    CGSize cellContent_LB_Size = [self.cellContent_LB.text boundingRectWithSize:CGSizeMake(self.width-85, MAXFLOAT)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                     attributes:@{NSFontAttributeName: self.cellContent_LB.font}
                                                                        context:nil].size;
    
    CGSize cellReply_LB_Size = [self.cellReply_LB.text boundingRectWithSize:CGSizeMake(self.width-85, MAXFLOAT)
                                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                 attributes:@{NSFontAttributeName: self.cellReply_LB.font}
                                                                    context:nil].size;
    
    CGFloat cellContent_LB_H =  cellContent_LB_Size.height <= 28 ? 44 : cellContent_LB_Size.height + 16.0;
    CGFloat cellReply_LB_H   =  cellReply_LB_Size.height <= 28 ? 44 : cellReply_LB_Size.height  + 16.0;
    return 133 + cellContent_LB_H + cellReply_LB_H + 1;
}

@end
