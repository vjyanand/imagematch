#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface FlickrPhotoCell : UICollectionViewCell

@property(nonatomic, strong) IBOutlet UIImageView *imageView;
- (void) setPhoto:(NSString *)photo;
- (NSString*) getPhotoURL;

@end
