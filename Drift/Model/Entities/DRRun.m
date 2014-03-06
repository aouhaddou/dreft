#import "DRRun.h"
#import "DRDataProcessor.h"
@import CoreLocation;

@interface DRRun ()

// Private interface goes here.

@end


@implementation DRRun

- (void)awakeFromInsert {
    [super awakeFromInsert];
    [self observeDrifts];
}

- (void)awakeFromFetch {
    [super awakeFromFetch];
    [self observeDrifts];
}

- (void)observeDrifts {
    [self addObserver:self forKeyPath:@"drifts" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"drifts"]) {
        NSArray *newDrifts = [change objectForKey:NSKeyValueChangeNewKey];
        [self handleDriftsChange:newDrifts];
    }
}

- (void)willTurnIntoFault {
    [super willTurnIntoFault];
    [self removeObserver:self forKeyPath:@"drifts"];
}

#pragma mark Photo

- (void)handleDriftsChange:(NSArray *)newDrifts {
    CGFloat distance = 0;
    CGFloat averageDrift = 0;
    NSInteger count = [newDrifts count];
    if (count > 1) {
        DRDriftResult *first = newDrifts[0];
        CGFloat driftTotal = first.drift;
        for (NSInteger i = 1; i<count; i++) {
            DRDriftResult *res1 = newDrifts[i-1];
            DRDriftResult *res2 = newDrifts[i];
            CGFloat leg = [res1.location distanceFromLocation:res2.location];
            distance += fabs(leg);
            driftTotal += res2.drift;
        }
        averageDrift = driftTotal/count;
    }
    self.distanceValue = distance;
    self.averageDriftValue = averageDrift;
}

@end
