//
//  TSMarkdownParser+paddyDefaults.m
//  Paddy
//
//  Created by Jian Jie on 2/8/15.
//  Copyright (c) 2015 Liau Jian Jie. All rights reserved.
//

#import "TSMarkdownParser+paddyDefaults.h"

@implementation TSMarkdownParser (paddyDefaults)

+ (TSMarkdownParser *)paddyDefaultParser
{
    TSMarkdownParser *parser = [TSMarkdownParser standardParser];
    parser.paragraphFont = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
    parser.strongFont = [UIFont fontWithName:@"HelveticaNeue-bold" size:17.0];
    parser.emphasisFont = [UIFont fontWithName:@"HelveticaNeue-italic" size:17.0];
    parser.h1Font = [UIFont fontWithName:@"HelveticaNeue-bold" size:29.0];
    parser.h2Font = [UIFont fontWithName:@"HelveticaNeue-bold" size:27.0];
    parser.h3Font = [UIFont fontWithName:@"HelveticaNeue-bold" size:25.0];
    parser.h4Font = [UIFont fontWithName:@"HelveticaNeue-bold" size:23.0];
    parser.h5Font = [UIFont fontWithName:@"HelveticaNeue-bold" size:21.0];
    parser.h6Font = [UIFont fontWithName:@"HelveticaNeue-bold" size:19.0];
    parser.monospaceFont = [UIFont fontWithName:@"Courier" size:17.0];
    //    parser.monospaceTextColor = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
    //    parser.linkColor = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
    //    parser.linkUnderlineStyle = @3;
    return parser;
}

@end
