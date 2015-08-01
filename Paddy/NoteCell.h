//
//  NoteCell.h
//  Paddy
//
//  Created by Jian Jie on 23/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "MCSwipeTableViewCell.h"
#import "PDNote.h"
#import "DateTools.h"
#import "UIColor+HexRGB.h"
#import "NotesManager.h"
#import "TSMarkdownParser.h"
#import "TSMarkdownParser+paddyDefaults.h"

@protocol NoteCellDelegate;

@interface NoteCell : MCSwipeTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, weak) id<NoteCellDelegate> swipeGestureDelegate;
@property (nonatomic, strong) PDNote *note;
@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) NSTimer *timeLabelRefreshTimer;

@end

@protocol NoteCellDelegate <NSObject>

@required

- (void)swipedToDeleteNoteAtCell:(NoteCell *)cell;
- (void)swipedToCreateReminder:(NoteCell *)cell;

@end