//
//  UIScrollView+STNScrollBar.h
//  STNScrollBarControl
//
//  Created by Stone Zhang on 9/23/17.
//  Copyright © 2017 Stone Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (STNScrollBar)
- (CGFloat)stn_contentInsetTop;
- (CGFloat)stn_height;
- (CGFloat)stn_didScrollRatio;
@end
