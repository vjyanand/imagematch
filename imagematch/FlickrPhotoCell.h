#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface FlickrPhotoCell : UICollectionViewCell

@property(nonatomic, strong) IBOutlet UIImageView *imageView;
- (void) setPhoto:(NSString *)photo;

@end
