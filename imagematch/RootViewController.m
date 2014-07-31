#import "RootViewController.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import "UIColor+FlatUI.h"
#import "MBHUDView.h"
#import "GalleryViewController.h"
#import "GameScore.h"

@interface RootViewController ()

@property (weak, nonatomic) IBOutlet UIButton *gameButton1;
@property (weak, nonatomic) IBOutlet UIButton *gameButton2;
@property (weak, nonatomic) IBOutlet UIButton *gameButton3;
@property (weak, nonatomic) IBOutlet UIButton *gameButton4;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *volLabel;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"subtle_stripes"]];
    
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if(!localPlayer.isAuthenticated) {
        __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
            if (viewController) {
                [self presentViewController:viewController animated:YES completion:nil];
            } else if (localPlayer.authenticated) {
                [localPlayer registerListener:self];
                [self enableButtons];
            } else if (error != nil) {
                    [self showGameCenterError];
            } else {
                //[self showGameCentreLogin:viewController];
            }
        };
    } else {
        NSLog(@"LOGEDIN");
    }
    float yConst = (self.view.frame.size.height - 380)/2;
    
    NSLayoutConstraint *constYPos = [NSLayoutConstraint constraintWithItem:_gameButton1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:yConst];
    [self.view addConstraint:constYPos];
    _gameButton1.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:18];
    _gameButton2.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:18];
    _gameButton3.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:18];
    _gameButton4.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:18];
    
    [UIView animateWithDuration:.5f animations:^{
        [self.view layoutIfNeeded];
        /*MakeQuestionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"makeq"];
        [vc setTitle:@"appleapple" andImages:@[
        @"http://i.istockimg.com/file_thumbview_approve/19059160/3/stock-photo-19059160-stages-of-eating-red-apple.jpg",
        @"http://i.istockimg.com/file_thumbview_approve/19175962/3/stock-photo-19175962-sliced-green-apple.jpg",
        @"http://i.istockimg.com/file_thumbview_approve/19987310/3/stock-photo-19987310-apple-orange.jpg",
        @"http://i.istockimg.com/file_thumbview_approve/19445504/3/stock-photo-19445504-sliced-red-apple-and-leaf.jpg"]];
        [self.navigationController pushViewController:vc animated:NO];*/
        //GalleryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"gallv"];
        //[self.navigationController pushViewController:vc animated:NO];
        
    }];
    
    _volLabel.font = [UIFont fontWithName:@"FontAwesome" size:30];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"volm"] == YES) {
        _volLabel.text = @"\uf027";
    } else {
        _volLabel.text = @"\uf028";
    }
}

- (void)enableButtons {
    _gameButton1.enabled = YES;
    _gameButton2.enabled = YES;
    _gameButton3.enabled = YES;
    _gameButton4.enabled = YES;
    
    [[GameScore sharedInstance] loadGameCoinWithCompletionHandler:^(int64_t score, NSError *error) {
        if(error == nil) {
            UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 34)];
            [titleView setBackgroundColor:[UIColor colorFromHexCode:@"#E13A34"]];
            titleView.layer.cornerRadius = 8.0;
            
            UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coin44"]];
            [titleImage setFrame:CGRectMake(2, 2, 30, 30)];
            [titleView addSubview:titleImage];
            UILabel *titleScoreText = [[UILabel alloc] initWithFrame:CGRectMake(36, 2, 56, 30)];
            titleScoreText.backgroundColor = [UIColor clearColor];
            titleScoreText.textColor = [UIColor whiteColor];
            titleScoreText.textAlignment = NSTextAlignmentCenter;
            titleScoreText.shadowColor = [UIColor blackColor];
            titleScoreText.shadowOffset = CGSizeMake(0, 1);
            titleScoreText.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
            titleScoreText.adjustsFontSizeToFitWidth = YES;
            [titleScoreText setTag:70];
            titleScoreText.text = [NSString stringWithFormat:@"%lld", score];
            [titleView addSubview:titleScoreText];
            [self.navigationItem setTitleView:titleView];
        }
    }];
}

- (IBAction)muteVolume:(UITapGestureRecognizer *)sender {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"volm"] == YES) {
        SystemSoundID tapPlayer;
        AudioServicesCreateSystemSoundID(( __bridge CFURLRef) [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sndLetterButton" ofType:@"aif"]], &tapPlayer);
        AudioServicesPlaySystemSound(tapPlayer);
        _volLabel.text = @"\uf028";
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"volm"];
    } else {
        _volLabel.text = @"\uf027";
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"volm"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showGameCenterError {
   [MBHUDView hudWithBody:@"Enable Game Center and try again" type:MBAlertViewHUDTypeExclamationMark hidesAfter:4.0 show:YES];
}

@end
