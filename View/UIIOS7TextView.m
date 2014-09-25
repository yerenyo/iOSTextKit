//
//  UIIOS7TextView.m
//  TextKitDemo
//
//  Created by Jinyou Gu on 13-6-25.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//

#import "UIIOS7TextView.h"
#import "PCMTextObject.h"
#import "UIRichImageView.h"
@interface UIIOS7TextView()<UITextViewDelegate, UIRichImageViewDelegate>{
    UITextView *_textView;
}
@end
@implementation UIIOS7TextView
@synthesize attributes=_attributes;
@synthesize textView=_textView;
- (void)dealloc{
    [_images release];
    [_attributes release];
    [_textView release];
    [_textstorage release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame TextObject:(PCMTextObject *)textObject{
    self = [super initWithFrame:frame];
    if (self) {
        _images = [[NSMutableArray alloc] init];
        _attributes = [@{NSFontAttributeName:[UIFont fontWithName:@"ArialMT" size:44],
                               NSForegroundColorAttributeName:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]} retain];
        _textstorage = [[NSTextStorage alloc] initWithAttributedString:[textObject attributedString]];
        NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
        NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithSize:frame.size] autorelease];
        textContainer.widthTracksTextView = NO;//resize textview
        [layoutManager addTextContainer:textContainer];
        [_textstorage addLayoutManager:layoutManager];
        _textView = [[UITextView alloc] initWithFrame:self.bounds textContainer:textContainer];
        [self addSubview:_textView];
        _textView.scrollEnabled = NO;
        [self performSelector:@selector(onTextViewOffset) withObject:nil afterDelay:0.1];//怪异的offset 总是｛0，-64｝
        _textView.delegate = self;
    }
    return self;
}
- (void)onTextViewOffset{
    _textView.contentOffset = CGPointMake(0, 0);
}
- (void)setExclusionPaths:(NSArray *)paths{
    _textView.textContainer.exclusionPaths = paths;
}
- (BOOL)pointInImage:(CGPoint)point index:(NSInteger *)index{
    for (int i=_images.count-1;i>=0;i--) {
        UIRichImageView *imageView = _images[i];
        if (CGRectContainsPoint(imageView.frame, point)) {
            *index = i;
            return YES;
        }
    }
    return NO;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSInteger index=-1;
    if ([self pointInImage:point index:&index]) {
        _selectIndex = index;
        return _images[_selectIndex];
    }
    CGPoint point1 = [_textView convertPoint:point fromView:self];
    CGRect textRect = [_textView.layoutManager usedRectForTextContainer:_textView.textContainer];
//    NSLog(@"%@", [NSValue valueWithCGRect:textRect]);
    while (point1.y>=textRect.size.height) {
        NSAttributedString *string = [[[NSAttributedString alloc] initWithString:@"\n" attributes:_attributes] autorelease];
        [_textstorage appendAttributedString:string];
        textRect = [_textView.layoutManager usedRectForTextContainer:_textView.textContainer];
//        NSLog(@"%@", [NSValue valueWithCGRect:textRect]);
    }
    return [super hitTest:point withEvent:event];
}
- (NSArray *)framesWithImageView{
    NSMutableArray *frames = [[[NSMutableArray alloc] init] autorelease];
    for (UIRichImageView *imageView in _images) {
        UIBezierPath *bPath = [UIBezierPath bezierPathWithCGPath:imageView.bezierPath.CGPath];
        [frames addObject:bPath];
    }
    return [NSArray arrayWithArray:frames];
}
- (void)addImage:(UIImage *)image WithBezierPath:(UIBezierPath *)bezierPath{
//    CGPoint center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
//    CGAffineTransform transform = CGAffineTransformMakeTranslation(center.x-image.size.width/2.0, center.y-image.size.height/2.0);
//    CGPathRef intermediatePath = CGPathCreateCopyByTransformingPath(bezierPath.CGPath,
//                                                                    &transform);
//    bezierPath.CGPath = intermediatePath;
//    CGPathRelease(intermediatePath);
    UIRichImageView *imageView = [[[UIRichImageView alloc] initWithImage:image BezierPath:bezierPath] autorelease];
    imageView.delegate = self;
//    imageView.center = center;
    [_images addObject:imageView];
    [self addSubview:imageView];
    [self setExclusionPaths:[self framesWithImageView]];
}
#pragma mark - UIRichImageViewDelegate
- (void)remove:(UIRichImageView *)view{
    [_images removeObject:view];
    [view removeFromSuperview];
    [self setExclusionPaths:[self framesWithImageView]];
}
- (void)refresh:(UIRichImageView *)view{
    [self setExclusionPaths:[self framesWithImageView]];
}
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSAttributedString *string = [[[NSAttributedString alloc] initWithString:text attributes:_attributes] autorelease];
    if (range.length>0) {
        [_textstorage deleteCharactersInRange:range];
    }
    [_textstorage insertAttributedString:string atIndex:range.location];
    _textView.selectedRange = NSMakeRange(_textView.selectedRange.location+1, 0);
    return NO;
}
- (void)textViewDidChange:(UITextView *)textView{
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0){
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0){
    return YES;
}

@end
