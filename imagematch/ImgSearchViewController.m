#import "ImgSearchViewController.h"
#import "FlickrPhotoCell.h"
#import "UIImageView+WebCache.h"

@interface ImgSearchViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *items;
@property (weak, nonatomic) IBOutlet UIView *imgHolder1;
@property (weak, nonatomic) IBOutlet UIView *imgHolder2;
@property (weak, nonatomic) IBOutlet UIView *imgHolder3;
@property (weak, nonatomic) IBOutlet UIView *imgHolder4;

@end

@implementation ImgSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 1000;// [self.items count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlickrPhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    [cell setPhoto:@"http://www.domain.com/path/to/image.jpg"];
    
    
    return cell;
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
