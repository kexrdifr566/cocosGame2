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

#import "MineMessageCell.h"
#import "UIView+Extension.h"

@implementation MineMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(CGFloat)getCell_H:(NSDictionary *)data{
    
    self.cellTime_LB.text = [self timeWithTimeIntervalString:[data valueForKey:@"time"]];
    self.charContent_LB.text = [data valueForKey:@"messageContent"];
    
    CGSize charContent_LB_Size = [self.charContent_LB.text boundingRectWithSize:CGSizeMake(WIDTH_SCREEN-74-18, 20000)
                                                                        options:\
                                  NSStringDrawingTruncatesLastVisibleLine |
                                  NSStringDrawingUsesLineFragmentOrigin |
                                  NSStringDrawingUsesFontLeading
                                                                     attributes:@{NSFontAttributeName: self.charContent_LB.font}
                                                                        context:nil].size;
    self.charContent_LB.frame = CGRectMake(15, 12, charContent_LB_Size.width, charContent_LB_Size.height);
    [self.chatBGImage_IV addSubview:self.charContent_LB];
    
    self.chatBGImage_IV.frame = CGRectMake(WIDTH_SCREEN - charContent_LB_Size.width - 88, 28, self.charContent_LB.width+32, charContent_LB_Size.height + 32);
    
    CGFloat cell_H = self.chatBGImage_IV.y + self.chatBGImage_IV.height;
    return cell_H;
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    if (timeString.length<1) {
        return @"";
    }
    // 格式化时间
    NSTimeInterval interval    =    [timeString doubleValue];
    NSDate *date               =    [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

- (NSString *)formateDate:(NSString *)dateString
{
    @try {
        // ------实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//这里的格式必须和DateString格式一致
        
        NSDate * nowDate = [NSDate date];
        
        // ------将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        
        // ------取当前时间和转换时间两个日期对象的时间间隔
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        NSLog(@"time----%f",time);
        // ------再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = [[NSString alloc] init];
        
        if (time<=60) {  //1分钟以内的
            
            dateStr = @"刚刚";
            
        }else if(time<=60*60){  //一个小时以内的
            
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
            
        }else if(time<=60*60*24){  //在两天内的
            
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                //在同一天
                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }else{
                //昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                //在同一年
                [dateFormatter setDateFormat:@"MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
    
    
}
@end
