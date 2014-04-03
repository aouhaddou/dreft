//
//  DRSonarView.m
//  Drift
//
//  Created by Christoph Albert on 4/1/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRSonarView.h"
#import "AngleGradientLayer.h"

@interface DRSonarView()

@end

@implementation DRSonarView

+ (Class)layerClass
{
	return [AngleGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
	if (!(self = [super initWithFrame:frame]))
		return nil;

	AngleGradientLayer *l = (AngleGradientLayer *)self.layer;
	l.colors = [NSArray arrayWithObjects:
                (id)[UIColor colorWithWhite:1 alpha:0.8].CGColor,
                (id)[UIColor colorWithWhite:1 alpha:0].CGColor,
                (id)[UIColor colorWithWhite:1 alpha:0].CGColor,
                (id)[UIColor colorWithWhite:1 alpha:0].CGColor,
                nil];
    
	return self;
}
@end
