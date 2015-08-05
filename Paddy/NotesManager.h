//
//  NotesManager.h
//  Paddy
//
//  Created by Jian Jie on 22/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>
#import "PDNote.h"
#import "PDReminder.h"

typedef NS_ENUM(NSUInteger, NotesManagerSortingBy)
{
    NotesManagerSortingByDefault = 0,
    NotesManagerSortingByCreatedDate,
    NotesManagerSortingByLastModifiedDate,
    NotesManagerSortingByTitle,
    NotesManagerSortingByContent,
    NotesManagerSortingByReminder,
    NotesManagerSortingByPinned
};

typedef NS_ENUM(NSUInteger, NotesManagerSortingOption)
{
    NotesManagerSortingOptionDefault = 0,
    NotesManagerSortingOptionAscending,
    NotesManagerSortingOptionDescending
};

@protocol NotesManagerRefreshDelegate;

@interface NotesManager : NSObject

@property (nonatomic, strong) NSUndoManager *undoManager;
@property (nonatomic, weak) id<NotesManagerRefreshDelegate> interfaceRefreshDelegate;

+ (NotesManager *)sharedNotesManager;

- (NSArray *)allNotes;
- (NSArray *)notesFromSearchTerm:(NSString *)searchTerm;
- (NSUInteger)allNotesCount;
- (NSUInteger)notesCountFromSearchTerm:(NSString *)searchTerm;

- (PDNote *)createNoteWithContent:(NSString *)content andTitle:(NSString *)title;
- (PDNote *)createBlankNote;
- (void)updateNote:(PDNote *)note withContent:(NSString *)content andTitle:(NSString *)title;
- (void)deleteNote:(PDNote *)note asynchronously:(BOOL)asynchronously;
- (void)togglePinNote:(PDNote *)note;

- (void)exit;

@end

@protocol NotesManagerRefreshDelegate <NSObject>

@required

- (void)shouldRefreshInterfaceForNotes;

@end
