#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface MakeQuestionViewController : UIViewController<GKTurnBasedMatchmakerViewControllerDelegate>

- (void)setTitle:(NSString *)searchKey andImages:(NSArray *)imgArrays;

@end
