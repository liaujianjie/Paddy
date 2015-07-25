//
//  PDReminder.h
//  Paddy
//
//  Created by Jian Jie on 23/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PDNote;

@interface PDReminder : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) PDNote *note;

@end
