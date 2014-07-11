#import "Question.h"

@implementation Question


- (id)initWithNSGameData:(NSData *)matchData {
   NSDictionary *matchDict = [NSJSONSerialization JSONObjectWithData:matchData options:NSJSONReadingMutableContainers error:nil];
   if(matchData && matchDict) {
      if ( self = [super init] ) {
         [self setImgURLs:[matchDict objectForKey:@"i"]];
         [self setScramble:[matchDict objectForKey:@"s"]];
         [self setSolution:[matchDict objectForKey:@"t"]];
         [self setQOwner:[matchDict objectForKey:@"u"]];
         [self setQID:[[matchDict objectForKey:@"id"] intValue]];
         return self;
      }
   }
   return nil;
}

@end
