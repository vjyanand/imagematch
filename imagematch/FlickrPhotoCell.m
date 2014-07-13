#import "FlickrPhotoCell.h"

#import "UIImageView+WebCache.h"

@interface FlickrPhotoCell()

@property(nonatomic, strong) NSString* imgURL;

@end

@implementation FlickrPhotoCell

- (void) setPhoto:(NSString *)photo {
    self.imgURL = photo;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"loading.png"] options:SDWebImageRetryFailed|SDWebImageProgressiveDownload];
}

- (NSString*) getPhotoURL {
    return _imgURL;
}

@end


