//
//  TSMarkdownParser+paddyDefaults.m
//  Paddy
//
//  Created by Jian Jie on 2/8/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "TSMarkdownParser+paddyDefaults.h"

#define kNormalFontSize 17.0

@implementation TSMarkdownParser (paddyDefaults)

+ (TSMarkdownParser *)paddyDefaultParser
{
    TSMarkdownParser *parser = [TSMarkdownParser standardParser];
    parser.paragraphFont = [UIFont fontWithName:@"HelveticaNeue-light" size:17.0];
    parser.strongFont = [UIFont fontWithName:@"HelveticaNeue-medium" size:17.0];
    parser.emphasisFont = [UIFont fontWithName:@"HelveticaNeue-lightitalic" size:17.0];
    parser.h1Font = [UIFont fontWithName:@"HelveticaNeue-medium" size:29.0];
    parser.h2Font = [UIFont fontWithName:@"HelveticaNeue-medium" size:27.0];
    parser.h3Font = [UIFont fontWithName:@"HelveticaNeue-medium" size:25.0];
    parser.h4Font = [UIFont fontWithName:@"HelveticaNeue-medium" size:23.0];
    parser.h5Font = [UIFont fontWithName:@"HelveticaNeue-medium" size:21.0];
    parser.h6Font = [UIFont fontWithName:@"HelveticaNeue-medium" size:19.0];
    parser.monospaceFont = [UIFont fontWithName:@"Courier" size:17.0];
    //    parser.monospaceTextColor = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
    //    parser.linkColor = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
    //    parser.linkUnderlineStyle = @3;
    
//    [parser addStrongEmParsingWithFormattingBlock:^(NSMutableAttributedString *attributedString, NSRange range) {
//        [attributedString addAttribute:NSFontAttributeName
//                                 value:[UIFont fontWithName:@"HelveticaNeue-mediumitalic" size:17.0]
//                                 range:range];
//    }];
    
    return parser;
}

#pragma mark - Fonts

- (UIFont *)fontForNormal
{
    UIFontDescriptor *descriptor = [UIFontDescriptor fontDescriptorWithName:@"HelveticaNeue-light" size:kNormalFontSize];
    descriptor = [descriptor fontDescriptorWithSymbolicTraits:0];
    UIFont *font = [UIFont fontWithDescriptor:descriptor size:kNormalFontSize];
    return font;
}

- (UIFont *)fontForBold
{
    UIFontDescriptor *descriptor = [UIFontDescriptor fontDescriptorWithName:@"HelveticaNeue-medium" size:kNormalFontSize];
    descriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    UIFont *font = [UIFont fontWithDescriptor:descriptor size:kNormalFontSize];
    return font;
}

- (UIFont *)fontForItalic
{
    UIFontDescriptor *descriptor = [UIFontDescriptor fontDescriptorWithName:@"HelveticaNeue-italic" size:kNormalFontSize];
    descriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
    UIFont *font = [UIFont fontWithDescriptor:descriptor size:kNormalFontSize];
    return font;
}

- (UIFont *)fontForBoldItalic
{
    UIFontDescriptor *descriptor = [UIFontDescriptor fontDescriptorWithName:@"HelveticaNeue-mediumitalic" size:kNormalFontSize];
    descriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold|UIFontDescriptorTraitItalic];
    UIFont *font = [UIFont fontWithDescriptor:descriptor size:kNormalFontSize];
    return font;
}

- (UIFont *)fontForMonospace
{
    UIFontDescriptor *descriptor = [UIFontDescriptor fontDescriptorWithName:@"Courier" size:kNormalFontSize];
    descriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitMonoSpace];
    UIFont *font = [UIFont fontWithDescriptor:descriptor size:kNormalFontSize];
    return font;
}

#pragma mark - Markdown Additions

static NSString *const TSMarkdownStrongEmRegex = @"(?<=[^\\*_]|^)(\\*|_)[^\\*_]+[^\\*_\\n]+(\\*|_)(?=[^\\*_]+[^\\*_\\n]+(\\*|_)(?=[^\\*_]|$)";

- (void)addStrongEmParsingWithFormattingBlock:(void(^)(NSMutableAttributedString *attributedString, NSRange range))formattingBlock {
    NSRegularExpression *boldParsing = [NSRegularExpression regularExpressionWithPattern:TSMarkdownStrongEmRegex options:NSRegularExpressionCaseInsensitive error:nil];
    
    [self addParsingRuleWithRegularExpression:boldParsing withBlock:^(NSTextCheckingResult *match, NSMutableAttributedString *attributedString) {
        
        formattingBlock(attributedString, match.range);
        
        [attributedString deleteCharactersInRange:NSMakeRange(match.range.location, 2)];
        [attributedString deleteCharactersInRange:NSMakeRange(match.range.location+match.range.length-4, 2)];
        
    }];
}

@end
