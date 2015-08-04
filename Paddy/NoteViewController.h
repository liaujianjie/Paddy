//
//  NoteViewController.h
//  Paddy
//
//  Created by Jian Jie on 23/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDNote.h"
#import "NotesManager.h"
#import "DateTools.h"
#import "UITextView+selectionHelpers.h"
#import "BABFrameObservingInputAccessoryView.h"
#import "NoteTextView.h"

typedef NS_ENUM(NSUInteger, NotesViewAlert)
{
    NotesViewAlertForEmptyNoteDismissal = 0,
    NotesViewAlertForDeleteConfirmation
};

@interface NoteViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) PDNote *note;
@property (nonatomic) bool shouldBringUpKeyboard;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet NoteTextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerVerticalPositionConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarBottomSpacingConstraint;

- (IBAction)pressedDismiss:(id)sender;
- (IBAction)pressedDeleteNote:(id)sender;

@property (weak, nonatomic) IBOutlet UIToolbar *editorToolbar;
@property (weak, nonatomic) IBOutlet UIButton *bulletedListButton;
@property (weak, nonatomic) IBOutlet UIButton *numberedListButton;
@property (weak, nonatomic) IBOutlet UIButton *boldButton;
@property (weak, nonatomic) IBOutlet UIButton *italicButton;
@property (weak, nonatomic) IBOutlet UIButton *underlineButton;

- (IBAction)pressedBulletedList:(id)sender;
- (IBAction)pressedNumberedList:(id)sender;
- (IBAction)pressedBold:(id)sender;
- (IBAction)pressedItalic:(id)sender;
- (IBAction)pressedUnderline:(id)sender;

@end
