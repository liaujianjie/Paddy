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

@protocol NoteCellDelegate;

@interface NoteCell : MCSwipeTableViewCell

@property (nonatomic, weak) id<NoteCellDelegate> deleteDelegate;
@property (nonatomic, retain) PDNote *note;
@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) NSTimer *timeLabelRefreshTimer;

@end

@protocol NoteCellDelegate <NSObject>

@required

- (void)swipedToDeleteNoteAtCell:(NoteCell *)cell;

@end