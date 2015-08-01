//
//  PDNote.m
//  Paddy
//
//  Created by Jian Jie on 1/8/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "PDNote.h"
#import "PDReminder.h"


@implementation PDNote

@dynamic content;
@dynamic createdDate;
@dynamic lastModifiedDate;
@dynamic title;
@dynamic pinned;
@dynamic reminders;

+ (NSString *)MR_entityName {
    return @"Note";
}

@end
