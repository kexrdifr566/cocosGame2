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

#import "ChatViewController.h"

#import "NetworkAPI.h"

#import "OtherMessageCell.h"
#import "MineMessageCell.h"
#import "CellButton.h"

#import "InformViewController.h"
#import "MessageViewController.h"
#import "OnlineServiceViewController.h"

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSString *baseURL;
}
@property(nonatomic,strong) UIButton *backBT;


@property(assign,nonatomic) CGFloat oldOffset;//TableView滚动 y 的偏移量

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;//聊天界面TableView

@property (strong, nonatomic) NSMutableArray *tableViewData;
@property (strong, nonatomic) NSArray *mainIssueAry;

@property (weak, nonatomic) IBOutlet UIView *bottomView;//默认底栏
@property (strong, nonatomic) IBOutlet UIView *kbBottomView;//输入底栏

@property (weak, nonatomic) IBOutlet UIButton *buttomBT;//玩家举报
@property (retain, nonatomic) IBOutlet UIButton *buttomBT_1;

@property (weak, nonatomic) IBOutlet UITextField *textField;//输入框
@property (weak, nonatomic) IBOutlet UIButton *sendMessageBT;

@property(assign,nonatomic) BOOL isInputStatus;//是否为输入状态

@property(nonatomic,strong) OtherMessageCell    *otherMessageCell;
@property(nonatomic,strong) MineMessageCell     *mineMessgeaCell;
@property(nonatomic,strong) UIImage *headImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bttomViewLayoutConstraint;//输入选择距离底部

@property (strong,nonatomic) MBProgressHUD *hud;

@property (nonatomic,strong) NSString *serviceURLStr;
@property (strong,nonatomic) UIAlertView *alertView;

@property (strong,nonatomic) NSDictionary *serviceData;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客服中心";
    
    baseURL = [self.userInfo valueForKey:@"url"];
    
    //设置初始视图
    [self setupUI];
    
    //请求数据
    [self requestOnlineService];
    
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.backBT.hidden = NO;
    [self.textField resignFirstResponder];
    [self addKeyboardNotificationCenter];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.backBT.hidden = YES;
    [self.textField resignFirstResponder];
    [self removKeyboardNotificationCenter];
}

#pragma mark - ---- 设置初始视图
-(void)setupUI{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];;
    [self.navigationController.navigationBar  addSubview:self.backBT];
    
    self.kbBottomView.frame = CGRectMake(0, 0, WIDTH_SCREEN, _bottomView.height);
    self.kbBottomView.hidden = YES;
    [self.bottomView addSubview:self.kbBottomView];
    
    //
    self.bottomView.layer.borderWidth = 0.5;
    self.bottomView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.buttomBT.layer.borderWidth = 0.5;
    self.buttomBT.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.buttomBT.layer.masksToBounds = YES;
    
    self.buttomBT_1.layer.borderWidth = 0.5;
    self.buttomBT_1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.buttomBT_1.layer.masksToBounds = YES;
    
    
    self.tableViewData = [[NSMutableArray alloc]init];
    self.chatTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.chatTableView.estimatedRowHeight = 81;
    
    [self.chatTableView registerNib:[UINib nibWithNibName:@"OtherMessageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OtherMessageCell"];
    self.otherMessageCell = [self.chatTableView dequeueReusableCellWithIdentifier:@"OtherMessageCell"];
    
    [self.chatTableView registerNib:[UINib nibWithNibName:@"MineMessageCell" bundle:nil] forCellReuseIdentifier:@"MineMessageCell"];
    self.mineMessgeaCell = [self.chatTableView dequeueReusableCellWithIdentifier:@"MineMessageCell"];
    
    self.sendMessageBT.layer.masksToBounds = YES;
    self.sendMessageBT.layer.cornerRadius = 3;
    
    self.headImage =  [UIImage imageNamed:@"icon_album_picture_fail_big.png"];
    NSString *headImageURL = [self.userInfo valueForKey:@"headurl"];
    if (headImageURL) {
        [self getImageWithImageURL:headImageURL];
    }
}

-(void) showAlertViewWithStr:(NSString *)str{
    self.alertView  = [[UIAlertView  alloc]initWithTitle:str message:@"" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [self.alertView  show];
}

#pragma mark  - 返回按钮
-(UIButton *)backBT{
    if (!_backBT) {
        _backBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBT.frame = CGRectMake(0, self.navigationController.navigationBar.height-40, 40, 40);
        [_backBT setImage:[UIImage imageNamed:@"App_back"] forState:UIControlStateNormal];
        [_backBT addTarget:self action:@selector(backBTAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBT;
}
-(void)backBTAction:(UIButton *)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  - 请求数据
-(void)requestNetWork{
    //请求热门话题
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:GetQuestionListHot(baseURL)]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *task =  [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            
            NSString *welcomeStr = [self.serviceData valueForKey:@"kefudesc"];
            
            NSArray *issueAry = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            //获取主菜单
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:GetQuestionType(baseURL)]];
            [urlRequest setTimeoutInterval:30.0f];
            [urlRequest setHTTPMethod:@"GET"];
            
            NSURLSessionDataTask *task  = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (data) {
                    
                    NSDictionary *otherMessageData = [[NSMutableDictionary alloc]init];
                    [otherMessageData setValue:@"OtherMessageCell" forKey:@"messageType"];
                    [otherMessageData setValue:[self getNowTimeTimestamp] forKey:@"time"];
                    [otherMessageData setValue:welcomeStr forKey:@"messageContent"];
                    [otherMessageData setValue:issueAry forKey:@"issueAry"];
                    
                    self.mainIssueAry = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    [otherMessageData setValue:self.mainIssueAry forKey:@"mainIssueAry"];
                    [self.tableViewData addObject:otherMessageData.copy];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.chatTableView reloadData];
                    });
                }
                
            }];
            [task resume];
        }
    }];
    [task resume];
    
}

-(void)searchIssueWithText:(NSString *)text{
    
    NSString *urlStr =  [GetQuestionListTitle(baseURL,text) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLSessionDataTask *task  = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSArray *issueAry = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            NSDictionary *otherMessageData = [[NSMutableDictionary alloc]init];
            [otherMessageData setValue:@"OtherMessageCell" forKey:@"messageType"];
            [otherMessageData setValue:[self getNowTimeTimestamp] forKey:@"time"];
            if (issueAry.count>0) {
                [otherMessageData setValue:@"以下是相关问题" forKey:@"messageContent"];
                [otherMessageData setValue:issueAry forKey:@"issueAry"];
            }else{
                [otherMessageData setValue:@"很抱歉，没有找到您所咨询的问题，您可以进行如下选择或继续自助查询问题。" forKey:@"messageContent"];
                issueAry = @[@{@"IssueTitle":@"留言回复"},@{@"IssueTitle":@"主菜单",@"mainIssueAry":_mainIssueAry}];
                [otherMessageData setValue:issueAry forKey:@"issueAry"];
            }
            [self.tableViewData addObject:otherMessageData.copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.chatTableView reloadData];
                [self scrollViewToBottom:NO];
            });
        }
    }];
    [task resume];
}

-(void)requestIssueWithIssueInfo:(NSDictionary *)issueInfo{
    NSString * issueID = [issueInfo valueForKey:@"ID"];
    NSString * typeName = [issueInfo valueForKey:@"TypeName"];
    //获取主菜单
    NSString *urlStr =  [GetQuestionListTypeId(baseURL,issueID) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLSessionDataTask *task  = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSArray *issueAry = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (issueAry.count>0) {
                NSDictionary *otherMessageData = [[NSMutableDictionary alloc]init];
                [otherMessageData setValue:@"OtherMessageCell" forKey:@"messageType"];
                [otherMessageData setValue:[self getNowTimeTimestamp] forKey:@"time"];
                [otherMessageData setValue:typeName forKey:@"messageContent"];
                [otherMessageData setValue:issueAry forKey:@"issueAry"];
                [self.tableViewData addObject:otherMessageData.copy];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.chatTableView reloadData];
                    [self scrollViewToBottom:NO];
                });
            }
        }
    }];
    [task resume];
    
}

-(void)requestOnlineService{
    //获取主菜单
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hud.labelText = @"加载中...";
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:GetKefu(baseURL)]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLSessionDataTask *task  = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",dict);
                int code = [[dict valueForKey:@"code"] intValue];
                NSString *msg = [dict valueForKey:@"msg"];
                if (code == 0) {
                    self.serviceData = [dict valueForKey:@"data"];
                }else{
                    [self showAlertViewWithStr:msg];
                }
                
                //请求问题列表
                [self requestNetWork];
                
            }else{
                if (error) {
                    [self showAlertViewWithStr:error.localizedDescription];
                }
            }
        });
    }];
    [task resume];
    
}

-(void)getImageWithImageURL:(NSString *)imageURL{
    dispatch_queue_t serialQueue = dispatch_queue_create("com.dispatch.serial", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        //并行想要执行的代码
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        if (imageData) {
            UIImage *image = [UIImage imageWithData:imageData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //想要在主线程中执行的代码 如刷新UI
                    self.headImage = image;
                    [self.chatTableView reloadData];
                });
            }
        }
        
    });
}

#pragma mark - ---- TableView相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary    *cellData  = self.tableViewData[indexPath.row];
    NSString        *cellType  = [cellData valueForKey:@"messageType"];
    if (self.otherMessageCell && [cellType isEqualToString:@"OtherMessageCell"]) {
        return [self.otherMessageCell getCell_H:cellData];
    }
    if (self.mineMessgeaCell && [cellType isEqualToString:@"MineMessageCell"]) {
        return [self.mineMessgeaCell getCell_H:cellData];
    }
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary    *cellData  = self.tableViewData[indexPath.row];
    NSString        *cellType  = [cellData valueForKey:@"messageType"];
    
    if ([cellType isEqualToString:@"MineMessageCell"]) {
        MineMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineMessageCell" forIndexPath:indexPath];
        [cell getCell_H:cellData];
        cell.userImage_IV.image = self.headImage;
        return cell;
    }else{
        OtherMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherMessageCell" forIndexPath:indexPath];
        [cell setupCellUIWithData:cellData WithTarget:self WithAction:@selector(issueButton:) WithIndexPath:indexPath];
        return cell;
    }
}

-(void)issueButton:(CellButton *)sender{
    NSDictionary *otherMessageData = [[NSMutableDictionary alloc]init];
    NSDictionary *cellData = sender.data;
    
    if (!sender.selected) {
        if (sender.tag == 3000 || sender.tag == 3001) {
            NSDictionary *selectedCellData = [self.self.tableViewData[sender.cellRow] mutableCopy];
            [selectedCellData setValue:[NSNumber numberWithBool:NO] forKey:@"已解决"];
            [selectedCellData setValue:[NSNumber numberWithBool:NO] forKey:@"未解决"];
            [self.self.tableViewData replaceObjectAtIndex:sender.cellRow withObject:selectedCellData.copy];
        }
        NSDictionary *selectedCellData = [self.self.tableViewData[sender.cellRow] mutableCopy];
        [selectedCellData setValue:[NSNumber numberWithBool:YES] forKey:sender.titleLabel.text];
        [self.self.tableViewData replaceObjectAtIndex:sender.cellRow withObject:selectedCellData.copy];
        
    }
    
    
    NSString *issueID = [cellData valueForKey:@"ID"] ;
    if(issueID){
        [self requestIssueWithIssueInfo:cellData];
        return;
    }
    
    NSString *issueTitle = [cellData valueForKey:@"IssueTitle"];
    if ([issueTitle isEqual:@"留言回复"]) {
        MessageViewController *VC = [[MessageViewController alloc]init];
        VC.userInfo = self.userInfo;
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }
    
    NSString *issueContent = [cellData valueForKey:@"IssueContent"];
    NSArray *issueAry = [cellData valueForKey:@"mainIssueAry"];
    
    [otherMessageData setValue:@"OtherMessageCell" forKey:@"messageType"];
    [otherMessageData setValue:[self getNowTimeTimestamp] forKey:@"time"];
    
    if (issueAry.count>0) {
        [otherMessageData setValue:issueTitle forKey:@"messageContent"];
        [otherMessageData setValue:issueAry forKey:@"issueAry"];
        [self.tableViewData addObject:otherMessageData.copy];
    }else{
        if (sender.tag == 3000) {
            [otherMessageData setValue:@"感谢你对小雅的支持，么么哒~" forKey:@"messageContent"];
            [self.tableViewData addObject:otherMessageData.copy];
        }else if (sender.tag == 3001) {
            [otherMessageData setValue:@"很抱歉，没有找到您所咨询的问题，您可以进行如下选择或继续自助查询问题。" forKey:@"messageContent"];
            issueAry = @[@{@"IssueTitle":@"留言回复"},@{@"IssueTitle":@"主菜单",@"mainIssueAry":_mainIssueAry}];
            [otherMessageData setValue:issueAry forKey:@"issueAry"];
            [self.tableViewData addObject:otherMessageData.copy];
        }else{
            [otherMessageData setValue:issueContent forKey:@"messageContent"];
            [self.tableViewData addObject:otherMessageData.copy];
            [otherMessageData setValue:@"请问是否解决了您的问题？" forKey:@"messageContent"];
            [self.tableViewData addObject:otherMessageData.copy];
        }
    }
    [self.chatTableView reloadData];
    [self scrollViewToBottom:NO];
}


//  - tableView滑到最底部
- (void)scrollViewToBottom:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.tableViewData.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark - ---- 键盘通知消息
//注册 键盘通知消息
-(void)addKeyboardNotificationCenter{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}


-(void)KeyboardWillShowNotification:(NSNotification *)notification{
    self.isInputStatus = YES;
    CGRect keyboardFrameEnd = [[notification.userInfo valueForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    self.bttomViewLayoutConstraint.constant = keyboardFrameEnd.size.height;
    self.oldOffset = self.chatTableView.contentOffset.y+keyboardFrameEnd.size.height;
    [self.chatTableView setContentOffset:CGPointMake(0, self.oldOffset) animated:NO];
    
}

-(void)KeyboardWillHideNotification:(NSNotification *)notification{
    self.isInputStatus = NO;
    self.bttomViewLayoutConstraint.constant = 0;
}

//移除 所有通知消息
-(void)removKeyboardNotificationCenter{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ---- 切换输入状态
- (IBAction)changeKeyboardBTAction:(UIButton *)sender
{
    if (self.kbBottomView.hidden) {
        [self.textField becomeFirstResponder];
        self.kbBottomView.hidden = NO;
    }else{
        [self.textField resignFirstResponder];
        self.kbBottomView.hidden = YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendBTAction:nil];
    return YES;
}

- (IBAction)sendBTAction:(UIButton *)sender {
    if (self.textField.text.length>0) {
        
        NSDictionary *sendMessageData = [[NSMutableDictionary alloc]init];
        [sendMessageData setValue:@"MineMessageCell" forKey:@"messageType"];
        [sendMessageData setValue:[self getNowTimeTimestamp] forKey:@"time"];
        [sendMessageData setValue:self.textField.text forKey:@"messageContent"];
        
        [self.tableViewData addObject:sendMessageData.copy];
        
        [self.chatTableView reloadData];
        [self scrollViewToBottom:NO];
        [self searchIssueWithText:self.textField.text];
        self.textField.text = @"";
    }
}


#pragma mark - ---- 底部按钮事件 玩家举报、留言回复
- (IBAction)bottomBTActom:(UIButton *)sender {
    NSLog(@"%@",self.tableViewData);
    [self.textField resignFirstResponder];
    if(sender.tag == 200){//玩家举报
        InformViewController *VC = [[InformViewController alloc]init];
        VC.userInfo = self.userInfo;
        [self.navigationController pushViewController:VC animated:YES];
        
    }else if(sender.tag == 201){//留言回复
        MessageViewController *VC = [[MessageViewController alloc]init];
        VC.userInfo = self.userInfo;
        [self.navigationController pushViewController:VC animated:YES];
    }else{//在线客服
        [self pushOnlineService];
    }
}

-(CGFloat) calculateCell_H{
    
    return 10;
}

//在线客服按钮点击事件
-(void)pushOnlineService{
    NSString *kefuinfo = [self.serviceData valueForKey:@"kefuinfo"];
    if (kefuinfo.length>2) {//使用弹出的警告框
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"联系方式" message:kefuinfo delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alertView show];
    }else{
        //如果有QQ号码  直接跳转到QQ
        NSString *qqNumber = [self.serviceData valueForKey:@"qq"];
        if (qqNumber.length>3) {
            [self openQQWithNumber:qqNumber];
        }else{//内嵌网页客服
            OnlineServiceViewController *VC = [[OnlineServiceViewController alloc]init];
            VC.webViewURL = [self.serviceData valueForKey:@"kefu53"];;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}


-(void)openQQWithNumber:(NSString *)qqNumber{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqNumber]];
        [[UIApplication sharedApplication]openURL:url];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"nil" message:@"对不起，您还没安装QQ" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            return ;
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(NSString *)getNowTimeTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}



#pragma mark - ---- 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
