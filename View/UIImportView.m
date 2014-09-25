//
//  UIImportView.m
//  TextKitDemo
//
//  Created by Jinyou Gu on 13-7-19.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//

#import "UIImportView.h"
#define kTopForEditImportMask 0
#import "TouchImageView.h"
@interface UIImportView(){
    UILabel *_titleLabel;
    CGPoint _startPoint;
    CGPoint _endPoint;
    BOOL _isImageTouch;
    TouchImageView *_touchImageView;
    UIButton *_cancleBtn;
    UIButton *_doneBtn;
}
@property(nonatomic, retain) UIBezierPath *bezierPath;
- (void)typeInit;
@end
@implementation UIImportView
@synthesize bezierPath=_bezierPath;
@synthesize delegate=_delegate;
- (void)dealloc{
    if ([_cancleBtn superview]) {
        [_cancleBtn removeFromSuperview];
    }
    [_cancleBtn release];
    if ([_doneBtn superview]) {
        [_doneBtn removeFromSuperview];
    }
    [_doneBtn release];
    if ([_touchImageView superview]) {
        [_touchImageView removeFromSuperview];
    }
    [_touchImageView release];
    [_bezierPath release];
    [_titleLabel release];
    [super dealloc];
}
- (id)initWithType:(NSUInteger)type{//0,star 1,round 2, acr
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        _type = type;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"请框出5角星";
        _titleLabel.backgroundColor = [UIColor yellowColor];
        _titleLabel.textColor = [UIColor redColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:24];
        _touchImageView = [[TouchImageView alloc] init];
        [self typeInit];
        [self addSubview:_titleLabel];
        [self setNeedsDisplay];
    }
    return self;
}
- (void)typeInit{
    switch (_type) {
        case 0:
        {
            _titleLabel.text = @"请用手指框出5角星";
        }
            break;
        case 1:
        {
            _titleLabel.text = @"请框出5角星";
        }
            break;
        case 2:
        {
            _titleLabel.text = @"请框出5角星";
        }
            break;
        default:
            break;
    }
    [_titleLabel sizeToFit];
    _titleLabel.center = CGPointMake(768/2.0, 960/2.0);
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.1);
//    CGContextFillRect(context, self.bounds);
    if (_startPoint.x>_endPoint.x && _endPoint.y>_startPoint.y) {
        _endPoint = CGPointMake(_endPoint.x, _startPoint.y-(_endPoint.x-_startPoint.x));
    }else if(_startPoint.x<_endPoint.x && _endPoint.y<_startPoint.y){
        _endPoint = CGPointMake(_endPoint.x, _startPoint.y-(_endPoint.x-_startPoint.x));
    }else
        _endPoint = CGPointMake(_endPoint.x, _startPoint.y+(_endPoint.x-_startPoint.x));
    CGPoint addLines[] =
	{
        _startPoint,
		CGPointMake(_endPoint.x, _startPoint.y),
        _endPoint,
		CGPointMake(_startPoint.x, _endPoint.y),
        _startPoint,
	};
	CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
	CGContextStrokePath(context);
    switch (_type) {
        case 0:
        {
            self.bezierPath = [UIBezierPath bezierPath];
            CGFloat r = abs(_startPoint.x-_endPoint.x)/2.0;
//            CGPoint center = CGPointMake(_startPoint.x+r, _startPoint.y+r);
            CGPoint center = CGPointZero;
            [self.bezierPath moveToPoint:CGPointMake(center.x, center.y+r)];
            for(int i = 1; i < 5; ++i)
            {
                CGFloat x = r * sinf(i * 4.0 * M_PI / 5.0);
                CGFloat y = r * cosf(i * 4.0 * M_PI / 5.0);
                [self.bezierPath addLineToPoint:CGPointMake(center.x + x, center.y + y)];
            }
            [self.bezierPath closePath];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(_startPoint.x+r, _startPoint.y+r);
            [_bezierPath applyTransform:transform];
            [self.bezierPath stroke];
        }
            break;
        case 1:
        {
        
        }
            break;
        default:
            break;
    }
    if (_isImageTouch) {
        CGPoint point1 = CGPointZero;
        CGPoint point2 = CGPointZero;
        point1.x = MIN(_startPoint.x, _endPoint.x);
        point1.y = MIN(_startPoint.y, _endPoint.y);
        point2.x = MAX(_startPoint.x, _endPoint.x);
        point2.y = MAX(_startPoint.y, _endPoint.y);
        CGPoint left[]=
        {
            {0,kTopForEditImportMask},
            point1,
            CGPointMake(point1.x, point2.y),
            {0,self.bounds.size.height},
            {0,kTopForEditImportMask}
        };
        CGContextAddLines(context, left, sizeof(left)/sizeof(left[0]));
        CGContextFillPath(context);
        CGPoint up[]=
        {
            {0,kTopForEditImportMask},
            {self.bounds.size.width,kTopForEditImportMask},
            CGPointMake(point2.x, point1.y),
            point1,
            {0,kTopForEditImportMask}
        };
        CGContextAddLines(context, up, sizeof(up)/sizeof(up[0]));
        CGContextFillPath(context);
        CGPoint right[]=
        {
            {self.bounds.size.width,kTopForEditImportMask},
            {self.bounds.size.width,self.bounds.size.height},
            point2,
            CGPointMake(point2.x, point1.y),
            {self.bounds.size.width,kTopForEditImportMask}
        };
        CGContextAddLines(context, right, sizeof(right)/sizeof(right[0]));
        CGContextFillPath(context);
        CGPoint down[]=
        {
            CGPointMake(point1.x, point2.y),
            point2,
            {self.bounds.size.width,self.bounds.size.height},
            {0,self.bounds.size.height},
            CGPointMake(point1.x, point2.y),
        };
        CGContextAddLines(context, down, sizeof(down)/sizeof(down[0]));
        CGContextFillPath(context);
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    _startPoint = location;
    _titleLabel.hidden = YES;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    _endPoint = location;
    [self setNeedsDisplay];
//    CGPoint prepoint = [touch previousLocationInView:self];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    _endPoint = location;
    if (_type==0 || _type==1) {
        _isImageTouch = YES;
        [self addTouchImageView];
    }
    [self setNeedsDisplay];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    _endPoint = location;
    [self setNeedsDisplay];
}

- (void)addTouchImageView{
    _touchImageView.image = [UIImage imageNamed:@"2000.jpg"];
    _touchImageView.bounds = (CGRect){CGPointZero,_touchImageView.image.size};
    CGPoint point1,point2;
    point1.x = MIN(_startPoint.x, _endPoint.x);
    point1.y = MIN(_startPoint.y, _endPoint.y);
    point2.x = MAX(_startPoint.x, _endPoint.x);
    point2.y = MAX(_startPoint.y, _endPoint.y);
    CGPoint center =  CGPointMake(point1.x+(point2.x-point1.x)/2.0,
                                  point1.y+(point2.y-point1.y)/2.0);
    center = [self.superview convertPoint:center fromView:self];
    _touchImageView.center = center;
    [self.superview insertSubview:_touchImageView belowSubview:self];
    if (_cancleBtn) {
        [_cancleBtn removeFromSuperview];
        [_cancleBtn release];
    }
    _cancleBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [_cancleBtn setImage:[UIImage imageNamed:@"button_backmenu01.png"] forState:UIControlStateNormal];
    [_cancleBtn setImage:[UIImage imageNamed:@"button_backmenu02.png"] forState:UIControlStateSelected];
    [_cancleBtn sizeToFit];
    [_cancleBtn addTarget:self action:@selector(onImageCancel:) forControlEvents:UIControlEventTouchUpInside];
    float x = _touchImageView.center.x - _cancleBtn.bounds.size.width/2;
    float y = _endPoint.y;
    _cancleBtn.center = CGPointMake(x,y);
    [self.superview insertSubview:_cancleBtn belowSubview:self];
    if (_doneBtn) {
        [_doneBtn removeFromSuperview];
        [_doneBtn release];
    }
    _doneBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [_doneBtn setImage:[UIImage imageNamed:@"sure01.png"] forState:UIControlStateNormal];
    [_doneBtn setImage:[UIImage imageNamed:@"sure02.png"] forState:UIControlStateSelected];
    [_doneBtn sizeToFit];
    [_doneBtn addTarget:self action:@selector(onImageDone:) forControlEvents:UIControlEventTouchUpInside];
    x = _touchImageView.center.x + _doneBtn.bounds.size.width/2;
    y = _endPoint.y;
    _doneBtn.center = CGPointMake(x,y);
    [self.superview insertSubview:_doneBtn belowSubview:self];
    self.userInteractionEnabled = NO;
}

- (void)onImageCancel:(id)sender{
    [_touchImageView removeFromSuperview];
    [_cancleBtn removeFromSuperview];
    [_cancleBtn release];
    _cancleBtn = nil;
    [_doneBtn removeFromSuperview];
    [_doneBtn release];
    _doneBtn = nil;
    _startPoint = CGPointZero;
    _endPoint = CGPointZero;
    [self setNeedsDisplay];
    self.userInteractionEnabled = YES;
    [self typeInit];
}
- (CGRect)mastImageRect{
    CGPoint point1,point2;
    point1.x = MIN(_startPoint.x, _endPoint.x);
    point1.y = MIN(_startPoint.y, _endPoint.y);
    point2.x = MAX(_startPoint.x, _endPoint.x);
    point2.y = MAX(_startPoint.y, _endPoint.y);
    CGRect rect = CGRectMake(point1.x,point1.y,point2.x-point1.x, point2.y-point1.y);
    return rect;
}
//生产路径范围内图片
- (UIImage *)generateMaskImage {
    CGRect rect = [self mastImageRect];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-rect.origin.x, -rect.origin.y);
    [_bezierPath applyTransform:transform];
    [_bezierPath fill];
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();
    return image;
}
- (UIImage *)clipImageWithMaskImage:(UIImage *)mask image:(UIImage *)image {
    CGRect rect = [self mastImageRect];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将画图的起点移动到image.size.height
    CGContextTranslateCTM(context, 0, rect.size.height);
    //然后将图片沿y轴翻转
    CGContextScaleCTM(context, 1, -1.0);
    CGContextClearRect(context, (CGRect){{0,0},rect.size});
    CGContextClipToMask(context, (CGRect){{0,0},rect.size}, mask.CGImage);
    
    CGContextDrawImage(context, (CGRect){{0,0},rect.size},image.CGImage);
    UIImage *imageas = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageas;
}
- (UIImage *)clipImage{
    UIView *view = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:_touchImageView.image] autorelease];
    imageView.center = CGPointMake(_touchImageView.center.x, _touchImageView.center.y-64); ;
    imageView.bounds = _touchImageView.bounds;
    imageView.transform = _touchImageView.transform;
    [view addSubview:imageView];
    
    CGRect rect = [self mastImageRect];
    view.frame = CGRectMake(-rect.origin.x, -rect.origin.y, view.frame.size.width, view.frame.size.height);
    UIView *imgView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)] autorelease];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.clipsToBounds = YES;
    [imgView addSubview:view];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [imgView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)onImageDone:(id)sender{
    switch (_type) {
        case 0:
        {
            UIImage *image =  [self clipImageWithMaskImage:[self generateMaskImage] image:[self clipImage]];
            if ([_delegate respondsToSelector:@selector(import:Image:BezierPath:)]) {
                [_delegate import:self Image:image BezierPath:_bezierPath];
            }
            
        }
            break;
        case 1:
        {
        
        }
            break;
        default:
            break;
    }
}

@end
