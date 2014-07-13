#import "GalleryViewController.h"
#import "SWTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface GalleryViewController ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation GalleryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *menuButtonImage = [UIImage imageNamed:@"list.png"];// set your image Name here
    UIButton *btnToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnToggle setImage:menuButtonImage forState:UIControlStateNormal];
    btnToggle.frame = CGRectMake(0, 0, menuButtonImage.size.width + 20, menuButtonImage.size.height);
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnToggle];
    [btnToggle addTarget:self action:@selector(goToBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Challenges" style:UIBarButtonItemStylePlain target:self action:@selector(gotoChallenge)];
    
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    [self loadQuestion:nil];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ContentCellIdentifier = @"ContentCell";
    SWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ContentCellIdentifier];
    UIImageView *imgView;
    UILabel *lblLikes;
    UILabel *mainLabel;
    if (cell == nil) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContentCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *view =[[UIView alloc] init];
        CGRect intFrame = CGRectInset(cell.contentView.bounds, 10, 5);
        view.frame = CGRectMake(intFrame.origin.x, intFrame.origin.y, intFrame.size.width, 80);
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 2.0; // if you like rounded corners
        view.layer.masksToBounds = NO;
        view.layer.shadowOffset = CGSizeMake(0, 0);
        view.layer.shadowRadius = 1;
        view.layer.shadowOpacity = 1.0;
        view.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:2.0].CGPath;
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 7, 70, 70)];
        //imgView.layer.borderWidth = 0.5;
        //imgView.layer.borderColor = [UIColor colorFromHexCode:@"#6C6C6C"].CGColor;
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = 4.0; // if you like rounded corners
        imgView.tag = 11;
        
        mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 28.0, self.view.bounds.size.width - 150, 25.0)];
        mainLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:16];
        mainLabel.textAlignment = UITextAlignmentLeft;
        mainLabel.textColor = [UIColor blackColor];
        mainLabel.backgroundColor = [UIColor clearColor];
        mainLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        mainLabel.tag = 10;
        
        
        UIImageView *imglikeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ribbon"]];
        imglikeView.center = CGPointMake(view.frame.size.width - 30, 35);
        lblLikes = [[UILabel alloc] initWithFrame:CGRectMake(8, 12, 25, 34)];
        lblLikes.tag = 15;
        lblLikes.backgroundColor = [UIColor greenColor];
        lblLikes.textAlignment = NSTextAlignmentCenter;
        lblLikes.adjustsFontSizeToFitWidth = YES;
        lblLikes.backgroundColor = [UIColor clearColor];
        lblLikes.textColor = [UIColor greenColor];
        lblLikes.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:14];
        
        [view addSubview:imglikeView];
        [imglikeView addSubview:lblLikes];
        [view addSubview:imgView];
        [view addSubview:mainLabel];
        [cell.contentView addSubview:view];
        [cell setDelegate:self];
        
    } else {
        imgView = (id)[cell viewWithTag:11];
        mainLabel = (id) [cell viewWithTag:10];
        lblLikes = (id) [cell viewWithTag:15];
    }
    
    NSDictionary *item = [_items objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://iavian.com/render.php?i=%@&s=340",[item objectForKey:@"id"]]];
    [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageRetryFailed];
    mainLabel.text = [item objectForKey:@"t"];
    lblLikes.text = [item objectForKey:@"rp"];
    return cell;
}

-(NSString *) uniqueId {
    NSString *uniqueId = [GKLocalPlayer localPlayer].playerID;
    if (uniqueId == nil) {
        if ([[UIDevice currentDevice] respondsToSelector:NSSelectorFromString(@"identifierForVendor")]) {
            uniqueId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        }
    }
    return  uniqueId;
}

-(void) loadQuestion:(id) sender {
    NSString *URLPath = [NSString stringWithFormat:@"https://iavian.net/im/getquestions?u=%@", [[self uniqueId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSArray class]]) {
                self.items = [NSMutableArray arrayWithArray:res];
            } else {
                self.items = nil;
            }
        } else {
            self.items = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            if(sender) {
                [sender endRefreshing];
            }
        });
    }];
}

- (void) goToBack {
    [self.navigationController popViewControllerAnimated:YES];
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
