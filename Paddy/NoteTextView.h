//
//  NoteTextView.h
//  Paddy
//
//  Created by Jian Jie on 31/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+locationHelpers.h"
#import "TSMarkdownParser.h"
#import "TSMarkdownParser+paddyDefaults.h"

@interface NoteTextView : UITextView

@property (nonatomic, strong) TSMarkdownParser *parser;
@property (nonatomic, strong) NSString *markdown;

@end
