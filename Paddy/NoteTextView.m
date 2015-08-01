//
//  NoteTextView.m
//  Paddy
//
//  Created by Jian Jie on 31/7/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "NoteTextView.h"

#define kSampleText @"Headings\n# H1\n## H2\n### H3\n#### H4\n##### H5\n###### H5\n\nLists\n* item\n+ Item\n\nEmphasis\n*Em*\n_Em_\n**Strong**\n__Strong__\n`code`\n\nURL\n[Link text](http://www.link.com)\n\nImages\n![Alternative text](image.png)"

@implementation NoteTextView

@synthesize markdown;

- (instancetype)init
{
    self = [super init];
    [self setup];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setup];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    self = [super initWithFrame:frame textContainer:textContainer];
    [self setup];
    return self;
}

- (void)setup
{
    [self setupParser];
    [self registerTextChangeNotification];
}

- (void)setupParser
{
    self.parser = [TSMarkdownParser paddyDefaultParser];
}

- (void)registerTextChangeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
}


/*
 * when markdown changes (due to first load), change attributedString accordingly
 * when attributedString changes (due to user edit), change markdown accordingly (without triggering the setter method)
 */

- (void)textDidChange
{
    TSMarkdownParser *parser = self.parser;
    
//    NSAttributedString *string = [parser attributedStringFromMarkdown:kSampleText];
//    self.attributedText = string;
    
//    NSArray *stringsToEscape = @[@"#",@"*",@"+",@"_"];
    NSArray *stringsToEscape = @[@"#",@"*"];
    NSDictionary *wrappingDictionary = @{@"**":parser.strongFont, @"*":parser.emphasisFont, @"`":parser.monospaceFont};
    NSDictionary *beginningDictionary = @{@"######":parser.h6Font,
                                          @"#####": parser.h5Font,
                                          @"####":  parser.h4Font,
                                          @"###":   parser.h3Font,
                                          @"##":    parser.h2Font,
                                          @"#":     parser.h1Font};
    NSString *bulletString = @"\u2022\t";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSRange range = NSMakeRange(0, attributedString.length);
    
    for (NSString *escapeString in stringsToEscape)
        [attributedString.mutableString replaceOccurrencesOfString:escapeString
                                                        withString:[NSString stringWithFormat:@"\\%@",escapeString]
                                                           options:NSCaseInsensitiveSearch|NSBackwardsSearch
                                                             range:range];
    [attributedString enumerateAttributesInRange:range
                                         options:NSAttributedStringEnumerationReverse
                                      usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                                          if (attrs[NSFontAttributeName])
                                          {
                                              UIFont *font = attrs[NSFontAttributeName];
                                              for (NSString *stringToInsert in wrappingDictionary.allKeys)
                                              {
                                                  UIFont *dictFont = wrappingDictionary[stringToInsert];
                                                  if (font == dictFont)
                                                  {
                                                      [attributedString.mutableString insertString:stringToInsert atIndex:range.location+range.length];
                                                      [attributedString.mutableString insertString:stringToInsert atIndex:range.location];
                                                      break;
                                                  }
                                              }
                                              
                                              NSUInteger locationOfStartOfLine = [attributedString.string locationOfStartOfLineForLocation:range.location];
                                              for (NSString *stringToInsert in beginningDictionary.allKeys)
                                              {
                                                  UIFont *dictFont = beginningDictionary[stringToInsert];
                                                  if (font == dictFont)
                                                  {
                                                      [attributedString.mutableString insertString:stringToInsert atIndex:locationOfStartOfLine];
                                                      break;
                                                  }
                                              }
                                          }
                                      }];
    
    NSArray *splitString = [attributedString.string componentsSeparatedByString:@"\n"];
    NSMutableArray *newSplitString = [[NSMutableArray alloc] init];
    for (__strong NSString *string in splitString)
    {
        if (string.length >= 2)
            [newSplitString addObject:[string stringByReplacingOccurrencesOfString:bulletString
                                                                        withString:@"*"
                                                                           options:0
                                                                             range:NSMakeRange(0, bulletString.length)]];
    }
    
    self->markdown = [newSplitString componentsJoinedByString:@"\n"];
    
//    NSLog(@"%@",self.markdown);
}

- (void)setMarkdown:(NSString *)newMarkdown
{
    self->markdown = newMarkdown;
    self.attributedText = [self.parser attributedStringFromMarkdown:newMarkdown];
}

@end
