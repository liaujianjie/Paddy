//
//  NotesManager.m
//  Paddy
//
//  Created by Jian Jie on 22/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "NotesManager.h"

@implementation NotesManager

@synthesize interfaceRefreshDelegate;

+ (NotesManager *)sharedNotesManager
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
//        [MagicalRecord setupCoreDataStack];
        [MagicalRecord setupAutoMigratingCoreDataStack];
        [[NSManagedObjectContext MR_defaultContext] setUndoManager:[[NSUndoManager alloc] init]];
    }
    return self;
}

#pragma mark - Note Setters

- (PDNote *)createNoteWithContent:(NSString *)content andTitle:(NSString *)title
{
    PDNote *note = [PDNote MR_createEntity];
    note.createdDate = [NSDate date];
    note.lastModifiedDate = [NSDate date];
    note.content = content;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
//    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
//        PDNote *localNote = [PDNote MR_createEntityInContext:localContext];
//        localNote.title = title;
//        localNote.content = content;
//        localNote.lastModifiedDate = [NSDate date];
//        [localContext MR_saveToPersistentStoreAndWait];
//        
//    } completion:^(BOOL success, NSError *error) {
//        [self.interfaceRefreshDelegate shouldRefreshInterfaceForNotes];
//    }];
    
    return note;
}

- (PDNote *)createBlankNote
{
    return [self createNoteWithContent:@"" andTitle:@""];
}

- (void)updateNote:(PDNote *)note withContent:(NSString *)content andTitle:(NSString *)title
{
//    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
//        PDNote *localNote = [note MR_inContext:localContext];
//        localNote.title = title;
//        localNote.content = content;
//        localNote.lastModifiedDate = [NSDate date];
//        [localContext MR_saveToPersistentStoreAndWait];
//        
//    } completion:^(BOOL success, NSError *error) {
//        [self.interfaceRefreshDelegate shouldRefreshInterfaceForNotes];
//    }];
    note.title = title;
    note.content = content;
    note.lastModifiedDate = [NSDate date];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)deleteNote:(PDNote *)note asynchronously:(BOOL)asynchronously
{
    if (asynchronously)
    {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            PDNote *localNote = [note MR_inContext:localContext];
            [localNote MR_deleteEntity];
            [localContext MR_saveToPersistentStoreAndWait];
            
        } completion:^(BOOL success, NSError *error) {
            [self.interfaceRefreshDelegate shouldRefreshInterfaceForNotes];
        }];
    }
    else
    {
        [note MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}

- (void)togglePinNote:(PDNote *)note {
    BOOL pinned = note.pinned.boolValue;
    
    if (pinned) {
        note.pinned = [NSNumber numberWithBool:false];
    }
    else
        note.pinned = [NSNumber numberWithBool:true];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

#pragma mark Notes Getters

- (NSArray *)allNotes {
    NSArray *notesSorted = [PDNote MR_findAllSortedBy:[self _sortByStringFromType:NotesManagerSortingByDefault]
                                            ascending:[self _optionBoolFromType:NotesManagerSortingOptionDescending]];
    return notesSorted;
}

- (NSArray *)notesFromSearchTerm:(NSString *)searchTerm {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title CONTAINS[c] %@) OR (content CONTAINS[c] %@)", searchTerm, searchTerm];
    NSArray *notesSorted = [PDNote MR_findAllSortedBy:[self _sortByStringFromType:NotesManagerSortingByDefault]
                                            ascending:[self _optionBoolFromType:NotesManagerSortingOptionDescending]
                                        withPredicate:predicate];
    return notesSorted;
}

- (NSUInteger)allNotesCount {
    NSUInteger count = [PDNote MR_countOfEntities];
    return count;
}

- (NSUInteger)notesCountFromSearchTerm:(NSString *)searchTerm
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title CONTAINS[c] %@) OR (content CONTAINS[c] %@)", searchTerm, searchTerm];
    NSUInteger count = [PDNote MR_countOfEntitiesWithPredicate:predicate];
    return count;
}

- (void)exit {
    [MagicalRecord cleanUp];
}

#pragma mark - Private Helpers

- (NSString *)_sortByStringFromType:(NotesManagerSortingBy)type
{
    static NSString *defaultSortBy = @"createdDate";
    
    if (type == NotesManagerSortingByDefault || type == NotesManagerSortingByCreatedDate)
        return defaultSortBy;
    else if (type == NotesManagerSortingByLastModifiedDate)
        return @"lastModifiedDate";
    else if (type == NotesManagerSortingByTitle)
        return @"title";
    else if (type == NotesManagerSortingByContent)
        return @"content";
    else if (type == NotesManagerSortingByReminder)
        return @"createdDate";
    return defaultSortBy;
}

- (BOOL)_optionBoolFromType:(NotesManagerSortingOption)type
{
    static BOOL defaultOption = NO;
    
    if (type == NotesManagerSortingOptionDefault || type == NotesManagerSortingOptionDescending)
        return defaultOption;
    else if (type == NotesManagerSortingOptionAscending)
        return YES;
    return defaultOption;
}

@end
