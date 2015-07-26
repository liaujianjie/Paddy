//
//  UITextView+selectionHelpers.m
//  Paddy
//
//  Created by Jian Jie on 26/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "UITextView+selectionHelpers.h"

@implementation UITextView (selectionHelpers)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSInteger)lineOfStartOfSelection
{
    if (!self || !self.isFirstResponder)
        return -1;
    
    NSArray *splitStrings = [self.text componentsSeparatedByString:@"\n"];
    NSRange selectedRange = self.selectedRange;
    
    NSInteger lineOfSelection = 0;
    NSInteger characterCount = 0;
    for (NSString *string in splitStrings)
    {
        characterCount += string.length + 1;
        if (selectedRange.location < characterCount)
            break;
        lineOfSelection ++;
    }
    
    return lineOfSelection;
}

- (NSInteger)locationOfStartOfSelectionInLine
{
    if (!self || !self.isFirstResponder)
        return -1;
    
    NSInteger lineOfSelection = self.lineOfStartOfSelection;
    NSArray *splitStrings = [self.text componentsSeparatedByString:@"\n"];
    
    NSInteger compoundedLinesLength = 0;
    NSInteger index = 0;
    while (index < lineOfSelection)
    {
        compoundedLinesLength += ((NSString *)splitStrings[index]).length + 1;
        index ++;
    }

    return self.selectedRange.location-compoundedLinesLength;
}

@end
