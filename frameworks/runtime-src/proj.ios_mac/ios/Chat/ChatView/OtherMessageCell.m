//
//                         _ooOoo_
//                        o8888888o
//                        88" . "88
//                        (| -_- |)
//                        O\  =  /O
//                     ____/`---'\____
//                   .'  \\|     |    `.
//                  /  \\|||  :  |||    \
//                 /  _||||| -:- |||||-  \
//                 |   | \\\  -  / |     |
//                 | \_|  ''\---/'' |    |
//                 \  .-\__  `-` ___/-. /
//               ___`. .'  /--.--\  `. . __
//            ."" '<  `.___\_<|>_/___.'  >'"".
//           | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//           \  \ `-.   \_ __\ /__ _/   .-` /  /
//      ======`-.____`-.___\_____/___.-`____.-'======
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//    佛祖保佑       永无BUG        轻松上架       6666
//*************************************************************
#import "OtherMessageCell.h"
#import "UIView+Extension.h"
#import "CellButton.h"

#define Buttom_H  30.0f
#define ButtomTitleColorNormal [UIColor colorWithRed:0/255.0 green:128/255.0 blue:255/255.0 alpha:1.0]
#define ButtomTitleColorSelected [UIColor orangeColor]

@implementation OtherMessageCell



- (void)awakeFromNib {
    [super awakeFromNib];
    
}


-(void)setupCellUIWithData:(NSDictionary *)cellData WithTarget:(id)target WithAction:(SEL)action WithIndexPath:(NSIndexPath *)indexPath{
    self.userImage_IV.image = [UIImage imageNamed:@"AppIcon60x60@3x.png"];
    self.userImage_IV.layer.cornerRadius = 3;
    
    self.cellTime_LB.text =  [self timeWithTimeIntervalString:[cellData valueForKey:@"time"]];
    
    self.charContent_LB.text = [cellData valueForKey:@"messageContent"];
    CGSize charContent_LB_Size = [self.charContent_LB.text boundingRectWithSize:CGSizeMake(WIDTH_SCREEN-74-18, 20000)
                                                          options:\
                                  NSStringDrawingTruncatesLastVisibleLine |
                                  NSStringDrawingUsesLineFragmentOrigin |
                                  NSStringDrawingUsesFontLeading
                                                       attributes:@{NSFontAttributeName: self.charContent_LB.font}
                                                          context:nil].size;
    
    self.charContent_LB.frame = CGRectMake(15, 12, charContent_LB_Size.width, charContent_LB_Size.height);
    [self.chatBGImage_IV addSubview:self.charContent_LB];
    
    //添加 主菜单
    _issueAry = [[NSMutableArray alloc]initWithArray:[cellData valueForKey:@"issueAry"]];
    NSArray *mainIssueAry = [cellData valueForKey:@"mainIssueAry"];
    if (mainIssueAry.count>0) {
        [_issueAry addObject:@{@"IssueTitle":@"主菜单",@"mainIssueAry":mainIssueAry}];
    }
    
    //移除所有按钮
    for (UIView *subview in self.chatBGImage_IV.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview removeFromSuperview];
        }
    }
    
    CGFloat chatBGImage_IV_W,chatBGImage_IV_H;
    if ([self.charContent_LB.text isEqual:@"请问是否解决了您的问题？"]) {
        
        CellButton *issueButton = [CellButton buttonWithType:UIButtonTypeCustom];
        issueButton.cellRow = indexPath.row;
        issueButton.tag = 3000;
        issueButton.frame = CGRectMake(0,12+charContent_LB_Size.height, 100, Buttom_H);
        issueButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [issueButton setTitle:@"已解决" forState:UIControlStateNormal];
        [issueButton setImage:[UIImage imageNamed:@"love_1"] forState:UIControlStateNormal];
        [issueButton setTitleColor:ButtomTitleColorNormal forState:UIControlStateNormal];
        [issueButton setTitleColor:ButtomTitleColorSelected forState:UIControlStateSelected];
        [issueButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self.chatBGImage_IV addSubview:issueButton];
        
        
        CellButton *issueButton_2 = [CellButton buttonWithType:UIButtonTypeCustom];
        issueButton_2.cellRow = indexPath.row;
        issueButton_2.tag = 3001;
        issueButton_2.frame = CGRectMake(100,12+charContent_LB_Size.height, 100, Buttom_H);
        issueButton_2.titleLabel.font = [UIFont systemFontOfSize:15];
        [issueButton_2 setImage:[UIImage imageNamed:@"love"] forState:UIControlStateNormal];
        [issueButton_2 setTitle:@"未解决" forState:UIControlStateNormal];
        [issueButton_2 setTitleColor:ButtomTitleColorNormal forState:UIControlStateNormal];
        [issueButton_2 setTitleColor:ButtomTitleColorSelected forState:UIControlStateSelected];
        [issueButton_2 addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self.chatBGImage_IV addSubview:issueButton_2];
        
        chatBGImage_IV_W = self.charContent_LB.width+32 < 200 ? 200: self.charContent_LB.width+32;
        chatBGImage_IV_H = 12 + charContent_LB_Size.height + 30;
        
        BOOL isSelected = [[cellData valueForKey:issueButton.titleLabel.text] boolValue];
        if (isSelected) {
            issueButton.selected = YES;
        }
        
        BOOL isSelected_2 = [[cellData valueForKey:issueButton_2.titleLabel.text] boolValue];
        if (isSelected_2) {
            issueButton_2.selected = YES;
        }
        
    }else{
        NSString *maxTitle = @"";
        for (int i = 0; i<_issueAry.count ; i++) {
            NSDictionary *issueDic = _issueAry[i];
            NSString *issueTitle = [issueDic valueForKey:@"IssueTitle"];
            if (issueTitle.length>maxTitle.length) {
                maxTitle = issueTitle;
            }
            
            NSString *typeName   = [issueDic valueForKey:@"TypeName"];
            BOOL    isShow       = [[issueDic valueForKey:@"IsShow"] boolValue];
            if (isShow && !issueTitle) {//主菜单
                issueTitle = typeName;
            } else if (!isShow && !issueTitle){
                continue;
            }
            CellButton *issueButton = [CellButton buttonWithType:UIButtonTypeCustom];
            issueButton.cellRow = indexPath.row;
            issueButton.data = issueDic;
            issueButton.frame = CGRectMake(18,12+charContent_LB_Size.height+i*Buttom_H+2, 230, Buttom_H);
            issueButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            issueButton.titleEdgeInsets = UIEdgeInsetsMake(0,5, 0, 0);
            issueButton.tag = 500+i;
            issueButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [issueButton setTitle:[NSString stringWithFormat:@"%d.%@",i+1,issueTitle] forState:UIControlStateNormal];
            [issueButton setTitleColor:ButtomTitleColorNormal forState:UIControlStateNormal];
            [issueButton setTitleColor:ButtomTitleColorSelected forState:UIControlStateHighlighted];
            [issueButton setTitleColor:ButtomTitleColorSelected forState:UIControlStateSelected];
            [issueButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            [self.chatBGImage_IV addSubview:issueButton];
            
            BOOL isSelected = [[cellData valueForKey:issueButton.titleLabel.text] boolValue];
            if (isSelected) {
                issueButton.selected = YES;
            }
        }
//        CGFloat issueButton_maxW = [maxTitle boundingRectWithSize:CGSizeMake(WIDTH_SCREEN-74-18, 20000)
//                                                                            options:\
//                                      NSStringDrawingTruncatesLastVisibleLine |
//                                      NSStringDrawingUsesLineFragmentOrigin |
//                                      NSStringDrawingUsesFontLeading
//                                                                         attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
//                                                                            context:nil].size.width;
//        NSLog(@"%.2f",issueButton_maxW);
        chatBGImage_IV_W = self.charContent_LB.width+32 < 230 ? 230: self.charContent_LB.width+32;
        chatBGImage_IV_H = 12 + charContent_LB_Size.height + _issueAry.count*30 + 2;
    }

    
    self.chatBGImage_IV.frame = CGRectMake(56, 28, chatBGImage_IV_W, chatBGImage_IV_H + 18);
    self.chatBGImage_IV.userInteractionEnabled = YES;
}


-(CGFloat)getCell_H:(NSDictionary *)cellData{
    
    self.charContent_LB.text = [cellData valueForKey:@"messageContent"];
    CGSize charContent_LB_Size = [self.charContent_LB.text boundingRectWithSize:CGSizeMake(WIDTH_SCREEN-74-18, 20000)
                                                            options:\
                                                                  NSStringDrawingTruncatesLastVisibleLine |
                                                                  NSStringDrawingUsesLineFragmentOrigin |
                                                                  NSStringDrawingUsesFontLeading
                                                         attributes:@{NSFontAttributeName: self.charContent_LB.font}
                                                            context:nil].size;
    
    
    
    CGFloat cell_H;
    if ([self.charContent_LB.text isEqual:@"请问是否解决了您的问题？"]) {
         cell_H = 12 + charContent_LB_Size.height + Buttom_H + 48;
    }else{
        NSArray *issueAry   = [cellData valueForKey:@"issueAry"];
        NSArray *mainIssueAry = [cellData valueForKey:@"mainIssueAry"];
        NSInteger issueCount = issueAry.count;
        if (mainIssueAry.count) {
            issueCount +=1;
        }
         cell_H = 12 + charContent_LB_Size.height + issueCount*Buttom_H + 48;
    }
    return cell_H<80?80:cell_H;
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    if (timeString.length<1) {
        return @"";
    }
    
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    
}

@end


