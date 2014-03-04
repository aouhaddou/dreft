#import "BROverlayView.h"
#import <QuartzCore/QuartzCore.h>
#import "CALayer+KeyframeAnimations.h"
#import "UIImage+ImageEffects.h"
#import "UIView+Image.h"

static BROverlayView *displayedOverlayView;

@interface BROverlayContentView()

@property (nonatomic, copy) BROverlayViewHandler willShowHandler;
@property (nonatomic, copy) BROverlayViewHandler didShowHandler;
@property (nonatomic, copy) BROverlayViewHandler willDismissHandler;
@property (nonatomic, copy) BROverlayViewHandler didDismissHandler;
@property (nonatomic, strong) BROverlayView *overlayView;

@end

@implementation BROverlayContentView

-(id)init {
    self = [super init];
    if (self) {
        [self setupOverlay];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupOverlay];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupOverlay];
    }
    return self;
}

-(void)setupOverlay {
    self.transitionStyle = BROverlayViewTransitionStyleBounce;
    self.offset = CGPointMake(0, 0);
    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
}

-(void)show {
    [self showWithCompletion:nil];
}

-(void)showWithCompletion:(dispatch_block_t)completion {
    if (self.willShowHandler) {
        self.willShowHandler(self);
    }

    BROverlayView *view = [[BROverlayView alloc] initWithView:self];
    self.overlayView = view;

    [view showWithTransitionStyle:self.transitionStyle completion:^{
        if (completion) {
            completion();
        }
        if (self.didShowHandler) {
            self.didShowHandler(self);
        }
    }];
}

-(void)dismiss {
    [self dismissWithCompletion:nil];
}

-(void)dismissWithCompletion:(dispatch_block_t)completion {
    if (self.willDismissHandler) {
        self.willDismissHandler(self);
    }

    [self.overlayView dismissWithTransitionStyle:self.transitionStyle completion:^{
        if (completion) {
            completion();
        }
        if (self.didDismissHandler) {
            self.didDismissHandler(self);
        }
    }];
}

@end

CGFloat const kRNGridMenuDefaultDuration = 0.33f;

@interface BROverlayView()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) BROverlayContentView *contentView;
@property (nonatomic, strong) UITapGestureRecognizer *superviewTapGesture;
@property (nonatomic, assign) BOOL viewHasLoaded;
@property (nonatomic, strong) UIMotionEffectGroup *parallaxGroup;

@end

@implementation BROverlayView

- (id)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (id)initWithView:(BROverlayContentView *)view {
    if (self = [self init]) {
        self.contentView = view;
        [self addMotionToContentView];
    }
    return self;
}

- (void)setup {
    self.animationDuration = kRNGridMenuDefaultDuration;
    self.parallax = YES;
    self.addsToWindow = NO;
    self.blurryBackground = NO;

    self.view.backgroundColor = [UIColor clearColor];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeOrientationNotification:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}

-(void)addMotionToContentView {
    if (self.contentView == nil) {
        return;
    }

    UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xAxis.minimumRelativeValue = @(-15.0f);
    xAxis.maximumRelativeValue = @(15.0f);

    UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yAxis.minimumRelativeValue = @(-15.0f);
    yAxis.maximumRelativeValue = @(15.0f);

    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[xAxis,yAxis];

    [self.contentView addMotionEffect:group];
}

-(void)setParallax:(BOOL)parallax {
    if (self.contentView != nil) {
        for (UIMotionEffectGroup *group in self.contentView.motionEffects) {
            [self.contentView removeMotionEffect:group];
        }
        if (parallax == YES) {
            [self addMotionToContentView];
        }
    }
    _parallax = parallax;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewHasLoaded = YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Layout

- (void)layoutBackgroundAndView {
    self.view.frame = self.view.superview.bounds;
    self.backgroundView.frame = self.view.bounds;
    self.contentView.center = self.view.center;
    self.contentView.x += self.contentView.offset.x;
    self.contentView.y += self.contentView.offset.y;
}

- (void)createScreenshotAndLayout {
    self.view.alpha = 0;
    self.backgroundView.alpha = 0;
    self.contentView.alpha = 0;

    self.backgroundView.layer.contents = (id) [self blurryBackgroundImage].CGImage;
    
    self.view.alpha = 1;
    self.backgroundView.alpha = 1;
    self.contentView.alpha = 1;
    
    [self layoutBackgroundAndView];
}

-(UIImage *)blurryBackgroundImage {
    UIView *snapshotView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    UIImage *snapshot = [snapshotView imageRepresentation];
    UIColor *tintColor = [UIColor colorWithWhite:1 alpha:0.25];
    return [snapshot applyBlurWithRadius:5 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];

}

#pragma mark - Notifications

- (void)didChangeOrientationNotification:(NSNotification *)notification {
    if (self.blurryBackground && self.viewHasLoaded && self.view.superview) {
        [self performSelector:@selector(createScreenshotAndLayout) withObject:nil afterDelay:0.01];
    }
}

#pragma mark - Gestures

- (void)superviewTapGestureHandler:(UITapGestureRecognizer *)recognizer {
    self.contentView.transitionStyle = BROverlayViewTransitionStyleDropDown;
    [self.contentView dismiss];
}

#pragma mark - Animations

- (void)showWithTransitionStyle:(BROverlayViewTransitionStyle)style completion:(dispatch_block_t)completion {
    displayedOverlayView = self;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (!window)
        window = [UIApplication sharedApplication].windows[0];

    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (self.blurryBackground) {
        self.backgroundView.layer.contents = (id) [self blurryBackgroundImage].CGImage;
    } else {
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];
    }
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.contentView];

    if(self.addsToWindow) {
        [window addSubview:self.view];
    }
    else {
        UIView *view = [window subviews][0];
        [view addSubview:self.view];
    }

    [self layoutBackgroundAndView];
    
    self.superviewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(superviewTapGestureHandler:)];
    [self.backgroundView performSelector:@selector(addGestureRecognizer:) withObject:self.superviewTapGesture afterDelay:self.animationDuration];

    //Transition Background
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(0);
    opacityAnimation.toValue = @(1);
    opacityAnimation.duration = self.animationDuration * 0.5f;
    [self.backgroundView.layer addAnimation:opacityAnimation forKey:nil];

    switch (style) {
        case BROverlayViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = self.contentView.frame;
            CGRect originalRect = rect;
            rect.origin.y = self.view.bounds.size.height;
            self.contentView.frame = rect;
            [UIView animateWithDuration:self.animationDuration
                             animations:^{
                                 self.contentView.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case BROverlayViewTransitionStyleSlideFromTop:
        {
            CGRect rect = self.contentView.frame;
            CGRect originalRect = rect;
            rect.origin.y = -rect.size.height;
            self.contentView.frame = rect;
            [UIView animateWithDuration:self.animationDuration
                             animations:^{
                                 self.contentView.frame = originalRect;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case BROverlayViewTransitionStyleFade:
        {
            self.contentView.alpha = 0;
            [UIView animateWithDuration:self.animationDuration
                             animations:^{
                                 self.contentView.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case BROverlayViewTransitionStyleBounce:
        {
            CAKeyframeBlocksAnimation *animation = [CAKeyframeBlocksAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0), @(1.13), @(0.95),@(1)];
            animation.keyTimes = @[@(0), @(0.5), @(0.75), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = self.animationDuration;
            animation.completion = ^(BOOL finished){
                if (completion) {
                    completion();
                }
            };
            [self.contentView.layer addAnimation:animation forKey:@"bounce"];
        }
            break;
        case BROverlayViewTransitionStyleDropDown:
        {
            CGFloat y = self.contentView.center.y;
            CAKeyframeBlocksAnimation *animation = [CAKeyframeBlocksAnimation animationWithKeyPath:@"position.y"];
            animation.values = @[@(y - self.view.bounds.size.height), @(y + 15), @(y - 4), @(y)];
            animation.keyTimes = @[@(0), @(0.5), @(0.75), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = self.animationDuration+0.1;
            animation.completion = ^(BOOL finished){
                if (completion) {
                    completion();
                }
            };
            [self.contentView.layer addAnimation:animation forKey:@"dropdown"];
        }
            break;
        default:
            break;
    }
}

- (void)dismissWithTransitionStyle:(BROverlayViewTransitionStyle)style completion:(dispatch_block_t)completion {
    //Background
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1);
    opacityAnimation.toValue = @(0);
    opacityAnimation.duration = self.animationDuration;
    [self.backgroundView.layer addAnimation:opacityAnimation forKey:nil];
    self.backgroundView.layer.opacity = 0;
    
    //Transition Content
    switch (style) {
        case BROverlayViewTransitionStyleSlideFromBottom:
        {
            CGRect rect = self.contentView.frame;
            rect.origin.y = self.view.bounds.size.height;
            [UIView animateWithDuration:self.animationDuration
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.contentView.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 [self cleanup];
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case BROverlayViewTransitionStyleSlideFromTop:
        {
            CGRect rect = self.contentView.frame;
            rect.origin.y = -rect.size.height;
            [UIView animateWithDuration:self.animationDuration
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.contentView.frame = rect;
                             }
                             completion:^(BOOL finished) {
                                 [self cleanup];
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case BROverlayViewTransitionStyleFade:
        {
            [UIView animateWithDuration:self.animationDuration
                             animations:^{
                                 self.contentView.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 [self cleanup];
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        case BROverlayViewTransitionStyleBounce:
        {
            CAKeyframeBlocksAnimation *animation = [CAKeyframeBlocksAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(1), @(1.12), @(0)];
            animation.keyTimes = @[@(0), @(0.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = self.animationDuration;
            animation.completion = ^(BOOL finished){
                [self cleanup];
                if (completion) {
                    completion();
                }
            };
            [self.contentView.layer addAnimation:animation forKey:@"bounce"];

            self.contentView.transform = CGAffineTransformMakeScale(0, 0);
        }
            break;
        case BROverlayViewTransitionStyleDropDown:
        {
            CGPoint point = self.contentView.center;
            point.y += self.view.bounds.size.height;
            [UIView animateWithDuration:self.animationDuration
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 self.contentView.center = point;
                                 CGFloat angle = 0.25f;
                                 self.contentView.transform = CGAffineTransformMakeRotation(angle);
                             }
                             completion:^(BOOL finished) {
                                 [self cleanup];
                                 if (completion) {
                                     completion();
                                 }
                             }];
        }
            break;
        default:
            break;
    }
}

- (void)cleanup {
    [self.backgroundView removeGestureRecognizer:self.superviewTapGesture];
    [self.contentView removeFromSuperview];
    [self.backgroundView removeFromSuperview];
    [self.view removeFromSuperview];
    displayedOverlayView = nil;
}

@end