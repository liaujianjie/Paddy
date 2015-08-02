//
//  NotesListViewController.m
//  Paddy
//
//  Created by Jian Jie on 22/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "NotesListViewController.h"

#define kNotesCellIdentifier @"NotesCell"


//#fee98d
@interface NotesListViewController ()

@end

@implementation NotesListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NotesManager sharedNotesManager].interfaceRefreshDelegate = self;
    
    self.title = @"Notes";
    [self.notesListTableView registerClass:[NoteCell class] forCellReuseIdentifier:kNotesCellIdentifier];
    [self.notesListTableView registerNib:[UINib nibWithNibName:@"NoteCell" bundle:[NSBundle mainBundle]]
                  forCellReuseIdentifier:kNotesCellIdentifier];

    [self.searchBar setBackgroundColor:[UIColor clearColor]];
    [self.searchBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexNum:0xFBFBFB alpha:0.04]]
                        forBarPosition:UIBarPositionAny
                            barMetrics:UIBarMetricsDefault];
    
    UITextField *searchTextField = [self.searchBar valueForKey:@"_searchField"];
    [searchTextField setBackgroundColor:[UIColor whiteColor]];
    [searchTextField setBorderStyle:UITextBorderStyleRoundedRect];
    searchTextField.layer.borderWidth = 1.0f;
    searchTextField.layer.cornerRadius = 5.0f;
    searchTextField.layer.borderColor = [UIColor colorWithHexNum:0xF0F0F0 alpha:1.0].CGColor;
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-light" size:14.0];
    searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.searchBar.placeholder attributes:@{NSFontAttributeName:font}];
    searchTextField.font = font;
    
    self.undoToasterVerticalPositionContraint.constant = -50;
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.notesListTableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoToExistingNote"])
    {
        NoteViewController *destination = (NoteViewController *)segue.destinationViewController;
        destination.note = ((NoteCell *)sender).note;
    }
    else if ([segue.identifier isEqualToString:@"GoToNewNote"])
    {
        NoteViewController *destination = (NoteViewController *)segue.destinationViewController;
        destination.note = [[NotesManager sharedNotesManager] createBlankNote];
        destination.shouldBringUpKeyboard = YES;
    }
}

#pragma mark - NotesManager Delegate

- (void)shouldRefreshInterfaceForNotes
{
//    NSLog(@"shouldRefreshInterfaceForNotes");
    [self.notesListTableView reloadData];
}

#pragma mark - UITableView Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDNote *note = [self notesFromSearch][indexPath.row];
    
    NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:kNotesCellIdentifier];
//    cell = [[NoteCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kNotesCellIdentifier];
    cell = [[NoteCell alloc] init];
    cell.note = note;
    cell.searchTerm = self.searchBar.text;
    cell.swipeGestureDelegate = self;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.searchBar.text || self.searchBar.text.length == 0)
        return [NotesManager sharedNotesManager].allNotesCount;
    return [[NotesManager sharedNotesManager] notesCountFromSearchTerm:self.searchBar.text];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // search with one line: 68
    if (!self.searchBar.text || self.searchBar.text.length == 0)
        return 44.0;
    return [NoteCell heightForCellWithSearchTerm:self.searchBar.text];
}

- (NSArray *)notesFromSearch
{
    if (!self.searchBar.text || self.searchBar.text.length == 0)
        return [NotesManager sharedNotesManager].allNotes;
    return [[NotesManager sharedNotesManager] notesFromSearchTerm:self.searchBar.text];
}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"GoToExistingNote" sender:(NoteCell *)[tableView cellForRowAtIndexPath:indexPath]];
}

- (IBAction)pressedNewNote:(id)sender {
    [self performSegueWithIdentifier:@"GoToNewNote" sender:sender];
}

- (void)swipedToCreateReminder:(NoteCell *)cell
{
    [self performSegueWithIdentifier:@"PopReminderDatePicker" sender:self];
}

- (void)swipedToDeleteNoteAtCell:(NoteCell *)cell
{
    [self.notesListTableView beginUpdates];
    [[NotesManager sharedNotesManager] deleteNote:cell.note asynchronously:NO];
    [self.notesListTableView deleteRowsAtIndexPaths:@[[self.notesListTableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.notesListTableView endUpdates];
}

#pragma mark - UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.notesListTableView reloadData];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
    
    const CGFloat requiredOffsetForNewNote = 150.0;
    if (scrollView == self.notesListTableView)
    {
        UIView *buttonView = [self.addNoteButton valueForKey:@"view"];
//        UIImageView *buttonImageView = [buttonView valueForKey:@"_imageView"];
        
        if (scrollView.contentOffset.y < -requiredOffsetForNewNote)
            [self performSegueWithIdentifier:@"GoToNewNote" sender:scrollView];
        
        if (scrollView.contentOffset.y < 0)
        {
            CGFloat scaleAmount = 1.0 + (-scrollView.contentOffset.y)/requiredOffsetForNewNote * 0.5;
            buttonView.transform = CGAffineTransformMakeScale(scaleAmount, scaleAmount);
        }
        else
            buttonView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }
}
    
@end
