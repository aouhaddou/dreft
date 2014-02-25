//
//  NSArray+DRExtensions.h
//  Drift
//
//  Created by Christoph Albert on 2/25/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NSArrayRelativePointsVerticalAlignment) {
    NSArrayRelativePointsVerticalAlignmentTop,
    NSArrayRelativePointsVerticalAlignmentCenter,
    NSArrayRelativePointsVerticalAlignmentBottom
};

typedef NS_ENUM(NSUInteger, NSArrayRelativePointsHorizontalAlignment) {
    NSArrayRelativePointsHorizontalAlignmentLeft,
    NSArrayRelativePointsHorizontalAlignmentCenter,
    NSArrayRelativePointsHorizontalAlignmentRight
};

@interface NSArray (DRExtensions)

-(NSArray *)dr_convertCLLocationsToRelativeMercatorPoints;
-(NSArray *)dr_zoomRelativeCoordinatesWithHorizontalAlignment:(NSArrayRelativePointsHorizontalAlignment)horizontalAlignment verticalAlignment:(NSArrayRelativePointsVerticalAlignment)verticalAlignment;

@end
