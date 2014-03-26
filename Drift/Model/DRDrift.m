//
//  DRDrift.m
//  Drift
//
//  Created by Christoph Albert on 3/7/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRDrift.h"

CLLocationDirection const DRDriftNoAngle = 1000;
NSInteger const DRDriftLegUnknown = -1;

@implementation DRDrift

-(id)init {
    self = [super init];
    if (self) {
        self.distance = 0;
        self.leg = DRDriftLegUnknown;
        self.direction = DRDriftDirectionUnknown;
        self.angle = DRDriftNoAngle;
    }
    return self;
}

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
-(void)setAngle:(CGFloat)angle {
    _angle = angle;
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
    self.angle = [decoder decodeDoubleForKey:@"angle"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeDouble:self.distance forKey:@"distance"];
    [encoder encodeObject:self.location forKey:@"location"];
    [encoder encodeInteger:self.leg forKey:@"leg"];
    [encoder encodeInteger:self.direction forKey:@"direction"];
    [encoder encodeDouble:self.distance forKey:@"angle"];
}

@end
