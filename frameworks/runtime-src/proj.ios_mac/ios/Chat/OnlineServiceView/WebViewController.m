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

#import "WebViewController.h"
#import "NetworkAPI.h"

@interface WebViewController ()<UIWebViewDelegate>
{
    NSString *baseURL;
}
@property(nonatomic,strong) UIButton *backBT;
@property (strong,nonatomic) UIAlertView *alertView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"App_top"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"App_top"] forBarMetrics:UIBarMetricsDefault];
    //self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationController.navigationBar  addSubview:self.backBT];
   
     //[self.navigationController.navigationBar  setBackgroundImage:[UIImage imageNamed:@"title_bg_0.png"] forBarMetrics:UIBarMetricsDefault];
    [self loadWebView];
    
}

-(void)loadWebView{
    if (self.webViewURL.length>5) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webViewURL]];
        [self.webView loadRequest:request];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.backBT.hidden = YES;
    [self.webView stopLoading];
}

-(void) showAlertViewWithStr:(NSString *)str{
    self.alertView  = [[UIAlertView  alloc]initWithTitle:str message:@"" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [self.alertView  show];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.activityIndicatorView.hidden = NO;
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.activityIndicatorView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.backBT.hidden = NO;
    //[self addKeyboardNotificationCenter];
}

#pragma mark  - 返回按钮
-(UIButton *)backBT{
    if (!_backBT) {
        _backBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBT.frame = CGRectMake(0, self.navigationController.navigationBar.origin.y, 40, 40);
        //_backBT.frame = CGRectMake(0, 50, 40, 40);
        [_backBT setImage:[UIImage imageNamed:@"App_back_0"] forState:UIControlStateNormal];
        //[_backBT setImage:[UIImage imageNamed:@"back_0.png"] forState:UIControlStateNormal];
        
        [_backBT addTarget:self action:@selector(backBTAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBT;
}
-(void)backBTAction:(UIButton *)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}- (void)dealloc {
    [_activityIndicatorView release];
    [super dealloc];
}
@end

