//
//  NoteCell.m
//  Paddy
//
//  Created by Jian Jie on 23/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "NoteCell.h"
#define kBackgroundColour [UIColor colorWithHexNum:0xFBFBFB alpha:1.0]

@implementation NoteCell

@synthesize swipeGestureDelegate;
@synthesize note;
@synthesize searchTerm;

#pragma mark - Setup Helpers

//- (void)setupStyle
//{
//    self.backgroundColor = kBackgroundColour;
//    self.contentView.backgroundColor = kBackgroundColour;
//    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
//    self.titleLabel.textColor = [UIColor colorWithHexNum:0x535353 alpha:1.0];
//    self.timeStampLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
//    self.timeStampLabel.textColor = [UIColor colorWithHexNum:0x535353 alpha:0.35];
//    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//}

- (void)setupContentTextView
{
    self.contentTextView.contentInset = UIEdgeInsetsZero;
    self.contentTextView.textContainerInset = UIEdgeInsetsZero;
    self.contentTextView.textContainer.lineFragmentPadding = 0;
}

- (void)setupSwipeGesture
{
    //    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    UIColor *yellowColor = [UIColor colorWithRed:254.0 / 255.0 green:217.0 / 255.0 blue:56.0 / 255.0 alpha:1.0];
    //    UIColor *brownColor = [UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
    
    [self setDefaultColor:[UIColor colorWithHexNum:0xF0F0F0 alpha:1.0]];
    
    [self setSwipeGestureWithView:[self cellReminderView]
                            color:yellowColor
                             mode:MCSwipeTableViewCellModeSwitch
                            state:MCSwipeTableViewCellState3
                  completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
//                      [self.swipeGestureDelegate swipedToCreateReminder:self];
                  }];
    [self setSwipeGestureWithView:[self cellDeleteView]
                            color:redColor
                             mode:MCSwipeTableViewCellModeExit
                            state:MCSwipeTableViewCellState4
                  completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                      [self.swipeGestureDelegate swipedToDeleteNoteAtCell:self];
                  }];
}

#pragma mark Helper Helpers

- (UIView *)cellDeleteView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_delete.png"]];
    [imageView setFrame:CGRectMake(0.0, 0.0, 24.0, 24.0)];
    
    return imageView;
}

- (UIView *)cellReminderView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_clock.png"]];
    [imageView setFrame:CGRectMake(0.0, 0.0, 24.0, 24.0)];
    
    return imageView;
}

#pragma mark - Overrides

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    
//    [self setupStyle];
//    [self setupSwipeGesture];
//    
//    return self;
//}

- (instancetype)init
{
    self = [[NSBundle mainBundle] loadNibNamed:@"NoteCell" owner:self options:nil][0];
    self.contentTextView.hidden = YES;
    
    [self setupContentTextView];
    [self setupSwipeGesture];
    
    return self;
}

- (void)setNote:(PDNote *)newNote
{
    self->note = newNote;
    
    if (newNote.title.length != 0)
        self.titleLabel.text = newNote.title;
    else if (newNote.content.length != 0)
        self.titleLabel.text = [[TSMarkdownParser paddyDefaultParser] attributedStringFromMarkdown:newNote.content].string;
    else
    {
        self.titleLabel.text = @"Empty note";
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:16.0];
        self.titleLabel.textColor = [UIColor colorWithHexNum:0x535353 alpha:0.5];
    }
//    self.timeStampLabel.text = newNote.lastModifiedDate.shortTimeAgoSinceNow;
    
    NSTimeInterval timeSinceDate = -[self.note.createdDate timeIntervalSinceNow];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (timeSinceDate > 60*60*24)
        [formatter setDateFormat:@"d MMM yyyy"];
    else
        [formatter setDateFormat:@"h:m"];
    self.timeStampLabel.text = [formatter stringFromDate:newNote.createdDate];
}

- (void)setSearchTerm:(NSString *)newSearchTerm
{
    self->searchTerm = newSearchTerm;
    
    if (!searchTerm || searchTerm.length == 0)
    {
        self.contentTextView.hidden = YES;
        self.contentTextViewVerticalSpacingConstraint.constant = 0.0;
    }
    else
    {
        NSAttributedString *attributedString = [[TSMarkdownParser paddyDefaultParser] attributedStringFromMarkdown:self.note.content];
        NSString *rawString = attributedString.string;
        self.contentTextView.hidden = NO;
        self.contentTextView.text = rawString;
//        self.contentTextView.font = [UIFont fontWithName:@"HelveticaNeue-light" size:14.0];
//        self.contentTextView.text enu
        NSError *error;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:newSearchTerm
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        if (!error)
        {
            NSRange entireRange = NSMakeRange(0, rawString.length);
            NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:rawString];
            [mutableAttributedString addAttribute:NSFontAttributeName
                                            value:[UIFont fontWithName:@"HelveticaNeue-light" size:14.0]
                                            range:entireRange];
            [mutableAttributedString addAttribute:NSForegroundColorAttributeName
                                            value:[UIColor colorWithHexNum:0x535353
                                                                     alpha:1.0]
                                            range:entireRange];
            __block NSRange firstLocation = NSMakeRange(0, 0);
            [regex enumerateMatchesInString:rawString
                                    options:0
                                      range:entireRange
                                 usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                     [mutableAttributedString addAttribute:NSBackgroundColorAttributeName
                                                                     value:[UIColor colorWithHexNum:0xfee98d alpha:1.0]
                                                                     range:result.range];
                                     if (firstLocation.length == 0)
                                         firstLocation = result.range;
                                 }];
            
            self.contentTextView.attributedText = mutableAttributedString;
            [self.contentTextView scrollRangeToVisible:firstLocation];
//            if (self.contentTextView.contentOffset.y == 0)
//                [self.contentTextView setContentOffset:CGPointMake(0.0,
//                                                                   self.contentTextView.contentOffset.y+4.0)];
//            NSLog(@"%f",self.contentTextView.font.lineHeight);
        }
        self.contentTextViewVerticalSpacingConstraint.constant = 4.0;
    }
}

+ (CGFloat)heightForCellWithSearchTerm:(NSString *)searchTerm
{
    return 12.0*2 + 19.0 + 4.0 + 16.52*3.0 + 2.0;
}

@end
