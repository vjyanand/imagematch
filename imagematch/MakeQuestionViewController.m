#import "MakeQuestionViewController.h"
#import "UIImageView+WebCache.h"
#import "MBHUDView.h"
#import "MBSpinningCircle.h"

@interface MakeQuestionViewController ()

@property (nonatomic, strong) NSString *searchKey;
@property (nonatomic, strong) UIImageView *imgHolder1;
@property (nonatomic, strong) UIImageView *imgHolder2;
@property (nonatomic, strong) UIImageView *imgHolder3;
@property (nonatomic, strong) UIImageView *imgHolder4;
@property (nonatomic, strong) NSArray *imgURLs;
@property (nonatomic, strong) NSString *scramble;
@property (nonatomic, assign) int qID;

@end

@implementation MakeQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    int strLength = (int)[_searchKey length];
    int boxSpace = 10;
    if (strLength > 7) {
        boxSpace = 6;
    }
    int screenWidth = self.view.bounds.size.width;
    
    int boxSize = (screenWidth - 30 - (boxSpace * (strLength -1))) / strLength;
    if(boxSize > 40) boxSize = 40;
    
    int width = (boxSize * strLength) + (boxSpace * (strLength -1));
    int startPoint = (screenWidth - width) / 2;
    int yPoint = (self.view.bounds.size.height - 310.0)/2;
    for (int i=0; i < strLength; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint, yPoint - 4, boxSize, boxSize)];
        titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.layer.borderWidth = .4;
        titleLabel.text = [[NSString stringWithFormat:@"%c",[_searchKey characterAtIndex:i]] uppercaseString] ;
        [self.view addSubview:titleLabel];
        startPoint = startPoint + boxSize + boxSpace;
    }
    
    boxSize = 100;
    int boxHeight = 100;
    boxSpace = 10;
    width = (boxSize * 2) + (boxSpace);
    startPoint = (screenWidth - width) / 2;
    yPoint += 52;
    self.imgHolder1 = [[UIImageView alloc] initWithFrame:CGRectMake(startPoint, yPoint, boxSize, boxHeight)];
    self.imgHolder2 = [[UIImageView alloc] initWithFrame:CGRectMake(startPoint + boxSize + boxSpace, yPoint, boxSize, boxHeight)];
    self.imgHolder3 = [[UIImageView alloc] initWithFrame:CGRectMake(startPoint, yPoint + boxSpace + boxHeight, boxSize, boxHeight)];
    self.imgHolder4 = [[UIImageView alloc] initWithFrame:CGRectMake(startPoint + boxSize + boxSpace, yPoint + boxSpace + boxHeight, boxSize, boxHeight)];
    
    _imgHolder1.layer.borderWidth = .5f;
    _imgHolder1.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor;
    _imgHolder2.layer.borderWidth = .5f;
    _imgHolder2.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor;
    _imgHolder3.layer.borderWidth = .5f;
    _imgHolder3.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor;
    _imgHolder4.layer.borderWidth = .5f;
    _imgHolder4.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor;
    
    [_imgHolder1 sd_setImageWithURL:[NSURL URLWithString:[_imgURLs objectAtIndex:0]] placeholderImage:nil options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
    [_imgHolder2 sd_setImageWithURL:[NSURL URLWithString:[_imgURLs objectAtIndex:1]] placeholderImage:nil options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
    [_imgHolder3 sd_setImageWithURL:[NSURL URLWithString:[_imgURLs objectAtIndex:2]] placeholderImage:nil options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
    [_imgHolder4 sd_setImageWithURL:[NSURL URLWithString:[_imgURLs objectAtIndex:3]] placeholderImage:nil options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
    
    [self.view addSubview:_imgHolder1];
    [self.view addSubview:_imgHolder2];
    [self.view addSubview:_imgHolder3];
    [self.view addSubview:_imgHolder4];
    
    int numBoxes = 14;
    if (strLength == 3) {
        numBoxes = 8;
    } else if (strLength == 4 || strLength == 5 ) {
        numBoxes = 10;
    }
    
    NSString *finalStr = [NSString stringWithFormat:@"%@%@", _searchKey, [self genRandStringLength:(numBoxes - strLength)]];
    NSMutableArray *chars = [[NSMutableArray alloc] initWithCapacity:[finalStr length]];
    for (int i=0; i < [finalStr length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%C", [finalStr characterAtIndex:i]];
        [chars addObject:ichar];
    }
    
    for (NSUInteger i = 0; i < [finalStr length]; i++) {
        NSUInteger j = arc4random() % ([finalStr length] - 1);
        if (j != i) {
            [chars exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
    
    self.scramble = [chars componentsJoinedByString:@""];
    yPoint = yPoint + boxSpace + boxHeight + boxHeight + 20;
    boxSize = 40;
    if (numBoxes == 14) {
        boxSize = 35;
    }
    boxSpace = 10;
    int cols = [chars count] / 2 ;
    width = (boxSize * cols) + (boxSpace * (cols -1));
    startPoint = (screenWidth - width) / 2;
    for (int i=0; i < cols; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint, yPoint, boxSize, boxSize)];
        titleLabel.layer.borderColor = [UIColor redColor].CGColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.layer.borderWidth = 0.4;
        titleLabel.layer.shadowColor = [UIColor grayColor].CGColor;
        titleLabel.layer.shadowRadius = .4f;
        titleLabel.layer.shadowOpacity = .9;
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        titleLabel.layer.shadowOffset = CGSizeZero;
        titleLabel.layer.masksToBounds = NO;
        titleLabel.text = [[NSString stringWithFormat:@"%@",[chars objectAtIndex:i]] uppercaseString] ;
        [self.view addSubview:titleLabel];
        startPoint = startPoint + boxSize + boxSpace;
    }
    
    yPoint = yPoint + boxSize + 15;
    startPoint = (screenWidth - width) / 2;
    
    for (int i=0; i < cols; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint, yPoint, boxSize, boxSize)];
        titleLabel.layer.borderColor = [UIColor redColor].CGColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        titleLabel.layer.borderWidth = 0.4;
        titleLabel.layer.shadowColor = [UIColor grayColor].CGColor;
        titleLabel.layer.shadowRadius = 2.0f;
        titleLabel.layer.shadowOpacity = .9;
        titleLabel.layer.shadowOffset = CGSizeZero;
        titleLabel.layer.masksToBounds = NO;
        titleLabel.text = [[NSString stringWithFormat:@"%@",[chars objectAtIndex:(i + cols)]] uppercaseString] ;
        [self.view addSubview:titleLabel];
        startPoint = startPoint + boxSize + boxSpace;
    }
    
    //yPoint = yPoint + 60.0;
    //width = (100 * 2) + (boxSpace);
    //startPoint = (screenWidth - width) / 2;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(bCancel)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(bChallenge:)];
    
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [leftButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor grayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
   
    
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.leftBarButtonItem = leftButton;
    // Do any additional setup after loading the view.
}

-(void) bCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) bChallenge:(id)sender {
    
    [MBHUDView hudWithBody:@"Wait." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:0.0 show:YES];
    
    NSString *post =[NSString stringWithFormat:@"i=%@&i=%@&i=%@&i=%@&t=%@&s=%@&u=%@",[_imgURLs objectAtIndex:0], [_imgURLs objectAtIndex:1], [_imgURLs objectAtIndex:2], [_imgURLs objectAtIndex:3], _searchKey, _scramble, [GKLocalPlayer localPlayer].playerID];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://iavian.net/im/create"] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBHUDView dismissCurrentHUD];
            if (httpResponse.statusCode != 200) {
                [MBHUDView hudWithBody:@"Retry after sometime" type:MBAlertViewHUDTypeExclamationMark hidesAfter:4.0 show:YES];
            } else {
                id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                self.qID = [[res objectForKey:@"i"] intValue];
                MBAlertView *alert = [MBAlertView alertWithBody:@"Game created.Do you want to challenge now?" cancelTitle:@"Cancel" cancelBlock:^{[self.navigationController popToRootViewControllerAnimated:YES];}];
                [alert setBackgroundAlpha:0.8];
                [alert addButtonWithText:@"Challenge" type:MBAlertViewItemTypePositive block:^{
                    //[self showGKTurnBasedMatchmakerViewController];
                }];
                [alert addToDisplayQueue];
            }
        });
    }];
}

- (void)setTitle:(NSString *)searchKey andImages:(NSArray *)imgArrays {
    self.searchKey = searchKey;
    self.imgURLs = imgArrays;
}

-(NSString *) genRandStringLength: (int) len {
    NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
