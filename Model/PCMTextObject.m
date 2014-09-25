//
//  PCMTextObject.m
//  PDFCreator
//
//  Created by Jinyou Gu on 13-1-22.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//
#import <CoreText/CoreText.h>
#import "PCMTextObject.h"
@implementation PCMText
@synthesize range = _range;
@synthesize themeRef = _themeRef;
@synthesize font = _font;
@synthesize graphStyleString = _graphStyleString;
@synthesize textColor=_textColor;
@synthesize underlineStyle=_underlineStyle;
@synthesize backColor=_backColor;
- (id)initWithDictionary:(NSDictionary *)attrs range:(NSRange)range{
    self = [super init];
    if (self) {
        _range = range;
        _font = [[attrs objectForKey:NSFontAttributeName] copy];
        _textColor = [[attrs objectForKey:NSForegroundColorAttributeName] copy];
        _backColor = [[attrs objectForKey:NSBackgroundColorAttributeName] copy];
        _underlineStyle = [[attrs objectForKey:NSUnderlineStyleAttributeName] integerValue];
        NSParagraphStyle *paragraphStyle = [attrs objectForKey:NSParagraphStyleAttributeName];
        _graphStyleString = [[NSString stringWithFormat:@"%d,%f,%f,%f,%f,%f,%f,%f",
                              paragraphStyle.alignment,paragraphStyle.lineSpacing,
                              paragraphStyle.paragraphSpacing,paragraphStyle.maximumLineHeight,
                              paragraphStyle.minimumLineHeight,paragraphStyle.headIndent,
                              paragraphStyle.tailIndent,paragraphStyle.firstLineHeadIndent] retain];
    }
    return self;
}
- (NSParagraphStyle *)paragraphStyle{
    NSArray *arr = [_graphStyleString componentsSeparatedByString:@","];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = [arr[0] integerValue];//对齐方式
    paragraphStyle.lineSpacing = [arr[1] floatValue];//行距
    paragraphStyle.paragraphSpacing = [arr[2] floatValue];//段落间距  在段的未尾（Bottom）加上间隔，这个值为负数。
    paragraphStyle.maximumLineHeight = [arr[3] floatValue];//最大行距
    paragraphStyle.minimumLineHeight = [arr[4] floatValue];//最小行距
    paragraphStyle.headIndent = [arr[5] floatValue];//段头缩进
    paragraphStyle.tailIndent = [arr[6] floatValue];//段尾缩进
    paragraphStyle.firstLineHeadIndent = [arr[7] floatValue];//首行缩进

//    paragraphStyle.lineBreakMode = [arr[8] integerValue];//换行模式
//    paragraphStyle.baseWritingDirection = [arr[9] integerValue];//基本书写方向
//    paragraphStyle.lineHeightMultiple = [arr[10] floatValue];//多行高
//    paragraphStyle.paragraphSpacingBefore = [arr[11] floatValue];//段落前间距 在一个段落的前面加上间隔。TOP  
//    paragraphStyle.hyphenationFactor = [arr[12] floatValue];//连字符？
    return [paragraphStyle autorelease];
}

- (void)dealloc{
    [_textColor release];
    [_themeRef release];
    [_font release];
    [_graphStyleString release];
    [super dealloc];
}
@end
@implementation PCMTextObject
@synthesize text = _text;
@synthesize textRanges = _textRanges;
@synthesize frames=_frames;
@synthesize align = _align;
- (void) dealloc{
    [_text release];
    [_textRanges release];
    [super dealloc];
}
- (id)initWithDataText{
    self = [super initByRandom];
    if (self) {
        _textRanges = [[NSMutableArray alloc] init];
        _text = [@"What is WWDCThe Apple Worldwide Developers Conference (WWDC) is"
                 "the premier technical conference for developers innovating with "
                 "Apple technologies. Over 1,000 Apple engineers will be at Moscone "
                 "West to present advanced coding and development techniques that "
                 "will show you how to enhance the capabilities of your applications "
                 "with the revolutionary technologies in iPhone OS and Mac OS X.5 days."
                 "\n"
                 "1,000 Apple engineers. 5,000 of your peers.Over 5,000 of the world’s "
                 "best and brightest Apple developers come together for the week-long "
                 "Apple Worldwide Developers Conference at Moscone West, in San Francisco, "
                 "California. This technical event provides you the opportunity to hear "
                 "about the latest advancements in iPhone OS and Mac OS X through practical "
                 "examples that you can apply directly to your app development.The hands-on "
                 "labs at WWDC are where you can work one-to-one with Apple engineers to try "
                 "out new concepts, get answers to questions that are important to you, and "
                 "bring your ideas to life." retain];
        UIColor *textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        UIColor *backCOlor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        PCMText *text = [[[PCMText alloc] init] autorelease];
        text.range = (NSRange){0,12};
        text.font = [UIFont fontWithName:@"Helvetica-Bold" size:49];
        text.textColor = textColor;
        text.backColor = backCOlor;
        text.graphStyleString = @"0,0.0,10,0.0,31,0.0,0.0,0.0";
        [_textRanges addObject:text];
        
        text = [[[PCMText alloc] init] autorelease];
        text.range = (NSRange){12,1};
        text.font = [UIFont fontWithName:@"Helvetica" size:22];
        text.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        text.backColor = backCOlor;
        text.graphStyleString = @"1,0.0,10,0.0,31,0.0,0.0,0.0";
        [_textRanges addObject:text];
        
        text = [[[PCMText alloc] init] autorelease];
        text.range = (NSRange){13,376};
        text.font = [UIFont fontWithName:@"Helvetica" size:22];
        text.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        text.backColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
        text.graphStyleString = @"2,0.0,28,0.0,22,0.0,0.0,0.0";
        [_textRanges addObject:text];
        
        text = [[[PCMText alloc] init] autorelease];
        text.range = (NSRange){389,51};
        text.font = [UIFont fontWithName:@"Helvetica-Bold" size:28];
        text.textColor = textColor;
        text.backColor = backCOlor;
        text.graphStyleString = @"3,0.0,14,0.0,21,0.0,0.0,0.0";
        [_textRanges addObject:text];
        
        text = [[[PCMText alloc] init] autorelease];
        text.range = (NSRange){440,1};
        text.font = [UIFont fontWithName:@"Helvetica" size:22];
        text.textColor = textColor;
        text.backColor = backCOlor;
        text.graphStyleString = @"4,0.0,14,0.0,21,0.0,0.0,0.0";
        [_textRanges addObject:text];
        
        text = [[[PCMText alloc] init] autorelease];
        text.range = (NSRange){441,555};
        text.font = [UIFont fontWithName:@"Helvetica" size:28];
        text.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        text.backColor = backCOlor;
        text.graphStyleString = @"4,0.0,18,0.0,21,0.0,0.0,0.0";
        [_textRanges addObject:text];
    }
    return self;
}
- (id)initByRandom{
    self = [super initByRandom];
    if (self) {
        _textRanges = [[NSMutableArray alloc] init];
        _text = [[NSString alloc] init];
    }
    return self;
}
- (id)initWithAttributedString:(NSAttributedString *)attributedString{
    self = [super initByRandom];
    if (self) {
        
    }
    return self;
}

- (NSMutableAttributedString *)attributedString{
	NSAttributedString* strBase = [[[NSAttributedString alloc] initWithString:_text] autorelease];
	NSMutableAttributedString* str = [[[NSMutableAttributedString alloc] init] autorelease];
	[str setAttributedString:strBase];
    for (PCMText *textrange in _textRanges) {
        NSRange range = textrange.range;
        NSDictionary *dict = @{NSFontAttributeName:textrange.font,
                               NSParagraphStyleAttributeName:textrange.paragraphStyle,
                               NSForegroundColorAttributeName:textrange.textColor,
                               NSBackgroundColorAttributeName:textrange.backColor,
                               NSUnderlineStyleAttributeName:@(textrange.underlineStyle)};
        [str addAttributes:dict range:range];
    }
	return str;
}
@end
