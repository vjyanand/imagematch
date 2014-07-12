#import "GameScore.h"


@implementation GameScore

+ (GameScore *)sharedInstance {
   static GameScore *sharedInstance;
   static dispatch_once_t onceQueue;
   dispatch_once(&onceQueue, ^{
      sharedInstance = [[GameScore alloc] init];
      [sharedInstance addObserver:sharedInstance forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:nil];
   });
   return sharedInstance;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
   if([keyPath isEqualToString:@"score"]) {
      [self saveGameScore];
   }
}

- (void)loadGameCoinWithCompletionHandler:(void(^)(int64_t score, NSError *error))completionHandler {
   NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://iavian.net/im/xoin?u=%@", [GKLocalPlayer localPlayer].playerID]];
   NSError *error = nil;
   NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] options:kNilOptions error:&error];
   if(error) {
      completionHandler(-1, error);
   } else {
      _coin = [[json objectForKey:@"c"] intValue];
      completionHandler(_coin, error);
   }
}

- (void)loadGameScoreWithCompletionHandler:(void(^)(int64_t score, NSError *error))completionHandler {
   GKLeaderboard *lb = [[GKLeaderboard alloc] initWithPlayerIDs:@[[GKLocalPlayer localPlayer].playerID]];
   lb.identifier = @"top_matcher";
   [lb loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
      if(error == nil && [scores count] == 1) {
         GKScore *gscore = [scores lastObject];
         _score = gscore.value;
         completionHandler(_score, error);
      }
   }];
}

- (void)setGameCoin:(int64_t) pCoin {
   if (_coin != pCoin) {
      [self saveGameCoin:(pCoin - _coin) doUpdate:YES];
      _coin = pCoin;
   }
}

- (void)updateGameCoin:(int64_t) pCoin {
   [self setGameCoin:(_coin + pCoin)];
}

- (void)saveGameCoin:(int64_t) pCoin doUpdate:(bool) update {
   NSString *post = [NSString stringWithFormat:@"&u=%@&s=%lld&up=%i", [GKLocalPlayer localPlayer].playerID, pCoin, update];
   NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
   NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://iavian.net/im/xoin"]];
   [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
   [request setHTTPMethod:@"POST"];
   [request setHTTPBody:postData];
   NSOperationQueue *queue = [[NSOperationQueue alloc] init];
   [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
      
   }];
}

- (void)saveGameScore {
   GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:@"top_matcher"];
   scoreReporter.value = _score;
    [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
    
    }];
}

- (void)dealloc {
   [self removeObserver:self forKeyPath:@"score" context:nil];
}

@end
