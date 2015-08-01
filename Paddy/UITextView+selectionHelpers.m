//
//  UITextView+selectionHelpers.m
//  Paddy
//
//  Created by Jian Jie on 26/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "UITextView+selectionHelpers.h"

@implementation UITextView (selectionHelpers)

- (NSUInteger)lineOfStartOfSelection
{
    return [self.text lineOfStartForLocation:self.selectedRange.location];
}

- (NSUInteger)locationOfStartOfSelectionInLine
{
    return [self.text locationOfLocationInLine:self.selectedRange.location];
}

@end
