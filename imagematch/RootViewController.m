#import "RootViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import "UIColor+FlatUI.h"

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
    UIImageView *t = [UIImageView alloc];
    [t setImageWithURL:[NSURL URLWithString:@"http://www.domain.com/path/to/image.jpg"]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

    [UIView animateWithDuration:.5f animations:^{
        [self.view layoutIfNeeded];
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
    
    NSLog(@"A");
}

- (void)showGameCenterError {
   // [MBHUDView hudWithBody:@"Enable Game Center and try again" type:MBAlertViewHUDTypeExclamationMark hidesAfter:4.0 show:YES];
}

@end
