#import "SolveChallengeViewController.h"
#import "UIColor+FlatUI.h"
#import "Question.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface SolveChallengeViewController ()
@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) UIImageView *imgHolder1;
@property (nonatomic, strong) UIImageView *imgHolder2;
@property (nonatomic, strong) UIImageView *imgHolder3;
@property (nonatomic, strong) UIImageView *imgHolder4;
@property (nonatomic, strong) UILabel *titleScoreText;
@property (nonatomic, strong) NSMutableArray *tDataDict; //Holds top data
@property (nonatomic, strong) NSMutableArray *bDataDict; // Holds bottom data
@property (nonatomic, assign) int qoID;
@property (nonatomic, strong) NSArray *imgPostions;
@property (nonatomic, assign) SystemSoundID tapPlayer;
@property (nonatomic, assign) SystemSoundID tapDownPlayer;
@property (nonatomic, assign) SystemSoundID beepPlayer;
@property (nonatomic, assign) SystemSoundID coinPlayer;
@property (nonatomic, assign) bool isVisible;
@property (nonatomic, assign) int lastAction;
@property (nonatomic, strong) GKTurnBasedMatch *currentMatch;

@end

@implementation SolveChallengeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"subtle_stripes"]];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 34)];
    [titleView setBackgroundColor:[UIColor colorFromHexCode:@"#E13A34"]];
    titleView.layer.cornerRadius = 8.0;
    [titleView.layer setBorderColor:[UIColor colorFromHexCode:@"#BF2C27"].CGColor];
    [titleView.layer setBorderWidth:1.5f];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coin44"]];
    [titleImage setFrame:CGRectMake(2, 2, 30, 30)];
    [titleView addSubview:titleImage];
    self.titleScoreText = [[UILabel alloc] initWithFrame:CGRectMake(36, 2, 56, 30)];
    _titleScoreText.backgroundColor = [UIColor clearColor];
    _titleScoreText.textColor = [UIColor whiteColor];
    _titleScoreText.textAlignment = NSTextAlignmentCenter;
    _titleScoreText.shadowColor = [UIColor blackColor];
    _titleScoreText.shadowOffset = CGSizeMake(0, 1);
    _titleScoreText.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    _titleScoreText.adjustsFontSizeToFitWidth = YES;
    _titleScoreText.tag = 70;
    _titleScoreText.text = [NSString stringWithFormat:@"%lld", [GameScore sharedInstance].coin];
    [titleView addSubview:_titleScoreText];
    
    [self.navigationItem setTitleView:titleView];
    
    [self.navigationController setDelegate:self];
    UIImage *menuButtonImage = [UIImage imageNamed:@"list.png"];
    UIButton *btnToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnToggle setImage:menuButtonImage forState:UIControlStateNormal];
    btnToggle.frame = CGRectMake(0, 0, menuButtonImage.size.width + 20, menuButtonImage.size.height);
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnToggle];
    [btnToggle addTarget:self action:@selector(goToBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    int boxSize = 120;
    int yPoint = (self.view.bounds.size.height - 490.0) / 2;
    if ([[UIScreen mainScreen] bounds].size.height < 500) {
        boxSize = 100;
        yPoint = (self.view.bounds.size.height - 440.0) / 2;
    }
    
    int boxSpace = 4;
    int width = (boxSize * 2) + (boxSpace);
    int startPoint = (self.view.bounds.size.width - width) / 2;
    
    self.imgHolder1 = [[UIImageView alloc] initWithFrame:CGRectMake(startPoint, yPoint, boxSize, boxSize)];
    self.imgHolder2 = [[UIImageView alloc] initWithFrame:CGRectMake(startPoint + boxSize + boxSpace, yPoint, boxSize, boxSize)];
    yPoint += (boxSpace + boxSize);
    self.imgHolder3 = [[UIImageView alloc] initWithFrame:CGRectMake(startPoint, yPoint, boxSize, boxSize)];
    self.imgHolder4 = [[UIImageView alloc] initWithFrame:CGRectMake(startPoint + boxSize + boxSpace, yPoint, boxSize, boxSize)];
    
    _imgHolder1.layer.borderWidth = 1.0;
    _imgHolder1.layer.borderColor = [UIColor blackColor].CGColor;
    _imgHolder2.layer.borderWidth = 1.0;
    _imgHolder2.layer.borderColor = [UIColor blackColor].CGColor;
    _imgHolder3.layer.borderWidth = 1.0;
    _imgHolder3.layer.borderColor = [UIColor blackColor].CGColor;
    _imgHolder4.layer.borderWidth = 1.0;
    _imgHolder4.layer.borderColor = [UIColor blackColor].CGColor;
    
    _imgHolder1.userInteractionEnabled = YES;
    _imgHolder2.userInteractionEnabled = YES;
    _imgHolder3.userInteractionEnabled = YES;
    _imgHolder4.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *itapGestureRecognize1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapRecognizer:)];
    itapGestureRecognize1.numberOfTapsRequired = 1;
    UITapGestureRecognizer *itapGestureRecognize2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapRecognizer:)];
    itapGestureRecognize2.numberOfTapsRequired = 1;
    UITapGestureRecognizer *itapGestureRecognize3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapRecognizer:)];
    itapGestureRecognize3.numberOfTapsRequired = 1;
    UITapGestureRecognizer *itapGestureRecognize4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapRecognizer:)];
    itapGestureRecognize4.numberOfTapsRequired = 1;
    
    [_imgHolder1 addGestureRecognizer:itapGestureRecognize1];
    [_imgHolder2 addGestureRecognizer:itapGestureRecognize2];
    [_imgHolder3 addGestureRecognizer:itapGestureRecognize3];
    [_imgHolder4 addGestureRecognizer:itapGestureRecognize4];
    
    [_imgHolder1 setTag:10];
    [_imgHolder2 setTag:11];
    [_imgHolder3 setTag:12];
    [_imgHolder4 setTag:13];
    
    self.imgPostions = [NSArray arrayWithObjects:[NSValue valueWithCGRect:_imgHolder1.frame], [NSValue valueWithCGRect:_imgHolder2.frame],[NSValue valueWithCGRect:_imgHolder3.frame],[NSValue valueWithCGRect:_imgHolder4.frame], nil];
    
    [self.view addSubview:_imgHolder1];
    [self.view addSubview:_imgHolder2];
    [self.view addSubview:_imgHolder3];
    [self.view addSubview:_imgHolder4];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"volm"] == NO) { //If not mute
        AudioServicesCreateSystemSoundID(( __bridge CFURLRef) [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sndLetterButton" ofType:@"aif"]], &_tapPlayer);
        AudioServicesCreateSystemSoundID(( __bridge CFURLRef) [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sndUndo" ofType:@"aif"]], &_tapDownPlayer);
        AudioServicesCreateSystemSoundID(( __bridge CFURLRef) [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep-horn" ofType:@"aif"]], &_beepPlayer);
        AudioServicesCreateSystemSoundID(( __bridge CFURLRef) [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"cha-ching" ofType:@"wav"]], &_coinPlayer);
    }
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
