//
//  PDReminder.h
//  
//
//  Created by Jian Jie on 1/8/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PDNote;

@interface PDReminder : NSManagedObject

@property (nonatomic, retain) NSNumber * localNotificationIdentifier;
@property (nonatomic, retain) PDNote *note;

@end
