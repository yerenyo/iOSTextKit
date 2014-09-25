//
//  UIImportView.h
//  TextKitDemo
//
//  Created by Jinyou Gu on 13-7-19.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UIImportView;
@protocol UIImportViewDelegate<NSObject>
- (void)import:(UIImportView *)view Image:(UIImage *)image BezierPath:(UIBezierPath *)bezierPath;
@end
@interface UIImportView : UIView{
    NSUInteger _type;
}
@property(nonatomic, assign) id<UIImportViewDelegate> delegate;
- (id)initWithType:(NSUInteger)type;//0,star 1,round 2, acr
@end
