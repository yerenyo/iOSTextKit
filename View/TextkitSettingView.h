//
//  TextkitSettingView.h
//  TextKitDemo
//
//  Created by Jinyou Gu on 13-7-1.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCImagePickerSlider.h"
@class TextkitSettingView;
@protocol TextkitSettingViewDelegate<NSObject>
- (void)refresh:(TextkitSettingView *)view Attribute:(NSDictionary*)attribute;
- (void)refresh:(TextkitSettingView *)view AttributeString:(NSAttributedString *)attibutedStr;
- (void)addTextAttechment:(TextkitSettingView *)view AttributeString:(NSAttributedString *)attibutedStr;
@end
@interface TextkitSettingView : UIView<UITableViewDataSource, UITableViewDelegate,
PCImagePickerDelegate>{
  //文字样式
    IBOutlet UITableView *_fontTableView;
    IBOutlet UITextField *_ligatureTextField;//连字
    IBOutlet UITextField *_glyphSpacing;
    IBOutlet UITextField *_strikethroughTextField;//删除线
    IBOutlet UITextField *_shadowSizeWidth;//阴影宽
    IBOutlet UITextField *_shadowSizeHeight;//阴影高
    IBOutlet UITextField *_shadowRadius;//阴影半径
    IBOutlet UITextField *_strokeWidth;//笔触宽
    IBOutlet UITextField *_obliqueness;//倾斜度
    IBOutlet UITextField *_expanssion;
    IBOutlet UITextField *_writingdirection;
    IBOutlet UITextField *_texteffect;
    IBOutlet UIButton *_attachment;
    IBOutlet UITextField *_link;
    IBOutlet UITextField *_baseline;
    IBOutlet UITextField *_verticalGlyph;
    IBOutlet UITextField *_underlineStyle;
    IBOutlet UIView *_fontColorView;
    IBOutlet UIView *_hightlightView;
    IBOutlet UIView *_strokeColorView;
    IBOutlet UIView *_shadowCOlorView;
    IBOutlet UIView *_underlineColorView;
    IBOutlet UIView *_strikeColorView;
  //段落样式
    IBOutlet UISegmentedControl *_alignmentSegment;
    IBOutlet UISegmentedControl *_linebreakmode;
    IBOutlet UISegmentedControl *_basewritedirection;
    IBOutlet UITextField *_linespace;
    IBOutlet UITextField *_paragraphSpacing;
    IBOutlet UITextField *_paragraphSpacingBefore;
    IBOutlet UITextField *_maxLineHeight;
    IBOutlet UITextField *_minLineHeight;
    IBOutlet UITextField *_headIndent;
    IBOutlet UITextField *_tailIndent;
    IBOutlet UITextField *_firstLineHeadIndent;
    IBOutlet UITextField *_lineHeightMultiple;
    IBOutlet UIScrollView *_contentScrollView;
    IBOutlet UISegmentedControl *_textParagh;
    IBOutlet UIView *_textView;
    IBOutlet UIView *_paraghView;
    IBOutlet UITextField *_fontsize;
    IBOutlet UIControl *_documentView;
    IBOutlet UITextField *_hyphenation;
}
@property(nonatomic, assign) id<TextkitSettingViewDelegate> delegate;
//@property(nonatomic, retain) NSMutableDictionary *dictionary;
- (void)attributeString:(NSAttributedString *)attributeStr Select:(NSRange)range Attribute:(NSDictionary *)attribute;
- (id)initWithXib;
- (IBAction)OnChageTextOrParagraph:(id)sender;
- (IBAction)onDissmiskeyboard:(id)sender;
  //段落样式
- (IBAction)onAlignment:(id)sender;
- (IBAction)onBaseWriteDirection:(id)sender;
- (IBAction)onLineBreakMode:(id)sender;
- (IBAction)onLineSpaceEndEdit:(id)sender;
- (IBAction)onMaxLineHeightEdit:(id)sender;
- (IBAction)onMinLineHeightEdit:(id)sender;
- (IBAction)onHeadIndent:(id)sender;
- (IBAction)onFirstLineHeadIndent:(id)sender;
- (IBAction)onTailIndent:(id)sender;
- (IBAction)onLineHeightMultiple:(id)sender;
- (IBAction)onParagraphSpacing:(id)sender;
- (IBAction)onParagraphSpaceingBefore:(id)sender;
- (IBAction)onHyphenationFactor:(id)sender;


  //文字样式
- (IBAction)onTextAttechment:(id)sender;
- (IBAction)onFontsize:(id)sender;
- (IBAction)onLigature:(id)sender;
- (IBAction)onObliqueness:(id)sender;
- (IBAction)onExpanssion:(id)sender;
- (IBAction)onVerticolGlyph:(id)sender;
- (IBAction)onUnderLineStyle:(id)sender;
- (IBAction)onWritingDirection:(id)sender;
- (IBAction)onStrokeWidth:(id)sender;
- (IBAction)onShadowRadius:(id)sender;
- (IBAction)onStrikeThrough:(id)sender;
- (IBAction)onShadowSizeWidth:(id)sender;
- (IBAction)onShadowSizeHeight:(id)sender;
- (IBAction)onTextEffect:(id)sender;
- (IBAction)onLink:(id)sender;
- (IBAction)onBaseLine:(id)sender;
@end
