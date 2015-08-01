//
//  PDNote.h
//  Paddy
//
//  Created by Jian Jie on 1/8/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PDReminder;

@interface PDNote : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * lastModifiedDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * pinned;
@property (nonatomic, retain) NSSet *reminders;
@end

@interface PDNote (CoreDataGeneratedAccessors)

- (void)addRemindersObject:(PDReminder *)value;
- (void)removeRemindersObject:(PDReminder *)value;
- (void)addReminders:(NSSet *)values;
- (void)removeReminders:(NSSet *)values;

@end
