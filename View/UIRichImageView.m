//
//  UIRichImageView.m
//  TextKitDemo
//
//  Created by Jinyou Gu on 13-7-21.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//

#import "UIRichImageView.h"
#import "TouchImageView_Private.h"
@implementation UIRichImageView
@synthesize bezierPath=_bezierPath;
@synthesize delegate=_delegate;
- (void)dealloc{
    [_orginPath release];
    [_bezierPath release];
    [super dealloc];
}
- (id)initWithImage:(UIImage *)image BezierPath:(UIBezierPath *)path
{
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    if (self) {
        // Initialization code
        _bezierPath = [path copy];
        _orginPath = [path copy];
        self.image = image;
        [self sizeToFit];
        self.center = CGPointMake(0, 0);
        self.userInteractionEnabled=YES;
        self.layer.anchorPoint = CGPointMake(0, 0);
    }
    return self;
}

- (void)onRemove{
    if ([_delegate respondsToSelector:@selector(remove:)]) {
        [_delegate remove:self];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self performSelector:@selector(onRemove) withObject:nil afterDelay:0.5];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    UIBezierPath *path = [[_orginPath copy] autorelease];
    [path applyTransform:self.transform];
    self.bezierPath = path;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onRemove) object:nil];
    if ([_delegate respondsToSelector:@selector(refresh:)]) {
        [_delegate refresh:self];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onRemove) object:nil];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onRemove) object:nil];
}

@end
