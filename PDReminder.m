//
//  PDReminder.m
//  Paddy
//
//  Created by Jian Jie on 23/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "PDReminder.h"
#import "PDNote.h"


@implementation PDReminder

@dynamic date;
@dynamic note;

+ (NSString *)MR_entityName {
    return @"Reminder";
}

@end
