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
#import <UIKit/UIKit.h>

@interface MineMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellTime_LB;
@property (weak, nonatomic) IBOutlet UIImageView *userImage_IV;
@property (weak, nonatomic) IBOutlet UIImageView *chatBGImage_IV;
@property (weak, nonatomic) IBOutlet UILabel *charContent_LB;


-(CGFloat)getCell_H:(NSDictionary *)data;

@end
