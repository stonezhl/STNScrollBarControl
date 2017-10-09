//
//  STNScrollBar.m
//  STNScrollBarControl
//
//  Created by Stone Zhang on 9/23/17.
//  Copyright © 2017 Stone Zhang. All rights reserved.
//

#import "STNScrollBar.h"
#import "STNScrollBarThumb.h"
#import "UIScrollView+STNScrollBar.h"

static const CGFloat kSTNScrollBarWidth = 30.0;
static const CGFloat kSTNScrollBarEnableThreshold = 1.5;
static const CGFloat kSTNScrollBarAnimationInterval = 0.3;
static const CGFloat kSTNScrollBarAnimationHideDelay = 1.0;

static NSString * const kSTNScrollViewContentInsetKeyPath = @"contentInset";

@interface STNScrollBar ()
@property (strong, nonatomic) STNScrollBarThumb *thumb;
@property (weak, nonatomic) NSTimer *hideAnimationTimer;
@end

@implementation STNScrollBar

+ (instancetype)scrollBar {
    return [[STNScrollBar alloc] initScrollBar];
}

- (instancetype)initScrollBar {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        
        _thumb = [STNScrollBarThumb layer];
        [self.layer addSublayer:_thumb];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"[ℹ️]: layoutSubviews");
    
    if (self.hideAnimationTimer) {
        [self.hideAnimationTimer invalidate];
    }
    
    self.hidden = YES;
    self.frame = CGRectMake(CGRectGetWidth(_scrollView.frame),
                            CGRectGetMinY(_scrollView.frame) + _scrollView.stn_contentInsetTop,
                            kSTNScrollBarWidth,
                            _scrollView.stn_height);
    
    [self updateThumbPositionByScrollView];
}

- (void)viewDidDisappear {
    [self setNeedsLayout];
}

- (void)dealloc {
    [_scrollView removeObserver:self forKeyPath:kSTNScrollViewContentInsetKeyPath];
}

- (void)setScrollView:(UITableView *)scrollView {
    NSLog(@"[ℹ️]: setScrollView");
    
    [_scrollView removeObserver:self forKeyPath:kSTNScrollViewContentInsetKeyPath];
    _scrollView = scrollView;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollView addObserver:self forKeyPath:kSTNScrollViewContentInsetKeyPath options:NSKeyValueObservingOptionNew context:nil];
    
    [self setNeedsLayout];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object != _scrollView) {
        return;
    }
    
    if ([keyPath isEqualToString:kSTNScrollViewContentInsetKeyPath]) {
        NSLog(@"[😱]: kSTNScrollViewFrameKeyPath");
    }
    
    [self setNeedsLayout];
}

#pragma mark - Animation

- (void)show {
    if (_scrollView.contentSize.height < kSTNScrollBarEnableThreshold * _scrollView.stn_height) {
        return;
    }
    
    self.hidden = NO;
    self.alpha = 0;
    CGRect toFrame = self.frame;
    toFrame.origin.x = CGRectGetWidth(_scrollView.frame) - CGRectGetWidth(self.frame);
    [UIView animateWithDuration:kSTNScrollBarAnimationInterval
                     animations:^{
                         self.frame = toFrame;
                         self.alpha = 1;
                     }
                     completion:nil];
}

- (void)hideWithDelay {
    if (self.hideAnimationTimer != nil) {
        [self.hideAnimationTimer invalidate];
    }
    
    self.hideAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:kSTNScrollBarAnimationHideDelay target:self selector:@selector(hideWithAnimationOnTimer) userInfo:nil repeats:NO];
}

- (void)hideWithAnimationOnTimer {
    CGRect toFrame = self.frame;
    toFrame.origin.x = CGRectGetWidth(_scrollView.frame);
    [UIView animateWithDuration:kSTNScrollBarAnimationInterval
                     animations:^{
                         self.frame = toFrame;
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.hidden = YES;
                         self.alpha = 1;
                     }];
}

- (void)cancelHideWithDelay {
    if (self.hideAnimationTimer != nil) {
        [self.hideAnimationTimer invalidate];
    }
}

#pragma mark - Touch Event

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return CGRectContainsPoint(self.thumb.frame, point);
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.thumb.frame, point)) {
        // stop scrollview scrolling
        [self updateScrollViewContentOffset];
        [self cancelHideWithDelay];
        return YES;
    }
    
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self updateThumbPositionByTouch:touch];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self updateThumbPositionByTouch:touch];
    [self hideWithDelay];
}

- (void)updateScrollViewContentOffset {
    CGPoint offset = _scrollView.contentOffset;
    offset.y = (_scrollView.contentSize.height - CGRectGetHeight(self.frame)) * [self thumbOffsetRatio] - _scrollView.stn_contentInsetTop;
    [_scrollView setContentOffset:offset animated:NO];
}

#pragma mark - Thumb

- (void)updateThumbPositionByScrollView {
    if (self.isTracking) {
        // Thumb is being tracked by touch now
        return;
    }
    
    CGFloat y = (CGRectGetHeight(self.frame) - CGRectGetHeight(self.thumb.bounds)) * _scrollView.stn_didScrollRatio;
    y = MIN(MAX(y, 0), CGRectGetHeight(self.frame) - CGRectGetHeight(self.thumb.bounds));
    [self.thumb setOriginY: y];
}

- (void)updateThumbPositionByTouch:(UITouch *)touch {
    CGFloat y = [touch locationInView:self].y - CGRectGetHeight(self.thumb.bounds) * 0.5;
    y = MIN(MAX(y, 0), (CGRectGetHeight(self.frame) - CGRectGetHeight(self.thumb.bounds)));
    BOOL updatedThumbPosition = [self.thumb setOriginY:y];
    
    if (updatedThumbPosition) {
        [self updateScrollViewContentOffset];
    }
}

- (CGFloat)thumbOffsetRatio {
    return CGRectGetMinY(self.thumb.frame) / (CGRectGetHeight(self.frame) - CGRectGetHeight(self.thumb.bounds));
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging {
    if (self.isHidden) {
        [self show];
    } else {
        [self cancelHideWithDelay];
    }
}

- (void)scrollViewDidScroll {
    [self updateThumbPositionByScrollView];
}

- (void)scrollViewDidEndDraggingAndWillDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        if (self.isHidden == NO) {
            [self hideWithDelay];
        }
    }
}

- (void)scrollViewDidEndDecelerating {
    if (self.isHidden == NO) {
        [self hideWithDelay];
    }
}

@end
