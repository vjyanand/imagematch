#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface ChallengeCellView : SWTableViewCell


@property(nonatomic, weak) IBOutlet UILabel *userLabel;
@property(nonatomic, weak) IBOutlet UILabel *statusLabel;
@property(nonatomic, weak) IBOutlet UILabel *timeLabel;
@property(nonatomic, weak) IBOutlet UIImageView *imgView;


@end
