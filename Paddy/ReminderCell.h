//
//  ReminderCell.h
//  Paddy
//
//  Created by Wallace Toh on 2/8/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *identifierLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
