#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameScore : NSObject

@property(nonatomic, assign) int64_t score;

@property(nonatomic, assign, readonly) int64_t coin;

+ (GameScore *)sharedInstance;

- (void)loadGameScoreWithCompletionHandler:(void(^)(int64_t score, NSError *error))completionHandler;

- (void)loadGameCoinWithCompletionHandler:(void(^)(int64_t score, NSError *error))completionHandler;

- (void)setGameCoin:(int64_t) pCoin;

- (void)updateGameCoin:(int64_t) pCoin;

@end
