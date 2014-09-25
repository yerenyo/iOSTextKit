//
//  PCImageColor.h
//  PDFCreator
//
//  Created by Jinyou Gu on 13-3-20.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PCImageColor : NSObject
- (id)initWithImage:(UIImage *)image;
- (UIColor *)getColor:(CGPoint)curPoint;//注意高清设备应该传入2倍坐标
- (CGPoint)getPickerPoint:(UIColor *)color;
@end
