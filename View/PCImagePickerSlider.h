//
//  PCImagePickerSlider.h
//  PDFCreator
//
//  Created by Jinyou Gu on 13-3-20.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PCImagePickerSlider;
@protocol PCImagePickerDelegate<NSObject>
- (void)chageColor:(PCImagePickerSlider *)slider Color:(UIColor *)color;
@end
@interface PCImagePickerSlider : UIView
@property(nonatomic, assign) id<PCImagePickerDelegate> delegate;
- (id)initWithColor:(UIImage *)image slider:(UIImage *)imageSlider;
- (void)pointInit:(UIColor *)color;
- (void)pointNull;
- (UIColor *)defaultColor;
@end
