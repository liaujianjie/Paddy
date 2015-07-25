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

@interface NoteViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) PDNote *note;
@property (nonatomic) bool shouldBringUpKeyboard;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerVerticalPositionConstraint;

- (IBAction)presssedDismiss:(id)sender;

@end
