//
//  DRDraggableTableViewCell.m
//  Drift
//
//  Created by Christoph Albert on 3/8/14.
//  Copyright (c) 2014 Christoph Albert. All rights reserved.
//

#import "DRDraggableTableViewCell.h"
#import "BRCancelIcon.h"

const CGFloat kCatchWidth = 100;

@interface DRDraggableTableViewCell() {
	BOOL _deleteOnDragRelease;
}

@property (nonatomic, strong) UIView *deleteImage;

@end

@implementation DRDraggableTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [DRTheme base0];
        self.contentView.backgroundColor = [DRTheme base0];

        UIView *panContentView = [[UIView alloc] init];
        panContentView.backgroundColor = [DRTheme base4];
        [self.contentView addSubview:panContentView];
        self.panContentView = panContentView;

        UIPanGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        recognizer.delegate = self;
        [self.panContentView addGestureRecognizer:recognizer];

        UIView *deleteImage = [BRCancelIcon viewWithColor:[DRTheme base4]];
        deleteImage.alpha = 0;
        [self.contentView addSubview:deleteImage];
        self.deleteImage = deleteImage;

        self.draggable = YES;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.panContentView.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.height);

    self.deleteImage.x = self.contentView.width + 25;
    self.deleteImage.y = (self.contentView.height-self.deleteImage.height)/2;

    [self.panContentView addSubview:self.textLabel];
    [self.panContentView addSubview:self.detailTextLabel];
    [self.panContentView addSubview:self.disclosure];
}

#pragma mark - horizontal pan gesture methods
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [pan translationInView:[pan.view superview]];
        // Check for horizontal gesture
        if (self.draggable && fabsf(translation.x) > fabsf(translation.y) && translation.x < 0) {
            return YES;
        }
        return NO;
    } else {
        return [super gestureRecognizerShouldBegin:gestureRecognizer];
    }
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        CGFloat trans = MIN(translation.x, 0);
        self.panContentView.transform = CGAffineTransformMakeTranslation(trans, 0);
        self.deleteImage.transform = CGAffineTransformMakeTranslation(trans, 0);

        CGFloat alphaVal = pow(fabs(translation.x)/kCatchWidth, 3);
        self.deleteImage.alpha = MAX(0, MIN(1, alphaVal));

        _deleteOnDragRelease = self.panContentView.x < -kCatchWidth;
        if (_deleteOnDragRelease) {
            self.contentView.backgroundColor = [DRTheme dangerColor];
        } else {
            self.contentView.backgroundColor = [DRTheme base1];
        }

    }

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // the frame this cell would have had before being dragged
        [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.7 options:0 animations:^{
            self.panContentView.transform = CGAffineTransformIdentity;
            self.deleteImage.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.deleteImage.alpha = 0;
            if (_deleteOnDragRelease) {
                if ([self.delegate respondsToSelector:@selector(tableViewCellDidSelectDeleteButton:)]) {
                    [self.delegate tableViewCellDidSelectDeleteButton:self];
                }
            }
        }];
    }
}

@end
