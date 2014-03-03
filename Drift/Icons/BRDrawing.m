//
//  BRIcon.m
//  Datalove
//
//  Created by Christoph on 4/6/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import "BRDrawing.h"
#import "UIView+Image.h"

@implementation BRDrawing

+ (instancetype)viewWithColor:(UIColor *)color {
    return [(BRDrawing *)[self alloc] initWithColor:color];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [[(BRDrawing *)[self alloc] initWithColor:color] layerRepresentation];
}

- (id)initWithColor:(UIColor *)color
{
    self = [super initWithFrame:CGRectMake(0, 0, _size.width, _size.height)];
    if (self) {
        _color = color;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

@end
