//
//  UIScrollView+STNScrollBar.m
//  STNScrollBarControl
//
//  Created by Stone Zhang on 9/23/17.
//  Copyright © 2017 Stone Zhang. All rights reserved.
//

#import "UIScrollView+STNScrollBar.h"

@implementation UIScrollView (STNScrollBar)

- (CGFloat)stn_contentInsetTop {
    CGFloat top = self.contentInset.top;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 110000
    if (@available(iOS 11, *)) {
        top += self.adjustedContentInset.top;
    }
#endif
    return top;
}

- (CGFloat)stn_contentInsetBottom {
    CGFloat bottom = self.contentInset.bottom;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 110000
    if (@available(iOS 11, *)) {
        bottom += self.adjustedContentInset.bottom;
    }
#endif
    return bottom;
}

- (CGFloat)stn_height {
    return CGRectGetHeight(self.frame) - self.stn_contentInsetTop - self.stn_contentInsetBottom;
}

- (CGFloat)stn_didScrollRatio {
    return (self.contentOffset.y  + self.stn_contentInsetTop) / (self.contentSize.height - self.stn_height);
}

@end
