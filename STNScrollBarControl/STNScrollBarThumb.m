//
//  STNScrollBarThumb.m
//  STNScrollBarControl
//
//  Created by Stone Zhang on 9/23/17.
//  Copyright © 2017 Stone Zhang. All rights reserved.
//

#import "STNScrollBarThumb.h"
#import <UIKit/UIKit.h>
#import "CATransaction+STNScrollBar.h"

static const CGFloat kSTNScrollBarThumbDiameter = 40.0;

@implementation STNScrollBarThumb

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kSTNScrollBarThumbDiameter, kSTNScrollBarThumbDiameter);
        self.borderWidth = 0.1;
        self.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25] CGColor];
        self.backgroundColor = [[UIColor whiteColor] CGColor];
        self.cornerRadius = kSTNScrollBarThumbDiameter * 0.5;
        
        // shadow style
        self.shadowOpacity = 1.0;
        self.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25] CGColor];
        self.shadowOffset = CGSizeMake(0, 2.0);
        self.shadowRadius = 2.0;
        
        // draw triangle
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(kSTNScrollBarThumbDiameter * 0.5, kSTNScrollBarThumbDiameter * 0.25)];
        [path addLineToPoint:CGPointMake(kSTNScrollBarThumbDiameter * 0.375, kSTNScrollBarThumbDiameter * 0.4375)];
        [path addLineToPoint:CGPointMake(kSTNScrollBarThumbDiameter * 0.625, kSTNScrollBarThumbDiameter * 0.4375)];
        [path closePath];
        
        [path moveToPoint:CGPointMake(kSTNScrollBarThumbDiameter * 0.5, kSTNScrollBarThumbDiameter * 0.75)];
        [path addLineToPoint:CGPointMake(kSTNScrollBarThumbDiameter * 0.375, kSTNScrollBarThumbDiameter * 0.5625)];
        [path addLineToPoint:CGPointMake(kSTNScrollBarThumbDiameter * 0.625, kSTNScrollBarThumbDiameter * 0.5625)];
        [path closePath];
        self.path = [path CGPath];
        self.fillColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] CGColor];
    }
    return self;
}

- (BOOL)setOriginY:(CGFloat)y {
    CGFloat positionY = y + CGRectGetHeight(self.bounds) * 0.5;
    if (self.position.y == positionY) {
        return NO;
    }
    
    [CATransaction stn_disableAnimaton:^{
        self.position = CGPointMake(self.position.x, positionY);
    }];
    return YES;
}

@end
