//
//  NoteViewController.m
//  Paddy
//
//  Created by Jian Jie on 23/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController ()

@end

@implementation NoteViewController

@synthesize note;
@synthesize shouldBringUpKeyboard;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    self.contentTextView.alwaysBounceVertical = YES;
    
    self.titleTextField.text = note.title;
    self.contentTextView.text = note.content;
    
    if (shouldBringUpKeyboard)
        [self.titleTextField becomeFirstResponder];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.contentTextView  setTextContainerInset:UIEdgeInsetsMake(10, 10, 10, 10)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (![self.contentTextView.text isEqualToString:note.content])
        [[NotesManager sharedNotesManager] updateNote:self.note withContent:self.contentTextView.text andTitle:self.titleTextField.text];
    else if (![self.titleTextField.text isEqualToString:note.title])
        [[NotesManager sharedNotesManager] updateNote:self.note withContent:self.contentTextView.text andTitle:self.titleTextField.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)presssedDismiss:(id)sender {
    if (self.titleTextField.text.length == 0 && self.contentTextView.text.length == 0)
        [self promptToDeleteEmptyNoteAndDismissViewController];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateTimeAgoLabel
{
    //last edited 1 minute ago – 25/5/2015 11:13 am
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.titleTextField)
        [self.contentTextView becomeFirstResponder];
    return NO;
}

#pragma mark UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.contentTextView)
    {
        if (scrollView.contentOffset.y < -100.0)
            [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Empty Note Deletion

- (void)promptToDeleteEmptyNoteAndDismissViewController
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Delete empty note"
                                                        message:@"This note is empty, do you wish to delete it?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
        [self dismissViewControllerAnimated:YES completion:^{
            [[NotesManager sharedNotesManager] deleteNote:self.note asynchronously:YES];
        }];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

@end
