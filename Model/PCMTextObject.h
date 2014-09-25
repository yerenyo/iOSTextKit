//
//  PCMTextObject.h
//  PDFCreator
//
//  Created by Jinyou Gu on 13-1-22.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//

#import "PCMImportObject.h"
@interface PCMText : NSObject{
    UIColor *_textColor;
    UIFont *_font;
    NSString *_graphStyleString;
    NSInteger _underlineStyle;
}
@property(nonatomic, assign) NSRange range;
@property(nonatomic, retain) NSString *themeRef;
@property(nonatomic, retain) UIFont *font;
@property(nonatomic, retain) NSString *graphStyleString;
@property(nonatomic, readonly) NSParagraphStyle *paragraphStyle;
@property(nonatomic, retain) UIColor *textColor;
@property(nonatomic, retain) UIColor *backColor;
@property(nonatomic, assign) NSInteger underlineStyle;
- (id)initWithDictionary:(NSDictionary *)attrs range:(NSRange)range;
@end
@interface PCMTextObject : PCMImportObject{
    NSString *_text;
    NSMutableArray *_textRanges;
}
@property(nonatomic, retain) NSString *text;
@property(nonatomic, retain) NSMutableArray *textRanges;//pcmtext 数组对像
@property(nonatomic, retain) NSMutableArray *frames;
@property(nonatomic,assign)UITextAlignment align;//文本对齐方式
- (NSMutableAttributedString *)attributedString;
- (id)initWithAttributedString:(NSAttributedString *)attributedString;
- (id)initWithDataText;
@end
