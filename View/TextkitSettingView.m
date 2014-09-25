//
//  TextkitSettingView.m
//  TextKitDemo
//
//  Created by Jinyou Gu on 13-7-1.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//

#import "TextkitSettingView.h"
@interface NSMutableParagraphStyle(initWithParagraphStyle)
- (id) initWithParagraphStyle:(NSParagraphStyle *)paragraphStyle;
@end
@implementation NSMutableParagraphStyle(initWithParagraphStyle)

- (id) initWithParagraphStyle:(NSParagraphStyle *)paragraphStyle{
    self = [super init];
    if (self) {
        self.alignment = paragraphStyle.alignment;
        self.lineBreakMode = paragraphStyle.lineBreakMode;
        self.baseWritingDirection = paragraphStyle.baseWritingDirection;
        self.lineSpacing = paragraphStyle.lineSpacing;
        self.paragraphSpacing = paragraphStyle.paragraphSpacing;
        self.paragraphSpacingBefore = paragraphStyle.paragraphSpacingBefore;
        self.maximumLineHeight = paragraphStyle.maximumLineHeight;
        self.minimumLineHeight = paragraphStyle.minimumLineHeight;
        self.headIndent = paragraphStyle.headIndent;
        self.tailIndent = paragraphStyle.tailIndent;
        self.firstLineHeadIndent = paragraphStyle.firstLineHeadIndent;
        self.hyphenationFactor = paragraphStyle.hyphenationFactor;
        self.lineHeightMultiple = paragraphStyle.lineHeightMultiple;
    }
    return self;
}

@end
#define isEqualFloat(f1, f2) ((f1 - f2 < 0.000001) && (f1 - f2 > -0.000001))
#define kFontArray @[@"AmericanTypewriter",@"AmericanTypewriter-Bold",\
                    @"ArialMT",@"Arial-BoldMT",@"Arial-ItalicMT",@"Arial-BoldItalicMT",\
                    @"Courier",@"Courier-Bold",@"Courier-Oblique",@"Courier-BoldOblique",\
                    @"Helvetica",@"Helvetica-Bold",@"Helvetica-Oblique",@"Helvetica-BoldOblique",\
                    @"MarkerFelt-Thin",\
                    @"Verdana",@"Verdana-Bold",@"Verdana-Italic", @"Verdana-BoldItalic",\
                    @"Noteworthy-Light",@"Noteworthy-Bold",\
                    @"Thonburi",@"Thonburi-Bold",@"TrebuchetMS-Italic",@"Trebuchet-BoldItalic",\
                    @"TrebuchetMS",@"TrebuchetMS-Bold",@"TrebuchetMS-Italic", @"Trebuchet-BoldItalic"]

#define kFontnameAttributeName @"fontnameAttributeName"
#define kPointsizeAttributedName @"pointsizeAttributeName"
#define kShadowOffsizeWidthName @"shadowoffsizeWidthName"
#define kShadowOffsizeHeightName @"shadowoffsizeHeightName"
#define kShadowColorAttributename @"shadowColorName"
#define kShadowRadiusAttributeName @"shadowRadiusName"
#define kParagraphLineSpacing @"ParagraphLineSpacing"
#define kParagraphParagraphSpacing @"ParagraphParagraphSpacing"
#define kParagraphAlignment @"ParagraphAlignment"
#define kParagraphFirstLineHeadIndent @"ParagraphFirstLineHeadIndent"
#define kParagraphHeadIndent @"ParagraphHeadIndent"
#define kParagraphTailIndent @"ParagraphTailIndent"
#define kParagraphLineBreakMode @"ParagraphLineBreakMode"
#define kParagraphMinimumLineHeight @"ParagraphMinimumLineHeight"
#define kParagraphMaximumLineHeight @"ParagraphMaximumLineHeight"
#define kParagraphBaseWritingDirection @"ParagraphBaseWritingDirection"
#define kParagraphLineHeightMultiple @"ParagraphLineHeightMultiple"
#define kParagraphParagraphSpacingBefore @"ParagraphParagraphSpacingBefore"
#define kParagraphHyphenationFactor @"ParagraphHyphenationFactor"
//3、StrokeWidth笔锋宽度、颜色；
//4、Strkethrough样式、颜色(0~9)；
//5、Underline样式、颜色(0~9)；
//6、Background颜色；
@interface TextkitSettingView(){
    NSMutableAttributedString *_m_attributedString;
    NSRange _selectRange;
    NSMutableDictionary *_dictionary;
}
@property(nonatomic, copy) UIFont *font;
@property(nonatomic, retain) NSShadow *shadow;
@property(nonatomic, retain) NSMutableParagraphStyle *paragraphStyle;
@property(nonatomic, assign) NSInteger selectIndex;
- (void)dataInit:(NSArray *)attrsArray;
- (void)callback:(id)object Key:(NSString *)key isParagraph:(BOOL)isParagraph;
@end
@implementation TextkitSettingView
@synthesize font=_font;
@synthesize shadow=_shadow;
@synthesize paragraphStyle=_paragraphStyle;
@synthesize selectIndex=_selectIndex;
@synthesize delegate=_delegate;
- (id)initWithXib{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TextkitSettingView" owner:self options:nil];
    self = [[array objectAtIndex:0] retain];
    if (self) {
        _fontTableView.dataSource = self;
        _fontTableView.delegate = self;
        _shadow = [[NSShadow alloc] init];
        self.paragraphStyle = [[[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
        NSArray *views = @[_fontColorView,_hightlightView,_strokeColorView,_shadowCOlorView,_underlineColorView,_strikeColorView];
        for(int i=0; i<6; i++){
            PCImagePickerSlider *colorPicker = [[PCImagePickerSlider alloc] initWithColor:[UIImage imageNamed:@"colorimage.png"]
                                                               slider:[UIImage imageNamed:@"button_colorselect.png"]];
            colorPicker.frame = CGRectMake(0, 0, 337, 24);
            colorPicker.delegate = self;
            colorPicker.tag = 100+i;
            [views[i] addSubview:colorPicker];
            ((UIView *)views[i]).backgroundColor = [UIColor clearColor];
        }
        _textParagh.selectedSegmentIndex = 0;
        _contentScrollView.contentSize = _textView.bounds.size;
        [_contentScrollView addSubview:_textView];
    }
    return self;
}
- (void)dealloc {
    [_m_attributedString release];
    [_paragraphStyle release];
    [_font release];
    [_shadow release];
    [_fontTableView release];
    [_ligatureTextField release];
    [_strikethroughTextField release];
    [_shadowSizeWidth release];
    [_shadowSizeHeight release];
    [_shadowRadius release];
    [_strokeWidth release];
    [_obliqueness release];
    [_expanssion release];
    [_writingdirection release];
    [_texteffect release];
    [_attachment release];
    [_link release];
    [_baseline release];
    [_verticalGlyph release];
    [_underlineStyle release];
    [_fontColorView release];
    [_hightlightView release];
    [_strokeColorView release];
    [_shadowCOlorView release];
    [_underlineColorView release];
    [_strikeColorView release];
    [_alignmentSegment release];
    [_linebreakmode release];
    [_basewritedirection release];
    [_linespace release];
    [_paragraphSpacing release];
    [_paragraphSpacingBefore release];
    [_maxLineHeight release];
    [_minLineHeight release];
    [_headIndent release];
    [_tailIndent release];
    [_firstLineHeadIndent release];
    [_lineHeightMultiple release];
    [_glyphSpacing release];
    [_contentScrollView release];
    [_textParagh release];
    [_textView release];
    [_paraghView release];
    [_fontsize release];
    [_documentView release];
    [_hyphenation release];
    [super dealloc];
}


- (IBAction)OnChageTextOrParagraph:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
        {
            [_documentView removeFromSuperview];
            [_paraghView removeFromSuperview];
            [_contentScrollView addSubview:_textView];
            _contentScrollView.contentSize = _textView.bounds.size;
        }
            break;
        case 1:
        {
            [_documentView removeFromSuperview];
            [_textView removeFromSuperview];
            [_contentScrollView addSubview:_paraghView];
            _contentScrollView.contentSize = _paraghView.bounds.size;
        }
            break;
        case 2:
        {
            [_textView removeFromSuperview];
            [_paraghView removeFromSuperview];
            [_contentScrollView addSubview:_documentView];
            _contentScrollView.contentSize = _documentView.bounds.size;
        }
            break;
        default:
            break;
    }
}
- (void)attributeString:(NSAttributedString *)attributeStr Select:(NSRange)range Attribute:(NSDictionary *)attribute{
    if (_m_attributedString) {
        [_m_attributedString release];
    }
    if (_dictionary) {
        [_dictionary release];
    }
    _m_attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributeStr];
    _selectRange = range;
    NSMutableArray *attrsArray = [[[NSMutableArray alloc] init] autorelease];
    if (_selectRange.length>0) {
        [_m_attributedString enumerateAttributesInRange:range
                                                options:NSAttributedStringEnumerationReverse
                                             usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                                                 [attrsArray addObject:attrs];
                                             }];
        [self dataInit:attrsArray];
    }else{
        [self setDictionary:[NSMutableDictionary dictionaryWithDictionary:attribute]];
    }

}

- (void)callback:(id)object Key:(NSString *)key isParagraph:(BOOL)isParagraph{
    if (_selectRange.length>0) {
        [_m_attributedString enumerateAttributesInRange:_selectRange
                                                options:NSAttributedStringEnumerationReverse
                                             usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                                                 NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:attrs];
                                                 NSParagraphStyle *paragraph = [dict valueForKey:NSParagraphStyleAttributeName];
                                                 NSMutableParagraphStyle *m_paragraph = [[[NSMutableParagraphStyle alloc] initWithParagraphStyle:[NSParagraphStyle defaultParagraphStyle]] autorelease];
                                                 if (paragraph) {
                                                     m_paragraph = [[[NSMutableParagraphStyle alloc] initWithParagraphStyle:paragraph] autorelease];
                                                 }
                                                 if ([key isEqualToString:kFontnameAttributeName]) {
                                                     UIFont *font = [dict valueForKey:NSFontAttributeName];
                                                     NSString *fontname = object;
                                                     UIFont *saveFont = [UIFont fontWithName:fontname size:font.pointSize];
                                                     [dict setValue:saveFont forKey:NSFontAttributeName];
                                                 }else if ([key isEqualToString:kPointsizeAttributedName]){
                                                     CGFloat pointsize = [object floatValue];
                                                     UIFont *font = [dict valueForKey:NSFontAttributeName];
                                                     UIFont *saveFont = [UIFont fontWithName:font.fontName size:pointsize];
                                                     [dict setValue:saveFont forKey:NSFontAttributeName];
                                                 }else if ([key isEqualToString:kShadowOffsizeWidthName]){
                                                     NSShadow *shadow = [dict valueForKey:NSShadowAttributeName];
                                                     if (!shadow) {
                                                         shadow = [[[NSShadow alloc] init] autorelease];
                                                     }
                                                     shadow.shadowOffset = CGSizeMake([object floatValue], shadow.shadowOffset.height);
                                                     [dict setValue:shadow forKey:NSShadowAttributeName];
                                                 }else if ([key isEqualToString:kShadowOffsizeHeightName]){
                                                     NSShadow *shadow = [dict valueForKey:NSShadowAttributeName];
                                                     if (!shadow) {
                                                         shadow = [[[NSShadow alloc] init] autorelease];
                                                     }
                                                     shadow.shadowOffset = CGSizeMake(shadow.shadowOffset.width, [object floatValue]);
                                                     [dict setValue:shadow forKey:NSShadowAttributeName];
                                                 }else if ([key isEqualToString:kShadowColorAttributename]){
                                                     NSShadow *shadow = [dict valueForKey:NSShadowAttributeName];
                                                     if (!shadow) {
                                                         shadow = [[[NSShadow alloc] init] autorelease];
                                                     }
                                                     shadow.shadowColor = object;
                                                     [dict setValue:shadow forKey:NSShadowAttributeName];
                                                 }else if ([key isEqualToString:kShadowRadiusAttributeName]){
                                                     NSShadow *shadow = [dict valueForKey:NSShadowAttributeName];
                                                     if (!shadow) {
                                                         shadow = [[[NSShadow alloc] init] autorelease];
                                                     }
                                                     shadow.shadowBlurRadius = [object floatValue];
                                                     [dict setValue:shadow forKey:NSShadowAttributeName];
                                                 }else if ([key isEqualToString:kParagraphLineSpacing]){
                                                     m_paragraph.lineSpacing = [object floatValue];
                                                     [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
                                                 }else if ([key isEqualToString:kParagraphParagraphSpacing]){
                                                     m_paragraph.paragraphSpacing = [object floatValue];
                                                     [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
                                                 }else if ([key isEqualToString:kParagraphAlignment]){
                                                     m_paragraph.alignment = [object integerValue];
                                                     [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
                                                 }else if ([key isEqualToString:kParagraphFirstLineHeadIndent]){
                                                     m_paragraph.firstLineHeadIndent = [object floatValue];
                                                     [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
                                                 }else if ([key isEqualToString:kParagraphHeadIndent]){
                                                     m_paragraph.headIndent = [object floatValue];
                                                     [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
                                                 }else if ([key isEqualToString:kParagraphTailIndent]){
                                                     m_paragraph.tailIndent = [object floatValue];
                                                     [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
                                                 }else if ([key isEqualToString:kParagraphLineBreakMode]){
                                                     m_paragraph.lineBreakMode = [object integerValue];
                                                     [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
                                                 }else if ([key isEqualToString:kParagraphMinimumLineHeight]){
                                                     m_paragraph.minimumLineHeight = [object floatValue];
                                                     [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
                                                 }else if ([key isEqualToString:kParagraphMaximumLineHeight]){
                                                     m_paragraph.maximumLineHeight = [object floatValue];
                                                     [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
                                                 }else if ([key isEqualToString:kParagraphBaseWritingDirection]){
                                                     m_paragraph.baseWritingDirection = [object integerValue];
                                                     [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
                                                 }else if ([key isEqualToString:kParagraphLineHeightMultiple]){
                                                     m_paragraph.lineHeightMultiple = [object floatValue];
                                                     [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
                                                 }else if ([key isEqualToString:kParagraphParagraphSpacingBefore]){
                                                     m_paragraph.paragraphSpacingBefore = [object floatValue];
                                                     [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
                                                 }else if ([key isEqualToString:kParagraphHyphenationFactor]){
                                                     m_paragraph.hyphenationFactor = [object floatValue];
                                                     [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
                                                 }else{
                                                     if (object) {
                                                         [dict setObject:object forKey:key];
                                                     }else{
                                                         [dict removeObjectForKey:key];
                                                     }
                                                 }
                                                 NSDictionary *dictattrs = [NSDictionary dictionaryWithDictionary:dict];
                                                 [_m_attributedString setAttributes:dictattrs range:range];
                                             }];
        if ([_delegate respondsToSelector:@selector(refresh:AttributeString:)]) {
            NSAttributedString *attributed = [[[NSAttributedString alloc] initWithAttributedString:_m_attributedString] autorelease];
            [_delegate refresh:self AttributeString: attributed];
        }
    }else{
        if (isParagraph && [[_m_attributedString string] length]>0) {
            NSRange effectRange = NSMakeRange(0, 0);
            NSInteger index = _selectRange.location;
            index = MIN(index, [[_m_attributedString string] length]-1);
            NSDictionary *dict1 = [_m_attributedString attributesAtIndex:index effectiveRange:&effectRange];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dict1];
            NSParagraphStyle *paragraph = [dict valueForKey:NSParagraphStyleAttributeName];
            NSMutableParagraphStyle *m_paragraph = [[[NSMutableParagraphStyle alloc] initWithParagraphStyle:[NSParagraphStyle defaultParagraphStyle]] autorelease];
            if (paragraph) {
                m_paragraph = [[[NSMutableParagraphStyle alloc] initWithParagraphStyle:paragraph] autorelease];
            }
           if ([key isEqualToString:kParagraphLineSpacing]){
                m_paragraph.lineSpacing = [object floatValue];
                [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
            }else if ([key isEqualToString:kParagraphParagraphSpacing]){
                m_paragraph.paragraphSpacing = [object floatValue];
                [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
            }else if ([key isEqualToString:kParagraphAlignment]){
                m_paragraph.alignment = [object integerValue];
                [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
            }else if ([key isEqualToString:kParagraphFirstLineHeadIndent]){
                m_paragraph.firstLineHeadIndent = [object floatValue];
                [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
            }else if ([key isEqualToString:kParagraphHeadIndent]){
                m_paragraph.headIndent = [object floatValue];
                [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
            }else if ([key isEqualToString:kParagraphTailIndent]){
                m_paragraph.tailIndent = [object floatValue];
                [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
            }else if ([key isEqualToString:kParagraphLineBreakMode]){
                m_paragraph.lineBreakMode = [object integerValue];
                [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
            }else if ([key isEqualToString:kParagraphMinimumLineHeight]){
                m_paragraph.minimumLineHeight = [object floatValue];
                [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
            }else if ([key isEqualToString:kParagraphMaximumLineHeight]){
                m_paragraph.maximumLineHeight = [object floatValue];
                [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
            }else if ([key isEqualToString:kParagraphBaseWritingDirection]){
                m_paragraph.baseWritingDirection = [object integerValue];
                [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
            }else if ([key isEqualToString:kParagraphLineHeightMultiple]){
                m_paragraph.lineHeightMultiple = [object floatValue];
                [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
            }else if ([key isEqualToString:kParagraphParagraphSpacingBefore]){
                m_paragraph.paragraphSpacingBefore = [object floatValue];
                [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
            }else if ([key isEqualToString:kParagraphHyphenationFactor]){
                m_paragraph.hyphenationFactor = [object floatValue];
                [dict setValue:m_paragraph forKey:NSParagraphStyleAttributeName];
            }
            NSDictionary *dictAttr = [NSDictionary dictionaryWithDictionary:dict];
            [_m_attributedString setAttributes:dictAttr range:effectRange];
            if ([_delegate respondsToSelector:@selector(refresh:AttributeString:)]) {
                [_delegate refresh:self AttributeString:_m_attributedString];
            }
            [_dictionary setObject:_paragraphStyle forKey:NSParagraphStyleAttributeName];
        }else{
            if ([key isEqualToString:kFontnameAttributeName]) {
                UIFont *font = [_dictionary valueForKey:NSFontAttributeName];
                NSString *fontname = object;
                UIFont *saveFont = [UIFont fontWithName:fontname size:font.pointSize];
                [_dictionary setValue:saveFont forKey:NSFontAttributeName];
            }else if ([key isEqualToString:kPointsizeAttributedName]){
                CGFloat pointsize = [object floatValue];
                UIFont *font = [_dictionary valueForKey:NSFontAttributeName];
                UIFont *saveFont = [UIFont fontWithName:font.fontName size:pointsize];
                [_dictionary setValue:saveFont forKey:NSFontAttributeName];
            }else if ([key isEqualToString:kShadowOffsizeWidthName]){
                NSShadow *shadow = [_dictionary valueForKey:NSShadowAttributeName];
                if (!shadow) {
                    shadow = [[[NSShadow alloc] init] autorelease];
                }
                shadow.shadowOffset = CGSizeMake([object floatValue], shadow.shadowOffset.height);
                [_dictionary setValue:shadow forKey:NSShadowAttributeName];
            }else if ([key isEqualToString:kShadowOffsizeHeightName]){
                NSShadow *shadow = [_dictionary valueForKey:NSShadowAttributeName];
                if (!shadow) {
                    shadow = [[[NSShadow alloc] init] autorelease];
                }
                shadow.shadowOffset = CGSizeMake(shadow.shadowOffset.width, [object floatValue]);
                [_dictionary setValue:shadow forKey:NSShadowAttributeName];
            }else if ([key isEqualToString:kShadowColorAttributename]){
                NSShadow *shadow = [_dictionary valueForKey:NSShadowAttributeName];
                if (!shadow) {
                    shadow = [[[NSShadow alloc] init] autorelease];
                }
                shadow.shadowColor = object;
                [_dictionary setValue:shadow forKey:NSShadowAttributeName];
            }else if ([key isEqualToString:kShadowRadiusAttributeName]){
                NSShadow *shadow = [_dictionary valueForKey:NSShadowAttributeName];
                if (!shadow) {
                    shadow = [[[NSShadow alloc] init] autorelease];
                }
                shadow.shadowBlurRadius = [object floatValue];
                [_dictionary setValue:shadow forKey:NSShadowAttributeName];
            }else{
                if (object) {
                    [_dictionary setObject:object forKey:key];
                }else{
                    [_dictionary removeObjectForKey: key];
                }
            }
        }
        if ([_delegate respondsToSelector:@selector(refresh:Attribute:)]) {
            [_delegate refresh:self Attribute:_dictionary];
        }
    }

}
- (IBAction)onDissmiskeyboard:(id)sender {
    UIView *view = (UIView *)sender;
    for (UIView *v in view.subviews) {
        if ([v isFirstResponder]) {
            [v resignFirstResponder];
        }
    }
}
- (void)setMyParagraphStyle:(NSParagraphStyle *)paragraphStyle{
    _paragraphStyle.alignment = paragraphStyle.alignment;
    _paragraphStyle.lineBreakMode = paragraphStyle.lineBreakMode;
    _paragraphStyle.baseWritingDirection = paragraphStyle.baseWritingDirection;
    _paragraphStyle.lineSpacing = paragraphStyle.lineSpacing;
    _paragraphStyle.paragraphSpacing = paragraphStyle.paragraphSpacing;
    _paragraphStyle.paragraphSpacingBefore = paragraphStyle.paragraphSpacingBefore;
    _paragraphStyle.maximumLineHeight = paragraphStyle.maximumLineHeight;
    _paragraphStyle.minimumLineHeight = paragraphStyle.minimumLineHeight;
    _paragraphStyle.headIndent = paragraphStyle.headIndent;
    _paragraphStyle.tailIndent = paragraphStyle.tailIndent;
    _paragraphStyle.firstLineHeadIndent = paragraphStyle.firstLineHeadIndent;
    _paragraphStyle.hyphenationFactor = paragraphStyle.hyphenationFactor;
    _paragraphStyle.lineHeightMultiple = paragraphStyle.lineHeightMultiple;
    _alignmentSegment.selectedSegmentIndex = _paragraphStyle.alignment;
    _linebreakmode.selectedSegmentIndex = _paragraphStyle.lineBreakMode;
    _basewritedirection.selectedSegmentIndex = _paragraphStyle.baseWritingDirection+1;
    _linespace.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.lineSpacing];
    _paragraphSpacing.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.paragraphSpacing];
    _paragraphSpacingBefore.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.paragraphSpacingBefore];
    _maxLineHeight.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.maximumLineHeight];
    _minLineHeight.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.minimumLineHeight];
    _headIndent.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.headIndent];
    _tailIndent.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.tailIndent];
    _firstLineHeadIndent.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.firstLineHeadIndent];
    _lineHeightMultiple.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.lineHeightMultiple];
    _hyphenation.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.hyphenationFactor];
}
- (void)dataInit:(NSArray *)attrsArray{
    if (attrsArray.count==0) {
        return;
    }
    NSDictionary *dictionary = attrsArray[0];
    NSString *fontName=nil;
    float pointSize=0;
    UIFont *font = [dictionary valueForKey:NSFontAttributeName];
    if (font) {
        fontName = font.fontName;
        pointSize = font.pointSize;
    }
    for (NSDictionary *dictionary in attrsArray) {
        UIFont *d_font1 = [dictionary valueForKey:NSFontAttributeName];
        if (d_font1) {
            if (fontName && (![fontName isEqualToString:d_font1.fontName])) {
                fontName = nil;
            }
            if ((pointSize!=0) && (!isEqualFloat(pointSize, d_font1.pointSize))) {
                pointSize=0;
            }
        }else{
            fontName = nil;
            pointSize = 0;
            break;
        }
    }
    self.selectIndex = [kFontArray indexOfObject:fontName];
    if (pointSize!=0) {
        _fontsize.text = [NSString stringWithFormat:@"%.f",pointSize];
        if (fontName) {
            self.font = [UIFont fontWithName:fontName size:pointSize];
        }
    }
    [_fontTableView reloadData];
    UIColor *foreColor=[dictionary valueForKey:NSForegroundColorAttributeName];
    for (NSDictionary *dictionary in attrsArray) {
        UIColor *d_color = [dictionary valueForKey:NSForegroundColorAttributeName];
        if (d_color) {
            if (foreColor && !CGColorEqualToColor(d_color.CGColor, foreColor.CGColor)) {
                foreColor = nil;
                break;
            }
        }else{
            foreColor = nil;
            break;
        }
    }
    PCImagePickerSlider *colorPicker = (PCImagePickerSlider *)[_fontColorView viewWithTag:100];
    if (foreColor) {
        [colorPicker pointInit:foreColor];
    }else{
        foreColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [colorPicker pointInit:foreColor];
    }
    UIColor *backColor=[dictionary valueForKey:NSBackgroundColorAttributeName];
    for (NSDictionary *dictionary in attrsArray) {
        UIColor *d_bkColor = [dictionary valueForKey:NSBackgroundColorAttributeName];
        if (d_bkColor) {
            if (backColor && !CGColorEqualToColor(d_bkColor.CGColor, backColor.CGColor)) {
                backColor = nil;
                break;
            }
        }else{
            backColor = nil;
            break;
        }
    }
    colorPicker = (PCImagePickerSlider *)[_hightlightView viewWithTag:101];
    if (backColor) {
        [colorPicker pointInit:backColor];
    }else{
        [colorPicker pointNull];
    }
    NSInteger ligature=0;
    NSNumber *d_ligature = [dictionary valueForKey:NSLigatureAttributeName];
    if (d_ligature) {
        ligature = [d_ligature integerValue];
    }
    for (NSDictionary *dictionary in attrsArray) {
        NSNumber *d_ligature = [dictionary valueForKey:NSLigatureAttributeName];
        if (d_ligature) {
            if (ligature!=0 && ligature != [d_ligature integerValue]) {
                ligature = 0;
                break;
            }
        }else{
            ligature=0;
            break;
        }
    }
    if (ligature) {
        NSString *text = [NSString stringWithFormat:@"%d", ligature];
        _ligatureTextField.text = text;
    }
    float kern=0;
    NSNumber *d_kern = [dictionary valueForKey:NSKernAttributeName];
    if (d_kern) {
        kern = [d_kern floatValue];
    }
    for (NSDictionary *dictionary in attrsArray) {
        NSNumber *d_kern = [dictionary valueForKey:NSKernAttributeName];
        if (d_kern) {
            if (kern!=0 && !isEqualFloat(kern, [d_kern floatValue])) {
                kern = 0;
                break;
            }
        }else{
            kern=0;
            break;
        }
    }
    if (kern) {
        NSString *text = [NSString stringWithFormat:@"%.f",kern];
        _obliqueness.text = text;
    }
    NSInteger strikethroughstyle=0;
    NSNumber *d_strikethroughstyle = [dictionary valueForKey:NSStrikethroughStyleAttributeName];
    if (d_strikethroughstyle) {
        strikethroughstyle = [d_strikethroughstyle integerValue];
    }
    for (NSDictionary *dictionary in attrsArray) {
        NSNumber *d_strikethroughstyle = [dictionary valueForKey:NSStrikethroughStyleAttributeName];
        if (d_strikethroughstyle) {
            if (strikethroughstyle!=0 && ([d_strikethroughstyle integerValue]!=strikethroughstyle)) {
                strikethroughstyle = 0;
                break;
            }
        }else{
            strikethroughstyle=0;
            break;
        }
    }
    if (strikethroughstyle) {
        NSString *text = [NSString stringWithFormat:@"%d", strikethroughstyle];
        _strikethroughTextField.text = text;
    }
    NSInteger underlinestyle=0;
    NSNumber *d_underlinestyle = [dictionary valueForKey:NSUnderlineStyleAttributeName];
    if (d_underlinestyle) {
        underlinestyle = [d_underlinestyle integerValue];
    }
    for (NSDictionary *dictionary in attrsArray) {
        NSNumber *d_underlinestyle = [dictionary valueForKey:NSUnderlineStyleAttributeName];
        if (d_underlinestyle) {
            if (underlinestyle!=0 && ([d_underlinestyle integerValue]!=underlinestyle)) {
                underlinestyle = 0;
                break;
            }
        }else{
            underlinestyle=0;
            break;
        }
    }
    if (underlinestyle) {
        NSString *text = [NSString stringWithFormat:@"%d", underlinestyle];
        _underlineStyle.text = text;
    }
    UIColor *strokeColor=[dictionary valueForKey:NSStrokeColorAttributeName];
    for (NSDictionary *dictionary in attrsArray) {
        UIColor *d_strokeColor = [dictionary valueForKey:NSStrokeColorAttributeName];
        if (d_strokeColor) {
            if (strokeColor && !CGColorEqualToColor(d_strokeColor.CGColor, strokeColor.CGColor)) {
                strokeColor = nil;
                break;
            }
        }else{
            strokeColor = nil;
            break;
        }
    }
    colorPicker = (PCImagePickerSlider *)[_strokeColorView viewWithTag:102];
    if (strokeColor) {
        [colorPicker pointInit:strokeColor];
    }else{
        [colorPicker pointNull];
    }
    float strokeWidth=0;
    NSNumber *d_strokeWidth = [dictionary valueForKey:NSStrokeWidthAttributeName];
    if (d_strokeWidth) {
        strokeWidth = [d_strokeWidth floatValue];
    }
    for (NSDictionary *dictionary in attrsArray) {
        NSNumber *d_strokeWidth = [dictionary valueForKey:NSStrokeWidthAttributeName];
        if (d_strokeWidth) {
            if (strokeWidth!=0 && !isEqualFloat([d_strokeWidth floatValue], strokeWidth)) {
                strokeWidth = 0;
                break;
            }
        }else{
            strokeWidth=0;
            break;
        }
    }
    if (strokeWidth!=0) {
        _strokeWidth.text = [NSString stringWithFormat:@"%.f", strokeWidth];
    }
    NSString *textEffect=[dictionary valueForKey:NSTextEffectAttributeName];
    for (NSDictionary *dictionary in attrsArray) {
        NSString *d_textEffect = [dictionary valueForKey:NSTextEffectAttributeName];
        if (!d_textEffect) {
            textEffect = nil;
            break;
        }
    }
    if (textEffect) {
        _texteffect.text = textEffect;
    }
    NSURL *url=[dictionary valueForKey:NSLinkAttributeName];
    for (NSDictionary *dictionary in attrsArray) {
        NSURL *d_url = [dictionary valueForKey:NSLinkAttributeName];
        if (d_url) {
            if (url && ![url.absoluteString isEqualToString:d_url.absoluteString]) {
                url = nil;
                break;
            }
        }else{
            url = nil;
            break;
        }
    }
    if (url) {
        _link.text = url.absoluteString;
    }
    NSInteger baselineoffset=0;
    NSNumber *d_baselineoffset = [dictionary valueForKey:NSBaselineOffsetAttributeName];
    if (d_baselineoffset) {
        baselineoffset = [d_baselineoffset integerValue];
    }
    for (NSDictionary *dictionary in attrsArray) {
        NSNumber *d_baselineoffset = [dictionary valueForKey:NSBaselineOffsetAttributeName];
        if (d_baselineoffset) {
            if (baselineoffset!=0 && baselineoffset!=[d_baselineoffset integerValue]) {
                baselineoffset = 0;
                break;
            }
        }else{
            baselineoffset=0;
            break;
        }
    }
    if (baselineoffset) {
        NSString *text = [NSString stringWithFormat:@"%d",baselineoffset];
        _baseline.text = text;
    }
    NSInteger verticolGlyph=0;
    NSNumber *d_verticolGlyph = [dictionary valueForKey:NSVerticalGlyphFormAttributeName];
    if (d_verticolGlyph) {
        verticolGlyph = [d_verticolGlyph integerValue];
    }
    for (NSDictionary *dictionary in attrsArray) {
        NSNumber *d_verticolGlyph = [dictionary valueForKey:NSVerticalGlyphFormAttributeName];
        if (d_verticolGlyph) {
            if (verticolGlyph!=0 && verticolGlyph!=[d_verticolGlyph integerValue]) {
                verticolGlyph = 0;
                break;
            }
        }else{
            verticolGlyph=0;
            break;
        }
    }
    if (verticolGlyph) {
        NSString *text = [NSString stringWithFormat:@"%d",verticolGlyph];
        _verticalGlyph.text = text;
    }
    UIColor *underlineColor=[dictionary valueForKey:NSUnderlineColorAttributeName];
    for (NSDictionary *dictionary in attrsArray) {
        UIColor *d_underlineColor = [dictionary valueForKey:NSUnderlineColorAttributeName];
        if (d_underlineColor) {
            if (underlineColor && !CGColorEqualToColor(d_underlineColor.CGColor, underlineColor.CGColor)) {
                underlineColor = nil;
                break;
            }
        }else{
            underlineColor = nil;
            break;
        }
    }
    colorPicker = (PCImagePickerSlider *)[_underlineColorView viewWithTag:104];
    if (underlineColor) {
        [colorPicker pointInit:underlineColor];
    }else{
        [colorPicker pointNull];
    }
    UIColor *strikeColor=[dictionary valueForKey:NSStrikethroughColorAttributeName];
    for (NSDictionary *dictionary in attrsArray) {
        UIColor *d_strikeColor = [dictionary valueForKey:NSStrikethroughColorAttributeName];
        if (d_strikeColor) {
            if (strikeColor && !CGColorEqualToColor(d_strikeColor.CGColor, strikeColor.CGColor)) {
                strikeColor = nil;
                break;
            }
        }else{
            strikeColor = nil;
            break;
        }
    }
    colorPicker = (PCImagePickerSlider *)[_strikeColorView viewWithTag:105];
    if (strikeColor) {
        [colorPicker pointInit:strikeColor];
    }else{
        [colorPicker pointNull];
    }
    float obliqueness=0;
    NSNumber *d_obliqueness = [dictionary valueForKey:NSObliquenessAttributeName];
    if (d_obliqueness) {
        obliqueness = [d_obliqueness floatValue];
    }
    for (NSDictionary *dictionary in attrsArray) {
        NSNumber *d_obliqueness = [dictionary valueForKey:NSObliquenessAttributeName];
        if (d_obliqueness) {
            if (obliqueness!=0 && !isEqualFloat([d_obliqueness floatValue], obliqueness)) {
                obliqueness = 0;
                break;
            }
        }else{
            obliqueness=0;
            break;
        }
    }
    if (obliqueness) {
        NSString *text = [NSString stringWithFormat:@"%.f",obliqueness];
        _obliqueness.text = text;
    }
    float expansion=0;
    NSNumber *d_expansion = [dictionary valueForKey:NSExpansionAttributeName];
    if (d_expansion) {
        expansion = [d_expansion floatValue];
    }
    for (NSDictionary *dictionary in attrsArray) {
        NSNumber *d_expansion = [dictionary valueForKey:NSExpansionAttributeName];
        if (d_expansion) {
            if (expansion!=0 && !isEqualFloat([d_expansion floatValue], expansion)) {
                expansion = 0;
                break;
            }
        }else{
            expansion=0;
            break;
        }
    }
    if (expansion) {
        NSString *text = [NSString stringWithFormat:@"%.f",expansion];
        _expanssion.text = text;
    }

    NSShadow *shadow=[dictionary valueForKey:NSShadowAttributeName];
    for (NSDictionary *dictionary in attrsArray) {
        NSShadow *d_shadow = [dictionary valueForKey:NSShadowAttributeName];
        if (d_shadow) {
            if (shadow.shadowBlurRadius !=0 && !isEqualFloat(d_shadow.shadowBlurRadius, shadow.shadowBlurRadius)) {
                shadow.shadowBlurRadius = 0;
            }
            if (shadow.shadowOffset.width !=0 && !isEqualFloat(d_shadow.shadowOffset.width, shadow.shadowOffset.width)) {
                shadow.shadowOffset = CGSizeMake(0, shadow.shadowOffset.height);
            }
            if (shadow.shadowOffset.height !=0 && !isEqualFloat(d_shadow.shadowOffset.height, shadow.shadowOffset.height)) {
                shadow.shadowOffset = CGSizeMake(shadow.shadowOffset.width, 0);
            }
            UIColor *shadowColor = shadow.shadowColor;
            if (shadowColor && CGColorEqualToColor(shadowColor.CGColor, ((UIColor *)d_shadow.shadowColor).CGColor)) {
                shadowColor = nil;
            }
        }else {
            shadow = nil;
            break;
        }
    }
    if (shadow.shadowBlurRadius!=0) {
        _shadowRadius.text = [NSString stringWithFormat:@"%.f", shadow.shadowBlurRadius];
    }
    if (shadow.shadowOffset.width !=0) {
        _shadowSizeWidth.text = [NSString stringWithFormat:@"%.f", shadow.shadowOffset.width];
    }
    if (shadow.shadowOffset.height !=0) {
        _shadowSizeHeight.text = [NSString stringWithFormat:@"%.f", shadow.shadowOffset.height];
    }
    if (shadow.shadowColor) {
        PCImagePickerSlider *colorPicker = (PCImagePickerSlider *)[_shadowCOlorView viewWithTag:103];
        [colorPicker pointInit:shadow.shadowColor];
    }else{
        [colorPicker pointNull];
    }
    NSParagraphStyle *paragraphStyle=[dictionary valueForKey:NSParagraphStyleAttributeName];
    if (_paragraphStyle) {
        [_paragraphStyle release];
    }
    _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    _paragraphStyle.alignment = paragraphStyle.alignment;
    _paragraphStyle.lineBreakMode = paragraphStyle.lineBreakMode;
    _paragraphStyle.baseWritingDirection = paragraphStyle.lineBreakMode;
    _paragraphStyle.lineSpacing = paragraphStyle.lineSpacing;
    _paragraphStyle.paragraphSpacing = paragraphStyle.paragraphSpacing;
    _paragraphStyle.paragraphSpacingBefore = paragraphStyle.paragraphSpacingBefore;
    _paragraphStyle.maximumLineHeight = paragraphStyle.maximumLineHeight;
    _paragraphStyle.minimumLineHeight = paragraphStyle.minimumLineHeight;
    _paragraphStyle.headIndent = paragraphStyle.headIndent;
    _paragraphStyle.tailIndent = paragraphStyle.tailIndent;
    _paragraphStyle.firstLineHeadIndent = paragraphStyle.firstLineHeadIndent;
    _paragraphStyle.hyphenationFactor = paragraphStyle.hyphenationFactor;
    _paragraphStyle.lineHeightMultiple = paragraphStyle.lineHeightMultiple;
    for (NSDictionary *dictionary in attrsArray) {
        NSParagraphStyle *d_paragraphStyle = [dictionary valueForKey:NSParagraphStyleAttributeName];
        if (d_paragraphStyle) {
            if (_paragraphStyle.alignment != 4 && paragraphStyle.alignment != d_paragraphStyle.alignment) {
                _paragraphStyle.alignment = 4;
            }
            if (_paragraphStyle.lineBreakMode != 0 && paragraphStyle.lineBreakMode != d_paragraphStyle.lineBreakMode) {
                _paragraphStyle.lineBreakMode = 0;
            }
            if (_paragraphStyle.baseWritingDirection != -1 && paragraphStyle.baseWritingDirection != d_paragraphStyle.baseWritingDirection) {
                _paragraphStyle.baseWritingDirection = -1;
            }
            if (_paragraphStyle.lineSpacing != 0 && !isEqualFloat(_paragraphStyle.lineSpacing, d_paragraphStyle.lineSpacing)) {
                _paragraphStyle.lineSpacing = 0;
            }
            if (_paragraphStyle.paragraphSpacing != 0 && !isEqualFloat(_paragraphStyle.paragraphSpacing, d_paragraphStyle.paragraphSpacing)) {
                _paragraphStyle.paragraphSpacing = 0;
            }
            if (_paragraphStyle.paragraphSpacingBefore != 0 && !isEqualFloat(_paragraphStyle.paragraphSpacingBefore, d_paragraphStyle.paragraphSpacingBefore)) {
                _paragraphStyle.paragraphSpacingBefore = 0;
            }
            if (_paragraphStyle.maximumLineHeight != 0 && !isEqualFloat(_paragraphStyle.maximumLineHeight, d_paragraphStyle.maximumLineHeight)) {
                _paragraphStyle.maximumLineHeight = 0;
            }
            if (_paragraphStyle.minimumLineHeight != 0 && !isEqualFloat(_paragraphStyle.minimumLineHeight, d_paragraphStyle.minimumLineHeight)) {
                _paragraphStyle.minimumLineHeight = 0;
            }
            if (_paragraphStyle.headIndent != 0 && !isEqualFloat(_paragraphStyle.headIndent, d_paragraphStyle.headIndent)) {
                _paragraphStyle.headIndent = 0;
            }
            if (_paragraphStyle.tailIndent != 0 && !isEqualFloat(_paragraphStyle.tailIndent, d_paragraphStyle.tailIndent)) {
                _paragraphStyle.tailIndent = 0;
            }
            if (_paragraphStyle.firstLineHeadIndent != 0 && !isEqualFloat(_paragraphStyle.firstLineHeadIndent, d_paragraphStyle.firstLineHeadIndent)) {
                _paragraphStyle.firstLineHeadIndent = 0;
            }
            if (_paragraphStyle.lineHeightMultiple != 0 && !isEqualFloat(_paragraphStyle.lineHeightMultiple, d_paragraphStyle.lineHeightMultiple)) {
                _paragraphStyle.lineHeightMultiple = 0;
            }
            if (_paragraphStyle.hyphenationFactor != 0 && !isEqualFloat(_paragraphStyle.hyphenationFactor, d_paragraphStyle.hyphenationFactor)) {
                _paragraphStyle.hyphenationFactor = 0;
            }
        }
    }
    _alignmentSegment.selectedSegmentIndex = _paragraphStyle.alignment;
    _linebreakmode.selectedSegmentIndex = _paragraphStyle.lineBreakMode;
    _basewritedirection.selectedSegmentIndex = _paragraphStyle.baseWritingDirection;
    if (_paragraphStyle.lineSpacing!=0) {
        _linespace.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.lineSpacing];
    }
    if (_paragraphStyle.paragraphSpacing!=0) {
        _paragraphSpacing.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.paragraphSpacing];
    }
    if (_paragraphStyle.paragraphSpacingBefore!=0) {
        _paragraphSpacingBefore.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.paragraphSpacingBefore];
    }
    if (_paragraphStyle.maximumLineHeight!=0) {
        _maxLineHeight.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.maximumLineHeight];
    }
    if (_paragraphStyle.minimumLineHeight!=0) {
        _minLineHeight.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.minimumLineHeight];
    }
    if (_paragraphStyle.headIndent!=0) {
        _headIndent.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.headIndent];
    }
    if (_paragraphStyle.tailIndent!=0) {
        _tailIndent.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.tailIndent];
    }
    if (_paragraphStyle.firstLineHeadIndent!=0) {
        _firstLineHeadIndent.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.firstLineHeadIndent];
    }
    if (_paragraphStyle.lineHeightMultiple!=0) {
        _lineHeightMultiple.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.lineHeightMultiple];

    }
    if (_paragraphStyle.hyphenationFactor!=0) {
        _hyphenation.text = [NSString stringWithFormat:@"%.f",_paragraphStyle.hyphenationFactor];
        
    }
//    NSArray *numbers = [dictionary valueForKey:NSWritingDirectionAttributeName];
//    NSTextAlternatives *textAlternatives = [dictionary valueForKey:NSTextAlternativesAttributeName];
//    NSTextAttachment *textAttachment = [dictionary valueForKey:NSTextEffectAttributeName];
//    if (numbers) {
//        NSMutableString *mutString=[[[NSMutableString alloc] init] autorelease];
//        for (NSNumber *num in numbers) {
//            [mutString appendFormat:@"%d,", [num  integerValue]];
//        }
//        _writingdirection.text = mutString;
//    }

//    if (textAlternatives) {
//        
//    }
}
- (void)setDictionary:(NSMutableDictionary *)dictionary{
    if (_dictionary==dictionary) {
        return;
    }
    [_dictionary release];
    _dictionary = [dictionary mutableCopy];
    UIFont *font = [dictionary valueForKey:NSFontAttributeName];
    if (font) {
        self.selectIndex = [kFontArray indexOfObject:font.fontName];
        _fontsize.text = [NSString stringWithFormat:@"%.f",font.pointSize];
        self.font = font;
        [_fontTableView reloadData];
    }
    NSParagraphStyle *paragraphStyle = [dictionary valueForKey:NSParagraphStyleAttributeName];
    if (paragraphStyle) {
        [self setMyParagraphStyle:paragraphStyle];
    }
    UIColor *color = [dictionary valueForKey:NSForegroundColorAttributeName];
    if (color) {
        PCImagePickerSlider *colorPicker = (PCImagePickerSlider *)[_fontColorView viewWithTag:100];
        [colorPicker pointInit:color];
    }else{
        color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        PCImagePickerSlider *colorPicker = (PCImagePickerSlider *)[_fontColorView viewWithTag:100];
        [colorPicker pointInit:color];
    }
    UIColor *bkColor = [dictionary valueForKey:NSBackgroundColorAttributeName];
    if (bkColor) {
        PCImagePickerSlider *colorPicker = (PCImagePickerSlider *)[_hightlightView viewWithTag:101];
        [colorPicker pointInit:color];
    }else{
        PCImagePickerSlider *colorPicker = (PCImagePickerSlider *)[_hightlightView viewWithTag:101];
        [colorPicker pointNull];
    }
    NSNumber *ligature = [dictionary valueForKey:NSLigatureAttributeName];
    if (ligature) {
        NSString *text = [NSString stringWithFormat:@"%d", [ligature integerValue]];
        _ligatureTextField.text = text;
    }
    NSNumber *kern = [dictionary valueForKey:NSKernAttributeName];
    if (kern) {
        NSString *text = [NSString stringWithFormat:@"%.f",[kern floatValue]];
        _obliqueness.text = text;
    }
    NSNumber *strikethroughstyle = [dictionary valueForKey:NSStrikethroughStyleAttributeName];
    if (strikethroughstyle) {
        NSString *text = [NSString stringWithFormat:@"%d", [strikethroughstyle integerValue]];
        _strikethroughTextField.text = text;
    }
    NSNumber *underlinestyle = [dictionary valueForKey:NSUnderlineStyleAttributeName];
    if (underlinestyle) {
        NSString *text = [NSString stringWithFormat:@"%d", [underlinestyle integerValue]];
        _underlineStyle.text = text;
    }
    UIColor *strokeColor = [dictionary valueForKey:NSStrokeColorAttributeName];
    if (strokeColor) {
        PCImagePickerSlider *colorPicker = (PCImagePickerSlider *)[_strokeColorView viewWithTag:102];
        [colorPicker pointInit:color];
    }else{
        PCImagePickerSlider *colorPicker = (PCImagePickerSlider *)[_strokeColorView viewWithTag:102];
        [colorPicker pointNull];
    }
    NSNumber *strokeWidth = [dictionary valueForKey:NSStrokeWidthAttributeName];
    if (strokeWidth) {
        NSString *text = [NSString stringWithFormat:@"%.f",[strokeWidth floatValue]];
        _strokeWidth.text = text;
    }
    NSShadow *shadow = [dictionary valueForKey:NSShadowAttributeName];
    if (shadow) {
        self.shadow = shadow;
        _shadowRadius.text = [NSString stringWithFormat:@"%.f", shadow.shadowBlurRadius];
        _shadowSizeWidth.text = [NSString stringWithFormat:@"%.f", shadow.shadowOffset.width];
        _shadowSizeHeight.text = [NSString stringWithFormat:@"%.f", shadow.shadowOffset.height];
        if (shadow.shadowColor) {
            PCImagePickerSlider *colorPicker = (PCImagePickerSlider *)[_shadowCOlorView viewWithTag:103];
            [colorPicker pointInit:shadow.shadowColor];
        }else{
            PCImagePickerSlider *colorPicker = (PCImagePickerSlider *)[_shadowCOlorView viewWithTag:103];
            [colorPicker pointNull];
        }
    }
    NSString *textEffect = [dictionary valueForKey:NSTextEffectAttributeName];
    if (textEffect) {
        _texteffect.text = textEffect;
    }
    NSTextAttachment *textAttachment = [dictionary valueForKey:NSTextEffectAttributeName];
    if (textAttachment) {
        
    }
    NSURL *url = [dictionary valueForKey:NSLinkAttributeName];
    if (url) {
        _link.text = url.absoluteString;
    }
    NSNumber *baselineoffset = [dictionary valueForKey:NSBaselineOffsetAttributeName];
    if (baselineoffset) {
        NSString *text = [NSString stringWithFormat:@"%d",[baselineoffset integerValue]];
        _baseline.text = text;
    }
    UIColor *underlineColor = [dictionary valueForKey:NSUnderlineColorAttributeName];
    if (underlineColor) {
        PCImagePickerSlider *colorPicker = (PCImagePickerSlider *)[_underlineColorView viewWithTag:104];
        [colorPicker pointInit:color];
    }else{
        PCImagePickerSlider *colorPicker = (PCImagePickerSlider *)[_underlineColorView viewWithTag:104];
        [colorPicker pointNull];
    }
    UIColor *strikeColor = [dictionary valueForKey:NSStrikethroughColorAttributeName];
    if (strikeColor) {
        PCImagePickerSlider *colorPicker = (PCImagePickerSlider *)[_strikeColorView viewWithTag:105];
        [colorPicker pointInit:color];
    }else{
        PCImagePickerSlider *colorPicker = (PCImagePickerSlider *)[_strikeColorView viewWithTag:105];
        [colorPicker pointNull];
    }
    NSNumber *obliqueness = [dictionary valueForKey:NSObliquenessAttributeName];
    if (obliqueness) {
        NSString *text = [NSString stringWithFormat:@"%.f",[obliqueness floatValue]];
        _obliqueness.text = text;
    }
    NSNumber *expansion = [dictionary valueForKey:NSExpansionAttributeName];
    if (expansion) {
        NSString *text = [NSString stringWithFormat:@"%.f",[expansion floatValue]];
        _expanssion.text = text;
    }
    NSArray *numbers = [dictionary valueForKey:NSWritingDirectionAttributeName];
    if (numbers) {
        NSMutableString *mutString=[[[NSMutableString alloc] init] autorelease];
        for (NSNumber *num in numbers) {
            [mutString appendFormat:@"%d,", [num  integerValue]];
        }
        _writingdirection.text = mutString;
    }
    NSNumber *verticolGlyph = [dictionary valueForKey:NSVerticalGlyphFormAttributeName];
    if (verticolGlyph) {
        NSString *text = [NSString stringWithFormat:@"%d",[verticolGlyph integerValue]];
        _verticalGlyph.text = text;
    }
}
- (void)chageColor:(PCImagePickerSlider *)slider Color:(UIColor *)color{
    switch (slider.tag) {
        case 100://font
        {
            [self callback:color Key:NSForegroundColorAttributeName isParagraph:NO];
        }
            break;
        case 101://highlight
        {
            [self callback:color Key:NSBackgroundColorAttributeName isParagraph:NO];
        }
            break;
        case 102://stroke
        {
            [self callback:color Key:NSStrokeColorAttributeName isParagraph:NO];
        }
            break;
        case 103://shadow
        {
            _shadow.shadowColor = color;
            [self callback:color Key:kShadowColorAttributename isParagraph:NO];
        }
            break;
        case 104://underline
        {
            [self callback:color Key:NSUnderlineColorAttributeName isParagraph:NO];
        }
            break;
        case 105://strike
        {
            [self callback:color Key:NSStrikethroughColorAttributeName isParagraph:NO];
        }
            break;
        default:
            break;
    }
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return kFontArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = @"fontnamecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (self.selectIndex==indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.text = kFontArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndex = indexPath.row;
    self.font = [UIFont fontWithName:kFontArray[indexPath.row] size:_font.pointSize];
    [self callback:kFontArray[indexPath.row] Key:kFontnameAttributeName isParagraph:NO];
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
  //段落样式
- (IBAction)onAlignment:(id)sender {
    NSInteger number = ((UISegmentedControl *)sender).selectedSegmentIndex;
    _paragraphStyle.alignment = number;
    [self callback:@(number) Key:kParagraphAlignment isParagraph:YES];
}

- (IBAction)onBaseWriteDirection:(id)sender {
    NSInteger number = ((UISegmentedControl *)sender).selectedSegmentIndex;
    _paragraphStyle.baseWritingDirection = number-1;
    [self callback:@(number-1) Key:kParagraphBaseWritingDirection isParagraph:YES];
}

- (IBAction)onLineBreakMode:(id)sender {
    NSInteger number = ((UISegmentedControl *)sender).selectedSegmentIndex;
    _paragraphStyle.lineBreakMode = number;
    [self callback:@(number) Key:kParagraphLineBreakMode isParagraph:YES];
}

- (IBAction)onLineSpaceEndEdit:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    _paragraphStyle.lineSpacing = [number floatValue];
    [self callback:@([number floatValue]) Key:kParagraphLineSpacing isParagraph:YES];
}

- (IBAction)onMaxLineHeightEdit:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    _paragraphStyle.maximumLineHeight = [number floatValue];
    [self callback:@([number floatValue]) Key:kParagraphMaximumLineHeight isParagraph:YES];
}

- (IBAction)onMinLineHeightEdit:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    _paragraphStyle.minimumLineHeight = [number floatValue];
    [self callback:@([number floatValue]) Key:kParagraphMinimumLineHeight isParagraph:YES];
}

- (IBAction)onHeadIndent:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    _paragraphStyle.headIndent = [number floatValue];
    [self callback:@([number floatValue]) Key:kParagraphHeadIndent isParagraph:YES];
}

- (IBAction)onFirstLineHeadIndent:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    _paragraphStyle.firstLineHeadIndent = [number floatValue];
    [self callback:@([number floatValue]) Key:kParagraphFirstLineHeadIndent isParagraph:YES];
}

- (IBAction)onTailIndent:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    _paragraphStyle.tailIndent = [number floatValue];
    [self callback:@([number floatValue]) Key:kParagraphTailIndent isParagraph:YES];
}

- (IBAction)onLineHeightMultiple:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    _paragraphStyle.lineHeightMultiple = [number floatValue];
    [self callback:@([number floatValue]) Key:kParagraphLineHeightMultiple isParagraph:YES];
}

- (IBAction)onParagraphSpacing:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    _paragraphStyle.paragraphSpacing = [number floatValue];
    [self callback:@([number floatValue]) Key:kParagraphParagraphSpacing isParagraph:YES];
}

- (IBAction)onParagraphSpaceingBefore:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    _paragraphStyle.paragraphSpacingBefore = [number floatValue];
    [self callback:@([number floatValue]) Key:kParagraphParagraphSpacingBefore isParagraph:YES];
}

- (IBAction)onHyphenationFactor:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    _paragraphStyle.hyphenationFactor = [number floatValue];
    [self callback:@([number floatValue]) Key:kParagraphHyphenationFactor isParagraph:YES];
}

#pragma mark - text attributes
- (IBAction)onTextAttechment:(id)sender {
    NSTextAttachment *attachment = [[[NSTextAttachment alloc] init] autorelease];
    attachment.image = [UIImage imageNamed:@"butterfly.png"];
    //    attachment.bounds = CGRectMake(0, 10, 20, 20);
    NSAttributedString *attributeStr = [NSAttributedString attributedStringWithAttachment:attachment];
    if (_selectRange.length>0) {
        [_m_attributedString deleteCharactersInRange:_selectRange];
    }
    [_m_attributedString insertAttributedString:attributeStr atIndex:_selectRange.location];
    if ([_delegate respondsToSelector:@selector(refresh:AttributeString:)]) {
        [_delegate addTextAttechment:self AttributeString:_m_attributedString];
    }
}

- (IBAction)onFontsize:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    self.font = [UIFont fontWithName:_font.fontName size:[number floatValue]];
    [self callback:@([number floatValue]) Key:kPointsizeAttributedName isParagraph:NO];
}
  //文字样式
- (IBAction)onLigature:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    NSNumber *num = [NSNumber numberWithInt:[number integerValue]];
    [self callback:num Key:NSLigatureAttributeName isParagraph:NO];
}


- (IBAction)onObliqueness:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    NSNumber *num = [NSNumber numberWithFloat:[number floatValue]];
    [self callback:num Key:NSObliquenessAttributeName isParagraph:NO];
}

- (IBAction)onExpanssion:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    NSNumber *num = [NSNumber numberWithFloat:[number floatValue]];
    [self callback:num Key:NSExpansionAttributeName isParagraph:NO];
}

- (IBAction)onVerticolGlyph:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    NSNumber *num = [NSNumber numberWithFloat:[number floatValue]];
    [self callback:num Key:NSVerticalGlyphFormAttributeName isParagraph:NO];
}

- (IBAction)onUnderLineStyle:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    NSInteger style = NSUnderlineStyleNone;
    switch ([number integerValue]) {
        case 0:
        {style = NSUnderlineStyleNone;}
            break;
        case 1:
        {style = NSUnderlineStyleSingle;}
            break;
        case 2:
        {style = NSUnderlineStyleThick;}
            break;
        case 3:
        {style = NSUnderlineStyleDouble;}
            break;
        case 4:
        {style = NSUnderlinePatternSolid;}
            break;
        case 5:
        {style = NSUnderlinePatternDot;}
            break;
        case 6:
        {style = NSUnderlinePatternDash;}
            break;
        case 7:
        {style = NSUnderlinePatternDashDot;}
            break;
        case 8:
        {style = NSUnderlinePatternDashDotDot;}
            break;
        case 9:
        {style = NSUnderlineByWord;}
            break;
        default:
            break;
    }
    NSNumber *num = [NSNumber numberWithInt:[number integerValue]];
    [self callback:num Key:NSUnderlineStyleAttributeName isParagraph:NO];
}

- (IBAction)onWritingDirection:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    NSNumber *num = [NSNumber numberWithInt:[number integerValue]];
    [self callback:num Key:NSWritingDirectionAttributeName isParagraph:NO];
}

- (IBAction)onStrokeWidth:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    NSNumber *num = [NSNumber numberWithInt:[number floatValue]];
    [self callback:num Key:NSStrokeWidthAttributeName isParagraph:NO];
}

- (IBAction)onShadowRadius:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    _shadow.shadowBlurRadius = [number floatValue];
    [self callback:@([number floatValue]) Key:kShadowRadiusAttributeName isParagraph:NO];
}

- (IBAction)onStrikeThrough:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    NSInteger style = NSUnderlineStyleNone;
    switch ([number integerValue]) {
        case 0:
        {style = NSUnderlineStyleNone;}
            break;
        case 1:
        {style = NSUnderlineStyleSingle;}
            break;
        case 2:
        {style = NSUnderlineStyleThick;}
            break;
        case 3:
        {style = NSUnderlineStyleDouble;}
            break;
        case 4:
        {style = NSUnderlinePatternSolid;}
            break;
        case 5:
        {style = NSUnderlinePatternDot;}
            break;
        case 6:
        {style = NSUnderlinePatternDash;}
            break;
        case 7:
        {style = NSUnderlinePatternDashDot;}
            break;
        case 8:
        {style = NSUnderlinePatternDashDotDot;}
            break;
        case 9:
        {style = NSUnderlineByWord;}
            break;
        default:
            break;
    }
    NSNumber *num = [NSNumber numberWithInt:style];
    [self callback:num Key:NSStrikethroughStyleAttributeName isParagraph:NO];
}

- (IBAction)onShadowSizeWidth:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    _shadow.shadowOffset = CGSizeMake([number floatValue], _shadow.shadowOffset.height);
    [self callback:@([number floatValue]) Key:kShadowOffsizeWidthName isParagraph:NO];
}

- (IBAction)onShadowSizeHeight:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    _shadow.shadowOffset = CGSizeMake(_shadow.shadowOffset.width, [number floatValue]);
    [self callback:@([number floatValue]) Key:kShadowOffsizeHeightName isParagraph:NO];
}

- (IBAction)onTextEffect:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    if ([number integerValue]==1) {
        [self callback:NSTextEffectLetterpressStyle Key:NSTextEffectAttributeName isParagraph:NO];
    }else if ([number integerValue]==0){
        [self callback:nil Key:NSTextEffectAttributeName isParagraph:NO];
    }
}

- (IBAction)onLink:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    NSURL *url = [[[NSURL alloc] initWithString:number] autorelease];
    [self callback:url Key:NSLinkAttributeName isParagraph:NO];
}

- (IBAction)onBaseLine:(id)sender {
    NSString *number = ((UITextField *)sender).text;
    NSNumber *num = [NSNumber numberWithFloat:[number floatValue]];
    [self callback:num Key:NSBaselineOffsetAttributeName isParagraph:NO];
}

@end
