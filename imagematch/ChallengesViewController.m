#import "ChallengesViewController.h"
#import "ChallengeCellView.h"
#import "Question.h"
#import "UIImageView+WebCache.h"
#import "UIColor+FlatUI.h"

@interface ChallengesViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet NSMutableDictionary *myMatches;
@property (nonatomic, strong) UISegmentedControl *mySwitch;

@end

@implementation ChallengesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refControl = [[UIRefreshControl alloc] init];
    [refControl addTarget:self action:@selector(loadMatches:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:refControl];
    
    UIImage *menuButtonImage = [UIImage imageNamed:@"list.png"];// set your image Name here
    UIButton *btnToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnToggle setImage:menuButtonImage forState:UIControlStateNormal];
    btnToggle.frame = CGRectMake(0, 0, menuButtonImage.size.width + 20, menuButtonImage.size.height);
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnToggle];
    [btnToggle addTarget:self action:@selector(goToBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    self.mySwitch = [[UISegmentedControl alloc] initWithItems:@[@"Your Turn", @"Other's Turn"]];
    [_mySwitch addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventValueChanged];
    _mySwitch.frame = CGRectMake(0,0,200,30);
    _mySwitch.selectedSegmentIndex = 0;
    _mySwitch.layer.cornerRadius = 5.0;
    
    self.navigationItem.titleView = _mySwitch;
    [self loadMatches:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_mySwitch.selectedSegmentIndex == 0) {
        return ((NSArray*)[_myMatches objectForKey:@"tm"]).count;
    } else {
        return ((NSArray*)[_myMatches objectForKey:@"fm"]).count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"RELO");
    ChallengeCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"challenge"];
    cell.delegate = self;
    
    /*if (!cell) {
     cell = [[ChallengeCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(84, 18, self.view.bounds.size.width - 95, 15.0)];
     userLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:17];
     userLabel.textColor = [UIColor blackColor];
     userLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
     userLabel.tag = 10;
     [cell.contentView addSubview:userLabel];
     UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
     imgView.tag = 11;
     [cell.contentView addSubview:imgView];
     
     CGFloat reminaingSpace = (self.view.bounds.size.width - 95) / 2 ;
     
     UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(84, 41, reminaingSpace, 40)];
     statusLabel.tag = 13;
     statusLabel.font = [UIFont fontWithName:@"Futura" size:16];
     [cell.contentView addSubview:statusLabel];
     
     timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(statusLabel.frame.origin.x + reminaingSpace, 41, reminaingSpace, 40)];
     timeLabel.tag = 12;
     timeLabel.textAlignment = UITextAlignmentRight;
     timeLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
     [cell.contentView addSubview:timeLabel];
     cell.contentView.backgroundColor = [UIColor whiteColor];
     } else {
     timeLabel = (id) [cell viewWithTag:12];
     UIImageView *imgView = (id)[cell viewWithTag:11];
     [imgView setImage:nil];
     }
     */
    
    
    GKTurnBasedParticipant *part;
    GKTurnBasedMatch *match;
    
    if (_mySwitch.selectedSegmentIndex == 0) {
        //cell.revealDirection = RMSwipeTableViewCellRevealDirectionBoth;
        NSArray *matches = [_myMatches objectForKey:@"tm"];
        match = [matches objectAtIndex:indexPath.row];
        part = [match.participants objectAtIndex:0];
    } else {
        //cell.revealDirection = RMSwipeTableViewCellRevealDirectionRight;
        NSArray *matches = [_myMatches objectForKey:@"fm"];
        match = [matches objectAtIndex:indexPath.row];
        part = [match.participants objectAtIndex:1];
    }
    
    NSLog(@"%@", match);
    
    [match loadMatchDataWithCompletionHandler:^(NSData *matchData, NSError *error) {
        if (error == nil) {
            UITableViewCell *cellToUpdate = [self.tableView cellForRowAtIndexPath:indexPath];
            UIImageView *imgView = (id)[cellToUpdate viewWithTag:11];
            Question *q = [[Question alloc] initWithNSGameData:matchData];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://iavian.com/render.php?i=%d&s=340", q.qID]];
            [imgView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed];
        }
    }];
    
    if(part !=nil && part.playerID !=nil) {
        [GKPlayer loadPlayersForIdentifiers:@[part.playerID] withCompletionHandler:^(NSArray *players, NSError *error) {
            
            NSLog(@"AAAA");
            
            if(error == nil && players.count == 1) {
                NSLog(@"AAAA");
                
                GKPlayer *player = [players lastObject];
                [cell.userLabel setText:player.alias];
                if(part.status == GKTurnBasedParticipantStatusUnknown) {
                    cell.statusLabel.text = @"Unknown";
                    cell.statusLabel.textColor = [UIColor yellowColor];
                } else if (part.status == GKTurnBasedParticipantStatusInvited) {
                    cell.statusLabel.text = @"Invited";
                    cell.statusLabel.textColor = [UIColor greenSeaColor];
                } else if (part.status == GKTurnBasedParticipantStatusMatching) {
                    cell.statusLabel.text = @"Matching";
                    cell.statusLabel.textColor = [UIColor amethystColor];
                } else if (part.status == GKTurnBasedParticipantStatusDone) {
                    if (part.matchOutcome == GKTurnBasedMatchOutcomeQuit) {
                        cell.statusLabel.text = @"Quit";
                        cell.statusLabel.textColor = [UIColor amethystColor];
                    } else {
                        cell.statusLabel.text = @"Solved";
                        cell.statusLabel.textColor = [UIColor amethystColor];
                    }
                } else if (part.status == GKTurnBasedParticipantStatusActive) {
                    if (part.matchOutcome == GKTurnBasedMatchOutcomeTied) {
                        cell.statusLabel.text = @"Quit";
                        cell.statusLabel.textColor = [UIColor amethystColor];
                    } else if (part.matchOutcome == GKTurnBasedMatchOutcomeLost) {
                        cell.statusLabel.text = @"Solved";
                        cell.statusLabel.textColor = [UIColor amethystColor];
                    } else {
                        cell.statusLabel.text = @"Invited";
                        cell.statusLabel.textColor = [UIColor amethystColor];
                    }
                }
            }
        }];
    } else {
        UILabel *userLabel = (id)[cell viewWithTag:10];
        UILabel *statusLabel = (id) [cell viewWithTag:13];
        [statusLabel setText:@"Matching"];
        [userLabel setText:@""];
    }
    
    NSLocale *locale = [NSLocale currentLocale];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MMM d h:m a" options:0 locale:locale];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:locale];
    cell.timeLabel.text = [formatter stringFromDate:match.creationDate];
    
    return cell;
}

- (void) changeView:(id) sender {
    NSLog(@"AB");
    [_tableView reloadData];
}

- (void)loadMatches:(id) sender{
    [GKTurnBasedMatch loadMatchesWithCompletionHandler:^(NSArray *matches, NSError *error) {
        if (error == nil) {
            self.myMatches = [[NSMutableDictionary alloc] initWithCapacity:2];
            NSMutableArray *tArray = [[NSMutableArray alloc] initWithCapacity:0];
            NSMutableArray *fArray = [[NSMutableArray alloc] initWithCapacity:0];
            [_myMatches setObject:tArray forKey:@"tm"];
            [_myMatches setObject:fArray forKey:@"fm"];
            
            for (GKTurnBasedMatch *match in matches) {
                if (match) {
                    
                    /*[match participantQuitOutOfTurnWithOutcome:GKTurnBasedMatchOutcomeQuit withCompletionHandler:^(NSError *error) {
                     [match removeWithCompletionHandler:^(NSError *error) {
                     NSLog(@"%@", error);
                     
                     }];
                     }]; */
                    
                    //NSLog(@"%@ \n>>>\n", match);
                    if (match.status == GKTurnBasedMatchStatusMatching) {
                        NSMutableArray *tArray = [_myMatches objectForKey:@"fm"];
                        [tArray addObject:match];
                    } else if (match.status == GKTurnBasedMatchStatusOpen) {
                        if([match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
                            if( match.currentParticipant.matchOutcome == GKTurnBasedMatchOutcomeNone) {
                                GKTurnBasedParticipant *nextPlayer;
                                if (match.currentParticipant == [match.participants objectAtIndex:0]) {
                                    nextPlayer = [[match participants] lastObject];
                                } else {
                                    nextPlayer = [[match participants] objectAtIndex:0];
                                }
                                if (nextPlayer.matchOutcome == GKTurnBasedMatchOutcomeQuit) {
                                    match.currentParticipant.matchOutcome = GKTurnBasedMatchOutcomeQuit;
                                    [match endMatchInTurnWithMatchData:match.matchData completionHandler:^(NSError *error) {
                                        [match removeWithCompletionHandler:^(NSError *error) {
                                            
                                        }];
                                    }];
                                } else {
                                    NSMutableArray *tArray = [_myMatches objectForKey:@"tm"];
                                    [tArray addObject:match];
                                }
                            } else if ( match.currentParticipant.matchOutcome == GKTurnBasedMatchOutcomeLost || match.currentParticipant.matchOutcome == GKTurnBasedMatchOutcomeTied) {
                                NSMutableArray *tArray = [_myMatches objectForKey:@"fm"];
                                [tArray addObject:match];
                            }
                        } else {
                            if(match.currentParticipant.matchOutcome == GKTurnBasedMatchOutcomeNone) {
                                NSMutableArray *tArray = [_myMatches objectForKey:@"fm"];
                                [tArray addObject:match];
                            }
                        }
                    }
                }
            }
            [_tableView reloadData];
        }
        if(sender){
            [sender endRefreshing];
        }
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
