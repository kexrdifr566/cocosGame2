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

#import "OnlineServiceViewController.h"
#import "NetworkAPI.h"

@interface OnlineServiceViewController ()<UIWebViewDelegate>
{
    NSString *baseURL;
}
@property (strong,nonatomic) UIAlertView *alertView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation OnlineServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线客服";
   
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


- (void)dealloc {
    [_activityIndicatorView release];
    [super dealloc];
}
@end

