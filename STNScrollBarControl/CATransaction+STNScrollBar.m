//
//  CATransaction+STNScrollBar.m
//  STNScrollBarControl
//
//  Created by Stone Zhang on 9/23/17.
//  Copyright © 2017 Stone Zhang. All rights reserved.
//

#import "CATransaction+STNScrollBar.h"

@implementation CATransaction (STNScrollBar)

+ (void)stn_disableAnimaton:(void (^)(void))block {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    block();
    [CATransaction commit];
}

@end
