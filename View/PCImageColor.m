//
//  PCImageColor.m
//  PDFCreator
//
//  Created by Jinyou Gu on 13-3-20.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//

#import "PCImageColor.h"
@interface PCImageColor(){
    CGImageRef _colorRef;
	CFDataRef _bitmapData;
	int _cWidth,_cHeight,_cBytesPerRow,_alphsOffset;
	UInt8 *_pBitmapBuffer;
}
- (void)loadUIimgae:(UIImage *)image;
@end
@implementation PCImageColor
- (void)dealloc{
    if (_colorRef) {
		CGImageRelease(_colorRef);
	}
	if (_bitmapData) {
		CFRelease(_bitmapData);
	}
    [super dealloc];
}
- (id)initWithImage:(UIImage *)image{
    self = [super init];
    if (self) {
        [self loadUIimgae:image];
    }
    return self;
}

- (UIColor *)getColor:(CGPoint)curPoint//注意高清设备应该传入2倍坐标
{
    NSInteger testX = curPoint.x, testY = curPoint.y;
	if (testX < 0 || testX >= _cWidth || testY < 0 || testY >= _cHeight) {
		return nil;
	}
	uint8_t *redPtr=NULL, *greenPtr=NULL, *bluePtr=NULL, *alpha=NULL;
    redPtr = (uint8_t*)(_pBitmapBuffer + testY * _cBytesPerRow + testX * 4);
    greenPtr = (uint8_t*)(_pBitmapBuffer + testY * _cBytesPerRow + testX * 4 + 1);
    bluePtr = (uint8_t*)(_pBitmapBuffer + testY * _cBytesPerRow + testX * 4 + 2);
    alpha = (uint8_t*)(_pBitmapBuffer + testY*_cBytesPerRow + testX*4 +3);
	UIColor *color = [UIColor colorWithRed:*redPtr/255.0
                                     green:*greenPtr/255.0
                                      blue:*bluePtr/255.0
                                     alpha:*alpha/255.0];
	return color;
}
- (CGPoint)getPickerPoint:(UIColor *)color
{
	uint8_t* redPtr, * greenPtr, *bluePtr, *alphaPtr;
	CGPoint pt = CGPointZero;
	for (int i = 0; i < _cHeight; i++) {
		for (int j = 0; j < _cWidth; j++) {
			alphaPtr = (uint8_t*)(_pBitmapBuffer + i * _cBytesPerRow + j * 4 + _alphsOffset);
			
			if (_alphsOffset == 0) {
				redPtr = (uint8_t*)(_pBitmapBuffer + i * _cBytesPerRow + j * 4 + 1);
				greenPtr = (uint8_t*)(_pBitmapBuffer + i * _cBytesPerRow + j * 4 + 2);
				bluePtr = (uint8_t*)(_pBitmapBuffer + i * _cBytesPerRow + j * 4 + 3);
			} else {
				redPtr = (uint8_t*)(_pBitmapBuffer + i * _cBytesPerRow + j * 4);
				greenPtr = (uint8_t*)(_pBitmapBuffer + i * _cBytesPerRow + j * 4 + 1);
				bluePtr = (uint8_t*)(_pBitmapBuffer + i * _cBytesPerRow + j * 4 + 2);
			}
			UIColor *color1 = [UIColor colorWithRed:((CGFloat)*redPtr) / 255.0
                                              green: ((CGFloat)*greenPtr) / 255.0
                                               blue:((CGFloat)*bluePtr) / 255.0
                                              alpha:((CGFloat)*alphaPtr) / 255.0];
			if (CGColorEqualToColor(color.CGColor, color1.CGColor)) {
				pt.x = j;
				pt.y = i;
				return pt;
			}
		}
	}
	return pt;
}
- (void)loadUIimgae:(UIImage *)image{
	_colorRef = CGImageRetain([image CGImage]);
	_cWidth = CGImageGetWidth(_colorRef);
	_cHeight = CGImageGetHeight(_colorRef);
	_cBytesPerRow = CGImageGetBytesPerRow(_colorRef);
	CGImageAlphaInfo bitmapInfo = CGImageGetAlphaInfo(_colorRef);
	if (bitmapInfo == kCGImageAlphaFirst || bitmapInfo == kCGImageAlphaPremultipliedFirst) {
		_alphsOffset = 0;
	} else if (bitmapInfo == kCGImageAlphaLast || bitmapInfo == kCGImageAlphaPremultipliedLast) {
		_alphsOffset = 3;
	}
    CGDataProviderRef dataProvider = CGImageGetDataProvider(_colorRef);
	_bitmapData = CGDataProviderCopyData(dataProvider);
	_pBitmapBuffer = (UInt8 *)CFDataGetBytePtr(_bitmapData);
}

@end
