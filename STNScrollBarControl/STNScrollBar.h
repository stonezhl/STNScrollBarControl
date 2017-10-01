//
//  STNScrollBar.h
//  STNScrollBarControl
//
//  Created by Stone Zhang on 9/23/17.
//  Copyright © 2017 Stone Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STNScrollBar : UIControl
@property (weak, nonatomic) UITableView *scrollView;
+ (instancetype)scrollBar;
- (void)viewDidDisappear;
// UIScrollViewDelegate
- (void)scrollViewWillBeginDragging;
- (void)scrollViewDidScroll;
- (void)scrollViewDidEndDraggingAndWillDecelerate:(BOOL)decelerate;
- (void)scrollViewDidEndDecelerating;
@end
