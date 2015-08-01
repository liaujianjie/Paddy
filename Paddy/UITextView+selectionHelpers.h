//
//  UITextView+selectionHelpers.h
//  Paddy
//
//  Created by Jian Jie on 26/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+locationHelpers.h"

@interface UITextView (selectionHelpers)

- (NSUInteger)lineOfStartOfSelection;
- (NSUInteger)locationOfStartOfSelectionInLine;

@end
