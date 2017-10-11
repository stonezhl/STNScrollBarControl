//
//  STNScrollBarText.h
//  STNScrollBarControl
//
//  Created by Stone Zhang on 10/8/17.
//  Copyright © 2017 Stone Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STNScrollBarText : CATextLayer
- (BOOL)updateTextWithItemString:(NSString *)itemString;
- (void)fadeInText;
- (void)fadeOutText;
@end
