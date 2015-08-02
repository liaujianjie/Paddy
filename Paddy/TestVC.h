//
//  TestVC.h
//  Paddy
//
//  Created by Wallace Toh on 2/8/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDNote.h"
#import <MagicalRecord/MagicalRecord.h>
#import "ReminderCell.h"
#import "NotesManager.h"
#import "PDReminder.h"

@interface TestVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) PDNote *note;
@property (nonatomic, retain) PDReminder *reminder;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
