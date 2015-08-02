//
//  PDReminder.h
//  Paddy
//
//  Created by Wallace Toh on 2/8/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@class PDNote;

@interface PDReminder : NSManagedObject

@property (nonatomic, retain) NSNumber * localNotificationIdentifier;
@property (nonatomic, retain) PDNote *note;

- (UILocalNotification *)localNotification;
- (BOOL)notificationHasExpired;

@end
