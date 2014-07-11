#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (nonatomic, strong) NSString *solution;
@property (nonatomic, strong) NSString *scramble;
@property (nonatomic, strong) NSArray *imgURLs;
@property (nonatomic, strong) NSString *qOwner;
@property (nonatomic, assign) int qID;

- (id)initWithNSGameData:(NSData *)matchData;

@end
