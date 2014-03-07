//
//  DRDrift.m
//  Drift
//
//  Created by Christoph Albert on 3/7/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRDrift.h"

@implementation DRDrift

-(void)setDistance:(CGFloat)distance {
    _distance = distance;
}
-(void)setLocation:(CLLocation *)location {
    _location = location;
}
-(void)setLeg:(NSInteger)leg {
    _leg = leg;
}
-(void)setDirection:(DRDriftDirection)direction {
    _direction = direction;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.distance = [decoder decodeDoubleForKey:@"distance"];
    self.location = [decoder decodeObjectForKey:@"location"];
    self.leg = [decoder decodeIntegerForKey:@"leg"];
    self.direction = [decoder decodeIntegerForKey:@"direction"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeDouble:self.distance forKey:@"distance"];
    [encoder encodeObject:self.location forKey:@"location"];
    [encoder encodeInteger:self.leg forKey:@"leg"];
    [encoder encodeInteger:self.direction forKey:@"direction"];
}

@end
