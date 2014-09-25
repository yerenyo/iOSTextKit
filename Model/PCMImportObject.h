//
//  PCMImportObject.h
//  PDFCreator
//
//  Created by Jinyou Gu on 13-1-14.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCMObject.h"
@interface PCMImportObject : NSObject<PCMObject>
@property(nonatomic, assign) CGRect rect;
@property(nonatomic, assign) CGAffineTransform transform;
@property(nonatomic, retain) UIColor *bgColor;
@property(nonatomic, retain) NSString *ref;
@property(nonatomic, retain) NSString *type;
@end
