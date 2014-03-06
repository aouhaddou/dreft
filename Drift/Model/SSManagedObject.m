#import "SSManagedObject.h"
#import "NSString+UniqueIdentifier.h"
#import "CoreData+MagicalRecord.h"

@interface SSManagedObject ()

// Private interface goes here.

@end


@implementation SSManagedObject

-(void)awakeFromInsert {
    [super awakeFromInsert];
    if ([self respondsToSelector:@selector(setUniqueID:)]) {
        [self performSelector:@selector(setUniqueID:) withObject:[NSString uniqueIdentifier]];
    }
    if ([self respondsToSelector:@selector(setCreated:)]) {
        [self performSelector:@selector(setCreated:) withObject:[NSDate date]];
    }
}

+ (id)objectWithID:(NSString *)objectID {
    return [self objectWithID:objectID inContext:[NSManagedObjectContext MR_defaultContext]];
}

+ (id)objectWithID:(NSString *)objectID inContext:(NSManagedObjectContext *)context {
    if (objectID == nil || [objectID isEqualToString:@""] || context == nil) {
        DLog(@"Invalid attributes for uniqueID fetch");
        return nil;
    }

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"uniqueID LIKE %@", objectID];
    return [self MR_findFirstWithPredicate:pred inContext:context];
}

+ (NSArray *)objectsWithIDs:(NSSet *)objectIDs {
    return [self objectsWithIDs:objectIDs inContext:[NSManagedObjectContext MR_defaultContext]];
}

+ (NSArray *)objectsWithIDs:(NSSet *)objectIDs inContext:(NSManagedObjectContext *)context {
    if (objectIDs == nil || [objectIDs count] == 0 || context == nil) {
        DLog(@"Invalid attributes for uniqueID fetch");
        return nil;
    }

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"uniqueID IN %@", objectIDs];
    return [self MR_findAllWithPredicate:pred inContext:context];
}

@end
