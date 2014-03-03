//
//  BRIcon.h
//  Datalove
//
//  Created by Christoph on 4/6/13.
//  Copyright (c) 2013 Chris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRDrawing : UIView

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGSize size;

+ (instancetype)viewWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color;
- (id)initWithColor:(UIColor *)color;

@end
