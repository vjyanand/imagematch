#import "GalleryViewController.h"
#import "SWTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GalleryCellView.h"
#import "AAShareBubbles.h"
#import "ChallengesViewController.h"
#import "MBHUDView.h"

@interface GalleryViewController ()<AAShareBubblesDelegate>

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
    
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    [self loadQuestion:nil];
    
}

-(void) gotoChallenge {
    ChallengesViewController *controller = [[UIStoryboard storyboardWithName:@"Storyboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"challenge"];
    
    NSArray *vc = @[[self.navigationController.viewControllers objectAtIndex:0], controller];
    [self.navigationController setViewControllers:vc animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"gallcell"];
    
    NSDictionary *item = [_items objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://iavian.com/render.php?i=%@&s=340",[item objectForKey:@"id"]]];
    [cell.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageRetryFailed];
    cell.mainLabel.text = [item objectForKey:@"t"];
    cell.lblLikes.text = [item objectForKey:@"rp"];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    return cell;
}

-(void)aaShareBubblesDidHide:(AAShareBubbles *)shareBubbles {
    [shareBubbles.superview removeFromSuperview];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIWindow* mainWindow = [[[UIApplication sharedApplication] delegate] window];
    UIView *modalView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    modalView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    [mainWindow addSubview:modalView];
    
    AAShareBubbles *shareBubbles = [[AAShareBubbles alloc] initWithPoint:self.view.center
                                                                  radius:100
                                                                  inView:modalView];
    shareBubbles.delegate = self;
    shareBubbles.bubbleRadius = 40; // Default is 40
    shareBubbles.showFacebookBubble = YES;
    shareBubbles.showTwitterBubble = YES;
    shareBubbles.showMailBubble = YES;
    [shareBubbles show];
    
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.18f green:0.18f blue:0.85f alpha:.8] title:@"Challenge"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:.9f]
                                                title:@"Remove"];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if (index == 0 && [cell.rightUtilityButtons count] == 2) {
        GKMatchRequest *request = [[GKMatchRequest alloc] init];
        request.minPlayers = 2;
        request.maxPlayers = 10;
        GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
        mmvc.turnBasedMatchmakerDelegate = self;
        mmvc.showExistingMatches = NO;
        _indexPath = indexPath;
        [self presentViewController:mmvc animated:YES completion:nil];
        [cell hideUtilityButtonsAnimated:YES];
    } else {
        NSString *URLPath = [NSString stringWithFormat:@"https://iavian.net/im/getquestion?d=1&u=%@&q=%d", [[self uniqueId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[[_items objectAtIndex:indexPath.row] objectForKey:@"id"] intValue]];
        [_items removeObjectAtIndex:indexPath.row];
        
        NSURL *URL = [NSURL URLWithString:URLPath];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
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

- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController playerQuitForMatch:(GKTurnBasedMatch *)match {
    
}

- (void)turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    
}

- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)match {
    [self dismissViewControllerAnimated:YES completion:^{
        NSData *postData = [NSJSONSerialization dataWithJSONObject:[_items objectAtIndex:_indexPath.row] options:0 error:nil];
        GKTurnBasedParticipant *nextPlayer;
        if (match.currentParticipant == [match.participants objectAtIndex:0]) {
            nextPlayer = [[match participants] lastObject];
        } else {
            nextPlayer = [[match participants] objectAtIndex:0];
        }
        match.message = [NSString stringWithFormat:@"New challenge:%@ from %@", [[_items objectAtIndex:_indexPath.row] objectForKey:@"s"], [GKLocalPlayer localPlayer].alias];
        
        [match endTurnWithNextParticipants:@[nextPlayer] turnTimeout:360 matchData:postData completionHandler:^(NSError *error) {
            if(error == nil) {
                [MBHUDView hudWithBody:@"Challege created" type:MBAlertViewHUDTypeCheckmark hidesAfter:1.0 show:YES];
            }
        }];
    }];
}

@end
