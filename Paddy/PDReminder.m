//
//  PDReminder.m
//  Paddy
//
//  Created by Wallace Toh on 2/8/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "PDReminder.h"
#import "PDNote.h"


@implementation PDReminder

@dynamic localNotificationIdentifier;
@dynamic note;

+ (NSString *)MR_entityName {
    return @"Reminder";
}

- (UILocalNotification *)localNotification
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userInfo.Key == %@", self.localNotificationIdentifier.stringValue];
    NSArray *notificationArray = [[[UIApplication sharedApplication] scheduledLocalNotifications] filteredArrayUsingPredicate:predicate];
    if (notificationArray.count == 0) {

        return nil;
    }
    return notificationArray[0];
}

- (BOOL)notificationHasExpired
{
    if (self.localNotification)
        return NO;
    
    return YES;
}

@end
