//
//  TestVC.m
//  Paddy
//
//  Created by Wallace Toh on 2/8/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "TestVC.h"

@interface TestVC () {
//    NSMutableArray *array;
}

@end

@implementation TestVC

@synthesize note;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSArray *)remindersArray {
    return note.allReminders.allObjects;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressCreate:(id)sender {
    NSDate *unformatted = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm";
    NSString *formattedString = [dateFormatter stringFromDate:unformatted];
    NSDate *formattedDate = [dateFormatter dateFromString:formattedString];
    [[NotesManager sharedNotesManager] createReminderForNote:note withDate:formattedDate];
    [self.tableView reloadData];
}

- (IBAction)pressBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderCell"];

    PDReminder *reminder = [[self remindersArray] objectAtIndex:indexPath.row];
    
    cell.identifierLabel.text = [NSString stringWithFormat:@"%@", reminder.localNotificationIdentifier];
    
    NSString *identifier = [NSString stringWithFormat:@"%@", reminder.localNotificationIdentifier];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userInfo.Key == %@", identifier];
    NSArray *notificationArray = [[[UIApplication sharedApplication] scheduledLocalNotifications] filteredArrayUsingPredicate:predicate];
    
    if (notificationArray.count > 0) {
        UILocalNotification *notification = [notificationArray objectAtIndex:0];
        
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        f.dateFormat = @"dd/MM/yyyy HH:mm";
        NSString *date = [f stringFromDate:notification.fireDate];
        cell.dateLabel.text = date;
    } else {
        cell.dateLabel.text = @"Notification expired";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PDReminder *reminder = [[self remindersArray] objectAtIndex:indexPath.row];
        [reminder.note removeRemindersObject:reminder];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return note.allReminders.count;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [self.tableView reloadData];
        
        for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy])
        {
            NSLog(@"%@", [notification.userInfo objectForKey:@"Key"]);
        }
        NSLog(@"%lu", (unsigned long)note.reminders.count);
    }
}

@end
