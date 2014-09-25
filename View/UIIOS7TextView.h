//
//  UIIOS7TextView.h
//  TextKitDemo
//
//  Created by Jinyou Gu on 13-6-25.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PCMTextObject;
@interface UIIOS7TextView : UIView{
    NSTextStorage *_textstorage;
    NSDictionary *_attributes;
    NSMutableArray *_images;
    NSInteger _selectIndex;
}
//当前样式字典-UIFont UIColor Underline BackColor... 参考"NSFontAttributeName"
@property(nonatomic, retain) NSDictionary *attributes;
//NSMutableAttributestring 富文本文符串对象
@property(nonatomic, retain, readonly) UITextView *textView;
//初始方法
- (id)initWithFrame:(CGRect)frame TextObject:(PCMTextObject *)textObject;
//设置文字环绕path数据 - UIBezierPath Array
- (void)setExclusionPaths:(NSArray *)paths;

- (void)addImage:(UIImage *)image WithBezierPath:(UIBezierPath *)bezierPath;
@end
