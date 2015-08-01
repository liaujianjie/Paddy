//
//  PDReminder.m
//  
//
//  Created by Jian Jie on 1/8/15.
//
//

#import "PDReminder.h"
#import "PDNote.h"


@implementation PDReminder

@dynamic localNotificationIdentifier;
@dynamic note;

+ (NSString *)MR_entityName {
    return @"Reminder";
}

@end
