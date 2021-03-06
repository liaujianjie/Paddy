//
//  NoteViewController.m
//  Paddy
//
//  Created by Jian Jie on 23/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "NoteViewController.h"

#define kSecondsToWaitBeforeSave 5.0

@interface NoteViewController ()
{
    NSTimer *saveTimer;
}

@end

@implementation NoteViewController

@synthesize note;
@synthesize shouldBringUpKeyboard;

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self setupTextviewForKeyboardNotifications];
    
    self.contentTextView.alwaysBounceVertical = YES;
    self.contentTextView.allowsEditingTextAttributes = YES;
    self.contentTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    self.titleTextField.text = note.title;
    self.contentTextView.markdown = note.content;
    
    if (shouldBringUpKeyboard)
        [self.titleTextField becomeFirstResponder];
    
    [self updateTimeAgoLabel];
    NSTimer *timeStampTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimeAgoLabel) userInfo:nil repeats:YES];
    [timeStampTimer fire];
    
    [self updateEditingButtonsForTextAttributes];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.contentTextView  setTextContainerInset:UIEdgeInsetsMake(5, 10, 10, 10)];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.titleTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
    
    [self saveNote];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTextviewForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
        id _obj = [notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect _keyboardFrame = CGRectNull;
        if ([_obj respondsToSelector:@selector(getValue:)]) [_obj getValue:&_keyboardFrame];
            [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.toolbarBottomSpacingConstraint.constant = _keyboardFrame.size.height;
                [self.view layoutIfNeeded];
            } completion:nil];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
        [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.toolbarBottomSpacingConstraint.constant = 0.0;
            [self.view layoutIfNeeded];
        } completion:nil];
    }];
}

//- (void)setupInputAccessoryViewInteractiveKeyboardDismissal
//{
//    BABFrameObservingInputAccessoryView *inputView = [[BABFrameObservingInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//    inputView.userInteractionEnabled = NO;
//    
//    self.contentTextView.inputAccessoryView = inputView;
//    
//    __weak typeof(self)weakSelf = self;
//    
//    inputView.inputAcessoryViewFrameChangedBlock = ^(CGRect frame){
//        
//        CGFloat value = CGRectGetHeight(weakSelf.view.frame) - CGRectGetMinY(weakSelf.textField.inputAccessoryView.superview.frame) - CGRectGetHeight(weakSelf.textField.inputAccessoryView.frame);
//        
//        weakSelf.toolbarContainerVerticalSpacingConstraint.constant = MAX(0, value);
//        
//        [weakSelf.view layoutIfNeeded];
//        
//    };
//}

- (void)updateTimeAgoLabel
{
    NSString *timeAgo = self.note.lastModifiedDate.timeAgoSinceNow;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@" d/M/yyyy h:m"];
    NSString *dateString = [formatter stringFromDate:self.note.lastModifiedDate];
    
    NSString *newString = [NSString stringWithFormat:@"last modified %@ – %@", timeAgo.lowercaseString, dateString];
    if (self.timeStampLabel.text.length == 0 || ![self.timeStampLabel.text isEqualToString:newString])
        self.timeStampLabel.text = newString;
}

- (void)updateEditingButtonsForTextAttributes
{
    if (!self.contentTextView.isFirstResponder || !self.contentTextView.attributedText || self.contentTextView.attributedText.length == 0)
        return;
    
//    NSRange selectedRange = self.contentTextView.selectedRange;

    NSDictionary *attributes;
//    if (selectedRange.length == 0)
        attributes = [self.contentTextView typingAttributes];
//    else
//        attributes = [self.contentTextView.attributedText attributesAtIndex:selectedRange.location effectiveRange:&selectedRange];
    
    if (!attributes)
        return;
    
    BOOL isBold = NO, isItalic = NO, isUnderlined = NO;
    
    UIFont *font = attributes[@"NSFont"];
    if (font)
    {
        isBold = [font.fontName containsString:@"Bold"];
        isItalic = [font.fontName containsString:@"Italic"];
    }
    
    NSNumber *underline = attributes[@"NSUnderline"];
    if (underline)
        isUnderlined = underline.boolValue;
    
    if (isBold)
        [self.boldButton setImage:[UIImage imageNamed:@"editing-bold-active.png"] forState:UIControlStateNormal];
    else
        [self.boldButton setImage:[UIImage imageNamed:@"editing-bold-muted.png"] forState:UIControlStateNormal];
    if (isItalic)
        [self.italicButton setImage:[UIImage imageNamed:@"editing-italic-active.png"] forState:UIControlStateNormal];
    else
        [self.italicButton setImage:[UIImage imageNamed:@"editing-italic-muted.png"] forState:UIControlStateNormal];
    if (isUnderlined)
        [self.underlineButton setImage:[UIImage imageNamed:@"editing-underline-active.png"] forState:UIControlStateNormal];
    else
        [self.underlineButton setImage:[UIImage imageNamed:@"editing-underline-muted.png"] forState:UIControlStateNormal];
}

- (void)saveNote
{
    if (![self.contentTextView.markdown isEqualToString:note.content])
        [[NotesManager sharedNotesManager] updateNote:self.note withContent:self.contentTextView.markdown andTitle:self.titleTextField.text];
    else if (![self.titleTextField.text isEqualToString:note.title])
        [[NotesManager sharedNotesManager] updateNote:self.note withContent:self.contentTextView.markdown andTitle:self.titleTextField.text];
}

#pragma mark - View Button Handlers

- (IBAction)pressedDismiss:(id)sender {
    if (self.titleTextField.text.length == 0 && self.contentTextView.text.length == 0)
        [self promptToDeleteEmptyNoteAndDismissViewController];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressedDeleteNote:(id)sender {
    [self promptToConfirmDelete];
}

#pragma mark Editing Button Handlers

// TODO: make tab indents slightly larger (accomodate 2 digits and 1 period)
// TODO: make tab indents for bullets indent entire paragraph (http://stackoverflow.com/questions/6644501/objective-c-nsattributedstring-inserting-a-bullet-point)

- (IBAction)pressedBulletedList:(id)sender {
    if (!self.contentTextView.isFirstResponder)
        return;
    
    NSArray *splitStrings = [self.contentTextView.text componentsSeparatedByString:@"\n"];
    NSUInteger lineOfSelection = [self.contentTextView lineOfStartOfSelection];
    NSUInteger locationOfSelection = [self.contentTextView locationOfStartOfSelectionInLine];
    NSString *stringInLine = (NSString *)(splitStrings[lineOfSelection]);
    
    if (stringInLine.length > 0 && locationOfSelection == stringInLine.length)
        [self.contentTextView insertText:@"\n\u2022 "];
    else
        [self.contentTextView insertText:@"\u2022 "];
    
    [self updateEditingButtonsForTextAttributes];
}

- (IBAction)pressedNumberedList:(id)sender {
    if (!self.contentTextView.isFirstResponder)
        return;
    
    NSString *stringToInsert = @"";
    NSInteger numberForBullet;
    
    NSArray *splitStrings = [self.contentTextView.text componentsSeparatedByString:@"\n"];
    NSUInteger lineOfSelection = [self.contentTextView lineOfStartOfSelection];
    NSUInteger locationOfSelection = [self.contentTextView locationOfStartOfSelectionInLine];
    NSString *stringInLine = (NSString *)(splitStrings[lineOfSelection]);
    
    BOOL pressedWhenAtEndOfLine = (locationOfSelection == stringInLine.length);
    
    if (lineOfSelection == 0)
    {
        if (!pressedWhenAtEndOfLine || !((NSString *)splitStrings[0]) || ((NSString *)splitStrings[0]).length == 0)
            numberForBullet = 1;
        else
        {
            NSArray *furtherSplitStrings = [splitStrings[0] componentsSeparatedByString:@"."];
            NSScanner *scan = [NSScanner scannerWithString:furtherSplitStrings[0]];
            NSInteger scannedInteger;
            [scan scanInteger:&scannedInteger];
            
            if ([scan isAtEnd])
                numberForBullet = scannedInteger+1;
        }
    }
    else
    {
        NSString *string;
        if (pressedWhenAtEndOfLine && stringInLine.length > 0)
            string = splitStrings[lineOfSelection];
        else
            string = splitStrings[lineOfSelection-1];
        NSArray *furtherSplitStrings = [string componentsSeparatedByString:@"."];
        
        NSScanner *scan = [NSScanner scannerWithString:furtherSplitStrings[0]];
        NSInteger scannedInteger;
        [scan scanInteger:&scannedInteger];
        if (!((NSString *)furtherSplitStrings[0]) || ((NSString *)furtherSplitStrings[0]).length == 0)
            numberForBullet = 1;
        else if ([scan isAtEnd])
            numberForBullet = scannedInteger+1;
        else
            numberForBullet = 1;
    }
    
    if (stringInLine.length > 0 && pressedWhenAtEndOfLine)
        stringToInsert = [@"\n" stringByAppendingString:stringToInsert];
    
    stringToInsert = [stringToInsert stringByAppendingString:[NSString stringWithFormat:@"%ld. ", (long)numberForBullet]];
    
    [self.contentTextView insertText:stringToInsert];
}

- (IBAction)pressedBold:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(toggleBoldface:) to:nil from:self forEvent:nil];
    [self updateEditingButtonsForTextAttributes];
}

- (IBAction)pressedItalic:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(toggleItalics:) to:nil from:self forEvent:nil];
    [self updateEditingButtonsForTextAttributes];
}

- (IBAction)pressedUnderline:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(toggleUnderline:) to:nil from:self forEvent:nil];
    [self updateEditingButtonsForTextAttributes];
}

#pragma mark Editing Button State Helpers

- (void)toggleBoldface:(id)sender
{
    [super toggleBoldface:sender];
    NSLog(@"textViewFormatting options: %@", [self.contentTextView typingAttributes]);
}

- (void)toggleItalics:(id)sender
{
    [super toggleItalics:sender];
}

- (void)toggleUnderline:(id)sender
{
    [super toggleUnderline:sender];
}


#pragma mark - UITextField Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateEditingButtonsForTextAttributes];
    
    if (saveTimer)
        [saveTimer invalidate];
    saveTimer = [NSTimer scheduledTimerWithTimeInterval:kSecondsToWaitBeforeSave
                                                 target:self
                                               selector:@selector(saveNote)
                                               userInfo:nil
                                                repeats:NO];
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    [self updateEditingButtonsForTextAttributes];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.titleTextField)
        [self.contentTextView becomeFirstResponder];
    return NO;
}

#pragma mark UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    const CGFloat requiredOffsetForDismissal = 80.0;
    const CGFloat textInsetTop = 10.0;
    
    if (scrollView == self.contentTextView)
    {
        if (scrollView.contentOffset.y < -requiredOffsetForDismissal && scrollView.isDragging)
            [self dismissViewControllerAnimated:YES completion:nil];
        
        if (scrollView.contentOffset.y < 0)
        {
            CGFloat scaleAmount = 1.0 + (-scrollView.contentOffset.y)/requiredOffsetForDismissal * 0.5;
            self.dismissButton.transform = CGAffineTransformMakeScale(scaleAmount, scaleAmount);
        }
        else
            self.dismissButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        if (scrollView.contentOffset.y >= 0)
        {
            CGFloat alpha = (scrollView.contentOffset.y/textInsetTop);
            if (alpha > 1.0)
                alpha = 1.0;
            self.separatorLineView.alpha = alpha;
        }
        else
            self.separatorLineView.alpha = 0.0;
    }
}

#pragma mark - UIAlertView

- (void)promptToDeleteEmptyNoteAndDismissViewController
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete empty note"
                                                        message:@"This note is empty. Do you wish to delete it?"
                                                       delegate:self
                                              cancelButtonTitle:@"No, save it"
                                              otherButtonTitles:@"Delete", nil];
    alertView.tag = NotesViewAlertForEmptyNoteDismissal;
    [alertView show];
}

- (void)promptToConfirmDelete
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete confirmation"
                                                        message:@"Are you sure you want to delete this note?"
                                                       delegate:self
                                              cancelButtonTitle:@"No, save it"
                                              otherButtonTitles:@"Delete", nil];
    alertView.tag = NotesViewAlertForDeleteConfirmation;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == NotesViewAlertForEmptyNoteDismissal)
    {
        if (buttonIndex == 1)
            [[NotesManager sharedNotesManager] deleteNote:self.note asynchronously:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (alertView.tag == NotesViewAlertForDeleteConfirmation)
    {
        if (buttonIndex == 1)
        {
            [[NotesManager sharedNotesManager] deleteNote:self.note asynchronously:NO];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

@end
