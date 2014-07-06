#import "FlickrPhotoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation FlickrPhotoCell

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
        bgView.backgroundColor = [UIColor blueColor];
        bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
        bgView.layer.borderWidth = 4;
        self.selectedBackgroundView = bgView;      
    }
    return self;
}

- (void) setPhoto:(NSString *)photo {
    [self.imageView setImageWithURL:[NSURL URLWithString:@"http://www.domain.com/path/to/image.jpg"]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
