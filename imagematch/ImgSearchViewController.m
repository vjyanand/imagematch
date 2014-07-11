#import "ImgSearchViewController.h"
#import "FlickrPhotoCell.h"
#import "UIImageView+WebCache.h"
#import "UIColor+FlatUI.h"
#import "MakeQuestionViewController.h"

@interface ImgSearchViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *imgHolder1;
@property (weak, nonatomic) IBOutlet UIView *imgHolder2;
@property (weak, nonatomic) IBOutlet UIView *imgHolder3;
@property (weak, nonatomic) IBOutlet UIView *imgHolder4;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UIImageView *draggingView;
@property (nonatomic, strong) UIBarButtonItem *rightButton;

@property (nonatomic, strong) NSString *searchKey;
@property (nonatomic, assign) int curPage;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSMutableArray *imgURLs;

@end

@implementation ImgSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_searchBar becomeFirstResponder];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if ((bottomEdge + 2.0) >= scrollView.contentSize.height && [self.items count] >= 98) {
        [self loadDataSource];
    }
}

- (void) createQuestion {
//    MakeQuestionViewController *makeQuestionViewController = [[MakeQuestionViewController alloc] initWithTitle:_searchKey images:_imgURLs];
  //  [self.navigationController pushViewController:makeQuestionViewController animated:YES];
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.items count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (IBAction)longPressed:(UILongPressGestureRecognizer*)sender {
    CGPoint loc = [sender locationInView:_collectionView];
    CGPoint locInScreen = CGPointMake(loc.x-_collectionView.contentOffset.x,  loc.y - _collectionView.contentOffset.y + 106);
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:loc];
        FlickrPhotoCell *cell = (FlickrPhotoCell*)[_collectionView cellForItemAtIndexPath:indexPath];
        self.draggingView = [[UIImageView alloc] initWithFrame:cell.frame];
        [_draggingView sd_setImageWithURL:[NSURL URLWithString:[cell getPhotoURL]]];
        _draggingView.center = CGPointMake(cell.frame.origin.x -_collectionView.contentOffset.x + 53, cell.frame.origin.y - _collectionView.contentOffset.y + 106 + 53);;
        [self.view addSubview:_draggingView];
        [UIView animateWithDuration:.4f animations:^{
            _draggingView.center = locInScreen;
            CGAffineTransform transform = CGAffineTransformMakeScale(0.6f, 0.6f);
            _draggingView.transform = transform;
        }];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        _draggingView.center = locInScreen;
        if ([self hitTest:_draggingView with:_imgHolder1]) {
            _imgHolder1.backgroundColor = [UIColor redColor];
        }
        if ([self hitTest:_draggingView with:_imgHolder2]) {
            _imgHolder2.backgroundColor = [UIColor redColor];
        }
        if ([self hitTest:_draggingView with:_imgHolder3]) {
            _imgHolder3.backgroundColor = [UIColor redColor];
        }
        if ([self hitTest:_draggingView with:_imgHolder4]) {
            _imgHolder4.backgroundColor = [UIColor redColor];
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.draggingView) {
            if ([self hitTest:_draggingView with:_imgHolder1]) {
                [self stickImgageToBottom:_draggingView wasDroppedOnTarget:_imgHolder1];
            } else if ([self hitTest:_draggingView with:_imgHolder2]) {
                [self stickImgageToBottom:_draggingView wasDroppedOnTarget:_imgHolder2];
            } else if ([self hitTest:_draggingView with:_imgHolder3]) {
                [self stickImgageToBottom:_draggingView wasDroppedOnTarget:_imgHolder3];
            } else if ([self hitTest:_draggingView with:_imgHolder4]) {
                [self stickImgageToBottom:_draggingView wasDroppedOnTarget:_imgHolder4];
            }
            [_draggingView removeFromSuperview];
        }
    }
}

- (BOOL)stickImgageToBottom:(UIImageView*)dragView wasDroppedOnTarget:(UIView*)dropTarget {
    if(_imgURLs == nil) {
        self.imgURLs = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"", nil];
    }
    if(dropTarget.tag == 301) {
        [_imgURLs replaceObjectAtIndex:0 withObject:[dragView sd_imageURL].absoluteString];
    } else if(dropTarget.tag == 302) {
        [_imgURLs replaceObjectAtIndex:1 withObject:[dragView sd_imageURL].absoluteString];
    } else if(dropTarget.tag == 303) {
        [_imgURLs replaceObjectAtIndex:2 withObject:[dragView sd_imageURL].absoluteString];
    } else if(dropTarget.tag == 304) {
        [_imgURLs replaceObjectAtIndex:3 withObject:[dragView sd_imageURL].absoluteString];
    }
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    UIImageView *stickyImg = [[UIImageView alloc] initWithImage:dragView.image];
    stickyImg.frame = CGRectInset(dropTarget.bounds, 4, 4);
    [stickyImg setTag:(dropTarget.tag + 10)];
    [stickyImg setUserInteractionEnabled:YES];
    [stickyImg addGestureRecognizer:swipeGesture];
    [[dropTarget viewWithTag:(dropTarget.tag + 10)] removeFromSuperview];
    [dropTarget addSubview:stickyImg];
    
    [UIView animateWithDuration:0.2 animations:^{
        stickyImg.frame = CGRectInset(dropTarget.bounds, 2, 2);
        dropTarget.backgroundColor = [UIColor colorWithRed:0.64079483695652173 green:0.61663917799123302 blue:0.61941982327278411 alpha:1.0];
        
    }];
    
    
    if([_imgURLs containsObject:@""]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        NSLog(@"%@", _imgURLs);
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    return YES;
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *) sender {
    UIView *source = [(UIGestureRecognizer *)sender view];
    [UIView animateWithDuration:0.33 animations:^{
        source.alpha = 0.5;
        source.transform = CGAffineTransformMakeScale(0.3, 0.3);
    } completion:^(BOOL finished){
        [source removeFromSuperview];
    }];
    [_imgURLs replaceObjectAtIndex:(source.tag - 311) withObject:@""];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (BOOL) hitTest:(UIView*) dragView with:(UIView*) targetView {
    CGRect intersect = CGRectIntersection(dragView.frame, targetView.frame);
    if (intersect.size.width > 30 && intersect.size.height > 30) {
        return YES;
    } else {
        targetView.backgroundColor = [UIColor colorWithRed:0.64079483695652173 green:0.61663917799123302 blue:0.61941982327278411 alpha:1.0];
    }
    return NO;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlickrPhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    
    NSString *item = [self.items objectAtIndex:indexPath.row];
    NSLog(@"%@", item);
    
    [cell setPhoto:item];
    
    return cell;
}

- (void)loadDataSource  {
    NSString *URLPath = [NSString stringWithFormat:@"https://iavian.net/im/search?s=%@&p=%d", [_searchKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], _curPage];
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        //[MBHUDView dismissCurrentHUD];
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                _curPage = [[res objectForKey:@"p"] intValue];
                if(self.items) {
                    self.items = [_items arrayByAddingObjectsFromArray:[res objectForKey:@"i"]];
                } else {
                    self.items = [res objectForKey:@"i"];
                }
                [self dataSourceDidLoad];
            } else {
                [self dataSourceDidError];
                //[MBHUDView hudWithBody:@"Error, Try again" type:MBAlertViewHUDTypeExclamationMark hidesAfter:2.0 show:YES];
            }
        } else {
            [self dataSourceDidError];
            //[MBHUDView hudWithBody:@"Error, Try again" type:MBAlertViewHUDTypeExclamationMark hidesAfter:2.0 show:YES];
        }
    }];
}

- (void)dataSourceDidLoad {
    [self.collectionView reloadData];
}

- (void)dataSourceDidError {
    [self.collectionView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSCharacterSet *alphaSet = [NSCharacterSet letterCharacterSet];
    NSString *searchString = [NSString stringWithFormat:@"%@", _searchBar.text];
    if ([searchString length] < 3 || [searchString length] > 10 || [[searchString stringByTrimmingCharactersInSet:alphaSet] isEqualToString:@""] == NO) {
        return;
    }
    //[MBHUDView hudWithBody:@"Getting images." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:0.0 show:YES];
    if([self.view viewWithTag:104]) {
        [[self.view viewWithTag:104] removeFromSuperview];
    }
    _items = nil;
    self.searchKey = [searchBar text];
    _curPage = 0;
    [self.collectionView setContentOffset:CGPointZero animated:YES];
    [self loadDataSource];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue identifier] isEqualToString:@"makequestion"]) {
         MakeQuestionViewController *vc = [segue destinationViewController];
         [vc setTitle:_searchKey andImages:_imgURLs];
     }
 }

@end
