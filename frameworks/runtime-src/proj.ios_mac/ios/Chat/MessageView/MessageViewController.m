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

#import "MessageViewController.h"
#import "NetworkAPI.h"

#import "MessageViewCell.h"
#import "MBProgressHUD.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate>
{
    NSString *baseURL;
}
@property (weak, nonatomic) IBOutlet UIView *topSelectedView;//顶部绿色的横线
@property (weak, nonatomic) IBOutlet UIButton *topSelectedBT_1;//我要留言 按钮
@property (weak, nonatomic) IBOutlet UIButton *topSelectedBT_2;//留言历史 按钮

@property (weak, nonatomic) IBOutlet UIView *informView;//留言视图 背景视图

@property (strong, nonatomic) IBOutlet UIView *pickerBGView;//滚轮视图 背景视图
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *pickerViewBT;//滚轮视图的 “完成” 按钮

@property (weak, nonatomic) IBOutlet UITextField *informIDTextField;//留言ID 输入框
@property (weak, nonatomic) IBOutlet UIButton *informTypeBT;//留言类型 按钮
@property (weak, nonatomic) IBOutlet UITextView *informContentTextView;//留言内容 输入框

@property (strong,nonatomic) NSArray *pickerViewData;//留言类型
@property (weak, nonatomic) IBOutlet UIButton *commitBT;//提交

@property (strong, nonatomic) IBOutlet UITableView *tableView;//历史留言列表
@property (strong,nonatomic) NSMutableArray *historyData;//历史数组
@property (strong,nonatomic) NSMutableDictionary *showCellData;//点击 cell展开记录

@property (strong,nonatomic) NSString *userid,*signature,*time,*contact,*typeid,*content;
@property (strong,nonatomic) MBProgressHUD *hud;
@property (strong,nonatomic) UIAlertView *alertView;

@property (strong,nonatomic) MessageViewCell *messageViewCell;


@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"玩家留言";
    
    self.historyData    = [[NSMutableArray alloc]init];
    self.showCellData    = [[NSMutableDictionary alloc]init];
    
    if (self.userInfo) {
         baseURL = [self.userInfo valueForKey:@"url"];
        self.userid = [NSString stringWithFormat:@"%@",[self.userInfo valueForKey:@"userid"]];
        self.signature  = [NSString stringWithFormat:@"%@",[self.userInfo valueForKey:@"signature"]];
        self.time  = [NSString stringWithFormat:@"%@",[self.userInfo valueForKey:@"time"]];
    }
    self.contact  = @"";
    self.content = @"";
    
    [self setupUI];
    [self requestReportWithTypeid];
}


#pragma mark - ---- 设置初始视图
-(void)setupUI{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];;
    //添加 留言历史 到 留言视图 上
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageViewCell" bundle:nil] forCellReuseIdentifier:@"MessageViewCell"];
    self.messageViewCell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageViewCell"];
    
    //添加 留言类型滚轮视图 到 留言视图 上
    self.pickerBGView.frame = CGRectMake(0, self.informView.height-self.pickerBGView.height,  self.informView.width, self.pickerBGView.height);
    self.pickerBGView.hidden = YES;
    [self.informView addSubview:self.pickerBGView];
    
    self.pickerViewBT.layer.cornerRadius = 2;
    self.pickerViewBT.layer.masksToBounds = YES;
    
    self.commitBT.layer.cornerRadius = 3;
    self.commitBT.userInteractionEnabled = NO;
    
}

-(void) showAlertViewWithStr:(NSString *)str{
    self.alertView  = [[UIAlertView  alloc]initWithTitle:str message:@"" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [self.alertView  show];
}

#pragma mark - ---- 数据请求
-(void)requestReportWithTypeid
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:GetMessageTypeID(baseURL)]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLSessionDataTask *task  = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            self.pickerViewData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.pickerView reloadAllComponents];
            });
        }
    }];
    [task resume];
}

-(void)requestReportWithUserid:(NSString *)userid WithSignature:(NSString *)signature
                      WithTime:(NSString *)time WithContact:(NSString *)contact
                    WithTypeid:(NSString *)typeid WithContent:(NSString *)content
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hud.labelText = @"提交中...";
    
    NSString *urlStr =  [GetMessage(baseURL,userid,signature,time,contact,typeid,content) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLSessionDataTask *task  = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                int code = [[dict valueForKey:@"code"] intValue];
                NSString *msg = [dict valueForKey:@"msg"];
                [self showAlertViewWithStr:msg];
                if (code == 0) {
                    [self typeSelectedBTACtion:self.topSelectedBT_2];
                    [self resetView];
                }
            }else{
                if (error) {
                    [self showAlertViewWithStr:error.localizedDescription];
                }
            }
        });
    }];
    [task resume];
}

-(void)requestReportListWithUserid:(NSString *)userid WithSignature:(NSString *)signature
                          WithTime:(NSString *)time
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hud.labelText = @"加载中...";
    
    NSString *urlStr =  [GetMessageList(baseURL,userid,signature,time) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    NSURLSessionDataTask *task  = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            if (data) {
                self.historyData  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                [self.tableView reloadData];
            }else{
                if (error) {
                    [self showAlertViewWithStr:error.localizedDescription];
                }
            }
        });
    }];
    [task resume];
}

#pragma mark - ---- textField相关
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return  [textField resignFirstResponder];
}

- (IBAction)textFieldEditChanged:(UITextField *)sender {
    if (sender.text.length>3) {
        self.commitBT.backgroundColor = [UIColor colorWithRed:110/255.0 green:204/255.0 blue:43/255.0 alpha:1.0];
        self.commitBT.userInteractionEnabled = YES;
    }else{
        self.commitBT.backgroundColor = [UIColor lightGrayColor];
        self.commitBT.userInteractionEnabled = NO;
    }
}

#pragma mark - ---- UITextView相关
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"留言内容";
        textView.textColor = [UIColor grayColor];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"留言内容"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}


-(void)hiddenKeyboard{
    [self.informIDTextField resignFirstResponder];
    [self.informContentTextView resignFirstResponder];
}

#pragma mark - ---- PickerView相关
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickerViewData.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title = [self.pickerViewData[row] valueForKey:@"TypeName"];
    return  title;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *title = [self.pickerViewData[row] valueForKey:@"TypeName"];
    self.typeid = [NSString stringWithFormat:@"%@",[self.pickerViewData[row] valueForKey:@"ID"]];
    [self.informTypeBT setTitle:title forState:UIControlStateNormal];
    [self.informTypeBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

#pragma mark - ---- TableView相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historyData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [NSString stringWithFormat:@"cell_%ld",(long)indexPath.row];
    NSString *isOpen = [[self.showCellData valueForKey:key] valueForKey:@"isOpen"];
    
    if ([isOpen isEqual:@"Yes"] && self.messageViewCell) {
        return [self.messageViewCell getCell_H:self.historyData[indexPath.row]];
    }
    return 44.5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [NSString stringWithFormat:@"cell_%ld",(long)indexPath.row];
    NSString *isOpen = [[self.showCellData valueForKey:key] valueForKey:@"isOpen"];
    
    MessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageViewCell" forIndexPath:indexPath];
    [cell.cellBT addTarget:self action:@selector(cellBTAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.cellBT.tag = indexPath.row;
    cell.cellData = self.historyData[indexPath.row];
    cell.jian_IV.highlighted = NO;
    if ([isOpen isEqual:@"Yes"]) {
        cell.jian_IV.highlighted = YES;
    }
    return cell;
}

-(void)cellBTAction:(UIButton *)sender{
    
    NSString *key = [NSString stringWithFormat:@"cell_%ld",(long)sender.tag];
    NSString *isOpen = [[self.showCellData valueForKey:key] valueForKey:@"isOpen"];
    
    if ([isOpen isEqual:@"Yes"]) {
        [self.showCellData setValue:@{@"isOpen":@"No"} forKey:key];
    }else{
        [self.showCellData setValue:@{@"isOpen":@"Yes"} forKey:key];
    }
    [self.tableView reloadData];
}


#pragma mark - ---- 顶部切换按钮 点击事件
- (IBAction)typeSelectedBTACtion:(UIButton *)sender {
    [self hiddenKeyboard];
    
    self.topSelectedView.x = sender.x;
    
    if (sender == self.topSelectedBT_1) {//我要留言
        self.topSelectedBT_1.selected = YES;
        self.topSelectedBT_2.selected = NO;
        
        self.informView.hidden = NO;
        self.tableView.hidden = YES;
        
    }else{//留言历史
        self.topSelectedBT_1.selected = NO;
        self.topSelectedBT_2.selected = YES;
        
        self.informView.hidden = YES;
        self.tableView.hidden = NO;
        self.tableView.frame = CGRectMake(self.informView.x, self.informView.y, self.informView.width, HEIGHT_SCREEN - self.informView.y-64);
        [self requestReportListWithUserid:self.userid WithSignature:self.signature WithTime:self.time];
    }
}

#pragma mark - ---- 留言类型按钮 点击事件
- (IBAction)selectedInformTypeBTACtion:(UIButton *)sender {
    self.pickerBGView.frame = CGRectMake(0, self.informView.height-self.pickerBGView.height,  self.informView.width, self.pickerBGView.height);
    
    if (!self.typeid) {
        NSString *title = [self.pickerViewData[0] valueForKey:@"TypeName"];
        self.typeid =  [NSString stringWithFormat:@"%@",[self.pickerViewData[0] valueForKey:@"ID"]];
        [self.informTypeBT setTitle:title forState:UIControlStateNormal];
        [self.informTypeBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    [self completeBTAction:nil];
}
// 滚轮视图 - “完成”按钮 点击事件
- (IBAction)completeBTAction:(UIButton *)sender {
    [self hiddenKeyboard];
    if (self.pickerBGView.hidden) {
        self.pickerBGView.hidden = NO;
    }else{
        self.pickerBGView.hidden = YES;
    }
}

//
- (IBAction)tapGestureRecognizerAction:(UITapGestureRecognizer *)sender {
    self.pickerBGView.hidden = YES;
    [self hiddenKeyboard];
}

-(void)resetView{
    self.informIDTextField.text = @"";
    
    [self.informTypeBT setTitle:@"请选择留言类型" forState:UIControlStateNormal];
    [self.informTypeBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.typeid = @"";
    
    self.informContentTextView.text = @"留言内容";
    self.informContentTextView.textColor = [UIColor grayColor];

    self.commitBT.userInteractionEnabled = NO;
}

#pragma mark - ---- 提交按钮 点击事件
- (IBAction)commitBTAction:(UIButton *)sender {
    [self hiddenKeyboard];
    
    self.contact = self.informIDTextField.text;//联系方式
    self.content  = self.informContentTextView.text;
    if (self.contact.length<1) {
        [self showAlertViewWithStr:@"联系方式不能为空"];
    }
    else if ([self.informContentTextView.text isEqualToString:@"留言内容"]
               ||[self.informContentTextView.text isEqualToString:@""]){
        self.content = @"";
        [self showAlertViewWithStr:@"留言内容不能为空"];
    }
    else if (self.typeid.length<1){
        [self showAlertViewWithStr:@"请选择留言类型"];
    }
    else{
        [self requestReportWithUserid:self.userid
                        WithSignature:self.signature
                             WithTime:self.time
                           WithContact:self.contact
                           WithTypeid:self.typeid
                          WithContent:self.content];
    }
}



#pragma mark - ---- 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end

