//
//  NotesListViewController.h
//  Paddy
//
//  Created by Jian Jie on 22/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NSIndexPath+displayableString.h"
#import "UIImage+imageWithColor.h"
#import "NotesManager.h"
#import "NoteCell.h"
#import "NoteViewController.h"
#import "TestVC.h"

@interface NotesListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate, NoteCellDelegate, NotesManagerRefreshDelegate>

@property (weak, nonatomic) IBOutlet UITableView *notesListTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addNoteButton;
@property (nonatomic) IBOutlet NSLayoutConstraint *undoToasterVerticalPositionContraint;

- (IBAction)pressedNewNote:(id)sender;

@end