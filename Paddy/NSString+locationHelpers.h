//
//  NSString+locationHelpers.h
//  Paddy
//
//  Created by Jian Jie on 2/8/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (locationHelpers)

- (NSUInteger)lineOfStartForLocation:(NSUInteger)location;
- (NSUInteger)locationOfStartOfLineForLocation:(NSUInteger)location;
- (NSUInteger)locationOfLocationInLine:(NSUInteger)location;

@end
