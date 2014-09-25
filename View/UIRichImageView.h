//
//  UIRichImageView.h
//  TextKitDemo
//
//  Created by Jinyou Gu on 13-7-21.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchImageView.h"
@class UIRichImageView;
@protocol UIRichImageViewDelegate<NSObject>
- (void)remove:(UIRichImageView *)view;
- (void)refresh:(UIRichImageView *)view;
@end
@interface UIRichImageView : TouchImageView{
    UIBezierPath *_orginPath;
}
@property(nonatomic, assign)id<UIRichImageViewDelegate> delegate;
@property(nonatomic, retain)UIBezierPath *bezierPath;
- (id)initWithImage:(UIImage *)image BezierPath:(UIBezierPath *)path;
@end
