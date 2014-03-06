#import "DRRun.h"
@import CoreLocation;

@interface DRRun ()

// Private interface goes here.

@end


@implementation DRRun

- (void)awakeFromInsert {
    [super awakeFromInsert];
    [self observeLocations];
}

- (void)awakeFromFetch {
    [super awakeFromFetch];
    [self observeLocations];
}

- (void)observeLocations {
    [self addObserver:self forKeyPath:@"locations" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"locations"]) {
        //        NSArray *oldLocations = [change objectForKey:NSKeyValueChangeOldKey];
        NSArray *newLocations = [change objectForKey:NSKeyValueChangeNewKey];
        [self handleLocationsChange:newLocations];
    }
}

- (void)willTurnIntoFault {
    [super willTurnIntoFault];
    [self removeObserver:self forKeyPath:@"locations"];
}

#pragma mark Photo

- (void)handleLocationsChange:(NSArray *)newLocations {
    CGFloat distance = 0;
    NSInteger count = [newLocations count];
    if (count > 1) {
        for (NSInteger i = 1; i<count; i++) {
            CLLocation *loc1 = newLocations[i-1];
            CLLocation *loc2 = newLocations[i];
            CGFloat leg = [loc1 distanceFromLocation:loc2];
            distance += fabs(leg);
        }
    }
    self.distanceValue = distance;
    //Average Drift
}

@end
