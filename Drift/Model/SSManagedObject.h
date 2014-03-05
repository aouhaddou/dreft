#import <CoreData/CoreData.h>

@interface SSManagedObject : NSManagedObject

+ (id)objectWithID:(NSString *)objectID;
+ (id)objectWithID:(NSString *)objectID inContext:(NSManagedObjectContext *)context;
+ (NSArray *)objectsWithIDs:(NSSet *)objectIDs;
+ (NSArray *)objectsWithIDs:(NSSet *)objectIDs inContext:(NSManagedObjectContext *)context;

@end
