//
//  STNScrollBarText.m
//  STNScrollBarControl
//
//  Created by Stone Zhang on 10/8/17.
//  Copyright © 2017 Stone Zhang. All rights reserved.
//

#import "STNScrollBarText.h"
#import "CATransaction+STNScrollBar.h"

static const NSInteger kSTNScrollBarTextHeight = 30.0;
static const CGFloat kSTNScrollBarTextFontSize = 14.0;
static const CGFloat kSTNScrollBarTextPositionY = 20.0;
static const CGFloat kSTNScrollBarTextAnimationInterval = 0.3;

@interface STNScrollBarText ()
@property (strong, nonatomic) UIFont *itemFont;
@property (copy, nonatomic) NSString *itemString;
@end

@implementation STNScrollBarText

- (instancetype)init {
    self = [super init];
    if (self) {
        // set layer appearance
        self.backgroundColor = [[UIColor whiteColor] CGColor];
        self.foregroundColor = [[UIColor blackColor] CGColor];
        self.cornerRadius = kSTNScrollBarTextHeight * 0.5;
        self.wrapped = YES;
        self.contentsScale = [[UIScreen mainScreen] scale];
        self.alignmentMode = kCAAlignmentCenter;
        
        //choose a font
        UIFont *font = [UIFont boldSystemFontOfSize:kSTNScrollBarTextFontSize];
        //set font property
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        self.font = fontRef;
        self.fontSize = font.pointSize;
        CGFontRelease(fontRef);
        self.itemFont = font;
        
        // set board appearance
        self.borderWidth = 0.1;
        self.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25] CGColor];
        
        // shadow style
        self.shadowOpacity = 1.0;
        self.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25] CGColor];
        self.shadowOffset = CGSizeMake(0, 2.0);
        self.shadowRadius = 2.0;
    }
    return self;
}

- (BOOL)updateTextWithItemString:(NSString *)itemString {
    if ([self compareString:self.itemString with:itemString] == NO) {
        self.itemString = itemString;
        [self updateTextFrame];
        return YES;
    }
    return NO;
}

- (void)updateTextFrame {
    CGSize itemTextSize = [self textSizeWithString:self.itemString font:self.itemFont];
    if (itemTextSize.width < itemTextSize.height) {
        itemTextSize = CGSizeMake(itemTextSize.height, itemTextSize.height);
    }
    [CATransaction stn_disableAnimaton:^{
        self.bounds = CGRectMake(0, 0, itemTextSize.width, itemTextSize.height);
        self.position = CGPointMake(0 - itemTextSize.width * 0.5 - kSTNScrollBarTextPositionY, kSTNScrollBarTextPositionY);
    }];
}

- (void)setItemString:(NSString *)itemString {
    self.string = itemString;
    _itemString = itemString;
}

- (void)drawInContext:(CGContextRef)ctx {
    CGFloat height = self.bounds.size.height;
    CGFloat fontSize = self.fontSize;
    CGFloat yDiff = (height - fontSize) * 0.5 - fontSize * 0.1;
    
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0, yDiff);
    [super drawInContext:ctx];
    CGContextRestoreGState(ctx);
}

#pragma mark - Animation

- (void)fadeInText {
    if (self.isHidden) {
        self.hidden = NO;
        CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeIn.duration = kSTNScrollBarTextAnimationInterval;
        fadeIn.fromValue = [NSNumber numberWithFloat:0.0];
        fadeIn.toValue = [NSNumber numberWithFloat:1.0];
        [self addAnimation:fadeIn forKey:@"fadeIn"];
    }
}

- (void)fadeOutText {
    if (self.isHidden == NO) {
        CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeIn.duration = kSTNScrollBarTextAnimationInterval;
        fadeIn.fromValue = [NSNumber numberWithFloat:1.0];
        fadeIn.toValue = [NSNumber numberWithFloat:0.0];
        [self addAnimation:fadeIn forKey:@"fadeOut"];
        self.hidden = YES;
    }
}

#pragma mark - Helper

- (BOOL)compareString:(NSString *)stringA with:(NSString *)stringB {
    if (stringA == nil && stringB == nil) {
        return YES;
    }
    
    if (stringA != nil && stringB != nil) {
        return [stringA isEqualToString:stringB];
    }
    
    return NO;
}

- (CGSize)textSizeWithString:(NSString *)string font:(UIFont *)font {
    if (string) {
        if (string.length == 1) {
            return CGSizeMake(kSTNScrollBarTextHeight, kSTNScrollBarTextHeight);
        } else {
            CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:font}];
            return CGSizeMake(size.width  + 20.0, kSTNScrollBarTextHeight);
        }
    }
    return CGSizeZero;
}

@end
