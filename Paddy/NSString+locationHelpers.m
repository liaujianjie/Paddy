//
//  NSString+locationHelpers.m
//  Paddy
//
//  Created by Jian Jie on 2/8/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "NSString+locationHelpers.h"

@implementation NSString (locationHelpers)

- (NSUInteger)lineOfStartForLocation:(NSUInteger)location
{
    NSArray *splitStrings = [self componentsSeparatedByString:@"\n"];
    
    NSInteger line = 0;
    NSInteger characterCount = 0;
    for (NSString *string in splitStrings)
    {
        characterCount += string.length + 1;
        if (location < characterCount)
            break;
        line ++;
    }
    
    return line;
}

- (NSUInteger)locationOfStartOfLineForLocation:(NSUInteger)location
{
    NSInteger lineOfLocation = [self lineOfStartForLocation:location];
    NSArray *splitStrings = [self componentsSeparatedByString:@"\n"];
    
    NSInteger compoundedLinesLength = 0;
    NSInteger index = 0;
    while (index < lineOfLocation)
    {
        compoundedLinesLength += ((NSString *)splitStrings[index]).length + 1;
        index ++;
    }
    return compoundedLinesLength;
}

- (NSUInteger)locationOfLocationInLine:(NSUInteger)location
{
    return location-[self locationOfStartOfLineForLocation:location];
}

@end
