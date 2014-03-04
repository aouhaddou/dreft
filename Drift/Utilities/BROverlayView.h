#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BROverlayViewTransitionStyle) {
    BROverlayViewTransitionStyleBounce = 0,
    BROverlayViewTransitionStyleSlideFromBottom,
    BROverlayViewTransitionStyleSlideFromTop,
    BROverlayViewTransitionStyleFade,
    BROverlayViewTransitionStyleDropDown
};

@class BROverlayContentView;
typedef void(^BROverlayViewHandler)(BROverlayContentView *contentView);

@interface BROverlayContentView : UIView



@property (nonatomic, assign) BROverlayViewTransitionStyle transitionStyle;

@property (nonatomic, assign) CGPoint offset;

-(void)show;
-(void)showWithCompletion:(dispatch_block_t)completion;
-(void)dismiss;
-(void)dismissWithCompletion:(dispatch_block_t)completion;

@end

@interface BROverlayView : UIViewController

@property (nonatomic, assign) BOOL addsToWindow;
@property (nonatomic, assign) BOOL parallax;
@property (nonatomic, assign) BOOL blurryBackground;
@property (nonatomic, assign) CGFloat animationDuration;

- (id)initWithView:(BROverlayContentView *)view;
- (void)showWithTransitionStyle:(BROverlayViewTransitionStyle)style completion:(dispatch_block_t)completion;
- (void)dismissWithTransitionStyle:(BROverlayViewTransitionStyle)style completion:(dispatch_block_t)completion;

@end
