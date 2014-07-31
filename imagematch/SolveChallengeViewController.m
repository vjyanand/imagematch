#import "SolveChallengeViewController.h"
#import "UIColor+FlatUI.h"
#import "Question.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "GameScore.h"
#import "MBHUDView.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

#define LABEL_TAG_OFFSET 60

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
    
    //[self.navigationController setDelegate:self];
    UIImage *menuButtonImage = [UIImage imageNamed:@"list.png"];
    UIButton *btnToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnToggle setImage:menuButtonImage forState:UIControlStateNormal];
    btnToggle.frame = CGRectMake(0, 0, menuButtonImage.size.width + 20, menuButtonImage.size.height);
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnToggle];
    [btnToggle addTarget:self action:@selector(goToBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    int boxSize = 120;
    int yPoint = (self.view.bounds.size.height - 400.0) / 2;
    
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
    
    if(_currentMatch) {
        if(_currentMatch.matchData == nil) {
            [_currentMatch loadMatchDataWithCompletionHandler:^(NSData *matchData, NSError *error) {
                [self loadGameFromMatchData:matchData];
            }];
        } else {
            [self loadGameFromMatchData:_currentMatch.matchData];
        }
    } else if (_question.scramble == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadQuestion];
        });
    }
}

-(void) imgTapRecognizer:(UIGestureRecognizer*)sender {
    UIImageView *imgView = (UIImageView*)sender.view;
    for (int i = 10; i < 14; i++) {
        [self.view viewWithTag:i].userInteractionEnabled = NO;
    }
    [UIView animateWithDuration:0.4 animations:^{
        if(imgView.frame.size.height > 120) {
            NSUInteger index = imgView.tag - 10;
            imgView.frame = [[_imgPostions objectAtIndex:index] CGRectValue];
        } else {
            [self.view bringSubviewToFront:imgView];
            CGRect blowupRect = CGRectMake(_imgHolder1.frame.origin.x, _imgHolder1.frame.origin.y, (_imgHolder4.frame.size.width * 2) + 6, (_imgHolder4.frame.size.height * 2) + 6);
            imgView.frame = blowupRect;
        }
    } completion:^(BOOL finished) {
        for (int i = 10; i < 14; i++) {
            [self.view viewWithTag:i].userInteractionEnabled = YES;
        }
    }];
}

-(void) loadGameFromMatchData:(NSData*)matchData {
    self.question = [[Question alloc] initWithNSGameData:matchData];
    [self reload];
}

-(void) showOptions:(UIGestureRecognizer*)sender {
    
    UIWindow* mainWindow = [[[UIApplication sharedApplication] delegate] window];
    UIView *modalView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Background tap view
    UIView *backgroundView = [[UIView alloc] initWithFrame:modalView.bounds];
    backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    [backgroundView setTag:404];
    [modalView addSubview:backgroundView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(mainWindow.center.x * 2, mainWindow.center.y - 120, 220, 240)];
    contentView.backgroundColor = [UIColor silverColor];
    contentView.layer.cornerRadius = 4.0;
    contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    contentView.layer.shadowOffset = CGSizeMake(0, 0);
    contentView.layer.shadowRadius = 5.0;
    contentView.layer.shadowOpacity = 1;
    
    int ySpacing = (contentView.bounds.size.height - 136) / 3;
    
    UIButton *revealButton = [[UIButton alloc] initWithFrame:CGRectMake((contentView.bounds.size.width - 172)/2, ySpacing, 172, 48)];
    revealButton.backgroundColor = [UIColor colorFromHexCode:@"#F75D59"];
    [revealButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [revealButton setTitle:@" Reveal letter" forState:UIControlStateNormal];
    [revealButton.titleLabel setFont:[UIFont fontWithName:@"GeezaPro-Bold" size:18.0]];
    [revealButton setImage:[UIImage imageNamed:@"reveal_new"] forState:UIControlStateNormal];
    UIBezierPath *maskPathTop = [UIBezierPath bezierPathWithRoundedRect:revealButton.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayerTop = [CAShapeLayer layer];
    maskLayerTop.frame = revealButton.bounds;
    maskLayerTop.path = maskPathTop.CGPath;
    revealButton.layer.mask = maskLayerTop;
    
    [contentView addSubview:revealButton];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(revealButton.frame.origin.x, revealButton.frame.origin.y + revealButton.frame.size.height, revealButton.frame.size.width, 20)];
    bottomView.backgroundColor = [UIColor turquoiseColor];
    
    UIImageView *coinImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coin84"]];
    coinImage.frame = CGRectMake((bottomView.bounds.size.width/2) - 20, 0, 20, 20);
    UILabel *coinLabel = [[UILabel alloc] initWithFrame:CGRectMake((bottomView.bounds.size.width/2) + 4, 0, 40, 20)];
    coinLabel.backgroundColor = [UIColor clearColor];
    coinLabel.text = @"20";
    [bottomView addSubview:coinLabel];
    [bottomView addSubview:coinImage];
    
    UIBezierPath *maskPathBottom = [UIBezierPath bezierPathWithRoundedRect:bottomView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayerBottom = [CAShapeLayer layer];
    maskLayerBottom.frame = bottomView.bounds;
    maskLayerBottom.path = maskPathBottom.CGPath;
    bottomView.layer.mask = maskLayerBottom;
    [contentView addSubview:bottomView];
    
    UIButton *hideButton = [[UIButton alloc] initWithFrame:CGRectMake((contentView.bounds.size.width - 172)/2, bottomView.frame.size.height + bottomView.frame.origin.y + ySpacing, 172, 48)];
    hideButton.backgroundColor = [UIColor colorFromHexCode:@"#F75D59"];
    [hideButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [hideButton setTitle:@" Remove letter" forState:UIControlStateNormal];
    [hideButton.titleLabel setFont:[UIFont fontWithName:@"GeezaPro-Bold" size:18.0]];
    [hideButton setImage:[UIImage imageNamed:@"remove_new"] forState:UIControlStateNormal];
    CAShapeLayer *maskLayerTop2 = [CAShapeLayer layer];
    maskLayerTop2.frame = hideButton.bounds;
    maskLayerTop2.path = maskPathTop.CGPath;
    hideButton.layer.mask = maskLayerTop2;
    [contentView addSubview:hideButton];
    
    UIView *bottomView2 = [[UIView alloc] initWithFrame:CGRectMake(hideButton.frame.origin.x, hideButton.frame.origin.y + hideButton.frame.size.height, hideButton.frame.size.width, 20)];
    bottomView2.backgroundColor = [UIColor turquoiseColor];
    
    UIImageView *coinImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coin84"]];
    coinImage2.frame = CGRectMake((bottomView2.bounds.size.width/2) - 20, 0, 20, 20);
    UILabel *coinLabel2 = [[UILabel alloc] initWithFrame:CGRectMake((bottomView2.bounds.size.width/2) + 4, 0, 40, 20)];
    coinLabel2.backgroundColor = [UIColor clearColor];
    coinLabel2.text = @"20";
    
    [bottomView2 addSubview:coinLabel2];
    [bottomView2 addSubview:coinImage2];
    
    CAShapeLayer *maskLayerBottom2 = [CAShapeLayer layer];
    maskLayerBottom2.frame = bottomView2.bounds;
    maskLayerBottom2.path = maskPathBottom.CGPath;
    bottomView2.layer.mask = maskLayerBottom2;
    [contentView addSubview:bottomView2];
    
    [hideButton addTarget:self action:@selector(hideLetter:) forControlEvents:UIControlEventTouchUpInside];
    [revealButton addTarget:self action:@selector(revealLetter:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:hideButton];
    [modalView addSubview:contentView];
    [mainWindow addSubview:modalView];
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeShareView:)];
    gr.numberOfTapsRequired = 1;
    [backgroundView addGestureRecognizer:gr];
    
    [UIView animateWithDuration:0.2 animations:^{
        [contentView setCenter:modalView.center];
    }];
}

- (void)closeShareView:(UIGestureRecognizer*)sender {
    if(sender.view.tag == 404){
        UIView *contentView = [sender.view.superview.subviews lastObject];
        CGRect cvRect = contentView.frame;
        cvRect.origin.x = 0 - cvRect.size.width;
        [UIView animateWithDuration:0.4 animations:^{sender.view.alpha = 0.0; contentView.frame = cvRect;} completion:^(BOOL finished){ [sender.view.superview removeFromSuperview];}];
    } else {
        [sender.view removeFromSuperview];
    }
}

-(void) revealLetter:(UIView*)sender {
    UIView *contentView = [sender.superview.superview.subviews objectAtIndex:1];
    CGRect cvRect = contentView.frame;
    cvRect.origin.x = 0 - cvRect.size.width;
    [[GameScore sharedInstance] updateGameCoin:-5];
    _titleScoreText.text = [NSString stringWithFormat:@"%lld", [GameScore sharedInstance].coin];
    [UIView animateWithDuration:0.2 animations:^{sender.superview.alpha = 0.0; contentView.frame = cvRect;} completion:^(BOOL finished){ [contentView.superview removeFromSuperview];
        
        //Push All Down
        NSString *searchKeyCopy = [NSString stringWithString:_question.solution];
        
        for (int i = 0; i < [_bDataDict count]; i++) {
            NSMutableDictionary *bdict = [_bDataDict objectAtIndex:i];
            if([[bdict objectForKey:@"l"] isEqualToString:@"1"]) {
                int tIndex = LABEL_TAG_OFFSET + i;
                UILabel *tLabel = (UILabel*)[self.view viewWithTag:tIndex];
                [self handleLowerLabels:tLabel playSound:NO location:NSNotFound];
            }
        }
        
        // replace all found words with space
        for(NSMutableDictionary *tdictI in _tDataDict) {
            NSRange range = [searchKeyCopy rangeOfString:[tdictI objectForKey:@"s"]];
            if(range.location != NSNotFound) {
                searchKeyCopy = [searchKeyCopy stringByReplacingCharactersInRange:range withString:@" "];
            }
        }
        
        // Push the label
        [_bDataDict indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary *bdict = (NSMutableDictionary *)obj;
            if([[bdict objectForKey:@"l"] isEqualToString:@"0"]){
                NSString *charAt = [NSString stringWithFormat:@"%c", [_question.scramble characterAtIndex:idx]];
                NSRange range = [searchKeyCopy rangeOfString:charAt];
                if (range.location != NSNotFound) {
                    NSUInteger tIndex = LABEL_TAG_OFFSET + idx;
                    UILabel *tLabel = (UILabel*)[self.view viewWithTag:tIndex];
                    [self handleLowerLabels:tLabel playSound:YES location:range.location];
                    *stop = YES;
                    return YES;
                }
            }
            return NO;
        }];
    }];
}

-(void) hideLetter:(UIView*)sender {
    UIView *contentView = [sender.superview.superview.subviews objectAtIndex:1];
    CGRect cvRect = contentView.frame;
    cvRect.origin.x = 0 - cvRect.size.width;
    [[GameScore sharedInstance] updateGameCoin:-5];
    _titleScoreText.text = [NSString stringWithFormat:@"%lld", [GameScore sharedInstance].coin];
    
    [UIView animateWithDuration:0.2 animations:^{sender.superview.alpha = 0.0; contentView.frame = cvRect;} completion:^(BOOL finished){ [contentView.superview removeFromSuperview];
        
        for (int i = 0; i < [_bDataDict count]; i++) {
            NSMutableDictionary *bdict = [_bDataDict objectAtIndex:i];
            if([[bdict objectForKey:@"l"] isEqualToString:@"1"]) {
                int tIndex = LABEL_TAG_OFFSET + i;
                UILabel *tLabel = (UILabel*)[self.view viewWithTag:tIndex];
                [self handleLowerLabels:tLabel playSound:NO location:NSNotFound];
            }
        }
        
        for (int i = 0; i < [_bDataDict count]; i++) {
            NSMutableDictionary *bdict = [_bDataDict objectAtIndex:i];
            if([[bdict objectForKey:@"l"] isEqualToString:@"0"]) {
                NSString *charAt = [NSString stringWithFormat:@"%c", [_question.scramble characterAtIndex:i]];
                NSRange range = [_question.solution rangeOfString:charAt];
                if (range.location == NSNotFound) {
                    int tIndex = LABEL_TAG_OFFSET + i;
                    UILabel *tLabel = (UILabel*)[self.view viewWithTag:tIndex];
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        tLabel.alpha = 0;
                        tLabel.backgroundColor = [UIColor orangeColor];
                    } completion:^(BOOL finished) {
                        [tLabel removeFromSuperview];
                    }];
                    
                    [bdict setObject:@"2" forKey:@"l"];
                    break;
                }
            }
        }
    }];
}

-(void)aaShareBubblesDidHide:(AAShareBubbles *)shareBubbles {
  [shareBubbles.superview removeFromSuperview];
}

#pragma mark - Reload
- (void) reload {
    UIImage *placeHolder = [UIImage imageNamed:@"loading"];
    
    [_imgHolder1 sd_setImageWithURL:[NSURL URLWithString:[_question.imgURLs objectAtIndex:0]] placeholderImage:placeHolder options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
    [_imgHolder2 sd_setImageWithURL:[NSURL URLWithString:[_question.imgURLs objectAtIndex:1]] placeholderImage:placeHolder options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
    [_imgHolder3 sd_setImageWithURL:[NSURL URLWithString:[_question.imgURLs objectAtIndex:2]] placeholderImage:placeHolder options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
    [_imgHolder4 sd_setImageWithURL:[NSURL URLWithString:[_question.imgURLs objectAtIndex:3]] placeholderImage:placeHolder options:SDWebImageProgressiveDownload | SDWebImageRetryFailed];
    
    int boxSpace = 5;
    int qSpacing = 20;
    if ([[UIScreen mainScreen] bounds].size.height < 500) qSpacing = 12;
    int yPoint = _imgHolder4.frame.origin.y + _imgHolder4.frame.size.height + qSpacing;
    NSUInteger strLength = [_question.solution length];
    int boxSize = (self.view.bounds.size.width - 30 - (boxSpace * (strLength -1))) / strLength;
    if(boxSize > 40) boxSize = 40;
    for (UIView *lable in self.view.subviews) {
        if ([lable isKindOfClass:[UILabel class]]){
            [lable removeFromSuperview];
        } else if (lable.tag > 79 && lable.tag < 95) { //Removes line
            [lable removeFromSuperview];
        }
    }
    
    NSUInteger width = (boxSize * strLength) + (boxSpace * (strLength -1));
    int startPoint = (self.view.bounds.size.width - width) / 2;
    self.tDataDict = [[NSMutableArray alloc] initWithCapacity:strLength];
    self.bDataDict = [[NSMutableArray alloc] initWithCapacity:_question.scramble.length];
    
    for (int i=0; i < strLength; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(startPoint, yPoint + (boxSize - 2), boxSize, 2)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        lineView.tag = 80 + i;
        [self.view addSubview:lineView];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSValue valueWithCGRect:CGRectMake(startPoint, yPoint, boxSize, boxSize)], @"f", @"", @"s", nil];
        startPoint += boxSize + boxSpace;
        [_tDataDict addObject:dict];
    }
    
    yPoint += (boxSpace + boxSize + qSpacing + 10);
    NSUInteger cols = [_question.scramble length] / 2 ;
    boxSize = (self.view.bounds.size.width - 30 - (boxSpace * (cols))) / (cols + 1); //Width - 15px padding - space
    if (boxSize > 44) boxSize = 44; //Dont want bigger than 44
    width = (boxSize * (cols + 1)) + (boxSpace * (cols)); //total width of boxes
    startPoint = (self.view.bounds.size.width - width) / 2; //where to start from
    for (int i=0; i < cols; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint, yPoint, boxSize, boxSize)];
        titleLabel.layer.borderColor = [UIColor darkTextColor].CGColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.layer.borderWidth = 0.4f;
        titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:20.0];
        titleLabel.layer.cornerRadius = 2.0;
        titleLabel.layer.masksToBounds = NO;
        titleLabel.text = [[NSString stringWithFormat:@"%c",[_question.scramble characterAtIndex:i]] uppercaseString] ;
        titleLabel.userInteractionEnabled = YES;
        titleLabel.tag = LABEL_TAG_OFFSET + i ;
        UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchNotificationForLower:)];
        [recog setNumberOfTouchesRequired:1];
        [titleLabel addGestureRecognizer:recog];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSValue valueWithCGRect:titleLabel.frame], @"f", @"0", @"l", @"", @"p", nil];
        [_bDataDict addObject:dict];
        
        [self.view addSubview:titleLabel];
        startPoint = startPoint + boxSize + boxSpace;
    }
    
    UILabel *helpLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint + 5, yPoint + 3, boxSize - 6, boxSize - 6 )];
    helpLabel.userInteractionEnabled = YES;
    helpLabel.backgroundColor = [UIColor colorFromHexCode:@"#00AAFF"];
    helpLabel.text = @"?";
    helpLabel.textColor = [UIColor whiteColor];
    helpLabel.textAlignment = NSTextAlignmentCenter;
    helpLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    helpLabel.layer.cornerRadius = helpLabel.bounds.size.height/2;
    CABasicAnimation *rotateAnim=[CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotateAnim.fromValue=[NSNumber numberWithDouble:0.0];
    rotateAnim.toValue=[NSNumber numberWithDouble:M_PI_2];
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 2;
    group.repeatCount = HUGE_VALF;
    group.autoreverses = YES;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.animations = [NSArray arrayWithObjects: rotateAnim, nil];
    [helpLabel.layer addAnimation:group forKey:@"allMyAnimations"];
    
    /*CFTimeInterval pausedTime = [helpLabel.layer convertTime:CACurrentMediaTime() fromLayer:nil];
     helpLabel.layer.speed = 0.0;
     helpLabel.layer.timeOffset = pausedTime;*/
    
    UITapGestureRecognizer *helpRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOptions:)];
    [helpRecog setNumberOfTouchesRequired:1];
    [helpLabel addGestureRecognizer:helpRecog];
    [self.view addSubview:helpLabel];
    
    yPoint = yPoint + boxSize + 15;
    startPoint = (self.view.bounds.size.width - width) / 2;
    
    for (int i=0; i < cols; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint, yPoint, boxSize, boxSize)];
        titleLabel.layer.borderColor = [UIColor darkTextColor].CGColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.layer.borderWidth = 0.4f;
        titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:20.0];
        titleLabel.layer.cornerRadius = 2.0;
        titleLabel.layer.masksToBounds = NO;
        titleLabel.text = [[NSString stringWithFormat:@"%c",[_question.scramble characterAtIndex:(i + cols)]] uppercaseString] ;
        titleLabel.userInteractionEnabled = YES;
        titleLabel.tag = LABEL_TAG_OFFSET + i + cols;
        UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchNotificationForLower:)];
        [recog setNumberOfTouchesRequired:1];
        [titleLabel addGestureRecognizer:recog];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSValue valueWithCGRect:titleLabel.frame], @"f", @"0", @"l", @"", @"p",nil];
        [_bDataDict addObject:dict];
        [self.view addSubview:titleLabel];
        startPoint = startPoint + boxSize + boxSpace;
    }
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(startPoint + 5, yPoint + 3, 40, 40)];
    [shareButton setImage:[UIImage imageNamed:@"share52"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(showShare:) forControlEvents:UIControlEventTouchUpInside];
    shareButton.tag = 92;
    
    /*
     UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint + 5, yPoint + 3, boxSize - 6, boxSize - 6 )];
     shareLabel.userInteractionEnabled = YES;
     shareLabel.font = [UIFont fontWithName:@"FontAwesome" size:35];
     shareLabel.textColor = [UIColor colorFromHexCode:@"#00AAFF"];
     shareLabel.text = @"\uf14d";
     UITapGestureRecognizer *shareRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showShare:)];
     [shareRecog setNumberOfTouchesRequired:1];
     [shareLabel addGestureRecognizer:shareRecog];
     
     shareLabel.textAlignment = NSTextAlignmentCenter;
     shareLabel.layer.cornerRadius = 4.0; */
    
    
    [self.view addSubview:shareButton];
}

-(void) goToBack {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) doDelayedAction:(int) action {
    
    if(_isVisible == YES) {
        _lastAction = action;
        return;
    }
    
    if(action == 1) {
        [self reload];
    } else if(action == 2) {
        MBHUDView *hud = [MBHUDView hudWithBody:@"Hurray!, You solved all\nTry after few hours \nfor new Challenges" type:MBAlertViewHUDTypeDefault hidesAfter:2.1 show:NO];
        hud.size = CGSizeMake(self.view.bounds.size.width -20, self.view.bounds.size.width -20);
        hud.bodyFont = [UIFont fontWithName:@"STHeitiTC-Light" size:20.0];
        hud.uponDismissalBlock = ^ { [self goToBack]; };
        hud.animationType = MBAlertAnimationTypeBounce;
        [hud addToDisplayQueue];
    } else if(action == 3) {
        MBHUDView *hud = [MBHUDView hudWithBody:@"Error!, Please try again" type:MBAlertViewHUDTypeDefault hidesAfter:2.1 show:NO];
        hud.size = CGSizeMake(self.view.bounds.size.width -20, self.view.bounds.size.width -20);
        hud.bodyFont = [UIFont fontWithName:@"STHeitiTC-Light" size:20.0];
        hud.uponDismissalBlock = ^ { [self goToBack]; };
        hud.animationType = MBAlertAnimationTypeBounce;
        [hud addToDisplayQueue];
    }
    _lastAction = 0;
}

-(void) loadQuestion {
    [MBHUDView hudWithBody:@"..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:0.0 show:YES];
    NSString *URLPath = [NSString stringWithFormat:@"https://iavian.net/im/getquestion?q=%d&u=%@", _question.qID, [[self uniqueId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [MBHUDView dismissCurrentHUD];
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                self.question = [[Question alloc] init];
                self.question.scramble = [res objectForKey:@"s"];
                self.question.solution = [res objectForKey:@"t"];
                self.question.imgURLs = [res objectForKey:@"i"];
                self.question.qID = [[res objectForKey:@"id"] intValue];
                self.question.qOwner = [res objectForKey:@"u"];
                [self doDelayedAction:1];
            } else {
             //   [self doDelayedAction:2];
            }
        } else {
           // [self doDelayedAction:3];
        }
    }];
}

-(void) didTouchNotificationForLower:(UIGestureRecognizer*)sender {
    UILabel *label = (UILabel*)sender.view;
    [self handleLowerLabels:label playSound:YES location:NSNotFound];
}

-(void) handleLowerLabels:(UIView*)label playSound:(bool) playSound location:(NSUInteger) location {
    NSUInteger index = label.tag - LABEL_TAG_OFFSET;
    NSMutableDictionary *bdict = [_bDataDict objectAtIndex:index];
    if([[bdict objectForKey:@"l"] isEqualToString:@"0"]) { // Label is tapped from bottom
        NSUInteger freeIndex = NSNotFound;
        if (location != NSNotFound) {
            [bdict setObject:@"" forKey:@"c"];
            ((UILabel*)label).backgroundColor = [UIColor greenSeaColor];
            freeIndex = location;
        } else {
            for(NSMutableDictionary *tdictI in _tDataDict) {
                if([[tdictI objectForKey:@"s"] isEqualToString:@""]) {
                    freeIndex = [_tDataDict indexOfObject:tdictI];
                    break;
                }
            }
        }
        if (freeIndex == NSNotFound) {
            return;
        } else {
            [[_tDataDict objectAtIndex:freeIndex] setObject:[NSString stringWithFormat:@"%c", [_question.scramble characterAtIndex:index]] forKey:@"s"];
            [bdict setObject:[NSNumber numberWithUnsignedInteger:freeIndex] forKey:@"p"];
            
            AudioServicesPlaySystemSound(_tapPlayer);
            NSMutableArray *aAnswer = [[NSMutableArray alloc] init];
            for(NSMutableDictionary *tdictI in _tDataDict) {
                [aAnswer addObject:[tdictI objectForKey:@"s"]];
            }
            
            NSString *answer = [aAnswer componentsJoinedByString:@""]; // Answer for far from top header
            NSMutableDictionary *tdict = [_tDataDict objectAtIndex:freeIndex];
            [bdict setObject:@"1" forKey:@"l"];
            
            [UIView animateWithDuration:0.4 animations:^{
                label.frame = [[tdict objectForKey:@"f"] CGRectValue];
            } completion:^(BOOL finished) {
                if(answer.length == _question.solution.length) {
                    if([answer isEqualToString:_question.solution]) {
                        self.qoID = _question.qID;
                        if(_currentMatch == nil) {
                            [self loadQuestion];
                        } else {
                            for(GKTurnBasedParticipant *participant in _currentMatch.participants) {
                                if([participant.playerID isEqualToString:_currentMatch.currentParticipant.playerID]) {
                                    participant.matchOutcome = GKTurnBasedMatchOutcomeWon;
                                } else {
                                    participant.matchOutcome = GKTurnBasedMatchOutcomeLost;
                                }
                            }
                            GKTurnBasedParticipant *nextPlayer;
                            if (_currentMatch.currentParticipant == [_currentMatch.participants objectAtIndex:0]) {
                                nextPlayer = [[_currentMatch participants] lastObject];
                            } else {
                                nextPlayer = [[_currentMatch participants] objectAtIndex:0];
                            }
                            [_currentMatch participantQuitInTurnWithOutcome:GKTurnBasedMatchOutcomeWon nextParticipants:@[nextPlayer] turnTimeout:60 matchData:_currentMatch.matchData completionHandler:^(NSError *error) {
                                if(error == nil) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_CHALLENGES" object:nil];
                                }
                            }];
                        }
                        [self showCompleteDialog];
                    } else {
                        for (int i = 0; i < [_bDataDict count]; i++) {
                            NSMutableDictionary *bdict = [_bDataDict objectAtIndex:i];
                            AudioServicesPlaySystemSound(_beepPlayer);
                            if([[bdict objectForKey:@"l"] isEqualToString:@"1"]) {
                                int tIndex = LABEL_TAG_OFFSET + i;
                                UILabel *tLabel = (UILabel*)[self.view viewWithTag:tIndex];
                                [UIView animateWithDuration:0.5 animations:^{
                                    tLabel.textColor = [UIColor redColor];
                                    tLabel.alpha = 0;
                                } completion:^(BOOL finished) {
                                    tLabel.textColor = [UIColor blackColor];
                                    tLabel.alpha = 1.0;
                                    [self handleLowerLabels:tLabel playSound:NO location:NSNotFound];
                                }];
                            }
                        }
                    }
                }
            }];
        }
    } else if([bdict objectForKey:@"c"] == nil){
        if(playSound == YES) {
            AudioServicesPlaySystemSound(_tapDownPlayer);
        }
        [bdict setObject:@"0" forKey:@"l"];
        int freeIndex = [[bdict objectForKey:@"p"] intValue];
        [[_tDataDict objectAtIndex:freeIndex] setObject:@"" forKey:@"s"];
        [UIView animateWithDuration:0.4 animations:^{
            CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            fullRotation.fromValue = [NSNumber numberWithFloat:0];
            fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
            fullRotation.duration = 0.3;
            fullRotation.repeatCount = 1;
            [label.layer addAnimation:fullRotation forKey:@"360"];
            label.frame = [[bdict objectForKey:@"f"] CGRectValue];
        } completion:^(BOOL finished) {
            [label.layer removeAnimationForKey:@"360"];
            label.layer.borderColor = [UIColor darkTextColor].CGColor;
        }];
    }
}

-(NSString*) uniqueId {
    NSString *uniqueId = [GKLocalPlayer localPlayer].playerID;
    if (uniqueId == nil) {
        if ([[UIDevice currentDevice] respondsToSelector:NSSelectorFromString(@"identifierForVendor")])
            uniqueId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    return uniqueId;
}

-(void) showCompleteDialog {
    NSUInteger points = _question.solution.length * 10;
    
    AudioServicesPlaySystemSound(_coinPlayer);
    UIWindow* mainWindow = [[[UIApplication sharedApplication] delegate] window];
    UIView *dialogLayer = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    dialogLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85f];
    [GameScore sharedInstance].score += points;
    [[GameScore sharedInstance] updateGameCoin:_question.solution.length];
    _titleScoreText.text = [NSString stringWithFormat:@"%lld", [GameScore sharedInstance].coin];
    
    int yPoint = (dialogLayer.bounds.size.height - 392)/2;
    
    UILabel *lblAwesome = [[UILabel alloc] initWithFrame:CGRectMake(0, yPoint, dialogLayer.bounds.size.width, 40)];
    NSArray *texts = @[@"AWESOME",@"SUPERB!", @"STUNNING", @"WONDERFUL"];
    NSUInteger randomIndex = arc4random() % [texts count];
    lblAwesome.text = [NSString stringWithFormat:@"%@", [texts objectAtIndex:randomIndex]];
    lblAwesome.font = [UIFont fontWithName:@"Helvetica-Bold" size:50];
    lblAwesome.textColor = [UIColor sunflowerColor];
    lblAwesome.textAlignment = NSTextAlignmentCenter;
    lblAwesome.backgroundColor = [UIColor clearColor];
    lblAwesome.adjustsFontSizeToFitWidth = YES;
    
    UILabel *lblAwesome1 = [[UILabel alloc] initWithFrame:CGRectMake(0, yPoint+=55, dialogLayer.bounds.size.width, 40)];
    lblAwesome1.text = [NSString stringWithFormat:@"YOU'E GUESSED THE WORD"];
    lblAwesome1.font = [UIFont fontWithName:@"BanglaSangamMN-Bold" size:18];
    lblAwesome1.textColor = [UIColor whiteColor];
    lblAwesome1.textAlignment = NSTextAlignmentCenter;
    lblAwesome1.backgroundColor = [UIColor clearColor];
    
    yPoint += 70;
    int lblSize = 40;
    int lblSpacing = 10;
    if( _question.solution.length > 6 ) {
        lblSize = 25;
        lblSpacing = 4;
    }
    
    UILabel *lblCscore = [[UILabel alloc] initWithFrame:CGRectMake(0, yPoint+=55, dialogLayer.bounds.size.width, 40)];
    lblCscore.text = [NSString stringWithFormat:@"You Scored %ld Points", (unsigned long)points];
    lblCscore.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20];
    lblCscore.textAlignment = NSTextAlignmentCenter;
    lblCscore.textColor = [UIColor whiteColor];
    lblCscore.backgroundColor = [UIColor clearColor];
    
    UILabel *lblcoin = [[UILabel alloc] initWithFrame:CGRectMake(0, yPoint+=70, dialogLayer.bounds.size.width, 40)];
    lblcoin.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:25];
    lblcoin.textAlignment = NSTextAlignmentCenter;
    lblcoin.textColor = [UIColor blackColor];
    lblcoin.backgroundColor = [UIColor clearColor];
    
    UIImageView *conImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coin84"]];
    [conImageView setFrame:CGRectMake(20, 0, 84, 84)];
    conImageView.center=CGPointMake(lblcoin.center.x, lblcoin.center.y);
    
    int xPoint = (self.view.bounds.size.width - ((lblSize * _question.solution.length) + (lblSpacing*(_question.solution.length-1))))/2;
    for(int i=0; i<_question.solution.length; i++) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint - 125, lblSize, lblSize)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:20.0];
        lbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scale"]];
        lbl.text = [NSString stringWithFormat:@"%c",[_question.solution characterAtIndex:i]];
        [dialogLayer addSubview:lbl];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, ((i*0.08))* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,44,44)];
            imgView.image = [UIImage imageNamed:@"coin84"];
            [dialogLayer addSubview:imgView];
            [dialogLayer sendSubviewToBack:imgView];
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                [imgView removeFromSuperview];
                lblcoin.text = [NSString stringWithFormat:@"%d", i+1];
            }];
            
            CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            pathAnimation.calculationMode = kCAAnimationPaced;
            pathAnimation.fillMode = kCAFillModeForwards;
            pathAnimation.removedOnCompletion = NO;
            pathAnimation.duration = 0.5;
            pathAnimation.delegate = self;
            CGMutablePathRef curvedPath = CGPathCreateMutable();
            CGPathMoveToPoint(curvedPath, NULL, lbl.center.x, lbl.center.y);
            CGPathAddCurveToPoint(curvedPath, NULL, lbl.center.x, lbl.center.y, self.view.bounds.size.width/2, yPoint + 220, conImageView.center.x, conImageView.center.y);
            pathAnimation.path = curvedPath;
            CGPathRelease(curvedPath);
            [imgView.layer addAnimation:pathAnimation forKey:@"curveAnimation"];
            [CATransaction commit];
            
        });
        xPoint+=(lblSize + lblSpacing);
    }
    
    UIButton *thumsUp = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    thumsUp.layer.shadowColor = [UIColor colorWithWhite:0.2 alpha:0.3].CGColor;
    thumsUp.layer.cornerRadius = 6.0f;
    thumsUp.center = CGPointMake(dialogLayer.center.x - 40, yPoint += 100);
    thumsUp.backgroundColor = [UIColor clearColor];
    [thumsUp setImage:[UIImage imageNamed:@"up_button.png"] forState:UIControlStateNormal];
    [[thumsUp imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [thumsUp addTarget:self action:@selector(thumbsHandle:) forControlEvents:UIControlEventTouchUpInside];
    [thumsUp setTag:22];
    
    UIButton *thumsDown = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    thumsDown.layer.shadowColor = [UIColor colorWithWhite:0.2 alpha:0.3].CGColor;
    thumsDown.layer.cornerRadius = 6.0f;
    thumsDown.center = CGPointMake(dialogLayer.center.x + 40, yPoint);
    thumsDown.backgroundColor = [UIColor clearColor];
    [thumsDown setImage:[UIImage imageNamed:@"down_button.png"] forState:UIControlStateNormal];
    [[thumsDown imageView] setContentMode:UIViewContentModeScaleAspectFit];
    [thumsDown addTarget:self action:@selector(thumbsHandle:) forControlEvents:UIControlEventTouchUpInside];
    [thumsDown setTag:20];
    
    UILabel *cnt = [[UILabel alloc] initWithFrame:CGRectMake(0, dialogLayer.bounds.size.height - 44, dialogLayer.bounds.size.width, 44)];
    cnt.backgroundColor = [UIColor clearColor];
    cnt.textAlignment = NSTextAlignmentCenter;
    cnt.text = @"Touch anywhere to continue";
    cnt.textColor = [UIColor asbestosColor];
    
    [dialogLayer addSubview:lblCscore];
    [dialogLayer addSubview:cnt];
    [dialogLayer addSubview:thumsUp];
    [dialogLayer addSubview:thumsDown];
    [dialogLayer addSubview:lblAwesome];
    [dialogLayer addSubview:lblAwesome1];
    [dialogLayer addSubview:conImageView];
    [dialogLayer addSubview:lblcoin];
    [mainWindow addSubview:dialogLayer];
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeDialog:)];
    gr.numberOfTapsRequired = 1;
    [dialogLayer addGestureRecognizer:gr];
    _isVisible = YES;
}

-(void) thumbsHandle:(id)sender {
    UIButton *btnThumbs = (UIButton*) sender;
    NSUInteger count = btnThumbs.tag - 21;
    if(count == 1) {
        [btnThumbs setImage:[UIImage imageNamed:@"up_button_selected.png"] forState:UIControlStateNormal];
        [(UIButton*)[btnThumbs.superview viewWithTag:20] setImage:[UIImage imageNamed:@"down_button.png"] forState:UIControlStateNormal];
    } else {
        [btnThumbs setImage:[UIImage imageNamed:@"down_button_selected.png"] forState:UIControlStateNormal];
        [(UIButton*)[btnThumbs.superview viewWithTag:22] setImage:[UIImage imageNamed:@"up_button.png"] forState:UIControlStateNormal];
    }
    
    NSString *URLPath = [NSString stringWithFormat:@"https://iavian.net/im/rate?s=%lu&q=%d&u=%@", (unsigned long)count, _qoID, [[self uniqueId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data,
                                                                                                            NSError *error) {
        
    }];
}

-(void) closeDialog:(UIGestureRecognizer*)sender {
    _isVisible = NO;
    [UIView animateWithDuration:0.5 animations:^{
        sender.view.transform = CGAffineTransformScale(sender.view.transform, 0.01, 0.01);
    } completion:^(BOOL finished) {
        [sender.view removeFromSuperview];
        if (_currentMatch) {
            [self goToBack];
        } else {
            [self doDelayedAction:_lastAction];
        }
    }];
}

-(void) showShare:(UIGestureRecognizer*)sender {
    
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
