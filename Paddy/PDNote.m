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

- (NSSet *)allReminders
{
    NSMutableSet *remindersToDestroy = [[NSMutableSet alloc] init];
    NSMutableSet *set = self.reminders.mutableCopy;
    
    for (PDReminder *reminder in self.reminders.allObjects) {
        if (reminder.notificationHasExpired) {
            [remindersToDestroy addObject:reminder];
        }
    }
    
    for (PDReminder *reminder in remindersToDestroy) {
        [set removeObject:reminder];
        self.reminders = set;
        [reminder MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    
    return self.reminders;
}

- (void)addRemindersObject:(PDReminder *)value
{
    self.reminders = [self.reminders setByAddingObject:value];
    value.note = self;
}

- (void)createReminderForNoteWithDate:(NSDate *)date {
    BOOL conflict = true;
    int identifier = 0;
    
    while (conflict == true) {
        identifier = arc4random();
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"localNotificationIdentifier == %ld", identifier];
        
        NSArray *objectsWithSameIdentifier = [PDReminder MR_findAllWithPredicate:predicate];
        
        if (objectsWithSameIdentifier.count == 0)
            conflict = false;
    }
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.fireDate = date;
    notification.alertBody = self.title;
    notification.userInfo = @{@"Key":[NSString stringWithFormat:@"%d",identifier]};
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    PDReminder *reminder = [PDReminder MR_createEntity];
    
    reminder.localNotificationIdentifier = [NSNumber numberWithInt:identifier];
    
    NSLog(@"%@ & %d",reminder.localNotificationIdentifier,identifier);
    //    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [self addRemindersObject:reminder];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)removeRemindersObject:(PDReminder *)value
{
    NSString *identifier = [NSString stringWithFormat:@"%@", value.localNotificationIdentifier]; // need or cant find.
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userInfo.Key == %@", identifier];
    NSArray *notificationArray = [[[UIApplication sharedApplication] scheduledLocalNotifications] filteredArrayUsingPredicate:predicate];
    
    if (notificationArray.count > 0) {
        UILocalNotification *notification = [notificationArray objectAtIndex:0];
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
    
    NSMutableSet *set = self.reminders.mutableCopy;
    [set removeObject:value];
    self.reminders = set;
    [value MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}



- (void)addReminders:(NSSet *)values
{
    
}

- (void)removeReminders:(NSSet *)values
{
    
}

@end
