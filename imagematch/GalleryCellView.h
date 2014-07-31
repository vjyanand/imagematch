#import "SWTableViewCell.h"

@interface GalleryCellView : SWTableViewCell

@property(nonatomic, weak) IBOutlet UIImageView *imgView;
@property(nonatomic, weak) IBOutlet UILabel *lblLikes;
@property(nonatomic, weak) IBOutlet UILabel *mainLabel;

@end
