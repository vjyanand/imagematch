#import "RootViewController.h"
//#import <SDWebImage/UIImageView+WebCache.h>
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
    float yConst = (self.view.frame.size.height - 360)/2;
    NSLayoutConstraint *constYPos = [NSLayoutConstraint constraintWithItem:_gameButton1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:yConst];
    [self.view addConstraint:constYPos];
    
    /*int spacing = 24;
    int buttonHeight = 44;
    int currentY = (((self.view.bounds.size.height) - ((buttonHeight * 4) + (spacing * 3))) / 2) - 44;
    
    self.gameButton1 = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2) - (100), currentY, 200, buttonHeight)];
    _gameButton1.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:20];
    [_gameButton1 setTitle:@"\uf144 Play" forState:UIControlStateNormal];
    
    currentY += buttonHeight + spacing;
    self.gameButton2 = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2) - (100), currentY, 200, buttonHeight)];
    _gameButton2.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:20];
    [_gameButton2 setTitle:@"\uf067 Create" forState:UIControlStateNormal];
    
    currentY += buttonHeight + spacing;
    self.gameButton3 = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2) - (100), currentY, 200, buttonHeight)];
    _gameButton3.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:20];
    [_gameButton3 setTitle:@"\uf0a3 Challenges" forState:UIControlStateNormal];
    
    currentY += buttonHeight + spacing;
    self.gameButton4 = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2) - (100), currentY, 200, buttonHeight)];
    _gameButton4.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:20];
    [_gameButton4 setTitle:@"\uf0f2 Gallery" forState:UIControlStateNormal];
    
    [_gameButton1 setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [_gameButton2 setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [_gameButton3 setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [_gameButton4 setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    
    _gameButton1.backgroundColor = [UIColor blackColor];
    _gameButton2.backgroundColor = [UIColor blackColor];
    _gameButton3.backgroundColor = [UIColor blackColor];
    _gameButton4.backgroundColor = [UIColor blackColor];
    
    _gameButton1.layer.cornerRadius = 4.0f;
    _gameButton1.layer.borderWidth = 1.0f;
    _gameButton1.layer.borderColor = [UIColor grayColor].CGColor;
    
    [_gameButton1 addTarget:self action:@selector(loadController:) forControlEvents:UIControlEventTouchUpInside];
    [_gameButton2 addTarget:self action:@selector(loadController:) forControlEvents:UIControlEventTouchUpInside];
    [_gameButton3 addTarget:self action:@selector(loadController:) forControlEvents:UIControlEventTouchUpInside];
    [_gameButton4 addTarget:self action:@selector(loadController:) forControlEvents:UIControlEventTouchUpInside];
    
    [_gameButton1 setTag:101];
    [_gameButton2 setTag:102];
    [_gameButton3 setTag:103];
    [_gameButton4 setTag:104];
    
    _gameButton1.enabled = NO;
    _gameButton2.enabled = NO;
    _gameButton3.enabled = NO;
    _gameButton4.enabled = NO;
    
    [self.view addSubview:_gameButton1];
    [self.view addSubview:_gameButton2];
    [self.view addSubview:_gameButton3];
    [self.view addSubview:_gameButton4];
    
    CGRect vRect = CGRectMake(0, _gameButton1.frame.origin.y - 70, self.view.bounds.size.width, 50);
    
    self.scoreLabel = [[UILabel alloc] initWithFrame:vRect];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scoreLabel];
    
    vRect = CGRectMake(15, (self.view.bounds.size.height - 44 - self.navigationController.navigationBar.bounds.size.height), 40, 30);
    
    UILabel *volLabel = [[UILabel alloc]initWithFrame:vRect];
    volLabel.backgroundColor = [UIColor clearColor];
    volLabel.adjustsFontSizeToFitWidth = YES;
    volLabel.userInteractionEnabled = YES;
    volLabel.font = [UIFont fontWithName:@"FontAwesome" size:30];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"volm"] == YES) {
        volLabel.text = @"\uf027";
    } else {
        volLabel.text = @"\uf028";
    }
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MuteVolume:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    [volLabel addGestureRecognizer:tapRecognizer];
    [self.view addSubview:volLabel];*/
    
    
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
