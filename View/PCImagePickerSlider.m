//
//  PCImagePickerSlider.m
//  PDFCreator
//
//  Created by Jinyou Gu on 13-3-20.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//

#import "PCImagePickerSlider.h"
#import "PCImageColor.h"
@interface PCImagePickerSlider(){
    UIImageView *_colorView;
    UIImageView *_sliderVew;
    PCImageColor *_imagePicker;
}
@end
@implementation PCImagePickerSlider
@synthesize delegate=_delegate;
- (void)dealloc{
    [_colorView release];
    [_sliderVew release];
    [_imagePicker release];
    [super dealloc];
}
- (id)initWithColor:(UIImage *)image slider:(UIImage *)imageSlider{
    self = [super init];
    if (self) {
        _colorView = [[UIImageView alloc] initWithImage:image];
        _sliderVew = [[UIImageView alloc] initWithImage:imageSlider];
        [self addSubview:_colorView];
        [self addSubview:_sliderVew];
        _imagePicker = [[PCImageColor alloc] initWithImage:image];
    }
    return self;
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _colorView.frame = CGRectMake(0, 0, 337, 24);
    _sliderVew.frame = CGRectMake(0, 0, 41, 41);
    _colorView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    _sliderVew.center = CGPointMake(_colorView.center.x,_colorView.center.y+7.0);
}
- (void)pointNull{
    CGFloat x = -self.bounds.size.width;
    CGPoint center = CGPointMake(x, self.bounds.size.height/2.0+7.0);
    _sliderVew.center = center;
}
- (void)pointInit:(UIColor *)color{
    CGPoint point = [_imagePicker getPickerPoint:color];
    CGFloat x = point.x;
    x = MAX(0, x);
    x = MIN(self.bounds.size.width, x);
    CGPoint center = CGPointMake(x, self.bounds.size.height/2.0+7.0);
    _sliderVew.center = center;
}
- (UIColor *)defaultColor
{
    CGPoint center = _sliderVew.center;
    UIColor *color = [_imagePicker getColor:center];
    return color;
}
#pragma mark -  --触摸控制 touch事件
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat x = point.x;
    x = MAX(0, x);
    x = MIN(self.bounds.size.width, x);
    CGPoint center = CGPointMake(x, self.bounds.size.height/2.0+7.0);
    _sliderVew.center = center;
    UIColor *color = [_imagePicker getColor:center];
    if ([_delegate respondsToSelector:@selector(chageColor:Color:)]) {
        [_delegate chageColor:self Color:color];
    }
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat x = point.x;
    x = MAX(5, x);
    x = MIN(self.bounds.size.width - _sliderVew.bounds.size.width/2+12, x);
    CGPoint center = CGPointMake(x, self.bounds.size.height/2.0+7.0);
    _sliderVew.center = center;
    UIColor *color = [_imagePicker getColor:center];
    if (color && [_delegate respondsToSelector:@selector(chageColor:Color:)]) {
        [_delegate chageColor:self Color:color];
    }
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
}

@end
